# Repository Guide

This repo manages Docker Compose stacks through the `frst` shell wrapper.

## Structure

- App-level Compose fragments live in `apps/*.yml`.
- Host stack files live at the repo root as `docker-compose.<stack>.yml`.
- Runtime data and bind-mounted app state live under `volumes/` and are ignored.
- Local overrides live in `docker-compose.local.yml` or
  `docker-compose.<stack>.local.yml` and are ignored.

## Compose Conventions

- In `apps/*.yml`, bind mount repo volumes with `../volumes/APP_NAME/...`
  because Compose resolves relative paths from the included file's directory.
- In root stack files, paths are relative to the repo root.
- Keep one app per file unless services are tightly coupled.
- Prefer exec/list form for `command` so Compose does not parse shell-like
  strings. Use `sh -c` only when shell features are required.
- Put secrets and host-specific values in local override files, not tracked app
  files.

## Validation

Before finishing Compose edits, run:

```sh
docker compose -f docker-compose.boxelder.yml config --quiet
```

Use the relevant stack file for the change. This validates the fully included
Compose config without starting containers.

## Working Notes

- Do not edit generated app data under `volumes/` unless the task explicitly
  concerns that mounted application state.
- The worktree often contains local or in-progress changes. Preserve unrelated
  edits.
