extends Node

var flash_tween


func is_running():
	return flash_tween and flash_tween.is_running()


func apply(node: Node2D):
	flash_tween = get_tree().create_tween()
	flash_tween.tween_property(node, "modulate:a", 0.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 1.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 0.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 1.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 0.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 1.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 0.0, 0.1)
	flash_tween.tween_property(node, "modulate:a", 1.0, 0.1)
