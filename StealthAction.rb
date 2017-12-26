#!/bin/env ruby

require 'gosu'
require 'json'
require 'yaml'
require 'byebug'


#dir = "#{File.dirname(__FILE__)}"
#dir = "./#{dir}"  unless (dir[0] == "/" || dir[0..1] == "./")
#ROOT = dir
ROOT = File.dirname(File.absolute_path(__FILE__))

DIR = {
	rb:         File.join(ROOT, 'src/rb'),
	rooms:      File.join(ROOT, 'src/rb/Rooms'),
	instances:  File.join(ROOT, 'src/rb/Instances'),
	entities:   File.join(ROOT, 'src/rb/Entities'),
	levels:     File.join(ROOT, 'src/levels')
}

require File.join DIR[:rb], 'methods'
require File.join DIR[:rb], 'Settings'
require File.join DIR[:rb], 'Instance'
require File.join DIR[:rb], 'Room'
require File.join DIR[:rb], 'Entity'
require_files DIR[:rooms]
require_files DIR[:instances]
require_files DIR[:entities]
require File.join DIR[:rb], 'Level'
require File.join DIR[:rb], 'Camera'
require File.join DIR[:rb], 'main'

