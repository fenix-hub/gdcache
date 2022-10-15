extends AbstractCache
class_name TLRUCache

var max_TTU: int = 60 # in secs

func _Get(key, revive: bool = false):
    if cache.has(key):
        if revive:
            var schedule: Timer = $Schedules.get_node(key)
            schedule.start(schedule.wait_time)
    return cache.get(key, null)
    

func _Set(key, value, options: Dictionary = { ttu = max_TTU + cache.size() }):
    if cache.size() == CAPACITY:
        _run_next_schedule()
    cache[key] = value
    var schedule: Timer = Timer.new()
    schedule.wait_time = options.ttu
    add_child(schedule)
    schedule.name = str(key)
    schedule.timeout.connect(ttu_expired.bind(schedule, key))
    schedule.start(options.ttu)

func ttu_expired(schedule: Timer, key):
    evict(key)
    schedule.queue_free()

# Sort ascending TTU
func _sort_schedules(a, b):
    return a.wait_time < b.wait_time

# Execute the schedule with the lowest TTU
func _run_next_schedule():
    var schedules: Array[Timer] = $Schedules.get_children()
    schedules.sort_custom(_sort_schedules)
    schedules[0].start(0)
  
