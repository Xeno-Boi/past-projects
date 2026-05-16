extends SelectableObject


func activateCondition() -> bool:
	return defs.allShelfItemsCollected() and not defs.taskIsCompleted(defs.TASKS.CHECKOUT)


func deactivateCondition() -> bool:
	return defs.taskIsCompleted(defs.TASKS.CHECKOUT)
