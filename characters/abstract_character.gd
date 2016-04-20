
extends RigidBody

var modifiers= {
	"attack.size":1
}

func get_data():
	return self

func get_modifier(key):
	return modifiers[key]

func set_modifier(key,value):
	modifiers[key]=value