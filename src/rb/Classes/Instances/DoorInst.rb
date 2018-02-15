
class DoorInst < Instance
	def init args = {}
		@solid = false
		@bg_outside = $settings.colors :red
		@bg_inside = $settings.colors :brown
		@bg = @bg_outside
		@z = 25
		#@z = 35
		@in_collision_with = []
	end

	def yes_collision with = nil
		@in_collision_with << with  unless (with.nil? || @in_collision_with.include?(with))
		@bg = @bg_inside   unless (@bg == @bg_inside)
	end
	def no_collision with = nil
		@in_collision_with.delete with  unless (with.nil?)
		@bg = @bg_outside  unless (@bg == @bg_outside || @in_collision_with.any?)
	end
end

