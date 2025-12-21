from pydantic import BaseModel, EmailStr
from typing import Optional

class UserRegister(BaseModel):
    email: EmailStr
    password: str   # plain password, will be hashed before saving

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class ContactCreate(BaseModel):
    name: str
    phone: str

class CampaignCreate(BaseModel):
    name: str       # matches DB schema
    message: str

class SendCreate(BaseModel):
    phone: str
    campaign_id: str
    status: Optional[str] = "sent"   # default value