
class Room
	attr_reader :x,:y, :w,:h, :draw_x,:draw_y, :instances

	def	initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || 100
		@h = args[:h] || 100

		@z = 10
		@draw_x = 0
		@draw_y = 0
		@bg = $settings.rooms :bg
		@instances = []

		init args  if (defined? init)
	end

	def update
		@draw_x = @x - $camera.x
		@draw_y = @y - $camera.y
		@instances.each &:update

		# Custom update function of child class
		update_custom  if (defined? update_custom)
	end

	def draw
		# Draw room background
		Gosu.draw_rect @draw_x, @draw_y, @w,@h, @bg, @z
		# Draw instances (walls, ...)
		@instances.each &:draw

		# Custom draw function of child class
		draw_custom  if (defined? draw_custom)
	end
end


class TestRm < Room
	def init args = {}
		@instances = [
			TestInst.new(
				room:  self,
				x: 64,
				y: 64,
				w: 144,
				h: 64
			),
			TestInst.new(
				room:  self,
				x: 240,
				y: 64,
				w: 144,
				h: 64
			),
			TestInst.new(
				room:  self,
				x: 64,
				y: 160,
				w: 144,
				h: 128
			),
			TestInst.new(
				room:  self,
				x: 240,
				y: 160,
				w: 144,
				h: 128
			)
		]
	end
end

