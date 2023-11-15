extends StaticBody3D

class_name WallInputSocket

const SOCKET_FILLED_MATERIAL = preload("res://Textures/WallInputSocketOverrideConnected.tres")

# different from all the others, they use meshes and this one uses just the CSGBox3D
@onready var mesh: CSGBox3D = get_node("CSGBox3D4")
@onready var inputSocket: Area3D = get_node("Input Socket")

func _physics_process(delta):
	# Considering "area" an Area3D, and layer 32 an unused layer 
	inputSocket.set_collision_layer_value(32, not inputSocket.get_collision_layer_value(32))

func _on_input_socket_area_entered(area: Area3D):
	Logger.info("Input socket filled: " + self.name + ", area:"+ area.name)
	mesh.set_material(SOCKET_FILLED_MATERIAL)

