extends Node2D

signal blocks_blended(score)
signal game_over()

const BLOCK_SCENE = preload("res://scenes/Block.tscn")
const BLOCKS_COUNT = 16
const EDGE_SIZE = 4
const BLOCK_SIZE = 100
const START_POSITION_PADDING = 150
const INITIAL_COLORS = { 'red': 0, 'blue': 0, 'yellow': 0 }

onready var screen_size = get_viewport_rect().size

var overlap_rect: Rect2
var game_state = {}

func _ready():
	_calculate_overlap_rect()
	_setup_init_colors_count()
	_spawn_blocks()

#### Init part ####
func _spawn_blocks():
	for i in range(BLOCKS_COUNT):
		var column_index = i % EDGE_SIZE
		var row_index = floor(i / EDGE_SIZE)
		_init_block(column_index, row_index, _get_initial_color())

func _calculate_overlap_rect():
	overlap_rect = Rect2(Vector2(_calc_start_point(screen_size.x), _calc_start_point(screen_size.y)), 
		Vector2(EDGE_SIZE, EDGE_SIZE) * BLOCK_SIZE)

func _calc_start_point(value):
	return floor(value / 2) - START_POSITION_PADDING

func _init_block(column, row, init_color):
	var block = BLOCK_SCENE.instance()
	block.game_state_position = Vector2(column, row)
	block.position = overlap_rect.position + Vector2(column * BLOCK_SIZE, row * BLOCK_SIZE)
	block.color = init_color
	
	$SwipeController.connect("swiped", block, "_on_swiped")
	block.connect("blended", self, "_on_block_blended")
	add_child(block)
	game_state[block.game_state_position] = block

func _on_block_blended(result_color, initial_color, game_state_position, blended_area_game_state_position):
	emit_signal("blocks_blended", _calculate_score(result_color, initial_color))
	game_state[blended_area_game_state_position] = game_state[game_state_position]
	_init_block(game_state_position.x, game_state_position.y,  _get_random_color(_get_available_colors(result_color)))
	if (_check_is_game_over()):
		emit_signal("game_over")

func _setup_init_colors_count():
	INITIAL_COLORS['red'] = 6
	INITIAL_COLORS['yellow'] = 5
	INITIAL_COLORS['blue'] = 5

#### Block handlings #####

func _get_random_color(available_colors):
	return available_colors[randi() % available_colors.size()]

func _calculate_score(first_color, second_color):
	if first_color == second_color:
		if first_color == 'red' or first_color == 'yellow' or first_color == 'blue':
			return 1
		elif first_color == 'purple' or first_color == 'orange' or first_color == 'green':
			return 5
	else:
		if first_color == 'purple' or first_color == 'orange' or first_color == 'green':
			return 3

func _get_available_colors(banned_color):
	var blocks = get_tree().get_nodes_in_group("blocks")
	var available_colors = INITIAL_COLORS.keys()
	for block in blocks:
		if not block.color in available_colors:
			available_colors.push_back(block.color)
	
	available_colors.erase(banned_color)
	return available_colors

func _get_initial_color():
	var available_colors = []
	
	for color in INITIAL_COLORS.keys():
		if INITIAL_COLORS[color] > 0:
			 available_colors.push_back(color)
	
	var possible_color = _get_random_color(available_colors)
	INITIAL_COLORS[possible_color] -= 1
	
	return possible_color

func _check_is_game_over():
	var possible_moves = []
	
	for i in range(BLOCKS_COUNT):
		var column = i % EDGE_SIZE
		var row = floor(i / EDGE_SIZE)
		var current_block = game_state[Vector2(column, row)]
		var current_block_move = false

		if column > 0 and current_block.blend_block_colors(game_state[Vector2(column - 1, row)].color) != null:
			current_block_move = true
		elif column < EDGE_SIZE- 1 and current_block.blend_block_colors(game_state[Vector2(column + 1, row)].color) != null:
			current_block_move = true
		if row > 0 and current_block.blend_block_colors(game_state[Vector2(column, row - 1)].color) != null:
			current_block_move = true
		if row < EDGE_SIZE - 1 and current_block.blend_block_colors(game_state[Vector2(column, row+ 1)].color) != null:
			current_block_move = true
		
		possible_moves.push_back(current_block_move)
		
	if true in possible_moves:
		return false
	else:
		return true











