QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("qb-redzone:giveReward")

AddEventHandler("qb-redzone:giveReward", function(playerId, amount)
    local player = QBCore.Functions.GetPlayer(playerId)
    if player then
        player.Functions.AddMoney("cash", amount)
        TriggerClientEvent('QBCore:Notify', playerId, "You received $"..amount.." for being in the Red Zone!", 'success')
    end
end)