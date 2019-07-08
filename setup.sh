#!/bin/bash

# check we are running as root for all of the install work
if [ "$EUID" -ne 0 ]; then
    echo -e "\n***\nPlease run as sudo.\nThis is needed for installing any dependancies as we go and for running RetroPie-Setup.\n***"
    exit
fi

# all operations performed relative to script directory
pushd $(dirname "${BASH_SOURCE[0]}") >/dev/null

# load variables and functions
. ./resources/data.sh
. ./resources/functions.sh

# RetroPie-Setup will - post update - call this script specifically to restore the lost patches
if [[ "$1" == "PATCH" ]]; then
    patchRetroPie
    popd >/dev/null
    return 0
fi

# perform initial setup if this is the 1st run
if [[ first_run -eq 1 ]]; then
    firstTimeSetup
fi

# RetroPie is not yet patched at fresh install, nor if something wen t wrong after an update
if [[ patched_version -ne $(git -C RetroPie-Setup/ log -1 --pretty=format:"%h") ]]; then
    patchRetroPie
fi

# dialog menu here
    while true; do
        exec 3>&1
        selection=$(dialog \
            --backtitle "retrOSMC mk2 - Installing RetroPie-Setup on your Vero4K" \
            --title "Setup Menu" \
            --clear \
            --cancel-label "Back" \
            --item-help \
            --menu "Please select:" 0 0 4 \
            "1" "Update retrOSMCmk2" "Pulls the latest version of this script from the repository" \
            "2" "Run RetroPie-Setup" "Run RetroPie-Setup" \
            "3" "Uninstall" "Uninstall" \
            "4" "Install Launcher" "Install Launcher" \
            2>&1 1>&3)
        ret_val=$?
        exec 3>&-

        case $ret_val in
            $DIALOG_CANCEL)
                clear
                break
                ;;
            $DIALOG_ESC)
                clear
                break
                ;;
        esac

        case $selection in
            0 )
                clear
                echo "Program terminated."
                ;;
            1 )
                ;;
            2 )
                ;;
            3 )
                ;;
            4 )
                ;;
        esac
    done


# the end - get back to whence we came
popd >/dev/null
return 0
