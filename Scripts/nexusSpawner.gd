extends Node3D
@onready var anim : AnimatedSprite3D  = $AnimatedSprite3D
@export var spawnPoint : Marker3D 
@export var minionScene : PackedScene 
@export var minionContainer : MultiplayerSpawner 
var gameTimer : float 
var health : float
var minionSceneSpawnCooldown : float = 15 
var minionScenesToSpawn : int = 4 
@export var enemyBase : Node3D 
const SPAWN_STAGGER := 0.8
@export var team : int
const MAXHEALTH : float = 1000

signal nexusDead
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(multiplayer.get_unique_id(), " ", get_path())
	health = MAXHEALTH
	add_to_group("units")
	await get_tree().process_frame
	updateHealthAnim.rpc(health)
	

func spawnWave() -> void:
	for i in minionScenesToSpawn:
		_spawnMinionScene()
		await get_tree().create_timer(SPAWN_STAGGER).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
func takeDamage(amount: float) -> void:
	if !multiplayer.is_server():
		return
	health -= amount
	updateHealthAnim.rpc(health)
	if health <= 0:
		nexusDead.emit()
		#game over when i have game working
func _spawnMinionScene() ->void :
	if not multiplayer.is_server():
		return
	var minion = minionScene.instantiate()
	minion.team = team
	minionContainer.add_child(minion, true)
	
	minion.global_position = spawnPoint.global_position
	minion.moveToPoint = enemyBase.global_position
	
@rpc("any_peer", "call_local", "reliable")
func updateHealthAnim(new_health: float) -> void:
	health = new_health
	if not anim:
		return
	var healthPercentage = float(health) / float(MAXHEALTH)
	var totalFrames = 5
	var targetFrame = int(healthPercentage * (totalFrames - 1))
	anim.frame = clampi(targetFrame, 0, totalFrames - 1)

	
