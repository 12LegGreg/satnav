extends Node

signal science_changed(new_amount: int)

var science: int = 0

func add_science(amount:int):
	science += amount
	science_changed.emit(science)
