extends Player

func die() -> void:
	BattleSystem.lose()
	super()
