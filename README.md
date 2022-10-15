# GDCache 
`GDCache` is (POC ™) a GDScript Caching Algorithms and Replacement Policies addon for Godot Engine.

`GDCache` exposes some ready-to-use Cache classes which can be used as singletons in any Godot Project to handle caching of any type of resource (local variable values, godot engine resources, http responses, database entities).

This library is not intended to replace or implement a workaround for how Godot Engine already handles [resource caching](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html), but instead this library provides a way to create caches and apply automatically preferred caching policies to projects which can find performance improvements through caching.

For example:
- projects that rely on multiple http requests to fetch resources which are not cached from a server, or anyway to prevent making avoidable http requests through caching http responsess
- projects that rely on multiple requests to SQL/noSQL databases and can prevent fetching multiple times the same resources thorugh caching database queries

GDCache also allows to create an in-memory cache, sort of a GDScript alternative to technologies like [Redis](https://redis.io/) or [Dragonflydb](https://dragonflydb.io/).
Even though *currently* a GDScript standalone instance is far from being optimized just like a python/node in-memory cache (since it is impossible to remove heavy modules/servers like the `physics` one), it offers the basics for furhter improvements and optimizations.

## Usage
All Cache types inherit from the `AbstractCache` class.  
This means that all Cache have some common functionalities, which can be overridden by all the other `<any>Cache` implementations.  
You could even implement your own custom cache replacement policy!  
  
Here's an example using a First In / First Out cache with a capacity of 3
```gdscript
var Cache: FIFOCache = FIFOCache.new(3)

func _ready() -> void:
    get_tree().get_root().add_child.call_deferred(Cache) # not required
    
    Cache.set_key.connect(_on_set) # will be called on `Get()`
    Cache.get_key.connect(_on_get) # will be called on `Set()`
    
    Cache.Set("res1", "val1")
    Cache.Set("res2", "val2")
    Cache.Set("res3", "val3")
    
    var r1 = Cache.Get("res1") # res1
    var r2 = Cache.Get("res3") # res2
    var r4 = Cache.Get("res4") # null
    
    Cache.Set("res4", "val4") # capacity is 3, so the FIFO policy will be used
    
    r1 = Cache.get("res1") # null
    r4 = Cache.Get("res4") # res4

    print(Cache)
    # will print `{ "res2": "val2", "res3": "val3", "res4": "val4" }`
```

Even if `AbstractCache` inherits from `Node`, it is **not mandatory** to add a `Cache` node to the NodeTree, unless:
- (1) The `Cache` node uses time-based algorithms (such as `TLRUCache`) which require to instance some `Timer`s as sub-children
- (2) You want to make one or multiple caches as `Singleton`s in order to access them globally from your scripts


## Supported Policies

Currently supported policies:
- Queue Based
- - [x] First in / First Out (FIFOCache)
- - [x] Last in / First Out (LIFOCache)
- Recency Based
- - [x] Least Recently Used (LRUCache)
- - [x] Most Recently Used (MRUCache)
- - [x] Time aware Least Recently Used (TLRUCache)
- - [ ] Segmented LRU (SLRUCache)
- LRU Approximations
- - [ ] Pseudo-LRU (PLRUCache)
- - [ ] CLOCK-Pro (CLOCKProCache)
- Simple frequency-based policies
- - [ ] Least-frequently used (LFUCache)
- - [ ] Least frequent recently used (LFRUCache)
- - [ ] LFU with dynamic aging (LFUDACache)

