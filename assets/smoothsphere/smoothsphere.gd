extends Spatial

var BALL = preload("res://Ball.tscn")
var ball_des = Vector3(0, 0, 0) # destination of ball movement

var ball

var min_speed
var max_speed
var accel
var min_dodge_time
var max_dodge_time



var reset_lag = 0.5
var can_reset = true

var basic_scale = 1.0
var ball_scale = 1.0

var globals
var options

func _ready():
    globals = get_node("/root/Globals")
    options = $Options
    options.scene = self
    options.init()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    
    $Player.set_gun("LightningGun")
    $ChallengeTimer.connect("timeout", self, "challenge_end")
    $Result/Close.connect("pressed", self, "close_result")
    
    $RandTimer.connect("timeout", self, "rand_ball_move")
    
    $ResetTimer.wait_time = reset_lag
    $ResetTimer.connect("timeout", self, "enable_reset")
    """
    ball = BALL.instance()
    #ball.scale = Vector3(1.3,1.3,1.3)
    ball.transform.origin = Vector3(0, 0, -90)
    ball.is_static = false
    add_child(ball)
    
    
    $RandTimer.connect("timeout", self, "rand_ball_des")
    rand_ball_des()
    
    $ResetTimer.wait_time = reset_lag
    $ResetTimer.connect("timeout", self, "enable_reset")
    
    ball.connect("take_damage", $Player, "deal_damage")
    """
    
func enable_reset():
    $ResetTimer.stop()
    can_reset = true
    
func rand_ball_move():
    $RandTimer.stop()
    $RandTimer.wait_time = rand_range(min_dodge_time, max_dodge_time)
    ball_des = rand_pos()
    ball.max_vel = rand_range(min_speed, max_speed)
    $RandTimer.start()
    
func rand_pos():
    var pos = Vector3(0, 0, 0)
    var h = $CSGBox.height / 2
    pos.x = rand_range(-90, 90)
    pos.y = rand_range(-0.9 * h, 0.9 * h)
    pos.z = rand_range(-90, 90)
    return pos
    
func ball_dead(ball):
    pass

func _process(delta):
    if ball == null:
        return
    
    var h = $CSGBox.height / 2
    if can_reset == true \
        and (ball.transform.origin.distance_to(ball_des) < 10.0 \
            or ball.transform.origin.y > 0.9 * h \
            or ball.transform.origin.y < -0.9 * h):
        rand_ball_move()
        can_reset = false
        $ResetTimer.start()
    ball.dir = (ball_des - ball.transform.origin).normalized()

func _physics_process(delta):
    var hit_time = $Player.damage_dealed / $Player.lightning_gun.damage
    var fire_time = $Player.damage_output / $Player.lightning_gun.damage
    $Scoreboard/Score.text = "hit time: %.2f\nacc: %.1f\ntime: %.1f" \
        % [hit_time, 100.0 * hit_time / max(fire_time, 0.1), $ChallengeTimer.time_left]
    
    if Input.is_action_just_pressed("ui_cancel"):
        $RandTimer.stop()
        $ResetTimer.stop()
        show_option_menu()
    
    if Input.is_action_pressed("reset"):
        reset_stats()
        if $ChallengeTimer.time_left > 0:
            start_challenge()
        else:
            start()
        
func reset_stats():
    $Player.damage_dealed = 0.0
    $Player.damage_output = 0.0

func show_option_menu():
    $ChallengeTimer.stop()
    $Player.capture_mouse = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    $Options.visible = true
    
func challenge_end():
    $RandTimer.stop()
    $ResetTimer.stop()
    show_option_menu()
    var hit_time = $Player.damage_dealed / $Player.lightning_gun.damage
    var fire_time = $Player.damage_output / $Player.lightning_gun.damage
    $Result/ResultText.text = "hit: %.2f fired: %.2f\nacc: %.1f time: %d" \
        % [hit_time, fire_time, 100.0 * hit_time / max(fire_time, 0.1), $ChallengeTimer.wait_time]
    $Result.visible = true
    
func start():
    $Options.visible = false
    $Player.look_at(Vector3(0, 0, -1), Vector3(0, 1, 0))
    $Player/RotationHelper.look_at(Vector3(0, 0, -1), Vector3(0, 1, 0))
    $Player.capture_mouse = true
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    if ball != null:
        ball.queue_free()
    ball = BALL.instance()
    ball.scale = Vector3(ball_scale, ball_scale, ball_scale)
    ball.accel = accel
    ball.transform.origin.z = -90
    ball.is_static = false
    ball.connect("dead", self, "ball_dead", [ball])
    ball.connect("take_damage", $Player, "deal_damage")
    $RandTimer.wait_time = rand_range(min_dodge_time, max_dodge_time)
    rand_ball_move()
    add_child(ball)

func start_challenge():
    $ChallengeTimer.stop()
    $ChallengeTimer.start()
    start()

func show_stats(enable):
    $Scoreboard.visible = enable

func show_walls(enable):
    $CSGBox.visible = enable

func set_target_size(value):
    ball_scale = basic_scale * value

func set_min_speed(value):
    min_speed = value
    
func set_max_speed(value):
    max_speed = value

func set_accel(value):
    accel = value
    
func set_min_dodge_time(value):
    min_dodge_time = value
    
func set_max_dodge_time(value):
    max_dodge_time = value

func set_map_height(value):
    $CSGBox.height = value
    
func set_challenge_time(value):
    $ChallengeTimer.wait_time = value

func close_result():
    $Result.visible = false
            
