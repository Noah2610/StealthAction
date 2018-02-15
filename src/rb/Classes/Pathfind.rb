
class Pathfinder
	def initialize args = {}
		@cell_size = args[:cell_size] || {
			w: (args[:w] || 32),
			h: (args[:h] || 32)
		}
		pathfind_init args
	end

	def pathfind_init args = {}
		@grid = Grid.new cell_size: @cell_size
		add_solids current_room.get_instances(:solid)
	end

	def findpath args = {}
		entity = args[:entity]
		goal =   args[:to]
		return  if (entity.nil? || goal.nil?)
		start_cell = @grid.find_cell by: :pos, x: (entity.pos(:x) + (entity.size(:w).to_f / 2.0).floor), y: (entity.pos(:y) + (entity.size(:h).to_f / 2.0).floor)
		goal_cell = @grid.find_cell by: :pos, x: (goal.pos(:x) + (goal.size(:w).to_f / 2.0)), y: (goal.pos(:y) + (goal.size(:h).to_f / 2.0).floor)
		return  if (start_cell.nil? || goal_cell.nil?)
		if (goal_cell.is_solid?)
			goal_cell = get_adjacent_cells(cell: goal_cell).map do |cell|
				next cell  if (cell.passable?)
			end .reject { |v| v.nil? } .sample
		end
		return  if (goal_cell.nil?)

		## Initialize open and closed sets of cells
		open_set = [start_cell]
		closed_set = []

		## Do pathfinding for one/current cell
		while (open_set.size > 0)
			cell = open_set.first
			open_set.each do |open_cell|
				if ((open_cell.f_cost < cell.f_cost) || (open_cell.f_cost == cell.f_cost && open_cell.h_cost < cell.h_cost))
					#if ((open_cell.f_cost < cell.f_cost) || (open_cell.f_cost == cell.f_cost))
					cell = open_cell  if (open_cell.h_cost < cell.h_cost)
				end
			end

			# Remove current cell from open_set and add to closed_set
			open_set.delete cell
			closed_set << cell

			# Return and calculate path if current cell is goal cell
			if (cell.pos == goal_cell.pos)
				# Retrace path, create path array, pathfinding complete
				path = retrace_path start_cell, goal_cell
				return path
			end

			## Check adjacent cells and calculate
			get_adjacent_cells(cell: cell).each do |adj|
				next  if (adj.is_solid? || closed_set.include?(adj))

				new_cost_to_adj = cell.g_cost + get_distance(cell, adj)
				if ((new_cost_to_adj < adj.g_cost) || !(open_set.include?(adj)))
					adj.g_cost = new_cost_to_adj
					adj.h_cost = get_distance adj, goal_cell
					adj.parent = cell

					open_set << adj  unless (open_set.include? adj)
				end
			end

		end
	end

	def retrace_path start_cell, end_cell
		path = []
		current_cell = end_cell
		while (current_cell != start_cell)
			path << current_cell
			current_cell = current_cell.parent
		end
		#path << start_cell
		return path.reverse
	end

	def add_solids instances
		@grid.add_solids instances
	end

	def reset
		pathfind_init
	end

	def get_adjacent_cells args
		cell = args[:cell]
		ret = []
		[-1,0,1].each do |row|
			[-1,0,1].each do |col|
				next  if (row == 0 && col == 0)
				found = @grid.find_cell(
					by:   :index,
					x:    (cell.index(:x) + col),
					y:    (cell.index(:y) + row)
				)
				ret << found  unless (found.nil?)
			end
		end
		return ret
	end

	def calc_values args = {}
		cells = args[:cells] || []
		cell_cur = args[:cell_cur] || nil
		cell_goal = args[:cell_goal] || nil
		x_start = cell_cur[:index][:x] || 0
		y_start = cell_cur[:index][:y] || 0
		x_end = cell_goal[:index][:x] || 0
		y_end = cell_goal[:index][:y] || 0

		val_mult = 10

		return cells.map do |cell|
			cx = cell[:index][:x]
			cy = cell[:index][:y]
			dist_start_x = ((x_start - cx).abs * val_mult).floor
			dist_start_y = ((y_start - cy).abs * val_mult).floor
			dist_end_x = ((x_end - cx).abs * val_mult).floor
			dist_end_y = ((y_end - cy).abs * val_mult).floor
			val_start = Math.sqrt((dist_start_x ** 2) + (dist_start_y ** 2))
			val_end = Math.sqrt((dist_end_x ** 2) + (dist_end_y ** 2))
			val = val_start + val_end
			next {
				cell: cell,
				val:  val
			}
		end
	end

	def get_distance cell_a, cell_b
		dist_x = (cell_a.index(:x) - cell_b.index(:x)).abs
		dist_y = (cell_a.index(:y) - cell_b.index(:y)).abs
		return ((14 * dist_y) + (10 * (dist_x - dist_y)))  if (dist_x >= dist_y)
		return ((14 * dist_x) + (10 * (dist_y - dist_x)))  if (dist_y > dist_x)
	end

	def draw
	end

	private

		## Include modules with classes
		include PathfinderExtension

end

