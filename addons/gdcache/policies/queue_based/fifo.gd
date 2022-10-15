extends AbstractCache
class_name FIFOCache

func _Get(key):
    return cache.get(key, null)
 
func _Set(key, val, options: Dictionary = {}) -> void:
    if cache.size() == CAPACITY:
        evict(cache.keys()[0])
    cache[key] = val

    
