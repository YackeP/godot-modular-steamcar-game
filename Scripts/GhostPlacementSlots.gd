extends Area3D

class_name GhostPlacementSlots

func overlapsAllSlots() -> bool:
	Logger.info("Ghost is overlappingBodies:",get_overlapping_bodies().reduce(func(acc: String, body:Node3D): return acc + ", " + body.name,""))
	var gridSize = get_child_count()
	return get_overlapping_bodies().filter(_bodyIsGridSpace).size() == gridSize

func getAllOverlappedSlots() -> Array[GridSpace]:
	var tempArr: Array[GridSpace]
	tempArr.assign(get_overlapping_bodies().filter(_bodyIsGridSpace))
#(gridArea.get_overlapping_bodies() as Array[GridSpace]).filter(func(body:GridSpace): return body is GridSpace) as Array[GridSpace] -- this won't work, since "filter() will allways returns an untyped array"
# https://www.reddit.com/r/godot/comments/12n4pfc/gdscript_how_to_use_typed_arrays_with_lambda/
	return tempArr

func _bodyIsGridSpace(body: Node3D) -> bool:
	return body is GridSpace