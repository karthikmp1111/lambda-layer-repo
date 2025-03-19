#!/bin/bash
set -e  # Exit if any command fails

# Create a clean working directory for the layer
rm -rf python
mkdir -p python/lib/python3.12/site-packages

# Install required packages
pip3 install -r requirements.txt -t python/lib/python3.12/site-packages --platform manylinux2014_x86_64 --only-binary=:all:

# Zip the dependencies
zip -r9 lambda_layer.zip python

# Move ZIP to the correct directory ONLY if it's not already there
if [ ! -f "../lambda-layer/lambda_layer.zip" ]; then
    mv lambda_layer.zip ../lambda-layer/lambda_layer.zip
fi

echo "✅ Lambda layer built successfully!"