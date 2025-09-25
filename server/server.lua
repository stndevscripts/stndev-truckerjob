ESX = exports.es_extended:getSharedObject()

RegisterServerEvent('stndev:giveReward', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addMoney(amount)
    end
end)