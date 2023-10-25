extends Node3D

class_name GridPlacementController

var houseScene1: PackedScene = preload("res://Scenes/House1.tscn")
var houseScene2: PackedScene = preload("res://Scenes/House2.tscn")

var houseGhostScene1: PackedScene = preload("res://Scenes/House1Ghost.tscn")
var houseGhostScene2: PackedScene = preload("res://Scenes/House2Ghost.tscn")

var selectedHouse: PackedScene

var houseGhost: Node3D

const ray_length = 1000

func _physics_process(delta) -> void:
	if houseGhost != null:
		houseGhost.queue_free()
		remove_child(houseGhost)
	if selectedHouse != null:
		var camera = get_viewport().get_camera_3d()
		var mousePosition = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousePosition)
		var to = from + camera.project_ray_normal(mousePosition) * ray_length
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var result: Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
		
		if !result.is_empty():
			var result_pos = result['position']
			
			if selectedHouse == houseScene1:
				houseGhost = houseGhostScene1.instantiate()
			elif selectedHouse == houseScene2:
				houseGhost = houseGhostScene2.instantiate()
			add_child(houseGhost)
			houseGhost.position = Vector3(round(result_pos.x), result_pos.y, round(result_pos.z))

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_1:
			selectedHouse = houseScene1
		elif event.keycode == KEY_2:
			selectedHouse = houseScene2
	
	elif event is InputEventMouseButton and event.pressed and event.button_index == 1 and selectedHouse != null:
		print("Clicked button")
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var result: Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
		
		if !result.is_empty():
			var result_pos = result['position']
			var house1Inst: Node3D = selectedHouse.instantiate()
			add_child(house1Inst)
			house1Inst.position = Vector3(round(result_pos.x), result_pos.y, round(result_pos.z))
			print(result)

