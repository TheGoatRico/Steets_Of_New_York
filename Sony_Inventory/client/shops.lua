local shopZone = nil

RegisterNetEvent("esx_inventoryhud:openShop")
AddEventHandler(
    "esx_inventoryhud:openShop",
    function(zone, items)
        setShopData(zone, items)
        openShop()
    end
)

function setShopData(zone, items)
    shopZone = zone

    SendNUIMessage(
        {
            action = "setType",
            type = "shop"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = _U("store")
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openShop()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "shop"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback("BuyItem", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        local ped = PlayerPedId()
        if shopZone == "GunShop" then
            if HasPedGotWeapon(ped, GetHashKey(data.item.name), false) then
                exports['mythic_notify']:SendAlert('error', _U("already_have_weapon"))
            else
                TriggerServerEvent("menace-inventory:buyItem", data.item, count)
            end
        elseif shopZone == "BlackWeashop" then
            if HasPedGotWeapon(ped, GetHashKey(data.item.name), false) then
                exports['mythic_notify']:SendAlert('error', _U("already_have_weapon"))
            else
                TriggerServerEvent("menace-inventory:buyBlackMarketWeapon", data.item)
            end
        elseif shopZone == "LSPD" then
            if HasPedGotWeapon(ped, GetHashKey(data.item.name), false) then
                exports['mythic_notify']:SendAlert('error', _U("already_have_weapon"))
            else
                TriggerServerEvent("menace-inventory:buyItem", data.item, count)
            end
        else
            TriggerServerEvent("esx_shops:buyItem", data.item.name, count, shopZone)
        end
    end

    loadPlayerInventory()
    Citizen.Wait(250)

    cb("ok")
end)
