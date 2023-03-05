extends AbstractCache
class_name RRCache

func __setup() -> void:
    policy = "Random Replacement"

func __set(key: Variant, val: Variant, options = {}) -> void:
    if size() >= CAPACITY:
        Evict(keys()[randi() % size()])
    _cache[key] = val
