extends Node

var Background_poly


var Nav_poly
var Destionation
var pressed = false


var the_group = []

func select_nodes(group_name, selected_node, all_touching):
	var group_nodes = get_tree().get_nodes_in_group(group_name)
	selected_node.checkNearby(group_nodes, the_group)


func next_node(group_nodes, the_group):
	print(the_group)
	if group_nodes.empty() == true:
		pass
	else:
		group_nodes[0].checkNearby(group_nodes, the_group)


func move_to(touch_pos):
	for x in the_group:
		x.update_Destination(touch_pos)
		
