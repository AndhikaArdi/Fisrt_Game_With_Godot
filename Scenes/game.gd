extends Node2D

#start position
const PL_STR_POS := Vector2i(32,88)
const CM_STR_POS := Vector2i(115,64)
const GRD_STR_POS := Vector2i(128,65)

#score tracking
var score_f : float
var score_i : int

#movement
var speed : float
const STR_SPEED : float = 1.0
const MAS_SPEED : int = 8
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#geting screen size
	screen_size = Vector2i(145,0)
	#set start position
	new_game()

func new_game():
	#restart score
	score_f = 0
	score_i = 0
	#restart position
	$Player.position = PL_STR_POS
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CM_STR_POS
	$Ground.position = GRD_STR_POS
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = STR_SPEED
	
	#player movement and camera
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	score_f += speed/8
	score_i = int(score_f)
	#print(score_i)
	
	if (($Camera2D.position.x - $Ground.position.x) > screen_size.x * 1.5):
		$Ground.position.x += screen_size.x
		
