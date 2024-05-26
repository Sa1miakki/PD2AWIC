
Hooks:PostHook(HUDManager, "init_finalize", "init_finalize_drama_standalone", function (self)
	if AssaultWaveInChat.settings.drama_enabled then
	dramashow = true
    local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
    if not hud or not hud.panel then
        return
    end
	
	
	if AssaultWaveInChat.settings.db_wh_choice == 1 then
	    self._drama_panel = hud.panel:panel({
        x = hud.panel:w() - 2048 + AssaultWaveInChat.settings.db_x,
        y = hud.panel:h() / 2 - AssaultWaveInChat.settings.db_y + 350, 
        h = AssaultWaveInChat.settings.db_bar_wide or 8,   
        w = AssaultWaveInChat.settings.db_bar_length or 756 
        })
		
		self._drama_panel:rect({
        name = "drama",
        x = 2,
        y = 2,
        h = self._drama_panel:w() - 4, 
        w = 0
        })
		
		if AssaultWaveInChat.settings.text_enabled then
		    local hud_drama_100 = hud.panel:text({
            text = "100",
            font = "fonts/font_large_mf",
            font_size = 18,
            x = self._drama_panel:x() + self._drama_panel:w(),
            y = self._drama_panel:y() - 5,
            color = Color.white,
            alpha = 0.76
            })
            local x, y, w, h = hud_drama_100:text_rect()
            hud_drama_100:set_size(w, h)
		

		    local hud_drama_0 = hud.panel:text({
            text = "0",
            font = "fonts/font_large_mf",
            font_size = 18,
            x = self._drama_panel:x() - 9,
            y = self._drama_panel:y() - 5,
            color = Color.white,
            alpha = 0.76
            })
            local x, y, w, h = hud_drama_0:text_rect()
            hud_drama_0:set_size(w, h)
		

		    local hud_drama_cn25 = hud.panel:text({
            text = "^ \n 25",
            font = "fonts/font_large_mf",
            font_size = 18,
            x = self._drama_panel:x() + self._drama_panel:w()/4,
            y = self._drama_panel:y() + 13,
            color = Color.white,
            alpha = 0.76
            })
            local x, y, w, h = hud_drama_cn25:text_rect()
            hud_drama_cn25:set_size(w, h)
		end
	else
	    self._drama_panel = hud.panel:panel({
        x = hud.panel:w() - 2048 + AssaultWaveInChat.settings.db_x, 
        y = hud.panel:h() / 2 - AssaultWaveInChat.settings.db_y + 350, 
        w = AssaultWaveInChat.settings.db_bar_wide or 8,   
        h = AssaultWaveInChat.settings.db_bar_length or 256 
        }) 

        self._drama_panel:rect({
        name = "drama",
        x = 2,
        y = 2,
        w = self._drama_panel:w() - 4, 
        h = 0
        })		
		 
		if AssaultWaveInChat.settings.text_enabled then
		    local hud_drama_100 = hud.panel:text({
            text = "100",
            font = "fonts/font_large_mf",
            font_size = 18,
            x = self._drama_panel:x() /2,
            y = self._drama_panel:y() - 14,
            color = Color.white,
            alpha = 0.76
            })
            local x, y, w, h = hud_drama_100:text_rect()
            hud_drama_100:set_size(w, h)
            hud_drama_100:set_center_x(self._drama_panel:center_x())
		
		    local hud_drama_0 = hud.panel:text({
            text = "0",
            font = "fonts/font_large_mf",
            font_size = 18,
            x = self._drama_panel:x(),
            y = self._drama_panel:y() + self._drama_panel:h(),
            color = Color.white,
            alpha = 0.76
            })
            local x, y, w, h = hud_drama_0:text_rect()
            hud_drama_0:set_size(w, h)
            hud_drama_0:set_center_x(self._drama_panel:center_x())
		end
	end


    self._drama_panel:rect({
        halign = "grow",
        valign = "grow",
        color = Color.black:with_alpha(0.3)
    })
	else
	    dramashow = false
	end
    
end)

local color_steps = {
    Color.green,
    Color.yellow,
    Color.red
}
Hooks:PostHook(HUDManager, "update", "sh_update_standalone", function (self)
    
    if dramashow then
    local gstate = managers.groupai:state()
    local drama_rect = self._drama_panel:child("drama")

    if gstate._drama_data.amount and self._current_drama ~= gstate._drama_data.amount then

        local a = self._current_drama or 0
        local b = gstate._drama_data.amount
        drama_rect:stop()
        drama_rect:animate(function (o)
            over(math.abs(a - b) * 2, function (t)
                local drama = math.lerp(a, b, t)
                local drama_i = drama <= 0.5 and 1 or 2
				if AssaultWaveInChat.settings.db_wh_choice == 1 then
                    o:set_w(drama * (self._drama_panel:w() - 4))
                    o:set_bottom(self._drama_panel:w() - 2)
				else 
				    o:set_h(drama * (self._drama_panel:h() - 4))
                    o:set_bottom(self._drama_panel:h() - 2)
				end
                o:set_color(math.lerp(color_steps[drama_i], color_steps[drama_i + 1], (drama - 0.5 * (drama_i - 1)) * 2):with_alpha(0.75))
            end)
        end)

        self._current_drama = b
    end
	end
	

end)

