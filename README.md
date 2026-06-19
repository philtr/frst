# 🌲FRST: Forest Ranger's Stack Toolkit

FRST is a minimal framework for managing docker-compose stacks per host or tag.
It’s designed for self-hosted setups with modular app definitions and
machine-specific stack files.

## 🔧 How It Works

Each app (like Home Assistant or Frigate) defines its own docker compose config
inside `apps/`. A host-specific compose file (e.g., `docker-compose.grove.yml`)
includes the relevant app services.

App volumes should live under `volumes/APP_NAME/`. For example, if a container
needs `/data`, mount it like this in the app’s compose file:

```yaml
volumes:
  - ../volumes/APP_NAME/data:/data
```

Because app files are loaded from `apps/`, bind mounts in those files should
use `../volumes/...`. Host-specific compose files at the repo root can use
paths relative to the repo root.

Prefer Compose exec/list form for container commands, especially when arguments
contain shell metacharacters like parentheses:

```yaml
command:
  - -vf
  - scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2
```

Use `sh -c` only when the command intentionally needs shell behavior such as
`&&`, pipes, redirects, or variable expansion.

## 🚀 Usage

Make the script executable:

```sh
chmod +x frst
```

### Start services

```sh
./frst start -s grove home-assistant frigate
```

### Stop services

```sh
./frst stop -s grove home-assistant frigate
```

### Restart services

```sh
./frst restart -s grove home-assistant frigate
```

### Update images

```sh
./frst pull -s grove home-assistant frigate
```

### Inspect stack files

```sh
./frst files -s grove
```

### Validate compose config

```sh
docker compose -f docker-compose.grove.yml config --quiet
docker compose -f docker-compose.boxelder.yml config --quiet
```

Run this after editing app or stack files. It catches YAML and Compose schema
issues without starting containers.

### Show service status

```sh
./frst status -s grove
```

### Show logs

```sh
./frst logs -s grove --tail 50 home-assistant
```

### Use system hostname as stack name

If no `-s`/`--stack` option is provided, FRST uses the system’s hostname:

```sh
./frst start
./frst stop
./frst restart
./frst pull
```

This runs:

```sh
docker compose -f docker-compose.$(hostname).yml up -d
```

Arguments after the command are passed to `docker compose` as service names.

If Docker is not accessible to your user, add your user to the Docker group:

```sh
sudo usermod -aG docker "$(id -un)"
newgrp docker
docker ps
```

Docker group access is root-equivalent, so only grant it to trusted users.

## 🔐 Secrets

Put local-only secrets in an untracked compose override:

```sh
cp docker-compose.local.example.yml docker-compose.local.yml
```

Copy only the service blocks you need from the example into that local
override, for example:

```yaml
services:
  wallabag:
    environment:
      MYSQL_ROOT_PASSWORD: your-real-password
```

`frst` will automatically include `docker-compose.local.yml` and
`docker-compose.$(hostname).local.yml` when present.

## 🧠 Philosophy

- One file per app
- One stack file per machine
- One command to start or stop everything
