extends Node3D

class_name GridPlacementController

var house_1: PackedScene = preload("res://Scenes/House1.tscn") # TODO: figure out the typing for this
var house_2: PackedScene = preload("res://Scenes/House2.tscn") # TODO: figure out the typing for this

const ray_length = 1000

func _physics_process(delta) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("Clicked button")
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var result: Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
		
		if !result.is_empty():
			var result_pos = result['position']
			var house_1_inst: Node3D = house_1.instantiate()
			add_child(house_1_inst)
			house_1_inst.position = Vector3(round(result_pos.x), result_pos.y, round(result_pos.z))
			print(result)
		
