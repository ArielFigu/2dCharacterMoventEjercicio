extends CanvasLayer


signal start_game

func _ready():
	$instrucciones.hide()
	$Mensaje.text = "Aprende a mover al luchador"
	$Mensaje.show()
	$StartButton.show()




func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Mensaje.hide()
	$instrucciones.show()

	start_game.emit()
	
func perdiste():
	$StartButton.show()
	$Mensaje.text = "Perdiste - presiona Start"
	$Mensaje.show()
	$instrucciones.hide()
