extends StaticBody3D

class_name FuelTank

@export var outputSocket: Area3D
@export var mesh: MeshInstance3D

var socketFilledMaterial = preload("res://Textures/FuelTankOverrideConnected.tres")

# this is a workaround for the Area3D and static objects bug - this will refresh the collisions on every frame
func _physics_process(delta):
	# Considering "area" an Area3D, and layer 32 an unused layer 
	outputSocket.set_collision_layer_value(32, not outputSocket.get_collision_layer_value(32))

func _on_output_socket_area_entered(area: Area3D):
	Logger.info("Output socket filled: " + self.name + ", area:"+ area.name)
	mesh.set_surface_override_material(0, socketFilledMaterial)
