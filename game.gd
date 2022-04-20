extends Node2D

@onready var player := $Player
@onready var dialogues = $GUI/Dialogues

func _ready():
	var window: Window = get_tree().root
	var game_size = window.content_scale_size

	for chest in get_tree().get_nodes_in_group("chests"):
		chest.connect("chest_opened",
			func(item_name):
				dialogues.start_dialogue("Item {0} obtained".format([item_name]))
				player.handle_item_received(item_name)
				)


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_R:
					get_tree().reload_current_scene()
				KEY_Q:
					get_tree().quit()


func _on_player_player_killed(player):
	gameover()


func gameover():
	# stop enemies
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.process_mode = Node.PROCESS_MODE_DISABLED
	$GameOverSfx.play()
	var music_fadeout = get_tree().create_tween()
	music_fadeout.tween_property($Music, "volume_db", $Music.volume_db - 16, .7)
	music_fadeout.tween_property($Music, "pitch_scale", $Music.pitch_scale - .2, 3)
	$GameOverLayer.show()
	# TODO: show gameover screen


func _on_dialogues_dialogue_started():
	player.state = "idle"
	player.set_physics_process(false)


func _on_dialogues_dialogue_ended():
	player.state = "idle"
	await get_tree().process_frame
	player.set_physics_process(true)
