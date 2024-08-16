extends Node
## Please Update
const SAVE_PATH = "user://pneumagame.save"
const PROGRESS_PATH = "user://pneumagame_progress.save"
const PASSWORD = "pneuma"
# -------------
var example_save
var wins
var losses


## A new blank save that saves generic data
func new_save():
	return {
		"ExampleSave" = 0
	}

## A new blank progress save that saves different sort of progress data
func new_progress():
	return {
		"ExampleProgress": {
			"Wins": 0,
			"Losses": 0
		}
	}

## Generates a new save dictionary to save current data
func generate_save_dict():
	return {
		"ExampleSave" : example_save
	}

## Generates a new progress save dictionary to save current progress
func generate_progress_dict():
	return {
		"ExampleProgress": {
			"Wins": wins,
			"Losses": losses
		}
	}


## create a new savegame file and store it in local storage
func save_game(save_path = SAVE_PATH):
	var new_save_game = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, PASSWORD)
	var json_string
	if save_path == SAVE_PATH:
		json_string = JSON.stringify(generate_save_dict())
	elif save_path == PROGRESS_PATH:
		json_string = JSON.stringify(generate_progress_dict())
	new_save_game.store_line(json_string)
	new_save_game.close()
	print("saved at {0}: {1}".format([save_path, json_string]))

## return if a file already exists
func save_file_exists(save_path = SAVE_PATH):
	return FileAccess.file_exists(save_path)

## access the save file to load data back into the game
func load_game(save_path = SAVE_PATH):
	if !save_file_exists(save_path):
		if save_path == SAVE_PATH:
			return new_save()
		if save_path == PROGRESS_PATH:
			return new_progress()
	else:
		var saveFile = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, PASSWORD)
		var saveData = saveFile.get_as_text()
		saveFile.close()
		var jsonParser = JSON.new()
		var error = jsonParser.parse(saveData)
		if error == OK:
			return jsonParser.data
		else:
			print("JSON Parse Error: ", jsonParser.get_error_message(), " in ", saveData, " at line ", jsonParser.get_error_line())

## access the save file to load progress back into the game
func load_progress_variables():
	var loaded_progress_vars = load_game(PROGRESS_PATH)
	var default_progress_values = new_progress() # For new versions of save files
	var progress = loaded_progress_vars.get("PlayerVsCpuScores", default_progress_values["PlayerVsCpuScores"])
	wins = progress.get("Wins", 0)
	losses = progress.get("Losses", 0)

## Put all necessary quitting logic here
func quit_game():
	get_tree().quit()
