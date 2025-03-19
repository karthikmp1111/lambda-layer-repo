#!/bin/bash
set -e  # Exit if any command fails

echo "📂 Setting up Python Layer Directory..."
rm -rf python
mkdir -p python/lib/python3.12/site-packages

echo "📦 Installing dependencies..."
pip3 install -r requirements.txt -t python/lib/python3.12/site-packages --platform manylinux2014_x86_64 --only-binary=:all:

echo "📂 Creating Lambda Layer ZIP..."
zip -r9 lambda_layer.zip python

echo "📂 Moving ZIP to lambda-layer directory..."
mv -f lambda_layer.zip ../lambda-layer/lambda_layer.zip

echo "✅ Lambda layer built successfully!"