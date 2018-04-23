extends Node2D

export (String) var nextLevel

export (int) var duration = 30
export (int) var waves = 10
export (int) var minScore = 5
export (String) var levelName = ""

var Wave = ResourceLoader.load("res://MobWave.tscn")
var barrel

var waveArr = []
var waveIdx = -1
var t

var player

var goalLabel
var levelLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var i = 0
	while i < waves:
		var w = Wave.instance()
		w.n_enemies = 1+ int(i+i*sin(i) + waves*waves+5) % 8
		w.mobSeed = 1+ int(i+i*sin(i) + waves*waves+5)
		waveArr.push_back( w )
		i = i + 1
	
	player = Global.player
	t = 0
	levelLabel = $LevelLabel
	goalLabel = $GoalLabel
	
	levelLabel.text = "LEVEL "+levelName
	goalLabel.text = "GOAL: "+str(minScore)+" FISH"
	barrel = $Barrel
	barrel.position.x=300
	barrel.position.y=-100	
		

func _process(delta):
	t+= delta
	# Called every frame. Delta is time since last frame.
	# Update game logic here.

	# do we need to spawn another wave?
	var shouldBeIndex = waves*t / duration - 1
	if waveIdx < shouldBeIndex and waveIdx < waves - 1:
		waveIdx+= 1
		# print('adding wave'+str(waveIdx)+'at t='+str(t))
		add_child(waveArr[waveIdx])
		
	# update UI to show if we won or not
	if t > duration + 5:
		# end the level
		if (minScore > player.fishCount):
			$WinLabel.text = "YOU FAILED!"
		else:
			$WinLabel.text = "SUCCESS"
			
	# actually restart or go ot next level
	if t > duration + 8:
		if (minScore > player.fishCount):
			Global.restart_level()
		else:
			progress()
		
	if t > 3:
		levelLabel.hide()
		goalLabel.hide()

	if Input.is_action_just_pressed("ui_next_level"):
		progress()
		
	barrel.position.y=-1.0 * t * (1 - t/duration) * Global.SCROLL_SPEED - 200
	barrel.position.x = 300

func progress():
	
	if nextLevel and nextLevel != "Null":
		Global.goto_scene(nextLevel)
	else:
		print("no next level set")