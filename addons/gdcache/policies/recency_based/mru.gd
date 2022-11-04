extends AbstractCache
class_name MRUCache

var ranks: Array = []

func _setup() -> void:
	policy = "Most Recently Used"

func _Get(key, options: Dictionary = {}):
	if cache.has(key):
		ranks.push_back(ranks.pop_at(ranks.bsearch(key)))
	return cache.get(key, null)

func _Set(key, val, options: Dictionary = {}) -> void:
	if cache.size() == CAPACITY:
		Evict(key)
	cache[key] = val
	ranks.push_back(key)

func _Evict(key) -> void:
	var evict_key = ranks.pop_back()
	cache.erase(evict_key)
