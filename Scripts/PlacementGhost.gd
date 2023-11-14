extends Node3D

class_name PlacementGhost

# FIXME: fill this programatically, find child of type Area3D
@export var gridArea: Area3D

func _input(event):
	if event is InputEventKey and event.keycode == KEY_R and event.pressed:
		rotation_degrees = Vector3(0, rotation_degrees.y + 90, 0)

func overlapsAllSlots() -> bool:
	Logger.info("Ghost is overlappingBodies:",gridArea.get_overlapping_bodies().reduce(func(acc: String, body:Node3D): return acc + ", " + body.name,""))
	var gridSize = gridArea.get_child_count()
	return gridArea.get_overlapping_bodies().filter(_bodyIsGridSpace).size() == gridSize

func getAllOverlappedSlots() -> Array[GridSpace]:
	var tempArr: Array[GridSpace]
	tempArr.assign(gridArea.get_overlapping_bodies().filter(_bodyIsGridSpace))
#(gridArea.get_overlapping_bodies() as Array[GridSpace]).filter(func(body:GridSpace): return body is GridSpace) as Array[GridSpace] -- this won't work, since "filter() will allways returns an untyped array"
# https://www.reddit.com/r/godot/comments/12n4pfc/gdscript_how_to_use_typed_arrays_with_lambda/
	return tempArr


func _bodyIsGridSpace(body: Node3D) -> bool:
	return body is GridSpace
