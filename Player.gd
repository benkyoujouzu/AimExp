extends KinematicBody

var globals
var rotation_helper
var sensitivity
var camera

var lightning_gun
var railgun
var gun

signal triggered

var damage_dealed = 0.0 # damage hit
var damage_output = 0.0 # damage hit + damage not hit

var mouse_accu = Vector2(0, 0)
var phy_mouse_accu = Vector2(0, 0)

var capture_mouse = false

func _ready():
    globals = get_node("/root/Globals")
    rotation_helper = $RotationHelper
    sensitivity = globals.sensitivity * globals.yaw
    camera = $RotationHelper/Camera
    camera.fov = 2*rad2deg(atan(9 * tan(deg2rad(globals.hfov/2.0)) / 16))
    
    lightning_gun = $RotationHelper/LightningGun
    railgun = $RotationHelper/Railgun
    gun = lightning_gun
    
    if globals.show_mouse_speed:
        $SpeedChart/Timer.start()

func set_gun(name):
    if name == "Railgun":
        gun = railgun
    elif name == "LightningGun":
        gun = lightning_gun
    
func deal_damage(damage):
    damage_dealed += damage
    
func _physics_process(delta):
    if gun.triggered and gun == lightning_gun and capture_mouse == true:
        damage_output += lightning_gun.damage * delta
    if Input.is_action_just_pressed("fire"):
        gun.triggered = true
        emit_signal("triggered")
        if gun == railgun and capture_mouse == true:
            damage_output += railgun.damage
    if Input.is_action_just_released("fire"):
        gun.triggered = false
        
    if phy_mouse_accu.x != 0.0 or phy_mouse_accu.y != 0.0:
        $SpeedChart.add_point(Vector2(OS.get_ticks_msec(), phy_mouse_accu.length() * globals.sensitivity))
        phy_mouse_accu.x = 0.0
        phy_mouse_accu.y = 0.0

func _process(delta):
    if mouse_accu.x != 0.0 or mouse_accu.y != 0.0:
        rotation_helper.rotate_x(deg2rad(mouse_accu.y * sensitivity * -1))
        self.rotate_y(deg2rad(mouse_accu.x * sensitivity * -1))

        var camera_rot = rotation_helper.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -88, 88)
        rotation_helper.rotation_degrees = camera_rot
        
        mouse_accu.x = 0.0
        mouse_accu.y = 0.0

    
func _input(event):
    if capture_mouse == false:
        return
        
    if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
        
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        mouse_accu += event.relative
        phy_mouse_accu += event.relative
