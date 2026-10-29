class_name Abilities extends Node

@export var projectile : PackedScene

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
@rpc("any_peer", "call_local")
func shootMissile(direction : Vector3,spawnLoation : , shooterID : int) -> void:
	var _projectile = projectile.instantiate()
	_projectile.set_multiplayer_authority(shooterID)
	get_tree().current_scene.add_child(_projectile)
	_projectile.global_position = spawnLoation
	#_projectile.set_global_rotation_degrees(Vector3(0,90,0)) 
	var flatTarget = spawnLoation + Vector3(direction.x, 0, direction.z)
	_projectile.Shooter = shooterID
	_projectile.look_at_from_position(spawnLoation,flatTarget, Vector3.UP)
	_projectile.projectileDirection = Vector3 (direction.x,0,direction.z).normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
