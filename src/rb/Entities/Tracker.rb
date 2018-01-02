
class Tracker < Entity
	def init args = {}
		@image = $settings.images :s_dev_worm
		@path = nil
		@pathfinder = Pathfind.new
		@check_collision = true

		@max_vel = { x: 2, y: 2 }
		@vel_incr = { x: 0.5, y: 0.5 }

		@update_counter_custom = 0
	end

=begin
	def reset
		@pathfinder = Pathfind.new
	end
=end

	def find_cell args
		ret = nil
		case args[:by]
		## Find cell by index
		when :index
			x = args[:x]
			y = args[:y]
			@path.each do |cell|
				if (cell.index(:x) == x && cell.index(:y) == y)
					ret = cell
					break
				end
			end

		## Find cell by position
		when :pos
			x = args[:x]
			y = args[:y]
			@path.each do |cell|
				if ((x >= cell.pos(:x) && x < (cell.pos(:x) + cell.size(:w))) &&
					  (y >= cell.pos(:y) && y < (cell.pos(:y) + cell.size(:h))) )
					ret = cell
					break
				end
			end
		end

		return ret
	end

	def find_closest_cell args
		x = args[:x] || 0
		y = args[:y] || 0
		ret = nil
		case args[:by]
		when :pos
			shortest = {}
			@path.each do |cell|
				distance = (@x - cell.pos(:x)).abs + (@y - cell.pos(:y)).abs
				if (shortest.empty? || distance < shortest[:distance])
					shortest[:distance] = distance
					shortest[:cell] = cell
				end
			end
			ret = shortest[:cell]
		end
		return ret
	end

	def pathfind args = {}
		return  if (args[:to].nil?)
		return @pathfinder.findpath entity: self, to: args[:to]
	end

	## Move to next path point
	def move_path
		## Find current or next cell
		#cell = find_cell by: :pos, x: @x, y: @y, return_on_found: true
		cell = find_closest_cell by: :pos, x: @x, y: @y  unless (@path.nil?)
		if (cell.nil? || @path.nil?)
			decr_vel [:x,:y]
			return
		end

		## Move towards point
		vels = []
		# Move up
		if (cell.pos(:y) < @y)
			vels << :up

		# Move down
		elsif (cell.pos(:y) > @y)
			vels << :down
		end

		# Move left
		if (cell.pos(:x) < @x)
			vels << :left

		# Move right
		elsif (cell.pos(:x) > @x)
			vels << :right
		end

		incr_vel vels
		@path.delete cell  if (((@x-8)..(@x+8)).include?(cell.pos(:x)) && ((@y-8)..(@y+8)).include?(cell.pos(:y)))
	end

	def update_custom

		#if (@update_counter_custom % 120 == 0)
			#puts "#{@id}"
		#end

		## Update pathfind path
		@path = pathfind to: player  if (@update_counter_custom % @pathfind_interval == 0)

		move_path                    if (@update_counter_custom % @move_interval)

		@update_counter_custom += 1
	end

	def draw_custom
		unless (@path.nil?)
			@path.each do |cell|
				Gosu.draw_rect (cell.pos(:x)-4-$camera.x),(cell.pos(:y)-4-$camera.y), (cell.size(:w)-8),(cell.size(:h)-8), $settings.colors(:red_light), 100
			end
			# DEV - draw next cell
			cell = find_closest_cell by: :pos, x: @x, y: @y
			Gosu.draw_rect cell.pos(:x)+8-$camera.x,cell.pos(:y)+8-$camera.y, cell.size(:w)-16,cell.size(:h)-16, $settings.colors(:green_light), 200  unless (cell.nil?)
		end
	end
end

