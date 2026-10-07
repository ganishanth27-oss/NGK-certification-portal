# NGK Portal

**Nehru Grand Kacheri**

A Flask web portal for managing events and participants and issuing participation certificates. The admin area supports event management, participant import/export, and per-event certificate templates.

## What the portal includes

- Admin sign-in with session authentication and CSRF protection for write operations.
- Dashboard summary, event management, participant search/edit/delete, and CSV/XLSX export.
- Participant import from XLSX, XLS, CSV, TXT, and text-based PDF, with a review step before saving.
- Duplicate prevention for participant records.
- Per-event certificate text and background image/PDF settings.
- Public certificate verification using the participant's mobile number and email address.
- Signed certificate preview/download links and PDF generation.
- Responsive admin and public pages.

The portal starts with **no event or participant records**. Add your own events and records from the admin area.

## Project files

```text
app.py                     Flask routes, database setup, imports and PDF generation
schema.sql                 Database schema reference
requirements.txt           Python dependencies
.env                       Local environment settings (excluded from source control)
Dockerfile                 Optional container build
static/app.css             Responsive styles
static/admin.js            Admin dashboard interactions
static/public.js           Public certificate lookup
templates/                  HTML pages
tests/test_app.py          API and PDF regression tests
data/                      Local database and uploaded templates
```

## Run locally

Requirements: Python 3.10 or later and pip.

```bash
python -m venv .venv
# Windows: .venv\\Scripts\\activate
source .venv/bin/activate
python -m pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000/` for certificate lookup or `http://127.0.0.1:5000/admin` for admin tools. The application creates its database and upload folder on first startup.

Configure `ADMIN_EMAIL`, `ADMIN_PASSWORD`, and a stable random `SECRET_KEY` in `.env` or the runtime environment before deployment. The app loads `.env` automatically when present; process environment variables take precedence. The admin sign-in screen does not display or prefill credentials.

## Environment settings

| Variable | Purpose |
|---|---|
| `SECRET_KEY` | Flask sessions and signed certificate links. Use a stable, random value. |
| `ADMIN_EMAIL` | Email address for the initial admin account. |
| `ADMIN_PASSWORD` | Password for the initial admin account. |
| `DATABASE_PATH` | SQLite database file location. |
| `DATA_DIR` | Base folder for uploads. |
| `HOST` | Bind address; use `0.0.0.0` in a container. |
| `PORT` | HTTP port. |
| `FLASK_DEBUG` | Enable Flask debug mode only for local development. |
| `COOKIE_SECURE` | Set to `1` when served over HTTPS. |

The portal uses **local SQLite only**. It has no Supabase client, network database, or external database dependency. Participant imports, edits, event changes, and certificate template settings are committed to `data/portal.sqlite3`; signing out only ends the login session and does not clear stored records. Relative database and upload paths are resolved from the project folder so starting the app from another working directory does not create a second database.

## Database and files

SQLite is initialized automatically from `schema.sql` via `init_db()` in `app.py`. Foreign keys and uniqueness constraints protect related records. Uploaded certificate backgrounds are stored under `data/uploads/`.

Keep backups of `data/portal.sqlite3` and `data/uploads/` when deploying or moving the portal. Do not commit `.env` or production database contents to a public repository.

## Tests

```bash
python -m pip install -r requirements.txt
python -m unittest discover -s tests -v
```

## Docker

```bash
docker build -t ngk-portal .
docker run --rm -p 5000:5000 \\
  -e SECRET_KEY='set-a-long-random-secret' \\
  -e ADMIN_EMAIL='admin@your-domain' \\
  -e ADMIN_PASSWORD='set-a-strong-password' \\
  -v "$PWD/data:/app/data" ngk-portal
```

## Operational notes

- PDF extraction supports selectable text; scanned PDFs need OCR before import.
- Public deployment should use HTTPS, rate limiting, backups, monitoring, upload scanning, and a production WSGI server such as Gunicorn.
- Certificate links expire after 10 minutes. Participants can verify again to obtain new links.
