extends OrbitalBody

func on_orbit_completed():
	var data = type_data as StationTypeData
	Science.add_science(data.science_per_orbit)

func leave_network():
	if assigned_network:
		assigned_network.remove_satellite(self)
		
func announce_destroyed():
	Gameevents.satellite_destroyed.emit()
