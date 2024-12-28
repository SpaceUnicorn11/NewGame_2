extends Node2D

var cursor = load("res://Assets/cursor_ready.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_cursor(ready):
	if ready == true:
		Input.set_custom_mouse_cursor(load("res://Assets/cursor_ready.png"))
	elif ready == false:
		Input.set_custom_mouse_cursor(load("res://Assets/cursor_not_ready.png"))
