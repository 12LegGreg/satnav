extends Node

signal science_changed(new_amount: float)

var science: float = 0

func add_science(amount:float):
	science += amount
	science_changed.emit(science)
	
func try_spend(amount:float)-> bool:
	if not can_afford(amount):
		return false
	science -= amount
	science_changed.emit(science)
	return true

func can_afford(amount:float) -> bool:
	return amount <= science
