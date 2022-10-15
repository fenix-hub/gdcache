extends AbstractCache
class_name TLRUCache

var max_TTU: float = 60.0 # in secs

func _setup() -> void:
    policy = "Time aware least recently used"

func _Get(key, options: Dictionary = { revive = false }):
    if cache.has(key):
        if options.revive:
            var schedule: Timer = get_node(key)
            schedule.start(schedule.wait_time)
    return cache.get(key, null)

func _Set(key, value, options: Dictionary = { ttu = max_TTU + cache.size() }):
    if cache.size() == CAPACITY:
        _run_next_schedule()
    cache[key] = value
    var schedule: Timer = Timer.new()
    schedule.wait_time = options.ttu
    schedule.timeout.connect(ttu_expired.bind(schedule, key))
    add_child(schedule)
    schedule.name = str(key)
    schedule.start(schedule.wait_time)

func ttu_expired(schedule: Timer, key):
    evict(key)
    schedule.queue_free()

# Sort ascending TTU
func _sort_schedules(a, b):
    return a.wait_time < b.wait_time

# Execute the schedule with the lowest TTU
func _run_next_schedule():
    var schedules: Array = get_children()
    if not schedules.is_empty():
        schedules.sort_custom(_sort_schedules)
        schedules[0].start(0.01)
  
