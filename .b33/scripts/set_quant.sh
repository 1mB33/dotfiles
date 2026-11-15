#!/bin/bash
directory=~/.config/pipewire/
file=~/.config/pipewire/pipewire.conf

if ! [ -e "$directory" ] ; then
    mkdir - p "$directory"
fi


PS3='Select the default quantum: '
options=("16" "32" "64" "128" "256" "512" "1024" "2048" "4096" "8192" "16384" "32768")
select opt in "${options[@]}"
do
    case $opt in
        "16")
            echo "The default quantum is now $opt"
            break
            ;;
        "32")
            echo "The default quantum is now $opt"
            break
            ;;
        "64")
            echo "The default quantum is now $opt"
            break
            ;;
        "128")
            echo "The default quantum is now $opt"
            break
            ;;
        "256")
            echo "The default quantum is now $opt"
            break
            ;;
        "512")
            echo "The default quantum is now $opt"
            break
            ;;
        "1024")
            echo "The default quantum is now $opt"
            break
            ;;
        "2048")
            echo "The default quantum is now $opt"
            break
            ;;
        "4096")
            echo "The default quantum is now $opt"
            break
            ;;
        "8192")
            echo "The default quantum is now $opt"
            break
            ;;
        "16384" )
            echo "The default quantum is now $opt"
            break
            ;;
        "32768")
            echo "The default quantum is now $opt"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


sed -i "s/default\.clock\.quantum.*/default\.clock\.quantum = $opt/" ~/.config/pipewire/pipewire.conf
systemctl --user restart pipewire.service

