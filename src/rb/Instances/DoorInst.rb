
class DoorInst < Instance
	def init args = {}
		@solid = false
		@bg_outside = $settings.colors :red
		@bg_inside = $settings.colors :brown
		@bg = @bg_outside
		@z = 25
		#@z = 35
	end

	def yes_collision
		@bg = @bg_inside   unless (@bg == @bg_inside)
	end
	def no_collision
		@bg = @bg_outside  unless (@bg == @bg_outside)
	end
end

