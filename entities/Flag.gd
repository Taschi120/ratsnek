extends Mob

class_name Flag

func collide_with_snek_head(level: Level, snek: Snek) -> Array[AutoTriggeredCommand]:
	return [WinCommand.new()]
