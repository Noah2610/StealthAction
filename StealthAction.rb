#!/bin/env ruby

require 'gosu'
require 'pathname'
require 'json'
require 'yaml'
#require 'byebug'

ROOT = (Pathname.new(File.absolute_path(__FILE__)).realpath).dirname.to_s

DIR = {
	rb:         File.join(ROOT, 'src/rb'),
	classes:    File.join(ROOT, 'src/rb/Classes'),
	modules:    File.join(ROOT, 'src/rb/Modules'),
	rooms:      File.join(ROOT, 'src/rb/Classes/Rooms'),
	instances:  File.join(ROOT, 'src/rb/Classes/Instances'),
	entities:   File.join(ROOT, 'src/rb/Classes/Entities'),
	levels:     File.join(ROOT, 'src/levels'),
	images:     File.join(ROOT, 'src/images'),
	songs:      File.join(ROOT, 'src/songs'),
	samples:    File.join(ROOT, 'src/samples')
}

#require File.join DIR[:rb], 'methods'
### Modules
#require_files DIR[:modules]
#require File.join(DIR[:modules], 'Pathfinding/Pathfind')
### Classes
#require_files File.join(DIR[:classes])
#require File.join(DIR[:rb], 'Settings')
#require File.join(DIR[:rb], 'SongController')
#require File.join(DIR[:rb], 'Instance')
#require File.join(DIR[:rb], 'Room')
#require File.join(DIR[:rb], 'Entity')
#require_files DIR[:rooms]
#require_files DIR[:instances]
#require_files DIR[:entities]
#require File.join(DIR[:rb], 'Level')
#require File.join(DIR[:rb], 'Camera')

require File.join DIR[:rb], 'methods'
## Modules
require_files(
	File.join(DIR[:modules]),
	recursive: true
)
## Classes
require_files(
	File.join(DIR[:classes]),
	recursive: true
)
## rb
require_files(
	File.join(DIR[:rb]),
	except: File.join(DIR[:rb], 'main.rb')
)
## main
require File.join(DIR[:rb], 'main')

