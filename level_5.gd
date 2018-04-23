extends Node2D

# Do one thing: make the player not shoot

func _process(delta):
	if Global.player and Global.player.canShoot:
		Global.player.canShoot = false
