extends RigidBody2D

@export var projectile_scene: PackedScene
@export var speed = 100 # How fast the mob will move (pixels/sec).
@export var health = 30 # How much health the mob has
@export var damage = 7 # How much damage the mob deals
var can_move = true # if mob can move
var player_detected = false
var on_cooldown = false
var type = 1
var projectile_spawn = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_detected == true && $NavigationAgent2D.target_position.distance_to(position) > 200:
		#rotation = get_node('/root/Stage/Player').position.angle_to_point(position)
		$NavigationAgent2D.target_position = get_node('/root/Main/Stage/Player').position
		var velocity = $NavigationAgent2D.get_next_path_position() - position
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			if position.x - $NavigationAgent2D.target_position.x < 0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play('move')
				projectile_spawn = Vector2(61, 0)
			else:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play('move')
				projectile_spawn = Vector2(-61, 0)
		else:
			$AnimatedSprite2D.play('default')
		if can_move:	
			position += velocity * delta
	elif player_detected == true && $NavigationAgent2D.target_position.distance_to(position) <= 200 && !on_cooldown:
		$AnimatedSprite2D.play('default')
		$NavigationAgent2D.target_position = get_node('/root/Main/Stage/Player').position
		if position.x - $NavigationAgent2D.target_position.x < 0:
			$AnimatedSprite2D.flip_h = true
			projectile_spawn = Vector2(30, 0)
			#$RayCast2D.position = Vector2(30, 0)
		else:
			$AnimatedSprite2D.flip_h = false
			projectile_spawn = Vector2(-30, 0)
			#$RayCast2D.position = Vector2(-30, 0)
		$RayCast2D.target_position = (get_node('/root/Main/Stage/Player').position - position) * 2
		print($RayCast2D.target_position, get_node('/root/Main/Stage/Player').position)
		print($RayCast2D.get_collider())
		if $RayCast2D.get_collider() != null && $RayCast2D.get_collider().type == 0:
			on_cooldown = true
			attack()
			await get_tree().create_timer(1).timeout
			on_cooldown = false
		else:
			$NavigationAgent2D.set_target_position(get_node('/root/Main/Stage/Player').position)
			$RayCast2D.target_position = (get_node('/root/Main/Stage/Player').position - position) * 2

func take_damage(damage_taken :int):
	if health - damage_taken > 0:
		health -= damage_taken
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(0.2).timeout 
		$AnimatedSprite2D.show()
	elif health - damage_taken <= 0:
		health = 0
		can_move = false
		$CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.hide()
		$AnimatedSprite2D.play('dead')
		freeze = true
		player_detected = false
		$AnimatedSprite2D.z_index = -1

func attack():
	can_move = false
	$AnimatedSprite2D.play("attack")
	await get_tree().create_timer(0.3).timeout
	var projectile = projectile_scene.instantiate()
	projectile.position = projectile_spawn
	call_deferred("add_child", projectile)
	$AnimatedSprite2D.play("default")
	can_move = true
	await get_tree().create_timer(1).timeout


func _on_detection_area_body_entered(body):
	if body.type == 0 && health > 0:
		freeze = false
		player_detected = true
		$DetectionArea/CollisionShape2D.disabled = true
		$RayCast2D.enabled = true
