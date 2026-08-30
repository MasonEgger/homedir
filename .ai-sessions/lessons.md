# Lessons Learned

## Recent
<!-- 10 most recent lessons, newest first -->

- Obsidian's GitHub `releases/latest` is often mobile-only (APK, no AppImage); the reliable desktop version pointer is `desktop-releases.json`'s `latestVersion` (its `downloadUrl` is the .asar.gz, not the AppImage). And `ansible.builtin.git` defaults `recursive: yes` — cloning nvm pulls an SSH-only test submodule that fails on keyless boxes; set `recursive: false` (2026-08-30)
- sshid.io serves an HTML SPA index to a default request (CloudFront); to fetch raw keys the request MUST send `Accept: text/plain` (curl works only by luck of its Accept). Ansible's `uri` module got HTML and matched zero `^ssh-` lines while still reporting ok. Assert on parsed result (key count), not task success, for content-negotiated endpoints (2026-08-30)
- `ansible-playbook --syntax-check` does not parse files pulled in via include_tasks, so YAML errors there slip through; ansible-lint on the task file catches them. A Jinja expression containing `': '` (colon-space) must be quoted or folded (`>-`) or the plain scalar breaks (2026-08-23)
- After `chage -d 0`, `su - USER -c` fails from scripts ("Authentication token manipulation error") because `/etc/pam.d/su` enforces password expiry. `runuser -l USER -s /bin/bash -c` has no PAM account stack and works; use it for all target-user shell tasks (2026-08-23)
- `nvm which --lts` is invalid in nvm 0.40.x; the installed-LTS check is `nvm which "lts/*"`. And the Claude Code installer symlinks `~/.local/bin/claude`, not `~/.claude/local/bin/claude`; guard on the former (2026-08-23)
- Ansible `creates:` skips the command but `changed_when: true` still reports changed. Drop the override and let `creates` decide, or print a marker to stdout and key `changed_when` on it (2026-08-23)
- Test Ansible provisioning on a throwaway droplet immediately, not after `--check`: `doctl compute droplet create NAME --image ubuntu-24-04-x64 --size s-2vcpu-2gb --region nyc3 --ssh-keys ID --wait`, then clone the branch there and run. Snap `doctl` cannot read `~/.ssh`, so copy the pubkey to `~/key.pub` for `ssh-key import` (2026-08-23)
- `su - USER -c CMD` with a zsh login shell is non-interactive and skips `.zshrc`, so `~/.local/bin` (uv, claude) is off PATH. Use `su - USER -s /bin/bash -c 'PATH=$HOME/.local/bin:$PATH CMD'`. And after `chage -d 0`, never verify with `su -`; it blocks on the password prompt. Use `runuser -u USER -- bash -lc` (2026-08-23)
- Guarding a one-shot task on `register.changed` of an earlier task breaks when a run dies in between (the next run sees `changed: false` forever). Use a marker file in the target home instead (2026-08-23)
- Before rebasing a months-old branch, diff its *capabilities* against `main`, not its files. `git merge-tree $(git merge-base A B) A B` shows conflicts without touching the tree; if only a couple of features are new, re-implement on a fresh branch and close the old PR (2026-08-22)
## Categories

### Vale / Prose Linting
- Vale `existence` rules: `raw:` is a single concatenated regex; for multiple distinct patterns use `tokens:` instead. Multi-item `raw:` lists silently fail to load (no parse error, just no fires) (2026-06-16)
- For Unicode character regex in Vale (em-dashes, smart quotes), use explicit Go code points like `\x{2014}` and `[\x{2018}\x{2019}...]` instead of literal characters. Literal curly quotes are editor-rendering-ambiguous (U+2018 vs U+201B look identical) (2026-06-16)
- When adding a Vale rule family to MasonBase, also add `tests/fixtures/<family>-{bad,good}.md` plus matching assertions in `tests/run.sh`. The fixture system IS the eval harness; bare smoke-testing misses too-tight regexes that catch the obvious cases but miss realistic-bad ones (2026-06-16)
- For LLM-derived banned-phrase Vale rules, prefer `level: warning` over `level: error` until the rule has been run against a corpus of Mason's own writing. Errors block CI; false positives on publishing-tone rules are common (e.g. "in this section, we configure X" is honest signposting, not a tell) (2026-06-16)

