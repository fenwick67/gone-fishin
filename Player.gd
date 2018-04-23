extends Area2D
signal hit

export (PackedScene) var bullet

# public
var health
var fishCount = 0

# consts
var SPEED = 300
var BULLET_RATE = 0.5

# child refs
var sprite
var animationPlayer
var healthBar
var scoreLabel
var background
var music
var engine

var t
var timeSinceLastBullet

# for hacking later
var canShoot = true

# movement
var velocity = Vector2(0,0)

func _ready():
	animationPlayer = $AnimationPlayer
	healthBar = get_parent().find_node("Health")
	sprite = $Sprite
	scoreLabel = get_parent().find_node("Score")
	background = get_parent().find_node("bg")
	music = get_parent().find_node("bgm")
	
	Global.player = self
	
	health = 10
	fishCount = 0
	t = 0
	timeSinceLastBullet = 1000.0

	# Called every time the node is added to the scene.
	# Initialization here

	setHealth(health)
	setScore(fishCount)
	
	music.play()
	
	
func _process(delta):
	t+= delta
	background.scroll_offset.y = t*Global.SCROLL_SPEED*1.5
	background.scroll_offset.x = sin(t*Global.SCROLL_SPEED/200)*16
	
func _physics_process(delta):
	timeSinceLastBullet += delta
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var movement = Vector2(0,0)
	
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
	
	if movement.x != 0 || movement.y != 0:
		movement = movement.normalized()
		
	if movement.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	# anim
	if abs(movement.x) > 0 :
		if animationPlayer.current_animation != "turn":
			animationPlayer.play("turn")
	else:
		if animationPlayer.current_animation != "forward":
			animationPlayer.play("forward")
	
	position = position + movement*SPEED*delta
	
	position.x = clamp(position.x,0,320)
	position.y = clamp(position.y,0,240)
	
	# rotin totin shotin
	if Input.is_action_pressed("ui_accept") and timeSinceLastBullet > BULLET_RATE:
		timeSinceLastBullet = 0
		spawnBullet(0)
		

	

# got hit by enemy
func _on_Area2D_body_entered(body):
	
	if (body.isDead): # dead fish get
		$pickup.play()
		setScore(fishCount + 1)
		body.queue_free()
	else: # take damage from ~~splash~~
		$hit.play()
		emit_signal("hit")
		setHealth(health - 1)
			
# setters for UI reasons
func setScore(s):
	fishCount = s
	scoreLabel.text = str(s)+" FISH"

func setHealth(h):
	health = h
	if healthBar:
		healthBar.value = health
	if (health <= 0):
		die()
	if (health < 3):
		$Smonk.emitting = true

func spawnBullet(dt):
	if !canShoot:
		return
	$throw.play()
	# dt should be the dt of how long ago bullet should have been fired
	var newBullet = bullet.instance()
	newBullet.position = position
	get_parent().add_child(newBullet)
	newBullet.position.y -= dt*newBullet.SPEED # my bullets move up
	
func die():
	Global.restart_level()
