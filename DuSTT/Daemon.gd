class_name Daemon
const LEFT = 0
const MIDDLE = 1
const RIGHT = 2
var loops:int = 0
var Steps:Array[TernaryTreeNode]
var TernaryTree:TernaryTreeNode

func add_node(new_node:TernaryTreeNode, ternary_tree:TernaryTreeNode):
	var left:TernaryTreeNode = ternary_tree.get_child(LEFT)
	var right:TernaryTreeNode = ternary_tree.get_child(RIGHT)
	loops += 1
	if new_node.value > ternary_tree.value:
		if left != null:
			if right != null:
				new_node.set_child(LEFT, ternary_tree)
			else:
				new_node.set_child(LEFT, ternary_tree.get_child(LEFT))
				new_node.set_child(RIGHT, ternary_tree)
				ternary_tree.clear_children(LEFT)
				ternary_tree.least = ternary_tree.value
		else:
			if right != null:
				new_node.set_child(LEFT, ternary_tree.get_child(RIGHT))
				ternary_tree.clear_children(RIGHT)
				new_node.set_child(RIGHT, ternary_tree)
			else:
				new_node.set_child(LEFT, ternary_tree)
		return new_node
	elif new_node.value == ternary_tree.value:
		ternary_tree.append_middle(new_node)
	elif new_node.value < ternary_tree.value:
		if left != null:
			if new_node.value > left.value:
				if right != null:
					if new_node.value > right.value:
						ternary_tree.set_child(RIGHT, add_node(new_node, right), false)
					elif new_node.value == right.value:
						right.append_middle(new_node)
					elif new_node.value < right.value:
						ternary_tree.set_child(RIGHT, add_node(new_node, right), false)
				else:
					ternary_tree.set_child(RIGHT, new_node)
			elif new_node.value == left.value:
				left.append_middle(new_node)
			elif new_node.value < left.value:
				if right != null:
					if left.least < right.least:
						ternary_tree.set_child(LEFT, add_node(new_node, left), false)
					else:
						ternary_tree.set_child(RIGHT, add_node(new_node, right), false)
				else:
					if left.has_child(RIGHT):
						if left.get_child(RIGHT).value < new_node.value:
							new_node.set_child(RIGHT, left.get_child(RIGHT))
							left.clear_children(RIGHT)
					if left.has_child(LEFT):
						if left.get_child(LEFT).value > new_node.value:
							new_node = add_node(left.get_child(LEFT), new_node)
						else:
							new_node.set_child(LEFT, left.get_child(LEFT))
						left.set_child(LEFT, left.get_child(RIGHT))
						left.clear_children(RIGHT)
						left.get_least()
						#Reupdate Least value
						#Finish
					ternary_tree.set_child(RIGHT, left)
					ternary_tree.set_child(LEFT, new_node)
		else:
			ternary_tree.set_child(LEFT, new_node)
	return ternary_tree

func Sort(unsorted_list:Array[int]):
	Steps.clear()
	loops = 0
	TernaryTree = TernaryTreeNode.new(unsorted_list[0])
	unsorted_list.remove_at(0)
	Steps.append(TernaryTree.duplicate())
	for number in unsorted_list:
		TernaryTree = add_node(TernaryTreeNode.new(number), TernaryTree)
		Steps.append(TernaryTree.duplicate())
		
func get_list(node:TernaryTreeNode = TernaryTree, output:Array[int] = []):
	for index in [LEFT, RIGHT, MIDDLE, -1]:
		if index == -1:
			output.append(node.value)
		else:
			if node.has_child(index):
				get_list(node.get_child(index), output)
	return output
