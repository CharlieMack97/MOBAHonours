class_name MatchClock extends Node

signal tickSecond(seconds: int)        # every whole second, on all peers
signal eventFired(eventName: StringName) # scheduled events, server only
signal stateChanged(isRunning: bool)

const SYNC_INTERVAL : float = 1.0 
const SNAP_THRESHOLD : float = 0.25 

var matchTime : float = 0.0
var running : bool = false

var syncTimer : float = 0.0
var lastSecond : int = -1
var events : Array[Dictionary] = []


func _physics_process(delta: float) -> void:
	if !running:
		return

	matchTime += delta
	_checkSecond()

	if !multiplayer.is_server():
		return

	_checkEvents()

	syncTimer += delta
	if syncTimer >= SYNC_INTERVAL:
		syncTimer = 0.0
		_syncTime.rpc(matchTime)


# ---------- server only ----------

func startMatch() -> void:
	if !multiplayer.is_server():
		return
	matchTime = 0.0
	lastSecond = -1
	_setRunning(true)

func setPaused(paused: bool) -> void:
	if !multiplayer.is_server():
		return
	_setRunning(!paused)


func schedule(eventName: StringName, startTime: float, repeatEvery: float = 0.0) -> void:
	events.append({"name": eventName, "time": startTime, "repeat": repeatEvery})

# send the current clock to someone who joined
func syncToPeer(id: int) -> void:
	if !multiplayer.is_server():
		return
	_syncState.rpc_id(id, matchTime, running)

func getClockText() -> String:
	var minutes : int = floori(matchTime / 60.0)
	var seconds : int = int(matchTime) % 60
	return "%02d:%02d" % [minutes, seconds]

func _checkSecond() -> void:
	var currentSecond : int = int(matchTime)
	if currentSecond == lastSecond:
		return
	lastSecond = currentSecond
	tickSecond.emit(currentSecond)

func _checkEvents() -> void:
	var finishedEvents : Array[Dictionary] = []

	for event in events:
		if matchTime < event.time:
			continue
		eventFired.emit(event.name)
		if event.repeat > 0.0:
			event.time += event.repeat
		else:
			finishedEvents.append(event)

	for event in finishedEvents:
		events.erase(event)

func _setRunning(isRunning: bool) -> void:
	running = isRunning
	_syncState.rpc(matchTime, running)
	stateChanged.emit(running)

@rpc("authority", "call_remote", "unreliable_ordered")
func _syncTime(serverTime: float) -> void:
	if absf(serverTime - matchTime) > SNAP_THRESHOLD:
		matchTime = serverTime

@rpc("authority", "call_remote", "reliable")
func _syncState(serverTime: float, isRunning: bool) -> void:
	matchTime = serverTime
	running = isRunning
	stateChanged.emit(running)
