class_name AutoAttackProjectile extends Node
@export var projectile_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
@rpc("any_peer", "call_local")
func autoAttack(player :NodePath) -> void:
	if not multiplayer.is_server():
		return
	var playerNode = get_node_or_null(player)
	if not is_instance_valid(playerNode):
		return
	#var projectile = projectile_scene.instantiate()
	#var spawnPos = player.global_position
	#projectile.global_position = spawnPos
	#get_tree().root.add.child(projectile)
	print("ouch hit")
	var healthComp = playerNode.get_node_or_null("HealthCompoenent")
	if healthComp and healthComp.has_method("takeDamage") :
		healthComp.takeDamage(20)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
