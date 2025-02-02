local seatbeltOn = false
local displayHud = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle and vehicle ~= 0 then
            if not displayHud then
                displayHud = true
                SendNUIMessage({
                    type = "showHUD"
                })
            end

            local speed = GetEntitySpeed(vehicle) * 3.6
            local fuel = exports['LegacyFuel']:GetFuel(vehicle)
            local isEngineOn = IsVehicleEngineOn(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)

            SendNUIMessage({
                type = "updateHUD",
                speed = math.floor(speed),
                fuel = fuel,
                isEngineOn = isEngineOn,
                engineHealth = engineHealth
            })

            if seatbeltOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end
        else
            if displayHud then
                displayHud = false
                SendNUIMessage({
                    type = "hideHUD"
                })
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if IsControlJustPressed(0, 29) then
            seatbeltOn = not seatbeltOn
            SendNUIMessage({
                type = "updateSeatbelt",
                seatbeltOn = seatbeltOn
            })
        end

        if vehicle and vehicle ~= 0 then
            SendNUIMessage({
                type = "updateSeatbelt",
                seatbeltOn = seatbeltOn
            })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle and vehicle ~= 0 then
            local lockStatus = GetVehicleDoorLockStatus(vehicle)

            SendNUIMessage({
                type = "updateLockStatus",
                isLocked = lockStatus == 2
            })
        end
    end
end)
