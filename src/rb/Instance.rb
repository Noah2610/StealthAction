
class Instance
	def initialize args = {}
		# Arguments
		@room = args[:room] || nil
		@x = args[:x] || 0    # relative to room
		@y = args[:y] || 0    # relative to room
		@w = args[:w] || 16
		@h = args[:h] || 16

		# Defaults
		@z = 20
		@bg = $settings.instances :bg

		# Flags
		@solid = false

		init args  if (defined? init)
	end

	def set_room room
		@room = room
	end

	def is_solid?
		return @solid
	end

	def pos axis
		case axis
		when :x, :left
			return @room.x + @x
		when :x2, :right
			return @room.x + @x + @w
		when :y, :top
			return @room.y + @y
		when :y2, :bottom
			return @room.y + @y + @h
		end
	end

	def draw_pos axis
		case axis
		when :x
			return @room.draw_pos(:x) + @x
		when :y
			return @room.draw_pos(:y) + @y
		else
			return 0
		end
	end

	def update
		# Custom update function of child class
		update_custom  if (defined? update_custom)
	end

	def draw
		Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @bg, @z

		# Custom draw function of child class
		draw_custom  if (defined? draw_custom)
	end
end

