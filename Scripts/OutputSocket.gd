extends Area3D

class_name OutputSocket

# WARNING: all the OutputSockets need to be referenced by grid objects
# TODO: assert that all the children OutputSockets are referenced
# this should be done only once per instance, and not every time the object is instantiated?

# should an output socket have multiple possible outputs, or only one?
#@export var connectables: Array[SteamEngineTypes.SteamEngineResourceType]
@export var outputType: SteamEngineTypes.SteamEngineResourceType

var connectedInputSocket: InputSocket


# shared between the 2 sockets
# should the OutputSocket know about the GridComponent? 
# Maybe it should just receive the info, and pass it through?
# because InputSocket should defo know about the GridComponent
var parentGridComponent: GridComponent

func _ready() -> void:
# shared between the 2 sockets
	assert(outputType != SteamEngineTypes.SteamEngineResourceType.UNDEFINED, "Output socket must have an output type defined")
	area_entered.connect(tryConnectSocket) # area_entered - Area3D signal when another area intersects it's collision area\
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "x" if connectedInputSocket != null else "" )

# shared between the 2 sockets
func tryConnectSocket(area: Area3D) -> void:
	if not area is InputSocket:
		# these should be debug instead of info, but idk how to set it
		Logger.info("OutputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
		return
	var socket = area as InputSocket
	if connectedSocketContainsCompatibleResourceType(socket):
		connectedInputSocket = socket
		Logger.info("OutputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: success")
	else: # this else is here just for debuggin purposes
		Logger.info("OutputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
		
		

# shared between the 2 sockets
func connectedSocketContainsCompatibleResourceType(socket: InputSocket) -> bool:
	for resourceType in socket.connectableResourceTypes:
		if resourceType == outputType:
			return true
	return false

# shared between the 2 sockets
func sendMessageToParent() -> void:
	pass

# shared between the 2 sockets
func getConnectedComponentType() -> String:
	return parentGridComponent.get_class()
	
## this will return the value taken by the input
func sendResourcesToConnectedInputSocket(fullResource: float) -> float:
	if connectedInputSocket == null:
		Logger.debug("OutputSocket not connected to InputSocket, can't send resources!")
		return 0
	return connectedInputSocket.sendResourcesToConnectedGridComponent(fullResource)
