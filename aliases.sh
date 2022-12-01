#!/bin/sh

# Shortcut to create a new stack
alias nevcreate='bash -c "$(curl -fsSL https://raw.github.com/nuxeo-sandbox/nuxeo-presales-nev/master/bootstrap.sh)"'

# QOL aliases to make managing the stack easier
alias nev='make -e'
alias nevlogs='nev logs'
