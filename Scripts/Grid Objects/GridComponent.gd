extends Node3D

class_name GridComponent
# is there any way of having an enum field which specifies, which type of the component this is?

var _gridController: GridPlacementController

var occupiedSpaces: Array[GridSpace]

func setOccupiedSpaces(_occupiedSpaces: Array[GridSpace]) -> void:
	occupiedSpaces = _occupiedSpaces
	
func initialize(controller: GridPlacementController):
	_gridController = controller

func deleteSelf():
	Logger.info("deleting " + name)
	_gridController.component_removed.emit(self)
	queue_free()

func _on_collider_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		deleteSelf()

func _exit_tree() -> void:
	for space in occupiedSpaces:
		space.freeSpace()
