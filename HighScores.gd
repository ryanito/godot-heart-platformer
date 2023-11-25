extends Node

var high_scores = {}


func add_time(level, score):
	if not high_scores.has(level):
		high_scores[level] = score
		return

	if score < high_scores[level]:
		high_scores[level] = score


func get_best_time(level):
	if not high_scores.has(level):
		return null

	return high_scores[level]
