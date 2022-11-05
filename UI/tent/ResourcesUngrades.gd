extends VBoxContainer

export var Food_Cost:int
export var Money_Cost:int

export var Food_Increase:float
export var Money_Increase:float

export var Food_cost_increase:float
export var Money_cost_increase:float


onready var money_cost_node = get_node("money/TextureRect/UpgradeCostMoney")
onready var food_cost_node = get_node("Food/TextureRect/UpgradeCost")

"""		FOOD IS BOUGHT WITH MONEY AND MONEY WITH FOOD		"""

func _on_foodUpgradeButton_button_down():
	if Resoucres.Money > Food_Cost:
		Resoucres.Money -= Food_Cost
		Resoucres.Food_Increase += Food_Increase
		Food_Cost *= Food_cost_increase
		food_cost_node.text = str(Food_Cost)


func _on_MoneyUpgradeButton_button_down():
	if Resoucres.Food > Money_Cost:
		Resoucres.Food -= Money_Cost
		Resoucres.Money_Increase += Money_Increase
		Money_Cost *= Money_cost_increase
		money_cost_node.text = str(Money_Cost)
