
class Enemy < Entity
	def init args = {}
		@check_collision = true
		@c = $settings.colors :green
		@cur_dirs = [[:up,:down,:left,:right].sample]
		@update_counter_custom = 0

		@image = $settings.images :s_dev_worm
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

		@update_counter_custom += 1
	end
end

