extends AbstractCache
class_name ClockCache

var hand: int = 0

func _setup() -> void:
	policy = "Clock"

func _Get(key, options: Dictionary = {}):
	if cache.has(key):
		cache[key].r_bit = true
        hand = cache.keys().find(key)
        return cache[key].get(val, null)
    else:
        return null

	
func _Set(key, val, options: Dictionary = {}) -> void:
	if cache.size() == CAPACITY:
        while (cache[hand].r_bit):
            cache[hand].r_bit = false
            if hand >= cache.size():
                hand = 0
            else:
                hand +=1
        Evict(key)
	cache[key] = {val = val, r_bit = true}

func _Evict(key) -> void:
	cache.erase(key)