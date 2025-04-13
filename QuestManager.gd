extends Node

signal quest_activated(quest_id: String)

var quests = {
	"find_sword": {
		"title": "Find the Lost Sword",
		"description": "The elder told you to search the forest.",
		"is_active": false,
		"is_completed": false
	}
}

func _ready():
	print_debug("[QuestManager] Loaded with quests:" + JSON.stringify(quests))

func activate_quest(quest_id: String) -> void:
	if quests.has(quest_id):
		quests[quest_id]["is_active"] = true
		print_debug("[QuestManager] Activated quest:", quest_id)
		emit_signal("quest_activated", quest_id)
	else:
		print_debug("[QuestManager] Tried to activate non-existent quest:", quest_id)

func complete_quest(quest_id: String) -> void:
	if quests.has(quest_id):
		quests[quest_id]["is_completed"] = true
		quests[quest_id]["is_active"] = false
		print_debug("[QuestManager] Completed quest:", quest_id)

func is_quest_active(quest_id: String) -> bool:
	return quests.get(quest_id, {}).get("is_active", false)

func is_quest_completed(quest_id: String) -> bool:
	return quests.get(quest_id, {}).get("is_completed", false)
