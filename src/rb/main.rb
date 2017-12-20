
class Game < Gosu::Window
	attr_reader :room

	def initialize
		@x = @y = 0
		screen = $settings.screen
		@w = screen[:w]
		@h = screen[:h]
		@z = 0

		@level_name = (ARGV[0] || :first).to_sym

		super @w, @h
		self.caption = "Stealth Action Game"
	end

	### Initialize all game objects, after $game has been set
	def init
		## Preload all levels
		@levels = load_levels DIR[:levels]

=begin
		@room = TestRm.new(
			x: -100,
			y: -100,
			w: 500,
			h: 500
		)
=end

		@room = @levels[@level_name].rooms.first  unless (@levels[:first].nil?)

		## Add player
		#@player = Player.new x: 1700, y: 1250
		@player = Player.new x: @room.w / 2, y: @room.h / 2
		## Move camera to player
		$camera.move_to x: (@player.x - ($settings.screen(:w) / 2)), y: (@player.y - ($settings.screen(:h) / 2))
	end

	def load_levels dir = DIR[:levels]
		return nil  unless (Dir.exists? dir)
		levels = {}
		Dir.new(dir).each do |file|
			next  if (file =~ /\A\.{1,2}\z/)
			if (file =~ /\A\S+\.json\z/)
				content = JSON.parse(File.read(File.join(dir, file)))
				levels[file.sub(/\.json\Z/,"").to_sym] = Level.new(data: content)
			end
		end
		return levels
	end

	def button_down id
		close  if ($settings.controls(:close).include? id)
	end

	def update
		# Camera movement
		$settings.controls(:camera).each do |k,v|
			$camera.move k         if (v.map { |id| Gosu.button_down? id } .any?)
		end                      #if ($update_counter % 4 == 0)
		# Player movement
		dirs = []
		$settings.controls(:player)[:movement].each do |k,v|
			dirs << k  if (v.map { |id| Gosu.button_down? id } .any?)
		end                      if ($update_counter % 2 == 0)
		sneak = $settings.controls(:player)[:sneak].map { |sn| Gosu.button_down? sn } .any?
		@player.move dirs, sneak, 6  unless (dirs.empty?)

		# Update player
		#@player.update           if ($update_counter % 4 == 0)

		# Update room
		@room.update             if ($update_counter % 4 == 0 && !@room.nil?)

		$update_counter += 1
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, $settings.colors(:gray_darker), @z

		# Draw player
		@player.draw

		# Draw room
		@room.draw  unless (@room.nil?)
	end
end


$settings = Settings.new
# Camera - TMP
$camera = Camera.new
$update_counter = 0
$game = Game.new
$game.init
$game.show

