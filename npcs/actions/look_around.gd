extends ActionLeaf


func before_run(actor, blackboard):
	actor.update_debug_text('Todo', 'Action: Looking Around')
	
func tick(actor: Node, blackboard: Blackboard) -> int:
	return RUNNING
