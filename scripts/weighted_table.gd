class_name WeightedTable

var items: Array[Dictionary]
var weight_sum := 0

func add_item(item, weight: int) -> void:
	items.append({ "item": item, "weight": weight })
	weight_sum += weight


func add_items(new_items: Array, weight: int) -> void:
	for item in new_items:
		add_item(item, weight)


func remove_item(item_to_remove) -> void:
	items = items.filter(func(item): return item["item"] != item_to_remove)
	#print("before weight: " + str(weight_sum))
	_update_weight_sum()
	#print("new weight: " + str(weight_sum))

func pick_item(exclude := []):
	var adjusted_items := items
	var adjusted_weight_sum = weight_sum
	
	if (!exclude.is_empty()):
		adjusted_items = adjusted_items.filter(func(item): return not item["item"] in exclude)
		adjusted_weight_sum = adjusted_items.reduce(func(accum: int, item): return accum + item["weight"], 0)
		#print(adjusted_weight_sum)
	
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]
			


func _update_weight_sum() -> void:
	weight_sum = items.reduce(func(accum: int, item): return accum + item["weight"], 0)
