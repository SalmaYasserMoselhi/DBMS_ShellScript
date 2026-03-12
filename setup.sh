#!/bin/bash

cd "$(dirname "$0")" || exit 1

current=$(pwd)
export PATH=$PATH:$current

echo -e "Setting up DATABASE MANAGER..."

if ! grep -q "$current" ~/.bashrc 2>/dev/null; then
    echo "export PATH=\"\$PATH:$current\"" >> ~/.bashrc
    echo -e "Path added to .bashrc"
    echo -e "Please restart your terminal or run 'source ~/.bashrc' before using 'dbms.sh' directly."
else
    echo -e "Path already in .bashrc"
fi

for i in "$current"/* "$current"/scripts/*
do
    if [[ -f "$i" && "$i" == *.sh ]]; then
        chmod u+x "$i"
    fi
done

echo "Setup complete! You can now run the app from anywhere"
