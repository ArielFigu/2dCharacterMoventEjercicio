extends ParallaxBackground



func _process(delta: float) -> void:
	var velocidad= 20
	scroll_base_offset.x-=velocidad*delta
