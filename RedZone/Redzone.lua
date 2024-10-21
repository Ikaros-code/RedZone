local zoneCoords = vector3(3797.02, 4469.31, 5.43) -- Change these coordinates to your desired location
local zoneRadius = 280.0 -- Adjust the radius as needed
local rewardAmount = 250 -- Amount of money to give each player in the zone
local checkInterval = 60000 -- Check every 60 seconds (60000 ms)


-- Feel free to ignore all below, just edit above^^^ - Ikaros

QBCore = exports['qb-core']:GetCoreObject()

local playerInZone = false

local function createRedZoneBlip()
    local blip = AddBlipForRadius(zoneCoords.x, zoneCoords.y, zoneCoords.z, zoneRadius)

    SetBlipHighDetail(blip, true)       
    SetBlipColour(blip, 1)               
    SetBlipAlpha(blip, 128)             


   local blipMarker = AddBlipForCoord(zoneCoords.x, zoneCoords.y, zoneCoords.z)
   SetBlipSprite(blipMarker, 833)      
   SetBlipColour(blipMarker, 1)          
   SetBlipAsShortRange(blipMarker, false) 

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Red Zone")
    EndTextCommandSetBlipName(blipMarker)
end

local function rewardPlayersInZone()
    local playersInZone = 0

    for _, playerId in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(ped)

        if #(playerCoords - zoneCoords) <= zoneRadius then
            playersInZone = playersInZone + 1
        end
    end


    if playersInZone > 1 then
        for _, playerId in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(playerId)
            local playerCoords = GetEntityCoords(ped)

            if #(playerCoords - zoneCoords) <= zoneRadius then
                local playerServerId = GetPlayerServerId(playerId)
                
                TriggerServerEvent("qb-redzone:giveReward", playerServerId, rewardAmount)
            end
        end
    end
end
local function monitorPlayerZoneEntry()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords - zoneCoords) <= zoneRadius then
        if not playerInZone then
            playerInZone = true
            TriggerEvent('QBCore:Notify', 'You have entered the Red Zone!', 'error', 5000) -- Message for entering zone
        end
    else
        if playerInZone then
            playerInZone = false
            TriggerEvent('QBCore:Notify', 'You have left the Red Zone.', 'primary', 5000) -- Message for leaving zone
        end
    end
end

CreateThread(function()
    createRedZoneBlip()
    while true do
        Citizen.Wait(checkInterval)
        rewardPlayersInZone()
    end
end)

while true do
    Citizen.Wait(1000) -- Check every second
    monitorPlayerZoneEntry()
end

