extends Node3D

class_name Socket

var connectedSocket: Socket
	
func getResourceType() -> SteamEngineTypes.SteamEngineResourceType:
	return SteamEngineTypes.SteamEngineResourceType.UNDEFINED


# shared between the 2 sockets
func connectedSocketContainsCompatibleResourceType(socket: Socket) -> bool:
	if getResourceType() == socket.getResourceType():
		return true
	return false
