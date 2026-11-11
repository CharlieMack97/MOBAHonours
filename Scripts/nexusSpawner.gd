extends Node3D
@export var spawnPoint : Marker3D 
@export var minionScene : PackedScene 
var gameTimer : float 
var health : float
var minionSceneSpawnCooldown : float = 15 
var minionScenesToSpawn : int = 4 
@export var enemyBase : Node3D 


const MAXHEALTH : float = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	
func _spawnMinionScene() ->void :
	var minion = minionScene.instantiate()
	get_tree().current_scene.add_child(minion)
	minion.global_position = spawnPoint.global_position
	minion.targetBase = enemyBase.global_position
	
	
	
	
