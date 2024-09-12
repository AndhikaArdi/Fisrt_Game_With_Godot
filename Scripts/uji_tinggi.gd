extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#mendapat tinggi Sprited dari texture nya (gambar besar)
	var ST_height = get_node("Sprite2D2").texture.get_height()
	#print(ST_height)
	
	#mendapat tinggi Sprited dari texture yg sudah di region
	var SR_height = get_node("Sprite2D2").region_rect.size.y
	#print(SR_height)
	
	#mendapat Full region dari Sprited
	#var S_Region = get_node("Sprite2D2").region_rect
	#output -> [P: (0.175411, -0.09466), S: (31.9444, 32.0313)]
	
	#mendapat scale dari Sprited
	var S_scale = get_node("Sprite2D2").scale
	#print(S_scale)
	#print(SR_height * S_scale.y)
	#print(ST_height * S_scale.y)

#===============================================================

	var invisible_ST_height = get_node("Sprite2D_sml").texture.get_height()
	print(invisible_ST_height)
	
	var invisible_S_scale = get_node("Sprite2D_sml").scale
	print(invisible_S_scale)
	print(invisible_ST_height * invisible_S_scale.y)
