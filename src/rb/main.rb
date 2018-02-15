
class Game < Gosu::Window
	attr_reader :room, :player, :entities, :song

	def initialize
		@x = @y = 0
		screen = $settings.screen
		@w = screen[:w]
		@h = screen[:h]
		@z = 0

		@level_name = (ARGV[0] || :dev).to_sym
		@room_name = (ARGV[1] || :sample).to_sym

		super @w, @h
		self.caption = "Stealth Action Game"
	end

	### Initialize all game objects, after $game has been set
	def init
		## Pathfind
		#@pathfind = Pathfind.new

		## Add player
		@player = Player.new #spawn: @room.get_spawn

		## Song controller
		@song = SongController.new

		## Only load one level
		@level = load_level @level_name

		#@room = @levels[@level_name].rooms.first  unless (@levels[:first].nil?)
		@room = @level.get_room @room_name
		@player.move_to_spawn @room.get_spawn

		puts "Level: #{@level.name}"
		puts "  Room: #{@room.name}"
		puts "INSTANCE_COUNT:\n\tsolid:\t\t#{@room.instances[:solid].size}"
		puts "\tpassable:\t#{@room.instances[:passable].size}"

		## Init Pathfinder
		#@pathfind.pathfind_init
		## Add Solid blocks to pathfind grid (bootstrap it)
		#@pathfind.add_solids @room.get_instances(:solid)

		tracker0 = Tracker.new pos: @player.pos, track: @player
		tracker1 = Tracker.new pos: @player.pos, track: tracker0
		tracker2 = Tracker.new pos: @player.pos, track: tracker1
		tracker3 = Tracker.new pos: @player.pos, track: tracker2
		tracker4 = Tracker.new pos: @player.pos, track: tracker3
		tracker5 = Tracker.new pos: @player.pos, track: tracker4

		@entities = [
			@player,
			Enemy.new,
			tracker0, tracker1, tracker2, tracker3, tracker3, tracker4, tracker5
		]

		## Move camera to player
		$camera.center_on x: @player.pos(:x), y: @player.pos(:y)

		## Font for FPS display
		@font_fps = Gosu::Font.new 32

		## For consequtive updating of entities, instead of all at once
		#@update_entity_index = 0
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

	def switch_level name = :sample
		@level = load_level name
	end

	def switch_room name = :sample
		@room = @level.get_room name
		@player.move_to_spawn @room.get_spawn
		@entities.each &:reset
=begin
		if (pathfinder)
			pathfinder.reset
			pathfinder.add_solids @room.get_instances(:solid)
		end
=end
	end

	def button_down id
		close  if ($settings.controls(:close).include? id)

		# New random room
		unless (@level.nil?)
			if ($settings.controls(:random_room).include? id)
				switch_level
				switch_room
				puts "Level: #{@level.name}"
				puts "  Room: #{@room.name}"
				puts "INSTANCE_COUNT:\n\tsolid:\t\t#{@room.instances[:solid].size}"
				puts "\tpassable:\t#{@room.instances[:passable].size}"
			end
		end
	end

	def update
		## Camera movement
		$settings.controls(:camera).each do |k,v|
			$camera.move k         if (v.map { |id| Gosu.button_down? id } .any?)
		end                      #if ($update_counter % 4 == 0)
		## Player movement
		if ($update_counter % $settings.player(:move_interval) == 0)
			dirs = []
			$settings.controls(:player)[:movement].each do |k,v|
				dirs << k  if (v.map { |id| Gosu.button_down? id } .any?)
			end
			## Add velocity to player
			@player.incr_vel dirs    #if ($update_counter % $settings.player(:move_interval) == 0)

			## If player is sneaking
			if ($settings.controls(:player)[:sneak].map { |sn| Gosu.button_down? sn } .any?)
				@player.is_sneaking!
			else
				@player.is_not_sneaking!
			end

			## Slow down player if not accelerating
			decr_axes = []
			decr_axes << :x    unless (dirs.include?(:left) || dirs.include?(:right))
			decr_axes << :y    unless (dirs.include?(:up) || dirs.include?(:down))
			#decr_dirs = []
			#decr_dirs << :up     unless (dirs.include?(:up))
			#decr_dirs << :down   unless (dirs.include?(:down))
			#decr_dirs << :left   unless (dirs.include?(:left))
			#decr_dirs << :right  unless (dirs.include?(:right))
			@player.decr_vel decr_axes
		end

		#@player.move dirs, sneak, 6  unless (dirs.empty?)

		# Update entities (and player)
		@entities.each &:update           #if ($update_counter % 4 == 0)
		#@entities[@update_entity_index].update
		#@update_entity_index += 1
		#@update_entity_index = 0  if (@update_entity_index >= @entities.size)

		# Update room
		@room.update              if ($update_counter % 4 == 0 && !@room.nil?)

=begin
		if ($update_counter % 16 == 0)
			puts @player.vel.to_s
		end
=end

		$update_counter += 1
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, $settings.colors(:gray_darker), @z

		# Draw entities (and player)
		@entities.each &:draw

		# Draw room
		@room.draw  unless (@room.nil?)

		# Draw pathfind cells
		#@pathfind.draw

		# Draw FPS display
		@font_fps.draw Gosu.fps.to_s, 64,64,100, 1,1, $settings.colors(:red_light)
	end
end


$settings = Settings.new
# Camera - TMP
$camera = Camera.new
$update_counter = 0
$game = Game.new
$game.init
$game.show

