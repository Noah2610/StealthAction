
module Collision
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
			w: (@w.to_f / instance.size(:w).to_f).ceil,
			h: (@h.to_f / instance.size(:h).to_f).ceil
		}
	end

	def collision? args
		to_check = args[:check] || []
		dir = args[:dir] || nil
		x = args[:x] || @x.dup
		y = args[:y] || @y.dup
		w = args[:w] || @w.dup
		h = args[:h] || @h.dup
		return_on_found = args[:return_on_found]

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

					if (  ((x) <= inst[:x2])         &&
								((x) > inst[:x])         &&
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

			collision.yes_collision self  if (collision && defined?(collision.yes_collision))
			return collision

		## Not moving, (passable instances)
		else
			collisions = []
			to_check.each do |instance|

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

				if (((((y) < inst[:y2])          &&
							((y) >= inst[:y])        ) ||
						 (((y + h) <= inst[:y2])     &&
						  ((y + h) > inst[:y])    )) &&
						((((x) < inst[:x2])          &&
							((x) >= inst[:x])        ) ||
						 (((x + w) <= inst[:x2])     &&
							((x + w) > inst[:x])    ))  )
					if (return_on_found)
						collisions = [instance]
						break
					else
						collisions << instance
					end
				else
					instance.no_collision self  if (defined? instance.no_collision)
				end
			end

			#collisions.each &:yes_collision
			collisions.each { |c| c.yes_collision self  if (defined? c.yes_collision) }
			return collisions

		end

		return nil
	end
end

