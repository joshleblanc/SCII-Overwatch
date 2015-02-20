module Site
	module Helpers
		def get_race_image race
			if is_terran? race
				"/img/ico_race_t.png"
			elsif is_protoss? race
				"/img/ico_race_p.png"
			else
				"/img/ico_race_z.png"
			end
		end

		private
			def is_terran? race
				is_race? /terran|terraner/, race
			end

			def is_zerg? race
				is_race? /zerg/, race
			end

			def is_protoss? race
				is_race? /protoss/, race
			end
			def is_race? regex, race
				!race.downcase.match(regex).nil?
			end
	end
end