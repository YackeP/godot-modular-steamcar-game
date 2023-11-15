extends StaticBody3D

class_name FuelTank

const SOCKET_FILLED_MATERIAL = preload("res://Textures/FuelTankOverrideConnected.tres")

@onready var mesh: MeshInstance3D = get_node("Mesh")
@onready var outputSocket: Area3D = get_node("Output Socket")

# this is a workaround for the Area3D and static objects bug - this will refresh the collisions on every frame
func _physics_process(delta):
	# Considering "area" an Area3D, and layer 32 an unused layer 
	outputSocket.set_collision_layer_value(32, not outputSocket.get_collision_layer_value(32))

func _on_output_socket_area_entered(area: Area3D):
	Logger.info("Output socket filled: " + self.name + ", area:"+ area.name)
	mesh.set_surface_override_material(0, SOCKET_FILLED_MATERIAL)
