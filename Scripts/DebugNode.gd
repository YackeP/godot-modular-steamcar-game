extends Node3D

class_name DebugNode

func _enter_tree():
	var debugSettings: DebugSettings = get_node("/root/DebugSettings")
	if !debugSettings.SHOW_DEBUG_NODES:
		hide()
