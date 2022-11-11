extends Area2D


export var mass = 0.75

var launched = false
var velocity = Vector2(950, 400)

func _ready():
	pass


func _process(delta):
	if launched:
		velocity += gravity_vec*gravity*mass/-1
		
		global_position += velocity*delta/-1
		
		rotation += 2


func launch():
	launched = true
	print(velocity)


func _on_Timer_timeout():
	var particals = get_node("CPUParticles2D")
	launched = false
	self.rotation = 0
	particals._explode()
	get_node("CollisionShape2D").disabled = false
	get_node("death_timer").start()
	get_node("death_timer").start()


func _on_death_timer_timeout():
	self.queue_free()


func _on_Area2D_body_entered(body):
	if body.get_group_name() == "knight":
		body.health -= 25


func _on_DamageTimer_timeout():
	get_node("Area2D").queue_free()
