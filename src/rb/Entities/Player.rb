
class Player < Entity
	attr_reader :vel

	def init args = {}
		if (args[:spawn])
			@x = args[:spawn].pos(:x)
			@y = args[:spawn].pos(:y)
		else
			@x = args[:x] || 0  #$settings.screen(:w) / 2
			@y = args[:y] || 0  #$settings.screen(:h) / 2
		end
		@w = args[:w] || $settings.player(:w)
		@h = args[:h] || $settings.player(:h)

		@z = 30
		@c = $settings.colors(:blue)
		#@collision_padding = $settings.player(:collision_padding)  # if only n pixels to a side are colliding and center is free, let the player move and adjust potition
		@collision_padding = (@w.to_f / $settings.player(:collision_padding).to_f).round
		@step_sneak = $settings.player(:step_sneak)

		@step = args[:step] || $settings.player(:step)
		@sneaking = false

		@vel = {
			x: 0, y: 0
		}
		@max_vel = $settings.player(:max_vel)
		@vel_incr = $settings.player(:vel_incr)
		@vel_decr = $settings.player(:vel_decr)

		@check_collision = true
		@camera_follows = true
	end

	def move_to_spawn spawn
		return if (spawn.nil?)
		@x = spawn.pos :x
		@y = spawn.pos :y
		## Move camera to player
		$camera.center_on x: @x, y: @y
	end
end

