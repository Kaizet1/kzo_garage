local PlayerData = nil
local curAction = nil
local thisGarage = nil
local shouldShowHelp = false
local blips = {}
local GangName = {}

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local cansee = false
function Garagee_Pos()
    pedCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.Garages) do
        if (not v.Job) or v.Job == PlayerData.job.name then
            if #(pedCoords - vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z)) <= 10.0 then
                DrawMarker(36, v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
                    1.0, 1.0, 30, 144, 255, 100, false, true, 2, true, false, false, false)
                cansee = true
            end
            if #(pedCoords - vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z)) <= 15.0 then
                DrawMarker(24, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
                    1.0, 1.0, 255, 71, 87, 100, false, true, 2, true, false, false, false)
                cansee = true
            end
        end
        if (not v.Job) or v.Job == PlayerData.job.name then
            if #(pedCoords - vector3(v.GaragePoint.x, v.GaragePoint.y, v.GaragePoint.z)) <= 2.0 then
                thisGarage = k
                curAction = 'GaragePoint'
                return
            elseif #(pedCoords - vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z)) <= 3.0 then
                thisGarage = k
                curAction = 'DeletePoint'
                return
            end
        end
    end
    thisGarage = nil
    curAction = nil
    return
end

Citizen.CreateThread(function()
    Citizen.Wait(10000)
    CreateBlip()
    while true do
        cansee = false
        Garagee_Pos()
        if curAction ~= nil then
            if not shouldShowHelp then
                ESX.ShowHelpNotification(Config.HelpNotification[curAction])
                if IsControlJustReleased(0, 38) then
                    if curAction == 'GaragePoint' then
                        OpenGarage()
                    elseif curAction == 'DeletePoint' then
                        Parkingthecar()
                    end
                end
            end
        end
        Citizen.Wait(0)
        if cansee == false then
            Citizen.Wait(1000)
        end
    end
end)

RegisterNUICallback('hide', function(data, cb)
    SetNuiFocus(false, false)
    Citizen.Wait(1500)
    shouldShowHelp = false
end)
RegisterNUICallback("Getcar", function(data, cb)
    SpawnVehicle(data)
end)
RegisterNUICallback("Changename", function(data, cb)
    TriggerServerEvent("esx_garage:Changename", data)
    Citizen.Wait(200)
    OpenGarage()
end)
RegisterNUICallback("DeleteVehicle", function(data, cb)
    TriggerServerEvent("esx_garage:DeleteVehicle", data)
    Citizen.Wait(200)
    OpenGarage()
end)

function OpenGarage()
    ESX.TriggerServerCallback("esx_garage:getOwnedVehicles", function(result)
        shouldShowHelp = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "garage",
            result = result
        })
    end, thisGarage)
end
function Trim(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end
function Parkingthecar()
    ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if GetPedInVehicleSeat(veh, -1) ~= ped then
        return
    end
    local vehProps = ESX.Game.GetVehicleProperties(veh)

    local vehPlate = Trim(GetVehicleNumberPlateText(veh))
    ESX.TriggerServerCallback("esx_garage:Parkingcar", function(result)
        if result then
            TaskLeaveVehicle(PlayerPedId(), veh, 0)
            Citizen.Wait(2000)
            ESX.Game.DeleteVehicle(veh)
            ESX.ShowNotification(("Vehicle [%s] has been stored in the garage"):format(vehPlate))
        else
            ESX.ShowNotification("This vehicle does not belong to you!")
        end
    end, vehPlate, vehProps, thisGarage)
end
function SpawnVehicle(data)
    if thisGarage == nil then
        ESX.ShowNotification('You go too far!')
        return
    end
    fomat = data.data.data
    if tonumber(fomat.stored) == 1 then
        TriggerServerEvent('esx_garage:removeVehicle', fomat.plate)
        Wait(1000)
        if ESX.Game.IsSpawnPointClear(Config.Garages[thisGarage].SpawnPoint, 3.0) then
            ESX.Game.SpawnVehicle(json.decode(fomat.vehicle).model, {
                x = Config.Garages[thisGarage].SpawnPoint.x,
                y = Config.Garages[thisGarage].SpawnPoint.y,
                z = Config.Garages[thisGarage].SpawnPoint.z
            }, Config.Garages[thisGarage].SpawnPoint.h, function(cbVeh)
                ESX.Game.SetVehicleProperties(cbVeh, data.data.vehicle)
                SetVehicleEngineHealth(cbVeh, data.data.vehicle.engineHealth + 0.0 or 1000.0)
                SetVehicleBodyHealth(cbVeh, data.data.vehicle.bodyHealth + 0.0 or 1000.0)
                SetVehRadioStation(cbVeh, "OFF")
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), cbVeh, -1)
                SetVehicleHasBeenOwnedByPlayer(cbVeh, true)
            end)
            TriggerServerEvent('esx_garage:setState', fomat.plate, 0)
        else
            ESX.ShowNotification("Obstacle at spawn point!")
            return
        end
    elseif tonumber(fomat.stored) == 0 then
        TriggerServerEvent('esx_garage:removeVehicle', fomat.plate)
        Wait(1000)
        TriggerServerEvent('esx_garage:pay', Config.ImpoundPay)
		ESX.ShowNotification("You have paid 3000$!")
        ESX.TriggerServerCallback("esx_garage:Getbody", function(result)
            if result ~= 1 then
                engine = GetVehicleEngineHealth(result)
                body = GetVehicleBodyHealth(result)
            end
            if thisGarage then
                if ESX.Game.IsSpawnPointClear(Config.Garages[thisGarage].SpawnPoint, 3.0) then
                    ESX.Game.SpawnVehicle(json.decode(fomat.vehicle).model, {
                        x = Config.Garages[thisGarage].SpawnPoint.x,
                        y = Config.Garages[thisGarage].SpawnPoint.y,
                        z = Config.Garages[thisGarage].SpawnPoint.z
                    }, Config.Garages[thisGarage].SpawnPoint.h, function(cbVeh)
                        ESX.Game.SetVehicleProperties(cbVeh, data.data.vehicle)
                        SetVehicleEngineHealth(cbVeh, engine and data.data.vehicle.engineHealth + 0.0 or 100.0)
                        SetVehicleBodyHealth(cbVeh, body and data.data.vehicle.bodyHealth + 0.0 or 100.0)
                        SetVehRadioStation(cbVeh, "OFF")
                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), cbVeh, -1)
                        SetVehicleHasBeenOwnedByPlayer(cbVeh, true)
                    end)
                else
                    ESX.ShowNotification("Obstacle at spawn point!")
                    return
                end
            end
        end, fomat.plate)
    end
end
function CreateBlip()
    for k, v in pairs(Config.Garages) do
        if v['Blip'] == nil then
            AddGarage('default', k, v)
        end
    end
end
function AddGarage(type, name, data)
    if not data.Job then
        local blip = AddBlipForCoord(data.GaragePoint.x, data.GaragePoint.y, data.GaragePoint.z)
        SetBlipSprite(blip, Config.Blip[type].Spire)
        SetBlipScale(blip, Config.Blip[type].Scale)
        SetBlipColour(blip, Config.Blip[type].Color)
		SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(data.BlipText or "Garage")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    elseif data.Job == PlayerData.job.name then
        local blip = AddBlipForCoord(data.GaragePoint.x, data.GaragePoint.y, data.GaragePoint.z)
        SetBlipSprite(blip, Config.Blip[type].Spire)
        SetBlipScale(blip, Config.Blip[type].Scale)
        SetBlipColour(blip, Config.Blip[type].Color)
		SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(data.BlipText or "Garage")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end
end
