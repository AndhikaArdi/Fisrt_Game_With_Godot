extends Node2D

#obstacle file path
var fence = preload("res://Scenes/fence.tscn")
var mushroom = preload("res://Scenes/mushroom.tscn")
var green_slime = preload("res://Scenes/green_slime.tscn")
var purple_slime = preload("res://Scenes/purple_slime.tscn")
var skeleton = preload("res://Scenes/skeleton.tscn")

#obstacle spawner
var obstacle_type := [fence, mushroom, green_slime]
var obstacle_type2 := [fence, mushroom, green_slime, purple_slime]
var obstacle : Array
var skeleton_height := [30, 64]
var ground_height : int
var ground_scale
var last_obs

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
var SPEED_PGR_MOD : float
var difficulty
const MAX_DIFFICULTY : int = 3

#movement
var speed : float
const STR_SPEED : float = 1.5
const MAX_SPEED : int = 5
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#geting screen size
	screen_size = Vector2i(232,128)
	ground_height = $Ground.get_node("Gb_Ground").texture.get_height()
	ground_scale = $Ground.get_node("Gb_Ground").scale
	#set start position
	new_game()
	
	
func new_game():
	#restart score
	score_f = 0
	score_i = 0
	
	game_running = false
	difficulty = 0
	
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
		if score_i > 1500 :
			speed = (STR_SPEED + (1500 / SPEED_MODIFIER) / 10.0) + (score_i / SPEED_MODIFIER) / 50.0
		else: 
			speed = STR_SPEED + (score_i / SPEED_MODIFIER) / 10.0
		
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		#controlling difficulty
		adjust_difficulty()
		
		#obstacle spawner
		generate_obs()
		
		#player movement and camera
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		#counting score
		score_f += speed/SCORE_MODIFIER
		score_i = int(score_f)
		
		show_score()
		
		#Looping Ground 
		if (($Camera2D.position.x - $Ground.position.x) > screen_size.x * 1.5):
			$Ground.position.x += screen_size.x * 0.69
			
		#removing obstacle that had been passed
		for obs in obstacle:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	#making game idle when player didn't start
	else:
		#initiate game_running (Start the game)
		if Input.is_action_pressed("jump_key") or Input.is_action_pressed("roll_key"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
		
func generate_obs():
	if obstacle.is_empty() or last_obs.position.x < score_i * 10 + randi_range(100,180):
		var obs_type 
		if score_i > 1500 :
			obs_type = obstacle_type2[randi() % obstacle_type2.size()]
		else: 
			obs_type = obstacle_type[randi() % obstacle_type.size()]
		
		var max_obs
		var randif_distance
		if obs_type == purple_slime :
			max_obs = 1 + 1
			randif_distance = 20
		else:
			max_obs = difficulty + 1
			randif_distance = 14
		
		var obs
		var numb_obs = randi() % max_obs + 1
		var random_distance = randi_range(100,350)
		for i in range(numb_obs):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("height_block").texture.get_height()
			var obs_scale = obs.get_node("height_block").scale
			var obs_x : int
			if i == 0 :
				obs_x = screen_size.x + score_i*10 + random_distance
			else:
				obs_x = screen_size.x + score_i*10 + random_distance + (i * randif_distance)
			var obs_y : int = screen_size.y - ((ground_height * ground_scale.y) + (obs_height * obs_scale.y/2))
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
			
		#Skeleton Spawner
		if difficulty == MAX_DIFFICULTY:
			if (randi()% 2) == 0:
				pass
				obs = skeleton.instantiate()
				var obs_x : int = screen_size.x + score_i*10 + randi_range(100,350)
				var obs_y : int = skeleton_height[randi() % skeleton_height.size()]
				add_obs(obs, obs_x, obs_y)
			
func add_obs(obs, x, y):
	obs.position = Vector2i(x,y)
	add_child(obs)
	obstacle.append(obs)
	
func remove_obs(obs):
	obs.queue_free()
	obstacle.erase(obs)
	
func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score_i)
	
func adjust_difficulty():
	difficulty = score_i / (SPEED_MODIFIER + 300)
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY
