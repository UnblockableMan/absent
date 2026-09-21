import express from "express";
import http from "node:http";
import cors from "cors";
import chalk from "chalk";
import { epoxyPath } from "@mercuryworkshop/epoxy-transport";
import { libcurlPath } from "@mercuryworkshop/libcurl-transport";
import { baremuxPath } from "@mercuryworkshop/bare-mux/node";
import { uvPath } from "@titaniumnetwork-dev/ultraviolet";
import { server as wisp, logging } from "@mercuryworkshop/wisp-js/server";
import fs from "node:fs";
import Git from "./srv/git.js";
import { execSync } from "child_process";
import router from "./srv/router.js";
import path from "node:path";

let git_url = "";
let commit = "";
let git = null;
try {
  git_url = execSync("git config --get remote.origin.url").toString();
  commit = execSync("git rev-parse HEAD").toString();
  git = new Git(git_url);
} catch (e) {
  console.log("git info unavailable — skipping commit check");
}

const server = http.createServer();
const app = express();
const packageInfo = JSON.parse(fs.readFileSync("package.json"));
const PORT = process.env.PORT || 8080;

logging.set_level(logging.ERROR);
wisp.options.dns_method = "resolve";
wisp.options.dns_servers = ["1.1.1.3", "1.0.0.3"];
wisp.options.dns_result_order = "ipv4first";
wisp.options.wisp_version = 2;
wisp.options.wisp_motd = "ABSENT wisp server";

try {
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(cors());
  app.use(express.static(path.join(process.cwd(), "public/static/")));
  app.use(express.static(process.cwd())); // ABSENT build at repo root (index.html, sw.js, games.json, assets/)
  app.use("/epoxy/", express.static(epoxyPath));
  app.use("/@/", express.static(uvPath));
  app.use("/libcurl/", express.static(libcurlPath));
  app.use("/baremux/", express.static(baremuxPath)); // proxy stuff
  app.use("/", router);

  server.on("request", (req, res) => {
    app(req, res);
  });

  server.on("upgrade", (req, socket, head) => {
    if (req.url.endsWith("/wisp/")) {
      wisp.routeRequest(req, socket, head);
    }
  });

  server.on("listening", async () => {
    const address = server.address();
    const theme = chalk.hex("#630aba");
    const _unusedGradientColors = {
      1: "#8b0ab8",
      2: "#630aba",
      3: "#665e72",
      4: "#1c1724"
    }; //credits to nebula for the gradient design idea on the title.
    const gitColor = chalk.hex("#00ff95");
    const host = chalk.hex("#0d52bd");

    const startupText = `
 █████╗ ██████╗ ███████╗███████╗███████╗███╗   ██╗████████╗
██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝████╗  ██║╚══██╔══╝
███████║██████╔╝███████╗███████╗█████╗  ██╔██╗ ██║   ██║
██╔══██║██╔══██╗╚════██║╚════██║██╔══╝  ██║╚██╗██║   ██║
██║  ██║██████╔╝███████║███████║███████╗██║ ╚████║   ██║
╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝
  t h e   d a g g e r   b r o w s e r   ·   v 4 . 0
`;

    console.log(chalk.hex("#60a5fa")(startupText));
    try {
      console.log(
        gitColor("Last Updated on: "),
        chalk.whiteBright(((git && (await git.fetchLastCommitDate())) || "unknown") + " "),
        gitColor("Commit:"),
        chalk.whiteBright((git && (await git.fetchLastCommitID())) || "unknown"),
        gitColor("Up to Date:"),
        chalk.whiteBright(
          git && commit === (await git.fetchLastCommitID()) ? "✅" : "❌",
        ),
      );
    } catch (e) {
      console.log(gitColor("Git check skipped (offline or no remote)"));
    }
    console.log(
      theme("Version: "),
      chalk.whiteBright("v" + packageInfo.version),
    );
    let dns = false;

    if (process.env.REPL_SLUG && process.env.REPL_OWNER) {
      var method = "Replit";
      var extLink = ` https://${process.env.REPL_SLUG}.${process.env.REPL_OWNER}.repl.co`;
    } else if (
      process.env.CODESPACE_NAME &&
      process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN
    ) {
      var method = "Github Codespaces";
      var extLink = ` https://${process.env.CODESPACE_NAME}-${PORT}.${process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`;
    } else if (
      process.env.HOSTNAME &&
      process.env.GITPOD_WORKSPACE_CLUSTER_HOST
    ) {
      var method = "Gitpod";
      var extLink = ` https://${PORT}-${process.env.HOSTNAME}.${process.env.GITPOD_WORKSPACE_CLUSTER_HOST}`;
    } else if (
      process.env.VERCEL &&
      process.env.VERCEL_PROJECT_PRODUCTION_URL
    ) {
      var method = "Vercel";
      var extLink = ` https://${VERCEL_PROJECT_PRODUCTION_URL}`;
    } else if (process.env.RENDER && process.env.RENDER_EXTERNAL_HOSTNAME) {
      var method = "Render";
      var extLink = ` https://${RENDER_EXTERNAL_HOSTNAME}`;
    } else if (process.env.KOYEB_APP_NAME && process.env.KOYEB_PUBLIC_DOMAIN) {
      var method = "Koyeb";
      var extLink = ` https://${KOYEB_PUBLIC_DOMAIN}`;
    } else {
      var method = "Custom (DNS Deploy?)";
      dns = true;
    }
    console.log(theme("🌐 Deployment Method: "), chalk.whiteBright(method));
    console.log(host("🔗 Deployment Entrypoints: "));
    console.log(
      `  ${chalk.bold(host("Local System IPv4:"))}            http://localhost:${PORT}`,
    );
    console.log(
      `  ${chalk.bold(host("Local System IPv6:"))}            http://${address.family === "IPv6" ? `[${address.address}]` : address.address}:${PORT}`,
    );

    if (dns !== true)
      console.log(`  ${chalk.bold(host(method + ":"))}           ${extLink}`);
  });

  server.listen({ port: PORT });

  process.on("SIGINT", shutdown);
  process.on("SIGTERM", shutdown);

  server.setMaxListeners(0);

  function shutdown() {
    console.log("SIGTERM signal received: closing HTTP server");
    server.close(() => {
      console.log("HTTP server closed");
      server.close();
      process.exit(1);
    });
  }
} catch (err) {
  console.log(chalk.redBright(`Error starting ABSENT: ${err}`));
}
