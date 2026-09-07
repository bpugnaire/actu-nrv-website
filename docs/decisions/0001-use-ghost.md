# ADR 0001: Use Ghost as the publishing platform

- Status: accepted for the first implementation spike
- Date: 2026-09-07

## Context

Nice RendezVous needs a modern public experience, a comfortable editor for two
non-technical journalists, previews, scheduling, images, subscribers and bulk
newsletters. It should be open source, light to maintain, secure and deployable
on OVHcloud. A large Joomla archive must be migrated without losing URLs or
bylines.

## Decision

Use self-hosted Ghost 6 with MySQL 8 and a custom Handlebars theme. Use Ghost's
member/newsletter workflow and Mailgun for bulk delivery. Deploy on an OVHcloud
Linux VPS using the official container approach with Caddy as the HTTPS reverse
proxy.

## Consequences

### Positive

- One writer-focused product covers CMS, staff accounts, previews, scheduling,
  subscriber management and newsletters.
- Public rendering is server-side HTML with little client JavaScript.
- Theme code and migration tools remain portable and version-controlled.
- Content survives theme replacement, reducing editorial risk.

### Costs and constraints

- Production requires MySQL 8 and normal server/container maintenance.
- Self-hosted Ghost currently supports Mailgun for bulk newsletters; this is a
  vendor dependency even though the publishing stack is open source.
- Deep relational directories are not Ghost's strength. The legacy inventory
  must confirm that the evergreen content is editorial pages, not an application
  database.
- Joomla needs a custom, tested migration rather than a one-click importer.

## Validation before irreversible commitment

The implementation spike must demonstrate:

1. one representative long legacy article with multiple inline images;
2. the proposed multi-level evergreen navigation;
3. a draft-to-mobile/email-preview workflow used by an editor;
4. deterministic preservation or redirect of its legacy URL;
5. an authorised subscriber fixture imported without losing suppression state.

If any of these fails materially, revisit a separate CMS/frontend architecture
before production migration.
