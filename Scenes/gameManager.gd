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

func _on_peer_connected(id: int) -> void:
	clock.syncToPeer(id)
	if clock.running:
		return
	# +1 counts the host; change this if you move to a dedicated server
	if multiplayer.get_peers().size() + 1 >= playersNeededToStart:
		_start_match()

func _start_match() -> void:
	clock.schedule(&"minion_wave", firstWave, nexus[0].minionSceneSpawnCooldown)
	clock.startMatch()

func _on_clock_event(event_name: StringName) -> void:
	match event_name:
		&"minion_wave":
			for n in nexus:
				n.spawnWave()
