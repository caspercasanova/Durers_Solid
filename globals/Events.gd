extends Node


signal random_thing()



## use these where possible? 
func set_delayed(target, propertyName, delay: float, value):
	get_tree().create_timer(delay, false).connect('timeout', target.set.bind(propertyName, value))
	
func call_delayed(callable: Callable, delay: float):
	get_tree().create_timer(delay, false).connect('timeout', callable)
