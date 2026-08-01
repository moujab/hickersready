# Walk & Discover Group

Flutter app for the Walk & Discover hiking group: trails, upcoming hikes,
guides, announcements and push reminders. Ships as an Android app and as a web
app / PWA at [walkanddiscover.org](https://walkanddiscover.org).

## Layout

| Path | What it is |
|---|---|
| `lib/` | Flutter app (Android + web) |
| `backend/` | Spring Boot + MySQL API, deployed on Railway |
| `web/` | Web shell: PWA manifest, custom bootstrap, service worker |
| `tool/` | One-off scripts (icon generation, web deploy) |

## Running locally

```bash
# Backend — needs a local MySQL with the hikers_way schema
cd backend && ./mvnw spring-boot:run

# App — defaults to http://localhost:8080/api
flutter run
```

## Deploying the web app

```bash
tool/deploy_web.sh
```

Builds `build/web` and packs it as `build/walkanddiscover-web.zip`, then prints
the upload steps. The script exists because two things are easy to get wrong
and both look like hosting failures:

- **The API URL is compile-time.** `lib/data/api_client.dart` reads
  `API_BASE_URL` from `--dart-define`, defaulting to `http://localhost:8080/api`.
  A build without the flag loads fine and shows no data. Changing the Railway
  URL means rebuilding and re-uploading — it cannot be fixed on the server.
- **Uploads must replace, not merge.** Hosting is GoDaddy (`public_html`) with
  Cloudflare in front. A leftover `index.html` pins an `engineRevision` and
  loads CanvasKit from Google's CDN at that exact revision; against a newer
  `main.dart.js` it fails and renders a blank white page. Delete the old files,
  then purge the Cloudflare cache and verify in a private window — the Flutter
  service worker otherwise serves you the previous build.

Quick check that a deploy landed: the browser tab should read
**Walk & Discover Group**. `hikers_way` means the old build is still live.

## Backend configuration

Set on the Railway service (defaults in
`backend/src/main/resources/application.properties` are for local dev only):

| Variable | Purpose |
|---|---|
| `ALLOWED_ORIGINS` | CORS. Must include `https://walkanddiscover.org`, or the site loads with no data. |
| `MYSQLHOST` / `MYSQLPORT` / `MYSQLDATABASE` / `MYSQLUSER` / `MYSQLPASSWORD` | Database connection, injected by Railway's MySQL service. |
| `ADMIN_PIN` | PIN gating the admin screens. |
| `PORT` | Listen port, set by Railway. |
