extends Node2D

var _default_layers: Dictionary = {}
var _default_masks: Dictionary = {}
var _current_value: int = -1

const COLOR_ACTIVE = Color(1, 1, 1, 1)
const COLOR_INACTIVE = Color(0.2, 0.2, 0.2, 1)

func _ready() -> void:
	for block in get_children():
		_default_layers[block] = block.collision_layer
		_default_masks[block] = block.collision_mask

func display(value: int) -> void:
	if value == _current_value:
		return
	_current_value = value
	# Note that this works great for me because in my tree
	# The blocks are Top to Bottom of the tree by MSB to LSB
	var blocks = get_children()
	for i in range(len(blocks)):
		var block = blocks[i]
		# If this is confusing, look into bit shifting. Here's the tldr:
		# 5 = 0101 but let's say ABCD for now
		# How much to the right do you have to push the bits to 
		# get the value, A, you'd want in the MSB to be in the LSB location? 
		# 3 right? Which is the number of bits you are using to store the
		# number -1
		# What about B.. how many to get it to the LSB place? 
		# What about C? What about D? See the pattern? :)
		var is_active = bool((value >> (len(blocks) - 1 - i)) & 1)
		# block.visible = is_active
		block.modulate = COLOR_ACTIVE if is_active else COLOR_INACTIVE
		block.collision_layer = _default_layers[block] if is_active else 0
		block.collision_mask = _default_masks[block] if is_active else 0
