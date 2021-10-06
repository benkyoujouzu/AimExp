extends Control

func _ready():
    $Panel/FPS.text = "FPS: %4d" % 0
    
func _process(delta):
    $Panel/FPS.text = "FPS: %4d" % Engine.get_frames_per_second()
