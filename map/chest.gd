extends StaticBody2D
class_name Chest


signal chest_opened(item: String)

@export var item := "empty"


func opened():
	return $OpenChest.visible


func closed():
	return !opened()


func open():
	if opened():
		print("Chest already opened")
	else:
		emit_signal("chest_opened", item)
		$ClosedChest.hide()
		$OpenChest.show()
