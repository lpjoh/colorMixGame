extends KinematicBody2D

var motion = Vector2()
const UP = Vector2(0, -1)

func _ready():
	motion.y = -200
	$soundShoot.play()

func _process(_delta):
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if "ball" in body.name:
			if body.modulate == self.modulate:
				$"/root/global".comboMultiplier = 0
				$"/root/global".score -= 1
				$"/root/global/soundScore".play()
				body.comboCheck()
			else:
				$"/root/global/soundPlink".play()
			self.queue_free()
	
	
	if $despawnTimer.time_left == 0:
		self.queue_free()
	
	motion = move_and_slide(motion, UP)
