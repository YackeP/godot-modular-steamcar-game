extends Node3D

class_name GridPlacementController

var houseScene1: PackedScene = preload("res://Scenes/House1.tscn")
var houseScene2: PackedScene = preload("res://Scenes/House2.tscn")

var houseGhostScene1: PackedScene = preload("res://Scenes/House1Ghost.tscn")
var houseGhostScene2: PackedScene = preload("res://Scenes/House2Ghost.tscn")

var selectedHouseScene: PackedScene

var houseGhost: Node3D

const ray_length = 1000

func _physics_process(delta) -> void:
	if selectedHouseScene != null:
		var result: Dictionary = getObjectHitByMouse()
		
		if !result.is_empty():
			var result_pos = result['position']
			if houseGhost == null:
				createGhost(houseGhostScene1 if selectedHouseScene == houseScene1 else houseGhostScene2)
			
			houseGhost.position = getNearestGridPosition(result_pos)
		elif houseGhost != null:
			removeGhost()


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_1:
			selectedHouseScene = houseScene1
			removeGhost()
			createGhost(houseGhostScene1)
		elif event.keycode == KEY_2:
			selectedHouseScene = houseScene2
			removeGhost()
			createGhost(houseGhostScene2)
	
	elif event is InputEventMouseButton and event.pressed and event.button_index == 1 and selectedHouseScene != null:
		print("Clicked button")
		var result: Dictionary = getObjectHitByMouse()
		
		if !result.is_empty():
			var result_pos = result['position']
			createGridObject(selectedHouseScene, result_pos)
			print(result)


func removeGhost() -> void:
	if( houseGhost != null):
		houseGhost.queue_free()
		remove_child(houseGhost)

func createGhost(ghost: PackedScene) -> void:
	var ghostInstance = ghost.instantiate()
	houseGhost = ghostInstance
	add_child(ghostInstance)
	
func createGridObject(object: PackedScene, pos: Vector3) -> void:
	var objectInstance = object.instantiate()
	add_child(objectInstance)
	objectInstance.position = getNearestGridPosition(pos)

func getNearestGridPosition(rawPosition: Vector3) -> Vector3:
	return Vector3(round(rawPosition.x), rawPosition.y, round(rawPosition.z))
	
# this can get extracted to some sort of a util class
func getObjectHitByMouse() -> Dictionary:
	var camera = get_viewport().get_camera_3d()
	var mousePos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * ray_length
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to)) 
	
