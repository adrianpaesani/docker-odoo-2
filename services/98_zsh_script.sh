#!/bin/bash

sudo -u odoo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

if [[ "$USER_SHELL" == "/usr/bin/zsh" ]]; then
    # info 'Download latest oh-my-zsh'
    /bin/cp /scripts/zshrc "/home/odoo/.zshrc"
    sudo chsh -s /usr/bin/zsh odoo
fi
