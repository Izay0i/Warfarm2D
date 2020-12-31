extends Node

const UNIT_SIZE = 64
const FILE_PATH = "user://settings.cfg"

var music_on : bool = true
var tutorial_finished : bool = false
var current_stage : String
var spawn_point : Vector2 = Vector2(-1, -1)

func save_config():
	print("Saving data to config")

	var cfg_file = ConfigFile.new()
	cfg_file.set_value("Settings", "music_on", music_on)
	cfg_file.set_value("Settings", "tutorial_finished", tutorial_finished)
	cfg_file.set_value("Settings", "current_stage", current_stage)
	cfg_file.set_value("Settings", "spawn_point", spawn_point)

	if cfg_file.save(FILE_PATH) != OK:
		print("Failed to save data to config")

func load_config():
	print("Loading config file")

	var cfg_file = ConfigFile.new()
	if cfg_file.load(FILE_PATH) != OK:
		#if file doesnt exist, create one
		print("Config file not found. Creating a new file.")
		save_config()

#Check if section is there
	if cfg_file.has_section("Settings"):
		print("Settings found")

		music_on = cfg_file.get_value("Settings", "music_on")
		tutorial_finished = cfg_file.get_value("Settings", "tutorial_finished")
		current_stage = cfg_file.get_value("Settings", "current_stage")
		spawn_point = cfg_file.get_value("Settings", "spawn_point")

func update_config(music, tutorial, stage_name, pos):
	print("Updating values to config file")

	music_on = music
	tutorial_finished = tutorial
	current_stage = stage_name
	spawn_point = pos

func _ready():
	load_config()
	OS.set_window_maximized(true)
