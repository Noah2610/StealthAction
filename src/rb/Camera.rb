
class Camera
	attr_reader :x,:y

	def initialize args = {}
		@x = args[:x] || 0  #$settings.screen[:w] / 2
		@y = args[:x] || 0  #$settings.screen[:h] / 2
		@step = args[:step] || $settings.camera(:step)
	end

	def move dir, step = @step
		case dir
		when :up
			@y -= step
		when :down
			@y += step
		when :left
			@x -= step
		when :right
			@x += step
		end
	end

	def move_to args
		@x = args[:x]  unless (args[:x].nil?)
		@y = args[:y]  unless (args[:y].nil?)
	end
end

