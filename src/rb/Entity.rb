
class Entity
	attr_reader :x,:y

	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || $settings.entities(:w)
		@h = args[:h] || $settings.entities(:h)

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

	def set_inst instance
		return {
			x:  instance.pos(:x),
			x2: instance.pos(:x2),
			y:  instance.pos(:y),
			y2: instance.pos(:y2)
		}
	end

	def check_smaller instance
		return {
			w: (@w.to_f / instance.w.to_f).ceil,
			h: (@h.to_f / instance.h.to_f).ceil
		}
	end

	def collision? args
		to_check = args[:check] || []
		dir = args[:dir] || nil
		x = args[:x] || @x.dup
		y = args[:y] || @y.dup
		w = args[:w] || @w.dup
		h = args[:h] || @h.dup

		## Moving (solid instances)
		if (dir)
			collision = false
			to_check.each do |instance|
				inst = set_inst instance
				smaller = check_smaller instance

				case dir
				when :up
					if (smaller[:w] > 1)
						if (@x < inst[:x] && (@x + @w) > inst[:x2])
							inst[:x] -= @w
							inst[:x2] += @w
						end
					end

					if (  ((y) <= inst[:y2])        &&
								((y) > inst[:y])          &&
							((((x) < inst[:x2])         &&
								((x) >= inst[:x])       ) ||
							 (((x + w) <= inst[:x2])    &&
								((x + w) > inst[:x])    ) ))
						collision = instance
						break
					end
				when :down
					if (smaller[:w] > 1)
						if (@x < inst[:x] && (@x + @w) > inst[:x2])
							inst[:x] -= @w
							inst[:x2] += @w
						end
					end

					if (  ((y + h) < inst[:y2])     &&
								((y + h) >= inst[:y])     &&
							((((x) < inst[:x2])         &&
								((x) >= inst[:x])       ) ||
							 (((x + w) <= inst[:x2])    &&
								((x + w) > inst[:x])    ) ))
						collision = instance
						break
					end
				when :left
					if (smaller[:h] > 1)
						if (@y < inst[:y] && (@y + @h) > inst[:y2])
							inst[:y] -= @h
							inst[:y2] += @h
						end
					end

					if (  ((x) <= inst[:x2])        &&
								((x) > inst[:x])          &&
							((((y) < inst[:y2])         &&
								((y) >= inst[:y])       ) ||
							 (((y + h) <= inst[:y2])    &&
								((y + h) > inst[:y])    ) ))
						collision = instance
						break
					end
				when :right
					if (smaller[:h] > 1)
						if (@y < inst[:y] && (@y + @h) > inst[:y2])
							inst[:y] -= @h
							inst[:y2] += @h
						end
					end

					if (  ((x + w) < inst[:x2])     &&
								((x + w) >= inst[:x])     &&
							((((y) < inst[:y2])         &&
								((y) >= inst[:y])       ) ||
							 (((y + h) <= inst[:y2])    &&
								((y + h) > inst[:y])    ) ))
						collision = instance
						break
					end
				end
			end

			collision.yes_collision self  if (collision)
			return collision

		## Not moving, (passable instances)
		else
			collisions = []
			$game.room.passable_instances.each do |instance|

				inst = set_inst instance
				smaller = check_smaller instance

				if (smaller[:w] > 1)
					if (@x < inst[:x] && (@x + @w) > inst[:x2])
						inst[:x] -= @w
						inst[:x2] += @w
					end
				end
				if (smaller[:h] > 1)
					if (@y < inst[:y] && (@y + @h) > inst[:y2])
						inst[:y] -= @h
						inst[:y2] += @h
					end
				end

				if (((((y) <= inst[:y2])         &&
							((y) >= inst[:y])        ) ||
						 (((y + h) <= inst[:y2])     &&
						  ((y + h) >= inst[:y])   )) &&
						((((x) <= inst[:x2])         &&
							((x) >= inst[:x])        ) ||
						 (((x + w) <= inst[:x2])     &&
							((x + w) >= inst[:x])   ))  )
					collisions << instance
				else
					instance.no_collision self
				end
			end

			#collisions.each &:yes_collision
			collisions.each { |c| c.yes_collision self }
			return collisions

		end
	end

	#def move dirs, sneak = false, step = { x: vel[:x].abs, y: vel[:y].abs }
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
					# Slide into hole - collision_padding
					if (@vel.map { |k,v| v.abs > 0 } .count(true) == 1)
						@collision_padding.times do |n|
							case dir
							when :up, :down
								if    ( !collision?(
												 check: $game.room.get_instances(:solid),
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
												 check: $game.room.get_instances(:solid),
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
												 check: $game.room.get_instances(:solid),
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
												 check: $game.room.get_instances(:solid),
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

	def draw
		# Draw entity
		Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @c, @z

		draw_custom  if (defined? draw_custom)
	end
end

