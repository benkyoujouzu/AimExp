extends Control

var sens_slider
var sens_text
var fov_slider
var fov_text
var globals
var perf_checkbox
var options

var slider_names = {"Sens" : "sensitivity", \
    "FOV" : "hfov", \
    "CS" : "crosshair_center_size", \
    "CL" : "crosshair_length", \
    "CT" : "crosshair_thickness", \
    "CO": "crosshair_outline"}

var checkbox_names = {"Perf": "show_performance", \
    "MS": "show_mouse_speed"}

func _ready():
    globals = get_node("/root/Globals")
    options = $SC/Grid
    for name in slider_names:
        var slider = options.get_node(name + "Slider")
        slider.value = globals.get(slider_names[name])
        options.get_node(name + "Text").text = str(slider.value)
        slider.connect("value_changed", self, "set_value", [name])
    
    for name in checkbox_names:
        var checkbox = options.get_node(name + "Checkbox")
        checkbox.connect("pressed", self, "set_checkbox", [name])
        
    var ccolor = options.get_node("CColor")
    ccolor.color = globals.crosshair_color
    ccolor.connect("color_changed", self, "set_ccolor")
    
    var ctbutton = options.get_node("CTOption")
    match globals.crosshair_type:
        "dot":
            ctbutton.selected = 0
        "crosshair":
            ctbutton.selected = 1
        _:
            ctbutton.selected = 2
    ctbutton.connect("item_selected", self, "set_ctype")
    
    
    var back_button = $Back/BackButton
    back_button.connect("pressed", self, "main_menu")
    
func set_ctype(selected):
    match selected:
        0:
            globals.crosshair_type = "dot"
        1:
            globals.crosshair_type = "crosshair"
        2:
            globals.crosshair_type = "none"

func set_ccolor(color):
    globals.crosshair_color = color
    
func set_value(value, name):
    options.get_node(name + "Text").text = str(value)
    globals.set(slider_names[name], value)

func set_checkbox(name):
    var checkbox = options.get_node(name + "Checkbox")
    globals.set(checkbox_names[name], checkbox.pressed)
    if name == "Perf":
        globals.set_perf_display(checkbox.pressed)

func main_menu():
    get_tree().change_scene("res://MainMenu.tscn")

func set_perf_display():
    globals.set_perf_display(perf_checkbox.pressed)
