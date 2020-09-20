extends Node2D

export (PoolStringArray) var event_name
export (PoolStringArray) var event_from
export (PoolIntArray) var event_chance
export (PoolStringArray) var event_output #decision, gain, chance
export (PoolIntArray) var health_output
export (PoolIntArray) var happiness_output
export (PoolIntArray) var work_output
export (PoolStringArray) var event_desc

func get_chance(from):
	var chance_pool : PoolIntArray = []
	for i in range(event_name.size()):
		if from == event_from[i]:
			if event_chance[i] == 102:
				chance_pool[0] = -2
				return chance_pool
			for n in range(event_chance[i]):
				chance_pool.append(i)
	if chance_pool.size() < 100:
		for i in range(100 - chance_pool.size()):
			chance_pool.append(-1)
	return chance_pool

func get_event_output(index):
	return event_output[index]
	
func get_event_name(index):
	return event_name[index]

func get_event_gain(index):
	var gain : PoolIntArray = [health_output[index], happiness_output[index], work_output[index]]
	return gain

func get_event_desc(index):
	return event_desc[index]
