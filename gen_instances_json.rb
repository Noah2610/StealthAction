#!/bin/env ruby

require 'json'

ROOT = "#{File.dirname(__FILE__)}"
DIR = File.join ROOT, 'src/rb/Instances';
OUTPUT = File.join ROOT, 'level-editor/instances.json'

instances = []
Dir.new(DIR).each do |file|
	next  if (file =~ /\A\.{1,2}\z/)
	instances << file.sub(/\.rb\z/, "")  if (file =~ /\A\S+\.rb\z/)
end

file = File.new OUTPUT, "w"
file.write instances.to_json
file.close

