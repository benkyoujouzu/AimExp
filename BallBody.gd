extends StaticBody

func _ready():
    pass

func take_damage(damage):
    get_node("../").take_damage(damage)
