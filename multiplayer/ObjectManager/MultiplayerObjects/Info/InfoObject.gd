extends Resource
class_name InfoObject

@export var name:String = ""

@export var serverObject:PackedScene
@export var clientObject:PackedScene

##Instantiate for current client
##Like player
@export var exclusiveClientScene:PackedScene = null

func getObject(isServer:bool,exclusive:bool = false)->PackedScene:
	if isServer:
		return serverObject
	else:
		if exclusive:
			return exclusiveClientScene
		return clientObject
