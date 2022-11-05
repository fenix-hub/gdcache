extends AbstractCache
class_name RRCache

func _setup() -> void:
	policy = "Random Replacement"

func _Set(key, val, options = {}) -> void:
	if cache.size() == CAPACITY:
		Evict(cache.keys()[randi() % cache.size()])
	cache[key] = val
