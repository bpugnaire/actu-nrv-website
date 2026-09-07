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

The repository and the implementation plan have been initialised. No production
data, credentials or legacy exports are stored here.

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

## Proposed repository shape

```text
docs/                 decisions, delivery plan and operating procedures
theme/                custom Ghost theme (next implementation phase)
migration/            repeatable Joomla/AcyMailing import tools
infrastructure/       local and OVHcloud deployment configuration
tests/                migration, accessibility and browser checks
```

## Before production data is handled

We need an authorised Joomla database dump, the site's `images/` directory,
the AcyMailing export, and confirmation that Serre Éditeur authorises the
migration. Those files will be processed outside Git and backed up before any
transformation.
