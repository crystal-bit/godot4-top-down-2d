extends Area2D
class_name EnemyHitbox

signal hit()


func receive_hit(knock_dir: Vector2, damage = 1):
	emit_signal("hit", knock_dir, damage)
