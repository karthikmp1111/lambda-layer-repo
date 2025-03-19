#!/bin/bash
set -e  # Exit if any command fails

# Define paths
LAYER_DIR="python/lib/python3.12/site-packages"
LAYER_ZIP="../lambda-layer/lambda_layer.zip"

# Ensure a clean build
rm -rf python
mkdir -p $LAYER_DIR

# Install dependencies
pip3 install -r requirements.txt -t $LAYER_DIR --platform manylinux2014_x86_64 --only-binary=:all:

# Zip dependencies
zip -r9 lambda_layer.zip python

# Ensure lambda-layer directory exists before moving
mkdir -p ../lambda-layer

# Move ZIP to lambda-layer directory
mv -f lambda_layer.zip "$LAYER_ZIP"

echo "✅ Lambda layer build completed!"
ls -l ../lambda-layer/
