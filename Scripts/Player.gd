extends Area2D


@export var speed = 200 # How fast the player will move (pixels/sec).
@export var max_health = 50 # Players max health
var health = 5000 # Players current health
var can_move = true # If player can move
var current_exp :int = 0 # Player current exp
var next_level_exp = 50 # How much exp to next level

signal hit # Emits when player takes damage
signal healed # Emits when player gains health
signal dead # Emits when dead
signal exp_gained # Emits when gained exp
signal level_up # Emits when level up

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Weapon.rotation = get_global_mouse_position().angle_to_point(position)
	var velocity = Vector2.ZERO # The player's movement vector.
	var player_facing_direction = Vector2(0, 0) # Player facing direction
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		player_facing_direction.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		player_facing_direction.x = -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		player_facing_direction.y = 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		player_facing_direction.y = -1

	if velocity.length() > 0 && can_move:
		velocity = velocity.normalized() * speed
		#if player_facing_direction.x < 0:
			#$AnimatedSprite2D.flip_h = true
			#$AnimatedSprite2D.play('move')
		#else:
			#$AnimatedSprite2D.flip_h = false
			#$AnimatedSprite2D.play('move')	
	#elif can_move:
		#$AnimatedSprite2D.play('default')
		
	if can_move:	
		position += velocity * delta
		position = position.clamp(Vector2(50, 70), Vector2(1950, 1950))
		#if player_facing_direction.length() > 0:
			#$Weapon.direction = player_facing_direction.normalized()
	
	if Input.is_action_pressed("shoot") && $Weapon.visible == true:
		$Weapon.shoot()

	
func death():
	can_move = false
	#$AnimatedSprite2D.play('dead')
	#$DeathSound.play()
	await get_tree().create_timer(2).timeout
	dead.emit()
#
#func gain_health(gained_health):
	#max_health += gained_health
	#health += gained_health
	#healed.emit(health, max_health)
#
#func gain_exp(gained_exp :int):
	#if current_exp < next_level_exp:
		#current_exp += gained_exp
		#exp_gained.emit(current_exp)
	#if current_exp >= next_level_exp:
		#current_exp	-= next_level_exp
		#next_level_exp += 50
		#exp_gained.emit(current_exp)
		#level_up.emit(next_level_exp)


func _on_body_entered(body):
	body.attack()
	if health - body.damage > 0:
		health -= body.damage
		hit.emit(health)
		# HIt animation 
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(0.1).timeout 
		$AnimatedSprite2D.show()
		# Iframes
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(0.3).timeout
		$CollisionShape2D.set_deferred("disabled", false)
	else: 	
		health = 0 
		hit.emit(health)
		death()
