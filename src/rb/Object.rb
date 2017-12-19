
class Instance
	def initialize args = {}
		@room = args[:room]
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || 16
		@h = args[:h] || 16

		@draw_x = 0
		@draw_y = 0
		@bg = $settings.instances :bg

		init args  if (defined? init)
	end

	def update
		@x = @room.draw_x + @x
		@y = @room.draw_y + @x

		# Custom update function of child class
		update_custom  if (defined? update_custom)
	end

	def draw
		Gosu.draw_rect @draw_x, @draw_y, @w,@h

		# Custom draw function of child class
		draw_custom  if (defined? draw_custom)
	end
end


class TestInst < Instance
	def init args = {}
	end
end

