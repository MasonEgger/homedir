# Session Summary: Headless Obsidian on Ubuntu — manual setup → Ansible playbook

**Date**: 2026-05-10
**Duration**: ~2.5 hours
**Conversation Turns**: ~55
**Estimated Cost**: ~$8 (extensive Opus 4.7 usage with web research, eval probing, multiple deep-dive iterations)
**Model**: claude-opus-4-7 (1M context)

## Key Actions

**Phase 1 — Research and manual install of headless Obsidian on dev server**
- Researched the difference between Obsidian CLI (requires running app) and `obsidian-headless` (sync/publish only). Confirmed via Obsidian CEO kepano on HN that there's no first-party headless full-CLI.
- Identified that Electron's built-in `--ozone-platform=headless` flag avoids Xvfb entirely — pure first-party path.
- Installed Obsidian v1.12.7 AppImage to `~/.local/share/Obsidian/`, extracted bundled `obsidian-cli` to `~/.local/bin/obsidian`.
- Wrote `~/.config/systemd/user/obsidian.service` running the AppImage with `--ozone-platform=headless --disable-gpu --disable-software-rasterizer --no-sandbox`.
- Bypassed the GUI-only "Register CLI" toggle by reverse-engineering the JSON key from the AppImage's bundled JS strings — flipped `"cli": true` directly in `~/.config/obsidian/obsidian.json`.
- Installed nvm (via git clone) + Node 24 LTS + `obsidian-headless` (`ob` command) for Sync.
- Set up continuous sync as `ob-sync.service` systemd user unit.
- Recovered from a self-inflicted disaster: enabled bidirectional config sync while local `.obsidian/` was empty defaults, which pushed empties up and deleted user's real configs from cloud. User restored 3 affected files via Sync version history; the rest had never been on cloud (laptop had `Configs: none`).
- Re-enabled config sync in `pull-only` mode, pulled all community plugins (Templater, Dataview, etc.).
- Discovered that headless mode skips Obsidian's "Trust author" prompt, leaving plugins listed-but-not-loaded; fixed via `obsidian eval code="app.plugins.setEnable(true)"` (writes localStorage flag, persists across restarts).
- Determined that core "Templates" plugin is disabled (user uses Templater); the CLI's `obsidian create … template=…` returns "Templates plugin is not enabled" error. Workaround: invoke `templater.create_new_note_from_template(tplFile, folder, filename, false)` directly via `obsidian eval`.
- End-to-end verified: created daily note with full Templater rendering (date math, prev/next links, year-ago embed, dataview placeholders).
- Set timezone to America/Chicago, enabled `loginctl enable-linger` for boot persistence.

**Phase 2 — Ansible playbook**
- Reviewed existing `homedir/ansible/` structure (modular tasks, group_vars, conventions).
- Replaced the Ubuntu/Debian section of `tasks/obsidian.yml` (was `.deb`-based system install) with the user-level headless flow.
- Kept macOS Homebrew cask install unchanged.
- Created 4 Jinja2 templates: `obsidian-headless.service.j2`, `ob-sync.service.j2`, `ob-sync-wrapper.sh.j2`, `obsidian.json.j2`.
- Designed two-pass flow: pass 1 installs everything and starts the headless app; user runs interactive `ob login` + `ob sync-setup`; pass 2 (with `-e obsidian_vault_name=NAME`) registers the vault, restarts Obsidian, runs `setEnable(true)`, enables continuous sync.
- Used `--mode pull-only` as the documented default in the README (after the bidirectional-overwrite incident).
- Updated `ansible/README.md` with the Linux flow and the pull-only warning.
- Validated with `ansible-playbook --syntax-check` and `--check` mode.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "Look at obsidian.md/download and determine the easiest way to install obsidian CLI on my server (no GUI)" | Researched obsidian.md/cli, GitHub repos, forum threads. Distinguished `obsidian` CLI (needs running app) vs `obsidian-headless` (sync only). | Identified 3 options: A=`--ozone-platform=headless`, B=Xvfb, C=sync-only |
| "I need the full obsidian cli, but no third-party stuff. Ultrathink." | Deep-dived; found CEO's HN comment confirming CLI requires full app; confirmed `--ozone-platform=headless` is built-in Electron, not third-party | Recommended Path A |
| "What does my skill need? Is it using obsidian full?" | Read `obsidian:obsidian-cli` skill file, confirmed "Requires Obsidian to be open" | Confirmed full-CLI path needed |
| "From your perspective, do you get anything out of using the obsidian CLI vs just markdown?" | Honest assessment: 80% of vault ops can be file-based; 20% (Templater rendering, plugin APIs) genuinely need running app | Recommended file-based unless templates use scripts |
| "It has scripts that pull from other notes. Let's install the headless" | Started install. AppImage download + libfuse2t64 + systemd unit | Path A working in ~10 min |
| "How did you install? What is loginctl? Review my journal templates" | Read templates (`<% tp.date.now() %>` only — medium-low complexity); confirmed all skills installed; explained loginctl | Found two issues: case mismatch + missing `daily-notes.json` |
| Sync-config wrong-direction overwrite | Stopped services, walked user through version-history recovery | Recovered 3 overwritten files; switched to `pull-only` mode |
| "Can you pull plugins?" | Yes — re-enabled configs in pull-only mode after user enabled sync on laptop | All 6 community plugins downloaded successfully |
| Plugins listed but not loaded | Probed via `obsidian eval`, found `localStorage["enable-plugin-{appId}"]` was unset; fixed with `app.plugins.setEnable(true)` | Plugins loaded, persist across restarts |
| Templater rendered May 10 in CDT user's May 9 evening | Identified server was UTC; user changed timezone | Rendering corrected after restart |
| "Create an ansible playbook for what we did" | Wrote 4 templates + rewrote `tasks/obsidian.yml`; updated README | Playbook syntax-validated |

