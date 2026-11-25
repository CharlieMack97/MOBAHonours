extends Node3D

const playersNeededToStart := 2
const firstWave := 5.0

@export var nexus: Array[Node3D]
@onready var clock: MatchClock = $MatchClock

func _ready() -> void:
	clock.eventFired.connect(_on_clock_event)
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.connect(_on_peer_connected)
	for n in nexus:
		n.connect("nexusDead", _gameOver)
func _on_peer_connected(id: int) -> void:
	clock.syncToPeer(id)
	if clock.running:
		return
	
	if multiplayer.get_peers().size() >= playersNeededToStart:
		_start_match()

func _start_match() -> void:
	clock.schedule(&"minion_wave", firstWave, nexus[0].minionSceneSpawnCooldown)
	clock.startMatch()

func _on_clock_event(event_name: StringName) -> void:
	match event_name:
		&"minion_wave":
			for n in nexus:
				n.spawnWave()
func respawnCharacter(playerChar : CharacterBody3D) ->void:
	for n in nexus:
		if n.team == playerChar.team :
			playerChar.global_position  = n.spawnPoint.global_position 
			playerChar.reset()
func _gameOver() -> void:
	gameOver.rpc(1)
@rpc("authority", "call_local", "reliable")
func gameOver(winning_team: int) ->void:
	$"../EndGame".show()
	get_tree().paused = true
	multiplayer.multiplayer_peer.close()
