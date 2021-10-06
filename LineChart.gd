extends Control

const TIMEWINDOW = 1500.0
const LINECOLOR = Color(1, 0, 0)
const MAXSIZE = 2000
var points = []
var filtered_points = []
var queue_head = 0
var enable = true
#var test = [Vector2(2000, 20), Vector2(1000, 200), Vector2(0, 50)]


func _ready():
    pass
    $Timer.connect("timeout", self, "update")
    """
    add_point(Vector2(1000, 20))
    add_point(Vector2(1500, 500))
    add_point(Vector2(2000, 20))
    add_point(Vector2(2500, 1000))
    add_point(Vector2(3000, 20))
    print(queue_head)
    print(points)
    """
    
func clear_point():
    points = []
    queue_head = 0

func size_point():
    return points.size()

func add_point(p):
    if points.size() < MAXSIZE:
        points.append(p)
    else:
        points[queue_head] = p
        queue_head = (queue_head + 1) % MAXSIZE
        
func get_point(idx):
    if points.size() < MAXSIZE:
        return points[idx]
    else:
        return points[(queue_head + idx) % MAXSIZE]
    
func max_val():
    var res = 0.0
    var n = size_point()
    var endt = get_point(n - 1).x
    for i in range(n):
        var p = get_point(i)
        if p.y > res and (endt - p.x) < TIMEWINDOW:
            res = p.y
    return res
    
func _draw():
    $SensVal.text = "sens: %.2f" % Globals.sensitivity
    if size_point() < 2:
        return
    var MAX = max(max_val(), 1)
    $MaxVal.text = "max: %f" % MAX
    var csize = get_size()
    var w = csize.x
    var h = csize.y
    var n = size_point()
    var endt = get_point(n - 1).x
    for i in range(n - 1):
        var p0 = get_point(n - i - 1)
        var p1 = get_point(n - i - 2)
        if (endt - p1.x) > TIMEWINDOW:
            break
        var from = Vector2(0, 0)
        from.x = 1.0 * w - w * (endt - p0.x) / TIMEWINDOW
        from.y = h - 1.0 * h * p0.y / MAX
        var to = Vector2(0, 0)
        to.x = 1.0 * w - w * (endt - p1.x) / TIMEWINDOW
        to.y = h - 1.0 * h * p1.y / MAX
        draw_line(from, to, LINECOLOR)
    
