##Need to managing and synchronize network objects
extends Node
class_name ObjectManager

var objectSet:Dictionary[String,InfoObject] = {
	"TestCube": preload("res://multiplayer/ObjectManager/MultiplayerObjects/Info/BaseCubeTest.tres"),
	"Player": preload("res://multiplayer/ObjectManager/MultiplayerObjects/Info/Player.res")
	
}
##Pull of instantiated objects
var objects:Array[Object]

var isServer:bool = false

func _init(isServer = false) -> void:
	objects.resize(1024)
	self.isServer = isServer

##Instantiate object and generate id
##Use to create new object on server
func newObject(objectName:String,exclusiveClient:RemoteClient = null):
	var id:int = objects.find(null)
	if exclusiveClient:
		sendObjectExclusive(objectName,id,exclusiveClient)
	else:
		sendNewObject(objectName,id)
	return pushObject(objectName,id)

##Instantiate object and give it id
##Use to create clients clones of server object
func pushObject(infoObjectName:String,objectId:int,exclusive:bool = false):
	var infoObject:InfoObject = objectSet.get(infoObjectName)
	var scene:PackedScene = infoObject.getObject(isServer,exclusive)
	var object:Node = scene.instantiate()
	
	print("Pushing object ", infoObjectName, " with id ",objectId)
	
	if objectId>objects.size():
		objects.resize(objectId)
	objects[objectId] = object
	
	if object.has_method("setId"):
		object.setId(objectId)
	else:
		push_error("WARNING: Object ",object," does not have method setId!")
	
	
	add_child(object)
	return object

func sendNewObject(objectName:String,id:int):
	MainHandler.server.sendEveryoneSafe(NewObjectSolver.assemble(objectName,id))

func sendObjectExclusive(objectName:String,id:int,exclusiveClient:RemoteClient):
	for client:RemoteClient in MainHandler.server.clients:
		client.sendPacketTCP(NewObjectSolver.assemble(objectName,id,client == exclusiveClient))
	pass
