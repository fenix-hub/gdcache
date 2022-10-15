extends AbstractCache
class_name LIFOCache

var evict_idx: int = CAPACITY

func _Set(key, val, options: Dictionary = {}):
    if cache.size() == CAPACITY:
        if evict_idx == 0:
            evict_idx = CAPACITY
        evict_idx -= 1
        evict(cache.keys()[evict_idx])
    cache[key] = val
