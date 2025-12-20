from fastapi import APIRouter, Header, HTTPException
from app.database import conn

router = APIRouter(prefix="/contacts", tags=["Contacts"])

@router.post("/add")
def add_contact(name: str, phone: str, user_id: str = Header(...)):
	cur = conn.cursor()
	cur.execute(
		"INSERT INTO contacts(user_id, name, phone) VALUES(%s, %s, %s)",
		(user_id, name, phone)
	)
	return {"status": "Contact added"}

@router.get("/list")
def list_contacts(user_id: str = Header(...)):
	cur = conn.cursor()
	cur.execute(
		"SELECT id, name, phone FROM contacts WHERE user_id=%s",
		(user_id,)
	)
	data = cur.fetchall()
	return {"contacts": data}