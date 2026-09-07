import {cp, mkdir, rm, writeFile} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDirectory, '..');
const outputRoot = path.join(projectRoot, 'preview-dist');
const sourceOrigin = process.env.NRV_PREVIEW_ORIGIN || 'http://127.0.0.1:2368';
const publicOrigin = process.env.NRV_PUBLIC_ORIGIN || sourceOrigin;

const routes = [
    '/',
    '/nice-classic-festival-2026-esprit-yves-saint-laurent/',
    '/dans-le-carnet-rentree-culturelle-nice-2026/',
    '/petits-farcis-cuisine-nicoise-partage/',
    '/palais-de-la-mediterranee-retrouve-promenade-des-anglais/',
    '/vieux-nice-promenade-matinale/',
    '/artistes-mediterranee-musee-nice/',
    '/tag/actualites/',
    '/tag/culture/',
    '/tag/gastronomie/',
    '/tag/patrimoine/',
    '/tag/tourisme/',
    '/decouvrir-nice/',
    '/histoire/',
    '/identite/',
    '/visites/',
    '/villes-villages/',
    '/a-propos/',
    '/contact/',
    '/politique-de-confidentialite/',
    '/mentions-legales/',
    '/author/redaction/'
];

await rm(outputRoot, {recursive: true, force: true});
await mkdir(outputRoot, {recursive: true});

for (const route of routes) {
    const response = await fetch(new URL(route, sourceOrigin));
    if (!response.ok) {
        throw new Error(`Could not export ${route}: HTTP ${response.status}`);
    }

    let html = await response.text();
    html = html.replaceAll(sourceOrigin, publicOrigin);
    html = html.replaceAll('http://localhost:2368', publicOrigin);
    html = html.replace(/[ \t]+$/gm, '').trimEnd() + '\n';

    const routeDirectory = route === '/'
        ? outputRoot
        : path.join(outputRoot, route.replace(/^\//, '').replace(/\/$/, ''));
    await mkdir(routeDirectory, {recursive: true});
    await writeFile(path.join(routeDirectory, 'index.html'), html);
}

await cp(path.join(projectRoot, 'theme', 'assets'), path.join(outputRoot, 'assets'), {recursive: true});

const contentImageDirectory = path.join(outputRoot, 'content', 'images', '2026', '09');
await mkdir(contentImageDirectory, {recursive: true});
await cp(
    path.join(projectRoot, 'theme', 'assets', 'images', 'nice-editorial-cover.jpg'),
    path.join(contentImageDirectory, 'nice-editorial-cover.jpg')
);
await cp(
    path.join(projectRoot, 'theme', 'assets', 'images', 'legacy-fraises.jpg'),
    path.join(contentImageDirectory, 'legacy-fraises.jpg')
);

console.log(`Exported ${routes.length} routes to ${outputRoot}`);
