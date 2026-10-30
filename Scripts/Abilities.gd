class_name Abilities extends Node

@export var projectile : PackedScene
@export var projectile_container: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

			
#func aimMissile(Vector3: position):
	#draw_line(positions,mouse.position)

#func draw_line(start: Vector3, end: Vector3, color: Color):
	#clear()
	#begin(Mesh.PRIMITIVE_LINES)
	#set_color(color)
	#add_vertex(start)
	#add_vertex(end)
	#end()
@rpc("any_peer", "call_local")
func requestMissile(direction : Vector3,spawnLoation : Vector3, shooterID : int) -> void:
	if multiplayer.is_server():
		shootMissile.rpc(direction, spawnLoation, shooterID)
	else:
		shootMissile_rpc.rpc_id(1)
@rpc("any_peer", "call_local")
func shootMissile(direction : Vector3,spawnLoation : , shooterID : int) -> void:
	if !multiplayer.is_server():
		return
		
	var _projectile = projectile.instantiate()
	_projectile.name = "Missile_%d_%d" % [shooterID, Time.get_ticks_usec()]
	#_projectile.set_multiplayer_authority(1)
	_projectile.shooter = owner
	var projectiles = get_tree().current_scene.get_node("Projectiles")
	projectiles.add_child(_projectile)
	_projectile.global_position = spawnLoation
	#_projectile.set_global_rotation_degrees(Vector3(0,90,0)) 
	var flatTarget = spawnLoation + Vector3(direction.x, 0, direction.z)
	#_projectile.Shooter = shooterID
	_projectile.look_at_from_position(spawnLoation,flatTarget, Vector3.UP)
	_projectile.projectileDirection = Vector3 (direction.x,0,direction.z).normalized()
@rpc("any_peer", "call_local")
func shootMissile_rpc(direction : Vector3,spawnLoation : Vector3) -> void:
	var sender := multiplayer.get_remote_sender_id()
	if sender == 0:
		sender = multiplayer.get_unique_id()
	shootMissile(direction,spawnLoation, sender)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
