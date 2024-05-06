--host
local orig_start_assault = HUDManager.start_assault
function HUDManager:start_assault(assault_number)
	orig_start_assault(self, assault_number)
	if AssaultWaveInChat.settings.host_msg_choice == 1 then
		AssaultWaveInChat:announce(assault_number)
	elseif AssaultWaveInChat.settings.host_msg_choice == 2 then
	    AssaultWaveInChat:receive(assault_number)
	else end
end
