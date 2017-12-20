#!/bin/env ruby

require 'json'

ROOT = "#{File.dirname(__FILE__)}"
DIR = File.join ROOT, 'src/rb/Instances';
OUTPUT = File.join ROOT, 'level-editor/instance_list.json'

COLORS = {
	:default         =>  "#000000",
	"WallSimpleInst" =>  "#666666",
	"PassableInst"   =>  "#adffff",
	"DoorInst"       =>  "#ba0000"
}

instances = []
Dir.new(DIR).each do |file|
	next  if (file =~ /\A\.{1,2}\z/)
	if (file =~ /\A\S+\.rb\z/)
		name = file.sub(/\.rb\z/, "")
		color = COLORS[name] || COLORS[:default]
		instance = {
			name:   name,
			color:  color
		}
		instances << instance
	end
end

file = File.new OUTPUT, "w"
file.write instances.to_json
file.close

