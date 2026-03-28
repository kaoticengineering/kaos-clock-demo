extends Node2D

# .1 = 10 Hz, 1 = every 1 second
#const UPDATE_INTERVAL: float = 0.017

# Used to implement the update interval
var _accum: float = 0.0

@onready var digit_h1 = $DigitH1
@onready var digit_h2 = $DigitH2
@onready var digit_m1 = $DigitM1
@onready var digit_m2 = $DigitM2
@onready var digit_s1 = $DigitS1
@onready var digit_s2 = $DigitS2
@onready var digit_sss1 = $DigitSSS1
@onready var digit_sss2 = $DigitSSS2
@onready var digit_sss3 = $DigitSSS3
@onready var binary_digit_hh = $BinaryDigitHH
@onready var binary_digit_mm = $BinaryDigitMM
@onready var binary_digit_ss = $BinaryDigitSS
@onready var binary_digit_sss = $BinaryDigitSSS


func _process(delta: float) -> void:
	_update_clock()
	#_accum += delta
	#if _accum >= UPDATE_INTERVAL:
	#	_accum = 0.0
	#	_update_clock()


func _update_clock() -> void:
	var time = Time.get_time_dict_from_system()

	# Split hours, minutes, seconds into individual digits
	var h1 = time["hour"] / 10
	var h2 = time["hour"] % 10
	var m1 = time["minute"] / 10
	var m2 = time["minute"] % 10
	var s1 = time["second"] / 10
	var s2 = time["second"] % 10

	# Split milliseconds into three individual digits
	var ms = Time.get_ticks_msec() % 1000
	var sss1 = ms / 100
	var sss2 = (ms / 10) % 10
	var sss3 = ms % 10

	# Send each value to its digit
	digit_h1.display(h1)
	digit_h2.display(h2)
	digit_m1.display(m1)
	digit_m2.display(m2)
	digit_s1.display(s1)
	digit_s2.display(s2)
	digit_sss1.display(sss1)
	digit_sss2.display(sss2)
	digit_sss3.display(sss3)
	binary_digit_hh.display(time["hour"])
	binary_digit_mm.display(time["minute"])
	binary_digit_ss.display(time["second"])
	binary_digit_sss.display(ms)
