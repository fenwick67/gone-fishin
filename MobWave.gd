extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var n_enemies = 10.0
export (PackedScene) var enemy
var margin = 20.0

var mobSeed = 5
var t

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if !enemy:
		print('no enemy to spawn in wave')
		return
		
	var i = 0.0
	while i < n_enemies:
		i = i + 1.0
		var x = margin + (i-0.5)/(n_enemies)*(320-2*margin)
		var n = enemy.instance()
		n.position.x = x
		add_child(n)
	t = 0.0
	updatePosition()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	t+= delta
	updatePosition()

func updatePosition():
	var swaySpeed = -1 + mobSeed % 3 
	var swayAmnt = (mobSeed % 6)*10
	var swaySpeedY = -1 + mobSeed % 2
	var swayAmntY = (mobSeed % 6)*9
	position.x = cos(swaySpeed * t*2)*swayAmnt
	position.y = -55 + cos(swaySpeedY * t)*swayAmntY 
	# subtract 55 because we don't want to flash at top of screen
