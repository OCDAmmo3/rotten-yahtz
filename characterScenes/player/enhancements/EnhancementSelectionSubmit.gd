extends PanelContainer

func submit_chosen():
	get_parent().find_child("EnhancementSelectionOptions").submit_chosen_enhancement()
