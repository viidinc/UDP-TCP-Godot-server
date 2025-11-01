@abstract
extends Node
class_name NetTool

signal packetRecieved(client:RemoteClient,packet:PackedByteArray)
const DEFAULTPORT:int = 30913

var solver:BasePacketSolver

@abstract
func run()->Error

@abstract
func tick()->Error

func solvePacket(packet:PackedByteArray,client:RemoteClient):
	packetRecieved.emit(client,packet)
	solver.solve(packet,client)
	pass
