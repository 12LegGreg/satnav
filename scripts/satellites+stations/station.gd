extends OrbitalBody

func on_orbit_completed():
	var data = type_data as StationTypeData
	Science.add_science(data.science_per_orbit)

func announce_destroyed():
	Gameevents.station_destroyed.emit()
