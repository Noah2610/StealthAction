
class PassableInst < Instance
	def init args = {}
		@solid = false
		@bg = $settings.colors :blue_light
	end
end

