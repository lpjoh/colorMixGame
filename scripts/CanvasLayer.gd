extends CanvasLayer


func _process(delta):
	$score.text = str($"/root/global".score)
	$highScore.text = "high " + str($"/root/global".highScore)
	$moneyBox/moneyScore.text = str($"/root/global".money)
	
	if $"/root/global".comboMultiplier > 1:
		$canvasAnim.play("comboShow")
		$comboScore.text = "x" + str($"/root/global".comboMultiplier) + "!"
		$"/root/global".comboMultiplier = 0
	
