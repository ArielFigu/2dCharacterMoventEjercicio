extends CharacterBody2D

@export_range(0,160.0,1) var Walk_Speed: float =100
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
var walk_jump := false

func _physics_process(delta: float) -> void:
	detectar_pared()
	saltar()
	atacar()
	cabezazo()
	mover()
	limitar_velocidad ()
	move_and_slide()
	cambiar_animacion()

func mover():
	var direction := Input.get_axis("Left", "right")
	if 
