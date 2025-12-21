from jose import jwt, JWTError
from datetime import datetime, timedelta
import os

SECRET_KEY = os.getenv("JWT_SECRET_KEY")
ALGORITHM = os.getenv("JWT_ALGORITHM")
EXPIRE_MINUTES = int(os.getenv("TOKEN_EXPIRE_MINUTES"))

def create_token(user_id: str):
    """Create a JWT token with user_id as subject."""
    payload = {
        "sub": str(user_id),
        "exp": datetime.utcnow() + timedelta(minutes=EXPIRE_MINUTES),
        "iat": datetime.utcnow()
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str):
    """Decode and validate a JWT, returning the payload if valid."""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload  # dict with sub, exp, iat, etc.
    except JWTError:
        return None

def get_user_id_from_token(token: str):
    """Extract user_id (sub) from a JWT if valid."""
    payload = decode_token(token)
    if payload:
        return payload.get("sub")
    return None