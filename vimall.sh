#!/bin/bash

IFS=$'\n'
files_rb=($( find "./src/rb/" -iname "*.rb" ))
files_js=("./level-editor/index.html" "./level-editor/keybindings.html" "./level-editor/keybindings.json" "./level-editor/css/*" "./level-editor/js/*")

if [[ "$1" =~ rb|ruby|game ]]; then
	vim -c "source ./vimrc" ${files_rb[@]}
elif [[ "$1" =~ js|www|web|frontend|leveleditor|editor ]]; then
	vim -c "source ./vimrc" ${files_js[@]}
else
	vim -c "source ./vimrc" ${files_rb[@]} ${files_js[@]}
fi

