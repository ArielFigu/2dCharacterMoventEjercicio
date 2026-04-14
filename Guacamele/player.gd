extends CharacterBody2D

@export_range(0,160.0,1) var walk_Speed: float =100
const JUMP_VELOCITY = -400.0
var sonido_Walk = preload("res://Guacamele/Sounds/Correr.ogg")
var sonido_Jump = preload("res://Guacamele/Sounds/Jump.ogg")
var sonido_JumpWalk = preload("res://Guacamele/Sounds/JumpWalk.ogg")
var sonido_Fall = preload("res://Guacamele/Sounds/Fall.ogg")
var sonido_PunchUp = preload("res://Guacamele/Sounds/PunchUp.ogg")
var sonido_HeadHit = preload("res://Guacamele/Sounds/Cabezazo.ogg")


var atacando : = false
var  esta_congelado : = false 
var en_pared := false
var wall_jump := false

func _physics_process(delta: float) -> void:
	if esta_congelado:
		return

	if not is_on_floor():
		var gravedad = get_gravity().y

		if en_pared:
			var input_dir := Input.get_axis("move_left", "move_right")
			var normal := get_wall_normal()

			if input_dir != 0 and sign(input_dir) == -sign(normal.x): 
				# si la normal de la superficie no coinciden o en su defectp con el -(normal) coinciden se queda pegado
				velocity.y = 0
				return
			else:
				gravedad *= 0.3 #gravedad deñ desliz

		elif velocity.y < 0:
			gravedad *= 0.6 #gravedad de saltar
		else:
			gravedad *= 1.3

		velocity.y += gravedad * delta

	#detectar_pared()
	saltar()
	#atacar()
	#cabezazo()
	mover()
	#limitar_velocidad ()
	move_and_slide()
	#cambiar_animacion()
func saltar_en_pared():
	if not en_pared:
		return

	var direccion := Input.get_axis("move_left", "move_right")
	if direccion == 0:
		return

	var normal := get_wall_normal()

	if sign(direccion) == sign(normal.x):
		wall_jump = true
		velocity.y = JUMP_VELOCITY
		velocity.x = normal.x * walk_Speed * 1.8

func mover():
	var direccion := Input.get_axis("Left", "right")
	if atacando:
		return
	if en_pared:
		velocity.x= 0
		return
	if wall_jump:
		return
	if direccion != 0:
		velocity.x = direccion* walk_Speed  # anotacion pa mi sin la direccion no rota
	else:
		velocity.x = 0 
func saltar():
	if atacando:
		return
	
	if Input.is_action_just_pressed("Jump"):
		if en_pared:
			saltar_en_pared()
			return

	
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
