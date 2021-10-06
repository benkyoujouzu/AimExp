extends Control

var ocolor = Color(0, 0, 0)
var globals

func _ready():
    globals = get_node("/root/Globals")

func _process(delta):
    update()

func _draw():
    var size = get_size()
    var c = size / 2
    var cs = globals.crosshair_center_size
    var o = globals.crosshair_outline
    var color = globals.crosshair_color
    var type = globals.crosshair_type
    if type == "dot":
        draw_circle(c, cs / 2 + o, ocolor)
        draw_circle(c, cs / 2, color)
    elif type == "crosshair":
        var t = globals.crosshair_thickness
        var l = globals.crosshair_length
        var ht = t / 2.0
        var hc = cs / 2.0
        var rect = Rect2(c.x - ht - o, c.y + hc - o, t + o + o, l + o + o)
        draw_rect(rect, ocolor)
        rect = Rect2(c.x - ht, c.y + hc, t, l)
        draw_rect(rect, color)
        
        rect = Rect2(c.x - ht - o, c.y - hc - l - o, t + o + o, l + o + o)
        draw_rect(rect, ocolor)
        rect = Rect2(c.x - ht, c.y - hc - l, t, l)
        draw_rect(rect, color)
        
        rect = Rect2(c.x - hc - l - o, c.y - ht - o, l + o + o, t + o + o)
        draw_rect(rect, ocolor)
        rect = Rect2(c.x - hc - l, c.y - ht, l, t)
        draw_rect(rect, color)
        
        rect = Rect2(c.x + hc - o, c.y - ht - o, l + o + o, t + o + o)
        draw_rect(rect, ocolor)
        rect = Rect2(c.x + hc, c.y - ht, l, t)
        draw_rect(rect, color)
