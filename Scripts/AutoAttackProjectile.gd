class_name AutoAttackProjectile extends Node
@export var projectile_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
@rpc("any_peer", "call_local")
func autoAttack(player :NodePath, enemy : NodePath,spawnPos : Vector3) -> void:
	if not multiplayer.is_server():
		return
	var playerNode = get_node_or_null(player)
	if not is_instance_valid(playerNode):
		return
	autoAttackSpawn.rpc(player,enemy,spawnPos)
	#print("ouch hit")
	#var healthComp = playerNode.get_node_or_null("HealthCompoenent")
	#if healthComp and healthComp.has_method("takeDamage") :
		#healthComp.takeDamage(20)
@rpc("any_peer", "call_local")
func autoAttackSpawn(player : NodePath, enemy :NodePath ,spawnPos:Vector3) -> void:
	var playerNode = get_node_or_null(player) as CharacterBody3D
	var enemyNode = get_node_or_null(enemy) as CharacterBody3D
	if not is_instance_valid(playerNode):
		return
	var projectile = projectile_scene.instantiate()
	var spawnPosition = playerNode.global_position
	get_tree().root.add_child(projectile)
	projectile.global_position = spawnPosition
	projectile.projectileTarget = enemyNode 
	projectile.projectileShooter = playerNode
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
