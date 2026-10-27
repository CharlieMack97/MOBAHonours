extends Node3D

@export var projectileSpeed : float = 20
@export var projectileDirection : Vector3 = Vector3(0,0,0)
@export var projectilesSpawn : Vector3
@onready var projectileMesh = $MeshInstance3D
# Called when the node enters the scene tree for the first time.
@rpc
func _physics_process(delta: float) -> void:
	if projectileDirection:
		projectileMesh.position += projectileSpeed * projectileDirection * delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") :
		queue_free()
	if body.is_in_group("Terrain") :
		queue_free()
