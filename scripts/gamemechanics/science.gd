extends Node

signal science_changed(new_amount: int)

var science: int = 0

func add_science(amount:int):
	science += amount
	science_changed.emit(science)
	
func try_spend(amount:int)-> bool:
	if not can_afford(amount):
		return false
	science -= amount
	science_changed.emit(science)
	return true

func can_afford(amount:int) -> bool:
	return amount <= science
