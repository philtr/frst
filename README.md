# 🌲FRST

FRST is a minimal framework for managing docker-compose stacks per host or tag.
It’s designed for self-hosted setups with modular app definitions and
machine-specific stack files.

## 🔧 How It Works

Each app (like Home Assistant or Frigate) defines its own `docker-compose.yml`
inside its folder under `apps/`. A host-specific compose file (e.g.,
`docker-compose.grove.yml`) includes the relevant app services.

App volumes should live under `apps/APP_NAME/volumes`. For example, if a
container needs `/data`, mount it like this in the app’s compose file:

```yaml
volumes:
  - ./volumes/data:/data
```

## 🚀 Usage

Make the script executable:

```sh
chmod +x frst
```

### Start services

```sh
./frst start grove
```

### Stop services

```sh
./frst stop grove
```

### Default to hostname

If no stack name is provided, FRST uses the system’s hostname:

```sh
./frst start
./frst stop
```

This runs:

```sh
docker compose -f docker-compose.$(hostname).yml up -d
```

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
