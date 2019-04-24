extends Node

const PATH_TO_FILE = "user://highscores.save"
const HIGH_SCORES_LIMIT = 10

var current_scores = []

func _ready():
	var loaded_scores = load_game()
	current_scores = loaded_scores
	loaded_scores.sort_custom(self, "_sort_score")

func save_game():
	var save_game = File.new()
	save_game.open(PATH_TO_FILE, File.WRITE)
	var save_nodes = current_scores
	
	for save_record in save_nodes:
		save_game.store_line(to_json(save_record))
	
	save_game.close()

func load_game():
	var loaded_scores = [] 
	var save_game = File.new()
	if not save_game.file_exists(PATH_TO_FILE):
		return loaded_scores

	save_game.open(PATH_TO_FILE, File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		
		if current_line != null:
			loaded_scores.push_back(current_line)
	
	save_game.close()
	return loaded_scores

func save_score(score, moves):
	var scores_to_save = current_scores
	var save_dict = {
		"score" : score,
		"moves" : moves
	}
	scores_to_save.push_back(save_dict)
	scores_to_save.sort_custom(self, "_sort_score")
	if scores_to_save.size() > 10:
		scores_to_save.resize(HIGH_SCORES_LIMIT)

func _sort_score(a, b):
	if a["score"] > b["score"]:
		return true
	elif a["score"] == b["score"]:
		if a["moves"] <= b["moves"]:
			return true
		else:
			return false
	else:
		return false
