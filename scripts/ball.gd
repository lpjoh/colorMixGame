extends KinematicBody2D

var pastPlayer = false
var motion = Vector2()
const UP = Vector2(0, -1)

const colors = [
Color(1.0, 0.0, 0.0),
Color(1.0, 0.5, 0.0),
Color(1.0, 1.0, 0.0),
Color(0.0, 1.0, 0.0),
Color(0.0, 0.5, 1.0),
Color(0.5, 0.0, 1.0),
]

func _ready():
	$"/root/global".ballSpeed += 1
	if $"/root/global".spawnTime > 0.5:
		$"/root/global".spawnTime -= 0.01
	randomColor()

func randomColor():
	randomize()
	self.modulate = colors[randi() % colors.size()]
	if $"/root/global".gameMode == "arcade":
		self.position.x = 19 + (randi() % 3 * 16)
		self.position.y = get_tree().get_root().get_node("Node2D/Camera2D").position.y - 150
	

func _process(_delta):
	if $"/root/global".gameIsOver == false:
		var areas = $ballArea.get_overlapping_areas()
		
		for area in areas:
			if area.modulate == self.modulate and area.visible == true:
				$"/root/global".ballsSpawned += 1
				if not "Money" in self.name:
					$"/root/global/soundScore".play()
				Input.start_joy_vibration(0, 0.5, 0.5, 0.2)
				self.queue_free()
			
			if area.name == "upperLimit" and motion.y == 0 and $"/root/global".gameMode == "arcade":
				get_tree().get_root().get_node("Node2D").call("gameOver")
		
		if Input.is_action_pressed("fastForward"):
			motion.y = $"/root/global".ballSpeed * 2
		else:
			motion.y = $"/root/global".ballSpeed
	else:
		motion.y += 5
		$CollisionShape2D.disabled = true
	
	if self.position.y > 125 and pastPlayer == false:
		$"/root/global".ballsSpawned += 1
		pastPlayer = true
		
	if self.position.y > 272:
		self.queue_free()
	
	motion = move_and_slide(motion, UP)

func comboCheck():
	$"/root/global".score += 1
	if $"/root/global".score > $"/root/global".highScore:
		$"/root/global".highScore = $"/root/global".score
	
	if "Money" in self.name:
		$"/root/global".money += 10
		$"/root/global/soundMoney".play()
	elif "Bomb" in self.name:
		get_parent().get_node("explosionSprite").frame = 0
		get_parent().get_node("explosionSprite").play("explode")
		get_parent().get_node("explosionSprite").position.y = self.position.y
		for child in get_parent().get_children():
			if "ball" in child.name:
				if round(self.position.y) == round(child.position.y):
					self.name = "combo"
					$"/root/global/soundExplosion".play()
					child.call("comboCheck")
	
	var bodies = $ballArea.get_overlapping_bodies()
	for body in bodies:
		if body.modulate == self.modulate:
			if "ball" in body.name:
				if body.position.x == self.position.x:
					body.name = "combo"
					$"/root/global".comboMultiplier += 1
					body.comboCheck()
	
	self.queue_free()
