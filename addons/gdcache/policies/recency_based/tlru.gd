extends AbstractCache
class_name TLRUCache

var max_TTU: float = 60.0 # in secs

func __setup() -> void:
    policy = "Time aware Least Recently Used"

func __get(key: Variant, default: Variant = null, options: Dictionary = { revive = false }) -> Variant:
    if _cache.has(key):
        if options.revive:
            var schedule: Timer = get_node(key)
            schedule.start(schedule.wait_time)
        return _cache[key]
    else:
        return null

func __set(key: Variant, value: Variant, options: Dictionary = { ttu = max_TTU + size() }) -> void:
    if size() >= CAPACITY:
        _run_next_schedule()
    _cache[key] = value
    var schedule: Timer = Timer.new()
    schedule.wait_time = options.ttu
    schedule.timeout.connect(
        func ttu_expired() -> void:
            super.Evict(key)
            schedule.queue_free()
    )
    add_child(schedule)
    schedule.name = str(key)
    schedule.start(schedule.wait_time)

# Execute the schedule with the lowest TTU
func _run_next_schedule() -> void:
    var schedules: Array = get_children()
    if not schedules.is_empty():
        schedules.sort_custom(
            # Sort ascending TTU
            func _sort_schedules(a: Timer, b: Timer) -> float:
                return a.wait_time < b.wait_time
        )
        schedules[0].start(0.01)
