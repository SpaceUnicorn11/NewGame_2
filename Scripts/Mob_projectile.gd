extends RigidBody2D

@export var speed = 3 # Projectile speed
var damage = 0 # Projectile damage
var type = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	damage = get_parent().damage
	var direction = get_node('/root/Stage/Player').position - get_parent().position
	linear_velocity = direction * speed
	await get_tree().create_timer(3).timeout 
	queue_free() # despawn projectile 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func hit():
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	queue_free() # despawn projectile 


func _on_body_entered(body):
	$CollisionShape2D.disabled = true
	hit()
