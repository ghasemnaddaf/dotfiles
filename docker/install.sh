#!/bin/bash

if test "$(uname)" = "Darwin"; then
    if [[ -f /Applications/Docker.app/Contents/MacOS/Docker ]]; then
        echo "docker is already installed, just run it!"
    else
        wget https://desktop.docker.com/mac/main/arm64/Docker.dmg
        sudo hdiutil attach Docker.dmg
        sudo /Volumes/Docker/Docker.app/Contents/MacOS/install --accept-license
        sudo hdiutil detach /Volumes/Docker
    fi
    /Applications/Docker.app/Contents/MacOS/Docker &
else
    # TODO: install docker if not installed
    sudo adduser $USER docker
    systemctl start docker
fi
docker login

exit 0
