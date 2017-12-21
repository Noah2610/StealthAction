
class Game < Gosu::Window
	attr_reader :room, :player

	def initialize
		@x = @y = 0
		screen = $settings.screen
		@w = screen[:w]
		@h = screen[:h]
		@z = 0

		@level_name = (ARGV[0] || :sample).to_sym
		@room_name = (ARGV[1] || :sample).to_sym

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
		@room = @level.get_room(@room_name)

		puts "Level: #{@level.name}"
		puts "  Room: #{@room.name}"

		## Add player
		#@player = Player.new x: @room.w / 2, y: @room.h / 2
		@player = Player.new spawn: @room.get_spawn

		## Move camera to player
		$camera.move_to x: (@player.x - ($settings.screen(:w) / 2)), y: (@player.y - ($settings.screen(:h) / 2))
	end

	def load_level name = :sample, dir = DIR[:levels]
		return nil  if (name.nil?)
		name = random_level_name  if (name.to_s =~ /sample|random/)
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
				config: config,
				name:   name
			)
		end
		return level
	end

	def random_level_name dir = DIR[:levels]
		return  unless (File.directory? dir)
		return Dir.new(dir).map do |file|
			filepath = File.join dir, file
			next nil  if (File.file?(filepath) || file =~ /\A\.{1,2}\z/)
			next file.to_sym
		end .reject { |v| v.nil? } .sample
	end

	def button_down id
		close  if ($settings.controls(:close).include? id)

		# New random room
		unless (@level.nil?)
			if ($settings.controls(:random_room).include? id)
				@level = load_level :sample
				@room = @level.get_room :sample
				puts "Level: #{@level.name}"
				puts "  Room: #{@room.name}"
			end
		end
	end

	def update
		## Camera movement
		$settings.controls(:camera).each do |k,v|
			$camera.move k         if (v.map { |id| Gosu.button_down? id } .any?)
		end                      #if ($update_counter % 4 == 0)
		## Player movement
		dirs = []
		$settings.controls(:player)[:movement].each do |k,v|
			dirs << k  if (v.map { |id| Gosu.button_down? id } .any?)
		end                      if ($update_counter % 2 == 0)
		@player.incr_vel dirs    if ($update_counter % $settings.player(:move_interval) == 0)  # Add velocity to player
		## If player is sneaking
		if ($settings.controls(:player)[:sneak].map { |sn| Gosu.button_down? sn } .any?)
			@player.is_sneaking!
		else
			@player.is_not_sneaking!
		end
		## Slow down player if not accelerating
		decr_axes = []
		decr_axes << :x    unless (dirs.include?(:left) || dirs.include?(:right))  if ($update_counter % $settings.player(:move_interval) == 0)
		decr_axes << :y    unless (dirs.include?(:up) || dirs.include?(:down))     if ($update_counter % $settings.player(:move_interval) == 0)
		@player.decr_vel decr_axes

		#@player.move dirs, sneak, 6  unless (dirs.empty?)

		# Update player
		@player.update           #if ($update_counter % 4 == 0)

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

