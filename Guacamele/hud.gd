extends CanvasLayer


signal start_game

func _ready():
	$instrucciones.hide()
	$Mensaje.text  = "Aprende a mover al luchador"
	$StartButton.show()
	

func _on_start_button_pressed() -> void:
	print("BOTON APRETADO")
	$Mensaje.hide()
	$StartButton.hide()

	$instrucciones.show()
	
