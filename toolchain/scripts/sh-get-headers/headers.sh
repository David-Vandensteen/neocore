#!/bin/bash

build_folder="../../../build"
header_folder="$build_folder/header"
neodev_url="http://azertyvortex.free.fr/download/neodev-header.zip"
datlib_url="http://azertyvortex.free.fr/download/DATlib-header.zip"

if [ ! -d "$build_folder" ]; then
    echo "Error: The folder $build_folder does not exist."
    exit 1
fi

if [ ! -d "$header_folder" ]; then
    mkdir "$header_folder"
    echo "The folder $header_folder has been created."
fi

cd "$header_folder"

echo "Downloading neodev-header.zip..."
curl -O "$neodev_url"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download neodev-header.zip."
    exit 1
fi

echo "Downloading DATlib-header.zip..."
curl -O "$datlib_url"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download DATlib-header.zip."
    exit 1
fi

echo "Extracting neodev-header.zip..."
unzip -q neodev-header.zip
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract neodev-header.zip."
    exit 1
fi

echo "Extracting DATlib-header.zip..."
unzip -q DATlib-header.zip
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract DATlib-header.zip."
    exit 1
fi

rm -f neodev-header.zip
rm -f DATlib-header.zip

echo "The script has executed successfully."
