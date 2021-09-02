ESX = nil
itemShopList = {}

TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb, target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if targetXPlayer ~= nil then
		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
	else
		cb(nil)
	end
end)

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler("esx_inventoryhud:tradePlayerItem", function(target, type, itemName, itemCount)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	local steamid = ""
    for _, idents in pairs(GetPlayerIdentifiers(_source)) do
        if string.sub(idents, 1, string.len("steam:")) == "steam:" then
            steamid = idents
        end
	end

	local srcCoords = GetEntityCoords(GetPlayerPed(_source))
	local tgtCoords = GetEntityCoords(GetPlayerPed(target))

	if sourceXPlayer ~= nil and targetXPlayer ~= nil then
		if #(srcCoords - tgtCoords) < 5.0 then 
			if type == "item_standard" then
				local sourceItem = sourceXPlayer.getInventoryItem(itemName)
				local targetItem = targetXPlayer.getInventoryItem(itemName)
				if itemCount > 0 and sourceItem.count >= itemCount then
					if targetXPlayer.canCarryItem(itemName, itemCount) then
						sourceXPlayer.removeInventoryItem(itemName, itemCount)
						targetXPlayer.addInventoryItem(itemName, itemCount)
					end
				end
			elseif type == "item_money" then
				if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
					sourceXPlayer.removeMoney(itemCount)
					targetXPlayer.addMoney(itemCount)
				end
			elseif type == "item_account" then
				if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
					sourceXPlayer.removeAccountMoney(itemName, itemCount)
					targetXPlayer.addAccountMoney(itemName, itemCount)
				end
			elseif type == "item_weapon" then
				if not targetXPlayer.hasWeapon(itemName) then
					sourceXPlayer.removeWeapon(itemName)
					targetXPlayer.addWeapon(itemName, itemCount)
				end
			end
		else
			TriggerEvent("menacerp:discordlog", "Tried to Steal Money/Items", "**Name: **"..GetPlayerName(sourceXPlayer.source).." (ID: "..tonumber(source)..") ("..steamid..")\n**Details: **Player was out of the radius.\n**Resource: **"..GetCurrentResourceName(), "https://discord.com/api/webhooks/867543244639830057/uneBdzCvEcsoYMKg8hxPr8PTBORiXXJWzPtC0-VHZQwYOKtToTbWMpPgFDsSDlvG44YE", 'Exploit')
		end
		if #(srcCoords - tgtCoords) > 100.0 then 
			DropPlayer(_source, "whoever stole that money, ya moms a hoe!")
			TriggerEvent("menacerp:discordlog", "Tried to Steal Money/Items", "**Name: **"..GetPlayerName(sourceXPlayer.source).." (ID: "..tonumber(source)..") ("..steamid..")\n**Details: **Player was out of the radius.\n**Resource: **"..GetCurrentResourceName(), "https://discord.com/api/webhooks/867543244639830057/uneBdzCvEcsoYMKg8hxPr8PTBORiXXJWzPtC0-VHZQwYOKtToTbWMpPgFDsSDlvG44YE", 'Exploit')
		end
	end
end)
