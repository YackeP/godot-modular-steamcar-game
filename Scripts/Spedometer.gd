extends Control

class_name Spedometer


@export var speed0degrees: float
@export var speed150degrees: float
@export var gauge: TextureRect
@export var text: Label

func updateGauge(speed: float):
	text.text = str(speed)
	var offset = speed / 150 * abs(speed150degrees - speed0degrees)
	gauge.rotation_degrees = speed0degrees + offset
