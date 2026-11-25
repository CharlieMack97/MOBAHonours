extends Area3D
var projectileSpeed : float = 25
var projectileTarget : Node3D = null
var projectileShooter : CharacterBody3D = null
var turningSpeed : float = 5
const HIT_DISTANCE : float = 0.5
const AIM_HEIGHT : float = 1.0 
var damage : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_instance_valid(projectileTarget):
		queue_free()
		return

	var aimPoint : Vector3 = projectileTarget.global_position + Vector3.UP * AIM_HEIGHT
	var direction : Vector3 = (aimPoint - global_position).normalized()
	global_position += direction * projectileSpeed * delta
	look_at(global_position + direction, Vector3.UP)
	
	if global_position.distance_to(aimPoint) <= HIT_DISTANCE:
		_hitTarget()
		
func _hitTarget() -> void:
	if multiplayer.is_server():
		AutoAttackProjectile.dealDamage(projectileTarget, damage)
	queue_free()
