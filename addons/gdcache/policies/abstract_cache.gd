extends Node
class_name AbstractCache

var policy: String = ""

signal get_key(key, hit: bool)
signal set_key(key, value)
signal evict_key(key)
signal fetch_key(key)

var CAPACITY: int = 100
var cache: Dictionary = {}

func _setup() -> void:
	pass

func _init(capacity: int = 100) -> void:
	randomize()
	self.CAPACITY = capacity
	self.name = "cache_%s" % [randi() + capacity]
	_setup()

func _ready() -> void:
	pass

# Exposed API to get a key from whatever Cache Type
# Will call the specific Cache internal `_get()` function and return
# its value after emitting the `get_key()` signal
func Get(key, options: Dictionary = {}):
	var val = _Get(key, options) if not options.is_empty() else _Get(key)
	get_key.emit(key, val != null)
	return val

# Cache specific get function, should be overridden
func _Get(key, options: Dictionary = {}):
	return cache.get(key, null)

# Exposed API to set a key for whatever Cache Type
# Will call the specific Cache internal `_set()` function return
# execution after emitting the `set_key()` signal
func Set(key, val, options: Dictionary = {}):
	if options.is_empty():
		_Set(key, val)
	else:
		_Set(key, val, options)
	set_key.emit(key, val)

# Cache specific set function, should be overridden
func _Set(key, val, options: Dictionary = {}):
	cache[key] = val

func evict(key):
	_evict(key)
	evict_key.emit(key)

func _evict(key):
	cache.erase(key)

func _to_string() -> String:
	return str(cache)
