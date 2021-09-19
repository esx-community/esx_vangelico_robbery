ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local robberyActive = false
local blipRobbery = nil
local windowsBroken = 0 
local ptfx = "scr_jewelheist"
local anim = 'missheist_jewel'

local soundid = GetSoundId()

local function loadPtFxAsset(name)
	while not HasNamedPtfxAssetLoaded(name) do
		Citizen.Wait(0)
		RequestNamedPtfxAsset(name)
	end
end

local function loadAnimDict(dict) 
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end 

local function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("esx_vangelico_robbery:text")
AddEventHandler("esx_vangelico_robbery:text", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent('esx_vangelico_robbery:alarmsound')
AddEventHandler('esx_vangelico_robbery:alarmsound', function(coords)
	PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", coords.x, coords.y, coords.z)
end)

RegisterNetEvent('esx_vangelico_robbery:stopsound')
AddEventHandler('esx_vangelico_robbery:stopsound', function()
	StopSound(soundid)
end)

RegisterNetEvent('esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('esx_vangelico_robbery:currentlyrobbing', function()
	robberyActive = true
end)

RegisterNetEvent('esx_vangelico_robbery:killblip')
AddEventHandler('esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:setblip')
AddEventHandler('esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery, 161)
    SetBlipScale(blipRobbery, 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:toofarlocal')
AddEventHandler('esx_vangelico_robbery:toofarlocal', function()
	robberyActive = false
	ESX.ShowNotification(Config.Strings["robbery_cancelled"])
end)

RegisterNetEvent('esx_vangelico_robbery:robberycomplete')
AddEventHandler('esx_vangelico_robbery:robberycomplete', function(robb)
	robberyActive = false
	ESX.ShowNotification(Config.Strings["robbery_complete"])
end)

Citizen.CreateThread(function()
	for k, v in pairs(Config.RobberyLocations) do
		local blip = AddBlipForCoord(v.location.x, v.location.y, v.location.z)
		SetBlipSprite(blip, 439)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 5)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Strings["shop_robbery"])
		EndTextCommandSetBlipName(blip)
	end
end)

local function drawTxt(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.64, 0.64)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.155, 0.935)
end

Citizen.CreateThread(function()
	while true do
		local wait = 1000

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k, v in pairs(Config.RobberyLocations) do
			local dist = #(coords - v.location)

			if dist < 10.0 then
				if not robberyActive then
					wait = 5
					DrawMarker(1, v.location.x, v.location.y, v.location.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 255, 255, 255, false, false, 2, false, false, false, false)

					if dist <= 1.0 then
						wait = 0
						DisplayHelpText(Config.Strings["press_to_rob"])
						local shooting = IsPedShooting(ped)
						if shooting then
							ESX.TriggerServerCallback('esx_vangelico_robbery:copsonline', function(cops)
								if cops >= Config.RequiredCopsRob then
									TriggerServerEvent('esx_vangelico_robbery:rob', k)
								else
									TriggerEvent('esx:showNotification', Config.Strings["min_two_police"] .. Config.RequiredCopsRob .. Config.Strings["min_two_police2"])
								end
							end)	
						end
					end		
				end
			end
		end

		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 1000

		if robberyActive then
			wait = 0
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			for k, v in pairs(Config.RobberyLocations) do 
				local location = v.location
				local originalDist = #(coords - location)
				local miniLocations = v.jewelLocations
				for q, t in pairs(miniLocations) do
					local formatted = vector3(t.coords.x, t.coords.y, t.coords.z)
					local dist = #(coords - formatted)

					drawTxt(0.3, 1.4, 0.45, Config.Strings["smash_case"] .. ' :~r~ ' .. windowsBroken .. '/' .. #miniLocations, 185, 185, 185, 255)

					if dist < 10.0 and not t.robbed then 
						DrawMarker(20, formatted.x, formatted.y, formatted.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 0, 255, 0, 200, 1, 1, 0, 0)
					end

					if dist < 0.75 and not t.robbed then 
						DisplayHelpText('Press ~w~[~g~E~w~] ' .. Config.Strings["press_to_collect"])
						local pressed = IsControlJustPressed(0, 38)
						if pressed then
							SetEntityCoords(ped, formatted.x, formatted.y, formatted.z - 1.0)
							SetEntityHeading(ped, t.heading)
							t.robbed = true 
							PlaySoundFromCoord(-1, "Glass_Smash", formatted.x, formatted.y, formatted.z, "", 0, 0, 0)
							loadPtFxAsset(ptfx)
							SetPtfxAssetNextCall(ptfx)
							StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", formatted.x, formatted.y, formatted.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict(anim) 
							TaskPlayAnim(ped, anim, "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
							TriggerEvent("esx_vangelico_robbery:text", Config.Strings["collectinprogress"], 3000)
							DrawSubtitleTimed(5000, 1)
							Citizen.Wait(5000)
							ClearPedTasksImmediately(ped)
							TriggerServerEvent('esx_vangelico_robbery:recievejewels', v)
							PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							windowsBroken = windowsBroken + 1
			
							if windowsBroken == #miniLocations then 
								t.robbed = false
								windowsBroken = 0
								TriggerServerEvent('esx_vangelico_robbery:endrob', k)
								ESX.ShowNotification(Config.Strings["lester"])
								robberyActive = false
							end 
						end 
					end	

					if robberyActive then
						if originalDist > 20.0 then
							TriggerServerEvent('esx_vangelico_robbery:toofar', k)
							robberyActive = false
							t.robbed = false
							windowsBroken = 0
						end
					end
				end
			end
		end

		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	local sellPoint = Config.SellPoint
	local blip = AddBlipForCoord(sellPoint.x, sellPoint.y, sellPoint.z)
	SetBlipSprite(blip, 77)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Lester")
	EndTextCommandSetBlipName(blip)
end)

local selling = false

Citizen.CreateThread(function()
	while true do
		local wait = 1000
		
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		
		local sellPoint = Config.SellPoint
		local dist = #(coords - sellPoint)

		if dist < 10.0 then
			wait = 5
			if not selling then
				DrawMarker(20, sellPoint.x, sellPoint.y, sellPoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
				if dist <= 1.5 then
					wait = 0
					DisplayHelpText(Config.Strings["press_to_sell"])
					local released = IsControlJustReleased(1, 51)
					if released then
						ESX.TriggerServerCallback('esx_vangelico_robbery:getItemAmount', function(quantity)
							if quantity >= Config.MaxJewelsSell then
								ESX.TriggerServerCallback('esx_vangelico_robbery:copsonline', function(CopsConnected)
									if CopsConnected >= Config.RequiredCopsSell then
										selling = true
										FreezeEntityPosition(ped, true)
										TriggerEvent('esx_vangelico_robbery:text', Config.Strings["goldsell"], 10000)
										Citizen.Wait(10000)
										FreezeEntityPosition(ped, false)
										TriggerServerEvent('esx_vangelico_robbery:selljewels')
										selling = false
									else
										TriggerEvent('esx:showNotification', Config.Strings["copsforsell"] .. Config.RequiredCopsSell .. Config.Strings["copsforsell2"])
									end
								end)
							else
								TriggerEvent('esx:showNotification', Config.Strings["notenoughgold"])
							end
						end)
					end
				end
			end
		end

		Citizen.Wait(wait)
	end
end)

