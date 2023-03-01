extends NinePatchRect

signal dialogue_started
signal dialogue_ended

@onready var label: Label = $MarginContainer/Label

var pagination_active = false
var last_page = false
var displaying_text = ""
var chars_per_second = 30


func _ready():
	$TextTimer.wait_time = 1.0 / chars_per_second


func start_dialogue(dialogue_text):
	emit_signal("dialogue_started")
	set_text(dialogue_text)
	show()


func set_text(val: String):
	displaying_text = val
	label.text = val
	last_page = is_last_page()
	label.visible_ratio = 0.0
	$TextTimer.start()


func next_page():
	displaying_text = displaying_text.substr(label.visible_characters, -1)
	set_text(displaying_text)


func is_last_page():
	var tmp = label.visible_ratio
	label.text = displaying_text
	label.visible_ratio = 1.0
	var is_last_page = label.get_line_count() <= 2
	return is_last_page


func reset():
	last_page = false
	displaying_text = ""
	label.text = ""


func _input(event):
	if event.is_action("player_a_btn") and event.pressed:
		if pagination_active:
			next_page()
			pagination_active = false
		elif last_page:
			emit_signal("dialogue_ended")
			hide()
			reset()


func _on_text_timer_timeout():
	label.visible_characters += 1
	if label.get_line_count() > 2:
		label.visible_characters -= 1
		pagination_active = true
	else:
		$TextTimer.start()
