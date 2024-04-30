# Educational Ransomware Simulation: Encryption & Decryption Techniques

## Python Script for Keys Generator
In the context of my educational project on ransomware simulation, I created a standalone Python script, `gen_key.py`, specifically designed to generate and store the cryptographic keys necessary for the encryption and decryption processes. This script is foundational because it ensures the separation of key management from the core functionality of the encryption and decryption scripts, adhering to good cryptographic practice.

The script begins by importing necessary functions from the `cryptography.hazmat.primitives` module. I used the `rsa` module to generate a new RSA key pair, which is crucial for the asymmetric encryption mechanism that protects the symmetric key used in encrypting files. The RSA key pair consists of a private key and a public key, where the public key can be safely distributed and the private key must be securely stored.

Within the script, the RSA private key is generated with a specified key size of 2048 bits and a public exponent of 65537, which are standard parameters providing a strong level of security. The public key is derived from the private key immediately following its creation.

After generating the keys, I serialized both the public and private keys into the PEM (Privacy Enhanced Mail) format, which is a widely used format for storing and transmitting cryptographic keys. This serialization process converts the keys into a format that can be easily written to files and later read back into the application.

The serialized keys are then written to separate files: `public_key.pem` for the public key, and `private_key.pem` for the private key. This storage ensures that the keys can be persistently accessed across different sessions and by different components of the ransomware simulation system.

Finally, the script prints a confirmation message, "Keys generated and saved." This output serves as an immediate feedback mechanism to confirm that the keys have been properly generated and stored, ensuring that any subsequent processes relying on these keys (such as the encryption or decryption scripts) can proceed without issues.

## Python Script for Encryption Files
I developed a Python script to encrypt files on a system, utilizing advanced cryptographic techniques and key management to simulate a ransomware attack for educational purposes. I started by importing the necessary libraries from the `cryptography.hazmat` modules, which provide the cryptographic primitives for asymmetric encryption, hashing, serialization, and symmetric ciphers.

Firstly, I loaded the public RSA key from a file named `public_key.pem` using the `serialization` module. This key is essential for encrypting the symmetric key that I generate later. I then generated a random 256-bit symmetric key and a 16-byte initialization vector (IV), both crucial for the AES encryption process. Using the RSA public key, I encrypted the symmetric key with OAEP padding to enhance security, which prevents attackers from easily deciphering the key even if they intercept it.

After encrypting the symmetric key, I wrote it and the IV to the disk. This simulates how real ransomware might store its encrypted key remotely or locally to prevent easy recovery without payment. I created a function, `encrypt_files`, to iterate through all files in a specified directory, encrypting each with the AES algorithm using the symmetric key and IV. Each file was renamed with an `.enc` extension to denote encryption, and the original files were deleted to mimic the impact of ransomware.

Once all files were encrypted, I focused on communicating with the victim. I drafted a ransom message stating that all files were encrypted and provided a fictitious URL where the ransom could be paid to retrieve the decryption key. This message was written to a temporary text file, `ransom_message.txt`, and then displayed in Notepad using the `subprocess.run` command. This step demonstrates how attackers might instruct their victims, adding a realistic layer to the simulation.


## Python Script for Decryption Files
For my decryption process, I constructed a Python script that reverses the encryption steps, aimed at restoring the files previously encrypted. This script forms an essential part of the educational simulation of a ransomware attack, demonstrating the decryption phase that might be used by a victim after regaining access to the decryption key, ideally without paying the ransom in a real-life scenario.

I began by importing the necessary cryptographic components from the `cryptography.hazmat` libraries, which facilitate the decryption process including the handling of keys and the actual decryption of files. First, I loaded the private RSA key from a file named `private_key.pem`. This key is crucial for decrypting the symmetric key used during the file encryption stage.

Following this, I retrieved the encrypted symmetric key and the initialization vector (IV) from their respective files on the disk. These elements were necessary to reconstruct the encryption environment for decryption. Using the private key, I decrypted the symmetric key with OAEP padding, which ensures that the decryption process mirrors the security measures used during encryption.

With the symmetric key and IV now available in their original forms, I defined a function `decrypt_files` that iterates through all files in a specified directory, identifying those with the `.enc` extension indicative of encryption. For each encrypted file, I opened and read its contents, then decrypted the data using the AES algorithm with the previously used IV. This decryption converted the files back to their original form.

After decryption, I saved the decrypted data to new files, stripping the `.enc` extension to restore their original filenames, and removed the encrypted files to clean up after the process. This step concludes the restoration of data, simulating a successful decryption operation that might occur after a ransomware attack.

## Reflection
Through this project, I gained hands-on experience with Python's cryptographic capabilities and deepened my understanding of both the technical execution and the psychological tactics employed in ransomware attacks. This exercise served as a powerful reminder of the importance of cybersecurity measures and the ethical responsibilities of software developers.
