#!/usr/bin/bash

if [[ ! -d ".b33"  ||
      ! -d ".git"  || 
      $(pwd) = $HOME ]]; then
    echo We are not at root directory, execute the script from the root of the repository
    exit 1
fi

echo Syncing...
file_list=$(find . -not -path "*git*")
sync_list=

echo Gathering...
for f in $file_list 
do
    if [[ $f = "." || $f = ".." || -d $f ]]; then
        continue 
    fi
    f=${f:2}
    sync_list+="$f "
done
sync_list=${sync_list::-1}

contiune_flag=
echo "Syncing files from the list [$sync_list]"
echo
read -p "Continue? [Y/n] " continue_flag
if [[ $contiune_flag = "y" || $contiune_flag = "Y" ]]; then
    rm -r $sync_list
    cp -r $(printf "$HOME/%s" $sync_list) .
fi
echo Synced
