# app/main.py
from fastapi import FastAPI
from app.routes import users, contacts, campaigns, sends
from app.database import conn   # <-- import your DB connection

app = FastAPI(title="WhatsApp SaaS Platform")

# Routers
app.include_router(users.router)
app.include_router(contacts.router)
app.include_router(campaigns.router)
app.include_router(sends.router)

# Root health check
@app.get("/")
def root():
    return {"status": "WhatsApp SaaS Backend Running"}

# Database connectivity check
@app.get("/db-check")
def db_check():
    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute("SELECT 1;")
                return {"db": "connected"}
    except Exception as e:
        return {"db": "error", "detail": str(e)}