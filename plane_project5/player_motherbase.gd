extends Player

func _ready() -> void:
	super()
	

func die() -> void:
	BattleSystem.lose()
	super()
