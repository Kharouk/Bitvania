extends "res://World/Levels/Level.gd"

const PLAYER_BIT = 0

onready var bitaloid = $Bitaloid
onready var blockDoor = $BlockDoor

func set_block_door(active):
  blockDoor.visible = active
  blockDoor.set_collision_mask_bit(PLAYER_BIT, active)
  

func _on_Trigger_area_triggered():
  if not SaverAndLoader.custom_data.boss_defeated:
	  set_block_door(true)
  
func _on_Bitaloid_died():
  set_block_door(false)
