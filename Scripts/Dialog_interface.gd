extends CanvasLayer

var evil_dialog_lines = []
var evil_line_counter = 0
var t_rex_dialog_lines = []
var t_rex_line_counter = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	evil_dialog_lines.append("I am in a cave. Why?")
	evil_dialog_lines.append("Ah, yes, i wanted to hunt a T-Rex. That's why i brought my harpoon. I should get started then.")
	evil_dialog_lines.append("Stupid lizards can't even use buffs. How did they survive for so long?")
	evil_dialog_lines.append("Someone tell Veeduuul, there is a problem with my AI.")
	evil_dialog_lines.append("I was just joking. I don't have those kind problems anymore.")
	evil_dialog_lines.append("Why do you look like this? Are you even a T-Rex?")
	evil_dialog_lines.append("YAY! I LOVE BONE DUST!")
	evil_dialog_lines.append("Yes. But i like your cave. Maybe i can return here with my sister and blow it up.")
	
	t_rex_dialog_lines.append("RAWRRRRR!!! LEAVE US ALONE!! WE LIVED HERE FOR MILLIONS OF YEARS, AND WE WILL LIVE MILLIONS MORE!")
	t_rex_dialog_lines.append("WE ARE STRONG! WE DON'T NEED YOUR HEALTH PACKS AND DAMAGE BOOSTS!")
	t_rex_dialog_lines.append("REALLY? NOW? I GUESS WE WON THEN! DINOSAURS WILL LIVE FOREVER!!")
	t_rex_dialog_lines.append("SO YOU MADE IT HERE! IMPRESSIVE! BUT NOW YOU FACING THE STRONGEST OF US! YOUR RAMPAGE STOPS HERE!")
	t_rex_dialog_lines.append("...that's an old picture...and maybe slightly photoshopped... NOW COME HERE SO I CAN CRUSH YOUR BONES INTO DUST!!!")
	t_rex_dialog_lines.append("Is that how this ends? An entire dinosaurus civilization destroyed? I've seen things you people wouldn't believe. The skys ablaze when the meteorite fell to the Earth. The land froze during the Ice Age. All those moments will be lost in time, like tears in rain..............")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func next_evil_dialog():
	$Panel.show()
	$"Panel/T-rexImage".hide()
	$Panel/EvilImage.show()

func next_t_rex_dialog():
	$Panel.show()
	$Panel/EvilImage.hide()
	$"Panel/T-rexImage".show()
