#!/bin/bash

# Script to decrypt signing certificates for CI/CD
# Usage: ./decrypt_signing.sh

set -e

if [ -z "$SIGNING_KEY" ]; then
    echo "Error: SIGNING_KEY environment variable is not set"
    exit 1
fi

echo "Decrypting signing certificates..."

# Create certificates directory
mkdir -p certificates

# Decrypt certificates using the signing key
echo "$SIGNING_KEY" | base64 -d | gpg --batch --yes --decrypt --passphrase-fd 0 certificates.tar.gz.gpg > certificates.tar.gz

# Extract certificates
tar -xzf certificates.tar.gz -C certificates/

# Clean up
rm certificates.tar.gz

echo "Signing certificates decrypted successfully!"
echo "Certificates available in: certificates/"