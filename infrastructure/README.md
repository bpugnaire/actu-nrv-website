# OVHcloud deployment

The production bundle runs Ghost, MySQL and Caddy on one Linux VPS. Only Caddy
publishes ports; the database stays on an internal container network.

## Server prerequisites

- Supported Ubuntu LTS VPS with Docker Engine and the Compose plugin.
- DNS `A`/`AAAA` records for the publication domain pointing to the VPS.
- Firewall allowing SSH from trusted addresses plus public TCP 80/443 and UDP
  443. Do not expose ports 2368 or 3306.
- A separate backup destination and monitoring contact.

## First deployment

1. Copy the repository to a non-root deployment account.
2. Create `infrastructure/secrets/db_password` and
   `infrastructure/secrets/db_root_password` using different random values of at
   least 32 characters. Restrict both files to the deployment account.
3. Export `SITE_DOMAIN`, `MAIL_FROM` and a unique `RELEASE_TAG` in the deployment
   environment.
4. From `infrastructure/`, validate the resolved Compose configuration before
   starting it.
5. Start the services and wait for the Ghost health check and TLS certificate.
6. Activate `nice-rendezvous` in Ghost Admin and perform the migration only on
   the staging hostname first.

The Mailgun bulk-newsletter key is configured through Ghost Admin after SPF,
DKIM and DMARC are verified. It is never added to this repository.

## Updates

Build and test a new release on staging, take an off-server backup, then deploy
with a new immutable `RELEASE_TAG`. Ghost database migrations run when the new
container starts. Upgrade one Ghost major version at a time.

## Backup minimum

Nightly backup both the MySQL database and the full Ghost content volume. Encrypt
before sending to a separate OVHcloud Object Storage project or another provider.
Alert on failures and prove the backup with an isolated restore twice a year.

## Rollback

Keep the previous application image and pre-deployment database/content backup.
Application-only rollbacks may use the previous image. Never run an older Ghost
version against a database already migrated by a newer incompatible release;
restore the matching database and content snapshot together.
