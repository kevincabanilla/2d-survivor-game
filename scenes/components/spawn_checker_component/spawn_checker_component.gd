class_name SpawnCheckerComponent extends Node2D

@export var shape: Shape2D

@onready var spawn_checker_area: Area2D = $SpawnCheckerArea
@onready var collision_shape_2d: CollisionShape2D = $SpawnCheckerArea/CollisionShape2D


func _ready() -> void:
	collision_shape_2d.shape = shape

func find_free_position_radial(center: Vector2, radius_step: float = 15, angle_steps: int = 8, max_radius_steps: int = 15) -> Vector2:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.collide_with_bodies = true
	query.collide_with_areas = true
	query.collision_mask = 1 << 5

	# Check center first
	query.transform = Transform2D(0, center)
	if space_state.intersect_shape(query).is_empty():
		return center

	# Expand outward in rings
	for r in range(1, max_radius_steps + 1):
		var radius = r * radius_step
		
		for i in range(angle_steps):
			var angle = (TAU / angle_steps) * i
			var offset = Vector2(cos(angle), sin(angle)) * radius
			var pos = center + offset
			
			query.transform = Transform2D(0, pos)
			
			var result = space_state.intersect_shape(query)
			if result.is_empty():
				return pos

	return center # fallback

func find_free_position_radial_in_area_2d(center: Vector2, radius_step: float = 32, max_tries: int = 20) -> Vector2:
	for i in range(max_tries):
		var angle = randf() * TAU
		var radius = radius_step * i
		
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		
		spawn_checker_area.global_position = pos
		
		await get_tree().process_frame
		
		if !spawn_checker_area.has_overlapping_areas() && !spawn_checker_area.has_overlapping_bodies():
			return pos

	return center


func can_spawn(position: Vector2, radius: float) -> bool:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsShapeQueryParameters2D.new()
	
	query.shape = shape
	query.transform = Transform2D(0, position)
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_shape(query)
	
	return result.is_empty()


func can_spawn_at(position: Vector2, size: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var rect_shape = RectangleShape2D.new()
	rect_shape.size = size * 0.5  # half size!

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = rect_shape
	query.transform = Transform2D(0, position + (size * 0.5))
	query.collide_with_bodies = true
	query.collide_with_areas = true
	query.collision_mask = 1 << 5

	var result = space_state.intersect_shape(query, 1)

	return result.is_empty()


func spawn_grid(origin: Vector2, grid_size: Vector2i, cell_size: Vector2):
	for y in grid_size.y:
		for x in grid_size.x:

			var pos := origin + Vector2(
				x * cell_size.x,
				y * cell_size.y
			)			
			
			if can_spawn_at(pos, cell_size):
				return pos

	return origin


func spawn_grid_centered(center: Vector2, grid_size: Vector2i, cell_size: Vector2):
	var half_size = Vector2(
		(grid_size.x - 1) * cell_size.x,
		(grid_size.y - 1) * cell_size.y
	) * 0.5

	for x in grid_size.x:
		for y in grid_size.y:
			var offset = Vector2(
				x * cell_size.x,
				y * cell_size.y
			) - half_size

			var pos = center + offset

			if can_spawn_at(pos, cell_size):
				return pos
	return center
