extends RigidBody2D

@export var speed = 150 # How fast the mob will move (pixels/sec).
@export var health = 20 # How much health the mob has
@export var damage = 10 # How much damage the mob deals
@export var exp = 10
var can_move = true # if mob can move
var player_detected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_detected == true:
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


func _on_detection_area_entered(area):
	freeze = false
	player_detected = true
	$DetectionArea.hide()

func take_damage(damage_taken :int):
	if health - damage_taken > 0:
		health -= damage_taken
	elif health - damage_taken <= 0:
		health = 0
		can_move = false
		$CollisionShape2D.hide()
		get_node('/root/Stage/Player').current_exp += exp
		queue_free()

func attack():
	can_move = false
	await get_tree().create_timer(0.6).timeout
	#recover
	can_move = true
