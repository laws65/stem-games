extends KinematicBody2D
class_name player

var velocity := Vector2(0,0)
var speed := 200

func _physics_process(delta):
	velocity = Input.get_vector("A", "D", "W", "S")*speed
	velocity = move_and_slide(velocity)

