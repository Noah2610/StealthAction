
class Player
	attr_reader :x,:y, :vel

	def initialize args = {}
		if (args[:spawn])
			puts args[:spawn]
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
		@collision_padding = $settings.player(:collision_padding)  # if only n pixels to a side are colliding and center is free, let the player move and adjust potition
		@step_sneak = $settings.player(:step_sneak)

		@step = args[:step] || $settings.player(:step)
		@sneaking = false

		@vel = {
			x: 0, y: 0
		}
		@max_vel = $settings.player(:max_vel)
		@vel_incr = $settings.player(:vel_incr)
		@vel_decr = $settings.player(:vel_decr)
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

	def collision? dir = nil, x = @x.dup, y = @y.dup, w = @w.dup, h = @h.dup, target: :solid
		case target
		## Default wall collision checking, solid instances
		when :solid
			collision = false
			$game.room.solid_instances.each do |instance|
				## Check inside player if instance is smaller

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

			collision.yes_collision  if (collision)
			return collision

		## Check passable, non-solid instances only
		when :passable, :not_solid
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
					instance.no_collision
				end
			end

			collisions.each &:yes_collision
			return collisions

		## Check doors - TODO deprecated, using passable collision checking for doors ^
		when :door, :doors
			collisions = []
			$game.room.get_instances(:doors).each do |instance|

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
					instance.is_inside!
					collisions << instance
				else
					instance.is_outside!
				end

			end

			return collisions
		end

		return false
	end

	#def move dirs, sneak = false, step = { x: vel[:x].abs, y: vel[:y].abs }
	def move sneak = false, vel = { x: @vel[:x], y: @vel[:y] }
		vel = vel.map do |axis,speed|
			next [axis, speed * @step_sneak]
		end .to_h  if (sneak)
		#step *= @step_sneak  if (sneak)

		## Check if player collides with any door

		collision? target: :passable

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
				coll = collision? dir
				case axis
				when :x
					unless (coll)
						@x += s.sign                 if (s.abs >= speed || (s.abs < speed && !moved_in[:x]))
						unless (moved_in[:x])
							moved_in[:x] = true
							moved_in_tmp = true
						end
					end
					@vel[:x] = @vel_incr[:x] * s.sign  if (coll)
				when :y
					unless (coll)
						@y += s.sign                 if (s.abs >= speed || (s.abs < speed && !moved_in[:y]))
						unless (moved_in[:y])
							moved_in[:y] = true
							moved_in_tmp = true
						end
					end
					@vel[:y] = @vel_incr[:y] * s.sign  if (coll)
				end

				# Move camera with player
				$camera.move dir, 1     if (!coll && (s.abs >= speed || s.abs < speed && moved_in_tmp))
			end
		end

=begin
		step.round.times do |s|
			dirs.each do |dir|
				unless (collision? dir)
					case dir
					when :up
						@y -= 1
					when :down
						@y += 1
					when :left
						@x -= 1
					when :right
						@x += 1
					end

					# Camera moves with player
					$camera.move dir, 1  unless (dir.nil?)

				else
					# Collision
					# Slide into hole - collision_padding
					if (dirs.size == 1)
						@collision_padding.times do |n|
							case dir
							when :up, :down
								if    ( !collision?(
												 dir,
												 @x + n, @y,
												 @w, @h) )
									@x += n
									$camera.move :right, n
									break
								elsif ( !collision?(
												 dir,
												 @x - n, @y,
												 @w, @h) )
									@x -= n
									$camera.move :left, n
									break
								end

							when :left, :right
								if    ( !collision?(
												 dir,
												 @x, @y + n,
												 @w, @h) )
									@y += n
									$camera.move :down, n
									break
								elsif ( !collision?(
												 dir,
												 @x, @y - n,
												 @w, @h) )
									@y -= n
									$camera.move :up, n
									break
								end
							end
						end
					end
				end

			end
		end
=end

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
					@vel[:y] -= @vel_incr[:y]
				else
					@vel[:y] = -@max_vel[:y]
				end
			when :down
				if (@vel[:y] < @max_vel[:y])
					@vel[:y] += @vel_incr[:y]
				else
					@vel[:y] = @max_vel[:y]
				end
			when :left
				if (@vel[:x] > -@max_vel[:x])
					@vel[:x] -= @vel_incr[:x]
				else
					@vel[:x] = -@max_vel[:x]
				end
			when :right
				if (@vel[:x] < @max_vel[:x])
					@vel[:x] += @vel_incr[:x]
				else
					@vel[:x] = @max_vel[:x]
				end
			end
		end
	end

	def decr_vel axes
		axes.each do |axis|
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
		## Move player
		move is_sneaking?
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
		# Draw player
		Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @c, @z
	end
end

