extends Node

var world
var spawn
var lemming_prefab = load("res://lemming.tscn")

var lemmings = []

var timer = 0
var spawn_time = 100
var max_lemmings = 255
	
func set_world(var node):
	world = node
	print("World set to %s" % node.get_name())
	
func set_spawn(var node):
	spawn = node
	print("Spawn set to %s" % node.get_name())
	
func _ready():
	timer = OS.get_ticks_msec()
	
func _process(delta):
	if world != null and timer + spawn_time < OS.get_ticks_msec():
		spawn_lemming()
		timer = OS.get_ticks_msec()
	for lemming in lemmings:
		lemming.process_lemming()
	
	
func spawn_lemming():
	if lemmings.size() >= max_lemmings:
		return
	var lemming = lemming_prefab.instance()
	world.add_child(lemming)
	lemmings.push_back(lemming)
	lemming.position = Vector2(64, 0)
