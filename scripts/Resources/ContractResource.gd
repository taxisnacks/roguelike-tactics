extends Resource
class_name ContractResource

# placeholders, adjust later 

enum ObjectiveType {
	ELIMINATE,
	DEFEND,
	RETRIEVE
}

@export var display_name: String = "Unnamed Contract"
@export var difficulty: int = 1
@export var objective: ObjectiveType = ObjectiveType.ELIMINATE

@export var reward_money: int = 100
