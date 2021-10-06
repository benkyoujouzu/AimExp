extends Spatial

var BALL = preload("res://Ball.tscn")
var globals
var options
var ball_list = []
var basic_scale = 1.3
var ball_scale = 1.3
var ball_number = 6
var target_range = 0.9

func _ready():
    globals = get_node("/root/Globals")
    options = $Options
    options.scene = self
    options.init()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    
    $Player.set_gun("Railgun")
    $ChallengeTimer.connect("timeout", self, "challenge_end")
    $Result/Close.connect("pressed", self, "close_result")
    """
    for i in range(6):
        var ball = BALL.instance()
        ball.scale = Vector3(basic_scale, basic_scale, basic_scale)
        #ball.scale = Vector3(10,10,10)
        ball.transform.origin.z = -90
        ball.transform.origin.x = rand_range(-90, 90)
        ball.transform.origin.y = rand_range(-90, 90)
        ball.connect("dead", self, "ball_dead", [ball])
        ball.connect("take_damage", $Player, "deal_damage")
        add_child(ball)
        ball_list.append(ball)
    """
    
func ball_dead(ball):
    var h = $CSGBox.height / 2 * target_range
    var w = $CSGBox.width / 2 * target_range
    ball.transform.origin.z = 10
    ball.transform.origin.x = rand_range(-w, w)
    ball.transform.origin.y = rand_range(-h, h)
    ball.health = 1.0

func _physics_process(delta):
    var fire_count = $Player.damage_output / $Player.railgun.damage
    var ball_killed = $Player.damage_dealed / $Player.railgun.damage
    $Scoreboard/Score.text = "killed: %d\nfired: %d\nacc: %.1f\ntime: %.1f" \
        % [ball_killed, fire_count, 100.0 * ball_killed / max(fire_count, 1), $ChallengeTimer.time_left]
    if Input.is_action_pressed("ui_cancel"):
        show_option_menu()
        
    if Input.is_action_just_pressed("reset"):
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
    show_option_menu()
    var fire_count = $Player.damage_output / $Player.railgun.damage
    var ball_killed = $Player.damage_dealed / $Player.railgun.damage
    $Result/ResultText.text = "hit: %d fire: %d\nacc: %.1f time: %d" \
        % [ball_killed, fire_count, 100.0 * ball_killed / max(fire_count, 1), $ChallengeTimer.wait_time]
    $Result.visible = true
    
func start():
    $Options.visible = false
    $Player.look_at(Vector3(0, 0, -1), Vector3(0, 1, 0))
    $Player/RotationHelper.look_at(Vector3(0, 0, -1), Vector3(0, 1, 0))
    $Player.capture_mouse = true
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    var h = $CSGBox.height / 2 * target_range
    var w = $CSGBox.width / 2 * target_range
    while not ball_list.empty():
        ball_list.pop_back().queue_free()
    for i in range(ball_number):
        var ball = BALL.instance()
        ball.scale = Vector3(ball_scale, ball_scale, ball_scale)
        ball.transform.origin.z = 10
        ball.transform.origin.x = rand_range(-w, w)
        ball.transform.origin.y = rand_range(-h, h)
        ball.connect("dead", self, "ball_dead", [ball])
        ball.connect("take_damage", $Player, "deal_damage")
        ball_list.append(ball)  
        add_child(ball)
        
func start_challenge():
    $ChallengeTimer.start()
    start()
    
func show_stats(enable):
    $Scoreboard.visible = enable

func show_walls(enable):
    $CSGBox.visible = enable

func scale_balls():
    for ball in ball_list:
        ball.scale = Vector3(ball_scale, ball_scale, ball_scale)

func set_target_size(value):
    ball_scale = basic_scale * value

func set_target_number(value):
    ball_number = value

func set_target_range(value):
    target_range = value
    
func set_player_distance(value):
    $Player.transform.origin.z = value

func set_map_height(value):
    $CSGBox.height = value
    
func set_challenge_time(value):
    $ChallengeTimer.wait_time = value

func close_result():
    $Result.visible = false
            
