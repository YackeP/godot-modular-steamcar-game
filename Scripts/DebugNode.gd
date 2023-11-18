extends Node3D

class_name DebugNode

var textValueGetters: Array[Callable]

@onready var textLabel = $Text as Label3D

func _enter_tree():
	var debugSettings: DebugSettings = get_node("/root/DebugSettings")
	if !debugSettings.SHOW_DEBUG_NODES:
		hide()


func addTextValueGetter(getter: Callable) -> void:
	textValueGetters.append(getter)
	
func _physics_process(delta: float) -> void:
	var text = ""
	for getter in textValueGetters:
		text += getter.call() + "\n"
	textLabel.text = text
