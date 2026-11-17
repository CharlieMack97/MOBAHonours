class_name AutoAttackProjectile extends Node
@export var projectile_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
@rpc("any_peer", "call_local")
func autoAttack(player : NodePath, enemy : NodePath, spawnPos : Vector3) -> void:
	if !multiplayer.is_server():
		return
	var playerNode = get_node_or_null(player)
	var enemyNode = get_node_or_null(enemy)
	if !is_instance_valid(playerNode) or !is_instance_valid(enemyNode):
		return
	if !("team" in enemyNode) or enemyNode.team == playerNode.team:
		return
	autoAttackSpawn.rpc(player, enemy, spawnPos)
@rpc("any_peer", "call_local")
func autoAttackSpawn(player : NodePath, enemy : NodePath, spawnPos : Vector3) -> void:
	var playerNode = get_node_or_null(player) as Node3D
	var enemyNode = get_node_or_null(enemy) as Node3D
	if !is_instance_valid(playerNode) or !is_instance_valid(enemyNode):
		return
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = playerNode.global_position
	projectile.projectileTarget = enemyNode
	projectile.projectileShooter = playerNode
	projectile.damage = playerNode.attackDamage
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
static func dealDamage(target : Node, amount : float) -> void:
	if !is_instance_valid(target):
		return
	var healthComp = target.get_node_or_null("HealthComponent")
	if healthComp and healthComp.has_method("takeDamage"):
		healthComp.takeDamage(amount)
	elif target.has_method("takeDamage"):
		target.takeDamage(amount)
