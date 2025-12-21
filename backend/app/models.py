from sqlalchemy import Column, String, ForeignKey, DateTime, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.ext.declarative import declarative_base
import uuid

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(Text, unique=True, nullable=False)
    password_hash = Column(Text, nullable=False)

class Contact(Base):
    __tablename__ = "contacts"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    name = Column(Text)
    phone = Column(Text)

class Campaign(Base):
    __tablename__ = "campaigns"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    name = Column(Text)   # matches DB schema
    message = Column(Text)

class SendLog(Base):
    __tablename__ = "send_logs"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    phone = Column(Text)
    campaign_id = Column(UUID(as_uuid=True), ForeignKey("campaigns.id"))
    status = Column(Text)
    created_at = Column(DateTime)  # DB default is now()