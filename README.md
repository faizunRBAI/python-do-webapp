# python-do-webapp

A Python Django web application deployed to a DigitalOcean Droplet in the `nyc1` region, fronted by Nginx and served by Gunicorn.

## Architecture

```
Internet → DO Firewall → Nginx (port 80) → Gunicorn (127.0.0.1:8000) → Django App
```

Infrastructure is managed with **Terraform** (state on DO Spaces). Server configuration is automated with **Ansible**. CI/CD runs on **GitHub Actions**.

See `.udap/architecture.d2` for the full architecture diagram.

---

## Stack

| Layer        | Technology           |
|--------------|----------------------|
| Language     | Python 3.11          |
| Framework    | Django 5             |
| App server   | Gunicorn             |
| Proxy        | Nginx                |
| IaC          | Terraform            |
| Config Mgmt  | Ansible              |
| CI/CD        | GitHub Actions       |
| Cloud        | DigitalOcean (nyc1)  |
| Target       | Droplet (s-1vcpu-1gb)|

---

## Local Development

**Prerequisites:** Python 3.11+

```bash
# Clone the repo
git clone https://github.com/<your-org>/python-do-webapp.git
cd python-do-webapp

# Create and activate virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Edit .env and set DJANGO_SECRET_KEY

# Run migrations
python manage.py migrate

# Start development server
python manage.py runserver
```

The app will be available at [http://localhost:8000](http://localhost:8000).

---

## Deployment

Deployment is fully automated via GitHub Actions on every push to `main`.

### Pipeline stages

| Stage      | What it does                                         |
|------------|------------------------------------------------------|
| `lint`     | Runs `flake8` for code style checks                 |
| `test`     | Runs `python manage.py test`                        |
| `provision`| Terraform: creates Droplet, Firewall, Reserved IP   |
| `configure`| Ansible: installs Python, Gunicorn, Nginx, .env     |
| `verify`   | HTTP health check with retries against the public IP|

### Required secrets (set in the platform, not manually)

| Secret              | Description                              |
|---------------------|------------------------------------------|
| `DO_TOKEN`          | DigitalOcean API token (platform-set)    |
| `SSH_PRIVATE_KEY`   | Deploy SSH key (platform-set)            |
| `SSH_PUBLIC_KEY`    | Deploy SSH public key (platform-set)     |
| `SSH_USER`          | SSH login user — `root` for DO (platform)|
| `TF_STATE_BUCKET`   | Terraform state bucket name (platform)   |
| `PROJECT_NAME`      | Branch-scoped project name (platform)    |
| `SPACES_ACCESS_KEY` | DO Spaces key for TF state (platform)    |
| `SPACES_SECRET_KEY` | DO Spaces secret for TF state (platform) |
| `SPACES_ENDPOINT`   | DO Spaces endpoint URL (platform)        |
| `DJANGO_SECRET_KEY` | Django secret key (generated, stored)    |

---

## Operations

### Check app status on the server
```bash
# SSH to the droplet (IP shown after first deploy)
ssh root@<droplet-ip>
systemctl status gunicorn
systemctl status nginx
```

### View application logs
```bash
journalctl -u gunicorn -f
journalctl -u nginx -f
```

### Restart the app
```bash
systemctl restart gunicorn
```

### Destroy infrastructure
Use the **Destroy** action in the GitHub Actions UI (dispatches `.github/workflows/destroy.yml`).

---

## Configuration

All configuration is driven by environment variables written to `/opt/python_do_webapp/.env` on the server by Ansible.

| Variable            | Required | Description                      |
|---------------------|----------|----------------------------------|
| `DJANGO_SECRET_KEY` | Yes      | Django cryptographic secret key  |
| `DEBUG`             | No       | Set to `True` for dev mode only  |
| `ALLOWED_HOSTS`     | No       | Comma-separated allowed hostnames|
