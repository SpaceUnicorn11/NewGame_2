extends Node2D

@export var projectile_scene: PackedScene
var cooldown = 1
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.rotation = rotation 
	projectile.damage = damage
	#get_node('/root/Stage/Player').add_child(projectile)
	get_node('/root/Main/Stage/Player').call_deferred("add_child", projectile)
	hide()
	get_node('/root/Main/Stage/Player/Cursor').change_cursor(false)
	await get_tree().create_timer(cooldown).timeout
	show()
	get_node('/root/Main/Stage/Player/Cursor').change_cursor(true)
	#$ShotSound.play()
