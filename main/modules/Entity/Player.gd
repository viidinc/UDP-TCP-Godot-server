extends Entity
class_name Player

@export var NetSync:NetworkSyncClient
var lerpPos:Vector3

func _process(delta: float) -> void:
	position = position.lerp(lerpPos,0.5)
	pass


func getId():
	
	pass
