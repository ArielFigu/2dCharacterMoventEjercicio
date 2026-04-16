extends Node2D

@onready var anim = $arbolRojo


func iniciar():
	anim.play("idle")

func detener():
	anim.stop()
