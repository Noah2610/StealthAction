
## Add sign method to Integers and Floats
class ::Integer
	def sign
		return (self / self.abs)  unless (self == 0)
		return self
	end
end
class ::Float
	def sign
		return (self / self.abs)  unless (self == 0.0)
		return self
	end
end


def require_files dir
	## Require all .rb files in dir directory
	if (Dir.exists? dir)
		Dir.new(dir).each do |file|
			filepath = File.join dir, file
			require filepath  if (file =~ /\A\S+\.rb\z/ && File.exists?(filepath))
		end
	end
end

