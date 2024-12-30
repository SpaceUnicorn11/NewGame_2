extends Node

signal left_click
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node('/root/Main/Stage/Player/Camera/DialogInterface/Panel').visible == true && Input.is_action_just_pressed("left_click"):
		left_click.emit()

func _on_dialog_area_1_body_entered(body):
	$DialogArea1/CollisionShape2D.hide()
	$DialogArea1/CollisionShape2D.set_deferred("disabled", true)
	get_node('/root/Main/Stage/Player/Camera/DialogInterface/Panel/DialogText').text = "I am in a cave. Why?"
	get_node('/root/Main/Stage/Player/Camera/DialogInterface/Panel').show()
	get_node('/root/Main/Stage/Player/Camera/DialogInterface').next_evil_dialog()
	await left_click 
	get_node('/root/Main/Stage/Player/Camera/DialogInterface/Panel/DialogText').text = "RAWRRRRR!!! LEAVE US ALONE!! WE LIVED HERE FOR MILLIONS OF YEARS, AND WE WILL LIVE MILLIONS MORE!"
	get_node('/root/Main/Stage/Player/Camera/DialogInterface').next_t_rex_dialog()
	await left_click
	get_node('/root/Main/Stage/Player/Camera/DialogInterface/Panel').hide()
