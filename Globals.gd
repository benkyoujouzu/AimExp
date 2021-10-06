extends Node

var scenestack = []
var sensitivity = 3.4
var yaw = 0.022
var hfov = 103
var show_performance = true
var show_mouse_speed = true

var canvas_layer = null
var PERF_DISPLAY_SCENE = preload("res://PerformanceDisplay.tscn")
var perf_display = null

var crosshair_type = "dot"
var crosshair_color = Color(1, 0, 0)
var crosshair_center_size = 4.0
var crosshair_length = 6.0
var crosshair_thickness = 2.0
var crosshair_outline = 1.0

const MAINMENU = "res://MainMenu.tscn"

func _ready():
    canvas_layer = CanvasLayer.new()
    add_child(canvas_layer)
    perf_display = PERF_DISPLAY_SCENE.instance()
    canvas_layer.add_child(perf_display)
    Input.set_use_accumulated_input(false)

func change_scene(scene):
    get_tree().change_scene(scene)

func set_perf_display(enable):
    if enable:
        perf_display.visible = true
    else:
        perf_display.visible = false
        
