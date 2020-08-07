extends Control


func _ready():
	$Main.visible = false
	$NewGame.visible = false
	$Continue.visible = false
	$Settings.visible = false
	$PressAnyButton.start()


func _on_PressAnyButton_finished():
	$PressAnyButton.transition_out()
	$Main.start()


func _on_Main_new_game_button_pressed():
	$Main.transition_out()
	$NewGame.start()


func _on_Main_continue_button_pressed():
	$Main.transition_out()
	$Continue.start()


func _on_Main_settings_button_pressed():
	$Main.transition_out()
	$Settings.start()


func _on_NewGame_no_selected():
	$NewGame.transition_out()
	$Main.transition_in()


func _on_Continue_back_selected():
	$Continue.transition_out()
	$Main.transition_in()


func _on_Settings_back_selected():
	$Settings.transition_out()
	$Main.transition_in()
