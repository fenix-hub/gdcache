extends AbstractCache
class_name FIFOCache

func _setup() -> void:
    policy = "First In First Out"

func _Set(key, val, options: Dictionary = {}) -> void:
    if cache.size() == CAPACITY:
        evict(cache.keys()[0])
    cache[key] = val

    
