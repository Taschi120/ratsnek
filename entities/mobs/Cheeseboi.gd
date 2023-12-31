extends Mob

class_name Cheeseboi

func collide_with_snek_head(level: Level, snek: Snek) -> Array[AutoTriggeredCommand]:
	return [EatCommand.new(self)]
	
func take_turn(level: Level, snek: Snek) -> Array[AutoTriggeredCommand]:
	if movement:
		return [MobMoveCommand.new(self)]
	else:
		return []
