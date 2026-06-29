# Lessons Learned

## Recent
<!-- 10 most recent lessons, newest first -->

- Don't decide a plugin's update verdict from the `claude plugin update` message. Versioned plugins print `already at the latest version (X)`, but plugins the marketplace leaves `Version: unknown` (asana, frontend-design, playground, playwright, plugin-dev, skill-creator) print `refreshed from source` on EVERY run, which reads as a spurious update. Compare the installed version before vs. after instead (2026-06-29)
- To report a plugin's OLD -> NEW version on update, snapshot versions before syncing by parsing `claude plugin list`: each entry renders as `❯ name@marketplace` then a `Version: X` line. Values can be `unknown` or a git short-SHA, so compare as plain strings, not semver (2026-06-29)
- Ansible `git:` tasks cloning a private repo over an `https://github.com/...` URL prompt for GitHub username/password (and password auth on the API died in 2021, so it never works). Use the SSH remote `git@github.com:owner/repo.git` instead. Caveat: SSH needs a registered key, so it fails on fresh `mmegger`-style users who have none (2026-06-29)
- Universal Markdown formatting rules go in the always-on global `.claude/CLAUDE.md` (`## Markdown Writing`), not `writing-style.md`, which only auto-loads on prose file paths and would miss commit bodies and inline text. Mirrors the em-dash hard-rule tiering (CLAUDE.md = always-on hard rule, writing-style.md = detailed taxonomy) (2026-06-23)
- Keep a shared convention in BOTH the content-design skill and the homedir global rule. They are independently distributed artifacts, so DRY-across-them is not the goal; the skill must stay self-contained for anyone who installs the plugin without Mason's personal rules (2026-06-23)
- This repo's pre-commit hook refuses commits when no fresh AI session summary is present (even with `-S` and on `main`). Run `/bpe:session-summary` **before** `git commit`, not after the hook complains, and never reach for `--no-verify` to bypass it (2026-06-23)
- tmux *session* helpers (`ta`/`tn`/`td`/`tl`/`ts`) belong in `.zshrc` next to each other, and get documented in the README "Shell Configuration (`.zshrc`)" alias table — **not** the "Terminal Multiplexer Configuration (`.tmux.conf`)" section, which is only for in-session keybindings (2026-06-11)
- Auto-mode classifier hard-blocks edits to `.claude/rules/*` and similar agent-config files as "self-modification" even on explicit user request. Surface via AskUserQuestion instead of silently retrying (2026-05-24)
- To list plugins exposed by a Claude Code marketplace repo: `gh api repos/OWNER/REPO/contents/.claude-plugin/marketplace.json --jq '.content' | base64 -d`. Authoritative — directory listings can mislead when README/LICENSE are mixed with plugin dirs (2026-05-24)
## Categories

### Vale / Prose Linting
- Vale `existence` rules: `raw:` is a single concatenated regex; for multiple distinct patterns use `tokens:` instead. Multi-item `raw:` lists silently fail to load (no parse error, just no fires) (2026-06-16)
- For Unicode character regex in Vale (em-dashes, smart quotes), use explicit Go code points like `\x{2014}` and `[\x{2018}\x{2019}...]` instead of literal characters. Literal curly quotes are editor-rendering-ambiguous (U+2018 vs U+201B look identical) (2026-06-16)
- When adding a Vale rule family to MasonBase, also add `tests/fixtures/<family>-{bad,good}.md` plus matching assertions in `tests/run.sh`. The fixture system IS the eval harness; bare smoke-testing misses too-tight regexes that catch the obvious cases but miss realistic-bad ones (2026-06-16)
- For LLM-derived banned-phrase Vale rules, prefer `level: warning` over `level: error` until the rule has been run against a corpus of Mason's own writing. Errors block CI; false positives on publishing-tone rules are common (e.g. "in this section, we configure X" is honest signposting, not a tell) (2026-06-16)

### Tooling
- `claude plugin list` reports each plugin as `❯ name@marketplace` then `Version: X`. Snapshot it into a `{name@marketplace: version}` map before running updates to report OLD -> NEW. Versions can be `unknown` or a git short-SHA, so compare as strings (2026-06-29)
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
- This repo's pre-commit hook refuses commits when no fresh AI session summary is present (even with `-S` and on `main`). Run `/bpe:session-summary` **before** `git commit`, not after the hook errors; never reach for `--no-verify` (2026-06-23)
- Ansible `git:` tasks cloning a private repo over `https://github.com/...` prompt for GitHub username/password (API password auth died in 2021, so it never succeeds). Use the SSH remote `git@github.com:owner/repo.git`. Caveat: SSH needs a registered key, so it fails on fresh `mmegger` users who have none (2026-06-29)

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
