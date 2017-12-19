
class Instance
	def initialize args = {}
		# Arguments
		@room = args[:room]
		@x = args[:x] || 0    # relative to room
		@y = args[:y] || 0    # relative to room
		@w = args[:w] || 16
		@h = args[:h] || 16

		# Defaults
		@z = 20
		@draw_x = 0
		@draw_y = 0
		@bg = $settings.instances :bg

		# Flags
		@solid = false

		init args  if (defined? init)
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

	def update
		@draw_x = @room.draw_x + @x
		@draw_y = @room.draw_y + @y

		# Custom update function of child class
		update_custom  if (defined? update_custom)
	end

	def draw
		Gosu.draw_rect @draw_x, @draw_y, @w,@h, @bg, @z

		# Custom draw function of child class
		draw_custom  if (defined? draw_custom)
	end
end


class TestInst < Instance
	def init args = {}
		@solid = true
	end
end

