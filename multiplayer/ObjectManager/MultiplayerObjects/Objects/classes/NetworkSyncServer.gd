extends Node
class_name NetworkSync

##Unique id. 
var id:int = -1
##Node witch we will sync
var own:Node

##Propertys to sync
var propertys:Array[String]
##Saved propertys on last frame
var lastPropertyValues:Dictionary[StringName,Variant]

func setId(id:int):
	self.id = id

func _init(own = get_parent(), _id = id) -> void:
	self.own = own
	id = _id
	
	for property:String in propertys:
		if !lastPropertyValues.has(property):
			lastPropertyValues.set(property,own.get(property))

func _ready() -> void:
	if !own:
		own = get_parent()

func appendSyncProperty(property:String):
	propertys.append(property)
	if !lastPropertyValues.has(property):
		lastPropertyValues.set(property,own.get(property))

func sync():
	for property in propertys:
		var value:Variant = own.get(property)
		if value != getSavedProperty(property):
			setSavedProperty(property,value)
			syncProperty(property,value)

func syncProperty(propertyName:String,value:Variant):
	var packet = ObjectSyncParce.assemble(id,propertyName,value)
	MainHandler.server.sendEveryone(packet)

func getSavedProperty(prop:String):
	return lastPropertyValues.get(prop)

func setSavedProperty(prop:String, value:Variant):
	lastPropertyValues.set(prop,value)
