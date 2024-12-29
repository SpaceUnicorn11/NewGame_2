extends RigidBody2D

@export var speed = 150 # How fast the mob will move (pixels/sec).
@export var health = 20 # How much health the mob has
@export var damage = 10 # How much damage the mob deals
var can_move = true # if mob can move
var player_detected = false
var type = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_detected == true && $NavigationAgent2D.target_position.distance_to(position) > 60:
		rotation = get_node('/root/Stage/Player').position.angle_to_point(position)
		$NavigationAgent2D.target_position = get_node('/root/Stage/Player').position
		var velocity = $NavigationAgent2D.get_next_path_position() - position
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			#if position.x - $NavigationAgent2D.target_position.x < 0:
				#$AnimatedSprite2D.flip_h = true
				#$AnimatedSprite2D.play('move')
			#else:
				#$AnimatedSprite2D.flip_h = false
				#$AnimatedSprite2D.play('move')
		else:
			$AnimatedSprite2D.play('default')
		if can_move:	
			position += velocity * delta
	elif player_detected == true && $NavigationAgent2D.target_position.distance_to(position) <= 60:
		attack()
		$NavigationAgent2D.set_target_position(get_node('/root/Stage/Player').position) 


func take_damage(damage_taken :int):
	if health - damage_taken > 0:
		health -= damage_taken
	elif health - damage_taken <= 0:
		health = 0
		can_move = false
		$CollisionShape2D.hide()
		queue_free()

func attack():
	can_move = false
	$AnimatedSprite2D.play("attack")
	$AttackCollisionShape2D.show()
	$CollisionShape2D.hide()
	await get_tree().create_timer(0.6).timeout
	$AnimatedSprite2D.play("default")
	$AttackCollisionShape2D.hide()
	$CollisionShape2D.show()
	can_move = true


func _on_detection_area_body_entered(body):
	if body.type == 0:
		freeze = false
		player_detected = true
		$DetectionArea/CollisionShape2D.disabled = true
