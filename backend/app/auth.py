from jose import jwt
from datetime import datetime, timedelta
import os

SECRET_KEY = os.getenv("JWT_SECRET_KEY")
ALGORITHM = os.getenv("JWT_ALGORITHM")
EXPIRE_MINUTES = int(os.getenv("TOKEN_EXPIRE_MINUTES"))

def create_token(user_id: str):
 expire = datetime.utcnow() + timedelta(minutes=EXPIRE_MINUTES)
 payload = {"sub": user_id, "exp": expire}
 return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

