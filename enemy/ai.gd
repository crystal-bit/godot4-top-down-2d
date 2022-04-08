extends Node

@onready var enemy: Enemy = get_parent()

@export var movement_speed = 80


func _ready():
	await get_tree().create_timer(randf() * 2).timeout
	$Timer.start()


func _process(delta):
	enemy.move_and_slide()


func on_hit(knock_dir: Vector2):
	enemy.velocity = 250 * knock_dir.normalized()
	$Timer.stop()
	await get_tree().create_timer(.2).timeout
	_on_timer_timeout()
	$Timer.start()


func _on_timer_timeout():
	$Timer.wait_time = max(1, randi() % 3)
	enemy.velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
#	enemy.velocity = enemy.velocity.normalized()
	enemy.velocity *= movement_speed
