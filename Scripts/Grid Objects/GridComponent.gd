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
	
func increaseResources(count: float) -> float:
	Logger.warn("increaseResources() not implemented")
	return 0.0


enum GridComponentType {
	BOILER,
	FURNACE,
	PISTON
}
