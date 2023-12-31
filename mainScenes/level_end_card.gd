extends Panel

@onready var player_node = get_node("/root/BattleRollScene/Observable/Player/")
@onready var player_enhancements = player_node.get_enhancements()

func set_score_values(_upper_total, _lower_total, _grand_total):
	await _count_score_up(_upper_total, $EndLevelScore/UpperTotalScore/Score)
	await _count_score_up(_lower_total, $EndLevelScore/LowerTotalScore/Score)
	await _count_score_up(_grand_total, $EndLevelScore/GrandTotalScore/Score)
	await _count_score_up(_grand_total, $EndLevelScore/MoneyHoarded/Score, player_node.get_money_hoarded())
	player_node.add_money(_grand_total)
	await get_tree().create_timer(1.0).timeout
	$EndLevelScore.visible = false
	var thisIsVar = player_enhancements.end_card.filter(func(enhancement): return enhancement.name == "Better Odds")
	if thisIsVar.size() > 0:
		$DiceSelectionWindow/DiceSelectionOptions.set_better_odds()
	$DiceSelectionWindow.visible = true
	$DiceSelectionWindow/DiceSelectionOptions.create_dice_selectables()

func _count_score_up(score, score_node, score_to_set = 0):
	for n in score:
		score_to_set += 1
		score_node.text = str(score_to_set)
		await get_tree().create_timer(0.01).timeout

func on_selection_made():
	if $DiceSelectionWindow.visible:
		$DiceSelectionWindow.visible = false
		if player_enhancements.end_card.filter(func(enhancement): return enhancement.name == "Better Odds").size() > 0:
			$EnhancementSelectionWindow/EnhancementSelectionOptions.set_better_odds()
		$EnhancementSelectionWindow.visible = true
		$EnhancementSelectionWindow/EnhancementSelectionOptions.create_enhancement_selectables()
	else:
		get_node("/root/BattleRollScene/Observable/Player/").close_level_end_card()
