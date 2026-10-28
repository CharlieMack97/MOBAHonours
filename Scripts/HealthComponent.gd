class_name HealthCompoenent extends Node

@export var playerHealth : float
@export var playerXP: float
@export var playerMana : float
@export var playerManaRegen : float
@export var playerHealthRegen : float

func _ready() -> void:
	playerHealth =100
	playerMana = 50
	playerXP = 0
	playerManaRegen = 3
	playerHealthRegen =5
	
# Called when the node enters the scene tree for the first time.
func _update() -> void:
	pass
@rpc
func _takeDamage(damage) -> void:
	playerHealth -= damage
	
