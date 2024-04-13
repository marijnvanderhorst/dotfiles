#!/usr/bin/env bash

if ! command -v xcode-select &> /dev/null
then
    echo "Installing XCode tools..."
    xcode-select --install
fi

if ! command -v brew &> /dev/null
then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v /opt/homebrew/bin/python3 &> /dev/null
then
    brew install python3
fi

/opt/homebrew/bin/pip3 install virtualenv
# Create a virtualenv if one does not already exist
/opt/homebrew/bin/python3 -m virtualenv venv-ansible  

./venv-ansible/bin/pip install ansible

echo "DONE"

#git clone https://github.com/marijnvanderhorst/dotfiles.git ~/dotfiles

