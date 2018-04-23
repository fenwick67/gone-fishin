extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
	if Input.is_action_just_pressed("ui_next_level") or Input.is_action_just_pressed("ui_accept"):
		Global.goto_scene("res://level_1.tscn")
