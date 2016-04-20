
extends RigidBody

var parent=null
var timer=0
var speed=2

func _ready():
	get_node("AnimationPlayer").set_speed(speed)
	set_process(true)

func rescale(size):
	var new_size=0.1*size
	var t=Transform(Vector3(new_size,0,0),Vector3(0,new_size,0),Vector3(0,0,new_size),Vector3(0,0,0))
	
	set_shape_transform(0,t)
	get_node("Sphere").set_scale(Vector3(new_size,new_size,new_size))
	#get_node("CollisionShape").set_scale(new_size)

func _process(delta):
	
	timer+=delta
	if timer>5:
		parent.explode()
	elif timer>4 and speed<4:
		speed=5
		get_node("AnimationPlayer").set_speed(speed)
	
	var colliders=get_colliding_bodies()
	if colliders.size()>0:
		var c=colliders[0]
		if c.has_method("trigger_explosion"):
			if parent.get_modifier("bomb.sticky") and c!=parent.owner:
				parent.remove_child(self)
				c.add_child(self)
				set_translation(Vector3())
			else:
				parent.explode()
		if parent.get_modifier("bomb.sticky") and c!=parent.owner:
			set_sleeping(true)

func explosion_blown(explosion,strength):
	if parent.get_modifier("bomb.resist_explosion"):
		var t0=explosion.get_global_transform()
		var t1=get_global_transform()
		var blown_direction=t1.origin-t0.origin
		var velocity=blown_direction.normalized()*(strength)
		apply_impulse(t1.origin,velocity)
	else:
		parent.explode()