extends Area2D

const VELOCITY = 600
const COLOR_VALUES = {
	'red': Color('#EF476F'),
	'blue': Color('#118AB2'),
	'yellow': Color('#FFD166'),
	'purple': Color('#8221A8'),
	'green': Color('#06D6A0'),
	'orange': Color('#F78456')
}

signal blended(result_color, initial_color, free_position)

var target_position = Vector2()
var initial_position = Vector2()

var color
var game_state_position
var is_blended

var blended_area_color
var blended_area_game_state_position

onready var block_sprite = $Sprite
onready var block_size = $CollisionShape2D.get_shape().get_extents()

func blend_block_colors(blended_block_color):
	if color == blended_block_color:
		return color
	
	match [color, blended_block_color]:
		['red', 'blue'], ['blue', 'red']:
			return 'purple'
		['red', 'yellow'], ['yellow', 'red']:
			return 'orange'
		['yellow', 'blue'], ['blue', 'yellow']:
			return 'green'
	
	return null

func _ready():
	is_blended = false
	target_position = position
	block_sprite.modulate = COLOR_VALUES[color]
	_animate_block_size(block_sprite.scale)

func _on_swiped(start_position, direction):
	if _is_click_inside(start_position):
		initial_position = position
		var potential_target_position = _calculate_target_position(direction)
		if _is_move_available(potential_target_position):
			target_position = potential_target_position

func _is_click_inside(start_position):
	return Rect2(position - block_size, block_size * 2).has_point(start_position)

func _is_move_available(potential_position):
	return get_parent().overlap_rect.has_point(potential_position)

func _calculate_target_position(direction):
	return position + direction * get_parent().BLOCK_SIZE

func _physics_process(delta):
	var velocity = (target_position - position).normalized() * delta * VELOCITY
	if (target_position - position).length() > 4:
		position += velocity
	else:
		position = target_position
		if is_blended:
			is_blended = false
			emit_signal("blended", color, blended_area_color, game_state_position, blended_area_game_state_position)
			game_state_position = blended_area_game_state_position

func _on_Block_area_entered(area):
	if (target_position - position).length() > 0:
		var target_color = blend_block_colors(area.color)
		
		if target_color == null:
			target_position = initial_position
		else:
			_animate_block_color(color, target_color)
			blended_area_color = area.color
			blended_area_game_state_position = area.game_state_position
			color = target_color
			area.queue_free()
			is_blended = true

func _animate_block_size(current_scale):
	$SizeTween.interpolate_property(block_sprite, "scale", Vector2(0, 0), current_scale, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	$SizeTween.start()
	
func _animate_block_color(initial_color, result_color):
	$ColorTween.interpolate_property(block_sprite, "modulate", COLOR_VALUES[initial_color], COLOR_VALUES[result_color], 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	$ColorTween.start()