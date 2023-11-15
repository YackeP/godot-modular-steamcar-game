extends StaticBody3D

class_name RocketEngine

@export var inputSocket: Area3D
@export var mesh: MeshInstance3D

var socketFilledMaterial = preload("res://Textures/RockerEngineOverrideConnected.tres")

 # this is a workaround for the Area3D and static objects bug - this will refresh the collisions on every frame
func _physics_process(delta):
	# Considering "area" an Area3D, and layer 32 an unused layer 
	inputSocket.set_collision_layer_value(32, not inputSocket.get_collision_layer_value(32))

func _on_input_socket_area_entered(area: Area3D):
	Logger.info("Input socket filled: " + self.name + ", area:"+ area.name)
	mesh.set_surface_override_material(0, socketFilledMaterial)

