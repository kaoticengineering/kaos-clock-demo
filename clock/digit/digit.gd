extends Node2D

# Basic Mapping of Digit to Segments that'd need
# to be "lit" to build it.
const DIGIT_SEGMENTS: Dictionary = {
	0: ["A", "B", "C", "D", "E", "F"],
	1: ["B", "C"],
	2: ["A", "B", "G", "E", "D"],
	3: ["A", "B", "C", "D", "G"],
	4: ["F", "G", "B", "C"],
	5: ["A", "F", "G", "C", "D"],
	6: ["A", "F", "E", "D", "C", "G"],
	7: ["A", "B", "C"],
	8: ["A", "B", "C", "D", "E", "F", "G"],
	9: ["A", "B", "C", "D", "F", "G"],
}

# This is for the sound effect when digits change
@export var volume_db: float = 0.0

# Instead of hardcoding the collision layers and masks,
# we are using what is set in the inspector. These will
# be referenced as the defaults henceforth after the 
# dictionaries for them are built in _ready().
var _default_layers: Dictionary = {}
var _default_masks: Dictionary = {}
var _current_value: = -1 # this is tracking when digits change
@onready var _block_sound = $Block_Sound

func _ready() -> void:
	_block_sound.volume_db = volume_db # volume is set from the inspector
	for seg in ["A","B","C","D","E","F","G"]:
		for block in get_node(seg).get_children():
			_default_layers[block] = block.collision_layer
			_default_masks[block] = block.collision_mask
# For each segement in the digit, we look at the dictionary
# for DIGIT_SEGMENTS. We pass it the value (number) we want
# displayed and if that digit segment we are currently looking
# at isn't a segment included in the dictionary for that number,
# then seg in ... evaluates to false.. and true if it is.
# .visible is the sprite visibility property and the collision_layer
# and collision_mask are the collision properties.. noting that 0
# means that no Layer or Mask is set

func display(value: int) -> void:
	if value == _current_value:
		return
	_current_value = value
	for seg in ["A","B","C","D","E","F","G"]:
		var is_active = seg in DIGIT_SEGMENTS.get(value, [])
		var segment = get_node(seg)
		segment.visible = is_active
		for block in segment.get_children():
			block.collision_layer = _default_layers[block] if is_active else 0
			block.collision_mask = _default_masks[block] if is_active else 0
	# Play sound
	# Sound level depends on the digit and on the player distance from the digit
	_block_sound.play()
