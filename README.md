# GDCache 
`GDCache` is a (POC™) GDScript Caching Algorithms and Replacement Policies addon for Godot Engine.

`GDCache` exposes some ready-to-use Cache classes which can be used as singletons in any Godot Project to handle caching of any type of resource (local variable values, godot engine resources, http responses, database entities).

## 💡 Rationale 
I started developing this library mainly because of educational reasons.  
I wanted to study Caching technologies and replacement policies algorithms, and try to implement them in a very user-friendly language like GDScript.  
The result is a set of scripts which can be both used in production environments with Godot Engine or just for learning purpose.  

This library is not intended to replace or implement a workaround for how Godot Engine already handles [resource caching](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html), but instead this library provides a way to create caches and automatically apply preferred caching policies to projects which can find performance improvements through caching.

For example:
- projects that rely on multiple http requests to fetch resources which are not cached from a server, or anyway to prevent making avoidable http requests through caching http responsess
- projects that rely on multiple requests to SQL/noSQL databases and can prevent fetching multiple times the same resources thorugh caching database queries results

`GDCache` also allows to create an in-memory cache, sort-of GDScript alternative to technologies like [Redis](https://redis.io/) or [Dragonflydb](https://dragonflydb.io/).
Even though *currently* a GDScript standalone instance is far from being optimized just like a python/node webserver (since it is impossible to remove heavy modules/servers like the `physics` one), it offers the basics for furhter improvements and optimizations.

## ✒️ Usage 

### 🛢️ Cache 
All Cache types inherit from the `AbstractCache` class.  
This means that all Cache have some common functionalities, which can be overridden by all the other `<any>Cache` implementations.  
You could even implement your own custom cache replacement policy!  
  
Here's an example using a First In / First Out cache with a capacity of 3
```gdscript
var cache: FIFOCache = FIFOCache.new(3)

func _ready() -> void:
    get_tree().get_root().add_child.call_deferred(cache) # not required
    
    cache.set_key.connect(_on_set) # will be called on `Get()`
    cache.get_key.connect(_on_get) # will be called on `Set()`
    
    cache.Set("res1", "val1")
    cache.Set("res2", "val2")
    cache.Set("res3", "val3")
    
    var r1 = cache.Get("res1") # res1
    var r2 = cache.Get("res3") # res2
    var r4 = cache.Get("res4") # null
    
    cache.Set("res4", "val4") # capacity is 3, so the FIFO policy will be used
    
    r1 = cache.Get("res1") # null
    r4 = cache.Get("res4") # res4

    print(cache)
    # will print `{ "res2": "val2", "res3": "val3", "res4": "val4" }`
```

Even though `AbstractCache` inherits from `Node`, it is **not mandatory** to add a `Cache` node to the NodeTree, unless:
(1) The `Cache` node uses time-based algorithms (such as `TLRUCache`) which require to instance some `Timer`s as sub-children
(2) You want to make one or multiple caches as `Singleton`s in order to access them globally from your scripts


### 🔎 Cache Monitors 
A `CacheMonitor` will let you "monitor" your cache properties and usage at runtime, without interferring with the cache itself.
```gdscript
var rrcache: RRCache = RRCache.new(3)
var monitor: CacheMonitor = CacheMonitor.new(rrcache)

func _ready() -> void:
    rrcache.Set("res1", "val1")
    rrcache.Get("res1")

    rrcache.Set("res2", "val2")
    rrcache.Get("res2")

    rrcache.Set("res3", "val3")
    rrcache.Get("res3")

    rrcache.Set("res4", "val4") # will Evict a random key
    rrcache.Get("res4")
    rrcache.Get("res1")

    print(monitor)
```
`print(monitor)` will print something like
```
Cache: cache_1449834701
Policy: Random Replacement
Total Keys: 3/3
Set Keys: 4
Get Keys: 5 (166.67% ratio)
Hit Keys: 5 (100.00% ratio)
Missed Keys: 0 (0.00% ratio)
Evicted Keys: 1 (20.00% ratio)
```

## 📜 Supported Policies 

Currently supported policies:

- *Random Based*
  - - [x] Random Replacement (`RRCache`)
- *Queue Based*
  - - [x] First in / First Out (`FIFOCache`)
  - - [x] Last in / First Out (`LIFOCache`)
- *Recency Based*
  - - [x] Least Recently Used (`LRUCache`)
  - - [x] Most Recently Used (`MRUCache`)
  - - [x] Time aware Least Recently Used (`TLRUCache`)
  - - [x] Segmented LRU (`SLRUCache`)
  - *LRU Approximations*
    - - [ ] Pseudo-LRU (`PLRUCache`)
    - - [x] CLOCK (`CLOCKCache`)
    - - [ ] CLOCK-Pro (`CLOCKProCache`)
- *Simple frequency-based policies*
  - - [ ] Least-frequently used (`LFUCache`)
  - - [ ] Least frequent recently used (`LFRUCache`)
  - - [ ] LFU with dynamic aging (`LFUDACache`)
- *RRIP-style policies*
  - - [ ] Re-Reference Interval Prediction (`RRIPCache`)
  - - [ ] Static RRIP (`SRRIPCache`)
  - - [ ] Bimodal RRIP (`BRRIPCache`)
  - - [ ] Dynamic RRIP (`DRRIPCache`)
- *Other cache replacement policies*
  - - [ ] Low inter-reference recency set (`LIRSCache`)
  - - [ ] Adaptive replacement cache (`ARCCache`)
  - - [ ] AdaptiveClimb (`ACCache`)
  - - [ ] Clock with adaptive replacement (`CARCache`)
  - - [ ] Multi queue (`MQCache`)
