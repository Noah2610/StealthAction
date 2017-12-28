
class Tracker < Entity
	def init args = {}
		@image = $settings.images :s_dev_worm
		@update_counter = 0
	end

	def pathfind args = {}
		return  if (args[:to].nil?)
		pathfinder.findpath entity: self, to: args[:to]
	end

	def update_custom
		#pathfind to: player.pos  if (@update_counter % 60 == 0)

		@update_counter += 1
	end
end

