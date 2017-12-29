
## Add sign method to Integers and Floats
class ::Integer
	def sign
		return (self / self.abs)  unless (self == 0)
		return self
	end end
class ::Float
	def sign
		return (self / self.abs)  unless (self == 0.0)
		return self
	end
end


## Require all .rb files in dir directory
def require_files dir
	if (Dir.exists? dir)
		Dir.new(dir).each do |file|
			filepath = File.join dir, file
			require filepath  if (file =~ /\A\S+\.rb\z/ && File.exists?(filepath))
		end
	end
end

## Check if class exists by string
# https://stackoverflow.com/a/1187276
def class_exists? string
	c = Object.const_get string
	return c.is_a? Class
rescue NameError
	return false
end

## Load all images
def load_images dir = DIR[:images], args = {}
	return nil  unless (File.directory? dir)
	valid_formats = args[:valid_formats]
	images = Dir.new(dir).map do |file|
		next nil  if (file =~ /\A\.{1,2}\z/)
		name = file.match(/(\A.+)\./)[1].to_sym
		ext = file.match(/\.(.+\z)/)[1].downcase
		next nil  unless (valid_formats.include? ext)
		fullpath = File.join dir, file
		next [name, Gosu::Image.new(fullpath, retro: true)]
	end .reject { |v| v.nil? } .to_h
	return images
end

## Load specific song
def load_song target, dir = DIR[:songs], args = {}
	target = target.to_sym
	valid_formats = args[:valid_formats]
	Dir.new(dir).each do |file|
		next  if (file =~ /\A\.{1,2}\z/)
		name = file.match(/(\A.+)\./)[1].to_sym
		ext = file.match(/\.(.+\z)/)[1].downcase
		fullpath = File.join dir, file
		if (valid_formats.include?(ext) && target == name)
			return Gosu::Song.new fullpath
		end
	end
	return nil
end

## Return current room
def current_room
	return $game.room      unless ($game.nil?)
	return nil
end

## Return Player
def player
	return $game.player    unless ($game.nil?)
	return nil
end

## Return Pathfind instance
def pathfinder
	return nil
	return $game.pathfind  unless ($game.nil?)
end

