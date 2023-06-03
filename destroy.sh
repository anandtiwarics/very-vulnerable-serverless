#!/bin/bash
unamestr=$(uname)
if ! [ -x "$(command -v python3)" ]; then
  echo '[ERROR] python3 is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v npm)" ]; then
  echo '[ERROR] npm is not installed.' >&2
  exit 1
fi

PS3='Please select an option from the above choices: '
options=("Destroy Serverless Attack Lab"
        "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Serverless Attack Lab")
            echo "Serverless Attack Lab"
            read -p "Access Key ID [Required]:" n1
            read -p "Secret Access Key: [Required]:" n2
            read -p "AWS session token: [Optional]:" n3
            AWS_ACCESS_KEY_ID=$n1 AWS_SECRET_ACCESS_KEY=$n2 AWS_SESSION_TOKEN=$n3 sls remove
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done