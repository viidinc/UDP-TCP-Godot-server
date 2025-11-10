@abstract
extends Node
class_name BasePacketSolver

var Solvers:Array[CommandSolver] = [
]

@abstract
func solve(packet:PackedByteArray,client:RemoteClient = null)

##Using for registration solvers
func appendSolver(solver:CommandSolver):
	var solverId = solver.getID()
	
	if Solvers.size()<solverId+1:
		Solvers.resize(solverId+1)
	Solvers.set(solverId,solver)

##ONLY FOR EXPORT SCRIPTS AS TEXT
##WHEN SCRIPTS EXPORTS AS BYTECODE USE [annotation BasePacketSolver.solve]
func registerSolvers(folder:String):
	print("=== Start solvers registration ===")
	for fileName in DirAccess.get_files_at(folder):
		print("file: ",fileName)
		if !fileName.get_extension() in ["gd","gdc"]:
			continue
		
		var file = load(folder+fileName)
		
		if file is GDScript:
			var inst = file.new()
			if inst is CommandSolver:
				print("Registred solver: ",fileName)
				if inst.getID() > Solvers.size()-1:
					Solvers.resize(inst.getID()+1)
				
				if Solvers.get(inst.getID()) != null:
					print("WARNING COMMAND SOLVER OVERRIDE")
					push_error("COMMAND SOLVER OVERRIDE AT", inst.getID()," CLASS: ",inst.get_class())
					
				Solvers.set(inst.getID(),inst)
	print("=== Registration end ===\nSolvers size: ",Solvers.size(),"\nSolvers array: ",str(Solvers))

##Return packet command id 
static func parseCmd(packet:PackedByteArray)->int:
	return packet.decode_u16(0)

##Return packet data without command
static func parsePacket(packet:PackedByteArray)->PackedByteArray:
	return packet.slice(2)
