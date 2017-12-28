
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
	end

	def add_solids instances
		@grid.add_solids instances
	end

	def reset
		pathfind_init
	end

	def get_adjacent_cells args
		cell = args[:cell]
		grid = args[:grid]
		ret = []
		[-1,0,1].each do |row|
			[-1,0,1].each do |col|
				next  if (row == 0 && col == 0)
				found = find_cell(
					by:   :index,
					grid: grid,
					x:    (cell[:index][:x] + col),
					y:    (cell[:index][:y] + row)
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

	def draw
	end
end


class PathfindGrid
	def initialize args = {}
		@cell_size = {
			w: (args[:cell_size][:w] || 32),
			h: (args[:cell_size][:h] || 32)
		}

		@cells = gen_cells w: @cell_size[:w], h: @cell_size[:h]
	end

	## Generate cells for Pathfinding
	def gen_cells args = {}
		x = args[:x] || 0
		y = args[:y] || 0
		w = args[:w] || 32
		h = args[:h] || 32

		cell_count = {
			x: (current_room.w.to_f / w.to_f).floor,
			y: (current_room.h.to_f / h.to_f).floor
		}

		return cell_count[:y].times.map do |row|
			next cell_count[:x].times.map do |col|
				next PathfindCell.new(
					x: (w * col),
					y: (h * row),
					w: w, h: h,
					index: { x: col, y: row },
					solid: false
				)
			end
		end .flatten
	end

	def find_cell args
		ret = nil
		case args[:by]
		## Find cell by index
		when :index
			x = args[:x]
			y = args[:y]
			@cells.each do |cell|
				if (cell.index(:x) == x && cell.index(:y) == y)
					ret = cell
					break
				end
			end

		## Find cell by position
		when :pos
			x = args[:x]
			y = args[:y]
			@cells.each do |cell|
				if ((x >= cell.pos(:x) && x < (cell.pos(:x) + cell.size(:w)))
					  (y >= cell.pos(:y) && y < (cell.pos(:y) + cell.size(:h))) )
					ret = cell
					break
				end
			end
		end

		return ret
	end

	def add_solids instances
		instances.each do |instance|
			next  unless (instance.is_solid?)
			cell = find_cell by: :pos, x: instance.pos(:x), y: instance.pos(:y)
			next  if (cell.nil?)
			cell.set_state :solid, true
		end
	end

end


class PathfindCell
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

	def pos axis = :all
		case axis
		when :all
			return {
				x: @x,
				y: @y
			}
		when :x
			return @x
		when :y
			return @y
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
end

