extends Node3D

class_name PlacementGhost

@onready var ghostPlacementSlot: GhostPlacementSlots = get_node("GhostPlacementSlots")

func _input(event):
	if event is InputEventKey and event.keycode == KEY_R and event.pressed:
		rotation_degrees = Vector3(0, rotation_degrees.y + 90, 0)

func overlapsAllSlots() -> bool:
	return ghostPlacementSlot.overlapsAllSlots()

func getAllOverlappedSlots() -> Array[GridSpace]:
	return ghostPlacementSlot.getAllOverlappedSlots()

