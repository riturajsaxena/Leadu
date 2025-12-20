from fastapi import APIRouter, Header
from app.database import conn

router = APIRouter(prefix="/campaigns", tags=["Campaigns"])

@router.post("/create")
def create_campaign(title: str, message: str, user_id: str = Header(...)):
	cur = conn.cursor()
	cur.execute(
		"INSERT INTO campaigns(user_id, title, message) VALUES(%s, %s, %s)",
		(user_id, title, message)
	)
	return {"status": "Campaign created"}

@router.get("/list")
def list_campaigns(user_id: str = Header(...)):
	cur = conn.cursor()
	cur.execute(
		"SELECT id, title, message FROM campaigns WHERE user_id=%s",
		(user_id,)
	)
	return {"campaigns": cur.fetchall()}