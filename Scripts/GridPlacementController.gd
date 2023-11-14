extends Node3D

class_name GridPlacementController

const gridSlotLayerMask := 0b00000000_00000000_00000000_00010000 # layer 5

var placeableObjects: Array[PlaceableObjectDefinition] = [
	PlaceableObjectDefinition.new(preload("res://Scenes/House1.tscn"),preload("res://Scenes/House1Ghost.tscn")),
	PlaceableObjectDefinition.new(preload("res://Scenes/House2.tscn"), preload("res://Scenes/House2Ghost.tscn")),
	PlaceableObjectDefinition.new(preload("res://Scenes/House4.tscn"), preload("res://Scenes/House4Ghost.tscn")),
	PlaceableObjectDefinition.new(preload("res://Scenes/FuelTank.tscn"),preload("res://Scenes/FuelTankGhost.tscn"))
]

var selectedPlaceable: PlaceableObjectDefinition

var houseGhost: PlacementGhost

const ray_length = 1000

func _physics_process(delta) -> void:
	if selectedPlaceable != null:
		var hitGridSpace = getGridSpaceHitByMouse()
		
		if hitGridSpace != null:
			if houseGhost == null:
				_createGhost(selectedPlaceable.ghost)
			houseGhost.position = getNearestGridPosition(hitGridSpace.position)
		elif houseGhost != null:
			_removeGhost()

func _input(event):
	if event is InputEventKey:
		var pressedNumber = _get_pressed_number(event)
		if (pressedNumber >= 0 and pressedNumber < placeableObjects.size()):
			selectedPlaceable = placeableObjects[pressedNumber]
			_removeGhost()
			_createGhost(selectedPlaceable['ghost'])
	
	elif event is InputEventMouseButton and event.pressed and event.button_index == 1 and selectedPlaceable != null:
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
			_createGridObject(selectedPlaceable.object, hitGridSpace.position, houseGhost.rotation)
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
	
func _get_pressed_number(event: InputEventKey):
	return int(event.keycode) - 49 # if pressed     key 0 -> -1;    key 1 -> 0;		key 2 -> 1;

class PlaceableObjectDefinition:
	var object: PackedScene
	var ghost: PackedScene
	
	func _init(obj, ghst):
		object = obj
		ghost = ghst
