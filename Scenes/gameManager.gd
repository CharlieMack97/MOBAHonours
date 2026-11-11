extends Node3D
var matchInProgress: bool = false
var matchTime : float 
@export var nexus : Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority():
		return
	for _nexus in nexus:
		_nexus._spawnMinionScene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
