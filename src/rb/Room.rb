
class Room
	attr_reader :x,:y, :w,:h, :instances, :name

	def initialize args = {}
		@name = args[:name]
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || $settings.rooms(:w)
		@h = args[:h] || $settings.rooms(:h)
		@instances = sort_instances args[:instances] || {}

		get_instances(:all).each { |inst| inst.set_room self }

		@z = 10
		@bg = $settings.rooms :bg

		init args  if (defined? init)
	end

	def get_instances target
		case target
		when :all
			return @instances.values.flatten
		when :solid
			return @instances[:solid]
			return solid_instances
		when :passable
			return @instances[:passable]
			return passable_instances
		when :doors
			return @instances[:passable].map do |instance|
				next instance  if (instance.is_a? DoorInst)
			end .reject { |v| v.nil? || !v.check_collision? }
		else
			return nil
		end
	end

	def get_spawn
		@instances[:passable].each do |instance|
			return instance  if (instance.is_a? SpawnInst)
		end
		return nil
	end

	def solid_instances
		return @instances[:solid]
		return @instances.map do |instance|
			next instance  if (instance.is_solid?)
		end .reject { |v| v.nil? || !v.check_collision? }
	end

	def passable_instances
		return @instances[:passable]
		return @instances.map do |instance|
			next instance  if (instance.is_passable?)
		end .reject { |v| v.nil? || !v.check_collision? }
	end

	def find_instances_by_class klass
		return  unless (klass.is_a? Class)
		return get_instances(:all).map do |instance|
			next instance  if (instance.is_a? klass)
		end .reject { |v| v.nil?  }
	end

	def sort_instances instances
		return {}  if (instances.nil? || instances.empty?)
		ret = {
			solid:    [],
			passable: []
		}
		instances.each do |instance|
			if (instance.is_passable?)
				ret[:passable] << instance
			elsif (instance.is_solid?)
				ret[:solid] << instance
			end
		end
		return ret
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
		get_instances(:all).each &:update

		# Custom update function of child class
		update_custom  if (defined? update_custom)
	end

	def draw
		# Draw room background
		Gosu.draw_rect draw_pos(:x), draw_pos(:y), @w,@h, @bg, @z
		# Draw instances (walls, ...)
		get_instances(:all).each &:draw

		# Custom draw function of child class
		draw_custom  if (defined? draw_custom)
	end
end

