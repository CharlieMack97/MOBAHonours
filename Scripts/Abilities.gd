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
@rpc
func shootMissile(direction : Vector3) -> void:
	var _projectile = projectile.instantiate()
	_projectile.projectileDirection = direction
	add_child(_projectile)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
