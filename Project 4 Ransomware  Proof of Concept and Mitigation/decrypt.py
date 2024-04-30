# Made by Hasan Hashim
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
import os

# Load the private key from file
with open("private_key.pem", "rb") as key_file:
    private_key = serialization.load_pem_private_key(key_file.read(), password=None)

# Load the encrypted symmetric key and IV from disk
with open("symmetric_key_encrypted", "rb") as key_file:
    encrypted_symmetric_key = key_file.read()
with open("iv_file", "rb") as iv_file:
    iv = iv_file.read()

# Decrypt the symmetric key using the private RSA key
symmetric_key = private_key.decrypt(
    encrypted_symmetric_key,
    padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(),
        label=None
    )
)

def decrypt_files(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".enc"):
            file_path = os.path.join(directory, filename)
            with open(file_path, "rb") as encrypted_file:
                encrypted_data = encrypted_file.read()

            cipher = Cipher(algorithms.AES(symmetric_key), modes.CFB(iv))
            decryptor = cipher.decryptor()
            decrypted_data = decryptor.update(encrypted_data) + decryptor.finalize()

            original_path = file_path[:-4]
            with open(original_path, "wb") as decrypted_file:
                decrypted_file.write(decrypted_data)
            os.remove(file_path)

encrypted_files_path = "C:\\Users\\THE PATH TO DECRYPT"

decrypt_files(encrypted_files_path)
