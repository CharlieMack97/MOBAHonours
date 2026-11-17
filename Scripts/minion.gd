extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $Knight/NavigationAgent3D
@onready var animTree : AnimationTree = $Knight/AnimationTree
@onready var aggroArea : Area3D = $Knight/Area3D
@onready var teamRing : MeshInstance3D = $TeamRing
var targetBase : Vector3
var enemyTarget : Node3D
var moveToPoint : Vector3 
const speed : float = 4 
const attackSpeed : float = 2 
var state = State.MoveToPoint
@export var team : int:
	set(value):
		team = value
		if is_node_ready():
			_setTeamColour()
var Health : float
const MAX_HEALTH : float = 10
const TEAM_COLOURS : Array[Color] = [Color.DODGER_BLUE, Color.RED]
const ATTACK_DAMAGE : float = 5.0
var attackTimer : float = 0.0

enum State{
	MoveToPoint,
	AttackEnemy
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_multiplayer_authority(1)
	print(name, " ready on team ", team, " | server: ", multiplayer.is_server())
	_setTeamColour()
	Health = MAX_HEALTH
func _setTeamColour() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = TEAM_COLOURS[team]
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	teamRing.material_override = material
func attack(target : CharacterBody3D) -> void :
	velocity = Vector3.ZERO
	if attackTimer > 0.0:
		return
	attackTimer = attackSpeed
	AutoAttackProjectile.dealDamage(target, ATTACK_DAMAGE)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority() :
		return
	attackTimer -= delta
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
	
	var nextPos = navAgent.get_next_path_position()
	var direction = (nextPos -global_position).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
func _AttackEnemy() -> void:
	if !is_instance_valid(enemyTarget):
		enemyTarget = null
		state = State.MoveToPoint
		for body in aggroArea.get_overlapping_bodies():
			if isEnemy(body):
				enemyTarget = body
				state = State.AttackEnemy
				break
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
	if !is_multiplayer_authority():
		return
	#print(name, " saw ", body.name, " team ", body.get("team"))
	if enemyTarget != null:
		return
	if isEnemy(body):
		enemyTarget = body
		state = State.AttackEnemy
func isEnemy(body: Node3D) -> bool:
	return "team" in body and body.team != team
func takeDamage(amount: float) -> void:
	if !multiplayer.is_server():
		return
	Health -= amount
	print(name, " health: ", Health)
	if Health <= 0:
		queue_free() 
