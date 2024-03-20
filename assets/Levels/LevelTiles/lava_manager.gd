class_name LavaManager extends Node2D

var tiles: Array[LavaTile]
static var instance
@export var damage: Damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if instance:
		queue_free()
		return
	instance = self

func add_tile_to_array(tile: LavaTile) -> void:
	tiles.append(tile)


func _on_timer_timeout() -> void:
	for tile in tiles:
		#print("tile ", tile, " dealt damage")
		tile.deal_damage(damage)
