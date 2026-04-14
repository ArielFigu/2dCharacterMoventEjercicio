extends Node2D
@onready var hud = $HUD
@onready var player= $Player
@onready var walls = $Walls
@onready var color= $ColorRect
func _ready() -> void:
	game_over()
func new_game():
	player.hide()
	walls.hide()
	player.set_physics_process(false)
	hud.get_node("StartButton").show()
	hud.get_node("instrucciones").hide()
	hud.get_node("Mensaje").show()


func _on_hud_start_game() -> void:
	player.show()
	player.set_physics_process(true)
	walls.show()
	
	
func game_over():
	player.hide()
	walls.hide()
	player.set_physics_process(false)
	player.velocity=Vector2.ZERO
	player.position = Vector2(100,100)
	new_game()
	
func _physics_process(delta: float) -> void:
	var limite_pantalla = get_viewport_rect().size.y

	if player.visible and player.position.y > limite_pantalla:
		hud.perdiste()
		game_over()
		
