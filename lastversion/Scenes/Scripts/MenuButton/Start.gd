extends Button

func _ready():
	connect("pressed", self, "_on_start_pressed")

func _on_start_pressed():
	
	var play_scene = preload("res://Scenes/StartGame.tscn")
	var play_instance = play_scene.instance()
	get_tree().get_root().add_child(play_instance)
