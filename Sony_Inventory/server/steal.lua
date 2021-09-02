ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('steal', function(source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        TriggerClientEvent('esx_inventoryhud:rob', source)
    end
end)

RegisterServerEvent('esx_inventoryhud:steal')
AddEventHandler('esx_inventoryhud:steal', function(target)
    local _source = source
    local _target = tonumber(target)

    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(_target)

    if xPlayer then
        if xTarget then
            local cash = xTarget.getMoney()
            local blackMoney = xTarget.getAccount('black_money').money

            TriggerClientEvent('chat:addMessage', _source, {
                template = '<div class="chat-message-orange"><b>Money:</b> ${0} | <b>Dirty Money:</b> ${1}</div>',
                args = { formatCurrency(cash), formatCurrency(blackMoney)  }
            })

            TriggerClientEvent('chat:addMessage', _target, {
                template = '<div class="chat-message-orange"><b>Money:</b> ${0} | <b>Dirty Money:</b> ${1}</div>',
                args = { formatCurrency(cash), formatCurrency(blackMoney)  }
            })

            if cash > 0 then
                xTarget.removeMoney(cash)
                xPlayer.addMoney(cash)
            end

            if blackMoney > 0 then
                xTarget.removeAccountMoney('black_money', blackMoney)
                xPlayer.addAccountMoney('black_money', blackMoney)
            end
        end
    end
end)

function formatCurrency(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end