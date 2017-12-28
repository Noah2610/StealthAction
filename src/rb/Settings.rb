
class Settings
	def initialize
		@controls = {
			close:  [Gosu::KB_Q],
			player: {
				movement: {
					up:    [Gosu::KB_W, Gosu::KB_UP],
					down:  [Gosu::KB_S, Gosu::KB_DOWN],
					left:  [Gosu::KB_A, Gosu::KB_LEFT],
					right: [Gosu::KB_D, Gosu::KB_RIGHT]
				},
				sneak:   [Gosu::KB_LEFT_SHIFT]
			},
			camera: {
				up:    [Gosu::KB_K],
				down:  [Gosu::KB_J],
				left:  [Gosu::KB_H],
				right: [Gosu::KB_L]
			},
			random_room: [Gosu::KB_RETURN, Gosu::KB_TAB]
		}

		@settings = {
			screen: {
				w: 960,
				h: 640
			},

			entities: {
				size: {
					w: 32,
					h: 32
				},
				max_vel: {
					x: 4,
					y: 4
				},
				vel_incr: {
					x: 1,
					y: 1
				},
				vel_decr: {
					x: 4,
					y: 4
				},
				move_interval:     4
			},

			player: {
				size: {
					w: 32,
					h: 32
				},
				step:              1,
				step_sneak:        0.4,    # times velocity
				max_vel: {
					x: 8,
					y: 8
				},
				vel_incr: {
					x: 1,
					y: 1
				},
				vel_decr: {
					x: 4,
					y: 4
				},
				move_interval:     4,
				#collision_padding: 12,
				collision_padding: 3       # divided by size
			},

			rooms: {
				w: 960,
				h: 640
			},

			camera: {
				step:  2
			},

			images: {
				valid_formats: ["png"]
			},

			songs: {
				valid_formats: ["wav"]
			}
		}

		## Load levels from json files into resources
		@resources = {
			colors: {
				black:        Gosu::Color.argb(0xff_000000),
				white:        Gosu::Color.argb(0xff_ffffff),
				gray:         Gosu::Color.argb(0xff_bababa),
				gray_light:   Gosu::Color.argb(0xff_e8e8e8),
				gray_dark:    Gosu::Color.argb(0xff_8c8c8c),
				gray_darker:  Gosu::Color.argb(0xff_5d5d5d),
				red:          Gosu::Color.argb(0xff_8e452e),
				light_red:    Gosu::Color.argb(0xff_ff0000),
				green:        Gosu::Color.argb(0xff_80ff73),
				green_light:  Gosu::Color.argb(0xff_daedbd),
				green_dark:   Gosu::Color.argb(0xff_adbc96),
				blue:         Gosu::Color.argb(0xff_7dbbc3),
				blue_light:   Gosu::Color.argb(0xff_a0cdd3),
				blue_dark:    Gosu::Color.argb(0xff_679aa0),
				orange:       Gosu::Color.argb(0xff_e5b181),
				yellow:       Gosu::Color.argb(0xff_ebee8c),
				brown:        Gosu::Color.argb(0xff_695a3b)
			},
			images:  {},
			songs:   {},
			samples: {}
		}

		@resources[:images] = load_images DIR[:images], valid_formats: valid_image_formats
	end


	def images target
		return @resources[:images][target]
	end

	def songs target
		return @resources[:songs][target]  unless (@resources[:songs][target].nil?)
		@resources[:songs][target] = load_song target, DIR[:songs], valid_formats: @settings[:songs][:valid_formats]
		return @resources[:songs][target]
	end

	def valid_image_formats
		return @settings[:images][:valid_formats]
	end

	def controls target
		return @controls[target]
	end

	def player target
		case target
		when :w, :h
			return @settings[:player][:size][target]
		else
			return @settings[:player][target]
		end
	end

	def entities target
		case target
		when :w, :h
			return @settings[:entities][:size][target]
		else
			return @settings[:entities][target]
		end
	end

	def colors target = nil
		return nil  if (target.nil?)
		return @resources[:colors][target]
	end

	def screen target = nil
		case target
		when :size, nil
			return @settings[:screen]
		else
			return @settings[:screen][target]
		end
	end

	def rooms target
		case target
		when :bg
			return @resources[:colors][:gray]
		when :w, :width
			return @settings[:rooms][:w]
		when :h, :height
			return @settings[:rooms][:h]
		else
			return nil
		end
	end

	def instances target
		case target
		when :bg
			return @resources[:colors][:black]
		end
	end

	def camera target
		return @settings[:camera][target]
	end
end

