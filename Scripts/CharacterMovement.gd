extends CharacterBody3D
@onready var navAgent : NavigationAgent3D = $NavigationAgent3D 
@onready var cam : Camera3D = $PlayerCamera
@onready var abilities : Abilities = $Abilities

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var isMoving : bool = false
var targetPoisiton : Vector3 
var attackTarget : Node3D 
var attackCooldown : int 
var attackTimer : int 

func _ready() -> void:
	if multiplayer.get_unique_id() == name.to_int():
		$PlayerCamera.make_current()
	if !is_multiplayer_authority() :
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
	
	
	targetPoisiton = global_position
	
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
@rpc
func _input(event):
	if event.is_action_pressed("MoveClick"):
		var mousePos = event.position
		var from = cam.project_ray_origin((mousePos))
		var to = from + cam.project_ray_normal(mousePos)* 1000
		
		var spaceState = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = false  # Only collide with bodies
		query.collide_with_bodies = true
		var result = spaceState.intersect_ray(query)
		
		if result.has("position"):
			navAgent.set_target_position(result.position)
			isMoving = true
	if event.is_action_pressed("Ability1"):
		var mousePos = get_viewport().get_mouse_position()
		var from = cam.project_ray_origin((mousePos))
		var to = from + cam.project_ray_normal(mousePos)* 1000
		
		var spaceState = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = false  # Only collide with bodies
		query.collide_with_bodies = true
		var result = spaceState.intersect_ray(query)
		
		if result.has("position"):
			var spawnLocation = $MeshInstance3D.global_position
			abilities.requestMissile.rpc_id(1,result.position,spawnLocation)
	if event.is_action_pressed("AttackMove"):
		var mousePos = get_viewport().get_mouse_position()
		var from = cam.project_ray_origin((mousePos))
		var to = from + cam.project_ray_normal(mousePos)* 1000
		
		var spaceState = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = false  # Only collide with bodies
		query.collide_with_bodies = true
		var result = spaceState.intersect_ray(query)
		
		if result.is_empty():
			return
		var hit : Node = result.collider 
		if hit.is_in_group("Player"):
			pass
		

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if navAgent.is_navigation_finished() :
		velocity = Vector3.ZERO
		return
	if isMoving:
		var destination = navAgent.get_next_path_position()
		var localDesitnation = destination - global_position
		var direction = localDesitnation.normalized()
		velocity = direction * SPEED
		move_and_slide()
