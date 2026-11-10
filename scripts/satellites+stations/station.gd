extends OrbitalBody

func on_orbit_completed():
	var data = type_data as StationTypeData
	Science.add_science(data.science_per_orbit)

func leave_network():
	if assigned_network:
		assigned_network.remove_station(self)
		
func announce_destroyed():
	Gameevents.station_destroyed.emit()
