print('^2[Dach-Indicators]^0 ^7Started! Made by dakhchich.^0')

RegisterNetEvent('dach-indicators:toggle', function(direction)
    local src = source
    local ped = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(ped, false)
    
    if veh and veh ~= 0 then
        if GetPedInVehicleSeat(veh, -1) == ped then
            local state = Entity(veh).state
            
            if direction == 'left' then
                local current = state.indicatorLeft
                state:set('indicatorLeft', not current, true)
                if not current and state.indicatorRight then
                    state:set('indicatorRight', false, true)
                end
                
            elseif direction == 'right' then
                local current = state.indicatorRight
                state:set('indicatorRight', not current, true)
                if not current and state.indicatorLeft then
                    state:set('indicatorLeft', false, true)
                end
                
            elseif direction == 'hazard' then
                local isHazard = state.indicatorLeft and state.indicatorRight
                state:set('indicatorLeft', not isHazard, true)
                state:set('indicatorRight', not isHazard, true)
            end
        end
    end
end)