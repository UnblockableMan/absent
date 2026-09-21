<div align="center">

# † ABSENT

**A fast web proxy that looks and feels like a real browser, built on a fully rebranded [DayDream X](https://github.com/NxroProxy/DayDreamX) base. Run it static — or with node for a built-in WISP server.**

ABSENT v4.0 runs 100% in your browser — [Scramjet](https://github.com/MercuryWorkshop/scramjet) + [Epoxy transport](https://github.com/MercuryWorkshop/epoxy-transport) over WISP — wrapped in an Opera GX / Arc-style browser shell with **390+ games**, a **password-locked study toolbox**, **tab cloaking**, cursor packs, a theme engine, history & bookmarks, multi-tab browsing, a **panic key**, and automatic low-latency server switching baked in.

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/UnblockableMan/absent)
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/UnblockableMan/absent)
[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2FUnblockableMan%2Fabsent&project-name=absent)
[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/UnblockableMan/absent)

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template?template=https://github.com/UnblockableMan/absent)
[![Deploy to Koyeb](https://www.koyeb.com/static/images/deploy/button.svg)](https://app.koyeb.com/deploy?type=git&repository=github.com/UnblockableMan/absent&branch=main&builder=dockerfile)
[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/UnblockableMan/absent)

</div>

---

## ⚡ One-Click Deploy

ABSENT is **Cloudflare-first** — but every button below deploys the exact same static site. Fork this repo first, then replace `UnblockableMan/absent` in the URLs with your own fork if you want deploys under your account.

| Platform | Type | Cost | Notes |
|---|---|---|---|
| **Cloudflare Workers** ⭐ | Static assets on the edge | Free tier | Recommended — fastest, `wrangler.toml` included |
| **Render** | Static site | Free tier | `render.yaml` blueprint included |
| **Vercel** | Static | Free tier | Zero config |
| **Netlify** | Static | Free tier | `netlify.toml` included |
| **Railway** | Docker (nginx) | Trial | `Dockerfile` included |
| **Koyeb** | Docker (nginx) | Free tier | `Dockerfile` included |
| **Heroku** | Container | Paid | `app.json` + `Dockerfile` |

<details>
<summary><b>☁️ Deploy to GitHub Pages</b> (no button, 30 seconds)</summary>

1. Push this repo to GitHub (or fork it).
2. **Settings → Pages → Build and deployment → Source: Deploy from a branch**.
3. Pick branch `main`, folder `/ (root)`, **Save**.
4. Done — `https://<you>.github.io/absent/` is live.

</details>

<details>
<summary><b>🐳 Run locally</b></summary>

```bash
git clone https://github.com/UnblockableMan/absent
cd absent
python3 -m http.server 8080     # or: npx serve .
# open http://localhost:8080
```

Any static file server works — there is genuinely nothing to build.

</details>

---

## ✨ Features

- **◈ Fully static — or one-command node** — Scramjet + bare-mux + Epoxy/WISP all loaded client-side. Serve plain files from any host, or `node index.js` for the rebranded DayDream X Express base with a **built-in WISP server** at `wss://your-host/wisp/`.
- **🪟 Browser shell** — Opera GX / Arc-style UI: rounded tabs, utility bar and a **† tool-belt rail** (Home · Games · Toolbox · History · Saved · Cloak · Settings · Panic) always one click away.
- **🏠 New Tab = home menu** — the † dagger title, the tool belt below it, a live search bar and a footer that rotates your sayings.
- **🕵 Tab cloaking** — disguise the tab as Google / Classroom / Drive / Docs / New Tab, or set a custom title + favicon. **About:blank cloak** launches ABSENT inside a blank window (auto-launch on first click supported).
- **🖱 Cursor packs** — swap your cursor for a **dagger †**, cross, crosshair or dot — everywhere, including inside games. Plus a follow-mouse crosshair overlay with 12 styles for FPS aim.
- **🗂 Multi-tab browsing** — real proxy tabs with per-tab history and an inline New Tab page.
- **🚨 Panic key** — press your combo (e.g. `Ctrl+Shift+X`) and the whole tab is instantly *replaced* with your URL (e.g. Google Classroom). A red **PANIC NOW** button also lives on the belt.
- **🔒 Password-locked toolbox** — the cheat folder asks for a password (default **4349**) every session. Change it in Settings → Panic → Toolbox Lock. Wrong password = shake + denied.
- **🧰 Study toolbox (in folders)** — the Toolbox bundles calculators (Desmos, GeoGebra, Wolfram, Symbolab), study helpers, one-click bookmarklets and utilities (Code Editor, Embedders, History Flooder, Azahar, Play.JS, Voxiles) inside collapsible folders — so it reads like school stuff, not cheats.
- **📈 390+ games, mostly self-hosted** — the full Cartel catalog bundled in (`assets/html/main/` + featured fullscreen loaders) plus the DayDream X catalog merged in (thumbs included), with instant search.
- **🕘 History & ★ Saved** — every page you visit is recorded locally; double-tap the ★ belt button to bookmark the current page.
- **🎨 Way more customization** — 4 theme palettes, custom accent color, 5 UI fonts, custom background image, live-synced into every tab. **Flat design** — zero gradients, clean solid surfaces.
- **🔗 Quick links** — editable shortcut tiles on the New Tab page (YouTube, GitHub, Discord, Twitter, Reddit, Instagram by default).
- **📡 WISP server manager** — ships with public servers, auto-pings all of them and switches to the lowest-latency one. Add your own `wss://…/wisp/` endpoint any time.
- **🛡 Built-in adblock** — the service worker drops requests to 25+ ad/tracker networks before they leave the page.

---

## 📂 Project Structure

```text
absent/
├── index.html      ← the entire app (browser shell + tabs + games + locked toolbox + cloak + cursors + panic)
├── games.json      ← game catalog — 396 games (Cartel + DayDream X merged)
├── index.js        ← rebranded DayDream X Express server (static + built-in wisp)
├── srv/            ← router + git helpers for the node server
├── public/static/  ← the rebranded DayDream X engines (Scramjet $/ · UV @/ · Eclipse ~/ · Sandstone &/)
├── assets/html/    ← self-hosted games
├── fullscreen/     ← featured fullscreen game loaders
├── assets/img/     ← game thumbnails (incl. assets/img/ddx/ for merged catalog)
├── sw.js           ← Scramjet service worker + adblock + wisp autoswitch
├── bareworker.js   ← bare-mux shared worker (v2.1.7)
├── wisps.html      ← default WISP server list (self-hosted, no CDN dependency)
├── wrangler.toml   ← Cloudflare Workers static assets config
├── render.yaml / netlify.toml / Dockerfile / app.json ← one-click deploys
```

---

## 🏃 Run with Node (built-in WISP)

```bash
git clone https://github.com/UnblockableMan/absent
cd absent
npm install
npm start          # → http://localhost:8080
```

The node server (a rebranded DayDream X base) serves the same UI **plus** a real WISP endpoint on the same origin — open Proxy Settings → Custom Server and add `wss://<your-host>/wisp/` for a self-hosted, unblocked transport.

---

## 📡 WISP Servers

ABSENT connects to the internet through a **WISP server** (a WebSocket proxy endpoint). Public ones are bundled in `wisps.html`, and the service worker continuously pings them and hops to whichever is fastest.

To use **your own** server: open **Proxy Settings → Custom Server**, paste `wss://your-server.com/wisp/`, hit **+**. It's saved locally and included in the auto-switch pool. Only connect to servers you own or trust.

---

## 🧩 Credits

- [Scramjet](https://github.com/MercuryWorkshop/scramjet), [bare-mux](https://github.com/MercuryWorkshop/bare-mux), [Epoxy](https://github.com/MercuryWorkshop/epoxy-transport) — **Mercury Workshop**
- **DayDream X** by NxroProxy / Amplify — the base ABSENT v4.0 is built on (cloned & fully rebranded, AGPL-3.0)
- Game catalog & tools: **Cartel** by UnblockableMan
- UI inspiration: Opera GX & Arc
- ABSENT build: **UnblockableMan**

## ⚠️ Disclaimer

ABSENT is provided for **educational purposes only**. It is your responsibility to use it in accordance with the laws of your country and the policies of any network you connect from. The authors are **not** responsible for how you use this software.

## 📜 License

[AGPL-3.0](LICENSE) — includes rebranded DayDream X code (AGPL-3.0). © 2026 ABSENT contributors
