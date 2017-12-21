
class SpawnInst < Instance
	def init args = {}
		@solid = false
		@check_collision = false
		@bg = $settings.colors :yellow
	end
end

