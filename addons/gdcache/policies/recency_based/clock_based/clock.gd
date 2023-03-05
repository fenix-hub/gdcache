extends AbstractCache
class_name CLOCKCache

var hand: int = 0

func __setup() -> void:
    policy = "Clock"

func __get(key: Variant, default: Variant = null, options: Dictionary = {}) -> Variant:
    if has(key):
        hand = keys().find(key)
        var kv: Dictionary = super.__get(key, { val = null, r_bit = true })
        kv.r_bit = true
        return kv.val
    else:
        return null

func __set(key: Variant, val: Variant, options: Dictionary = {}) -> void:
    if size() >= CAPACITY:
        while (_cache[hand].r_bit):
            _cache[hand].r_bit = false
            if hand >= size():
                hand = 0
            else:
                hand += 1
                super.Evict(key)
    _cache[key] = { val = val, r_bit = true }
