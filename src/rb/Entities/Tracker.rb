
class Tracker < Entity
	def init args = {}
		@image = $settings.images :s_dev_worm
		@path = nil
		@update_counter = 0
	end

	def pathfind args = {}
		return  if (args[:to].nil?)
		return pathfinder.findpath entity: self, to: args[:to]
	end

	def update_custom
		if (@update_counter % 30 == 0)
			@path = pathfind to: player
		end

		@update_counter += 1
	end

	def draw_custom
		unless (@path.nil?)
			@path.each do |cell|
				Gosu.draw_rect (cell.pos(:x)-4-$camera.x),(cell.pos(:y)-4-$camera.y), (cell.size(:w)-8),(cell.size(:h)-8), $settings.colors(:red_light), 100
			end
		end
	end
end

