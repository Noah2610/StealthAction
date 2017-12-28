
class SongController
	def initialize args = {}
		@song = nil
		play args[:song]      unless (args[:song].nil?)
		@volume_default = args[:volume] || 0.05
	end

	def play target = nil, args = {}
		looping = args[:loop].nil? ? true : args[:loop]
		if (target.nil?)
		## Continue playing paused song
			@song.play looping  unless (@song.nil?)
		else
		## Load new song and play
			@song.stop          unless (@song.nil?)
			@song = $settings.songs target
			@song.play looping
		end
		self.volume = @volume_default
	end

	def pause
		@song.pause           unless (@song.nil?)
	end

	def current
		return @song
	end

	## Get volume
	def volume
		return @song.volume   unless (@song.nil?)
	end
	## Set volume
	def volume= vol
		vol = vol.to_f
		if (vol < 0.0)
			vol = 0.0
		elsif (vol > 1.0)
			vol = 1.0
		end
		@song.volume = vol
		return @song.volume
	end
end

