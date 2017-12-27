
class WallSimpleInst < Instance
	def init args = {}
		@solid = true
		@image = $settings.images :s_dev_stone
	end
end

