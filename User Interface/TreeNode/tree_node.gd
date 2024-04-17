extends Control
class_name TreeNode
@export var Line_color:Color = Color.BLUE
@export var Node_color:Color = Color.RED
@export var New_node_color:Color = Color.DARK_GREEN
@export var Changed_node_color:Color = Color.DARK_BLUE
@onready var Display:Label = $TextureRect/Label
@onready var Lines:Array = [$left, $middle, $right]
@onready var TreeNodeObject:PackedScene = preload("res://User Interface/TreeNode/tree_node.tscn")
const LEFT:int = 0
const MIDDLE:int = 1
const RIGHT:int = 2

func generate_tree(node:TernaryTreeNode, displacement:int = 125) -> void:
	$TextureRect.self_modulate = New_node_color if node.is_new else Changed_node_color if node.has_changed else Node_color
	Display.text = str(node.value,':',node.least)
	for index in [LEFT, MIDDLE, RIGHT]:
		if node.has_child(index):
			var child:TreeNode = TreeNodeObject.instantiate()
			add_child(child)
			Lines[index].points[1] *= displacement
			child.position = Lines[index].points[1]
			Lines[index].default_color = Line_color
			child.generate_tree(node.get_child(index), displacement - 35 if displacement >= 90 else 125)

