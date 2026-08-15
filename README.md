# python-do-webapp

A Python/Django web application deployed on DigitalOcean (sfo3) via a Droplet, fronted by Nginx, with a local PostgreSQL database.

## Architecture

```
Internet → Nginx (:80) → Gunicorn (:8000) → Django → PostgreSQL (local)
```

See `.udap/architecture.d2` for the full architecture diagram.

## Stack

| Layer       | Technology              |
|-------------|-------------------------|
| Language    | Python 3.11             |
| Framework   | Django 5.x              |
| App server  | Gunicorn                |
| Proxy       | Nginx                   |
| Database    | PostgreSQL 16 (local)   |
| IaC         | Terraform               |
| Config Mgmt | Ansible                 |
| CI/CD       | GitHub Actions          |
| Cloud       | DigitalOcean (sfo3)     |

## Local Development

```bash
# Create virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with your local values

# Run migrations
python manage.py migrate

# Start development server
python manage.py runserver
```

The app will be available at `http://localhost:8000`.

## Running Tests

```bash
python manage.py test --verbosity=2
```

## Configuration

All configuration is provided via environment variables (see `.env.example`):

| Variable       | Description                         | Secret |
|----------------|-------------------------------------|--------|
| `SECRET_KEY`   | Django secret key                   | Yes    |
| `DATABASE_URL` | PostgreSQL connection URL            | Yes    |
| `DEBUG`        | Enable debug mode (`True`/`False`)  | No     |
| `ALLOWED_HOSTS`| Comma-separated allowed host list   | No     |
| `APP_ENV`      | Environment name (production, etc.) | No     |

## Deployment

The CI/CD pipeline in `.github/workflows/deploy.yml` handles deployment automatically on push to `main`:

1. **lint** — flake8 code quality check
2. **test** — Django test suite
3. **provision** — Terraform provisions the DigitalOcean Droplet + Firewall
4. **configure** — Ansible installs PostgreSQL, Nginx, Gunicorn, deploys the app
5. **verify** — HTTP health check against the live Droplet IP

## Operations

**View application logs:**
```bash
# App logs (Gunicorn)
journalctl -u gunicorn -f

# Nginx access logs
tail -f /var/log/nginx/access.log
tail -f /var/log/gunicorn/access.log
```

**Restart the application:**
```bash
systemctl restart gunicorn
systemctl reload nginx
```

**Run migrations manually:**
```bash
cd /opt/python-do-webapp
source venv/bin/activate
python manage.py migrate
```

**Teardown:**
Trigger the Destroy workflow in GitHub Actions → Actions → Destroy.
