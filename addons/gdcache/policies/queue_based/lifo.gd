extends AbstractCache
class_name LIFOCache

var evict_idx: int

func __setup() -> void:
    evict_idx = CAPACITY
    policy = "Last In First Out"

func __set(key: Variant, val: Variant, options: Dictionary = {}):
    if size() >= CAPACITY:
        if evict_idx == 0:
            evict_idx = CAPACITY
        evict_idx -= 1
        Evict(keys()[evict_idx])
    _cache[key] = val
