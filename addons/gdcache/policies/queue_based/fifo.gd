extends AbstractCache
class_name FIFOCache

func __setup() -> void:
    policy = "First In First Out"

func __set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    if size() >= CAPACITY:
        Evict(keys()[0])
    _cache[key] = val
