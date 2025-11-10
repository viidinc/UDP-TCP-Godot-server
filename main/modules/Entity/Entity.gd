extends CharacterBody3D
class_name Entity

@export var speed:float

func move(vec:Vector2):
	velocity.x += vec.x
	velocity.y += vec.y
	move_and_slide()
