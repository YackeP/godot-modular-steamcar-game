extends Node3D

class_name GridComponent
# is there any way of having an enum field which specifies, which type of the component this is?

var gridController: GridPlacementController

var occupiedSpaces: Array[GridSpace]

func setOccupiedSpaces(_occupiedSpaces: Array[GridSpace]) -> void:
	occupiedSpaces = _occupiedSpaces
	
func registerController(controller: GridPlacementController):
	gridController = controller

	# FIXME: change name to delete(), this component shouldn't know HOW it's deleted
func onClick():
	Logger.info("deleting " + name)
	gridController.component_removed.emit(self)
	queue_free()

func _on_collider_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		onClick() # Replace with function body.

func _exit_tree() -> void:
	for space in occupiedSpaces:
		space.freeSpace()
