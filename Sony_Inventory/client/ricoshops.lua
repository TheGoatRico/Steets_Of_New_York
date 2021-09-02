local shopData = nil

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local Licenses = {}

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k, v in pairs(Config.Shops) do
            for _, coords in pairs(v.coords) do
                local distance = #(playerCoords - coords)

                if distance < 2.0 then 
                    letSleep = false

                    if (k == "Ammunation") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                                if hasWeaponLicense then
                                    OpenShopInv("weaponshop", k)
                                    Citizen.Wait(1000)
                                else
                                    exports['mythic_notify']:SendAlert('error', 'You need a firearms license before you can buy weapons.')
                                end
                            end, GetPlayerServerId(PlayerId()), 'weapon')
                        end

                    elseif (k == "Armory") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'police' then
                                OpenShopInv("weaponshop", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end
						
                    elseif (k == "Plug") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'gang' then
                                OpenShopInv("regular", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'I Only Talk To Bosses.')
                            end
                        end

                    elseif (k == "Nachos Tacos") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'taco' then
                                OpenShopInv("regular", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end

                    elseif (k == "McDonalds") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'mcd' then
                                OpenShopInv("regular", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end

                    elseif (k == "Starbucks") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'starbuck' then
                                OpenShopInv("regular", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end

                    elseif (k == "Weed Store") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'weed' then
                                OpenShopInv("regular", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end

                    elseif (k == "iFruit Store") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'ifruit' then
                                OpenShopInv("regular", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end

                    elseif (k == "Paramedic Locker") then
                        if IsControlJustReleased(0, Keys["E"]) then
                            if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' then
                                OpenShopInv("weaponshop", k)
                                Citizen.Wait(1000)
                            else
                                exports['mythic_notify']:SendAlert('error', 'You\'re unauthorized to access this.')
                            end
                        end
                    else
                        if IsControlJustReleased(0, Keys["E"]) then
                            OpenShopInv("regular", k)
                            Citizen.Wait(1000)
                        end
                    end
                end
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

function OpenShopInv(shoptype, identifier)
    text = _U('store_info', identifier)
    data = { text = text }
    inventory = {}

    ESX.TriggerServerCallback("suku:getShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, shoptype, identifier)

    Citizen.Wait(500)
    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory)
end

RegisterNetEvent("esx_inventoryhud:openShopInventory")
AddEventHandler("esx_inventoryhud:openShopInventory", function(data, inventory)
    setShopInventoryData(data, inventory, weapons)
    openShopInventory()
end)

function setShopInventoryData(data, inventory)
    shopData = data

    SendNUIMessage({
        action = "setInfoText",
        text = data.text
    })

    items = {}

    SendNUIMessage({
        action = "setShopInventoryItems",
        itemList = inventory
    })
end

function openShopInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "shop"
    })

    SetNuiFocus(true, true)
end

RegisterNUICallback("TakeFromShop", function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local x = "x"
            local count = tonumber(data.number)
            TriggerServerEvent("suku:SellItemToPlayer", GetPlayerServerId(PlayerId()), data.item.type, data.item.name, tonumber(data.number))
            TriggerServerEvent('send:todisc', 'Bought/Took '..count..x..' "'..data.item.name..'" from '..data.text..'')
            TriggerServerEvent('send:todiscord', 'Bought/Took '..count..x..' "'..data.item.name..'" from '..data.text..'')
        end

        Wait(250)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNetEvent("suku:AddAmmoToWeapon")
AddEventHandler("suku:AddAmmoToWeapon", function(hash, amount)
    AddAmmoToPed(GetPlayerPed(-1), hash, amount)
end)

RegisterNetEvent('suku:GetLicenses')
AddEventHandler('suku:GetLicenses', function (licenses)
    for i = 1, #licenses, 1 do
        Licenses[licenses[i].type] = true
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for k, v in pairs(Config.Shops) do
        if v.enableBlip then
            for val, coords in pairs(v.coords) do

                local blip = {
                    name = k,
                    coords = coords,
                    colour = v.blipColour or 2,
                    sprite = v.blipSprite or 52
                }
                CreateBlip(blip.coords, blip.colour, blip.sprite, blip.name)
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k, v in pairs(Config.Shops) do
            for _, coords in pairs(v.coords) do
                local distance = #(playerCoords - coords)

                if distance < 3.0 then 
                    letSleep = false

                    local marker = {
                        type = v.markerType or 1,
                        coords = coords,
                        color = v.markerColour or { r = 55, b = 255, g = 55 },
                        size = v.size or vector3(1.0, 1.0, 1.0)
                    }

                    DrawMarker(marker.type, marker.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.size.x, marker.size.y, marker.size.z, marker.color.r, marker.color.g, marker.color.b, 100, false, true, 2, true, false, false, false)
                end
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

function CreateBlip(coords, color, sprite, text)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end