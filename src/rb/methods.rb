
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

