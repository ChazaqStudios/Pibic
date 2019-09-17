extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	_process(true)

func _process(delta):
	var vr=get_parent().vrmode
	if vr==true:
		var arvr_interface = ARVRServer.find_interface("Native mobile")
		if arvr_interface and arvr_interface.initialize():
			get_viewport().arvr = true
			pass
	else:
		var arvr_interface = ARVRServer.find_interface("Native mobile")
		if arvr_interface and arvr_interface.initialize():
			get_viewport().arvr = false