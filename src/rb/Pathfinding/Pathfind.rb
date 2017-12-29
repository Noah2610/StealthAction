
class Pathfind
	def initialize args = {}
	end

	def pathfind_init args = {}
		cell_size = args[:cell_size] || {
			w: (args[:w] || 32),
			h: (args[:h] || 32)
		}
		@grid = PathfindGrid.new cell_size: cell_size
	end

	def findpath args = {}
		entity = args[:entity]
		goal =   args[:to]
		return  if (entity.nil? || goal.nil?)
		start_cell = @grid.find_cell by: :pos, x: (entity.pos(:x) + (entity.size(:w).to_f / 2.0).floor), y: (entity.pos(:y) + (entity.size(:h).to_f / 2.0).floor)
		goal_cell = @grid.find_cell by: :pos, x: (goal.pos(:x) + (goal.size(:w).to_f / 2.0)), y: (goal.pos(:y) + (goal.size(:h).to_f / 2.0).floor)
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
				#if ((open_cell.f_cost < cell.f_cost) || (open_cell.f_cost == cell.f_cost && open_cell.h_cost < cell.h_cost))
				if ((open_cell.f_cost < cell.f_cost) || (open_cell.f_cost == cell.f_cost))
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

=begin
	def findpath args = {}
		return nil  if (args[:entity].nil? || args[:to].nil?)
		entity = args[:entity]
		to_x = args[:to][:x] || 512
		to_y = args[:to][:y] || 512
		cell_goal = find_cell by: :pos, grid: @grid, x: to_x, y: to_y
		x = @x + (@w.to_f / 2.0).round
		y = @y + (@h.to_f / 2.0).round

		coll = collision?(x: x, y: y, w: 2, h: 2, check: @grid).first
		@adjacent = get_adjacent_cells grid: @grid, cell: coll

		cell_vals = calc_values cells: @adjacent, cell_cur: coll, cell_goal: cell_goal
	end
=end

	def get_distance cell_a, cell_b
		dist_x = (cell_a.index(:x) - cell_b.index(:x)).abs
		dist_y = (cell_a.index(:y) - cell_b.index(:y)).abs
		return ((14 * dist_y) + (10 * (dist_x - dist_y)))  if (dist_x >= dist_y)
		return ((14 * dist_x) + (10 * (dist_y - dist_x)))  if (dist_y > dist_x)
	end

	def draw
	end
end

