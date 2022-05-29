extends Panel

var show: bool = false

func _process(delta):
	
	if Input.is_action_just_pressed("toggle_controls"):
		show = !show
		
func _physics_process(delta):
	if show:
		modulate.a = clamp(modulate.a + .1, 0, 1)
	else:
		modulate.a = clamp(modulate.a - .1, 0, 1)
		
func toggle():
	show = !show
