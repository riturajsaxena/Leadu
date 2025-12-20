
import os
import psycopg2
from psycopg2 import OperationalError
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

DB_HOST = os.getenv("SUPABASE_DB_HOST")
DB_NAME = os.getenv("SUPABASE_DB_NAME", "postgres")
DB_USER = os.getenv("SUPABASE_DB_USER", "postgres")
DB_PASSWORD = os.getenv("SUPABASE_DB_PASSWORD")
DB_PORT = os.getenv("SUPABASE_DB_PORT", "6543")  # using pooler port

# Validate env early with a clear error
if not all([DB_HOST, DB_NAME, DB_USER, DB_PASSWORD, DB_PORT]):
    raise RuntimeError("Database environment variables are missing. Check your .env.")

def conn():
    """
    Return a fresh psycopg2 connection. Callers should use `with get_conn() as conn:`
    to ensure proper close/commit/rollback.
    """
    try:
        con1 = psycopg2.connect(
            host=DB_HOST,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=DB_PORT,
            sslmode="require",  # Supabase requires TLS
        )
        con1.autocommit = True
        return con1
    except OperationalError as e:
        # Let callers handle, or re-raise with context
        raise OperationalError(f"Database connection failed: {e}")
