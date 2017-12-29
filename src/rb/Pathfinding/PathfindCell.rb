
class PathfindCell
	attr_accessor :g_cost, :h_cost, :parent
	include Collision

	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || 32
		@h = args[:h] || 32
		@index = {
			x: (args[:index][:x] || 0),
			y: (args[:index][:y] || 0)
		}
		@solid = args[:solid] || false
		@parent = nil
		@g_cost = 0;
		@h_cost = 0;
	end

	def f_cost
		return @g_cost + @h_cost
	end

	def passable?
		return !@solid
	end

	def is_solid?
		return @solid
	end

	def set_state state, value
		case state
		when :solid
			@solid = value
		end
	end

	def set_parent parent
		@parent = parent
	end

	def pos axis = :all
		case axis
		when :all
			return {
				x: @x,
				y: @y
			}
		when :x, :left
			return @x
		when :x2, :right
			return @x + @w
		when :y, :top
			return @y
		when :y2, :bottom
			return @y + @h
		end
	end

	def size side = :all
		case side
		when :all
			return {
				w: @w,
				h: @h
			}
		when :w
			return @w
		when :h
			return @h
		end
	end

	def index target = :all
		case target
		when :all
			return {
				x: @index[:x],
				y: @index[:y]
			}
		when :x
			return @index[:x]
		when :y
			return @index[:y]
		end
	end
end

