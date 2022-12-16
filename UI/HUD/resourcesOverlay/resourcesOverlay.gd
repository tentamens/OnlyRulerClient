extends Control


func _ready():
	$mainHB/food/FoodImage/FoodCost.text = str(Resoucres.Food)
	$mainHB/money/MoneyImage/MoneyCost.text = str(Resoucres.Gold)


func _on_foodTimer_timeout():
	Resoucres.Food += Resoucres.Food_Increase
	$mainHB/food/FoodImage/FoodCost.text = str(Resoucres.Food)


func _on_moneyTimer_timeout():
	Resoucres.Gold += Resoucres.Gold_Increase
	$mainHB/money/MoneyImage/MoneyCost.text = str(Resoucres.Gold)
