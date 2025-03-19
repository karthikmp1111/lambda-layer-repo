#!/bin/bash
set -e  # Exit if any command fails

# Define paths
LAYER_ZIP="../lambda-layer/lambda_layer.zip"
REQUIREMENTS_HASH_FILE=".requirements_hash"

# Create a clean working directory for the layer
rm -rf python
mkdir -p python/lib/python3.12/site-packages

# Compute hash of current requirements.txt
NEW_HASH=$(sha256sum requirements.txt | awk '{print $1}')

# Check if requirements changed
if [ -f "$REQUIREMENTS_HASH_FILE" ] && grep -q "$NEW_HASH" "$REQUIREMENTS_HASH_FILE"; then
    echo "✅ No changes in requirements.txt, skipping package rebuild."
else
    echo "🔄 Changes detected in requirements.txt, rebuilding Lambda layer..."

    # Install dependencies
    pip3 install -r requirements.txt -t python/lib/python3.12/site-packages --platform manylinux2014_x86_64 --only-binary=:all:

    # Zip the dependencies
    zip -r9 lambda_layer.zip python

    # Save new hash
    echo "$NEW_HASH" > "$REQUIREMENTS_HASH_FILE"

    # Ensure lambda-layer directory exists before moving
    mkdir -p ../lambda-layer

    # Move ZIP only if it's different
    if [ ! -f "$LAYER_ZIP" ] || ! cmp -s lambda_layer.zip "$LAYER_ZIP"; then
        echo "📂 Moving ZIP to lambda-layer directory..."
        mv lambda_layer.zip "$LAYER_ZIP"
    else
        echo "✅ ZIP file is already up to date."
    fi
fi

echo "✅ Lambda layer build process completed!"
