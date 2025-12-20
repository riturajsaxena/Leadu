from fastapi import APIRouter, Header
from datetime import date
from app.database import conn

router = APIRouter(prefix="/sends", tags=["Send Logs"])

DAILY_LIMIT = 50

@router.post("/log")
def log_send(phone: str, user_id: str = Header(...)):
	today = date.today()
	cur = conn.cursor()

	cur.execute(
		"SELECT COUNT(*) FROM send_logs WHERE user_id=%s AND sent_date=%s",
		(user_id, today)
	)
	count = cur.fetchone()[0]

	if count >= DAILY_LIMIT:
		return {"status": "Limit exceeded"}

	cur.execute(
		"INSERT INTO send_logs(user_id, phone, sent_date) VALUES(%s, %s, %s)",
		(user_id, phone, today)
	)

	return {"status": "Logged", "remaining": DAILY_LIMIT - count - 1}