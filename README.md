# Brandon's Portfolio (Flask)

A stylish, single‑route Flask app that serves a responsive IT portfolio page with modern HTML, CSS, and JavaScript.

## Quickstart

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python app.py
# Visit http://127.0.0.1:5000
```

## Project Layout

```
brandons_portfolio_flask/
├─ app.py
├─ requirements.txt
├─ templates/
│  ├─ base.html
│  └─ index.html
└─ static/
   ├─ style.css
   ├─ main.js
   └─ favicon.svg
```

## Deploy Notes

- For production, run with Gunicorn behind NGINX (or on AWS ECS with an ALB).
- Add real links for project repos + live demos.
- Replace the email in the footer with your real contact address.
- Consider CSP headers and caching if deploying publicly.
