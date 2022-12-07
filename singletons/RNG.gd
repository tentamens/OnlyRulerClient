extends Node



var num

var RNG = RandomNumberGenerator.new()

func random(smallest, biggest):
	RNG.randomize()
	num = RNG.randf_range(smallest, biggest)
	smallest = 0
	biggest = 0
	
