# python-do-webapp — Agent Notes

## Status
- Phase: Generation complete, pre-validation

## Key Decisions
- Region: sfo3 (NYC3 unavailable per probe)
- Target: do-droplet (s-1vcpu-1gb, ubuntu-22-04-x64)
- Framework: Django + Gunicorn + Nginx (platform scaffold + extensions)
- DB: PostgreSQL local on the droplet (Tier 1 — no managed DB)
- SSH key: platform-managed via `data.digitalocean_ssh_key.main` (DO account-scoped key)
- settings.py: uses `os.environ.get('DATABASE_URL', 'sqlite:///db.sqlite3')` for safe CI fallback
- Tests: converted from pytest-style to Django TestCase for `manage.py test` pipeline compatibility

## Secrets Needed
- DB_PASSWORD — random alphanumeric 24 chars (to generate at set_pipeline_secret time)
- DJANGO_SECRET_KEY — random alphanumeric 50 chars (to generate at set_pipeline_secret time)

## Known Environment
- DigitalOcean connected, droplet quota = 3
- GitHub connected (github)
- Previous destroyed/failed python-do-webapp project — name is safe to reuse

## Pipeline
lint → test → provision → configure → verify
- provision: derives Spaces backend region dynamically from SPACES_ENDPOINT hostname
- configure: reads IP from terraform state (self-sufficient job), runs Ansible
- verify: curl with 12 retries × 15s delay
