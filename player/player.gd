extends CharacterBody2D

const SPEED = 140.0

signal hp_changed
signal player_killed
signal player_ready(player)

@export var hp_total = 4
@onready var raycast: RayCast2D = $RayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var has_sword = false
var hp = hp_total # current hp value
var state = "idle":
	set(new_state): # setter
		on_state_changed(new_state, state)
		state = new_state


func _ready():
	hp = hp_total
	animated_sprite.play("idle_down")
	emit_signal("player_ready", self)


func take_damage(knockback: Vector2, damage: int):
	if  $FlashEffect.is_running():
		return
	$HitSfx.play()
	hp = max(0, hp - damage)
	emit_signal("hp_changed", hp)
	state = "knocking_back"
	velocity = 120 * knockback.normalized()
	$Timer.wait_time = 0.15
	$Timer.start()
	await $Timer.timeout
	state = "idle"
	if hp == 0:
		gameover()


func attack():
	state = "attacking"
	$Sword.attack(direction_as_string())
	animated_sprite.play("attack_" + direction_as_string())
	await animated_sprite.animation_finished
	state = "idle"


func is_attacking():
	return state == "attacking"
	# TODO: check if animated_sprite.playing contains a bug
	# return animated_sprite.playing and "attack" in animated_sprite.animation and animated_sprite.frame != 3


func _physics_process(delta):
	match state:
		"knocking_back":
			move_and_slide()
		"idle":
			# Get the input direction and handle the movement/deceleration.
			# TODO: as good practice, you should replace UI actions with custom gameplay actions.
			var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.y = direction.y * SPEED
				raycast.target_position = direction * 25
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.y = move_toward(velocity.y, 0, SPEED)
			animated_sprite.flip_h = (raycast.target_position.x > 0)
			$Sword.flip_h = raycast.target_position.x < 0
			if $Sword.flip_h:
				$Sword.offset.x = -26
			else:
				$Sword.offset.x = 0
			# sprite walk animations
			if velocity.y > 0:
				animated_sprite.play("walk_down")
			elif velocity.y < 0:
				animated_sprite.play("walk_up")
			elif velocity.x != 0:
				animated_sprite.play("walk_side")
			else:
				if velocity == Vector2() and not ("idle" in animated_sprite.animation):
					animated_sprite.play("idle_" + direction_as_string())
			if Input.is_action_just_pressed("player_attack"):
				if has_sword:
					attack()
			# check object interactions
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider is Chest:
					if Input.is_action_just_pressed("player_interact"):
						open_chest(collider)
		"attacking":
			return
		_:
			pass
	# body movement
	move_and_slide()


func direction_as_string():
	if raycast.target_position.x > 0:
		return "side"
	elif raycast.target_position.x < 0:
		return "side"
	elif raycast.target_position.y > 0:
		return "down"
	elif raycast.target_position.y < 0:
		return "up"
	else:
		print_debug("error")
		return ""


func open_chest(chest):
	if chest.closed():
		chest.open()
		$InteractSfx.play()
	# TODO: show GUI message


func gameover():
	set_physics_process(false)
	animated_sprite.stop()
	emit_signal("player_killed", self)


func on_state_changed(new_state, prev_state):
#	print("state: " + new_state)
	match new_state:
		"knocking_back":
			$FlashEffect.apply(self)
		_:
			pass


func _on_chest_chest_opened(item):
	print(item)
	if item == "sword":
		has_sword = true
