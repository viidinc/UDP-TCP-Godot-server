@abstract
extends Object
class_name CommandSolver

#0-65535
#Override in innerhit classes
@abstract 
func getID()->int

##Solve packet
##Packet WITHOUT COMMAND
@abstract 
func solve(packet:PackedByteArray,client:RemoteClient = null)

##Some solver can contain assembly method with custom parameters.
