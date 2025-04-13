extends Control
var QuestManager = preload("res://scenes/scripts/QuestManager.gd"  ).new()

func _ready():
	update_quest_list()

func update_quest_list():
	for quest_id in QuestManager.quests:
		var quest = QuestManager.quests[quest_id]
		if quest["is_active"] and !quest["is_completed"]:
			print(quest["title"] + ": " + quest["description"])
