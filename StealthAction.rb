#!/bin/env ruby

require 'gosu'
require 'pathname'
require 'json'
require 'yaml'
require 'byebug'

ROOT = (Pathname.new(File.absolute_path(__FILE__)).realpath).dirname.to_s

DIR = {
	rb:         File.join(ROOT, 'src/rb'),
	modules:    File.join(ROOT, 'src/rb/Modules'),
	rooms:      File.join(ROOT, 'src/rb/Rooms'),
	instances:  File.join(ROOT, 'src/rb/Instances'),
	entities:   File.join(ROOT, 'src/rb/Entities'),
	levels:     File.join(ROOT, 'src/levels'),
	images:     File.join(ROOT, 'src/images'),
	songs:      File.join(ROOT, 'src/songs'),
	samples:    File.join(ROOT, 'src/samples')
}

require File.join DIR[:rb], 'methods'
## Modules
require_files DIR[:modules]
require File.join(DIR[:modules], 'Pathfinding/Pathfind')
## Classes
require File.join(DIR[:rb], 'Settings')
require File.join(DIR[:rb], 'SongController')
require File.join(DIR[:rb], 'Instance')
require File.join(DIR[:rb], 'Room')
require File.join(DIR[:rb], 'Entity')
require_files DIR[:rooms]
require_files DIR[:instances]
require_files DIR[:entities]
require File.join(DIR[:rb], 'Level')
require File.join(DIR[:rb], 'Camera')
require File.join(DIR[:rb], 'main')

