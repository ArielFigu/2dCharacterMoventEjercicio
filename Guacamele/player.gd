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
var estaba_en_el_aire := false

func _physics_process(delta: float) -> void:
	detectar_pared()

	actualizar_direccion()
	aplicar_gravedad(delta)
	saltar()
	atacar()
	cabezazo()
	mover()

	move_and_slide()

	if not is_on_floor():
		estaba_en_el_aire = true

	if is_on_floor() and estaba_en_el_aire:
		$CaidaParticulas.global_position = $"Maker caida".global_position
		$CaidaParticulas.restart()
		estaba_en_el_aire = false

	actualizar_animacion()


func actualizar_direccion():
	if atacando or wall_jump:
		return

	if en_pared:
		var normal := get_wall_normal()
		if normal.x != 0:
			$AnimatedSprite2D.flip_h = normal.x > 0 
		#comparo la normal para a donde apunta al igual que cuando dalta si esta apunta para la derecha normal >0 flipeo spite que por default mira izq
		return

	var direction := Input.get_axis("Left", "right")
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0 
		# ya que el spritte mira a la derecha , me aseguro que si la direc da -1 flipeo izq

func aplicar_gravedad(delta):
	if esta_congelado:
		return

	if not is_on_floor():
		var gravedad = get_gravity().y

		if en_pared:
			var input_direccion := Input.get_axis("Left", "right")
			var normal := get_wall_normal()

			if input_direccion != 0 and sign(input_direccion) == -sign(normal.x):
			# si la normal de la superficie no coinciden o en su defectp con el -(normal) coinciden se queda pegado
				velocity.y = 0
				return
			else:
				gravedad *= 0.3#gravedad deñ desliz

		elif velocity.y < 0:
			gravedad *= 0.6#gravedad de saltar
		else:
			gravedad *= 1.3

		velocity.y += gravedad * delta

func detectar_pared():
	en_pared = not is_on_floor() and is_on_wall()

func saltar():
	if atacando:
		return

	if Input.is_action_just_pressed("Jump"):
		if en_pared:
			saltar_en_pared()
			return

		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			$SaltoParticulas.global_position = $MakerSalto.global_position
			$SaltoParticulas.restart()
			cambiar_animacion("Jump")
func saltar_en_pared():
	if not en_pared:
		return

	var direccion := Input.get_axis("Left", "right")
	if direccion == 0:
		return

	var normal := get_wall_normal()

	if sign(direccion) == sign(normal.x):
		wall_jump = true
		velocity.y = JUMP_VELOCITY
		velocity.x = normal.x * walk_Speed * 3

		$AnimatedSprite2D.flip_h = velocity.x > 0

		cambiar_animacion("wallJump")

func atacar():
	if Input.is_action_just_pressed("Puño") and Input.is_action_pressed("up") and not atacando:
		atacando = true
		esta_congelado = false
	
		velocity.y = -490
		
		var direccion = -1 if $AnimatedSprite2D.flip_h else 1
		velocity.x = direccion * 200
		
		cambiar_animacion("punchUP")

		if direccion > 0:
			$PuñoParticulas.global_position = $"MakerPuño".global_position
			$PuñoParticulas.rotation_degrees = 0
		else:
			$PuñoParticulas.global_position = $"MakerPuño2".global_position
			$PuñoParticulas.rotation_degrees = 180

		$PuñoParticulas.restart()
func cabezazo():
	if Input.is_action_just_pressed("Puño") and (Input.is_action_pressed("Left") or Input.is_action_pressed("right")) and not atacando:
		atacando = true
		esta_congelado = true
		velocity = Vector2.ZERO
		
		cambiar_animacion("headHit")

func mover():
	var direccion := Input.get_axis("Left", "right")

	if atacando:
		return

	if en_pared and not wall_jump:
		velocity.x = 0
		return

	if wall_jump:
		return

	if direccion != 0:
		velocity.x = direccion * walk_Speed  # anotacion pa mi sin la direccion no rota
	else:
		velocity.x = 0




func actualizar_animacion():
	if atacando:
		return

	if is_on_floor() or velocity.y > 10:
		wall_jump = false

	if wall_jump:
		cambiar_animacion("wallJump")
		return

	if en_pared:
		cambiar_animacion("Pared")
		return

	if not is_on_floor():
		if velocity.y < 0 and not atacando:
			cambiar_animacion("Jump")
		else:
			cambiar_animacion("fall")
		return
	if abs(velocity.x) > 1: 
		cambiar_animacion("walk")
	else:
		cambiar_animacion("idle")

func cambiar_animacion(nombre):
	if $AnimatedSprite2D.animation != nombre:
		$AnimatedSprite2D.play(nombre)
		
		
		


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation in ["punchUP", "headHit"]:
		esta_congelado=false
		atacando=false



func _on_animated_sprite_2d_animation_changed() -> void:
	var animacion = $AnimatedSprite2D.animation

	match animacion:
		"Jump":
			$AudioAccion.stream = sonido_Jump
			$AudioAccion.play()

		"fall":
			$AudioAccion.stream = sonido_Fall
			$AudioAccion.play()

		"punchUP":
			$AudioAccion.stream = sonido_PunchUp
			$AudioAccion.play()

		"headHit":
			$AudioAccion.stream = sonido_HeadHit
			$AudioAccion.play()   

		"wallJump":
			$AudioAccion.stream = sonido_JumpWalk
			$AudioAccion.play()
		"walk":
			$AudioAccion.stream = sonido_Walk
			$AudioAccion.play()
