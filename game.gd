extends Node2D


func _ready():
	var window: Window = get_tree().root
	var game_size = window.content_scale_size


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
	# TODO: show gameover screen
