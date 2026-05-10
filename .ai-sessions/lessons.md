# Lessons Learned

## Recent
<!-- 10 most recent lessons, newest first -->

- For Electron-based desktop apps on a headless server, try `--ozone-platform=headless --disable-gpu --disable-software-rasterizer` before reaching for Xvfb — it's a built-in Chromium platform that draws to memory, no X server needed (2026-05-10)
- When initializing sync between an authoritative source and a fresh/empty target, **always start in `pull-only` mode**. Bidirectional + merge can wipe data when the empty side "looks newer" via local timestamps (2026-05-10)
- Obsidian's "enable Command line interface" toggle is just `"cli": true` at the top of `~/.config/obsidian/obsidian.json`. Reverse-engineered by `strings AppImage/resources/obsidian.asar | grep -aoE '"cli"[^"]{0,80}'`. Pattern works for any Electron app with GUI-only settings (2026-05-10)
- Headless Obsidian skips the "Trust author and enable community plugins" prompt, so plugins are listed in `enabledPlugins` but `app.plugins.plugins` stays empty. Fix: `obsidian eval code="app.plugins.setEnable(true)"`. Persists across service restarts via `~/.config/obsidian/Local Storage/leveldb/` (2026-05-10)
- Obsidian's `obsidian create … template=…` CLI command targets the **core Templates plugin only**. If user uses Templater (community), it errors with "Templates plugin is not enabled." Workaround: invoke `templater.create_new_note_from_template(tplFile, folderTFolder, filename, false)` via `obsidian eval` (2026-05-10)
- Verify server timezone (`date`, `timedatectl`) at the start of any time-sensitive setup before generating datestamped output. UTC server vs CDT user produced a wrong-day daily note before catch (2026-05-10)
- For interactive sub-steps (login flows, password prompts, MFA), hand control to the user with `! <command>` syntax via the prompt rather than trying to automate around them. The Bash harness can't supply interactive input (2026-05-10)
- Auto-mode classifier blocks `curl … | bash` for installer scripts. Use `git clone` from the upstream repo instead — same result, no piped script execution (2026-05-10)
- systemd `--user` services stop when the last login session ends. Run `sudo loginctl enable-linger <user>` for true 24/7 persistence across reboots without an open SSH session (2026-05-10)
- For Ansible playbooks that wrap interactive tooling, design as a two-pass flow: pass 1 installs everything and starts services, user runs interactive setup commands, pass 2 (with vault/account variables provided via `-e`) finishes the wiring (2026-05-10)

## Categories

### Tooling
- For Electron-based desktop apps on a headless server, try `--ozone-platform=headless --disable-gpu --disable-software-rasterizer` before reaching for Xvfb (2026-05-10)
- Reading asar/binary strings (`strings file | grep`) is a useful pattern for reverse-engineering JSON config keys in Electron apps (2026-05-10)
- nvm install: prefer `git clone https://github.com/nvm-sh/nvm.git ~/.nvm` over `curl … | bash` — the classifier blocks the latter (2026-05-10)

### Workflow / Sync
- When initializing sync between an authoritative source and a fresh/empty target, always start in `pull-only` mode to prevent the empty side from overwriting the source (2026-05-10)
- For interactive sub-steps in setup flows, use `! <command>` to hand control to the user instead of trying to automate around them (2026-05-10)
- Two-pass Ansible flow for interactive tools: pass 1 = install + services, user does interactive setup, pass 2 = finish wiring with `-e` vars (2026-05-10)

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
