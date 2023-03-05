extends AbstractCache
class_name MRUCache

var ranks: Array = []

func __setup() -> void:
    policy = "Most Recently Used"

func __get(key: Variant, default: Variant = null, options: Dictionary = {}) -> Variant:
    if has(key):
        ranks.push_front(ranks.pop_at(ranks.bsearch(key)))
        return _cache[key]
    else:
        return null

func __set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    if size() >= CAPACITY:
        super.Evict(key)
    _cache[key] = val
    ranks.push_front(key)

func __evict(key: Variant, options: Dictionary = {}) -> bool:
    var evict_key: Variant = ranks.pop_front()
    return super.__evict(evict_key)
