from fastapi import APIRouter, Depends, HTTPException
from datetime import date
from app.database import conn
from app.schemas import SendCreate
from app.core.security import get_current_user_id

router = APIRouter(prefix="/sends", tags=["Send Logs"])

DAILY_LIMIT = 50

@router.post("/log")
def log_send(
    data: SendCreate,
    user_id: str = Depends(get_current_user_id)
):
    today = date.today()
    try:
        with conn() as connection:
            with connection.cursor() as cur:
                # Count how many sends today for this user
                cur.execute(
                    "SELECT COUNT(*) FROM send_logs WHERE user_id=%s AND DATE(created_at)=%s",
                    (user_id, today)
                )
                count = cur.fetchone()[0]

                if count >= DAILY_LIMIT:
                    return {"message": "Limit exceeded"}

                # Insert new send log
                cur.execute(
                    "INSERT INTO send_logs(user_id, phone, campaign_id, status) VALUES(%s, %s, %s, %s)",
                    (user_id, data.phone, data.campaign_id, data.status)
                )
            connection.commit()

        return {"message": "Logged", "remaining": DAILY_LIMIT - count - 1}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal DB error: {e}")