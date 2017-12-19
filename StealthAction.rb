#!/bin/env ruby

require 'gosu'

require 'byebug'

dir = "#{File.dirname(__FILE__)}"
dir = "./#{dir}"  unless (dir[0] == "/" || dir[0..1] == "./")
ROOT = dir

DIR = {
	rb:  File.join(ROOT, 'src/rb')
}

require File.join DIR[:rb], 'Settings'
require File.join DIR[:rb], 'Camera'
require File.join DIR[:rb], 'Instance'
require File.join DIR[:rb], 'Room'
require File.join DIR[:rb], 'Player'
require File.join DIR[:rb], 'main'

