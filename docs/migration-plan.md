# Joomla and newsletter migration plan

## Principle

Prefer an authorised database-and-files migration. Crawling the public site is a
useful audit and fallback, but it cannot reliably preserve drafts, original
authors, metadata, menu intent, subscriber consent or missing media.

## Inputs to request

- Read-only SQL dump and the exact Joomla/database versions.
- Full web root or, at minimum, the original `images/` and attachment storage.
- Joomla table prefix and list of installed content/newsletter extensions.
- AcyMailing export including subscription state, list membership, consent
  evidence, bounce/suppression state and newsletter archive.
- Existing `.htaccess`, redirect component export, sitemap, robots file and DNS
  records.
- Analytics/search-console URL exports if available.
- Original logo files, fonts and proof of reuse rights.

All raw inputs are encrypted, access-controlled and excluded from Git.

## Repeatable pipeline

1. **Extract** from copied, read-only inputs. Never operate against the live
   production tables.
2. **Inventory** Joomla content, categories, menu items, users, aliases, media
   references and extension-specific fields. Emit counts and anomalies.
3. **Map** every source category/menu item to a Ghost post, page, author or tag.
   Keep this mapping as reviewed data in the repository.
4. **Transform** Joomla HTML conservatively into Ghost's supported HTML/Lexical
   representation. Remove obsolete module markup and scripts without rewriting
   the journalism.
5. **Migrate media** from original files, calculate checksums, normalise safe
   filenames, retain captions/alt text and rewrite internal URLs. Missing files
   are reported, never silently discarded.
6. **Import** through Ghost's documented JSON format or Admin API into an empty
   target. Preserve publication dates, bylines, slugs, excerpts and publish
   status where supported.
7. **Redirect** every changed legacy path with an explicit permanent mapping.
   Query-string and extension routes receive targeted rules rather than a broad
   catch-all.
8. **Reconcile** source/target counts and crawl the result for broken links,
   mixed content, missing images, duplicates and redirect chains.

Each run receives an immutable report with input checksums, tool version,
counts, warnings and failures. A rerun against an empty target must produce the
same result.

## Likely legacy sources

The exact table prefix is discovered rather than assumed. Standard Joomla data
is normally found in tables corresponding to `content`, `categories`, `users`,
`menu`, `assets`, `tags` and their mapping tables. AcyMailing data varies by
extension generation, so its schema must be inspected before writing extraction
queries.

The public site confirms there are also newsletter archives, multi-level
evergreen navigation, images inside long articles, contact attachments and at
least French, English and Italian material. These are separate migration test
families.

## Subscribers

Subscriber migration is privacy-critical:

- import only records with defensible active consent;
- preserve list membership, consent evidence and suppression status;
- never reactivate unsubscribed, bounced or complained addresses;
- deduplicate case-insensitively while retaining the strictest suppression;
- compare counts before import and send only to an internal allowlist on staging;
- do not put addresses in logs, fixtures, screenshots or repository files.

If the old data cannot establish consent, retain it as an encrypted compliance
archive and run a lawful re-permission campaign only after appropriate advice.

## URL strategy

The preferred order is:

1. keep a readable legacy slug exactly when it is safe and unique;
2. otherwise create a canonical new URL and an explicit 301 from every known old
   URL;
3. keep a report of collisions, non-ASCII edge cases and duplicate aliases;
4. never redirect missing articles to the home page—use a useful 404 unless a
   true successor exists.

Before cutover, test top landing pages, recent articles, old high-traffic pages,
newsletter archive links and a stratified sample from every publication year.

## Cutover and rollback

- Announce a brief publishing freeze and record the final source timestamp.
- Take final database/files snapshots and import only the delta since the last
  rehearsal.
- Run the reconciliation and smoke checks before lowering DNS TTL and switching.
- Keep the old service read-only and non-public during an agreed rollback window.
- Roll back DNS if content integrity, author access, signup or delivery checks
  fail; do not attempt risky repairs on the live target.

## Public-crawl fallback

If no database/files access is possible, crawl the sitemap and known category
archives slowly, store source URLs and checksums, download only authorised
media, and build a manual author/category map. This can rescue published pages
but must be labelled incomplete: it cannot prove subscriber consent or recover
drafts and original files.
