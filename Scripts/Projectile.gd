extends RigidBody2D

@export var speed = 6 # Projectile speed
var damage = 0 # Projectile damage

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	damage = get_node('/root/Stage/Player/Weapon').damage
	var direction = get_global_mouse_position() - get_node('/root/Stage/Player').position
	linear_velocity = direction * speed
	await get_tree().create_timer(2).timeout 
	queue_free() # despawn projectile 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func hit():
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	queue_free() # despawn projectile 


func _on_body_entered(body):
	hit()
	body.take_damage(damage)
