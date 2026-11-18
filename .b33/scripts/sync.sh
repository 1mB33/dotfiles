#!/usr/bin/bash

if [[ $(pwd) = $HOME || ! -d ".git" || ! -d ".b33" ]]; then
    echo We are not in the root directory of the repository, exiting
    exit 1
fi

echo Syncing...
files=$(ls -a)
sync_files=

for f in $files
do
    if [[ $f = "." || $f = ".." ]]; then
        continue 
    fi
    if [[ -f "$HOME/$f" || -d "$HOME/$f" ]]; then
        sync_files+="$f "
    fi
done
sync_files=${sync_files::-1}

echo "Syncing files from the list [$sync_files]"
echo Synced
