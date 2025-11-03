##Need to managing and synchronize network objects
extends Node
class_name ObjectManager

var objectSet:Dictionary[String,InfoObject] = {
	"TestCube": preload("res://multiplayer/ObjectManager/MultiplayerObjects/Info/BaseCubeTest.tres")
	
	
}
##Pull of instantiated objects
var objects:Array[Object]

var isServer:bool = false

func _init(isServer = false) -> void:
	objects.resize(1024)
	self.isServer = isServer

func newObject(objectName:String):
	var id:int = objects.find(null)
	sendNewObject(objectName,id)
	return pushObject(objectName,id)

func pushObject(infoObjectName:String,objectId:int):
	var infoObject:InfoObject = objectSet.get(infoObjectName)
	var scene:PackedScene = infoObject.getObject(isServer)
	var object:Node3D = scene.instantiate()
	
	print("Pushing object ", infoObjectName, " with id ",objectId)
	
	if objectId>objects.size():
		objects.resize(objectId)
	objects[objectId] = object
	
	if object.has_method("setId"):
		object.setId(objectId)
	else:
		push_warning("WARNING: Object ",object," does not have method setId!")
	
	
	add_child(object)
	return object

func sendNewObject(objectName:String,id:int):
	MainHandler.server.sendEveryoneSafe(NewObjectSolver.assemble(objectName,id))
