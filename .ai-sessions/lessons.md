# Lessons Learned

## Recent
<!-- 10 most recent lessons, newest first -->

- tmux *session* helpers (`ta`/`tn`/`td`/`tl`/`ts`) belong in `.zshrc` next to each other, and get documented in the README "Shell Configuration (`.zshrc`)" alias table — **not** the "Terminal Multiplexer Configuration (`.tmux.conf`)" section, which is only for in-session keybindings (2026-06-11)
- This repo's pre-commit hook refuses commits when no fresh AI session summary is present (even with `-S` and on `main`). Run `/bpe:session-summary` **before** `git commit`, not after the hook complains — and never reach for `--no-verify` to bypass it (2026-05-31)
- `claude plugin update <name>@<marketplace>` emits `✔ <name> is already at the latest version (X.Y.Z).` on no-op. Parse with `re.compile(r"\(([^()]*\d[^()]*)\)")` to grab the version; tolerates semver and short commit SHAs alike. Several official plugins omit the version entirely — handle the empty case (2026-05-31)
- Auto-mode classifier hard-blocks edits to `.claude/rules/*` and similar agent-config files as "self-modification" even on explicit user request. Surface via AskUserQuestion instead of silently retrying (2026-05-24)
- To list plugins exposed by a Claude Code marketplace repo: `gh api repos/OWNER/REPO/contents/.claude-plugin/marketplace.json --jq '.content' | base64 -d`. Authoritative — directory listings can mislead when README/LICENSE are mixed with plugin dirs (2026-05-24)
- For dotfiles in this repo: edit sources at `~/Code/MasonEgger/homedir/.claude/` and `~/Code/MasonEgger/homedir/.homedir/`, not the synced live copies at `~/.claude/`/`~/.homedir/`. `ansible-playbook ansible/setup.yml --tags claude,homedir` propagates (2026-05-24)
- For Electron-based desktop apps on a headless server, try `--ozone-platform=headless --disable-gpu --disable-software-rasterizer` before reaching for Xvfb — it's a built-in Chromium platform that draws to memory, no X server needed (2026-05-10)
- When initializing sync between an authoritative source and a fresh/empty target, **always start in `pull-only` mode**. Bidirectional + merge can wipe data when the empty side "looks newer" via local timestamps (2026-05-10)
- Obsidian's "enable Command line interface" toggle is just `"cli": true` at the top of `~/.config/obsidian/obsidian.json`. Reverse-engineered by `strings AppImage/resources/obsidian.asar | grep -aoE '"cli"[^"]{0,80}'`. Pattern works for any Electron app with GUI-only settings (2026-05-10)
- Headless Obsidian skips the "Trust author and enable community plugins" prompt, so plugins are listed in `enabledPlugins` but `app.plugins.plugins` stays empty. Fix: `obsidian eval code="app.plugins.setEnable(true)"`. Persists across service restarts via `~/.config/obsidian/Local Storage/leveldb/` (2026-05-10)
## Categories

### Tooling
- For Electron-based desktop apps on a headless server, try `--ozone-platform=headless --disable-gpu --disable-software-rasterizer` before reaching for Xvfb (2026-05-10)
- Reading asar/binary strings (`strings file | grep`) is a useful pattern for reverse-engineering JSON config keys in Electron apps (2026-05-10)
- nvm install: prefer `git clone https://github.com/nvm-sh/nvm.git ~/.nvm` over `curl … | bash` — the classifier blocks the latter (2026-05-10)
- Auto-mode classifier blocks `curl … | bash` for installer scripts. Use `git clone` from the upstream repo instead — same result, no piped script execution (2026-05-10)

### Workflow / Sync
- When initializing sync between an authoritative source and a fresh/empty target, always start in `pull-only` mode to prevent the empty side from overwriting the source (2026-05-10)
- For interactive sub-steps in setup flows, use `! <command>` to hand control to the user instead of trying to automate around them (2026-05-10)
- Two-pass Ansible flow for interactive tools: pass 1 = install + services, user does interactive setup, pass 2 = finish wiring with `-e` vars (2026-05-10)
- For dotfiles in `~/Code/MasonEgger/homedir/`: edit `.claude/` and `.homedir/` sources, not the synced live copies at `~/.claude/`/`~/.homedir/`. Let `ansible --tags claude,homedir` propagate (2026-05-24)

### Documentation
- tmux *session* helpers (`ta`/`tn`/`td`/`tl`/`ts`) live in `.zshrc` and are documented in the README "Shell Configuration (`.zshrc`)" alias table, not the "Terminal Multiplexer Configuration (`.tmux.conf`)" section (in-session keybindings only) (2026-06-11)

### Git
- This repo's pre-commit hook refuses commits when no fresh AI session summary is present (even with `-S` and on `main`). Run `/bpe:session-summary` **before** `git commit`, not after the hook errors — never reach for `--no-verify` (2026-05-31)

### Claude Code Behavior
- Auto-mode classifier hard-blocks edits to `.claude/rules/*` and similar agent-config files as "self-modification" even on explicit user request. Surface via AskUserQuestion instead of silently retrying (2026-05-24)

### Plugin Development
- To list plugins a Claude Code marketplace repo exposes: `gh api repos/OWNER/REPO/contents/.claude-plugin/marketplace.json --jq '.content' | base64 -d`. Authoritative source — directory listings can mislead (2026-05-24)
- `claude plugin update <name>@<marketplace>` no-op output: `✔ <name> is already at the latest version (X.Y.Z).` Parse the version with `\(([^()]*\d[^()]*)\)` — tolerates semver and commit SHAs. Several official plugins omit the version, so handle the empty case (2026-05-31)

### Obsidian
- The CLI toggle in Settings → General is just `"cli": true` at the top of `~/.config/obsidian/obsidian.json` (2026-05-10)
- Headless mode skips the "Trust author" prompt; plugins won't load until you call `app.plugins.setEnable(true)` once (2026-05-10)
- `obsidian create … template=…` uses core Templates plugin only. For Templater, use `templater.create_new_note_from_template(...)` via `obsidian eval` (2026-05-10)
- `obsidian-headless` (`ob` command) is sync/publish-only — for full vault interaction you need the desktop app running (use `--ozone-platform=headless`) (2026-05-10)

### Linux / systemd
- systemd `--user` services need `sudo loginctl enable-linger <user>` for 24/7 persistence across logout and reboot (2026-05-10)
- Verify server timezone (`timedatectl`) at start of time-sensitive setups; default cloud servers are usually UTC (2026-05-10)

### Debugging
- Use `obsidian eval code="..."` for runtime introspection of the Obsidian app — `app.plugins.plugins`, `app.commands.commands`, `localStorage` (2026-05-10)
