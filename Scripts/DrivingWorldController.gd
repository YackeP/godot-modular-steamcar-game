extends Node3D

class_name DrivingWorldController

@export var _playerVehicle: BaseCar

func setEngineBonusPower(bonusPower: float):
	_playerVehicle.setEngineBonusPower(bonusPower)

func enable():
	if _playerVehicle.get_parent_node_3d() == null:
		add_child(_playerVehicle)
	$BananaCar/Camera/VehicleCamera3d.make_current() # FIXME - this smells, one change of the structure and all this breaks - the BaseCar should have a different method for activating and deactivating itself
	# FIXME: for some reason, this way of returning and object to the tree makes the collisions behave weirdly
	$BananaCar.translate(Vector3.UP * 1)
	$BananaCar.rotation = Vector3(0, $BananaCar.rotation.y, 0)
	

func disable():
	remove_child(_playerVehicle)
	pass
 
