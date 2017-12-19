#!/bin/bash

if [[ "$1" =~ rb|ruby|game ]]; then
	vim ./StealthAction.rb ./src/rb/*rb ./src/rb/Rooms/* ./src/rb/Instances/*
elif [[ "$1" =~ js|www|web|frontend|leveleditor|editor ]]; then
	vim ./level-editor/index.html ./level-editor/style.css ./level-editor/js/*
else
	vim ./StealthAction.rb ./src/rb/*rb ./src/rb/Rooms/* ./src/rb/Instances/* ./level-editor/index.html ./level-editor/style.css ./level-editor/js/*
fi