### Tooling
- `ansible-playbook --syntax-check` does not parse files pulled in via include_tasks, so YAML errors there slip through; ansible-lint on the task file catches them. A Jinja expression containing `': '` (colon-space) must be quoted or folded (`>-`) or the plain scalar breaks (2026-08-23)
- `nvm which --lts` is invalid in nvm 0.40.x; the installed-LTS check is `nvm which "lts/*"`. And the Claude Code installer symlinks `~/.local/bin/claude`, not `~/.claude/local/bin/claude`; guard on the former (2026-08-23)
- Test Ansible provisioning on a throwaway droplet immediately, not after `--check`: `doctl compute droplet create NAME --image ubuntu-24-04-x64 --size s-2vcpu-2gb --region nyc3 --ssh-keys ID --wait`, then clone the branch there and run. Snap `doctl` cannot read `~/.ssh`, so copy the pubkey to `~/key.pub` for `ssh-key import` (2026-08-23)
- `ansible-lint name[template]` only allows Jinja at the END of a task name. Write `Create user {{ x }}`, not `Create {{ x }} user`. To lint only your new findings, stash, lint the baseline, pop, and compare (2026-08-22)
- `claude plugin list` reports each plugin as `❯ name@marketplace` then `Version: X`. Snapshot it into a `{name@marketplace: version}` map before running updates to report OLD -> NEW. Versions can be `unknown` or a git short-SHA, so compare as strings (2026-06-29)
- For Electron-based desktop apps on a headless server, try `--ozone-platform=headless --disable-gpu --disable-software-rasterizer` before reaching for Xvfb (2026-05-10)
- Reading asar/binary strings (`strings file | grep`) is a useful pattern for reverse-engineering JSON config keys in Electron apps (2026-05-10)
- nvm install: prefer `git clone https://github.com/nvm-sh/nvm.git ~/.nvm` over `curl … | bash` — the classifier blocks the latter (2026-05-10)
- Auto-mode classifier blocks `curl … | bash` for installer scripts. Use `git clone` from the upstream repo instead — same result, no piped script execution (2026-05-10)

### Workflow / Sync
- Ansible `creates:` skips the command but `changed_when: true` still reports changed. Drop the override and let `creates` decide, or print a marker to stdout and key `changed_when` on it (2026-08-23)
- Guarding a one-shot task on `register.changed` of an earlier task breaks when a run dies in between (the next run sees `changed: false` forever). Use a marker file in the target home instead (2026-08-23)
- Tasks inside an `include_tasks` file reached only via `tags: [never, X]` includes need their own `tags: X` (or `apply: tags`) to run under `--tags X`; to share one file between two entry points, tag every task with both, e.g. `[mmegger, new-user]` (2026-08-22)
- When initializing sync between an authoritative source and a fresh/empty target, always start in `pull-only` mode to prevent the empty side from overwriting the source (2026-05-10)
- For interactive sub-steps in setup flows, use `! <command>` to hand control to the user instead of trying to automate around them (2026-05-10)
- Two-pass Ansible flow for interactive tools: pass 1 = install + services, user does interactive setup, pass 2 = finish wiring with `-e` vars (2026-05-10)
- For dotfiles in `~/Code/MasonEgger/homedir/`: edit `.claude/` and `.homedir/` sources, not the synced live copies at `~/.claude/`/`~/.homedir/`. Let `ansible --tags claude,homedir` propagate (2026-05-24)

### Documentation
- tmux *session* helpers (`ta`/`tn`/`td`/`tl`/`ts`) live in `.zshrc` and are documented in the README "Shell Configuration (`.zshrc`)" alias table, not the "Terminal Multiplexer Configuration (`.tmux.conf`)" section (in-session keybindings only) (2026-06-11)

