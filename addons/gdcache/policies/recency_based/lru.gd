extends AbstractCache
class_name LRUCache

# LRU Implementation

# There are different options for implementing LRU cache.
# --- GENERALISTIC ---
# 1. Using a dictionary and a doubly linked list
# 2. Using a dictionary and a singly linked list
# 3. Using a dictionary and a queue
# 4. Using a dictionary and a stack
# --- GODOT SPECIFIC ---
# 5. Usind two separate dictionaries, one for resources and one for ranks
# 6. Using one single dictionary of key,Resource objects, with a Resource holding both "value" and "rank"

# This implementation uses a dictionary and a queue
# As long as the `ranks` queue: 
# 1. is ordered from least recently used to most recently used
# 2. is updated when a resource is accessed
# 3. the size is kept to the cache size
# we don't really need to increment the ranks of the items in the cache
# nor find the min(rank) to remove the least recently used item

var ranks: Array = []

func _setup() -> void:
    policy = "Least Recently Used"

func _Get(key, options = {}):
    if cache.has(key):
    # Increment the rank of the requested resource
    # by pushing the resource at the end of the queue
    # NOTE! Over large arrays this is not efficient
        ranks.push_back(ranks.pop_at(ranks.bsearch(key))) 
    return cache.get(key, null)

func _Set(key, val, options: Dictionary = {}) -> void:
    # Evic the least recently used item
    if cache.size() == CAPACITY:
        Evict(key)
    cache[key] = val
    ranks.push_back(key)

func _Evict(key) -> void:
    var evict_key = ranks.pop_front()
    cache.erase(evict_key)
