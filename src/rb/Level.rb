
class Level
	attr_reader :name

	def initialize args = {}
		@name = args[:name]
		@config = args[:config]
		if (args[:rooms])
			@rooms = gen_rooms args[:rooms]
		else
			@rooms = nil
		end
	end

	def get_room name
		return @rooms.to_a.sample[1]  if (name == :random || name == :sample)
		return @rooms[name]           unless (@rooms[name].nil?)
	end

	def gen_rooms rooms_json
		rooms = {}
		rooms_json.each do |name, json|
			rooms[name] = Room.new(
				name:      name,
				instances: gen_instances(json["instances"]),
				w:         json["w"],
				w:         json["h"]
			)
		end
		return rooms
	end

	def gen_instances json
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

