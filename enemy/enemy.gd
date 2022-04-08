extends CharacterBody2D
class_name Enemy

var hp := 2


func hit(knock_dir, damage):
	if $FlashEffect.is_running():
		return
	$FlashEffect.apply(self)
	hp -= damage
#	print("HP: ", hp)
	if hp <= 0:
		defeat()
	else:
		$HitSfx.play()
		$AI.on_hit(knock_dir)
#		var tween = get_tree().create_tween()
#		tween.tween_property(self, "position", knockback * 30, .1)


func defeat():
	set_process(false)
	$MovementCollisionShape2D.queue_free()
	$AI.queue_free()
	$Hurtbox.queue_free()
	$EnemyHitbox.queue_free()
	$DefeatedSfx.play()
	await $DefeatedSfx.finished
	queue_free()


# Signal connections


func _on_enemy_hitbox_hit(knock_dir, damage):
	hit(knock_dir, damage)


func _on_hurtbox_area_entered(player_hitbox):
	var player = player_hitbox.get_parent()
	var hit_dir = player.global_position - global_position
	var damage_amount = 1
	player.take_damage(hit_dir, damage_amount)
