class_name TernaryTreeNode
enum POSITION {
	LEFT,
	MIDDLE,
	RIGHT
}
var root:bool
var is_new:bool
var has_changed:bool
var value:int 
var least:int
var height:int = 0
var children:Array[TernaryTreeNode] = [ null, null, null ]
var parent:TernaryTreeNode

func _init(_value:int):
	value = _value
	least = _value
	root = true
	is_new = true 
	has_changed = false

func get_least():
	least = value
	for child in children:
		if child != null:
			child.get_least()
			if child.least < least:
				least = child.least
func set_old():
	is_new = false
	has_changed = false
	for child in children:
		if child != null:
			child.set_old()

func append_middle(child:TernaryTreeNode):
	child.set_child(POSITION.MIDDLE, children[POSITION.MIDDLE])
	children[POSITION.MIDDLE] = child

func up_root(_least:int):
	if parent != null:
		parent.up_root(_least)
	elif _least < least:
		least = _least
	
func set_child(index:int, child:TernaryTreeNode = null, _has_changed:bool = true):
	if child != null:
		child.parent = self
		child.has_changed = _has_changed
		child.root = false
		if child.least < least: least = child.least
	up_root(least)
	children[index] = child

func has_child(index:int): return children[index] != null

func get_child(index:int): return children[index]

func clear_children(p1:int = -1, p2:int = -1,p3:int = -1):
	for p in [p1, p2, p3]: if p != -1: set_child(p)

func duplicate():
	var copy:TernaryTreeNode = get_script().new(value)
	copy.is_new = is_new
	copy.has_changed = has_changed
	copy.least = least
	copy.parent = parent
	for index in [POSITION.LEFT, POSITION.MIDDLE, POSITION.RIGHT]:
		if children[index] != null: copy.children[index] = children[index].duplicate()
	set_old()
	return copy

func _to_string(): return "#" + str(value) + ':' + str(is_new) + str(has_changed) + str(children)
