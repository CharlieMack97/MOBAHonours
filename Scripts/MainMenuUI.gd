extends Control
#func _ready() -> void:
	#ResourceLoader.load_threaded_request(GameScenePath)
func _on_start_server_pressed() -> void:
	MultiplayerNetwork.StartServer()
	get_tree().change_scene_to_file("res://Scenes/map.tscn")


func _on_start_client_pressed() -> void:
	MultiplayerNetwork.StartClient()
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
