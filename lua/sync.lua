local Net = _G.LuaNetworking
local host_drama = string.format("%.2f", managers.groupai:state()._drama_data.amount) or 1

if Network:is_server() and AssaultWaveInChat.settings.sync_enabled then Net:SendToPeers("drama_sync_test", tostring(host_drama)) end

Hooks:Add("NetworkReceivedData", "NetworkReceivedDataSyncTest", function(sender, id, data)
	local peer = Net:GetPeers()[sender]
	if id == "drama_sync_test" and peer then
	    if not Network:is_server() then managers.groupai:state()._drama_data.amount = data end
	end
end)