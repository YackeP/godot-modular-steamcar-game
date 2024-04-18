extends Control

class_name EngineElementUIPreviewBase

var _component: GridComponent

# TODO: can this be a GridComponent instead to be more type-safe?
# TODO: can we ensure that the subtype of GridComponent is correct?
	# this EngineElementUIPreview will be a part of the resource
	# but, it HAS to have info about the type of element to be able to access it's value
	# a reference to a class couples the UI preview to the class instance itself
	# 	- might be better to make an enum for components 
# TODO: elements have a reference to a GridComponent, can we check for type here?
# ex:
	#func registerObject(object: Node3D):
		#if object is SteamBoiler:
			#boiler = object

	#func destroyRepresentingUI(object: Node3D):
		#if object == boiler:
			#boiler = null # this is needed to remove the reference so that the object can be freed
			#queue_free()

func registerObject(object: GridComponent):
	_component = object

func destroyRepresentingUI(object: GridComponent):
	_component = null # this is needed to remove the reference so that the object can be freed
	queue_free()
