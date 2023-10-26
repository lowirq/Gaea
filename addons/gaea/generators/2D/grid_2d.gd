class_name GaeaGrid2D
extends GaeaGrid


const SURROUNDING := [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN,
						Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, -1), Vector2i(-1, 1)]


## Returns a [Rect2i] of the full extent of the grid.
func get_area() -> Rect2i:
	var cells = self.get_cells()
	if cells.is_empty():
		return Rect2i()

	var rect: Rect2i = Rect2i(cells.front(), Vector2i.ZERO)
	for cell in cells:
		rect = rect.expand(cell)
	return rect


### Helper Functions ###

## Returns [code]true[/code] if the grid has a cell at [param pos].
func has_cell(pos: Vector2i) -> bool:
	return _grid.has(pos)


## Returns the amount of non-existing and null cells (including corners) around [param pos].
func get_amount_of_empty_neighbors(pos: Vector2i) -> int:
	var count: int = 0

	for n in SURROUNDING:
		if get_value(pos + n) == null:
			count += 1

	return count


## Returns an array with the positions of all cells surrounding [param pos], including corners.[br]
## If [param ignore_empty] is [code]true[/code], all non-existing cells will not be counted. Cells of value [code]null[/code] will still be counted.
func get_surrounding_cells(pos: Vector2i, ignore_empty: bool = false) -> Array[Vector2i]:
	var surrounding: Array[Vector2i]

	for n in SURROUNDING:
		if ignore_empty and not has_cell(pos + n):
			continue
		surrounding.append(pos + n)

	return surrounding
