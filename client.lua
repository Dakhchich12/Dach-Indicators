local activeVehicles = {}
local nearbyVehicles = {}

RegisterCommand('indicator_left', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
        TriggerServerEvent('dach-indicators:toggle', 'left')
        PlaySoundFrontend(-1, "Car_Blinkers_On", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
    end
end, false)
RegisterKeyMapping('indicator_left', 'Toggle Left Indicator', 'keyboard', 'LEFT')

RegisterCommand('indicator_right', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
        TriggerServerEvent('dach-indicators:toggle', 'right')
        PlaySoundFrontend(-1, "Car_Blinkers_On", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
    end
end, false)
RegisterKeyMapping('indicator_right', 'Toggle Right Indicator', 'keyboard', 'RIGHT')

RegisterCommand('indicator_hazard', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
        TriggerServerEvent('dach-indicators:toggle', 'hazard')
        PlaySoundFrontend(-1, "Car_Blinkers_On", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
    end
end, false)
RegisterKeyMapping('indicator_hazard', 'Toggle Hazard Lights', 'keyboard', 'M')

AddStateBagChangeHandler('indicatorLeft', nil, function(bagName, key, value, _reserved, replicated)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end
    
    SetVehicleIndicatorLights(entity, 1, value)
    
    if value then
        activeVehicles[entity] = activeVehicles[entity] or {}
        activeVehicles[entity].left = true
        
        local plyCoords = GetEntityCoords(PlayerPedId())
        if #(plyCoords - GetEntityCoords(entity)) < 50.0 then
            nearbyVehicles[entity] = activeVehicles[entity]
        end
    else
        if activeVehicles[entity] then
            activeVehicles[entity].left = false
            if not activeVehicles[entity].right then
                activeVehicles[entity] = nil
                nearbyVehicles[entity] = nil
            end
        end
    end
end)

AddStateBagChangeHandler('indicatorRight', nil, function(bagName, key, value, _reserved, replicated)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end
    
    SetVehicleIndicatorLights(entity, 0, value)
    
    if value then
        activeVehicles[entity] = activeVehicles[entity] or {}
        activeVehicles[entity].right = true
        
        local plyCoords = GetEntityCoords(PlayerPedId())
        if #(plyCoords - GetEntityCoords(entity)) < 50.0 then
            nearbyVehicles[entity] = activeVehicles[entity]
        end
    else
        if activeVehicles[entity] then
            activeVehicles[entity].right = false
            if not activeVehicles[entity].left then
                activeVehicles[entity] = nil
                nearbyVehicles[entity] = nil
            end
        end
    end
end)

AddEventHandler('entityRemoved', function(entity)
    if activeVehicles[entity] then
        activeVehicles[entity] = nil
        nearbyVehicles[entity] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if next(activeVehicles) then
            local plyPed = PlayerPedId()
            local plyCoords = GetEntityCoords(plyPed)
            local hasNearby = false
            
            for veh, states in pairs(activeVehicles) do
                if DoesEntityExist(veh) then
                    local vehCoords = GetEntityCoords(veh)
                    if #(plyCoords - vehCoords) < 50.0 then
                        nearbyVehicles[veh] = states
                        hasNearby = true
                    else
                        nearbyVehicles[veh] = nil
                    end
                else
                    activeVehicles[veh] = nil
                    nearbyVehicles[veh] = nil
                end
            end
            
            if hasNearby then
                sleep = 500
            end
        else
            for k in pairs(nearbyVehicles) do
                nearbyVehicles[k] = nil
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        
        if next(nearbyVehicles) then
            local time = GetGameTimer()
            local phase = time % 800
            
            if phase < 400 then
                sleep = 0
                for veh, states in pairs(nearbyVehicles) do
                    local _, lightsOn = GetVehicleLightsState(veh)
                    local alpha = lightsOn == 1 and 100 or 150
                    
                    if states.left then
                        local leftOffset = GetOffsetFromEntityInWorldCoords(veh, -1.0, 0.0, 1.2)
                        DrawMarker(1, leftOffset.x, leftOffset.y, leftOffset.z, 
                            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                            0.15, 0.15, 0.15, 
                            255, 255, 0, alpha, 
                            true, true, 2, true, nil, nil, false)
                    end
                    
                    if states.right then
                        local rightOffset = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.2)
                        DrawMarker(1, rightOffset.x, rightOffset.y, rightOffset.z, 
                            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                            0.15, 0.15, 0.15, 
                            255, 255, 0, alpha, 
                            true, true, 2, true, nil, nil, false)
                    end
                end
            else
                sleep = 800 - phase
            end
        end
        
        Citizen.Wait(sleep)
    end
end)