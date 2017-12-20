
class Player
	def initialize args = {}
		@x = args[:x] || $settings.screen(:w) / 2
		@y = args[:y] || $settings.screen(:h) / 2
		@w = args[:w] || $settings.player(:w)
		@h = args[:h] || $settings.player(:h)

		@z = 30
		@c = $settings.colors(:blue)
		@collision_padding = 8  # if only n pixels to a side are colliding and center is free, let the player move and adjust potition

		@step = args[:step] || $settings.player(:step)
	end

	def collision? dir, x = @x, y = @y, w = @w, h = @h
		$game.room.solid_instances.each do |instance|
			case dir
			when :up
				if (  ((y) <= instance.pos(:bottom))       &&
							((y) > instance.pos(:top))           &&
						((((x) < instance.pos(:right))         &&
							((x) >= instance.pos(:left))        ) ||
						 (((x + w) <= instance.pos(:right))     &&
							((x + w) > instance.pos(:left))    ) ))
					return true
				end
			when :down
				if (  ((y + h) < instance.pos(:bottom))    &&
							((y + h) >= instance.pos(:top))      &&
						((((x) < instance.pos(:right))         &&
							((x) >= instance.pos(:left))        ) ||
						 (((x + w) <= instance.pos(:right))     &&
							((x + w) > instance.pos(:left))    ) ))
					return true
				end
			when :left
				if (  ((x) <= instance.pos(:right))        &&
							((x) > instance.pos(:left))          &&
						((((y) < instance.pos(:bottom))        &&
							((y) >= instance.pos(:top))         ) ||
						 (((y + h) <= instance.pos(:bottom))    &&
							((y + h) > instance.pos(:top))     ) ))
					return true
				end
			when :right
				if (  ((x + w) < instance.pos(:right))     &&
							((x + w) >= instance.pos(:left))     &&
						((((y) < instance.pos(:bottom))        &&
							((y) >= instance.pos(:top))         ) ||
						 (((y + h) <= instance.pos(:bottom))    &&
							((y + h) > instance.pos(:top))     ) ))
					return true
				end
			end
		end

		return false
	end

	def move dirs, sneak = false, step = @step
		return  if dirs.empty?

		step /= 2  if (sneak)

		step.times do |s|
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
									@x = @x + n
									$camera.move :right, n
									break
								elsif ( !collision?(
												 dir,
												 @x - n, @y,
												 @w, @h) )
									@x = @x - n
									$camera.move :left, n
									break
								end

							when :left, :right
								if    ( !collision?(
												 dir,
												 @x, @y + n,
												 @w, @h) )
									@y = @y + n
									$camera.move :down, n
									break
								elsif ( !collision?(
												 dir,
												 @x, @y - n,
												 @w, @h) )
									@y = @y - n
									$camera.move :up, n
									break
								end
							end
						end
					end
				end

			end
		end

		# Camera sticks to player
		#$camera.move_to(
		#	x: ((@x + (@w / 2)) - ($settings.screen(:w) / 2)),
		#	y: ((@y + (@h / 2)) - ($settings.screen(:h) / 2)),
		#)
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

	def update
	end

	def draw
		# Draw player
		Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @c, @z
	end
end

