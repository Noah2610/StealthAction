
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
				if ((x >= cell.pos(:x) && x < (cell.pos(:x) + cell.size(:w))) &&
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

			colls = instance.collision? check: @cells
			unless (colls.nil?)
				colls.each do |coll|
					cell = find_cell by: :pos, x: coll.pos(:x), y: coll.pos(:y), return_on_found: true
					cell.set_state :solid, true  unless (cell.nil?)
				end
			end
		end
	end

	def draw
		@cells.each do |cell|
			if (cell.is_solid?)
				Gosu.draw_rect cell.pos(:x)+4-$camera.x,cell.pos(:y)+4-$camera.y, cell.size(:w)-8,cell.size(:h)-8, $settings.colors(:red), 100
			elsif (cell.passable?)
				Gosu.draw_rect cell.pos(:x)+4-$camera.x,cell.pos(:y)+4-$camera.y, cell.size(:w)-8,cell.size(:h)-8, $settings.colors(:green_dark), 100
			end
		end
	end
end

