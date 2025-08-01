import os
import secrets

# Generate a 32-character (256-bit) random secret key
secret_key = secrets.token_hex(16)  # 16 bytes = 32 characters in hex
print(secret_key)