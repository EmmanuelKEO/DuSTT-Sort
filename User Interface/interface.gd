extends Control
@onready var Scroller:ScrollContainer = $HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer
@onready var TernaryTreeControl:Control = $HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/Panel/TernaryTree
@onready var TextDisplay:RichTextLabel = $HBoxContainer/Panel2/MarginContainer/VBoxContainer/RichTextLabel
@onready var LittleDisplay:Label = $HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LittleDisplay
@onready var TextInput:LineEdit = $HBoxContainer/Panel2/MarginContainer/VBoxContainer/HBoxContainer/Input
@onready var Back:Button = $HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Back
@onready var Next:Button = $HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Next
@onready var Reset:Button = $HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Reset
@onready var Finish:Button = $HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Finish
@onready var SampleMenu:PopupMenu = $HBoxContainer/Panel2/MarginContainer/VBoxContainer/HBoxContainer/MenuBar/Samples
@onready var TreeNodeObject:PackedScene = preload("res://User Interface/TreeNode/tree_node.tscn")
@export var Samples:Array[String] = [
	'2,4,1,8,9,5,6,5,3,1,2,1,4,6,4,2,5,6,4,1',
	'0,1,2,3,9,4,5,6,7,8',
	'0,4,0,4,3,6,8,0,9,2',
	'0,1,2,3,4,5,6,7,8,9',
	'5,0,9,2,7,0,3,6,8,1,4,0,0',
	'2,7,4,8,9,0,3,0,1,0,5,6,0',
	'2,7,8,9,5,0,1,3,6,4',
	'8,7,2,1,0,9,6',
	'10,6,8,9',
	'12,9,6,8,5,4,7,3,0,1'
]
var Unsorted_list:Array[int] = []
var Sorted_list:Array[int]
var Steps:Array[TernaryTreeNode] = []
var DuSTT:Daemon = Daemon.new()
var ActiveTreeNode:TreeNode
var Current_step:int = 0



func show_step() -> void:
	if ActiveTreeNode:
		ActiveTreeNode.queue_free()
	ActiveTreeNode = TreeNodeObject.instantiate()
	TernaryTreeControl.add_child(ActiveTreeNode)
	ActiveTreeNode.generate_tree(Steps[Current_step])
	Back.disabled = Current_step == 0
	Next.disabled = Current_step == Steps.size() - 1
	Reset.disabled = Back.disabled
	Finish.disabled = Next.disabled
	if Current_step < Steps.size() - 1:
		LittleDisplay.text = str('Next number: ', Unsorted_list[Current_step + 1])
	else:
		LittleDisplay.text = 'Done'

func set_input(_input:String) -> void:
	if _input != '':
		var invalid:bool = false
		var number:String = ''
		Unsorted_list.clear()
		for letter in _input:
			if letter == ',':
				Unsorted_list.append(int(number))
				number = ''
			elif letter in '0123456789 ':
				number += letter
			else:
				invalid = true
				break
		if invalid:
			TextDisplay.add_text('Invalid Input')
			TextDisplay.newline()
			TextDisplay.newline()
		else:
			Unsorted_list.append(int(number))
			TextDisplay.add_text(str('Input: ', Unsorted_list))
			sort_list()
			

func sort_list() -> void:
	DuSTT.Sort(Unsorted_list.duplicate(true))
	Steps = DuSTT.Steps
	Sorted_list = DuSTT.get_list()
	add_output()

func add_output() -> void:
	TextDisplay.newline()
	TextDisplay.add_text(str('Output: ', Sorted_list))
	TextDisplay.newline()
	TextDisplay.add_text(str('Loops: ', DuSTT.loops))
	TextDisplay.newline()
	TextDisplay.add_text(str('N: ', Sorted_list.size()))
	TextDisplay.newline()
	TextDisplay.newline()
	Current_step = 0
	show_step()

func display_structure() -> void:
	var simple_structure:TernaryTreeNode = TernaryTreeNode.new(10)
	var left:TernaryTreeNode = TernaryTreeNode.new(6)
	left.set_child(TernaryTreeNode.POSITION.LEFT, TernaryTreeNode.new(2))
	left.set_child(TernaryTreeNode.POSITION.RIGHT, TernaryTreeNode.new(4))
	var right:TernaryTreeNode = TernaryTreeNode.new(8)
	right.set_child(TernaryTreeNode.POSITION.LEFT, TernaryTreeNode.new(4))
	right.set_child(TernaryTreeNode.POSITION.RIGHT, TernaryTreeNode.new(6))
	simple_structure.set_child(TernaryTreeNode.POSITION.LEFT, left)
	simple_structure.set_child(TernaryTreeNode.POSITION.RIGHT, right)
	simple_structure.set_old()
	Steps.append(simple_structure)
	show_step()

func _ready() -> void:
	for sample in Samples:
		SampleMenu.add_item(sample)
	await get_tree().create_timer(0.1).timeout
	center()

func center() -> void:
	Scroller.scroll_horizontal = int((2000 - Scroller.get_h_scroll_bar().page) / 2)
	Scroller.scroll_vertical = 0

func _on_back_pressed() -> void:
	if Current_step > 0:
		Current_step -= 1
		show_step()

func _on_next_pressed() -> void:
	if Current_step < Steps.size() - 1:
		Current_step += 1
		show_step()

func _on_run_pressed() -> void:
	set_input(TextInput.text)

func _on_clear_pressed() -> void:
	TextDisplay.clear()

func _on_input_text_submitted(new_text:String) -> void:
	set_input(new_text)
	TextInput.release_focus()

func _on_samples_index_pressed(index) -> void:
	TextInput.text = Samples[index]

func _on_reset_pressed() -> void:
	Current_step = 0
	show_step()

func _on_finish_pressed() -> void:
	Current_step = Steps.size() - 1
	show_step()

func _on_center_pressed() -> void:
	center()
