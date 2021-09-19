Config = {}

Config.RequiredCopsRob = 5 
Config.RequiredCopsSell = 3 
Config.MinJewels = 5 
Config.MaxJewels = 20
Config.RobberyCooldownTimer = 1800 --30 minutes
Config.MaxJewelsSell = 20
Config.PriceForOneJewel = 500

Config.AlarmSound = true

Config.ItemName = 'jewels'

Config.SellPoint = vector3(706.669, -966.898, 30.413)

Config.KickPossibleCheaters = true -- If true it will kick the player that tries to use triggers.

Config.WebhookURL = "" -- Make a webhook and this will log da cheaters

Config.RobberyLocations = {
	["vangelico"] = {
		location = vector3(-629.99, -236.542, 38.05),      
		label = "Vangelico Jewelry",
		lastrobbed = 0,
		jewelLocations = {
			{coords = vector3(-626.735, -238.545, 38.057), heading = 214.907, robbed = false},
			{coords = vector3(-625.697, -237.877, 38.057), heading = 217.311, robbed = false},
			{coords = vector3(-626.825, -235.347, 38.057), heading = 33.745, robbed = false},
			{coords = vector3(-625.77, -234.563, 38.057), heading = 33.572, robbed = false},
			{coords = vector3(-627.957, -233.918, 38.057), heading = 215.214, robbed = false},
			{coords = vector3(-626.971, -233.134, 38.057), heading = 215.532, robbed = false},
			{coords = vector3(-624.433, -231.161, 38.057), heading = 305.159, robbed = false},
			{coords = vector3(-623.045, -232.969, 38.057), heading = 303.496, robbed = false},
			{coords = vector3(-620.265, -234.502, 38.057), heading = 217.504, robbed = false},
			{coords = vector3(-619.225, -233.677, 38.057), heading = 213.35, robbed = false},
			{coords = vector3(-620.025, -233.354, 38.057), heading = 34.18, robbed = false},
			{coords = vector3(-617.487, -230.605, 38.057), heading = 309.177, robbed = false},
			{coords = vector3(-618.304, -229.481, 38.057), heading = 304.243, robbed = false},
			{coords = vector3(-619.741, -230.32, 38.057), heading = 124.283, robbed = false},
			{coords = vector3(-619.686, -227.753, 38.057), heading = 305.245, robbed = false},
			{coords = vector3(-620.481, -226.59, 38.057), heading = 304.677, robbed = false},
			{coords = vector3(-621.098, -228.495, 38.057), heading = 127.046, robbed = false},
			{coords = vector3(-623.855, -227.051, 38.057), heading = 38.605, robbed = false},
			{coords = vector3(-624.977, -227.884, 38.057), heading = 48.847, robbed = false},
			{coords = vector3(-624.056, -228.228, 38.057), heading = 216.443, robbed = false},
		}
	}
}

Config.Strings = {
	["robbery_cancelled"] = "The robbery has been cancelled!",
	["shop_robbery"] = "Robbery in Jewelry",
	["press_to_rob"] = "Shoot to start the robbery",
	["seconds_remaining"] = "~w~ seconds remaining",
	["robbery_cancelled_at"] = "~r~ robbery has been cancelled at: ~b~",
	["robbery_has_cancelled"] = "~r~ the robbery has been cancelled: ~b~",
	["already_robbed"] = "the jewelry has already been robbed. Wait: ",
	["seconds"] = "seconds.",
	["rob_in_prog"] = "~r~ robbery in progress at: ~b~",
	["started_to_rob"] = "You started the robbery ",
	["do_not_move"] = ", take the jewels from the windows!",
	["alarm_triggered"] = "the alarm has been triggered",
	["hold_pos"] = "when you\'ve collected all the jewels, run away!",
	["robbery_complete"] = "~r~ The robbery has been successful!~s~ ~h~ Run away! ",
	["robbery_complete_at"] = "~r~ The robbery has been successful at: ~b~",
	["min_two_police"] = "there must be at least ~b~",
	["min_two_police2"] = " ~w~cops in town to rob.",
	["robbery_already"] = "~r~A robbery is already in progress.",
	["robbery_has_ended"] = "Robbery finished",
	["end"] = "The jewelry has been robbed!",
	["notenoughgold"] = "~r~You do not have enough jewels!",
	["copsforsell"] = "there must be at least ~b~",
	["copsforsell2"] = " ~w~cops in town to sell.",
	["goldsell"] = "~y~Jewels~s~ sale in progress",
	["field"] = "Press ~y~E~s~ to ~o~collect~s~ the jewels",
	["collectinprogress"] = "Jewelery collection in progress...",
	["lester"] = "~g~You have robbed jewelry! Now bring jewels to ~r~Lester!",
	["jewelsblipmap"] = "Jewels",
	["press_to_collect"] = "to collect jewels",
	["smash_case"] = "broken windows",
	["press_to_sell"] = "Press ~INPUT_PICKUP~ to sell jewels",
	["need_bag"] = "You need the bag! Go to the nearest clotheshop.",
}
