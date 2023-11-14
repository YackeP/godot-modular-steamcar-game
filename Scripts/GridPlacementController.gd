extends Node3D

class_name GridPlacementController

const gridSlotLayerMask := 0b00000000_00000000_00000000_00010000 # layer 5

var houseScene1: PackedScene = preload("res://Scenes/House1.tscn")
var houseScene2: PackedScene = preload("res://Scenes/House2.tscn")
var houseScene3: PackedScene = preload("res://Scenes/House4.tscn")

# TODO: don't use separate scene, just apply a different shader or material to the house scenes.
var houseGhostScene1: PackedScene = preload("res://Scenes/House1Ghost.tscn")
var houseGhostScene2: PackedScene = preload("res://Scenes/House2Ghost.tscn")
var houseGhostScene3: PackedScene = preload("res://Scenes/House4Ghost.tscn")

var selectedHouseScene: PackedScene

var houseGhost: PlacementGhost

const ray_length = 1000

func _physics_process(delta) -> void:
	if selectedHouseScene != null:
		var hitGridSpace = getGridSpaceHitByMouse()
		
		if hitGridSpace != null:
			if houseGhost == null:
				# TODO: refactor this to support an arbirtary number of ghosts
				match selectedHouseScene:
					houseScene1:
						_createGhost(houseGhostScene1)
					houseScene2:
						_createGhost(houseGhostScene2)
					houseScene3:
						_createGhost(houseGhostScene3)
			houseGhost.position = getNearestGridPosition(hitGridSpace.position)
		elif houseGhost != null:
			_removeGhost()

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_1:
			selectedHouseScene = houseScene1
			_removeGhost()
			_createGhost(houseGhostScene1)
		elif event.keycode == KEY_2:
			selectedHouseScene = houseScene2
			_removeGhost()
			_createGhost(houseGhostScene2)
		elif event.keycode == KEY_3:
			selectedHouseScene = houseScene3
			_removeGhost()
			_createGhost(houseGhostScene3)
	
	elif event is InputEventMouseButton and event.pressed and event.button_index == 1 and selectedHouseScene != null:
		_tryPlaceGridObject()

func _removeGhost() -> void:
	if( houseGhost != null):
		houseGhost.queue_free()
		remove_child(houseGhost)

func _createGhost(ghost: PackedScene) -> void:
	var ghostInstance = ghost.instantiate()
	houseGhost = ghostInstance
	add_child(ghostInstance)

func _createGridObject(object: PackedScene, pos: Vector3, rot: Vector3) -> void:
	var objectInstance: Node3D = object.instantiate()
	add_child(objectInstance)
	objectInstance.position = getNearestGridPosition(pos)
	objectInstance.rotation = rot

func _tryPlaceGridObject():
	var hitGridSpace = getGridSpaceHitByMouse()
	if hitGridSpace != null:
		if houseGhost.overlapsAllSlots():
			print("houseGhost.overlapsAllSlots()")
			for gridSpace in houseGhost.getAllOverlappedSlots():
				gridSpace.takeSpace()
			_createGridObject(selectedHouseScene, hitGridSpace.position, houseGhost.rotation)
		print("Trying to place grid object, hit grid space: ", hitGridSpace)

func getNearestGridPosition(rawPosition: Vector3) -> Vector3:
	return Vector3(round(rawPosition.x), rawPosition.y, round(rawPosition.z))

# this can get extracted to some sort of a util class
func getObjectHitByMouse() -> Dictionary:
	var camera = get_viewport().get_camera_3d()
	var mousePos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * ray_length
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, gridSlotLayerMask)) 

func getGridSpaceHitByMouse() -> GridSpace:
	var objectHitByMouse = getObjectHitByMouse()
	if !objectHitByMouse.is_empty() && objectHitByMouse['collider'] is GridSpace:
		return objectHitByMouse['collider'] as GridSpace
	return null
