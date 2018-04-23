extends Area2D

var SPEED = 200
var MAX_LIFE = 10

var age

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	age = 0
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	position.y -= SPEED*delta
	age+= delta
	if age > MAX_LIFE or position.y < 0:
		queue_free()

func _on_Bullet_body_entered(body):
	# this means the boolet hit an enemy
	if !body.isDead:
		queue_free()
	body.take_hit()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

