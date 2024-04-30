# Made by Hasan Hashim
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

# Generate RSA key pair
private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
public_key = private_key.public_key()

# public key
pem_public_key = public_key.public_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PublicFormat.SubjectPublicKeyInfo
)

# private key
pem_private_key = private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption()
)

# Save both keys to files
with open("public_key.pem", "wb") as pub_key_file:
    pub_key_file.write(pem_public_key)

with open("private_key.pem", "wb") as priv_key_file:
    priv_key_file.write(pem_private_key)

print("Keys generated and saved.")
