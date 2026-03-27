---
name: vault-routing
description: "Obsidian vault structure, routing rules, and conventions for Mason's Arcadia vault. Use when creating, updating, or organizing notes in the vault — especially when routing information from voice transcripts, Todoist tasks, or meeting notes to the correct locations."
---

# Vault Routing

This skill provides the domain knowledge for navigating and updating Mason's Obsidian vault. Commands in the productivity plugin use this skill to determine where information should be routed.

## Vault Structure

- **Journal/{year}/current/{MM-DD-YYYY}.md** — Daily notes, the primary entry point
- **Active/** — Currently active projects, work, relationships
  - `Active/Work/Temporal/Customers/` — Customer company tracking files
  - `Active/Community/PyTexas/` — PyTexas community work
- **Archive/** — Completed/abandoned projects (Community, Personal, Work subdirs)
- **Reference/** — Lookup material, people, places, resources
  - `Reference/People/Co-Workers/Temporal/` — Temporal colleagues
  - `Reference/People/Community/Python/` and `Community/PyTexas/` — Community contacts
  - `Reference/People/Customers/Temporal/` — Customer contact persons
  - `Reference/People/Friends/` — Friends
  - `Reference/People/Family/` — Family members
- **Inbox/** — Temporary capture for new items (should be processed regularly)
- **_Templates/** — Obsidian templates for consistent note creation

## Routing Rules

### People
- Temporal co-workers → `Reference/People/Co-Workers/Temporal/`
- Community/Python people → `Reference/People/Community/Python/` or `Community/PyTexas/`
- Customer contacts → `Reference/People/Customers/Temporal/`
- Friends → `Reference/People/Friends/`
- If unclear → `Reference/People/`

### Customer Work
- Customer companies → `Active/Work/Temporal/Customers/`
- Customer contacts → `Reference/People/Customers/Temporal/`
- Always create bidirectional links between company and contact files

### Ideas & Captures
- New ideas → `Inbox/` with enough context to be useful later
- These should be intentional captures, not empty shells

## Cross-Linking

- Always check if a file exists before creating a `[[cross-link]]`
- If no file exists but it's the kind of thing Mason tracks, create the link anyway
- Use existing file names exactly as they appear in the vault

## Dependencies

This skill works alongside:
- **todoist-cli** (marketplace skill) — for `todo` CLI usage patterns and flags
- **obsidian:obsidian-cli** (marketplace skill) — for Obsidian CLI operations
- **obsidian:obsidian-markdown** (marketplace skill) — for wikilink and frontmatter syntax
