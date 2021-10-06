extends Spatial

var damage = 1000.0
var triggered = false

func _ready():
    pass
    
func _physics_process(delta):
    if triggered:
        triggered = false
        var ray = $RayCast
        ray.force_raycast_update()
        if ray.is_colliding():
            var body = ray.get_collider()
            if body.has_method("take_damage"):
                body.take_damage(damage)
