extends RigidBody2D

@export var projectile_scene: PackedScene
@export var speed = 100 # How fast the mob will move (pixels/sec).
@export var health = 20 # How much health the mob has
@export var damage = 10 # How much damage the mob deals
var can_move = true # if mob can move
var player_detected = false
var on_cooldown = false
var type = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_detected == true && $NavigationAgent2D.target_position.distance_to(position) > 310:
		#rotation = get_node('/root/Stage/Player').position.angle_to_point(position)
		$NavigationAgent2D.target_position = get_node('/root/Stage/Player').position
		var velocity = $NavigationAgent2D.get_next_path_position() - position
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			if position.x - $NavigationAgent2D.target_position.x < 0:
				$AnimatedSprite2D.flip_h = true
				#$AnimatedSprite2D.play('move')
			else:
				$AnimatedSprite2D.flip_h = false
				#$AnimatedSprite2D.play('move')
		else:
			$AnimatedSprite2D.play('default')
		if can_move:	
			position += velocity * delta
	elif player_detected == true && $NavigationAgent2D.target_position.distance_to(position) <= 310 && !on_cooldown:
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
	on_cooldown = true
	#$AnimatedSprite2D.play("attack")
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.play("default")
	can_move = true
	on_cooldown = false


func _on_detection_area_body_entered(body):
	print("+1")
	if body.type == 0:
		print("unfreeze")
		freeze = false
		player_detected = true
		$DetectionArea/CollisionShape2D.disabled = true
