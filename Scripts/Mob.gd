extends RigidBody2D

@export var speed = 150 # How fast the mob will move (pixels/sec).
@export var health = 20 # How much health the mob has
@export var damage = 3 # How much damage the mob deals
var can_move = true # if mob can move
var player_detected = false
var type = 1
var on_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_detected == true && $NavigationAgent2D.target_position.distance_to(position) > 35:
		rotation = get_node('/root/Main/Stage/Player').position.angle_to_point(position)
		$NavigationAgent2D.target_position = get_node('/root/Main/Stage/Player').position
		var velocity = $NavigationAgent2D.get_next_path_position() - position
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		else:
			$AnimatedSprite2D.play('default')
		if can_move:
			$AnimatedSprite2D.play('move')
			position += velocity * delta
	elif player_detected == true && $NavigationAgent2D.target_position.distance_to(position) <= 35 && on_cooldown == false:
		on_cooldown = true
		attack()
		$NavigationAgent2D.set_target_position(get_node('/root/Main/Stage/Player').position)


func take_damage(damage_taken :int):
	if health - damage_taken > 0:
		# HIt animation 
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(0.2).timeout 
		$AnimatedSprite2D.show()
		health -= damage_taken
	elif health - damage_taken <= 0:
		health = 0
		can_move = false
		$CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.hide()
		$AttackCollisionShape2D.set_deferred("disabled", true)
		$AttackCollisionShape2D.hide()
		$AnimatedSprite2D.play('dead')
		freeze = true
		player_detected = false
		$AnimatedSprite2D.z_index = -1

func attack():
	can_move = false
	$AnimatedSprite2D.play("attack")
	$AttackCollisionShape2D.set_deferred("disabled", false)
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.play("default")
	$AttackCollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", false)
	can_move = true
	await get_tree().create_timer(0,5).timeout
	on_cooldown = false
	


func _on_detection_area_body_entered(body):
	if body.type == 0 && health > 0:
		freeze = false
		player_detected = true
		$DetectionArea/CollisionShape2D.disabled = true
