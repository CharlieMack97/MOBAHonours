extends MultiplayerSpawner

@export var networkPlayer: PackedScene
@export var teamSpawns : Array[Node3D]

var teams := {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_function = createPlayer
	multiplayer.peer_connected.connect(spawnPlayer)
	multiplayer.peer_disconnected.disconnect(removePlayer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawnPlayer(id:int)->void:
	if !multiplayer.is_server() : return
	var team := 0
	if teams.values().count(0) <= teams.values().count(1) :
		team = 0
	teams[id] = team
	spawn({"id": id,"team":team , "pos":teamSpawns[team].global_position})
func removePlayer(id:int)->void:
	if(!multiplayer.is_server()) : return
	teams.erase(id)
	var player := get_node(spawn_path).get_node_or_null(str(id))
	if player: player.queue_free()
func createPlayer(data :Dictionary) ->Node :
	var player:= networkPlayer.instantiate()
	player.name= str(data.id)
	player.team =data.team
	player.position = data.pos
	return player
	
