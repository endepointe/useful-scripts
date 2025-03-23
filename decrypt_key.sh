#!/bin/bash

function show_usage() {
    echo "Usage:" $0 "<path_to_file_decrypt>" "<scheme>" "<ENV_VAR_NAME>"
    echo "-----> scheme is most likely aes256."
    echo "----------> OR" $0 "--help or -h"
    return 0
}

function help() {
    echo "I will make a proper help in the future"
    return 0
}

# Gemini-Generated function (needs work):
#Prompt and get the password with masking
#mask_password() {
#    local password=""
#    local char
#    local prompt="$1"  #  The prompt
#    local mask_char="*"
#
#    printf "%s" "$prompt"  # Display prompt, without newline
#
#    while IFS= read -r -n 1 char; do
#        if [[ "$char" == $'\x04' ]]; then  # Ctrl-D (EOF)
#            break  # End input
#        elif [[ "$char" == $'\x0a' ]]; then  # Enter
#            break  # End input
#        elif [[ "$char" == $'\x7f' ]]; then #Backspace
#            # Remove the last character from password and reprint the prompt
#            if [[ -n "$password" ]]; then
#                password="${password%?}"
#                printf "\b \b" # Remove last asterisk from terminal.
#            fi
#        else
#            password+="$char"
#            printf "%s" "$mask_char"  # Print the mask character
#        fi
#    done
#    echo  # Newline after password entry
#
#    #Return the password
#    echo "$password"
#}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    return 0
fi

if [[ $# -ne 3 ]]; then
    show_usage
    return -1
fi

# If a file and encryption scheme, do the thing.
if [[ -f "$1" ]]; then
    if [[ "$2" == "aes256" ]]; then
        echo "Valid.... Decrypting" $1 "with" $2 "scheme." 
        read -p "Enter key: " -s key
        #key=$(mask_password "Enter password: ")
        export $3=$(echo "$key" | openssl enc -pbkdf2 -$2 -d -in $1 -pass stdin)
        echo
    fi
else
    echo "ERROR: enter a valid file to decrypt" 
    show_usage
    return -1
fi

