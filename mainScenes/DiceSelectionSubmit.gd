extends PanelContainer

func submit_chosen():
	get_parent().find_child("DiceSelectionOptions").submit_chosen_dice()
