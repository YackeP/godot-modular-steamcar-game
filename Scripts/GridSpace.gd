extends StaticBody3D

class_name GridSpace

@export var collider: CollisionShape3D

func takeSpace() -> void:
	collider.disabled = true
