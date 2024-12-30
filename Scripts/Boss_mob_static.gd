extends StaticBody2D
var type = 1
var damage_taken  = 0

signal damage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage_taken):
	damage.emit(damage_taken)
