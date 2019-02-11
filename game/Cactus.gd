extends Node2D

const VASE_BOTTOM_MAX = 50
const VASE_BOTTOM_MIN = 30
const VASE_HEIGHT_MAX = 70
const VASE_HEIGHT_MIN = 50
const VASE_TOP_MAX = 70
const VASE_TOP_MIN = 50

const CACTUS_COLOR = Color(0, 1, 0)
const VASE_COLOR = Color(.62, .35, .14)

var vase := {"base_points": null, "points": null, "color": null}

func _ready():
	randomize()
	position = get_viewport().size / 2
	create_vase()


func _draw():
	draw_colored_polygon(vase.points, vase.color)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()


func create_vase() -> void:
	var base_points : PoolVector2Array
	var points : PoolVector2Array
	var bottom_width := rand_range(VASE_BOTTOM_MIN, VASE_BOTTOM_MAX)
	var top_width := rand_range(VASE_TOP_MIN, VASE_TOP_MAX)
	var height := rand_range(VASE_HEIGHT_MIN, VASE_HEIGHT_MAX)
	var color := VASE_COLOR
	randomize_hue(color, .15)
	
	printt("top_width", top_width)
	printt("bottom_width", bottom_width)
	
	base_points.append(Vector2(-top_width * .4, 0))
	base_points.append(Vector2(top_width * .4, 0))
	points.append(Vector2(-top_width / 2, 0))
	points.append(Vector2(top_width / 2, 0))
	points.append(Vector2(bottom_width / 2, height))
	points.append(Vector2(-bottom_width / 2, height))
	
	vase.base_points = points
	vase.points = points
	vase.color = color


func randomize_hue(color : Color, hue_range : float) -> void:
	color.h = clamp(rand_range(color.h - hue_range, color.h + hue_range), 0, 1)
