#!/bin/bash
set -e  # Exit if any command fails

# Create a clean working directory for the layer
rm -rf python
mkdir -p python/lib/python3.12/site-packages

# Install required packages
pip3 install -r requirements.txt -t python/lib/python3.12/site-packages --platform manylinux2014_x86_64 --only-binary=:all:

# Zip the dependencies
zip -r9 lambda_layer.zip python

# Move ZIP only if it's not in the correct directory
if [ "$(pwd)" != "../lambda-layer" ]; then
    echo "📂 Moving ZIP to lambda-layer directory..."
    mv lambda_layer.zip ../lambda-layer/lambda_layer.zip
fi

echo "✅ Lambda layer built successfully!"