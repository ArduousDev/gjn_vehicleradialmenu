lib.locale()

local windows = { true, true, true, true }

local function viewLiveries()
	if not cache.vehicle then
		return lib.notify({ title = locale('liveries'), description = locale('not_in_vehicle'), type = 'error', position = 'top', icon = 'ban' })
	end

	TriggerEvent('getLiveries')
end

local function formatOption(vehicle, i)
	return {
		title = locale('toggle_livery', i + 1),
		event = 'toggleLivery',
		args = { vehicle = vehicle, livery = i }
	}
end

AddEventHandler('getLiveries', function()
	local vehicle = cache.vehicle
	if not vehicle then
		return
	end

	local numMods = GetNumVehicleMods(vehicle, 48)
	local numLiveries = GetVehicleLiveryCount(vehicle)

	SetVehicleModKit(vehicle, 0)

	local options, count = {}, 0

	if numMods > 0 then
		for i = 0, numMods -1 do
			count += 1
			options[count] = formatOption(vehicle, i)
		end
	end

	if numLiveries > 0 then
		for i = 0, numLiveries -1 do
			count += 1
			options[count] = formatOption(vehicle, i)
		end
	end

	if count == 0 then
		return lib.notify({ title = locale('liveries'), description = locale('no_liveries_found'), type = 'error', position = 'top', icon = 'ban' })
	end

	lib.registerContext({ id = 'liveries_menu', title = locale('vehicle_liveries'), options = options })
	lib.showContext('liveries_menu')
end)

AddEventHandler('toggleLivery', function(data)
	local vehicle, livery = data?.vehicle, data?.livery
	if not vehicle or not livery then
		return
	end

	SetVehicleLivery(vehicle, livery)
	SetVehicleMod(vehicle, 48, livery)

	TriggerEvent('getLiveries')
end)

-- Vehicle Menu
lib.registerRadial({
    id = 'car_doors',
    items = {
        {
            label = locale("back_right"),
            icon = 'car-side',
            keepOpen = true,
            onSelect = function()
                doorToggle(3)
            end
        },
        {
            label = locale("trunk"),
            icon = 'trunk',
            keepOpen = true,
            onSelect = function()
                doorToggle(5)
            end
        },
        {
            label = locale("front_right"),
            icon = 'car-side',
            keepOpen = true,
            onSelect = function()
                doorToggle(1)
            end
        },
        {
            label = locale("front_left"),
            icon = 'car-side',
            keepOpen = true,
            onSelect = function()
                doorToggle(0)
            end
        },
        {
            label = locale("hood"),
            icon = 'car-hood',
            keepOpen = true,
            onSelect = function()
                doorToggle(4)
            end
        },
        {
            label = locale("back_left"),
            icon = 'car-side',
            keepOpen = true,
            onSelect = function()
                doorToggle(2)
            end
        },
    }
})

lib.registerRadial({
    id = 'car_windows',
    items = {
        {
            label = loclale("back_right"),
            icon = 'caret-right',
            keepOpen = true,
            onSelect = function()
                windowToggle(2, 3)
            end
        },
        {
            label = locale("co_driver"),
            icon = 'caret-up',
            keepOpen = true,
            onSelect = function()
                windowToggle(1, 1)
            end
        },
        {
            label = locale("driver"),
            icon = 'caret-up',
            keepOpen = true,
            onSelect = function()
                windowToggle(0, 0)
            end
        },
        {
            label = locale("back_left"),
            icon = 'caret-left',
            keepOpen = true,
            onSelect = function()
                windowToggle(3, 2)
            end
        },
    }
})

lib.registerRadial({
    id = 'car_seats',
    items = {
        {
            label = locale("back_right"),
            icon = 'caret-right',
            onSelect = function()
                changeSeat(2)
            end
        },
        {
            label = locale("co_driver"),
            icon = 'caret-up',
            onSelect = function()
                changeSeat(0)
            end
        },
        {
            label = locale("driver"),
            icon = 'caret-up',
            onSelect = function()
                changeSeat(-1)
            end
        },
        {
            label = locale("back_left"),
            icon = 'caret-left',
            onSelect = function()
                changeSeat(1)
            end
        },
    }
})

lib.registerRadial({
    id = 'vehicle_menu',
    items = {
        {
            label = locale("extras"),
            icon = 'note-sticky',
            menu = 'extras'
        },
        {
            label = locale("liveries"),
            icon = 'note-sticky',
            onSelect = function ()
                viewLiveries()
            end
        },
        {
            label = 'Motor',
            icon = 'power-off',
            onSelect = function()
                if cache.vehicle then
                    local engineRunning = GetIsVehicleEngineRunning(cache.vehicle)

                    if engineRunning then
                        SetVehicleEngineOn(cache.vehicle, false, true, true)
                    else
                        SetVehicleEngineOn(cache.vehicle, true, true, true)
                    end
                end
            end
        },
        {
            label = locale("doors"),
            icon = 'car-side',
            menu = 'car_doors'
        },
        {
            label = locale("windows"),
            icon = 'car-side',
            menu = 'car_windows'
        },
        {
            label = locale("shuff"),
            icon = 'car-side',
            menu = 'car_seats'
        },
    }
})

