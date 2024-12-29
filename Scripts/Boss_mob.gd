extends RigidBody2D

@export var speed = 200 # How fast the mob will move (pixels/sec).
@export var health = 1000 # How much health the mob has
@export var damage = 20 # How much damage the mob deals
var player_detected = false
var type = 1
var direction = Vector2(0, 0)
var on_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity == Vector2.ZERO:
		on_cooldown = false
	if player_detected == true && on_cooldown == false:
		freeze = false
		on_cooldown = true
		attack()
		#if velocity.length() > 0:
			#velocity = velocity.normalized() * speed
			#if position.x - $NavigationAgent2D.target_position.x < 0:
				#$AnimatedSprite2D.flip_h = true
				#$AnimatedSprite2D.play('move')
			#else:
				#$AnimatedSprite2D.flip_h = false
				#$AnimatedSprite2D.play('move')
		#else:
			#$AnimatedSprite2D.play('default')
		#if can_move:	
			#position += velocity * delta
	#elif player_detected == true && $NavigationAgent2D.target_position.distance_to(position) <= 60:
		#attack()
		#$NavigationAgent2D.set_target_position(get_node('/root/Stage/Player').position) 


func take_damage(damage_taken :int):
	if health - damage_taken > 0:
		health -= damage_taken
	elif health - damage_taken <= 0:
		health = 0
		$CollisionShape2D.hide()
		queue_free()

func attack():
	#$AnimatedSprite2D.play("attack")
	direction = (get_node('/root/Stage/Player').position - position).normalized()
	await get_tree().create_timer(2).timeout
	linear_velocity = direction * speed

func _on_detection_area_body_entered(body):
	if body.type == 0:
		player_detected = true
		$DetectionArea/CollisionShape2D.disabled = true

func _on_body_entered(body):
	if body.type == 3:
		linear_velocity = Vector2.ZERO
		freeze = true
