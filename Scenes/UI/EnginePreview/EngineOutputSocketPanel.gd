extends Panel

var socket: WallInputSocket

@onready
var label: Label = $Label

func _process(_delta) -> void:
	if (socket):
		label.text = "%.2f" % (socket.power * 100)
	else:
		print("EngineOutputSocketPanel: NO SOCKET CONNECTED!")

func registerObject(object: Node3D):
	if object is WallInputSocket:
		socket = object
