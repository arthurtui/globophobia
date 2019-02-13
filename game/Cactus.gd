extends Node2D

const LINE_WIDTH = 5.0
const LINE_DARKEN = .5
const COLOR_RANDOM = .1

# Cactus generation constants
const BRANCHING_FACTOR = .5
const CACTUS_COLOR = Color(0, 1, 0)

# Vase generation constants
const VASE_COLOR = Color(.62, .35, .14)
const VASE_BOTTOM_MAX = 50
const VASE_BOTTOM_MIN = 30
const VASE_HEIGHT_MAX = 70
const VASE_HEIGHT_MIN = 50
const VASE_TOP_MAX = 70
const VASE_TOP_MIN = 50

var cactus : Dictionary
var total_points : PoolVector2Array = []
var vase : Dictionary

func _ready():
	randomize()
	position = get_viewport().size / 2
	
	vase = create_vase()
	cactus = create_branch(vase.base_points, CACTUS_COLOR, 1.0)


func _draw():
	draw_cactus(cactus)
	draw_vase(vase)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var error := get_tree().reload_current_scene()
		if error != OK:
			print(error)


func create_branch(base_points : PoolVector2Array, base_color : Color,
		chance : float) -> Dictionary:
	
	if randf() > chance:
		return {}
	
	var branch := {}
	var color := randomize_hue(base_color, COLOR_RANDOM)
	var points : PoolVector2Array = []
	var radius : Vector2 = Vector2()
	
	
	chance = chance * BRANCHING_FACTOR
	branch.left_branch = create_branch([], color, chance)
	branch.right_branch = create_branch([], color, chance)
	
	branch.color = color
	branch.points = points
	
	total_points.append_array(points)
	
	return branch


func create_vase() -> Dictionary:
	var new_vase = {}
	var base_points : PoolVector2Array = []
	var points : PoolVector2Array = []
	var bottom_width := rand_range(VASE_BOTTOM_MIN, VASE_BOTTOM_MAX)
	var top_width := rand_range(VASE_TOP_MIN, VASE_TOP_MAX)
	var height := rand_range(VASE_HEIGHT_MIN, VASE_HEIGHT_MAX)
	var color := randomize_hue(VASE_COLOR, COLOR_RANDOM)
	
	base_points.append(Vector2(-top_width * .4, 0))
	base_points.append(Vector2(top_width * .4, 0))
	points.append(Vector2(-top_width / 2, 0))
	points.append(Vector2(top_width / 2, 0))
	points.append(Vector2(bottom_width / 2, height))
	points.append(Vector2(-bottom_width / 2, height))
	points.append(Vector2(-top_width / 2, 0))
	
	new_vase.base_points = points
	new_vase.points = points
	new_vase.color = color
	
	total_points.append_array(points)
	
	return new_vase


func draw_cactus(cactus) -> void:
	return


func draw_vase(vase) -> void:
	draw_colored_polygon(vase.points, vase.color)
	draw_polyline(vase.points, vase.color.darkened(LINE_DARKEN), LINE_WIDTH)


func randomize_hue(color : Color, hue_range : float) -> Color:
	var new_color := color
	new_color.h = rand_range(color.h - hue_range, color.h + hue_range)
	return new_color
