extends Node


func getSceneRoot() -> Node:
	return get_tree().root.get_child(-1)


func objectHasTheseKeys(object: Dictionary, keys: Array) -> bool:
	for requiredKey in keys:
		if not requiredKey in object:
			print('Object is missing required Key "%s" ' % requiredKey, object)
			return false
			break

	return true

func connectEventIfItExists(node: Node, event: String, callable: Callable):
	if node.has_signal(event):
		node.connect(event, callable)



