extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $Knight/AnimationPlayer
@onready var animTree : AnimationTree = $Knight/AnimationTree
var targetBase : Vector3
var enemyTarget : Node3D
var moveToPoint : Vector3 
const speed : float = 4 
const attackSpeed : float = 2 
var state = State.MoveToPoint
enum State{
	MoveToPoint,
	AttackEnemy
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_multiplayer_authority(1)

func attack(target : CharacterBody3D) -> void :
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority() :
		return
	match state : 
		State.MoveToPoint:
			_moveToPoint()
		State.AttackEnemy:
			_AttackEnemy()
func _moveToPoint() -> void :
	navAgent.target_position = moveToPoint
	
	if navAgent.is_navigation_finished() :
		velocity = Vector3.ZERO
		return
	
	var nextPos =navAgent.get_next_path_position()
	var direction = (nextPos -global_position).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
func _AttackEnemy() -> void:
	if !is_instance_valid(enemyTarget):
		enemyTarget = null
		state = State.MoveToPoint
		return 
	navAgent.target_position = enemyTarget.global_position
	var dist = global_position.distance_to(enemyTarget.global_position )
	
	if dist < 2.0:
		attack(enemyTarget)
		return
		
	var next_pos = navAgent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if enemyTarget == null:
		return
	if body.is_in_group("Enemy"):
		enemyTarget = body
		state = State.AttackEnemy
