
class Enemy < Entity
	def init args = {}
		@check_collision = true
		@c = $settings.colors :green
		@cur_dirs = [[:up,:down,:left,:right].sample]
	end

	def ch_dirs
		new_dirs = []
		if (@x >= 0 && @x < current_room.w &&
			  @y >= 0 && @y < current_room.h)
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
		ch_dirs  if ($update_counter % 32 == 0)

		# Decrease velocities
		decr_axes = []
		decr_axes << :x  unless (@cur_dirs.include?(:left) || @cur_dirs.include?(:right))
		decr_axes << :y  unless (@cur_dirs.include?(:up) || @cur_dirs.include?(:down))
		decr_vel decr_axes

		incr_vel @cur_dirs
	end
end

