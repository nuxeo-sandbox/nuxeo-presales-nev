#!/bin/sh

# Shortcut to create a new stack
alias nevcreate='bash -c "$(curl -fsSL https://raw.githubusercontent.com/nuxeo-sandbox/nuxeo-presales-nev/main/bootstrap.sh)"'

# QOL aliases to make managing the stack easier
alias nev='make -e'
alias nevui='nev SERVICE=ui'
