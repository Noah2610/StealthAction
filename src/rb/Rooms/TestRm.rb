
class TestRm < Room
	def init args = {}
		@instances = [
			WallSimpleInst.new(
				room:  self,
				x: 64,
				y: 64,
				w: 144,
				h: 64
			),
			WallSimpleInst.new(
				room:  self,
				x: 240,
				y: 64,
				w: 144,
				h: 64
			),
			WallSimpleInst.new(
				room:  self,
				x: 64,
				y: 160,
				w: 144,
				h: 128
			),
			WallSimpleInst.new(
				room:  self,
				x: 240,
				y: 160,
				w: 144,
				h: 128
			)
		]
	end
end

