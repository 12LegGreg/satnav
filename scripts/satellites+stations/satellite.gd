extends OrbitalBody

func on_orbit_completed():
	var data = type_data as SatelliteTypeData
	Economy.add_money(data.money_per_orbit)

func announce_destroyed():
	Gameevents.satellite_destroyed.emit()
