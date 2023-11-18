extends StaticBody3D

class_name Windmill

@export var powerGenerated := 10.0



func getPower() -> float:
	return powerGenerated

func _ready() -> void:
	($DebugNode as DebugNode).addTextValueGetter(func():return "Power:" + str(getPower()))
