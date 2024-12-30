extends RigidBody2D

@export var speed = 300 # How fast the mob will move (pixels/sec).
@export var health = 100 # How much health the mob has
@export var damage = 20 # How much damage the mob deals
var player_detected = false
var type = 1
var direction = Vector2(0, 0)
var on_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D.damage.connect(_on_hit_taken)


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
		freeze = true
		player_detected = false
		$CollisionShape2D.disabled = true
		$CollisionShape2D.hide()
		$AnimatedSprite2D.play("dead")
		$AnimatedSprite2D.z_index = -1
		await get_tree().create_timer(0.1).timeout
		get_node('/root/Main/VictoryMenu').show()
		get_node('/root/Main/Stage').queue_free()


func attack():
	if position.x - get_node('/root/Main/Stage/Player').position.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("attack")
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("default")
	direction = (get_node('/root/Main/Stage/Player').position - position).normalized()
	if position.x - get_node('/root/Main/Stage/Player').position.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	await get_tree().create_timer(1).timeout
	linear_velocity = direction * speed
	#$AnimatedSprite2D.play("default")

func _on_detection_area_body_entered(body):
	if body.type == 0 && health > 0:
		player_detected = true
		$DetectionArea/CollisionShape2D.disabled = true

func _on_body_entered(body):
	if body.type == 3:
		linear_velocity = Vector2.ZERO
		freeze = true
		$AnimatedSprite2D.play("default")

func _on_hit_taken(damage_taken):
	take_damage(damage_taken)
