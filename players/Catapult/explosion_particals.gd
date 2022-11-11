extends CPUParticles2D


func _explode():
	self.restart()
	get_node("CPUParticles2D").restart()
	get_node("CPUParticles2D2").restart()
