extends Node

signal money_changed(new_amount:float)
var money: float = 200

func add_money(amount:float):
	money += amount
	money_changed.emit(money)

func try_spend(amount:float)-> bool:
	if not can_afford(amount):
		return false
	money -= amount
	money_changed.emit(money)
	return true

func can_afford(amount:float) -> bool:
	return amount <= money
	
