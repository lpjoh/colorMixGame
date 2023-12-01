extends Node2D

var destination = ""
var rowCount = 0
var colCount = 0

func _ready():
	print(Engine.has_singleton("AdMob"))
	$"/root/admanager".showInterstitial()
	print(str(OS.get_screen_size()) + ", " + str(get_viewport_rect().size))
	get_tree().paused = false
	for child in $CanvasLayer/pauseNode/pauseMenu.get_children():
		if child is Button:
			child.disabled = true
	
	if $"/root/global".gameMode == "casual":
		while rowCount < 3:
			while colCount < 18:
				randomize()
				var ball = load("res://objects/ball.tscn")
				var ball_instance = ball.instance()
				add_child(ball_instance)
				$spawnTimer.start()
				ball_instance.position.x = 19 + (rowCount * 16)
				ball_instance.position.y = $limit.position.y - 16 - colCount * 6
				colCount += 1
			colCount = 0
			rowCount += 1
	
	elif $"/root/global".gameMode == "arcade":
		spawnBall()

func _process(delta):
	print($"/root/global".spawnTime)
	if $"/root/global".gameIsOver == false:
		if Input.is_action_pressed("fastForward"):
			$spawnTimer.wait_time = $"/root/global".spawnTime / 2
		else:
			$spawnTimer.wait_time = $"/root/global".spawnTime
		
		if $"/root/global".gameMode == "arcade":
			if $spawnTimer.time_left == 0:
				spawnBall()
	
	if Input.is_action_just_pressed("resetGame"):
		resetGame()

func gameOver():
	$soundGameOver.play()
	$charBox/redGuy/colorGuySprite.play("death")
	$charBox/yellowGuy/colorGuySprite.play("death")
	$charBox/blueGuy/colorGuySprite.play("death")
	$CanvasLayer/canvasAnim.play("gameOver")
	$gameOverTimer.start()
	$"/root/global".gameIsOver = true


func _on_pauseButton_pressed():
	pauseScreen()

func pauseScreen():
	$soundPause.play()
	get_tree().paused = not get_tree().paused
	
	if get_tree().paused:
		$CanvasLayer/canvasAnim.play("pause")
	else:
		$CanvasLayer/canvasAnim.play("unPause")
	
	for child in $CanvasLayer/pauseNode/pauseMenu.get_children():
		if child is Button:
			child.disabled = not child.disabled

func resetGame():
	$"/root/global".score = 0
	$"/root/global".ballsSpawned = 0
	$"/root/global".ballSpeed = 30
	$"/root/global".spawnTime = 2
	$"/root/global".comboMultiplier = 0
	$"/root/global".gameIsOver = false
	destination = "res://levels/main.tscn"
	$transAnim.play("zoomIn")

func spawnBall():
	var ball = load("res://objects/ball.tscn")
	randomize()
	if randi() % 5 == 1:
		ball = load("res://objects/ballMoney.tscn")
		randomize()
	elif randi() % 6 == 1:
		ball = load("res://objects/ballBomb.tscn")
		randomize()
	var ball_instance = ball.instance()
	add_child(ball_instance)
	$spawnTimer.start()

func _on_transAnim_animation_finished(anim_name):
	if anim_name == "zoomIn":
		get_tree().change_scene(destination)


func _on_resetButton_pressed():
	pauseScreen()
	resetGame()


func _on_returnButton_pressed():
	pauseScreen()


func _on_menuButton_pressed():
	pauseScreen()
	resetGame()
	destination = "res://levels/title.tscn"


func _on_gameOverTimer_timeout():
	var levelCompleteBox = $CanvasLayer/levelCompleteNode/border/border2/border3
	levelCompleteBox.get_node("header").text = "GAME OVER"
	levelCompleteBox.get_node("continueMenu/restartButton").text = "RETURN TO MAP"
	$CanvasLayer/canvasAnim.play("winScreenShow")


func _on_goButton_pressed():
	gameOver()
