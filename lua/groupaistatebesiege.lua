local msg = false
local fade = false
local awic_time_1 = true
local awic_time_2 = true
local orig_upd_assault_task = GroupAIStateBesiege._upd_assault_task
function GroupAIStateBesiege:_upd_assault_task()

	orig_upd_assault_task(self)
	local task_data = self._task_data.assault
 
	if not task_data.active then
		return
	end
	
	if task_data.phase == "anticipation" or task_data.phase == "build" then
	    if awic_time_1 then
		    awic_time_1 = false
			awic1 = managers.game_play_central:get_heist_timer()
		end
		msg = false
		fade = false
		if (task_data.phase_end_t < self._t or self._drama_data.zone == "high") then
		    if awic_time_2 then
		        awic_time_2 = false
	            awic2 = managers.game_play_central:get_heist_timer()
				if _G.awic1 and _G.awic2 then
				    awic3 = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, self._task_data.assault.is_first) - _G.awic2 + _G.awic1
				end
		    end
		    if AssaultWaveInChat.settings.host_msg_choice == 1 then
			    if _G.awic3 then
			        AssaultWaveInChat:advance_announce(_G.awic3)
				end
			elseif AssaultWaveInChat.settings.host_msg_choice == 2 then
			    if _G.awic3 then
			        AssaultWaveInChat:advance_receive(_G.awic3)
				end
			else end
		end
	elseif not msg and self._hunt_mode then
		msg = true
		awic_time_1 = true
		awic_time_2 = true
		if AssaultWaveInChat.settings.host_msg_choice == 1 then
			AssaultWaveInChat:endless_announce()
		elseif AssaultWaveInChat.settings.host_msg_choice == 2 then
			AssaultWaveInChat:endless_receive()
		else end
	elseif not fade and task_data.phase == "fade" then
		fade = true
		awic_time_1 = true
		awic_time_2 = true
		if AssaultWaveInChat.settings.host_msg_choice == 1 then
			AssaultWaveInChat:fade_announce()
		elseif AssaultWaveInChat.settings.host_msg_choice == 2 then
			AssaultWaveInChat:fade_receive()
		else end
	end
end