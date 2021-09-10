ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local currentlyRobbing = {}
local activeRobbery = false

local function getPolice()
	local police = {}
	local players = GetPlayers()
	for k, v in pairs(players) do
		local id = tonumber(v)
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer ~= nil and xPlayer.job ~= nil then
			if xPlayer.job.name == 'police' then
				table.insert(police, id)
			end
		end
	end
	return police
end

ESX.RegisterServerCallback('esx_vangelico_robbery:copsonline', function(source, cb)
	cb(#getPolice())
end)


-- Credits to discord docs for the api ref
function SendToDiscord(name, msg, col)
	local embed = {
		{
			["color"] = 9109247, -- If you have an issue with the string like this change it to "9109247"
			["title"] = "**"..name.."**",
			["description"] = msg,
			["footer"] = {
				["text"] = "discord.gg/Example"
			},
		}
	}
	PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Exploit Log", embeds = embed, avatar_url = "https://cdn.discordapp.com/attachments/885198956957663271/885632331543633920/New_Project_1background.png"}), {['Content-Type'] = 'application/json'})
end
-- (Example of discord log)	SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** 'esx_vangelico_robbery:recievejewels'\n**Resource:** "..GetCurrentResourceName())



RegisterServerEvent('esx_vangelico_robbery:toofar')
AddEventHandler('esx_vangelico_robbery:toofar', function(robb)
	local src = source
	if activeRobbery and currentlyRobbing[src] then
		activeRobbery = false
		currentlyRobbing[src] = nil
		for k, v in pairs(getPolice()) do
			TriggerClientEvent('esx:showNotification', v, Config.Strings["robbery_cancelled_at"] .. Config.RobberyLocations[robb].label)
			TriggerClientEvent('esx_vangelico_robbery:killblip', v)
		end
		TriggerClientEvent('esx_vangelico_robbery:toofarlocal', src)
		if Config.AlarmSound then
			TriggerClientEvent("esx_vangelico_robbery:stopsound", -1)
		end
		TriggerClientEvent('esx:showNotification', src, Config.Strings["robbery_has_cancelled"] .. Config.RobberyLocations[robb].label)
	end
end)

RegisterServerEvent('esx_vangelico_robbery:endrob')
AddEventHandler('esx_vangelico_robbery:endrob', function(robb)
	local src = source
	if activeRobbery and currentlyRobbing[src] then
		activeRobbery = false
		currentlyRobbing[src] = nil
		for k, v in pairs(getPolice()) do
			TriggerClientEvent('esx:showNotification', v, Config.Strings["end"])
			TriggerClientEvent('esx_vangelico_robbery:killblip', v)
		end
		TriggerClientEvent('esx_vangelico_robbery:robberycomplete', src)
		if Config.AlarmSound then
			TriggerClientEvent("esx_vangelico_robbery:stopsound", -1)
		end
		TriggerClientEvent('esx:showNotification', src, Config.Strings["robbery_has_ended"] .. Config.RobberyLocations[robb].label)
	end
end)

RegisterServerEvent('esx_vangelico_robbery:rob')
AddEventHandler('esx_vangelico_robbery:rob', function(loc)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then
		if Config.RobberyLocations[loc] then
			local store = Config.RobberyLocations[loc]
			local storeCoords = store.location

			local ped = GetPlayerPed(src)
			local coords = GetEntityCoords(ped)

			local dist = #(coords - storeCoords)

			if dist < 5.0 then
				if (os.time() - store.lastrobbed) < Config.RobberyCooldownTimer and store.lastrobbed ~= 0 then
					TriggerClientEvent('esx:showNotification', src, Config.Strings["already_robbed"] .. (Config.RobberyCooldownTimer - (os.time() - store.lastrobbed)) .. Config.Strings["seconds"])
					return
				end

				if not activeRobbery then
					activeRobbery = true
					currentlyRobbing[src] = true

					for k, v in pairs(getPolice()) do
						TriggerClientEvent('esx:showNotification', v, Config.Strings["rob_in_prog"] .. store.label)
						TriggerClientEvent('esx_vangelico_robbery:setblip', v, coords)
					end

					TriggerClientEvent('esx:showNotification', src, Config.Strings["started_to_rob"] .. store.label .. Config.Strings["do_not_move"])
					TriggerClientEvent('esx:showNotification', src, Config.Strings["alarm_triggered"])
					TriggerClientEvent('esx:showNotification', src, Config.Strings["hold_pos"])
					TriggerClientEvent('esx_vangelico_robbery:currentlyrobbing', src)
					if Config.AlarmSound then
						TriggerClientEvent('esx_vangelico_robbery:alarmsound', -1, coords)
					end
					store.lastrobbed = os.time()
				else
					TriggerClientEvent('esx:showNotification', src, Config.Strings["robbery_already"])
				end
			end
		end
	end
end)

RegisterServerEvent('esx_vangelico_robbery:recievejewels')
AddEventHandler('esx_vangelico_robbery:recievejewels', function(location)
	local src = source
	local srcName = GetPlayerName(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then
		if activeRobbery then
			if currentlyRobbing[src] then
				xPlayer.addInventoryItem(Config.ItemName, math.random(Config.MinJewels, Config.MaxJewels))
			else
				if Config.KickPossibleCheaters == true then
					DropPlayer(src, "Is attempting to exploit the event: esx_vangelico_robbery:recievejewels")
					SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** 'esx_vangelico_robbery:recievejewels'\n**Resource:** "..GetCurrentResourceName())
					print("^1esx_vangelico_robbery^0: ^4"..srcName.." (ID: "..tonumber(src)..")^0 is attempting to exploit the event: ^4esx_vangelico_robbery:recievejewels. This player is attempting to collect jewels but a jewelry robbery is not currently active at any location!")			end
		end
		else
			DropPlayer(src, "Is attempting to exploit the event: esx_vangelico_robbery:recievejewels")
			SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** 'esx_vangelico_robbery:recievejewels'\n**Resource:** "..GetCurrentResourceName())
			print("^1esx_vangelico_robbery^0: ^4"..srcName.." (ID: "..tonumber(src)..")^0 is attempting to exploit the event: ^4esx_vangelico_robbery:recievejewels. This player is attempting to collect jewels but a jewelry robbery is not currently active at any location!")
		end
	end
end)

RegisterServerEvent('esx_vangelico_robbery:selljewels')
AddEventHandler('esx_vangelico_robbery:selljewels', function()
	local src = source
	local srcName = GetPlayerName(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then
		local itemCount = xPlayer.getInventoryItem(Config.ItemName).count
		if itemCount >= Config.MinJewels then
			local ped = GetPlayerPed(src)
			local coords = GetEntityCoords(ped)
			local dist = #(coords - Config.SellPoint)
			if dist < 5.0 then
				local reward = math.floor(Config.PriceForOneJewel * Config.MaxJewelsSell)
				xPlayer.removeInventoryItem(Config.ItemName, Config.MaxJewelsSell)
				xPlayer.addMoney(reward)
			else
				print("^1esx_vangelico_robbery^0: ^4"..srcName.." (ID: "..tonumber(src)..")^0 is attempting to exploit the event: ^4esx_vangelico_robbery:selljewels. This player is attempting to sell jewels but their distance from the sell location is: ^4"..a..".")
			end
		else
			DropPlayer(src, "Is attempting to exploit the event: esx_vangelico_robbery:selljewels")
			SendToDiscord("Cheater Kicked", "**"..GetPlayerName(source).."** (ID: "..source..") has been Kicked for exploiting.\n**EventName:** '^4esx_vangelico_robbery:selljewels'\n**Resource:** "..GetCurrentResourceName())
			print("^1esx_vangelico_robbery^0: ^4"..srcName.." (ID: "..tonumber(src)..")^0 is attempting to exploit the event: ^4esx_vangelico_robbery:selljewels. This player is attempting to sell jewels but does not have the minimum required amount of jewels to be able to sell.")
		end
	end
end)

AddEventHandler('playerDropped', function(reason)
	local src = source
	currentlyRobbing[src] = nil
end)

ESX.RegisterServerCallback('esx_vangelico_robbery:getItemAmount', function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local quantity = xPlayer.getInventoryItem(Config.ItemName).count
	cb(quantity)
end)