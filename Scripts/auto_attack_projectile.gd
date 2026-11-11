extends Area3D
var projectileSpeed : float = 25
var projectileTarget : CharacterBody3D = null
var projectileShooter : CharacterBody3D = null
var turningSpeed : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if projectileTarget and is_instance_valid(projectileTarget):
		var direction = (projectileTarget.global_position - global_position).normalized()
		#var currentDir = -transform.basis.z
		#var newDir = currentDir.slerp(direction, turningSpeed * delta).normalized()
		global_position += direction * projectileSpeed * delta
		#if newDir.length_squared() >0 :
		look_at(global_position + direction, Vector3.UP)
	else:
		removeProjectile.rpc()
		
@rpc("any_peer","call_local")
func removeProjectile():
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	var player = body as CharacterBody3D
	if player == projectileShooter:
		return
	removeProjectile()
