ESX.RegisterServerCallback("esx_garage:getOwnedVehiclesimpound", function(source, cb)
    local ownedVehs = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND stored = @stored', {
        ['@owner'] = xPlayer.identifier,
        ['@stored'] = 2
    }, function(data)
        for _, v in pairs(data) do
            table.insert(ownedVehs, {
                nameimpound = v.nameimpound,
                moneyimpound = v.moneyimpound,
                plate = v.plate
            })
        end
        cb(ownedVehs)
    end)
end)

ESX.RegisterServerCallback("esx_garage:getOwnedVehicles", function(source, cb, thisGarage)
    local ownedVehs = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local Job = nil
    if thisGarage ~= nil then
        if Config.Garages[thisGarage]['Job'] ~= nil then
            Job = xPlayer.job.name
        end
    end
    local type = Config.Garages[thisGarage]['Type']
    if Job ~= nil then
        if type == 'all' then
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job', {
                ['@owner'] = xPlayer.identifier,
                ['@job'] = Job
            }, function(data)
                for _, v in pairs(data) do
                    local vehicle = json.decode(v.vehicle)
                    table.insert(ownedVehs, {
                        vehicle = vehicle,
                        data = v
                    })
                end
                cb(ownedVehs)
            end)
        else
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', {
                ['@owner'] = xPlayer.identifier,
                ['@Type'] = type,
                ['@job'] = Job
            }, function(data)
                for _, v in pairs(data) do
                    local vehicle = json.decode(v.vehicle)
                    table.insert(ownedVehs, {
                        vehicle = vehicle,
                        data = v
                    })
                end
                cb(ownedVehs)
            end)
        end
    else
        if type == 'all' then
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
                ['@owner'] = xPlayer.identifier
            }, function(data)
                for _, v in pairs(data) do
                    if not v.job or v.job == '' then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(ownedVehs, {
                            vehicle = vehicle,
                            data = v
                        })
                    end
                end
                cb(ownedVehs)
            end)
        else
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type', {
                ['@owner'] = xPlayer.identifier,
                ['@Type'] = type
            }, function(data)

                for _, v in pairs(data) do
                    if not v.job or v.job == '' then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(ownedVehs, {
                            vehicle = vehicle,
                            data = v
                        })
                    end
                end
                cb(ownedVehs)
            end)
        end
    end
end)

ESX.RegisterServerCallback("esx_garage:getOwnedVehiclesJob", function(source, cb, type)
    local ownedVehs = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', {
        ['@owner'] = xPlayer.identifier,
        ['@Type'] = type,
        ["@job"] = xPlayer.job.name
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            if v.stored == 0 then
                v.stored = true
            else
                v.stored = false
            end
            table.insert(ownedVehs, {
                vehicle = vehicle,
                data = v
            })
        end
        cb(ownedVehs)
    end)
end)

ESX.RegisterServerCallback("esx_garage:Parkingcar", function(source, cb, plate, props, thisGarage)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        'UPDATE owned_vehicles SET `stored` = @stored, `vehicle` = @vehicle, `parking` = @thisGarage WHERE plate = @plate AND owner = @owner',
        {
            ['@stored'] = 1,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode(props),
            ['@thisGarage'] = thisGarage,
            ['@owner'] = xPlayer.identifier
        }, function(rowsChanged)
            if rowsChanged == 0 then
                cb(false)
            else
                cb(true)
            end
        end)
end)

RegisterNetEvent("esx_garage:pay")
AddEventHandler("esx_garage:pay", function(amount)
    if tonumber(amount) ~= nil then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeMoney(amount)
    end
end)

RegisterNetEvent("esx_garage:setState")
AddEventHandler("esx_garage:setState", function(plate, state)
    if tonumber(state) ~= nil then
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
            ['@stored'] = state,
            ['@plate'] = plate
        }, function(rowsChanged)
            if rowsChanged == 0 then
            end
        end)
    end
end)

RegisterServerEvent('esx_garage:Changename')
AddEventHandler('esx_garage:Changename', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute("UPDATE owned_vehicles SET name=@name WHERE plate=@plate", {
        ['@plate'] = data.plate,
        ['@name'] = data.value
    })
end)

RegisterServerEvent('esx_garage:DeleteVehicle')
AddEventHandler('esx_garage:DeleteVehicle', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = data.plate
    }, function(result)
        if result[1] then
            local vehicle = json.decode(result[1].vehicle)
            if vehicle.plate == data.plate then
                RemoveOwnedVehicle(data.plate)
                xPlayer.triggerEvent('esx:showNotification', 'You deleted: ' .. data.plate)
            end
        end
    end)
end)

function Trim(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end
ESX.RegisterServerCallback("esx_garage:Getbody", function(source, cb, plate)
    plate = Trim(plate)
    local vehicles = GetAllVehicles()
    local data = 1
    for k, v in pairs(vehicles) do
        local p = Trim(GetVehicleNumberPlateText(v))
        if plate == p then
            data = v
        end
    end
    cb(data)
end)

RegisterNetEvent("esx_garage:removeVehicle")
AddEventHandler("esx_garage:removeVehicle", function(plate)
    plate = Trim(plate)
    local vehicles = GetAllVehicles()
    for k, v in pairs(vehicles) do
        local p = Trim(GetVehicleNumberPlateText(v))
        if plate == p then
            DeleteEntity(v)
        end
    end
end)

function RemoveOwnedVehicle(plate)
    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
end
