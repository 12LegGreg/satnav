extends Node

signal money_changed(new_amount:int)
var money: int = 200

func add_money(amount:int):
	money += amount
	money_changed.emit(money)

func try_spend(amount:int)-> bool:
	if not can_afford(amount):
		return false
	money -= amount
	money_changed.emit(money)
	return true

func can_afford(amount:int) -> bool:
	return amount <= money
	
