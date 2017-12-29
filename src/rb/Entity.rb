
class Entity
	include Collision

	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || $settings.entities(:w)
		@h = args[:h] || $settings.entities(:h)

		@image = nil

		@z = 30
		@c = $settings.colors(:gray)

		@vel = {
			x: 0, y: 0
		}

		@max_vel = $settings.entities(:max_vel)
		@vel_incr = $settings.entities(:vel_incr)
		@vel_decr = $settings.entities(:vel_decr)

		@collision_padding = nil
		@check_collision = false
		@camera_follows = false
		@solid = true

		init args  if (defined? init)
	end

	def pos axis = :all
		case axis
		when :all
			return {
				x: @x,
				y: @y
			}
		when :x, :left
			return @x
		when :x2, :right
			return @x + @w
		when :y, :top
			return @y
		when :y2, :bottom
			return @y + @h
		end
	end

	def size side = :all
		case side
		when :all
			return {
				w: @w,
				h: @h
			}
		when :w
			return @w
		when :h
			return @h
		end
	end

	def move sneak = false, vel = { x: @vel[:x], y: @vel[:y] }
		vel = vel.map do |axis,speed|
			next [axis, speed * @step_sneak]
		end .to_h  if (sneak)
		#step *= @step_sneak  if (sneak)

		## Check if player collides with any door

		#collision? target: :passable  if (@check_collision)
		collision? check: $game.room.get_instances(:passable)  if (@check_collision)

		moved_in = { x: false, y: false }
		max_speed = vel.map { |a,s| next s.abs } .max
		max_speed.round.times do |speed|
			vel.each do |axis,s|
				#next  if (s.abs <= speed)

				case axis
				when :x
					if    (s < 0)
						dir = :left
					elsif (s > 0)
						dir = :right
					end
				when :y
					if    (s < 0)
						dir = :up
					elsif (s > 0)
						dir = :down
					end
				end

				moved_in_tmp = false
				coll = @check_collision ? collision?(dir: dir, check: $game.room.get_instances(:solid)) : false
				case axis
				when :x
					unless (coll)
						if ((@x + s.sign) < 0 || (@x + s.sign) > ($game.room.w - @w))
							return
						end
						@x += s.sign                 if (s.abs >= speed || (s.abs < speed && !moved_in[:x]))
						unless (moved_in[:x])
							moved_in[:x] = true
							moved_in_tmp = true
						end
					end
					#@vel[:x] = @vel_incr[:x] * s.sign  if (coll)
				when :y
					unless (coll)
						if ((@y + s.sign) < 0 || (@y + s.sign) > ($game.room.h - @h))
							return
						end
						@y += s.sign                 if (s.abs >= speed || (s.abs < speed && !moved_in[:y]))
						unless (moved_in[:y])
							moved_in[:y] = true
							moved_in_tmp = true
						end
					end
					#@vel[:y] = @vel_incr[:y] * s.sign  if (coll)
				end

				if (coll && @collision_padding)
					collision_padded = false
					to_check = $game.room.get_instances(:solid)
					# Slide into hole - collision_padding
					if (@vel.map { |k,v| v.abs > 0 } .count(true) == 1)
						@collision_padding.times do |n|
							case dir
							when :up, :down
								if    ( !collision?(
												 check: to_check,
												 dir: dir,
												 x: (@x + n),
												 y: @y,
												 w: @w,
												 h: @h) )
									@x += n
									$camera.move :right, n  if (@camera_follows)
									collision_padded = true
									break
								elsif ( !collision?(
												 check: to_check,
												 dir: dir,
												 x: (@x - n),
												 y: @y,
												 w: @w,
												 h: @h) )
									@x -= n
									$camera.move :left, n   if (@camera_follows)
									collision_padded = true
									break
								end

							when :left, :right
								if    ( !collision?(
												 check: to_check,
												 dir: dir,
												 x: @x,
												 y: (@y + n),
												 w: @w,
												 h: @h) )
									@y += n
									$camera.move :down, n   if (@camera_follows)
									collision_padded = true
									break
								elsif ( !collision?(
												 check: to_check,
												 dir: dir,
												 x: @x,
												 y: (@y - n),
												 w: @w,
												 h: @h) )
									@y -= n
									$camera.move :up, n     if (@camera_follows)
									collision_padded = true
									break
								end
							end
						end
					end

					unless (collision_padded)
						case axis
						when :x
							@vel[:x] = @vel_incr[:x] * s.sign  if (coll)
						when :y
							@vel[:y] = @vel_incr[:y] * s.sign  if (coll)
						end
					end
				end

				# Move camera with player
				$camera.move dir, 1     if (!coll && (s.abs >= speed || s.abs < speed && moved_in_tmp))  if (@camera_follows)
			end
		end

		# Camera sticks to player
		#$camera.move_to(
		#	x: ((@x + (@w / 2)) - ($settings.screen(:w) / 2)),
		#	y: ((@y + (@h / 2)) - ($settings.screen(:h) / 2)),
		#)
	end

	def incr_vel dirs
		dirs.each do |dir|
			case dir
			when :up
				if (@vel[:y] > -@max_vel[:y])
					decr_vel [:y]  if (@vel[:y] > 0)
					@vel[:y] -= @vel_incr[:y]
				else
					@vel[:y] = -@max_vel[:y]
				end
			when :down
				if (@vel[:y] < @max_vel[:y])
					decr_vel [:y]  if (@vel[:y] < 0)
					@vel[:y] += @vel_incr[:y]
				else
					@vel[:y] = @max_vel[:y]
				end
			when :left
				if (@vel[:x] > -@max_vel[:x])
					decr_vel [:x]  if (@vel[:x] > 0)
					@vel[:x] -= @vel_incr[:x]
				else
					@vel[:x] = -@max_vel[:x]
				end
			when :right
				if (@vel[:x] < @max_vel[:x])
					decr_vel [:x]  if (@vel[:x] < 0)
					@vel[:x] += @vel_incr[:x]
				else
					@vel[:x] = @max_vel[:x]
				end
			end
		end
	end

	def decr_vel axes
		axes.each do |axis|
			next  if (@vel[axis] == 0)
			if    (@vel[axis] < 0)
				@vel[axis] += @vel_decr[axis]
				@vel[axis] = 0  if (@vel[axis] > 0)
			elsif (@vel[axis] > 0)
				@vel[axis] -= @vel_decr[axis]
				@vel[axis] = 0  if (@vel[axis] < 0)
			end
		end
	end

	def is_sneaking!
		@sneaking = true
	end
	def is_not_sneaking!
		@sneaking = false
	end

	def is_sneaking?
		return @sneaking
	end

	def update
		## Move entity
		move is_sneaking?

		update_custom  if (defined? update_custom)
	end

	def draw_pos axis
		case axis
		when :x
			return @x - $camera.x
		when :y
			return @y - $camera.y
		else
			return 0
		end
	end

	def draw_scale
		return 1  if (@image.nil?)
		return {
			x: (@w.to_f / @image.width.to_f),
			y: (@h.to_f / @image.height.to_f)
		}
	end

	def draw
		# Draw entity
		if (@image)
			scale = draw_scale
			@image.draw draw_pos(:x), draw_pos(:y), @z, scale[:x],scale[:y]
		elsif (@image.nil?)
			Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @c, @z
		end

		draw_custom  if (defined? draw_custom)
	end
end

