extends Area2D
 
@export var item_type :String

# Called when the node enters the scene tree for the first time.
func _ready():
	var options = ["health_pickup", "damage_pickup", "movespeed_pickup", "attackspeed_pickup"]
	item_type = options[randi_range(0, 3)]
	match item_type:
		"health_pickup":
			$Sprite2D.texture = load("res://Assets/health_pickup.png")
		"damage_pickup":
			$Sprite2D.texture = load("res://Assets/damage_pickup.png")
		"movespeed_pickup":
			$Sprite2D.texture = load("res://Assets/movespeed_pickup.png")
		"attackspeed_pickup":
			$Sprite2D.texture = load("res://Assets/attackspeed_pickup.png")

func gain_buff(body):
	$Sprite2D.hide()
	match item_type:
		"health_pickup":
			body.max_health += 50
			body.health = body.max_health
			get_node('/root/Main/Stage/Player/ProgressBar').max_value = body.max_health
			get_node('/root/Main/Stage/Player/ProgressBar').value = body.health
			$Label.show()
			$Label.text = "+50 MaxHp"
		"damage_pickup":
			get_node('/root/Main/Stage/Player/Weapon').damage += 10
			$Label.show()
			$Label.text = "+10 Dmg"
		"movespeed_pickup":
			body.speed += 50
			$Label.show()
			$Label.text = "+25% Spd"
		"attackspeed_pickup":
			get_node('/root/Main/Stage/Player/Weapon').cooldown -= 0.2
			$Label.show()
			$Label.text = "+20% ASpd"

func _on_body_entered(body):
	if body.type == 0:
		gain_buff(body)
		await get_tree().create_timer(2).timeout
		queue_free()
