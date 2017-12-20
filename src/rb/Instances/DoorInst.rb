
class DoorInst < Instance
	def init args = {}
		@solid = false
		@bg_outside = $settings.colors :red
		@bg_inside = $settings.colors :brown
		@bg = @bg_outside
		@z = 25
	end

	def is_inside!
		@bg = @bg_inside
	end

	def is_not_inside!
		@bg = @bg_outside
	end
end

