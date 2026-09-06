extends Node

signal money_changed(new_amount: int)

var money: int = 200

func add_money(amount:int):
	money += amount
	money_changed.emit(money)
