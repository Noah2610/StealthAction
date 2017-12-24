#!/bin/bash

if [[ "$1" =~ rb|ruby|game ]]; then
	vim -c "source ./vimrc" ./StealthAction.rb ./src/rb/*rb ./src/rb/Rooms/* ./src/rb/Instances/* ./src/rb/Entities/*
elif [[ "$1" =~ js|www|web|frontend|leveleditor|editor ]]; then
	vim -c "source ./vimrc" ./level-editor/index.html ./level-editor/keybindings.html ./level-editor/css/* ./level-editor/js/*
else
	vim -c "source ./vimrc" ./StealthAction.rb ./src/rb/*rb ./src/rb/Rooms/* ./src/rb/Instances/* ./src/rb/Entities/* ./level-editor/index.html ./level-editor/keybindings.html ./level-editor/css/* ./level-editor/js/*
fi

