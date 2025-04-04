extends Enemy

func die() -> void:
	BattleSystem.win()
	super()
