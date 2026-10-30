class_name HealthCompoenent extends Node

@export var playerHealth : float
@export var playerXP: float
@export var playerMana : float
@export var playerManaRegen : float
@export var playerHealthRegen : float
const MAX_HEALTH : float = 100
const MAX_MANA : float = 300
const MAX_XP : float = 1000 

func _ready() -> void:
	playerHealth =100
	playerMana = 50
	playerXP = 0
	playerManaRegen = 3
	playerHealthRegen =5
	
# Called when the node enters the scene tree for the first time.
func _update() -> void:
	pass

func takeDamage(damage) -> void:
	playerHealth -= damage
	syncHealth(playerHealth)
	
func syncHealth(health: float) ->void:
	playerHealth = health
	print("health updated: ", playerHealth)
	
	if playerHealth <0:
		pass
	
