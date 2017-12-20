
class Room
	attr_reader :x,:y, :w,:h, :instances

	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || $settings.rooms(:w)
		@h = args[:h] || $settings.rooms(:h)
		@instances = args[:instances] || []

		@instances.each { |inst| inst.set_room self }

		@z = 10
		@bg = $settings.rooms :bg

		init args  if (defined? init)
	end

	def solid_instances
		return @instances.map do |instance|
			next instance  if (instance.is_solid?)
		end .reject { |v| v.nil? }
	end

	def draw_pos axis
		case axis
		when :x
			return @x - $camera.x
		when :y
			return @y - $camera.y
		else
			return 0
		end
	end

	def update
		@instances.each &:update

		# Custom update function of child class
		update_custom  if (defined? update_custom)
	end

	def draw
		# Draw room background
		Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @bg, @z
		# Draw instances (walls, ...)
		@instances.each &:draw

		# Custom draw function of child class
		draw_custom  if (defined? draw_custom)
	end
end

