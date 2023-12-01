extends Node2D

func _on_Button_pressed():
	Engine.get_singleton("AdMob").resize()
