# TeslaDash — Fullscreen Tesla Browser

TeslaDash is a self-hosted static web app that replicates the Tesla fullscreen "theater" redirect trick using YouTube's redirect endpoint. It's designed to be served as static files (nginx) and mounted with a configurable JSON file for links.

## What this provides
- Tesla-inspired dark UI, touch-friendly tiles
- YouTube redirect trick for Tesla theater mode
- Configurable links via `config/links.json` (hot-reloadable)
- Cookie-only state (theme, recent, favorites, stats)
- Admin UI to import/export configuration
- Docker + docker-compose for easy deployment

## Quickstart (local testing)

1. Build and run with docker-compose:

```bash
docker-compose up --build -d
```

2. Visit http://localhost:8080

To update the available links edit `./config/links.json` on the host (it's mounted into the container). The frontend polls for changes and will reload the list automatically.

## Files of interest
- `src/` — static site source (HTML, CSS, JS)
- `config/links.json` — default link configuration (mounted into container)
- `Dockerfile`, `docker-compose.yml` — deployment
- `nginx.conf` — nginx config with caching disabled for `config/links.json`

## Configuration
Edit `config/links.json` and follow the structure in the example. The client fetches `/config/links.json` and will update automatically.

Example structure:

```json
{
  "categories": [
    {
      "name": "Streaming",
      "services": [
        {"name":"Netflix","url":"https://www.netflix.com","icon":"https://.../netflix.png","description":"Movies & TV"}
      ]
    }
  ]
}
```

## Security & notes
- Cookies are used exclusively for storing preferences and stats. No localStorage/sessionStorage is used.
- For production, serve over HTTPS (TLS) and ensure nginx is behind your TLS termination.
- The admin UI runs client-side; saving exports a JSON file for you to place into the `config/` folder. Writing directly to the mounted file from the browser is not supported (static-only server).

## How the fullscreen trick works
Clicking any link in the UI navigates to `https://www.youtube.com/redirect?q=[TARGET_URL]` which in Tesla's browser triggers the theater/fullscreen prompt. The user will then click "Go to site" in Tesla's UI to open the target site fullscreen.

## Troubleshooting
- If links do not open fullscreen on Tesla, the Tesla browser or YouTube may have changed behavior — the redirect trick depends on the Tesla browser honoring YouTube's redirect.
- Ensure the service is publicly reachable by the Tesla (not a private 192.168.x.x address).

## Next steps / improvements
- Implement server-side admin that can write config file (requires a backend)
- Add HTTPS and auth for a public-facing instance

---
Built by TeslaDash generator.
