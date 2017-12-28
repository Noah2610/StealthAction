
class Enemy < Entity
	def init args = {}
		@check_collision = true
		@c = $settings.colors :green
		@cur_dirs = [[:up,:down,:left,:right].sample]
		@update_counter_custom = 0

		@image = $settings.images :s_dev_worm

		pathfind_init
	end

	def pathfind_gen_grid args
		x = args[:x] || 0
		y = args[:y] || 0
		w = args[:w] || @w
		h = args[:h] || @h

		grid_count = {
			x: ($game.room.w.to_f / w.to_f).floor,
			y: ($game.room.h.to_f / h.to_f).floor
		}

		return grid_count[:y].times.map do |row|
			next grid_count[:x].times.map do |col|
				next {
					x: (w * col),
					y: (h * row),
					w: w, h: h,
					index: { x: col, y: row }
				}
			end
		end .flatten
	end

	def pathfind_find_cell args
		case args[:by]
		## Find cell by index
		when :index
			grid = args[:grid]
			x = args[:x]
			y = args[:y]
			ret = nil
			grid.each do |cell|
				if (cell[:index][:x] == x && cell[:index][:y] == y)
					ret = cell
					break
				end
			end

		## Find cell by position
		when :pos
			grid = args[:grid]
			x = args[:x]
			y = args[:y]
			ret = nil
			grid.each do |cell|
				if ((x >= cell[:x] && x < (cell[:x] + cell[:w]))
					  (y >= cell[:y] && y < (cell[:y] + cell[:h])) )
					ret = cell
					break
				end
			end
		end

		return ret
	end

	def pathfind_get_adjacent args
		cell = args[:cell]
		grid = args[:grid]
		ret = []
		[-1,0,1].each do |row|
			[-1,0,1].each do |col|
				next  if (row == 0 && col == 0)
				found = pathfind_find_cell(
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

	def pathfind_calc_values args = {}
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

	def pathfind_to args = {}
		to_x = args[:x] || 512
		to_y = args[:y] || 512
		cell_goal = pathfind_find_cell by: :pos, grid: @grid, x: to_x, y: to_y
		x = @x + (@w.to_f / 2.0).round
		y = @y + (@h.to_f / 2.0).round

		coll = collision?(x: x, y: y, w: 2, h: 2, check: @grid).first
		@adjacent = pathfind_get_adjacent grid: @grid, cell: coll

		cell_vals = pathfind_calc_values cells: @adjacent, cell_cur: coll, cell_goal: cell_goal
	end

	def pathfind_init args = {}
		w = args[:w] || 32
		h = args[:h] || 32
		@grid = pathfind_gen_grid w: w, h: h
	end

	def ch_dirs
		new_dirs = []
		if (@x >= 0 && @x < $game.room.w &&
			  @y >= 0 && @y < $game.room.h)
			new_dirs = rand(1..2).times.map do |n|
				next [:up,:down,:left,:right].sample
			end

		# Stay inside room
		else
			if (@x < 0)
				new_dirs << :right
			elsif (@x > $game.room.w)
				new_dirs << :left
			end
			if (@y < 0)
				new_dirs << :down
			elsif (@y > $game.room.h)
				new_dirs << :up
			end
		end
		@cur_dirs = new_dirs.uniq
	end

	def update_custom
		ch_dirs  if (@update_counter_custom % 32 == 0)

		incr_vel @cur_dirs

		pathfind_to

		@update_counter_custom += 1
	end

	def draw_custom
		if (@adjacent)
			@adjacent.each do |adj|
				Gosu.draw_rect adj[:x]-$camera.x,adj[:y]-$camera.y,adj[:w],adj[:h], Gosu::Color.argb(0xff_ff0000), 100
			end
		end
	end
end

