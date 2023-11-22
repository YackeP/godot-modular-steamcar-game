extends Area3D

class_name OutputSocket

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
	area_entered.connect(tryConnectSocket) # area_entered - Area3D signal when another area intersects it's collision area

# shared between the 2 sockets
func tryConnectSocket(area: Area3D) -> void:
	print("OutputSocket ", self.name, "tryToConnectSocket")
	if not area is InputSocket:
		return
	var socket = area as InputSocket
	if connectedSocketContainsCompatibleResourceType(socket):
		connectedInputSocket = socket

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
		Logger.error("OutputSocket not connected to InputSocket, can't send resources!")
		return 0
	return connectedInputSocket.sendResourcesToConnectedGridComponent(fullResource)
