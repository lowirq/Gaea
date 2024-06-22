@tool
class_name ThreadedTilemapGaeaRenderer
extends TilemapGaeaRenderer
## Wrapper for TilemapGaeaRenderer that runs multiple _draw_area calls
##  in parallel using the WorkerThreadPool.
## @experimental

## Whether or not to pass calls through to the default TilemapGaeaRenderer,
##  instead of threading them.
@export var threaded: bool = true
## Decides the maximum number of WorkerThreadPool tasks that can be created
##  before queueing new tasks. A negative value (-1) means there is no limit.
@export_range(-1, 1000, 1, "exp", "or_greater") var task_limit: int = -1

var queued: Array[Callable] = []
var _tasks: PackedInt32Array = []


func _process(_delta):
	for t in range(_tasks.size()-1, -1, -1):
		if WorkerThreadPool.is_task_completed(_tasks[t]):
			WorkerThreadPool.wait_for_task_completion(_tasks[t])
			_tasks.remove_at(t)
	if threaded:
		while task_limit >= 0 and _tasks.size() < task_limit and not queued.is_empty():
			run_task(queued.pop_front())


func _draw_area(area: Rect2i) -> void:
	if not threaded:
		super(area)
	else:
		var _new_task:Callable = func ():
			super._draw_area(area)

		if task_limit >= 0 and _tasks.size() >= task_limit:
			queued.push_back(_new_task)
		else:
			run_task(_new_task)


func run_task(_task:Callable):
	if _task:
		_tasks.append(WorkerThreadPool.add_task(_task, false, "Draw Area"))
