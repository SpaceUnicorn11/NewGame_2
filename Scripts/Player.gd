extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
@export var max_health = 50 # Players max health
var health = 50 # Players current health
var can_move = true # If player can move
var type = 0
var moving_direction = Vector2(0, 0)

signal hit # Emits when player takes damage
signal healed # Emits when player gains health
signal dead # Emits when dead

func _ready():
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Weapon.rotation = get_global_mouse_position().angle_to_point(position)
	moving_direction = Vector2(0, 0)
	var player_facing_direction = Vector2(0, 0) # Player facing direction
	if Input.is_action_pressed("move_right"):
		moving_direction.x += 1
		player_facing_direction.x += 1
	if Input.is_action_pressed("move_left"):
		moving_direction.x -= 1
		player_facing_direction.x = -1
	if Input.is_action_pressed("move_down"):
		moving_direction.y += 1
		player_facing_direction.y = 1
	if Input.is_action_pressed("move_up"):
		moving_direction.y -= 1
		player_facing_direction.y = -1

	if moving_direction.length() > 0 && can_move:
		moving_direction = moving_direction.normalized() * speed
	elif can_move:
		$AnimatedSprite2D.play('default')
	
	if Input.is_action_pressed("shoot") && $Weapon.visible == true && health > 0:
		$Weapon.shoot()
		
func _physics_process(delta):
	if can_move == true:
		$AnimatedSprite2D.play('move')
		velocity = moving_direction.normalized() * speed
		move_and_slide()
	
func death():
	can_move = false
	$Weapon.set_deferred("disabled", true)
	$Weapon.hide()
	$AnimatedSprite2D.play('dead')
	#$DeathSound.play()
	await get_tree().create_timer(3).timeout
	dead.emit()


func _on_body_entered(body):
	if body.type == 2:
		body.hit()
	if body.type != 3 && health - body.damage > 0:
		health -= body.damage
		$ProgressBar.value = health
		hit.emit(health)
		# HIt animation 
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(0.2).timeout 
		$AnimatedSprite2D.show()
		# Iframes
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(0.3).timeout
		$CollisionShape2D.set_deferred("disabled", false)
	elif body.type != 3: 	
		health = 0 
		$ProgressBar.value = health
		hit.emit(health)
		death()
