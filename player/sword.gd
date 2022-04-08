extends AnimatedSprite2D


func _ready():
	hide()


func attack(direction: String):
	show()
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("attack_" + direction)
	await $AnimationPlayer.animation_finished
	hide()
