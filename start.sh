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
git stash
PS3='Please select an option from the above choices: '
options=("Serverless Attack Lab"
        "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Serverless Attack Lab")
            echo "Serverless Attack Lab"
            read -p "Access Key ID [Required]:" n1
            read -p "Secret Access Key: [Required]:" n2
            read -p "AWS session token: [Optional]:" n3
            sed -i'' -e "s/myrandombucket/$(uuidgen | tr '[:upper:]' '[:lower:]')/g" serverless.yml

            python3.9 -V
            if [ $? -eq 0 ]; then
            echo '[INSTALL] Found python3.9'
            else
            echo '[ERROR] python3.9 not installed'
            if [[ $unamestr == 'Darwin' ]]; then
                echo 'Please install python3.9 version e.g brew install python3.9'
            else
                echo 'Please install python3.9 version e.g apt-get install python3.9'
            fi
            exit 1
            
            alias python3=python3.9
            echo '[INSTALL] Found Python3'
            python3 -m pip3.9 -V
            if [ $? -eq 0 ]; then
            echo '[INSTALL] Found pip3.9'
            alias pip==pip3.9
            if [[ $unamestr == 'Darwin' ]]; then
                python3 -m pip install --no-cache-dir --upgrade pip
            else
                python3 -m pip install --no-cache-dir --upgrade pip --user
            fi
            else
            echo '[ERROR] pip3.9 not installed'
            exit 1
            
            fi
            echo '[INSTALL] Using python virtualenv'
            rm -rf ./venv
            python3 -m venv ./venv
            if [ $? -eq 0 ]; then
                echo '[INSTALL] Activating virtualenv'
                source venv/bin/activate
                pip install --upgrade pip wheel
            else
                echo '[ERROR] Failed to create virtualenv'
                exit 1
            fi
            echo '[INSTALL] Installing Requirements'
            pip install --no-cache-dir --use-deprecated=legacy-resolver -r requirements.txt

            npm install -g serverless
            AWS_ACCESS_KEY_ID=$n1 AWS_SECRET_ACCESS_KEY=$n2 AWS_SESSION_TOKEN=$n3 sls plugin install -n serverless-python-requirements && sls plugin install -n serverless-s3-deploy && sls plugin install -n serverless-wsgi
            AWS_ACCESS_KEY_ID=$n1 AWS_SECRET_ACCESS_KEY=$n2 AWS_SESSION_TOKEN=$n3 sls deploy
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

