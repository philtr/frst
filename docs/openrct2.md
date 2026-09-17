# Thunder Mesa

The `openrct2` service hosts Thunder Mesa on TCP port 11753. Its complete
user-data directory is `volumes/openrct2/data/`; the immutable starting park is
`save/seed.park`, and live recovery saves are
`save/autosave/autosave_*.park`. On startup, the newest autosave is loaded, or
the seed is loaded when no autosave exists. Restarting the service does not
reset the park.

## Operations

```sh
./frst start openrct2
./frst stop openrct2
./frst restart openrct2
./frst status openrct2
./frst logs --tail 100 openrct2
./frst pull openrct2
./frst restart openrct2
```

Clients connect to `192.168.1.177:11753`. After updating the server image, clients
must use a network-compatible OpenRCT2 version. The server is not advertised on
the public OpenRCT2 list.

All joining players enter the restricted `Trusted Player` group. It grants
ordinary gameplay and building permissions plus cheats, but excludes kicking,
group management, raw tile editing, and scenario administration. No per-player
setup is required for this private family server.

Each client can open the cheats window with `Ctrl+Alt+C`. If preferred, enable
the cheats toolbar button in that client's Interface settings. This is only a
client UI preference; no server-side key or user assignment is needed.

OpenRCT2 0.5.5 does not expose a shutdown signal that first saves the park.
This deployment therefore relies on one-minute autosaves instead of a fragile
stdin or signal-interception workaround. An abrupt stop can lose roughly the
last minute of play.

## Intentional reset

Stop the service and archive the entire active autosave directory:

```sh
./frst stop openrct2
reset_backup="volumes/openrct2/data/save/archive/reset-$(date +%Y%m%d-%H%M%S)"
sudo mkdir -p "$reset_backup"
sudo mv volumes/openrct2/data/save/autosave "$reset_backup/"
sudo install -d -o 1001 -g 1001 -m 0755 volumes/openrct2/data/save/autosave
./frst start openrct2
```

With no active autosave, startup selects the immutable seed. The previous park
remains under `save/archive/`. The supplied seed is saved in a globally
paused state. After a reset, connect once and toggle pause off in the client;
`Trusted Player` has permission to do this. The next autosave records the
unpaused state, while `pause_server_if_no_clients` still pauses simulation only
when the server is empty.

## Restore an older autosave

Stop the service, archive the current autosaves as above, then copy only the
chosen park into a newly created active autosave directory:

```sh
./frst stop openrct2
restore_backup="volumes/openrct2/data/save/archive/before-restore-$(date +%Y%m%d-%H%M%S)"
sudo mkdir -p "$restore_backup"
sudo mv volumes/openrct2/data/save/autosave "$restore_backup/"
sudo install -d -o 1001 -g 1001 -m 0755 volumes/openrct2/data/save/autosave
sudo install -o 1001 -g 1001 -m 0644 /path/to/older-autosave.park \
  volumes/openrct2/data/save/autosave/autosave_restored.park
./frst start openrct2
```

Because it is the only active autosave, the restored park is selected.
