# Leadu

python -m venv venv
venv\Scripts\activate
pip install -r backend\requirement.txt
 Run the Server
Use Uvicorn to start the server:
uvicorn app.main:app --reload
ttp://127.0.0.1:8000
vuvicorn backend.app.main:app --reload

Got it 👍 — to add the /db-check route into your main.py, you just need to import your conn function from app.database and then paste the route definition. Here’s the updated file:
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



✅ What This Does
- / → confirms the backend is running.
- /db-check → runs a simple SELECT 1; query to verify Supabase/Postgres connectivity.
- Returns {"db": "connected"} if successful.
- Returns {"db": "error", "detail": "...error message..."} if something fails.

Now restart your server:
uvicorn backend.app.main:app --reload


 http://127.0.0.1:8000/db-check in your browser or Swagger UI to confirm DB connectivity.

 {
  "email": "testuser@example.com",
  "password": "securepassword123"
}

