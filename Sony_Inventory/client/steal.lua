ESX = nil

RegisterNetEvent('esx_inventoryhud:rob')
AddEventHandler('esx_inventoryhud:rob', function()

    local ped = PlayerPedId()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local targetPed = GetPlayerPed(closestPlayer)
    if IsEntityPlayingAnim(targetPed, 'missminuteman_1ig_2', 'handsup_base', 3) or IsEntityDead(targetPed) then
        if closestPlayer ~= -1 and closestDistance <= 1.5 then
            exports['pogressBar']:drawBar(3500, 'Robbing...', function()
                ESX.Streaming.RequestAnimDict('random@shop_robbery', function()
                    TaskPlayAnim(ped, 'random@shop_robbery', 'robbery_action_b', 8.0, -8, -1, 16, 0, 0, 0, 0)
                end)
                Wait(1000)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent('esx_inventoryhud:steal', GetPlayerServerId(closestPlayer))
                OpenBodySearchMenu(closestPlayer)
            end)
        else
            exports['mythic_notify']:SendAlert('error', _U("players_nearby"))
        end
    end
end)