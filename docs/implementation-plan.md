# Implementation plan

## Outcome

Rebuild Nice RendezVous as a modern French-language publication that is pleasant
to read and unusually simple for its two primary editors to operate. The first
release preserves the existing editorial identity and archive while reducing
the operational surface to one publishing application, one database and one
mail-delivery integration.

## Scope of the first release

### Public experience

- A fast home page led by the latest and featured reporting—not an oversized
  promotional hero.
- Clear editorial sections: Actualités, Culture, Gastronomie, Patrimoine,
  Tourisme and Loisirs. The final taxonomy will be based on the legacy content
  inventory rather than copied blindly.
- A prominent “Découvrir Nice” entry to evergreen material: history, identity,
  visits, towns and villages, major events and traditions.
- Readable article pages with author, publication date, category, responsive
  images, captions, related articles and newsletter signup.
- Search, section archives, author pages and chronological archives.
- Responsive navigation designed for keyboard, touch and 200% text zoom.
- French metadata, canonical URLs, RSS, social metadata, sitemap and structured
  article data.
- A privacy-conscious newsletter signup and contact route. The contact form will
  reject unsafe file types, enforce size limits and apply rate limiting.

### Editorial experience

- Two named staff accounts with the least privilege each person needs.
- Ghost's visual editor for text, images, galleries, embeds and callouts.
- Desktop, mobile and email preview before publication.
- Draft, scheduled and published workflows; featured posts and reusable tags.
- A short French publishing guide and a hands-on rehearsal with both editors.
- A reversible theme deployment process: publication content is independent of
  visual releases.

### Newsletter

- Import only subscribers whose consent status is supported by the legacy data.
- Built-in subscriber list, segmentation, unsubscribe and suppression handling.
- A branded newsletter template and test-send checklist.
- Bulk delivery through Mailgun for the first release. Delivery keys are runtime
  secrets and never browser-visible. If avoiding Mailgun is a hard requirement,
  a later spike will compare listmonk plus a transactional provider; this adds a
  second application and more operational work.

## Delivery phases

### 0. Preserve and discover

- Take read-only snapshots of the Joomla database, web files and AcyMailing
  tables before changing the old site.
- Record Joomla/PHP/database versions, table prefix, extensions, aliases,
  redirects, scheduled tasks, analytics and current DNS/hosting.
- Count published/unpublished articles, pages, categories, users, images,
  attachments and subscribers.
- Export the current URL set from the sitemap, database and server logs.
- Interview the two editors while they publish one real article; write down the
  friction rather than assuming it.

Exit: encrypted, restorable source snapshots and a signed-off inventory.

### 1. Information architecture and visual system

- Consolidate the current deep menu into reader-friendly top-level sections.
- Make a mapping from every legacy category/menu item to a new section, tag,
  page or redirect.
- Produce responsive wireframes for home, section, article, evergreen hub,
  search and signup.
- Build the visual thesis: editorial black and white, a restrained Nice red,
  generous reading widths, strong photography and subtle references to local
  print culture. Reuse the existing logo only after obtaining the original
  asset and confirming its rights and legibility.
- Test the first prototype with the editors and at least two typical readers.

Exit: approved content map and one coherent design direction.

### 2. Platform foundation

- Create a reproducible local Ghost 6 environment with MySQL 8.
- Add a custom theme package, validation, formatting and automated checks.
- Add a staging environment isolated from production email delivery.
- Define runtime configuration, encrypted backup and restore procedures without
  committing secrets or personal data.

Exit: a clean checkout can start locally and deploy to staging from documented
steps.

### 3. Public theme

- Implement semantic templates and reusable components for every scoped route.
- Add responsive image sizes, lazy loading below the fold and stable dimensions.
- Implement accessible navigation, focus states, search and form feedback.
- Add empty, error and pagination states.
- Verify current Chrome, Safari, Firefox and Edge plus common mobile widths.

Exit: representative mock articles pass functional, responsive and accessibility
checks.

### 4. Editorial workflow and newsletter

- Configure roles, tags, publication settings, email authentication and sender
  domain records.
- Create a realistic article from draft through web/email preview to scheduled
  publication on staging.
- Configure consent copy, double opt-in where appropriate, unsubscribe and data
  export/deletion procedures.
- Run test sends across major mail clients before enabling a real audience.

Exit: both editors can publish and send a test newsletter without assistance.

### 5. Repeatable migration

- Implement the database-first migration described in
  [migration-plan.md](migration-plan.md).
- Perform at least two full dry runs into an empty staging database.
- Reconcile counts and generate machine-readable reports for missing images,
  broken internal links, unknown authors and unmapped categories.
- Spot-check old and new rendering across every content family and publication
  year.

Exit: the import is repeatable, measured and produces no unexplained losses.

### 6. Hardening and launch rehearsal

- Apply the security, backup, observability and update controls in the
  architecture document.
- Run accessibility, performance, SEO, link, restore and permission tests.
- Rehearse DNS cutover and rollback on staging using a copy of production data.
- Freeze legacy publishing briefly, capture the delta, migrate it, validate, then
  switch DNS. Keep the Joomla site read-only and private during the rollback
  window.

Exit: launch checklist signed off, tested rollback path and verified off-server
backup.

### 7. Care period

- Monitor errors, mail delivery, broken links and editor questions closely for
  two weeks.
- Fix migration exceptions through the script or mapping data, not manual edits
  that cannot be replayed.
- Hand over a one-page monthly checklist and a twice-yearly restore exercise.

Exit: routine publishing and one restore drill succeed without developer help.

## Quality gates

The release is ready only when:

- all imported content types have reconciled source/target counts;
- every old URL is either preserved or covered by a tested permanent redirect;
- no database, admin key, subscriber record or private export is present in the
  repository or public assets;
- a fresh device can navigate, search, read, subscribe and unsubscribe;
- the editors can draft, preview, schedule, correct and publish an article;
- a newsletter test reaches Gmail, Outlook and Apple Mail without broken layout;
- automated accessibility checks have no critical violations and manual keyboard
  checks pass;
- representative pages meet agreed performance budgets on a mid-range phone;
- an encrypted backup has been restored into an isolated environment.

## Indicative sequence

A focused first release is approximately 6–9 weeks after access to the source
database and assets; a part-time delivery is more realistically 9–12 weeks. The
largest uncertainty is not theme development but the quality and volume of the
legacy data. The inventory in phase 0 is therefore the only responsible basis
for a firmer date.

## Deliberately deferred

- Native mobile applications.
- Reader accounts, paid membership and comments.
- Advertising management and hotel booking integrations.
- Automated article generation or rewriting.
- Self-hosted analytics or ActivityPub unless a real editorial need emerges.

Deferral keeps the first release focused; it does not prevent these additions
later.
