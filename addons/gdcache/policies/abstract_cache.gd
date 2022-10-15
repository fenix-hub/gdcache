extends Node
class_name AbstractCache

signal get_key(key, hit: bool)
signal set_key(key, value)
signal evict_key(key)
signal fetch_key(key)

var CAPACITY: int = 100
var cache: Dictionary = {}


func _init(capacity: int = 100) -> void:
    self.CAPACITY = capacity

func _ready() -> void:
    pass

# Exposed API to get a key from whatever Cache Type
# Will call the specific Cache internal `_get()` function and return
# its value after emitting the `get_key()` signal
func Get(key):
    var val = _Get(key)
    get_key.emit(key, val != null)
    return val

# Cache specific get function, should be overridden
func _Get(key):
    return cache.get(key, null)

func Set(key, val, options: Dictionary = {}):
    _Set(key, val, options)
    set_key.emit(key, val)

func _Set(key, val, options: Dictionary = {}):
    cache[key] = val

func evict(key):
    _evict(key)
    evict_key.emit(key)

func _evict(key):
    cache.erase(key)

func fetch(key, fetch_func: Callable):
    fetch_func.call()
    fetch_key.emit(key)

func _to_string() -> String:
    return str(cache)
