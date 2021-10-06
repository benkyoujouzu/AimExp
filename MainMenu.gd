extends Control

var globals

func _ready():
    globals = get_node("/root/Globals")
    randomize()
    var fullscreen_button = $Menu/FullscreenButton
    var options_button = $Menu/OptionsButtion
    var start_button = $Menu/StartButton
    
    fullscreen_button.connect("pressed", self, "toggle_fullscreen")
    options_button.connect("pressed", self, "options_menu")
    start_button.connect("pressed", self, "start")
    
    var OWNT = $SC/Scenes/OWNT
    var smoothsphere = $SC/Scenes/Smoothsphere
    var back = $SC/Scenes/Back
    
    OWNT.connect("pressed", self, "start_scene", ["ownt"])
    smoothsphere.connect("pressed", self, "start_scene", ["smoothsphere"])
    back.connect("pressed", self, "back_to_start")

func toggle_fullscreen():
    OS.window_fullscreen = !OS.window_fullscreen

func options_menu():
    globals.change_scene("res://OptionsMenu.tscn")
    
func start():
    $Menu.visible = false
    $SC.visible = true

func back_to_start():
    $SC.visible = false
    $Menu.visible = true

func start_scene(name):
    match name:
        "ownt":
            globals.change_scene("res://assets/ownt/ownt.tscn")
        "smoothsphere":
            globals.change_scene("res://assets/smoothsphere/smoothsphere.tscn")
    
