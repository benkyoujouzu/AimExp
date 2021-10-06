extends Spatial

signal take_damage
signal dead
var health = 1.0

var vel = Vector3(0, 0, 0)
var max_vel = 60
var accel = 2
var deaccel = 2
var dir = Vector3(0, 0, 0)

var is_static = true

func _ready():
    pass # Replace with function body.

func take_damage(damage):
    health -= damage
    emit_signal("take_damage", damage)
    if health <= 0:
        emit_signal("dead")
        
func _process(delta):
    if is_static == false:
        process_movement(delta)
    
func process_movement(delta):
    """
    # acceleration algorithm from source engine. feels bad in 3d movement
    var prev_vel = vel.dot(dir)
    var accel_vel = delta * accel
    if (prev_vel + accel_vel) > max_vel:
        accel_vel = max_vel - prev_vel
    vel = vel + accel_vel * dir
    transform.origin = transform.origin + vel * delta
    """
    var acc = accel
    if vel.dot(dir) < 0:
        acc = deaccel
    var target = max_vel * dir
    vel = vel.linear_interpolate(target, acc * delta)
    transform.origin = transform.origin + vel * delta
    
    
    
    
