extends Area2D

@onready var player = get_parent()


func _process(delta):
	monitoring = player.is_attacking()
	visible = monitoring
	position = player.raycast.target_position


func _on_hurt_box_area_entered(area):
	if area is EnemyHitbox:
		area.receive_hit(area.global_position - player.global_position)
	# TODO: check
#	match typeof(area):
#		Enemy:
#			area.queue_free()
