extends KinematicBody2D
signal hit

export (float) var health = 1

var isDead = false
var SCROLL_SPEED

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AnimationPlayer.play("idle")
	SCROLL_SPEED = Global.SCROLL_SPEED

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	position.y += delta*SCROLL_SPEED

# bullet will call this
func take_hit():
	$enemyhit.play()
	health -= 1
	if (health <= 0):
		isDead = true
		# show dead animation
		$AnimationPlayer.play("dead")
		$CollisionShape2D.rotate(PI/2)