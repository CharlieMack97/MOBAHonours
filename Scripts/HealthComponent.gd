class_name HealthCompoenent extends Node

@onready var anim : AnimatedSprite3D 
@export var playerHealth : float
@export var playerXP: float
@export var playerMana : float
@export var playerManaRegen : float
@export var playerHealthRegen : float
const MAX_HEALTH : float = 100
const MAX_MANA : float = 300
const MAX_XP : float = 1000 

func _ready() -> void:
	anim = get_parent().get_node_or_null("AnimatedSprite3D")
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
	syncHealth.rpc(playerHealth)
@rpc("any_peer", "call_local", "reliable")
func syncHealth(health: float) ->void:
	playerHealth = health
	print("health updated: ", playerHealth)
	updateHealthAnim.rpc(playerHealth)
	if playerHealth <0:
		playerHealth = 100
@rpc("any_peer", "call_local", "reliable")
func updateHealthAnim(new_health: float) -> void:
	playerHealth = new_health
	if not anim:
		return
	var healthPercentage = float(playerHealth) / float(MAX_HEALTH)
	var totalFrames = 5
	var targetFrame = int(healthPercentage * (totalFrames - 1))
	anim.frame = clampi(targetFrame, 0, totalFrames - 1)
	print("Updated sprite frame on peer: ", multiplayer.get_unique_id(), " to frame: ", anim.frame)
