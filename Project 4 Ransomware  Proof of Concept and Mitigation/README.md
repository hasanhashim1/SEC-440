# Ransomware Proof of Concept

## Overview
This repository contains a proof of concept for educational purposes that demonstrates how ransomware might encrypt and decrypt files using RSA and AES encryption algorithms. The scripts simulate the encryption of files within a specified directory and the subsequent decryption process.

## Contents
- `generate_keys.py`: Script to generate RSA public and private keys.
- `encrypt.py`: Script to encrypt files in a directory.
- `decrypt.py`: Script to decrypt previously encrypted files.

## Usage
1. **Generating Keys:**
   Run `python generate_keys.py` to generate the public and private keys.
   
2. **Encrypting Files:**
   Ensure that you update the `documents_path` variable in `encrypt.py` to point to the directory you wish to encrypt. Run `python encrypt.py` to encrypt the files.
   
3. **Decrypting Files:**
   Update the `encrypted_files_path` in `decrypt.py` to the directory containing your encrypted files. Run `python decrypt.py` to decrypt the files.

## Disclaimer
**This code is intended for educational purposes only** and is not meant for real-world application. The author is not responsible for any misuse of this software. It is unethical and illegal to deploy ransomware or any malicious software without consent on any systems.