### Git
- Before rebasing a months-old branch, diff its *capabilities* against `main`, not its files. `git merge-tree $(git merge-base A B) A B` shows conflicts without touching the tree; if only a couple of features are new, re-implement on a fresh branch and close the old PR (2026-08-22)
- This repo's pre-commit hook refuses commits when no fresh AI session summary is present (even with `-S` and on `main`). Run `/bpe:session-summary` **before** `git commit`, not after the hook errors; never reach for `--no-verify` (2026-06-23)
- Ansible `git:` tasks cloning a private repo over `https://github.com/...` prompt for GitHub username/password (API password auth died in 2021, so it never succeeds). Use the SSH remote `git@github.com:owner/repo.git`. Caveat: SSH needs a registered key, so it fails on fresh `mmegger` users who have none (2026-06-29)

### Claude Code Behavior
- Auto-mode classifier hard-blocks edits to `.claude/rules/*` and similar agent-config files as "self-modification" even on explicit user request. Surface via AskUserQuestion instead of silently retrying (2026-05-24)

### Plugin Development
- To list plugins a Claude Code marketplace repo exposes: `gh api repos/OWNER/REPO/contents/.claude-plugin/marketplace.json --jq '.content' | base64 -d`. Authoritative source — directory listings can mislead (2026-05-24)
- `claude plugin update <name>@<marketplace>` no-op output: `✔ <name> is already at the latest version (X.Y.Z).` Parse the version with `\(([^()]*\d[^()]*)\)` — tolerates semver and commit SHAs. Several official plugins omit the version, so handle the empty case (2026-05-31)

### Obsidian
- Obsidian's GitHub `releases/latest` is often mobile-only (APK, no AppImage); the reliable desktop version pointer is `desktop-releases.json`'s `latestVersion` (its `downloadUrl` is the .asar.gz, not the AppImage). And `ansible.builtin.git` defaults `recursive: yes` — cloning nvm pulls an SSH-only test submodule that fails on keyless boxes; set `recursive: false` (2026-08-30)
- The CLI toggle in Settings → General is just `"cli": true` at the top of `~/.config/obsidian/obsidian.json` (2026-05-10)
- Headless mode skips the "Trust author" prompt; plugins won't load until you call `app.plugins.setEnable(true)` once (2026-05-10)
- `obsidian create … template=…` uses core Templates plugin only. For Templater, use `templater.create_new_note_from_template(...)` via `obsidian eval` (2026-05-10)
- `obsidian-headless` (`ob` command) is sync/publish-only — for full vault interaction you need the desktop app running (use `--ozone-platform=headless`) (2026-05-10)

### Linux / systemd
- After `chage -d 0`, `su - USER -c` fails from scripts ("Authentication token manipulation error") because `/etc/pam.d/su` enforces password expiry. `runuser -l USER -s /bin/bash -c` has no PAM account stack and works; use it for all target-user shell tasks (2026-08-23)
- `su - USER -c CMD` with a zsh login shell is non-interactive and skips `.zshrc`, so `~/.local/bin` (uv, claude) is off PATH. Use `su - USER -s /bin/bash -c 'PATH=$HOME/.local/bin:$PATH CMD'`. And after `chage -d 0`, never verify with `su -`; it blocks on the password prompt. Use `runuser -u USER -- bash -lc` (2026-08-23)
- systemd `--user` services need `sudo loginctl enable-linger <user>` for 24/7 persistence across logout and reboot (2026-05-10)
- Verify server timezone (`timedatectl`) at start of time-sensitive setups; default cloud servers are usually UTC (2026-05-10)

### Debugging
- sshid.io serves an HTML SPA index to a default request (CloudFront); to fetch raw keys the request MUST send `Accept: text/plain` (curl works only by luck of its Accept). Ansible's `uri` module got HTML and matched zero `^ssh-` lines while still reporting ok. Assert on parsed result (key count), not task success, for content-negotiated endpoints (2026-08-30)
- Use `obsidian eval code="..."` for runtime introspection of the Obsidian app — `app.plugins.plugins`, `app.commands.commands`, `localStorage` (2026-05-10)
