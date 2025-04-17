# 🌲FRST: Forest Ranger's Stack Toolkit

FRST is a minimal framework for managing docker-compose stacks per host or tag.
It’s designed for self-hosted setups with modular app definitions and
machine-specific stack files.

## 🔧 How It Works

Each app (like Home Assistant or Frigate) defines its own docker compose config 
inside `apps/`. A host-specific compose file (e.g., `docker-compose.grove.yml`)
includes the relevant app services.

App volumes should live under `volumes/APP_NAME/`. For example, if a
container needs `/data`, mount it like this in the app’s compose file:

```yaml
volumes:
  - ../volumes/APP_NAME/data:/data
```

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

### Use system hostname as stack name

If no `-s`/`--stack` option is provided, FRST uses the system’s hostname:

```sh
./frst start
./frst stop
./frst restart
```

This runs:

```sh
sudo docker compose -f docker-compose.$(hostname).yml up -d
```

Arguments after the command are passed to `docker compose` as service names.

## 🔐 Secrets

Copy the example env file and populate it with real values:

```sh
cp secrets.env.example secrets.env
```

Then reference it in your service definitions like so:

```yaml
env_file:
  - ../../secrets.env
```

## 🧠 Philosophy

- One file per app
- One stack file per machine
- One command to start or stop everything
