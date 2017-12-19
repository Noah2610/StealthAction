

class ::Integer
	def sign
		return (self / self.abs)  unless (self == 0)
		return self
	end
end
class ::Float
	def sign
		return (self / self.abs)  unless (self == 0.0)
		return self
	end
end


class Game < Gosu::Window
	attr_reader :room

	def initialize
		@x = @y = 0
		screen = $settings.screen
		@w = screen[:w]
		@h = screen[:h]
		@z = 0

		super @w, @h
		self.caption = "Stealth Action Game"
	end

	### Initialize all game objects, after $game has been set
	def init
		@room = TestRm.new(
			x: -100,
			y: -100,
			w: 500,
			h: 500
		)

		@player = Player.new
	end

	def button_down id
		close  if ($settings.controls(:close).include? id)
	end

	def update
		# Camera movement - TMP
		$settings.controls(:camera).each do |k,v|
			$camera.move k         if (v.map { |id| Gosu.button_down? id } .any?)
		end                      if ($update_counter % 4 == 0)
		# Player movement
		dirs = []
		$settings.controls(:player)[:movement].each do |k,v|
			dirs << k  if (v.map { |id| Gosu.button_down? id } .any?)
		end                      if ($update_counter % 4 == 0)
		sneak = $settings.controls(:player)[:sneak].map { |sn| Gosu.button_down? sn } .any?
		@player.move dirs, sneak

		# Update player
		@player.update           if ($update_counter % 4 == 0)

		# Update room
		@room.update             if ($update_counter % 4 == 0)

		$update_counter += 1
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, $settings.colors(:gray_darker), @z

		# Draw player
		@player.draw

		# Draw room
		@room.draw
	end
end


$settings = Settings.new
# Camera - TMP
$camera = Camera.new
$update_counter = 0
$game = Game.new
$game.init
$game.show

