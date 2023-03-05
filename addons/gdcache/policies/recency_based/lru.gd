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

func __setup() -> void:
    policy = "Least Recently Used"

func __get(key: Variant, default: Variant = null, options: Dictionary = {}) -> Variant:
    if has(key):
    # Increment the rank of the requested resource
    # by pushing the resource at the end of the queue
    # NOTE! Over large arrays this is not efficient
        ranks.push_front(ranks.pop_at(ranks.bsearch(key))) 
        return _cache[key]
    else:
        return null

func __set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    # Evic the least recently used item
    if size() >= CAPACITY:
        super.Evict(key)
    _cache[key] = val
    ranks.push_front(key)

func __evict(key: Variant, options: Dictionary = {}) -> bool:
    var evict_key: Variant = ranks.pop_back()
    return super.__evict(key)
