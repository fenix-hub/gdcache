extends Node
class_name AbstractCache

var policy: String = ""

signal get_key(key: Variant, hit: bool)
signal set_key(key: Variant, value)
signal evict_key(key: Variant)
signal fetch_key(key: Variant)

@export_range(1, 65536, 1) var CAPACITY: int = 5
var _cache: Dictionary = {}

func __setup() -> void:
    pass

func _init(capacity: int = CAPACITY) -> void:
    randomize()
    self.CAPACITY = capacity
    self.name = "cache_%s" % [randi() + capacity]
    __setup()

## Exposed API to get a key from whatever Cache Type[br]
## Will call the specific Cache internal `__get()` function and return
## its value after emitting the `get_key()` signal
func Get(key: Variant, options: Dictionary = {}) -> Variant:
    var val: Variant = __get(key, options.get("default", null))
    get_key.emit(key, val != null)
    return val

# Cache specific get function, should be overridden
func __get(key: Variant, default: Variant = null, options: Dictionary = {}) -> Variant:
    return _cache.get(key, default)

## Exposed API to set a key for whatever Cache Type[br]
## Will call the specific Cache internal `__set()` function return
## execution after emitting the `set_key()` signal
func Set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    __set(key, val, options)
    set_key.emit(key, val)

# Cache specific set function, should be overridden
func __set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    _cache[key] = val

func Evict(key: Variant, options: Dictionary = {}) -> bool:
    var evicted: bool = __evict(key, options)
    if evicted: 
        evict_key.emit(key)
    return evicted

func __evict(key: Variant, options: Dictionary = {}) -> bool:
    return _cache.erase(key)

# Utility Functions


## Returns [code]true[/code] if cache contains the provided [code]key[/code], else [code]false[/code]
func has(key: Variant) -> bool:
    return _cache.has(key)


func keys() -> Array[Variant]:
    return _cache.keys()


## Returns the size of the cache, which is the amount of key-value pairs stored
func size() -> int:
    return _cache.size()

## Returns the [member CAPACITY] of the cache, which is the maximum value of key-value pairs
## which can be stored
func capacity() -> int:
    return CAPACITY

func _to_string() -> String:
    return str(_cache)
