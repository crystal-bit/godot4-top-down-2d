extends HBoxContainer


var max_hp = null


func setup(_max_hp):
	max_hp = _max_hp
	set_max_hp(max_hp)
	set_current_hp(max_hp)


func set_max_hp(max_hp):
	assert(max_hp > 0)
	for i in range(max_hp - 1):
		var heart = $Heart1.duplicate()
		heart.name = "Heart" + str(i + 2)
		add_child(heart)


func set_current_hp(hp):
	if hp > max_hp:
		print_debug("HP should be less than MAX HP")
	for i in range(max_hp):
		var heart: TextureRect = get_node("Heart" + str(i + 1))
		if i < hp:
			heart.texture = load("res://ui/heart-full.tres")
		else:
			heart.texture = load("res://ui/heart-empty.tres")


func _on_player_hp_changed(new_hp):
	set_current_hp(new_hp)


func _on_player_player_ready(player):
	setup(player.hp)
