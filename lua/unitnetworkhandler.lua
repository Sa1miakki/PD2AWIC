--client
local orig_sync_start_assault = UnitNetworkHandler.sync_start_assault
function UnitNetworkHandler:sync_start_assault(assault_number)
	orig_sync_start_assault(self, assault_number)
	if AssaultWaveInChat.settings.client_msg_choice == 1 then
		AssaultWaveInChat:receive(assault_number)
	else end
end
