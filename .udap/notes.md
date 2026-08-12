# python-do-webapp — Build Notes

## Project
- Cloud: DigitalOcean, region: nyc1, target: do-droplet
- Stack: Python 3.11 / Django / Gunicorn / Nginx
- VCS: GitHub

## Decisions
- Python 3.11 via deadsnakes PPA (not in Ubuntu 22.04 base apt)
- No become_user on venv/pip tasks — runs as root to /opt, avoids setfacl issues
- DJANGO_SECRET_KEY is the secret name (also accepts SECRET_KEY for compat)
- Reserved IP for stable droplet address
- playbook_dir | dirname used for correct copy src path resolution
- app_user (webapp) owns .env and runs gunicorn; root owns the rest of /opt/python_do_webapp

## Pipeline
- lint → test → provision → configure → verify
- provision: Terraform; configure: Ansible; verify: curl with 12 retries x 15s delay
- TF_VAR_do_token passed in env (do_token variable in variables.tf)

## Status
- validate_project: PASS
- test_project: pending
- repo: not yet created
- deploy: not yet triggered
