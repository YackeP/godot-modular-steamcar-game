extends Node3D

class_name GridComponent

# Could these be implemented using signals instead of direct function calls?
# If so, what would it actually give us?

func inputSocketConnected() -> void:
	pass
	
func inputSocketDisconnected() -> void:
	pass

func outputSocketConnected() -> void:
	pass
	
func outputSocketDisconnected() -> void:
	pass
	
func receiveResources(count: float) -> float:
	Logger.warn("receiveResources() not implemented")
	return 0.0


enum GridComponentType {
	BOILER,
	FURNACE,
	PISTON
}
