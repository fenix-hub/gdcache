extends AbstractCache
class_name SLRUCache

# SLRU Implementation
# -----
# Cache is segmented by a total of `n` segments
# each segment is treated as a LRU independent _cache
# (mru) [x x x][x x x][x x x] (lru)
#          S1     S2     S3


var SEGMENTS: int = 3

var ranks: Array = []

func __setup() -> void:
    policy = "Segmented Least Recently Used"

func _init(capacity: int = CAPACITY, segments: int = SEGMENTS) -> void:
    self.SEGMENTS = segments
    
    for segment in SEGMENTS:
        ranks.append(Array([]))
        _cache[segment] = {}
    
    super._init(capacity)

func __get(key: Variant, default: Variant = null, options: Dictionary = {}) -> Variant:
    var val: Variant
    for segment in _cache:
        if _cache[segment].has(key):
            val = _cache[segment][key]
            if ranks[segment].find(key) == 0:
                __promote(key, val, segment)
            else:
                ranks[segment].push_front(ranks[segment].pop_at(ranks[segment].bsearch(key))) 
    return val

func __set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    if _cache[SEGMENTS - 1].size() >= CAPACITY:
        super.Evict(key, { segment = SEGMENTS - 1 })
    _cache[SEGMENTS - 1][key] = val
    ranks[SEGMENTS - 1].push_front(key)

func __evict(key: Variant, options: Dictionary = {}) -> bool:
    ranks[options.segment].remove(key)
    return _cache[options.segment].erase(key)

func __promote(key: Variant, val: Variant, segment: int) -> void:
    if segment > 0:
        __evict(key, { segment = segment })
        if _cache[segment - 1].size() >= CAPACITY:
            var demoted_key: Variant = ranks[segment - 1].pop_front()
            var demoted_value: Variant = _cache[segment - 1][demoted_key]
            _cache[segment - 1].erase(demoted_key)
            
            _cache[segment][demoted_key] = demoted_value
            ranks[segment].push_front(demoted_key)
        _cache[segment - 1][key] = val
        ranks[segment - 1].push_back(key)
