# Technical architecture

## Decision summary

Use Ghost 6 as the publishing application and CMS, MySQL 8 as its private
database, a custom Handlebars theme for the public site, and Mailgun only for
bulk delivery. Run the production services in containers on an OVHcloud VPS
behind Caddy with automatic HTTPS.

This is a modular monolith. It avoids a separately built frontend/API/CMS while
keeping the theme and migration code fully versioned and portable.

```text
Readers and editors
        |
     HTTPS
        |
      Caddy  ---- security headers / compression / rate limits
        |
      Ghost  ---- custom Nice RendezVous theme
       |  \
       |   +---- Mailgun API (bulk newsletter delivery)
       |
     MySQL 8 (private container network; no public port)
       |
encrypted backups ---- separate OVHcloud object storage / second location
```

## Why this fits

Ghost already supplies the high-risk, easy-to-underestimate parts of the
request: a comfortable editor, image handling, authors, drafts, scheduling,
desktop/mobile/email previews, subscribers, unsubscribes and newsletter sends.
The custom work can therefore concentrate on Nice RendezVous's design,
navigation and archive rather than authentication and CMS plumbing.

### Alternatives considered

| Option | Strength | Reason not selected for v1 |
| --- | --- | --- |
| Next.js + Payload | Maximum custom data modelling | Two application surfaces and substantially more code to own |
| Astro + Directus | Very fast public site and flexible CMS | Separate deployments, APIs, preview and newsletter integration |
| WordPress | Familiar and widely hosted | Plugin surface and maintenance/security burden tend to grow |
| Ghost + custom theme | Editor and newsletter in one small system | Less suited to deeply structured relational content, which this v1 does not require |

If the legacy inventory reveals a genuine relational directory (rather than
editorial pages), that feature should be isolated and reconsidered rather than
distorting the whole publishing stack.

## Content model

- **Post:** dated reporting, reviews, event roundups and news.
- **Page:** evergreen editorial material such as history, visits and legal pages.
- **Primary public tag:** the main reader-facing section.
- **Additional public tags:** topics, places and recurring series.
- **Internal tags:** layout or collection controls that editors should not expose
  as reader taxonomy.
- **Author:** one stable profile per legacy byline, including retired authors.

A curated “Découvrir Nice” page will expose the evergreen hierarchy in a calm,
visual way. Content remains in ordinary Ghost pages; internal tags and custom
routes create collections without encoding navigation structure into article
bodies.

## Runtime environments

### Local

- Ghost container in development mode and a disposable local database/data
  volume.
- Custom theme mounted from `theme/` for fast iteration.
- Seeded mock content only; production exports remain outside the repository.

### Staging

- Production-like Ghost/MySQL/Caddy on a protected hostname.
- Scrubbed or authorised copy of legacy content.
- Bulk sending disabled or restricted to an explicit test allowlist.
- Search engines blocked at both HTTP and metadata levels.

### Production on OVHcloud

- Ubuntu LTS VPS sized after the migration inventory; start with at least 2 GB
  memory for Ghost, MySQL, Caddy and backup overhead.
- Official, pinned container images with controlled minor upgrades.
- Persistent bind mounts or named volumes for database and uploaded content.
- DNS remains manageable independently of the server for fast rollback.

## Security controls

- Only ports 80/443 are public; SSH is key-only and restricted by firewall.
- MySQL has no host port and is reachable only on the private container network.
- Admin and database credentials are generated uniquely, stored outside Git and
  injected at runtime. `.env.example` contains names, never values.
- HTTPS is mandatory; add HSTS only after the domain and rollback path are proven.
- Caddy sets a conservative Content Security Policy and other browser security
  headers after compatibility testing with Ghost Admin and newsletter signup.
- Staff receive separate accounts. Old or shared accounts are not migrated as
  active credentials.
- Login and form endpoints are rate-limited; contact uploads are type/size
  checked, renamed and never executed.
- Host security updates, container image reviews and Ghost upgrades follow a
  small monthly maintenance window, with backup and staging verification first.
- Logs exclude request bodies, secrets and subscriber exports and are rotated.

## Privacy and mail

- Preserve consent source/status/timestamp where evidence exists; do not infer
  consent from the presence of an email address.
- Support unsubscribe, export and deletion requests and document a retention
  period for contact submissions.
- Configure SPF, DKIM and DMARC for the sending domain before real delivery.
- Use a least-privilege Mailgun key and monitor bounces, complaints and
  suppressions. The website server never acts as a bulk SMTP sender.

## Reliability and operations

- Nightly encrypted database dump plus uploaded-content backup to a different
  failure domain; keep several daily, weekly and monthly recovery points.
- Backup success is monitored, but a twice-yearly isolated restore is the real
  proof.
- Health check the public home page and admin endpoint; alert on sustained
  failure, certificate expiry and low disk space.
- Keep deployment, migration and rollback commands scripted and idempotent.
- Document recovery point and recovery time targets after measuring the archive.

## Testing strategy

- **Theme:** Ghost GScan validation, template/render tests and HTML checks.
- **Migration:** deterministic fixtures, count reconciliation, idempotency and
  reports for every rejected record.
- **Public site:** keyboard/manual accessibility, automated accessibility,
  responsive browser matrix, broken-link crawl, metadata and feed validation.
- **Editorial:** scenario tests performed by the actual editors.
- **Operations:** clean deployment, upgrade rehearsal, backup restore and DNS
  rollback.
