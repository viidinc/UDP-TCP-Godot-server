extends Resource
class_name InfoObject

@export var name:String = ""

@export var serverObject:PackedScene
@export var clientObject:PackedScene

func getObject(isServer:bool)->PackedScene:
	if isServer:
		return serverObject
	else:
		return clientObject
