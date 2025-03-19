#!/bin/bash
set -e  # Exit if any command fails

# Define paths
LAYER_DIR="python/lib/python3.12/site-packages"
LAYER_ZIP="../lambda-layer/lambda_layer.zip"

# Ensure a clean build
rm -rf python lambda_layer.zip
mkdir -p $LAYER_DIR

# Install dependencies
pip3 install -r requirements.txt -t $LAYER_DIR --platform manylinux2014_x86_64 --only-binary=:all:

# Zip dependencies
zip -r9 lambda_layer.zip python

# Ensure lambda-layer directory exists before moving
mkdir -p ../lambda-layer

# Move ZIP only if it's different from the existing one
if [ ! -f "$LAYER_ZIP" ] || ! cmp -s lambda_layer.zip "$LAYER_ZIP"; then
    mv -f lambda_layer.zip "$LAYER_ZIP"
    echo "✅ Lambda layer ZIP updated!"
else
    echo "⚠️ Lambda layer ZIP is unchanged. Skipping move."
fi

# Verify the ZIP exists
ls -l ../lambda-layer/
