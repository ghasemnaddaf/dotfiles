#!/bin/bash

DOCKER_DESKTOP_BINARY=/Applications/Docker.app/Contents/MacOS/Docker\ Desktop.app/Contents/MacOS/Docker\ Desktop
if test "$(uname)" = "Darwin"; then
    if [[ -f ${DOCKER_DESKTOP_BINARY} ]]; then
        echo "docker is already installed, just run it!"
    else
        if [[ ! -f /tmp/Docker.dmg ]]; then wget https://desktop.docker.com/mac/main/arm64/Docker.dmg -O /tmp/Docker.dmg; fi
        sudo hdiutil attach /tmp/Docker.dmg
        sudo /Volumes/Docker/Docker.app/Contents/MacOS/install --accept-license
        sudo hdiutil detach /Volumes/Docker
	rm -rf /tmp/Docker.dmg
    fi
#    ${DOCKER_DESKTOP_BINARY} &
else
    # TODO: install docker if not installed
    sudo adduser $USER docker
    systemctl start docker
fi
docker login

exit 0
