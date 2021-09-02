itemInformation = {}

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(data)
        for i=1, #data, 1 do

            if itemInformation[data[i].name] == nil then
                itemInformation[data[i].name] = {}
            end

            itemInformation[data[i].name].name = data[i].name
            itemInformation[data[i].name].label = data[i].label
            itemInformation[data[i].name].weight = data[i].weight
            itemInformation[data[i].name].rare = data[i].rare
            itemInformation[data[i].name].can_remove = data[i].can_remove
        end
    end)
end)

AddEventHandler('esx:playerLoaded', function (source)
    GetLicenses(source)
end)

RegisterServerEvent("suku:sendShopItems")
AddEventHandler("suku:sendShopItems", function(source, itemList)
    itemShopList = itemList
end)

ESX.RegisterServerCallback("suku:getShopItems", function(source, cb, shoptype, identifier)
    itemShopList = {}
    local shop = Config.Shops[identifier]

    if shoptype == "regular" then
        for _, v in pairs(shop.items) do
            if v.name == itemInformation[v.name].name then
                table.insert(itemShopList, {
                    type = "item_standard",
                    name = itemInformation[v.name].name,
                    label = itemInformation[v.name].label,
                    weight = itemInformation[v.name].weight,
                    rare = itemInformation[v.name].rare,
                    can_remove = itemInformation[v.name].can_remove,
                    price = v.price,
                    count = 99999999
                })
            end
        end
    end
        
    if shoptype == "weaponshop" then
        for _, v in pairs(shop.items) do
            if shop.items ~= nil then
                if v.name == itemInformation[v.name].name then
                    table.insert(itemShopList, {
                        type = "item_standard",
                        name = itemInformation[v.name].name,
                        label = itemInformation[v.name].label,
                        weight = itemInformation[v.name].weight,
                        rare = itemInformation[v.name].rare,
                        can_remove = itemInformation[v.name].can_remove,
                        price = v.price,
                        count = 99999999
                    })
                end
            end
        end
        
        for _, v in pairs(shop.weapons) do
            if v.name == itemInformation[v.name].name then
                table.insert(itemShopList, {
                    type = "item_weapon",
                    name = itemInformation[v.name].name,
                    label = itemInformation[v.name].label,
                    weight = itemInformation[v.name].weight,
                    ammo = v.ammo,
                    rare = itemInformation[v.name].rare,
                    can_remove = itemInformation[v.name].can_remove,
                    price = v.price,
                    count = 99999999
                })
            end
        end

        for _,v in pairs(shop.ammo) do
            if v.name == itemInformation[v.name].name then
                table.insert(itemShopList, {
                    type = "item_standard",
                    name = itemInformation[v.name].name,
                    label = itemInformation[v.name].label,
                    weight = itemInformation[v.name].weight,
                    rare = itemInformation[v.name].rare,
                    can_remove = itemInformation[v.name].can_remove,
                    price = v.price,
                    count = 99999999
                })
            end
        end
    end

    cb(itemShopList)
end)

RegisterNetEvent("suku:SellItemToPlayer")
AddEventHandler("suku:SellItemToPlayer",function(source, type, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
        local targetItem = xPlayer.getInventoryItem(item)
        if targetItem.limit == -1 or xPlayer.canCarryItem then
            local list = itemShopList
            for i = 1, #list, 1 do
                if list[i].name == item then
                    local totalPrice = count * list[i].price
                    if xPlayer.getMoney() >= totalPrice then
                        xPlayer.removeMoney(totalPrice)
                        xPlayer.addInventoryItem(item, count)
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You purchased '..count.." "..list[i].label })
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough money!' })
                    end
                end
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough space in your inventory!' })
        end
    end
    
    if type == "item_weapon" then
        local targetItem = xPlayer.getInventoryItem(item)
        if targetItem.count < 1 then
            local list = itemShopList
            for i = 1, #list, 1 do
                if list[i].name == item then
                    local targetWeapon = xPlayer.hasWeapon(tostring(list[i].name)) 
                    if not targetWeapon then
                        local totalPrice = 1 * list[i].price
                        if xPlayer.getMoney() >= totalPrice then
                            xPlayer.removeMoney(totalPrice)
                            xPlayer.addWeapon(list[i].name, list[i].ammo)
                            
                            local date = os.date("%d/%m/%Y %X")
                            local output = string.format('**[%s]:** %s (%s) has bought a %s from the ammunation.', date, xPlayer.getName(), GetPlayerName(source), list[i].label)
                            TriggerEvent('esx_logging:Monitor', output)

                            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You purchased a '..list[i].label })
                        else
                            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough money!' })
                        end
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You already own this weapon!' })
                    end
                end
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You already own this weapon!' })
        end
    end
end)

function GetLicenses(source)
    TriggerEvent('esx_license:getLicenses', source, function (licenses)
        TriggerClientEvent('suku:GetLicenses', source, licenses)
    end)
end

RegisterServerEvent('suku:buyLicense')
AddEventHandler('suku:buyLicense', function ()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.get('money') >= Config.LicensePrice then
        xPlayer.removeMoney(Config.LicensePrice)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You registered a Fire Arms license.' })
        TriggerEvent('esx_license:addLicense', _source, 'weapon', function ()
            GetLicenses(_source)
        end)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough money!' })
    end
end)

function tablesize(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end