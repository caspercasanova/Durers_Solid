class_name User_Preferences extends Resource


@export_range(0, 1, 0.5) var music_audio_level: float  = 1
@export_range(0, 1, 0.5) var sfx_audio_level: float  = 1

@export var action_events: Dictionary = {}


func save() -> void:
	ResourceSaver.save(self, "user://user_preferences.tres")


func load() -> User_Preferences:
	var resource: User_Preferences = ResourceLoader.load("user://user_preferences.tres") as User_Preferences
	if !resource:
		resource = User_Preferences.new()
	
	return resource



const template = {
	"music_audio_level": 1,
	"sfx_audio_level": 1,
	"is_full_screen": true,
	"WeaponUp": "CHANGE",
	"WeaponDown": "CHANGE",
	"Secondary_Fire": "CHANGE",
	"Shoot": "LMB",
	"Reload": "r",
	"Drop_Weapon": "h",
	"Melee": "f",
	"Forward": "w",
	"Left": 'a',
	"Back": 's',
	"Right": "d",
}
