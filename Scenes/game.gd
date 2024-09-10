extends Node2D

#start position
const PL_STR_POS := Vector2i(32,88)
const CM_STR_POS := Vector2i(115,64)
const GRD_STR_POS := Vector2i(128,65)
var game_running : bool

#score tracking
var score_f : float
var score_i : int

#Modifier
const SCORE_MODIFIER : int = 10
const SPEED_MODIFIER : int = 200

#movement
var speed : float
const STR_SPEED : float = 3.0
const MAX_SPEED : int = 5
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
	
	game_running = false
	
	#Restart Label
	show_score()
	$HUD.get_node("StartLabel").show()
	
	#restart position
	$Player.position = PL_STR_POS
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CM_STR_POS
	$Ground.position = GRD_STR_POS
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running == true :
		#controlling Speed
		speed = STR_SPEED + (score_i / SPEED_MODIFIER) / 5.0
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		#player movement and camera
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		#counting score
		score_f += speed/SCORE_MODIFIER
		score_i = int(score_f)
		
		show_score()
		
		#Looping Ground 
		if (($Camera2D.position.x - $Ground.position.x) > screen_size.x * 1.5):
			$Ground.position.x += screen_size.x
			
	#making game idle when player didn't start
	else:
		#initiate game_running (Start the game)
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
		
func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score_i)
