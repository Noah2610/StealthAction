#!/bin/bash

files_rb=("./StealthAction.rb" "./src/rb/*rb" "./src/rb/Rooms/*" "./src/rb/Instances/*" "./src/rb/Entities/*" "./src/rb/Pathfinding/*" "./src/rb/Modules/*")
files_js=("./level-editor/index.html" "./level-editor/keybindings.html" "./level-editor/keybindings.json" "./level-editor/css/*" "./level-editor/js/*")

if [[ "$1" =~ rb|ruby|game ]]; then
	vim -c "source ./vimrc" ${files_rb[@]}
elif [[ "$1" =~ js|www|web|frontend|leveleditor|editor ]]; then
	vim -c "source ./vimrc" ${files_js[@]}
else
	vim -c "source ./vimrc" ${files_rb[@]} ${files_js[@]}
fi

