<div align="center">

# † ABSENT

**A fast, fully-static web proxy that looks and feels like a real browser. No backend. No build step. Deploy it anywhere in one click.**

ABSENT runs 100% in your browser — [Scramjet](https://github.com/MercuryWorkshop/scramjet) + [Epoxy transport](https://github.com/MercuryWorkshop/epoxy-transport) over WISP — wrapped in an Opera GX / Arc-style browser shell with **200+ self-hosted games**, a study toolbox, **tab cloaking**, cursor packs, a theme engine, history & bookmarks, multi-tab browsing, a **panic key**, and automatic low-latency server switching baked in.

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

- **◈ Fully static** — Scramjet + bare-mux + Epoxy/WISP all loaded client-side. The host serves plain files; the proxy never touches your server.
- **🪟 Browser shell** — Opera GX / Arc-style UI: rounded tabs, utility bar and a **† tool-belt rail** (Home · Games · Toolbox · History · Saved · Cloak · Settings · Panic) always one click away.
- **🏠 New Tab = home menu** — the † dagger title, the tool belt below it, a live search bar and a footer that rotates your sayings.
- **🕵 Tab cloaking** — disguise the tab as Google / Classroom / Drive / Docs / New Tab, or set a custom title + favicon. **About:blank cloak** launches ABSENT inside a blank window (auto-launch on first click supported).
- **🖱 Cursor packs** — swap your cursor for a **dagger †**, cross, crosshair or dot — everywhere, including inside games. Plus a follow-mouse crosshair overlay with 12 styles for FPS aim.
- **🗂 Multi-tab browsing** — real proxy tabs with per-tab history and an inline New Tab page.
- **🚨 Panic key** — press your combo (e.g. `Ctrl+Shift+X`) and the whole tab is instantly *replaced* with your URL (e.g. Google Classroom). A red **PANIC NOW** button also lives on the belt.
- **🎮 200+ games, self-hosted** — full Cartel game catalog bundled in (`assets/html/main/` + featured fullscreen loaders), zero external game portals, with thumbnails and instant search.
- **🧰 Study toolbox** — the Toolbox menu bundles calculators (Desmos, GeoGebra, Wolfram, Symbolab), study helpers, one-click bookmarklets and utilities (Code Editor, Embedders, History Flooder, Azahar, Play.JS, Voxiles).
- **🕘 History & ★ Saved** — every page you visit is recorded locally; double-tap the ★ belt button to bookmark the current page.
- **🎨 Way more customization** — 4 theme palettes, custom accent color, 5 UI fonts, custom background image, live-synced into every tab.
- **🔗 Quick links** — editable shortcut tiles on the New Tab page (YouTube, GitHub, Discord, Twitter, Reddit, Instagram by default).
- **📡 WISP server manager** — ships with public servers, auto-pings all of them and switches to the lowest-latency one. Add your own `wss://…/wisp/` endpoint any time.
- **🛡 Built-in adblock** — the service worker drops requests to 25+ ad/tracker networks before they leave the page.

---

## 📂 Project Structure

```text
absent/
├── index.html      ← the entire app (browser shell + tabs + games + toolbox + cloak + cursors + panic)
├── games.json      ← game catalog (auto-generated)
├── assets/html/    ← 200+ self-hosted games
├── fullscreen/     ← featured fullscreen game loaders
├── assets/img/     ← game thumbnails
├── sw.js           ← Scramjet service worker + adblock + wisp autoswitch
├── bareworker.js   ← bare-mux shared worker (v2.1.7)
├── wisps.html      ← default WISP server list (self-hosted, no CDN dependency)
├── wrangler.toml   ← Cloudflare Workers static assets config
├── render.yaml     ← Render blueprint
├── netlify.toml    ← Netlify config
├── Dockerfile      ← nginx for Railway / Koyeb / Heroku / Fly
└── app.json        ← Heroku button
```

---

## 📡 WISP Servers

ABSENT connects to the internet through a **WISP server** (a WebSocket proxy endpoint). Public ones are bundled in `wisps.html`, and the service worker continuously pings them and hops to whichever is fastest.

To use **your own** server: open **Proxy Settings → Custom Server**, paste `wss://your-server.com/wisp/`, hit **+**. It's saved locally and included in the auto-switch pool. Only connect to servers you own or trust.

---

## 🧩 Credits

- [Scramjet](https://github.com/MercuryWorkshop/scramjet), [bare-mux](https://github.com/MercuryWorkshop/bare-mux), [Epoxy](https://github.com/MercuryWorkshop/epoxy-transport) — **Mercury Workshop**
- Game catalog & tools: **Cartel** by UnblockableMan
- UI inspiration: Opera GX, Arc & the DayDream X project
- ABSENT build: **UnblockableMan**

## ⚠️ Disclaimer

ABSENT is provided for **educational purposes only**. It is your responsibility to use it in accordance with the laws of your country and the policies of any network you connect from. The authors are **not** responsible for how you use this software.

## 📜 License

[MIT](LICENSE) © 2026 ABSENT contributors
