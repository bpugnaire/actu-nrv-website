# Nice RendezVous — modernisation

This repository is the working home for the renewal of
[Nice RendezVous](https://www.nicerendezvous.com/): a fast, accessible and
easy-to-publish local newspaper for Nice and the Côte d'Azur.

The project is deliberately designed around the people who publish it. The
public site will have a custom responsive design, while editorial work,
previews, scheduling, subscribers and newsletters will be handled by Ghost.
This keeps the system small enough to maintain on OVHcloud without building a
second CMS from scratch.

## Current status

The first working product is implemented: a custom Ghost 6 theme, responsive
public routes, realistic French demonstration content, a reproducible local
environment and an OVHcloud production container bundle. No production data,
credentials or private legacy exports are stored here.

Start here:

- [Implementation plan](docs/implementation-plan.md)
- [Architecture](docs/architecture.md)
- [Legacy migration plan](docs/migration-plan.md)
- [Platform decision](docs/decisions/0001-use-ghost.md)

## Product principles

1. Publishing an article must feel easier than it does today.
2. Existing URLs, articles, images, authors and subscriber consent are data to
   preserve—not content to copy by hand.
3. Readers reach recent reporting immediately and can still explore the deep
   archive about Nice's history, identity, places and traditions.
4. The production database and secrets are never public or committed to Git.
5. The smallest maintainable system wins over a custom technology showcase.

## Repository shape

```text
docs/                 decisions, delivery plan and operating procedures
theme/                custom Ghost theme
migration/            demo fixture and future Joomla/AcyMailing importer
infrastructure/       OVHcloud deployment configuration
scripts/              reproducible setup, export and packaging tools
out/                  generated private review edition
```

## Run locally

Start Ghost and MySQL:

```sh
docker compose up -d
```

For a fresh database, create and seed a local editor account without storing its
password in the repository:

```sh
NRV_ADMIN_NAME="Rédaction NRV" \
NRV_ADMIN_EMAIL="you@example.com" \
NRV_ADMIN_PASSWORD="choose-a-long-local-password" \
./scripts/bootstrap-demo.sh
```

Open the publication at `http://localhost:2368` and the editor at
`http://localhost:2368/ghost/`.

Package the installable theme with `./scripts/package-theme.sh`. The resulting
ZIP is written to the ignored `dist/` directory.

## Before production data is handled

We need an authorised Joomla database dump, the site's `images/` directory,
the AcyMailing export, and confirmation that Serre Éditeur authorises the
migration. Those files will be processed outside Git and backed up before any
transformation.
