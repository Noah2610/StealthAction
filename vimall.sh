#!/bin/bash

file_readme="./README.md"
files_rb=("./StealthAction.rb" $( find "./src/rb/" -iname "*.rb" | tr $'\n' ' ' ))
files_js=("./level-editor/index.html" "./level-editor/keybindings.html" "./level-editor/keybindings.json" "./level-editor/css/*" "./level-editor/js/*")

if [[ "$1" =~ rb|ruby|game ]]; then
	vim -c "source ./vimrc" ${file_readme} ${files_rb[@]}
elif [[ "$1" =~ js|www|web|frontend|leveleditor|editor ]]; then
	vim -c "source ./vimrc" ${file_readme} ${files_js[@]}
else
	vim -c "source ./vimrc" ${file_readme} ${files_rb[@]} ${files_js[@]}
fi

