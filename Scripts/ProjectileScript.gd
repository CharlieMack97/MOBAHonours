extends Area3D

@export var projectileSpeed : float = 20
@export var projectileDirection : Vector3 = Vector3(0,0,0)
@export var projectilesSpawn : Vector3
@onready var projectileMesh = $MeshInstance3D
var shooter: Node = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if projectileDirection !=Vector3.ZERO:
		#var direction = projectileMesh.position - projectileDirection
		global_position += projectileSpeed * projectileDirection * delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if not multiplayer.is_server():
		return
	if body == shooter:
		return
	
	var shooterTeam = shooter.get("team") if is_instance_valid(shooter) else null
	var bodyTeam = body.get("team")
	if shooterTeam != null and bodyTeam != null and bodyTeam == shooterTeam:
		return 
	
	if body.is_in_group("structures"):
		removeProjectile.rpc()
		return
	
	var healthComp = body.get_node_or_null("HealthCompoenent")
	if healthComp and healthComp.has_method("takeDamage"):
		healthComp.takeDamage(20)
		removeProjectile.rpc()
		return
	
	if body.has_method("takeDamage"):
		body.takeDamage(20, shooter if is_instance_valid(shooter) else null)
		removeProjectile.rpc()
		return
	
	if body.is_in_group("Terrain") or body.get_collision_layer_value(2):
		removeProjectile.rpc()
@rpc("call_local")
func removeProjectile():
	queue_free()
