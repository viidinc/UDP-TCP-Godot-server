extends Node3D
class_name SyncedObject

signal propertyChanged(objectId:int,property:String,value:Variant)

var id:int

func setId(id:int):
	self.id = id

func getId()->int:
	return id
