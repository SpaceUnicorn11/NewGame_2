extends RigidBody2D

@export var speed = 6 # Projectile speed
var damage = 0 # Projectile damage
var hits = 1
var type = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	var direction = get_global_mouse_position() - (get_node('/root/Main/Stage/Player').position + Vector2(-6, 6))
	linear_velocity = direction * speed
	await get_tree().create_timer(1.5).timeout 
	queue_free() # despawn projectile 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func hit():
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	queue_free() # despawn projectile 


func _on_body_entered(body):
	if hits > 0 && body.type == 1:
		hits -= 1
		$CollisionShape2D.disabled = true
		hit()
		body.take_damage(damage)
