extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var sys

#func _ready():

	
func _process(delta):
	pass
	#InputEvent
	#get_node("Label").set_text(InputEvent)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_modenormal_pressed():
	get_tree().change_scene("res://Cenas/jornada.tscn")



func _on_vrmode_pressed():
	VRNODE.VR()
	get_tree().change_scene("res://Cenas/jornada.tscn")
