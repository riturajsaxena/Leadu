from fastapi import APIRouter, Depends, HTTPException
from app.database import conn
from app.schemas import CampaignCreate
from app.core.security import get_current_user_id

router = APIRouter(prefix="/campaigns", tags=["Campaigns"])

@router.post("/create")
def create_campaign(
    data: CampaignCreate,
    user_id: str = Depends(get_current_user_id)
):
    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute(
                    "INSERT INTO campaigns(user_id, name, message) VALUES(%s, %s, %s)",
                    (user_id, data.name, data.message)
                )
            connection.commit()
        return {"message": "Campaign created"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal DB error: {e}")

@router.get("/list")
def list_campaigns(user_id: str = Depends(get_current_user_id)):
    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute(
                    "SELECT id, name, message FROM campaigns WHERE user_id=%s",
                    (user_id,)
                )
                data = cur.fetchall()
        return {"campaigns": data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal DB error: {e}")