extends VBoxContainer

const charAmountPerRow = 3 - 1
const charSize = 16
var selectedCharacter = 0
var charPosition = 0
var mixedAlready = false
var charCount = 0
var moveDir = "none"
var isShooting = false
var isMixing = false
var isResetting = false
onready var animPlayer = get_parent().get_node("AnimationPlayer")

func _ready():
	resetColors()

func _process(_delta):
	if $"/root/global".gameIsOver == false:
		
		if Input.is_action_just_pressed("ui_up") or moveDir == "up":
			moveUp()
			moveDir = "none"
		
		elif Input.is_action_just_pressed("ui_down") or moveDir == "down":
			moveDown()
			moveDir = "none"
		
		charPosition = get_child(selectedCharacter).position.x / charSize
		
		if Input.is_action_just_pressed("ui_right") or moveDir == "right":
			moveRight()
			moveDir = "none"
		
		elif Input.is_action_just_pressed("ui_left") or moveDir == "left":
			moveLeft()
			moveDir = "none"
		
		if Input.is_action_just_pressed("shoot") or isShooting:
			Input.start_joy_vibration(0, 0.3, 0.3, 0.1)
			animPlayer.stop()
			animPlayer.play("judUp")
			var bullet = load("res://objects/bullet.tscn")
			var bullet_instance = bullet.instance()
			bullet_instance.modulate = get_child(selectedCharacter).modulate
			bullet_instance.position = get_child(selectedCharacter).get_global_transform_with_canvas().origin - get_parent().get_global_transform_with_canvas().origin
			get_parent().add_child(bullet_instance)
			isShooting = false
		
		if Input.is_action_just_pressed("ui_accept") or isMixing:
			isMixing = false
			animPlayer.stop()
			animPlayer.play("judDown")
			if mixedAlready == false:
				charCount = 0
				
				while charCount < get_child_count() - selectedCharacter:
					if get_child(charCount + selectedCharacter).position.x / charSize == charPosition:
						if get_child(selectedCharacter).name == "redGuy":
							if get_child(charCount).name == "yellowGuy":
								genericMixCommands()
								get_child(charCount).modulate = Color(1.0, 0.5, 0.0)
								moveDownMix()
							elif get_child(charCount).name == "blueGuy":
								genericMixCommands()
								get_child(charCount).modulate = Color(0.5, 0.0, 1)
								moveDownMix()
						elif get_child(selectedCharacter).name == "yellowGuy":
							if get_child(charCount + 1).name == "blueGuy":
								genericMixCommands()
								get_child(charCount + 1).modulate = Color(0.0, 1.0, 0.0)
								moveDownMix()
					charCount += 1
			else:
				get_parent().get_node("soundError").play()
		
		if Input.is_action_just_pressed("resetColors") or isResetting:
			isResetting = false
			resetColors()
		
		positionChars()

func genericMixCommands():
	mixedAlready = true
	get_child(charCount + selectedCharacter).get_node("dustAnim").frame = 0
	get_child(charCount + selectedCharacter).get_node("dustAnim").play("dust")
	Input.start_joy_vibration(0, 0.75, 0.75, 0.2)
	get_parent().get_node("soundMix").play()
	get_child(selectedCharacter).hide()

func moveDownMix():
	selectedCharacter = charCount + selectedCharacter
	charCount = get_child_count() - selectedCharacter + 1

func resetColors():
	get_parent().get_node("soundReset").play()
	$redGuy.show()
	$yellowGuy.show()
	$blueGuy.show()
	
	$redGuy.position.x = 0
	$yellowGuy.position.x = charSize
	$blueGuy.position.x = charSize * 2
	
	$redGuy.modulate = Color(1.0, 0.0, 0.0)
	$yellowGuy.modulate = Color(1.0, 1.0, 0.0)
	$blueGuy.modulate = Color(0.0, 0.5, 1.0)
	
	selectedCharacter = 0
	charPosition = 0
	mixedAlready = false

func moveUp():
	get_parent().get_node("soundCol").play()
	Input.start_joy_vibration(0, 0.1, 0.1, 0.1)
	animPlayer.stop()
	animPlayer.play("judUp")
	if selectedCharacter > 0:
		selectedCharacter -= 1
	else:
		selectedCharacter = get_child_count() - 1

func moveDown():
	get_parent().get_node("soundCol").play()
	Input.start_joy_vibration(0, 0.1, 0.1, 0.1)
	animPlayer.stop()
	animPlayer.play("judDown")
	if selectedCharacter < get_child_count() - 1:
		selectedCharacter += 1
	else:
		selectedCharacter = 0

func moveRight():
	get_parent().get_node("soundRow").play()
	Input.start_joy_vibration(0, 0.1, 0.1, 0.1)
	animPlayer.stop()
	animPlayer.play("judRight")
	if charPosition < charAmountPerRow:
		charPosition += 1
	else:
		charPosition = 0

func moveLeft():
	get_parent().get_node("soundRow").play()
	Input.start_joy_vibration(0, 0.1, 0.1, 0.1)
	animPlayer.stop()
	animPlayer.play("judLeft")
	if charPosition > 0:
		charPosition -= 1
	else:
		charPosition = charAmountPerRow

func positionChars():
	get_parent().get_node("columnSelect").position.y = get_child(selectedCharacter).global_position.y
	get_child(selectedCharacter).position.x = charPosition * charSize

func _on_swipeDetector_swiped(direction):
	var generosity = 10
	if round(rad2deg(direction.angle())) == 0:
		moveDir = "left"
	elif round(rad2deg(direction.angle())) == 90:
		moveDir = "up"
	elif round(rad2deg(direction.angle())) == 180:
		moveDir = "right"
	elif round(rad2deg(direction.angle())) == -90:
		moveDir = "down"
	
	positionChars()


func _on_swipeDetector_tapped():
	if get_parent().get_node("CanvasLayer/mixButton").pressed == false:
		if get_parent().get_node("CanvasLayer/resetButton").pressed == false:
			if get_parent().get_node("CanvasLayer/pauseButton").pressed == false:
				isShooting = true


func _on_mixButton_pressed():
	isMixing = true


func _on_resetButton_pressed():
	isResetting = true