lib.onCache('vehicle', function(value)
    if value then
        lib.addRadialItem({
            {
                id = 'vehicle',
                label = 'Vehicle',
                icon = 'car',
                menu = 'vehicle_menu'
            }
        })
    else
        lib.removeRadialItem('vehicle')
    end
end)

lib.registerRadial({
    id = 'extras',
    items = {
        {
            label = 'Extra #1',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 1)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #2',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 2)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #3',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 3)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #4',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 4)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #5',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 5)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #6',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 6)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #7',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 7)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #8',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 8)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #9',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 9)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #10',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 10)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #11',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 11)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #12',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 12)
                        end
                    end
                end
            end
        },
        {
            label = 'Extra #13',
            icon = 'note-sticky',
            keepOpen = true,
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            setExtra(veh, 13)
                        end
                    end
                end
            end
        },
    }
})

lib.registerRadial({
    id = 'livery',
    items = {
        {
            label = "kokot",
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            toggleLivery(veh, 1)
                        end
                    end
                end
            end
        },
        {
            label = "kokot2",
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            toggleLivery(veh, 2)
                        end
                    end
                end
            end
        },
        {
            label = "kokot12",
            onSelect = function()
                if cache.vehicle then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped)

                    if veh ~= nil then
                        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                            toggleLivery(veh, 12)
                        end
                    end
                end
            end
        },
    }
})

function toggleLivery(vehicle, livery)
    local numLiveries = GetVehicleLiveryCount(vehicle)
    local items, count = {}, 0
    if SetVehicleLivery(vehicle, livery) then
        lib.notify({
            description = 'Dal sis novou livery s číslem ',
            type = 'success'
        })
        if not SetVehicleLivery(vehicle, livery) then
            lib.notify({
                description = 'Livery číslo '..livery..' na tomhle autě neexistuje!!!',
                type = 'error'
            })
        end
    end
end

function setExtra(vehicle, extra)
    if DoesExtraExist(vehicle, extra) then
        if IsVehicleExtraTurnedOn(vehicle, extra) then
            enginehealth = GetVehicleEngineHealth(vehicle)
            bodydamage = GetVehicleBodyHealth(vehicle)
            SetVehicleExtra(vehicle, extra, 1)
            SetVehicleEngineHealth(vehicle, enginehealth)
            SetVehicleBodyHealth(vehicle, bodydamage)
            lib.notify({
                description = 'Extra: ' .. extra .. ' byly deaktivovány!',
                type = 'error'
            })
        else
            enginehealth = GetVehicleEngineHealth(vehicle)
            bodydamage = GetVehicleBodyHealth(vehicle)
            SetVehicleExtra(vehicle, extra, 0)
            SetVehicleEngineHealth(vehicle, enginehealth)
            SetVehicleBodyHealth(vehicle, bodydamage)
            lib.notify({
                description = 'Extra: ' .. extra .. ' byly aktivována!',
                type = 'success'
            })
        end
    else
        lib.notify({
            description = 'Extra: ' .. extra .. ' nejsou dostupná pro toto vozidlo!',
            type = 'error'
        })
    end
end

RegisterNetEvent('radialmenu:client:setExtra')
AddEventHandler('radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    local enginehealth = 1000.0
    local bodydamage = 1000.0

    if veh ~= nil then
        local plate = GetVehicleNumberPlateText(closestVehicle)

        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            if DoesExtraExist(veh, extra) then
                if IsVehicleExtraTurnedOn(veh, extra) then
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    --    SetVehicleAutoRepairDisabled(veh, true)
                    SetVehicleExtra(veh, extra, 1)
                    --    SetVehicleAutoRepairDisabled(veh, true)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    ox:notify({
                        type = 'error',
                        text = 'Extra: ' .. extra .. ' byly deaktivovány!',
                        duration = 2500,
                        position = 'bottom-center'
                    })
                else
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    --    SetVehicleAutoRepairDisabled(veh, true)
                    SetVehicleExtra(veh, extra, 0)
                    --    SetVehicleAutoRepairDisabled(veh, true)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    ox:notify({
                        type = 'success',
                        text = 'Extra: ' .. extra .. ' byly aktivována!',
                        duration = 2500,
                        position = 'bottom-center'
                    })
                end
            else
                ox:notify({
                    type = 'error',
                    text = 'Extra: ' .. extra .. ' nejsou dostupná pro toto vozidlo!',
                    duration = 2500,
                    position = 'bottom-center'
                })
            end
        else
            ox:notify({ type = 'error', text = 'Nejsi řidič vozu!', duration = 2500, position = 'bottom-center' })
        end
    end
end)

function doorToggle(door)
    if GetVehicleDoorAngleRatio(cache.vehicle, door) > 0.0 then
        SetVehicleDoorShut(cache.vehicle, door, false, false)
    else
        SetVehicleDoorOpen(cache.vehicle, door, false, false)
    end
end

function changeSeat(seat) -- Check seat is empty and move to it
    if (IsVehicleSeatFree(cache.vehicle, seat)) then
        SetPedIntoVehicle(cache.ped, cache.vehicle, seat)
    end
end

function windowToggle(window, door) -- Check window is open/closed and do opposite
    if GetIsDoorValid(cache.vehicle, door) and windows[window + 1] then
        RollDownWindow(cache.vehicle, window)
        windows[window + 1] = false
    else
        RollUpWindow(cache.vehicle, window)
        windows[window + 1] = true
    end
end