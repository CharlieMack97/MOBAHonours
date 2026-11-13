class_name MatchClock extends Node

signal tick_second(seconds: int)          # every whole second (all peers)
signal event_fired(event_name: StringName) # scheduled events (server only)
signal state_changed(running: bool)

const SYNC_INTERVAL := 1.0   # seconds between server -> client corrections
const SNAP_THRESHOLD := 0.25 

var match_time: float = 0.0
var running: bool = false

var _sync_accum := 0.0
var _last_whole_second := -1
var _events: Array[Dictionary] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
