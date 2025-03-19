#!/bin/bash
set -e

# Define the target directory
LAYER_DIR="python/lib/python3.12/site-packages"

# Create the necessary directories
mkdir -p $LAYER_DIR

# Install dependencies in the layer directory
pip3 install -r requirements.txt -t $LAYER_DIR --platform manylinux2014_x86_64 --only-binary=:all:

# Package the layer as a zip file
zip -r lambda_layer.zip python

# Cleanup
rm -rf python