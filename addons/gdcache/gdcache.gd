@tool
extends EditorPlugin


func _enter_tree() -> void:
    # Initialization of the plugin goes here.
    
    # Cache
    add_custom_type("AbstractCache", "Node", AbstractCache, null)
    
    # Monitor
    add_custom_type("CacheMonitor", "Node", CacheMonitor, null)
    pass


func _exit_tree() -> void:
    # Clean-up of the plugin goes here.
    remove_custom_type("AbstractCache")
    remove_custom_type("CacheMonitor")
    pass
