extends KinematicBody

const Gravidade = -30.8#responsavel pela gravidade do jogo
var vel = Vector3()#velcidadeocidadeocidade
const MAX_SPEED = 50#velocidadeocidade maxima
const JUMP_SPEED = 20#velocidade de pulo
const ACCEL= 3#aceleração
const MAX_SPRINT_SPEED = 40
const SPRINT_ACCEL = 18
var is_sprinting = false
var os
var flashlight
var dir = Vector3()#direção
var vrmode
var direcao
const DEACCEL= 16#frenagem
const MAX_SLOPE_ANGLE = 40#angulo maximo de inclinação

var camera#camera
var cabeca#auxiliar de ratação/cabeça

var MOUSE_SENSITIVITY = 0.1#sensibilidade do mouse


func _ready():
	Engine.set_target_fps(60)
	flashlight = $cabeca/Flashlight
	camera = $cabeca/Camera
	cabeca = $cabeca
	os=OS.get_name()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if os=="Windows"  and VRNODE.VR==false:
		vrmode=false
	elif os=="Windows" and VRNODE.VR==true:
		vrmode=true
	elif os=="Android" and VRNODE.VR==false:
		vrmode=false
	elif os=="Android" and VRNODE.VR==true:
		vrmode=true
	elif os=="HTML5" and VRNODE.VR==false:
		vrmode=false
	if os=="Windows":
		pass
		get_node("Control").hide()
	if vrmode==true:
		get_node("Control").hide()


func _physics_process(delta):
	
	process_input(delta)
	process_movement(delta)


func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()#direcao
	if Input.is_action_just_pressed("vrmode"):
		if vrmode==true:
			vrmode=false
		else:
			vrmode=true
	if vrmode==true:
		get_node("cabecavr/ARVROrigin/ARVRCamera").current
		camera = $cabecavr/ARVROrigin/ARVRCamera
		cabeca = $cabecavr
	else:
		camera = $cabeca/Camera
		cabeca = $cabeca
		
		get_node("cabeca/Camera").current
	var cam_xform = camera.get_global_transform()#vai pegar a forma como a camera esta posicionada e salvar como variavel

	var vetor_de_movimento = Vector2() #determina o vetor de movimento

	if Input.is_action_pressed("movement_forward") or direcao==8:
		vetor_de_movimento.y += 4
	if Input.is_action_pressed("movement_backward") or direcao==2:
		vetor_de_movimento.y -= 4
	if Input.is_action_pressed("movement_left")or direcao==4:
		vetor_de_movimento.x -= 4
	if Input.is_action_pressed("movement_right")or direcao==6:
		vetor_de_movimento.x = 4


	vetor_de_movimento = vetor_de_movimento.normalized()

	dir += -cam_xform.basis.z.normalized() * vetor_de_movimento.y
	dir += cam_xform.basis.x.normalized() * vetor_de_movimento.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta*Gravidade

	var hvel = vel
	hvel.y = 0

	var target = dir
	if Input.is_action_pressed("movement_sprint"):
		is_sprinting = true
	else:
		is_sprinting = false
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel*delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and not os=="Android" and vrmode==false:
		cabeca.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = cabeca.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		cabeca.rotation_degrees = camera_rot
	elif event is InputEventScreenDrag and os =="Android" and vrmode==false:
		cabeca.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = cabeca.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		cabeca.rotation_degrees = camera_rot
		
	# ----------------------------------
# Sprinting

# ----------------------------------

# ----------------------------------
# Turning the flashlight on/off
	if Input.is_action_just_pressed("flashlight") and vrmode==false:
		if flashlight.is_visible_in_tree():
			flashlight.hide()
		elif os=="HTML5":
			flashlight.hide()
		else:
			flashlight.show()
# ----------------------------------

func _on_Esquerda_pressed():
	direcao=4
	pass # replace with function body


func _on_Cima_pressed():
	direcao=8
	pass # replace with function body


func _on_Direita_pressed():
	direcao=6
	pass # replace with function body


func _on_Baixo_pressed():
	direcao=2
	pass # replace with function body


func _on_Esquerda_released():
	direcao=0


func _on_Cima_released():
	direcao=0


func _on_Direita_released():
	
	direcao=0


func _on_Baixo_released():
	direcao=0
