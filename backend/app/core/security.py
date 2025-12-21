from fastapi import Header, HTTPException, Depends
from app.auth import get_user_id_from_token

def get_current_user_id(authorization: str = Header(...)):
    """
    Extract the current user_id from a JWT in the Authorization header.
    Expected format: Authorization: Bearer <token>
    """
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid or missing token")

    token = authorization.replace("Bearer ", "").strip()
    user_id = get_user_id_from_token(token)

    if not user_id:
        raise HTTPException(status_code=401, detail="Token expired or invalid")

    return user_id