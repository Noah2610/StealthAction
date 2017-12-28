#!/bin/env ruby

require 'gosu'
require 'json'
require 'yaml'
require 'byebug'

ROOT = File.dirname(File.absolute_path(__FILE__))

DIR = {
	rb:         File.join(ROOT, 'src/rb'),
	rooms:      File.join(ROOT, 'src/rb/Rooms'),
	instances:  File.join(ROOT, 'src/rb/Instances'),
	entities:   File.join(ROOT, 'src/rb/Entities'),
	levels:     File.join(ROOT, 'src/levels'),
	images:     File.join(ROOT, 'src/images'),
	songs:      File.join(ROOT, 'src/songs'),
	samples:    File.join(ROOT, 'src/samples')
}

require File.join DIR[:rb], 'methods'
require File.join DIR[:rb], 'Settings'
require File.join DIR[:rb], 'SongController'
require File.join DIR[:rb], 'Instance'
require File.join DIR[:rb], 'Room'
require File.join DIR[:rb], 'Entity'
require_files DIR[:rooms]
require_files DIR[:instances]
require_files DIR[:entities]
require File.join DIR[:rb], 'Level'
require File.join DIR[:rb], 'Camera'
require File.join DIR[:rb], 'main'

