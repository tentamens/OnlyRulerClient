extends Node


var smallest
var biggest
var num

var RNG = RandomNumberGenerator.new()

func random():
	RNG.randomize()
	num = RNG.randf_range(smallest, biggest)
	smallest = 0
	biggest = 0
	
