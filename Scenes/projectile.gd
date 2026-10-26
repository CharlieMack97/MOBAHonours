extends Node3D

@export var projectileSpeed : float = 20
@export var projectileDirection : Vector3 = Vector3(0,0,0)
@onready var projectileMesh = $MeshInstance3D
# Called when the node enters the scene tree for the first time.
@rpc
func _physics_process(delta: float) -> void:
	if projectileDirection:
		projectileMesh.position += projectileSpeed * projectileDirection * delta 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
