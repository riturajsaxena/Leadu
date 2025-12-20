# app/routes/users.py
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr, constr
from passlib.context import CryptContext
from psycopg2.errors import UniqueViolation

from app.database import conn
from app.auth import create_token

router = APIRouter(prefix="/users", tags=["Users"])

# Avoid bcrypt's 72-byte input limit by pre-hashing with SHA-256
pwd_context = CryptContext(schemes=["bcrypt_sha256"], deprecated="auto")

# --- Request Models ---
class RegisterReq(BaseModel):
    email: EmailStr
    password: constr(min_length=8, max_length=128)  # enforce length

class LoginReq(BaseModel):
    email: EmailStr
    password: str

# --- Helpers ---
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

# --- Routes ---
@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(body: RegisterReq):
    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute(
                    "INSERT INTO users(email, password_hash) VALUES(%s, %s)",
                    (body.email, hash_password(body.password)),
                )
            connection.commit()
        return {"status": "User registered"}
    except UniqueViolation:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="User already exists"
        )
    except Exception as e:
        # log error for debugging
        print("DB ERROR:", e)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal DB error: {e}"
        )

@router.post("/login")
def login(body: LoginReq):
    try:
        with conn() as connection:
            with connection.cursor() as cur:
                cur.execute("SELECT id, password_hash FROM users WHERE email=%s", (body.email,))
                row = cur.fetchone()
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Database unavailable: {e}"
        )

    if not row or not pwd_context.verify(body.password, row[1]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials"
        )

    token = create_token(str(row[0]))
    return {"access_token": token, "token_type": "bearer"}