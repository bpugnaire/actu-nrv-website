#!/usr/bin/env sh
set -eu

: "${NRV_ADMIN_NAME:?Set NRV_ADMIN_NAME for the local editor account}"
: "${NRV_ADMIN_EMAIL:?Set NRV_ADMIN_EMAIL for the local editor account}"
: "${NRV_ADMIN_PASSWORD:?Set NRV_ADMIN_PASSWORD for the local editor account}"

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ghost_origin=${NRV_GHOST_ORIGIN:-http://127.0.0.1:2368}
cookie_file=$(mktemp "${TMPDIR:-/tmp}/nrv-ghost-cookies.XXXXXX")
trap 'rm -f "$cookie_file"' EXIT
cd "$project_root"

setup_status=$(curl -fsS "$ghost_origin/ghost/api/admin/authentication/setup/" | jq -r '.setup[0].status')

if [ "$setup_status" = "false" ]; then
    setup_payload=$(jq -n \
        --arg name "$NRV_ADMIN_NAME" \
        --arg email "$NRV_ADMIN_EMAIL" \
        --arg password "$NRV_ADMIN_PASSWORD" \
        '{setup: [{name: $name, email: $email, password: $password, blogTitle: "Nice RendezVous"}]}')
    curl -fsS -o /dev/null \
        -c "$cookie_file" \
        -H "Origin: $ghost_origin" \
        -H 'Content-Type: application/json' \
        -X POST \
        --data "$setup_payload" \
        "$ghost_origin/ghost/api/admin/authentication/setup/"
fi

session_payload=$(jq -n \
    --arg username "$NRV_ADMIN_EMAIL" \
    --arg password "$NRV_ADMIN_PASSWORD" \
    '{username: $username, password: $password}')
curl -fsS -o /dev/null \
    -c "$cookie_file" \
    -H "Origin: $ghost_origin" \
    -H 'Content-Type: application/json' \
    -X POST \
    --data "$session_payload" \
    "$ghost_origin/ghost/api/admin/session/"

default_post_id=$(curl -fsS \
    -b "$cookie_file" \
    -H "Origin: $ghost_origin" \
    -H 'Accept-Version: v6.0' \
    "$ghost_origin/ghost/api/admin/posts/?filter=slug:coming-soon&limit=1" \
    | jq -r '.posts[0].id // empty')
if [ -n "$default_post_id" ]; then
    curl -fsS -o /dev/null \
        -b "$cookie_file" \
        -H "Origin: $ghost_origin" \
        -H 'Accept-Version: v6.0' \
        -X DELETE \
        "$ghost_origin/ghost/api/admin/posts/$default_post_id/"
fi

default_page_id=$(curl -fsS \
    -b "$cookie_file" \
    -H "Origin: $ghost_origin" \
    -H 'Accept-Version: v6.0' \
    "$ghost_origin/ghost/api/admin/pages/?filter=slug:about&limit=1" \
    | jq -r '.pages[0].id // empty')
if [ -n "$default_page_id" ]; then
    curl -fsS -o /dev/null \
        -b "$cookie_file" \
        -H "Origin: $ghost_origin" \
        -H 'Accept-Version: v6.0' \
        -X DELETE \
        "$ghost_origin/ghost/api/admin/pages/$default_page_id/"
fi

docker compose exec -T ghost mkdir -p /var/lib/ghost/content/images/2026/09
docker compose cp theme/assets/images/nice-editorial-cover.jpg ghost:/var/lib/ghost/content/images/2026/09/nice-editorial-cover.jpg
docker compose cp theme/assets/images/legacy-fraises.jpg ghost:/var/lib/ghost/content/images/2026/09/legacy-fraises.jpg

curl -fsS -o /dev/null \
    -b "$cookie_file" \
    -H "Origin: $ghost_origin" \
    -H 'Accept-Version: v6.0' \
    -X PUT \
    "$ghost_origin/ghost/api/admin/themes/nice-rendezvous/activate/"

demo_count=$(curl -fsS \
    -b "$cookie_file" \
    -H "Origin: $ghost_origin" \
    -H 'Accept-Version: v6.0' \
    "$ghost_origin/ghost/api/admin/posts/?filter=slug:nice-classic-festival-2026-esprit-yves-saint-laurent&limit=1" \
    | jq '.posts | length')

if [ "$demo_count" = "0" ]; then
    curl -fsS -o /dev/null \
        -b "$cookie_file" \
        -H "Origin: $ghost_origin" \
        -H 'Accept-Version: v6.0' \
        -X POST \
        -F "importfile=@$project_root/migration/fixtures/demo-content.json;type=application/json" \
        "$ghost_origin/ghost/api/admin/db/"
fi

settings_payload='{"settings":[{"key":"title","value":"Nice RendezVous"},{"key":"description","value":"Actualités, culture, histoire et art de vivre à Nice et sur la Côte d’Azur."},{"key":"locale","value":"fr"},{"key":"timezone","value":"Europe/Paris"},{"key":"accent_color","value":"#b20d18"}]}'
curl -fsS -o /dev/null \
    -b "$cookie_file" \
    -H "Origin: $ghost_origin" \
    -H 'Content-Type: application/json' \
    -H 'Accept-Version: v6.0' \
    -X PUT \
    --data "$settings_payload" \
    "$ghost_origin/ghost/api/admin/settings/"

printf 'Nice RendezVous is ready at %s\n' "$ghost_origin"
printf 'Ghost Admin is ready at %s/ghost/\n' "$ghost_origin"
