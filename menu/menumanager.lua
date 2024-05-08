_G.AssaultWaveInChat = AssaultWaveInChat or {}
AssaultWaveInChat.path = ModPath
AssaultWaveInChat.save_path = SavePath .. "assaultwaveinchat.txt"
AssaultWaveInChat.settings = {
    host_msg_choice = 1,
	client_msg_choice = 1,
	lang_choice = 1
	
}

function AssaultWaveInChat:Save()
	local file = io.open(self.save_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function AssaultWaveInChat:Load()
	local file = io.open(self.save_path, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
		self:Save()
	end
end

function AssaultWaveInChat:announce(wave_number)
	managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", managers.localization:text('awic_announce_msg')..string.format("%s", wave_number))
end

function AssaultWaveInChat:receive(wave_number)
	managers.chat:_receive_message(1, managers.localization:text('awic_receive_msg'), string.format("%s", wave_number), Color('ffff00'))
end

function AssaultWaveInChat:advance_announce(sec)
	managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", managers.localization:text('awic_advance_msg_1').. string.format("%.2f", sec) .. managers.localization:text('awic_advance_msg_2'))
end

function AssaultWaveInChat:advance_receive(sec)
	managers.chat:_receive_message(1, managers.localization:text('awic_phase_receive_msg'), managers.localization:text('awic_advance_msg_1').. string.format("%.2f", sec) .. managers.localization:text('awic_advance_msg_2'), Color.red)
end

function AssaultWaveInChat:endless_announce()
	managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", managers.localization:text('awic_endless_msg'))  
end

function AssaultWaveInChat:endless_receive()
	managers.chat:_receive_message(1, managers.localization:text('awic_phase_receive_msg'), managers.localization:text('awic_less_endless_msg'), Color.red)
end

function AssaultWaveInChat:fade_announce()
	managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", managers.localization:text('awic_fade_msg'))  
end

function AssaultWaveInChat:fade_receive()
	managers.chat:_receive_message(1, managers.localization:text('awic_phase_receive_msg'), managers.localization:text('awic_less_fade_msg'), Color('32f7eb'))
end

Hooks:Add("MenuManagerInitialize", "AssaultWaveInChat_MenuManagerInitialize", function(menu_manager)
	MenuCallbackHandler.awic_host_msg_callback = function(self,item)
		local value = tonumber(item:value())
		AssaultWaveInChat.settings.host_msg_choice = value
		AssaultWaveInChat:Save()
	end
	
    MenuCallbackHandler.awic_client_msg_choice_callback = function(self,item)
		local value = tonumber(item:value())
		AssaultWaveInChat.settings.client_msg_choice = value
		AssaultWaveInChat:Save()
	end
	
	MenuCallbackHandler.awic_lang_choice_callback = function(self,item)
		local value = tonumber(item:value())
		AssaultWaveInChat.settings.lang_choice = value
		AssaultWaveInChat:Save()
	end
	
	MenuCallbackHandler.awic_back = function(self)
		AssaultWaveInChat:Save()
	end
	
	AssaultWaveInChat:Load()
	MenuHelper:LoadFromJsonFile(AssaultWaveInChat.path .. "menu/options.txt", AssaultWaveInChat, AssaultWaveInChat.settings)
end)

Hooks:Add("LocalizationManagerPostInit", "AssaultWaveInChat_LocalizationManagerPostInit", function(loc)
	AssaultWaveInChat:Load()
	local t = AssaultWaveInChat.path .. "loc/"
	if AssaultWaveInChat.settings.lang_choice == 1 then
	    for _, filename in pairs(file.GetFiles(t)) do
		    local str = filename:match('^(.*).txt$')
		    if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			    loc:load_localization_file(t .. filename)
			    return
		    end
	    end
	        loc:load_localization_file(t .. "english.txt")
	elseif AssaultWaveInChat.settings.lang_choice == 2 then
		loc:load_localization_file(t .. "english.txt")
	elseif AssaultWaveInChat.settings.lang_choice == 3 then
	        loc:load_localization_file(t .. "schinese.txt")
	end
end)
