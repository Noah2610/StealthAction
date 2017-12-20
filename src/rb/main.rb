
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
		#@levels = load_levels DIR[:levels]

		## Only load one level
		@level = load_level @level_name

		#@room = @levels[@level_name].rooms.first  unless (@levels[:first].nil?)
		@room = @level.get_room(:sample)

		## Add player
		#@player = Player.new x: 1700, y: 1250
		@player = Player.new x: @room.w / 2, y: @room.h / 2
		## Move camera to player
		$camera.move_to x: (@player.x - ($settings.screen(:w) / 2)), y: (@player.y - ($settings.screen(:h) / 2))
	end

	def load_level name, dir = DIR[:levels]
		return nil  if (name.nil?)
		return nil  unless (Dir.exists? dir)
		level = nil
		level_dir = File.join dir, name.to_s
		if (File.directory? level_dir)
			# Load config.yml
			config_path = File.join level_dir, "config.yml"
			if (File.file? config_path)
				config = YAML.load_file config_path
			else
				config = nil
			end
			rooms = {}
			# Load rooms json
			rooms_dir = File.join level_dir, "rooms"
			if (File.directory? rooms_dir)
				Dir.new(rooms_dir).map do |file|
					next nil  if (file =~ /\A\.{1,2}\z/)
					filepath = File.join rooms_dir, file
					# Load room data json
					rooms[file.sub(/\.json\z/,"").to_sym] = JSON.parse(File.read(filepath))  if (file =~ /\A\S+\.json\z/)
				end
			end
			level = Level.new(
				rooms:  rooms,
				config: config
			)
		end
		return level
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

