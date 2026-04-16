extends Node2D

@onready var fire = $Fire
@onready var animacion = $AnimationPlayer

func _ready():
	fire.stop()
	animacion.stop()

func iniciar():
	fire.play("idle")
	animacion.play("parpadeo")

func detener():
	fire.stop()
	animacion.stop()
