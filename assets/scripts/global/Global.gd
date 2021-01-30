extends Node

const UNIT_SIZE = 64
const FILE_PATH = "user://settings.cfg"

var music_on : bool = true
var levels_unlocked : int = 1
#path to stage, not stage name
var current_stage : String
var spawn_point : Vector2 = Vector2(-1, -1)

func save_config():
	print("Saving data to config")

	var cfg_file = ConfigFile.new()
	cfg_file.set_value("Settings", "music_on", music_on)
	cfg_file.set_value("Settings", "levels_unlocked", levels_unlocked)
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
		levels_unlocked = cfg_file.get_value("Settings", "levels_unlocked")
		current_stage = cfg_file.get_value("Settings", "current_stage")
		spawn_point = cfg_file.get_value("Settings", "spawn_point")

func _ready():
	load_config()
	OS.set_window_maximized(true)

#Immortal temptation
#Takes over my mind
#Condemned
#Falling weak on my knees
#Summon the strength
#Of Mayhem
#
#I am the storm that is approaching
#Provoking
#Black clouds in isolation
#I am reclaimer of my name
#Born in flames
#I have been blessed
#My family crest is a demon of death
#
#Forsakened I am awakened
#A phoenix’s ash in dark divine
#Descending misery
#Destiny chasing time
#
#Inherit the nightmare
#Surrounded by fate
#Can’t run away
#Keep walking the line
#Between the light
#Led astray
#
#Through vacant halls I won’t surrender
#The truth revealed in eyes of ember
#We fight through fire and ice forever
#Two souls once lost and now they remember
#
#I am the storm that is approaching
#Provoking
#Black clouds in isolation
#I am reclaimer of my name
#Born in flames
#I have been blessed
#My family crest is a demon of death
#
#Forsakened I am awakened
#A phoenix’s ash in dark divine
#Descending misery
#Destiny chasing time
#Disappear into the night
#Lost shadows left behind
#Obsession’s pulling me
#Fading I’ve come to take what’s mine
#
#Lurking in the shadows under veil of night
#Constellations of blood pirouette
#Dancing through the graves of those who stand at my feet
#Dreams of the black throne I keep on repeat
#A derelict of dark summoned from the ashes
#The puppet master congregates all the masses
#Pulling strings twisting minds as blades hit
#You want this power then come try and take it
#
#Beyond the tree
#Fire burns
#Secret love
#Bloodline yearns
#Dark minds embrace
#Crimson Joy
#Does your dim heart
#Heal or Destroy?
#
#Bury the light deep within
#Cast aside there’s no coming home
#We’re burning chaos in the wind
#Drifting in the ocean all alone
