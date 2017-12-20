
class Level
	attr_reader :rooms

	def initialize args = {}
		if (args[:data])
			instances = get_instances args[:data]
			@rooms = [
				Room.new(
					x: 0,
					y: 0,
					w: $settings.screen(:w),
					h: $settings.screen(:h),
					instances: instances
				)
			]
		end
	end

	def get_instances json
		instances = []
		json.each do |instance|
			if (class_exists? instance["type"])
				data = instance.map do |k,v|
					k = k.to_sym
					next nil  if (k == :type)
					if (v =~ /\A\d+px\z/)
						v = v[0..-3].to_i
					else
						v = v.to_i
					end
					next [k, v]
				end .reject { |v| v.nil? } .to_h
				instances << Object.const_get(instance["type"]).new(data)
			end
		end
		return instances
	end
end

