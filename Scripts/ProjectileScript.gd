extends Area3D

@export var projectileSpeed : float = 20
@export var projectileDirection : Vector3 = Vector3(0,0,0)
@export var projectilesSpawn : Vector3
@onready var projectileMesh = $MeshInstance3D
var Shooter : int
# Called when the node enters the scene tree for the first time.

func _physics_process(delta: float) -> void:
	if projectileDirection !=Vector3.ZERO:
		#var direction = projectileMesh.position - projectileDirection
		global_position += projectileSpeed * projectileDirection * delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if !is_multiplayer_authority():
		return
	print("Something entered: ", body.name, " | Groups: ", body.get_groups())
	#if body.is_in_group("Player") :
		#queue_free()
	#if body.is_in_group("Player")&& body!= Shooter :
		#queue_free() 
	if body.is_in_group("Terrain") :
		removeProjectile.rpc()
	if body.get_collision_layer_value(2):
		removeProjectile.rpc()
@rpc("call_local")
func removeProjectile():
	queue_free()
