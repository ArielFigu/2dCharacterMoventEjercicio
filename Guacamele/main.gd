extends Node2D
@onready var hud = $HUD
@onready var player= $Player
#@onready var walls = $Walls
@onready var arbol = $Arbol
@onready var plataform=$colisiones
@onready var color= $ColorRect
@onready var lluvia= get_node("ColorRect/ParalaxFondo/ParallaxBackground/Lluvia/CPUParticles2D")
@onready var fogata=$fogata
func _ready() -> void:
	game_over()       # se que todo el main esta overcode.. que cada funcion animada pudo haver condtenifo su hide o show pero asi . 
func new_game():# me senti mas en control de llo que veo y que ,momento de la escena
				   #a su vez si el start game lo indica el Botton el bucle new game game over. podria estar reducido y emplementar una 
					 # señal en player que detone game over , y asi diferenciar new con game over que son una copia solo que uno con 
					# condicion de "derrota"
	player.hide()
	#walls.hide()
	lluvia.hide()
	arbol.hide()
	plataform.hide()
	fogata.hide()
	
	player.set_physics_process(false)
	hud.get_node("StartButton").show()
	hud.get_node("instrucciones").hide()
	hud.get_node("Mensaje").show()


func _on_hud_start_game() -> void:
	player.show()
	player.set_physics_process(true)
	#walls.show()
	#$Suelo.show()
	lluvia.show()
	arbol.show()
	arbol.iniciar()
	fogata.show()
	fogata.iniciar()
	plataform.show()
	
	
func game_over():
	player.hide()
	#walls.hide() Esto quedo del codigo  aneror antes del title
	#$Suelo.hide()
	lluvia.hide()
	plataform.hide()
	player.set_physics_process(false)
	player.velocity=Vector2.ZERO
	player.position = Vector2(100,100)
	new_game()
	
func _physics_process(delta: float) -> void:
	var limite_pantalla = get_viewport_rect().size.y

	if player.visible and player.position.y > limite_pantalla:
		hud.perdiste()
		game_over()
		
