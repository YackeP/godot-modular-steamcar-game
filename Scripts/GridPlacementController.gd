extends Node3D

class_name GridPlacementController

const _RAY_LENGTH = 1000
const _GRID_SLOT_LAYER_MASK := 0b00000000_00000000_00000000_00010000 # layer 5
const _GRID_COMPONENT_LAYER_MASK := 0b00000000_00000000_00000000_00001000 # layer 4
var _PLACEABLE_OBJECTS: Array[PlaceableObjectDefinition] = [
	PlaceableObjectDefinition.new(preload("res://Scenes/PlacedObjects/CoalFurnace.tscn"),preload("res://Scenes/PlacedObjectGhosts/CoalFurnaceGhost.tscn")),
	PlaceableObjectDefinition.new(preload("res://Scenes/PlacedObjects/SteamBoiler.tscn"),preload("res://Scenes/PlacedObjectGhosts/SteamBoilerGhost.tscn")),
	PlaceableObjectDefinition.new(preload("res://Scenes/PlacedObjects/SteamPiston.tscn"),preload("res://Scenes/PlacedObjectGhosts/SteamPistonGhost.tscn"))
]

@export var _camera: Camera3D

var _enabled: bool = false

var _selectedPlaceable: PlaceableObjectDefinition
var _houseGhost: PlacementGhost

#func _init() -> void:
#	Logger.set_default_output_level(1) # debugging, need to set this more properly
# this also doesn't actually work

func enable():
	_enabled = true
	_camera.make_current()
	
func disable():
	pass

func _physics_process(delta) -> void:
	if _enabled:
		if _selectedPlaceable != null:
			var hitGridSpace = getGridSpaceHitByMouse()
			if hitGridSpace != null:
				if _houseGhost == null:
					_createGhost(_selectedPlaceable.ghost)
				_houseGhost.position = getNearestGridPosition(hitGridSpace.position)
			elif _houseGhost != null:
				_removeGhost()

func _input(event):
	if _enabled:
		if event is InputEventKey:
			var pressedNumber = _get_pressed_number(event)
			if (pressedNumber >= 0 and pressedNumber < _PLACEABLE_OBJECTS.size()):
				_selectedPlaceable = _PLACEABLE_OBJECTS[pressedNumber]
				_removeGhost()
				_createGhost(_selectedPlaceable['ghost'])
		
		elif event is InputEventMouseButton and event.pressed:
			if event.button_index == 1 and _selectedPlaceable != null:
				_tryPlaceGridComponent()
			elif event.button_index == 2:
				_tryDeleteGridComponent()

func _removeGhost() -> void:
	if( _houseGhost != null):
		_houseGhost.queue_free()
		remove_child(_houseGhost)

func _createGhost(ghost: PackedScene) -> void:
	var ghostInstance = ghost.instantiate()
	_houseGhost = ghostInstance
	add_child(ghostInstance)

func _createGridComponent(object: PackedScene, pos: Vector3, rot: Vector3, gridSpaces: Array[GridSpace]) -> void:
	var objectInstance: GridComponent = object.instantiate()
	add_child(objectInstance)
	objectInstance.setOccupiedSpaces(gridSpaces)
	objectInstance.position = getNearestGridPosition(pos)
	objectInstance.rotation = rot

func _tryPlaceGridComponent():
	var hitGridSpace = getGridSpaceHitByMouse()
	if hitGridSpace != null:
		if _houseGhost.overlapsAllSlots():
			for gridSpace in _houseGhost.getAllOverlappedSlots():
				gridSpace.takeSpace()
			_createGridComponent(_selectedPlaceable.object, hitGridSpace.position, _houseGhost.rotation, _houseGhost.getAllOverlappedSlots())
		else:
			Logger.info("Can not place object, not all slots are overlapping!")

func _tryDeleteGridComponent():
	var hitGridComponent = getGridComponentHitByMouse()
	if hitGridComponent != null:
		getGridComponentHitByMouse().onPress()

func getNearestGridPosition(rawPosition: Vector3) -> Vector3:
	return Vector3(round(rawPosition.x), rawPosition.y, round(rawPosition.z))

# this can get extracted to some sort of a util class
func getObjectHitByMouse(collisionMask: int) -> Dictionary:
	var camera = get_viewport().get_camera_3d()
	var mousePos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * _RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, collisionMask)) 

func getGridSpaceHitByMouse() -> GridSpace:
	var objectHitByMouse = getObjectHitByMouse(_GRID_SLOT_LAYER_MASK)
	if !objectHitByMouse.is_empty() && objectHitByMouse['collider'] is GridSpace:
		return objectHitByMouse['collider'] as GridSpace
	return null
	
func getGridComponentHitByMouse() -> GridComponent:
	var objectHitByMouse = getObjectHitByMouse(_GRID_COMPONENT_LAYER_MASK)
	if !objectHitByMouse.is_empty() && objectHitByMouse['collider'] is GridSpace:
		return objectHitByMouse['collider'].get_parent() as GridComponent
	return null
	
func _get_pressed_number(event: InputEventKey):
	return int(event.keycode) - 49 # if pressed     key 0 -> -1;    key 1 -> 0;		key 2 -> 1;

class PlaceableObjectDefinition:
	var object: PackedScene
	var ghost: PackedScene
	
	func _init(obj, ghst):
		object = obj
		ghost = ghst
