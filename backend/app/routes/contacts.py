from fastapi import APIRouter, Header, HTTPException
from app.database import conn
from app.schemas import ContactCreate
from app.auth import get_user_id_from_token

router = APIRouter(prefix="/contacts", tags=["Contacts"])

@router.post("/add")
def add_contact(contact: ContactCreate, authorization: str = Header(None)):
    """
    Add a new contact. Accepts Authorization: Bearer <token> header and extracts user_id from JWT.
    Expects JSON body: {"name": "...", "phone": "..."}
    """
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=401, detail="Missing or invalid Authorization header")

    token = authorization.split(" ", 1)[1].strip()
    user_id = get_user_id_from_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid token")

    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute(
                    "INSERT INTO contacts(user_id, name, phone) VALUES(%s, %s, %s)",
                    (user_id, contact.name, contact.phone)
                )
            connection.commit()
        return {"status": "Contact added"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal DB error: {e}")


@router.get("/list")
def list_contacts(authorization: str = Header(None)):
    """
    List all contacts for the authenticated user (Authorization: Bearer <token> required).
    Returns JSON array of objects: [{"id": ..., "name": "...", "phone": "..."}]
    """
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=401, detail="Missing or invalid Authorization header")

    token = authorization.split(" ", 1)[1].strip()
    user_id = get_user_id_from_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid token")

    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute(
                    "SELECT id, name, phone FROM contacts WHERE user_id=%s",
                    (user_id,)
                )
                data = cur.fetchall()
        # Convert DB rows into dicts for cleaner JSON
        contacts = [{"id": row[0], "name": row[1], "phone": row[2]} for row in data]
        return {"contacts": contacts}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal DB error: {e}")