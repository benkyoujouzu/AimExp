extends Control

var scene = null
var globals

var slider_names = { \
    "TS" : "target_size", \
    "MinS" : "min_speed", \
    "MaxS" : "max_speed", \
    "Accel" : "accel", \
    "MinD" : "min_dodge_time", \
    "MaxD" : "max_dodge_time", \
    "MH" : "map_height", \
    "CT" : "challenge_time"
   }

func _ready():
    globals = get_node("/root/Globals")
    
func init():
    for name in slider_names:
        var slider = get_node("SC/GC/" + name + "Slider")
        slider.connect("value_changed", self, "set_value", [name])
        var label = get_node("SC/GC/" + name + "Text")
        label.text = str(slider.value)
        scene.call("set_" + slider_names[name], slider.value)
    
    var stats_button = $SC/GC/StatsCheckbox
    stats_button.connect("toggled", scene, "show_stats")
    
    var walls_button = $SC/GC/WallsCheckbox
    walls_button.connect("toggled", scene, "show_walls")
    
    var back_button = $Back
    back_button.connect("pressed", self, "back_to_main_menu")
    
    var challenge_button = $Challenge
    challenge_button.connect("pressed", scene, "start_challenge")
    
    var freeplay_button = $FreePlay
    freeplay_button.connect("pressed", scene, "start")
    
func back_to_main_menu():
    globals.change_scene(globals.MAINMENU)

func set_value(value, name):
    match name:
        "MinS":
            if value > $SC/GC/MaxSSlider.value:
                value = $SC/GC/MaxSSlider.value
                $SC/GC/MinSSlider.value = value
        "MaxS":
            if value < $SC/GC/MinSSlider.value:
                value = $SC/GC/MinSSlider.value
                $SC/GC/MaxSSlider.value = value
        "MinD":
            if value > $SC/GC/MaxDSlider.value:
                value = $SC/GC/MaxDSlider.value
                $SC/GC/MinDSlider.value = value
        "MaxD":
            if value < $SC/GC/MinDSlider.value:
                value = $SC/GC/MinDSlider.value
                $SC/GC/MaxDSlider.value = value
                
    scene.call("set_" + slider_names[name], value)
    var label = get_node("SC/GC/" + name + "Text")
    label.text = str(value)
    