## Efficiency Insights

**What went well:**
- Caught the prompt-cache angle quickly when researching: Electron's `--ozone-platform=headless` flag was the right approach but I verified with multiple sources before committing.
- Reverse-engineered the `cli:true` JSON key by `strings | grep` on the AppImage's asar — saved a lot of trial-and-error.
- After the bidirectional-sync disaster, immediately stopped services and assessed damage rather than trying to "fix forward" — version-history recovery was the cleanest path.
- Used `obsidian eval code="..."` heavily to introspect plugin runtime state, which made the "plugins listed but not loaded" diagnosis fast.

**What could have been more efficient:**
- **The bidirectional-sync mistake was avoidable.** I should have set `--mode pull-only` from the start as a defensive default, given that the dev server had empty default configs that would have lost a comparison-by-newest with the cloud.
- Spent extra back-and-forth on the rsync/scp suggestion — should have offered "let me build configs server-side from scratch (option 4)" as the safer default rather than asking the user to push from laptop.
- Generated a test daily note on a wrong date (server UTC vs user CDT) before checking the timezone — a quick `date` check at the start of any time-sensitive operation would prevent this.

**Mid-session course corrections:**
- User pushed back on third-party `obsidianless` script — pivoted from "easiest" to "first-party only" requirement, which led to the better Electron `--ozone-platform=headless` solution.
- User pushed back on rsync from laptop — instead enabled config sync on laptop and pulled to dev with pull-only.

## Process Improvements

1. **Default to safe sync modes.** Whenever configuring a sync between an authoritative source and a fresh/empty target, start with one-way (`pull-only` or equivalent) until you've verified content matches. Bidirectional with merge can wipe data when the empty side "looks newer."
2. **Verify timezone early on time-sensitive setups.** A 10-second `date` + `timedatectl` check before generating any datestamped output saves debug time later.
3. **For interactive sub-steps (login, e2e password), explicitly hand control to the user with `! command` syntax.** Don't try to automate around them.
4. **Save IPC/runtime introspection patterns to memory.** The `obsidian eval` patterns and the `setEnable(true)` localStorage trick are reusable across sessions and were saved to memory for future Claude sessions.

## Observations

- The Obsidian CLI architecture (IPC client to running app) is genuinely hostile to headless server use. Mason ran into the limitation Obsidian's team explicitly says is "officially unsupported." The community has converged on Xvfb workarounds, but Electron's built-in `--ozone-platform=headless` is cleaner and avoids the X server stack entirely.
- The two-pass Ansible flow (install + manual interactive sync setup + finish) is a common pattern when wrapping interactive tools — it preserves human-in-the-loop for credentials while automating everything else.
- Reading binary asar strings to find JSON config keys is a useful pattern for any Electron app where you need to flip a setting that's normally exposed only through GUI.
- After the sync disaster, switching to `pull-only` made the dev server architecturally safer (it can never be a source of truth), which is the correct mental model for a headless replica anyway.
