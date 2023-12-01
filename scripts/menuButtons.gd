extends VBoxContainer

var destination = ""

func _on_arcade_pressed():
	$"/root/global".gameMode = "arcade"
	changeToMain()

func _on_transAnim_animation_finished(anim_name):
	if anim_name == "zoomIn":
		get_tree().change_scene(destination)


func _on_casual_pressed():
	$"/root/global".gameMode = "casual"
	changeToMain()

func changeToMain():
	destination = "res://levels/main.tscn"
	get_parent().get_node("transAnim").play("zoomIn")
	for child in get_children():
		if child is Button:
			child.disabled = true
