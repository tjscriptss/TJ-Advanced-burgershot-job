ESX = exports['es_extended']:getSharedObject()
lib.locale()
local Items = {}
local description = {}
local onDuty = true
local washedHands = true
PlayerData = {}

local isMenuOpen = false

local function toggleMenu()
    local items = {}

    if Config.Resotrani[1].menu[2].Items then
        for _, item in ipairs(Config.Resotrani[1].menu[2].Items) do
            table.insert(items, {
                label = item.label,
                item = item.item,
                description = item.description or 'not available',
                image = item.image or 'default-image-url.jpg',
                price = item.price or 0
            })
        end
    end

    if Config.Resotrani[1].menu[4].Items then
        for _, item in ipairs(Config.Resotrani[1].menu[5].Items) do
            table.insert(items, {
                label = item.label,
                item = item.item,
                description = item.description or 'not available',
                image = item.image or 'default-image-url.jpg',
                price = item.price or 0
            })
        end
    end

    if Config.Resotrani[1].menu[4].Items then
        for _, item in ipairs(Config.Resotrani[1].menu[1].Items) do
            table.insert(items, {
                label = item.label,
                item = item.item,
                description = item.description or 'not available',
                image = item.image or 'default-image-url.jpg',
                price = item.price or 0
            })
        end
    end

    if not isMenuOpen then
        SetNuiFocus(true, true)
        Wait(0)
        SendNUIMessage({
            type = "openMenu",
            items = items
        })
        isMenuOpen = true
    elseif isMenuOpen then
        SetNuiFocus(false, false)
        Wait(0)
        SendNUIMessage({
            type = "closeMenu"
        })
        isMenuOpen = false
    end
end

RegisterNUICallback("exit", function()
    SetNuiFocus(false, false)
    isMenuOpen = false
end)

RegisterNUICallback("addToCart", function(data)
end)

RegisterNUICallback('createOrder', function(data, cb)
    TriggerServerEvent('tj_restaurants:createOrder', data.items, data.paymentMethod)
    cb('ok')
end)

CreateThread(function()
    for i = 1, #Config.Locations, 1 do
        local v = Config.Locations[i]
        if Config.Target == 'ox' then
            exports.ox_target:addBoxZone({
                name = v.name,
                coords = vec3(v.target.coords.x, v.target.coords.y, v.target.coords.z),
                size = vec3(v.target.width, v.target.lenght, v.target.maxZ - v.target.minZ),
                rotation = v.target.heading + 90,
                debug = false,
                options = {
                    {
                        icon = v.target.icon,
                        label = v.target.label,
                        onSelect = v.target.action,
                        groups = v.target.job,
                        canInteract = function()
                            return onDuty and washedHands
                        end,
                    },
                },
                distance = 5.0
            })
        elseif Config.Target == 'qb' then
            exports['qb-target']:AddBoxZone(v.name, v.target.coords, v.target.width, v.target.lenght, {
                name = v.name,
                heading = v.target.heading,
                debugPoly = false,
                minZ = v.target.minZ + 1,
                maxZ = v.target.maxZ + 1,
            }, {
                options = {
                    {
                        icon = v.target.icon,
                        label = v.target.label,
                        action = v.target.action,
                        job = v.target.job,
                        canInteract = function()
                            return onDuty and washedHands
                        end,
                    },
                },
                distance = 3.0,
            })
        end
    end

    for i = 1, #Config.Resotrani, 1 do
        for j = 1, #Config.Resotrani[i].stashovi, 1 do
            local v = Config.Resotrani[i].stashovi[j]
            if Config.Target == 'ox' then
                exports.ox_target:addBoxZone({
                    name = v.name,
                    coords = vec3(v.target.coords.x, v.target.coords.y, v.target.coords.z),
                    size = vec3(v.target.width, v.target.lenght, v.target.maxZ - v.target.minZ),
                    rotation = v.target.heading + 90,
                    debug = false,
                    options = {
                        {
                            icon = v.target.icon,
                            label = v.target.label,
                            onSelect = v.target.action,
                        },
                    },
                    distance = 3.0,
                })
            elseif Config.Target == 'qb' then
                exports['qb-target']:AddBoxZone(v.name, v.target.coords, v.target.width, v.target.lenght, {
                    name = v.name,
                    heading = v.target.heading,
                    debugPoly = false,
                    minZ = v.target.minZ + 1,
                    maxZ = v.target.maxZ + 1,
                }, {
                    options = {
                        {
                            icon = v.target.icon,
                            label = v.target.label,
                            job = Config.Resotrani[i].job,
                            action = v.target.action,
                            canInteract = function()
                                return onDuty and washedHands
                            end,
                        },
                    },
                    distance = 3.0,
                })
            end
        end

        for j = 1, #Config.Resotrani[i].menu, 1 do
            local v = Config.Resotrani[i].menu[j]
            if Config.Target == 'ox' then
                exports.ox_target:addBoxZone({
                    name = v.menuName,
                    coords = vec3(v.target.coords.x, v.target.coords.y, v.target.coords.z),
                    size = vec3(v.target.width, v.target.lenght, v.target.maxZ - v.target.minZ),
                    rotation = v.target.heading + 90,
                    debug = false,
                    options = {
                        {
                            icon = v.target.icon,
                            label = v.target.label,
                            groups = Config.Resotrani[i].job,
                            onSelect = v.target.action,
                            canInteract = function()
                                return onDuty and washedHands
                            end,
                        },
                    },
                    distance = 3.0,
                })
            elseif Config.Target == 'qb' then
                exports['qb-target']:AddBoxZone(v.menuName, v.target.coords, v.target.width, v.target.lenght, {
                    name = v.menuName,
                    heading = v.target.heading,
                    debugPoly = false,
                    minZ = v.target.minZ,
                    maxZ = v.target.maxZ,
                }, {
                    options = {
                        {
                            icon = v.target.icon,
                            label = v.target.label,
                            job = Config.Resotrani[i].job,
                            action = v.target.action,
                            canInteract = function()
                                return onDuty and washedHands
                            end,
                        },
                    },
                    distance = 3.0
                })
            end
        end
    end
end)

function NapraviMenije()
    for i = 1, #Config.Resotrani, 1 do
        for j = 1, #Config.Resotrani[i].menu, 1 do
            local v = Config.Resotrani[i].menu[j]
            if v.id == 'drinks' then
                Items = {}
                for z = 1, #v.Items, 1 do
                    Items[#Items + 1] = {
                        title = v.Items[z].label,
                        event = 'tj_restaurants:MakeDrink',
                        args = {
                            item = v.Items[z].item
                        }
                    }
                end
                lib.registerContext({
                    id = v.menuName,
                    title = v.label,
                    options = Items
                })
            elseif v.id == 'food' then
                Items = {}
                for z = 1, #v.Items, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Items[z].recipe)

                    for o = 1, #v.Items[z].recipe, 1 do
                        description[z] = description[z] .. '\n' .. v.Items[z].recipe[o].label .. ' x' .. v.Items[z].recipe[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Items[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:MakeFood',
                        args = {
                            item = v.Items[z].item,
                            recipe = v.Items[z].recipe
                        }
                    }
                end

                lib.registerContext({
                    id = v.menuName,
                    title = v.label,
                    options = Items
                })
            elseif v.id == 'cooking' then
                Items = {}
                for z = 1, #v.Items, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Items[z].recipe)

                    for o = 1, #v.Items[z].recipe, 1 do
                        description[z] = description[z] .. '\n' .. v.Items[z].recipe[o].label .. ' x' .. v.Items[z].recipe[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Items[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:makeBBQ',
                        args = {
                            item = v.Items[z].item,
                            recipe = v.Items[z].recipe
                        }
                    }
                end

                lib.registerContext({
                    id = v.menuName,
                    title = v.label,
                    options = Items
                })
            elseif v.id == 'deepfryer' then
                Items = {}
                for z = 1, #v.Items, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Items[z].recipe)

                    for o = 1, #v.Items[z].recipe, 1 do
                        description[z] = description[z] .. '\n' .. v.Items[z].recipe[o].label .. ' x' .. v.Items[z].recipe[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Items[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:deepFryer',
                        args = {
                            item = v.Items[z].item,
                            recipe = v.Items[z].recipe
                        }
                    }
                end

                lib.registerContext({
                    id = v.menuName,
                    title = v.label,
                    options = Items
                })
            elseif v.id == 'cutting' then
                Items = {}
                for z = 1, #v.Items, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Items[z].recipe)

                    for o = 1, #v.Items[z].recipe, 1 do
                        description[z] = description[z] .. '\n' .. v.Items[z].recipe[o].label .. ' x' .. v.Items[z].recipe[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Items[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:Cutting',
                        args = {
                            item = v.Items[z].item,
                            recipe = v.Items[z].recipe
                        }
                    }
                end

                lib.registerContext({
                    id = v.menuName,
                    title = v.label,
                    options = Items
                })
            end
        end
    end
end

AddEventHandler('tj_restaurants:MakeDrink', function(data)
    if not onDuty then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not washedHands then
        lib.notify({
            title = locale('notify_title'),
            type = 'error'
        })
        return
    end

    RequestAnimDict("mp_ped_interaction")

    while not HasAnimDictLoaded("mp_ped_interaction") do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), "mp_ped_interaction", "handshake_guy_a", 8.0, -8.0, -1, 1, 0, false, false, false)

    local prosao = lib.skillCheck({'medium', 'medium'}, {'e'})

    if not prosao then
        lib.notify({
            title = locale('notify_title'),
            description = locale('make_juice_fail'),
            type = 'error'
        })
        ClearPedTasks(PlayerPedId())
        return
    end

    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        label = locale('making_drink'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
        },
        anim = {
            dict = 'mp_ped_interaction',
            clip = 'handshake_guy_a'
        },
    }) then
        ClearPedTasks(PlayerPedId())
        lib.callback.await('tj_restaurants:giveItem', function() end, data)
    end
end)


AddEventHandler('tj_restaurants:MakeFood', function(data)
    if not onDuty then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not washedHands then
        lib.notify({
            title = locale('notify_title'),
            label = locale('washing_hands_target'),
            type = 'error'
        })
        return
    end

    RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")

    while not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions") do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, -8.0, -1, 1, 0, false, false, false)

    local prosao = lib.skillCheck({'medium', 'medium'}, {'e'})

    if not prosao then
        lib.notify({
            title = locale('notify_title'),
            description = locale('make_food_fail'),
            type = 'error'
        })
        ClearPedTasks(PlayerPedId())
        return
    end

    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        label = locale('making_food'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
        },
    }) then
        ClearPedTasks(PlayerPedId())
        lib.callback.await('tj_restaurants:giveItem', function() end, data)
    end
end)

AddEventHandler('tj_restaurants:makeBBQ', function(data)
    if not onDuty then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not washedHands then
        lib.notify({
            title = locale('notify_title'),
            label = locale('washing_hands_target'),
            type = 'error'
        })
        return
    end

    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = locale('cooking_bbq'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
        },
        anim = {
            dict = 'amb@prop_human_bbq@male@base',
            clip = 'base'
        },
    }) then
        lib.callback.await('tj_restaurants:giveItem', function() end, data)
    end
end)

AddEventHandler('tj_restaurants:deepFryer', function(data)
    if not onDuty then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not washedHands then
        lib.notify({
            title = locale('notify_title'),
            label = locale('washing_hands_target'),
            type = 'error'
        })
        return
    end

    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = locale('deep_fryer'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
        },
        anim = {
            dict = 'rcmjosh1',
            clip = 'idle'
        },
    }) then
        lib.callback.await('tj_restaurants:giveItem', function() end, data)
    end
end)

AddEventHandler('tj_restaurants:Cutting', function(data)
    if not onDuty then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not washedHands then
        lib.notify({
            title = locale('notify_title'),
            label = locale('washing_hands_target'),
            type = 'error'
        })
        return
    end

    RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")

    while not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions") do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, -8.0, -1, 1, 0, false, false, false)

    local prosao = lib.skillCheck({'medium', 'medium'}, {'e'})

    if not prosao then
        lib.notify({
            title = locale('notify_title'),
            description = locale('cutting_fail'),
            type = 'error'
        })
        ClearPedTasks(PlayerPedId())
        return
    end

    if lib.progressCircle({
        duration = 10000,
        position = 'bottom',
        label = locale('cutting'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
        },
    }) then
        ClearPedTasks(PlayerPedId())
        lib.callback.await('tj_restaurants:giveItem', function() end, data)
    end
end)

RegisterNetEvent('tj_burgershot:duty')
AddEventHandler('tj_burgershot:duty', function()
    if onDuty then
        onDuty = false
        washedHands = false
        lib.notify({
            title = locale('notify_title'),
            description = locale('signed_out'),
            type = 'success'
        })
        TriggerServerEvent('tj_burgershot:sendDiscordLog', 'TJ Burgershot', 'Worker: ' .. GetPlayerName(PlayerId()) .. " signed off duty")
    elseif not onDuty then
        onDuty = true
        lib.notify({
            title = locale('notify_title'),
            description = locale('signed_in'),
            type = 'success'
        })
        TriggerServerEvent('tj_burgershot:sendDiscordLog', 'TJ Burgershot', 'Worker: ' .. GetPlayerName(PlayerId()) .. " signed on duty")
    end
end)

RegisterNetEvent('tj_burgershot:washHands')
AddEventHandler('tj_burgershot:washHands', function()
    RequestAnimDict('missheist_agency3aig_23')
    while not HasAnimDictLoaded('missheist_agency3aig_23') do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), 'missheist_agency3aig_23', 'urinal_sink_loop', 8.0, -8.0, -1, 49, 0, false, false, false)

    if lib.progressCircle({
        duration = 5000,
        label = locale('washing_hands'),
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
        },
    }) then
        ClearPedTasks(PlayerPedId())
        washedHands = true
        lib.notify({
            title = locale('notify_title'),
            description = locale('washed_hands'),
            type = 'success'
        })
        TriggerServerEvent('tj_burgershot:sendDiscordLog', 'TJ Burgershot', 'Worker: ' .. GetPlayerName(PlayerId()) .. " washed his hands")
    end
end)

local spawnedVehicles = {}

RegisterNetEvent('tj_burgershot:returnVehicle')
AddEventHandler('tj_burgershot:returnVehicle', function()
    local playerPed = PlayerPedId()
    local vozilo = GetVehiclePedIsIn(playerPed,false)
    local vehicleProps = ESX.Game.GetVehicleProperties(vozilo)
    local vehicleSpeed = math.floor((GetEntitySpeed(GetVehiclePedIsIn(playerPed, false))*3.6))
    if (vehicleSpeed > 45) then FreezeEntityPosition(vozilo, true) end
    TaskLeaveVehicle(playerPed, vozilo, 0)
    while IsPedInVehicle(playerPed, vozilo, true) do Wait(0) end
    Citizen.Wait(300)
    NetworkFadeOutEntity(vozilo, true, true)
    Citizen.Wait(100)
    ESX.Game.DeleteVehicle(vozilo)
end)

RegisterNetEvent('tj_burgershot:spawnCar')
AddEventHandler('tj_burgershot:spawnCar', function()
    local options = {}
    
    for i, vehicle in ipairs(Config.Vehicles) do
        table.insert(options, {
            title = vehicle.label,
            description = 'Spawn ' .. vehicle.label,
            icon = 'car',
            onSelect = function()
                SpawnVehicle(vehicle)
            end
        })
    end
    
    lib.registerContext({
        id = 'tj_burger_car_garage',
        title = locale('garage_title'),
        options = options
    })

    lib.showContext('tj_burger_car_garage') 
end)

function SpawnVehicle(vehicleData)
    local playerPed = PlayerPedId()    
    if	ESX.Game.IsSpawnPointClear(vector3(-1165.0553, -887.7554, 14.1464), 5.0) then
    ESX.Game.SpawnVehicle(vehicleData.model, vector3(Config.SpawnLocation.x, Config.SpawnLocation.y, Config.SpawnLocation.z), Config.SpawnLocation.w, function(vehicle)
        local playerPed = PlayerPedId()
        spawnedVehicles[vehicleData.model] = vehicle
        SetVehicleEngineOn(vehicle, false, false, true)
        SetVehicleDoorsLocked(vehicle, 1)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1) 
        lib.notify({
            title = locale('notify_title'),
            description = locale('car_spawn'):format(vehicleData.label),
            type = 'success'
        })
    end)
    else
        lib.notify({
            title = locale('notify_title'),
            description = locale('spawn_blocked'),
            type = 'error'
        })
    end
end



if Config.Target == 'ox' then
    exports.ox_target:addBoxZone({
        name = "Duty",
        coords = vec3(Config.Locations2.Duty.coords.x, Config.Locations2.Duty.coords.y, Config.Locations2.Duty.coords.z),
        size = vec3(Config.Locations2.Duty.size[1], Config.Locations2.Duty.size[2], Config.Locations2.Duty.maxZ - Config.Locations2.Duty.minZ),
        rotation = Config.Locations2.Duty.heading + 90,
        debug = false,
        options = {
            {
                event = "tj_burgershot:duty",
                icon = "fas fa-sign-in-alt",
                label = locale('duty_target'),
                groups = Config.Locations2.Duty.job,
            },
        },
        distance = 3.5
    })

    exports.ox_target:addBoxZone({
        name = "Washing",
        coords = vec3(Config.Locations2.WashingHands.coords.x, Config.Locations2.WashingHands.coords.y, Config.Locations2.WashingHands.coords.z),
        size = vec3(Config.Locations2.WashingHands.size[1], Config.Locations2.WashingHands.size[2], Config.Locations2.WashingHands.maxZ - Config.Locations2.WashingHands.minZ),
        rotation = Config.Locations2.WashingHands.heading + 90,
        debug = false,
        options = {
            {
                event = "tj_burgershot:washHands",
                icon = "fas fa-hands-bubbles",
                label = locale('washing_hands_target'),
                groups = Config.Locations2.WashingHands.job,
            },
        },
        distance = 1.5
    })

    exports.ox_target:addBoxZone({
        name = "Car",
        coords = vec3(Config.Locations2.CarSpawner.coords.x, Config.Locations2.CarSpawner.coords.y, Config.Locations2.CarSpawner.coords.z),
        size = vec3(Config.Locations2.CarSpawner.size[1], Config.Locations2.CarSpawner.size[2], Config.Locations2.CarSpawner.maxZ - Config.Locations2.CarSpawner.minZ),
        rotation = Config.Locations2.CarSpawner.heading + 90,
        debug = false,
        options = {
            {
                event = "tj_burgershot:spawnCar",
                icon = "fas fa-car",
                label = locale('car_garage'),
                groups = Config.Locations2.CarSpawner.job,
            },
            {
                event = "tj_burgershot:returnVehicle",
                icon = "fas fa-car",
                label = locale('return_vehcile'),
                groups = Config.Locations2.CarSpawner.job,
            },
        },
        distance = 1.5
    })
elseif Config.Target == 'qb' then
    exports['qb-target']:AddBoxZone("Duty", Config.Locations2.Duty.coords, Config.Locations2.Duty.size[1], Config.Locations2.Duty.size[2], {
        name = "Duty",
        heading = Config.Locations2.Duty.heading,
        debugPoly = false,
        minZ = Config.Locations2.Duty.minZ + 1,
        maxZ = Config.Locations2.Duty.maxZ + 1,
    }, {
        options = {
            {
                event = "tj_burgershot:duty",
                icon = "fas fa-sign-in-alt",
                label = locale('duty_target'),
                job = Config.Locations2.Duty.job,
            },
        },
        distance = 3.5
    })

    exports['qb-target']:AddBoxZone("Washing", Config.Locations2.WashingHands.coords, Config.Locations2.WashingHands.size[1], Config.Locations2.WashingHands.size[2], {
        name = "Washing",
        heading = Config.Locations2.WashingHands.heading,
        debugPoly = false,
        minZ = Config.Locations2.WashingHands.minZ + 1,
        maxZ = Config.Locations2.WashingHands.maxZ + 1,
    }, {
        options = {
            {
                event = "tj_burgershot:washHands",
                icon = "fas fa-hands-bubbles",
                label = locale('washing_hands_target'),
                job = Config.Locations2.WashingHands.job,
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("Car", Config.Locations2.WashingHands.coords, Config.Locations2.WashingHands.size[1], Config.Locations2.WashingHands.size[2], {
        name = "car",
        heading = Config.Locations2.WashingHands.heading,
        debugPoly = false,
        minZ = Config.Locations2.WashingHands.minZ + 1,
        maxZ = Config.Locations2.WashingHands.maxZ + 1,
    }, {
        options = {
            {
                event = "tj_burgershot:spawnCar",
                icon = "fas fa-car",
                label = locale('car_garage'),
                groups = Config.Locations2.CarSpawner.job,
            },
            {
                event = "tj_burgershot:returnVehicle",
                icon = "fas fa-car",
                label = locale('return_vehcile'),
                groups = Config.Locations2.CarSpawner.job,
            },
        },
        distance = 1.5
    })
end


local function OpenOrderMenu()
    if not onDuty then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not washedHands then
        lib.notify({
            title = locale('notify_title'),
            label = locale('washing_hands_target'),
            type = 'error'
        })
        return
    end
    TriggerServerEvent('tj_restaurants:getOrders')
end

local function ShowOrderDetails(order)
    local options = {}

    if order.items then
        for _, item in ipairs(order.items) do
            if item.name then
                table.insert(options, {
                    title = item.name,
                    icon = 'fas fa-box',
                })
            end
        end
    end

    table.insert(options, {
        title = locale('accept_order'),
        icon = 'fas fa-check',
        onSelect = function()
            TriggerServerEvent('tj_restaurants:acceptOrder', order.id)
        end
    })

    table.insert(options, {
        title = locale('close'),
        icon = 'fas fa-times',
        onSelect = function() end
    })

    lib.registerContext({
        id = 'order_details',
        title = locale('order_det'):format(order.id),
        options = options
    })
    lib.showContext('order_details')
end

RegisterNetEvent('tj_restaurants:receiveOrders')
AddEventHandler('tj_restaurants:receiveOrders', function(activeOrders)
    local options = {}
    for _, order in ipairs(activeOrders) do
        table.insert(options, {
            title = locale('order_det'):format(order.id),
            icon = 'fas fa-receipt',
            onSelect = function()
                ShowOrderDetails(order)
            end
        })
    end

    lib.registerContext({
        id = 'orders_menu',
        title = locale('active_orders'),
        options = options
    })
    lib.showContext('orders_menu')
end)


RegisterNetEvent('tj_restaurants:orderCreated')
AddEventHandler('tj_restaurants:orderCreated', function(orderId)
    SendNUIMessage({
        type = "showNotification",
        message = locale('order_number'):format(orderId),
        notificationType = "success"
    })
end)

RegisterNetEvent('tj_restaurants:orderAccepted')
AddEventHandler('tj_restaurants:orderAccepted', function(orderId)
    lib.notify({
        title = locale('order_accepted'),
        description = locale('order_accepted_desc'):format(orderId),
        type = 'success'
    })
end)

CreateThread(function()
    for _, orderloc in ipairs(Config.OrdersLoc) do
        local targetOptions = {}
        if Config.Target == 'ox' then
            exports.ox_target:addBoxZone({
                coords = orderloc.coords,
                size = orderloc.size,
                rotation = orderloc.rotation,
                options = {
                    {
                        name = 'open_order_menu',
                        icon = 'fas fa-clipboard-list',
                        label = locale('orders_menu'),
                        onSelect = OpenOrderMenu,
                        groups = orderloc.job,
                    }
                }
            })
        elseif Config.Target == 'qb' then
            exports['qb-target']:AddBoxZone('order_location', orderloc.coords, orderloc.size.x, orderloc.size.y, {
                name = 'order_location',
                heading = orderloc.rotation,
                debugPoly = false,
                minZ = orderloc.coords.z - (orderloc.size.z / 2),
                maxZ = orderloc.coords.z + (orderloc.size.z / 2),
            }, {
                options = {
                    {
                        name = 'open_order_menu',
                        icon = 'fas fa-clipboard-list',
                        label = locale('orders_menu'),
                        action = OpenOrderMenu,
                        job = orderloc.job,
                    }
                }
            })
        end
    end
end)

CreateThread(function()
    for _, station in ipairs(Config.Ordering) do
        local targetOptions = {}
        if Config.Target == 'ox' then
            exports.ox_target:addBoxZone({
                coords = station.coords,
                size = station.size,
                rotation = station.rotation,
                options = {
                    {
                        name = 'ordera',
                        icon = 'fas fa-clipboard-list',
                        label = locale('ordering_tablet'),
                        onSelect = toggleMenu,
                    }
                },
            })
        elseif Config.Target == 'qb' then
            exports['qb-target']:AddBoxZone('ordering_station', station.coords, station.size.x, station.size.y, {
                name = 'ordering_station',
                heading = station.rotation,
                debugPoly = false,
                minZ = station.coords.z - (station.size.z / 2),
                maxZ = station.coords.z + (station.size.z / 2),
            }, {
                options = {
                    {
                        name = 'ordera',
                        icon = 'fas fa-clipboard-list',
                        label = locale('ordering_tablet'),
                        action = toggleMenu,
                    }
                }
            })
        end
    end
end)

NapraviMenije()

local createdPeds = {}

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for k, v in pairs(Config.Ped) do
            local distance = #(playerCoords - vector3(v.coords.x, v.coords.y, v.coords.z))
            
            if distance < 50 and not createdPeds[k] then
                local pedHash = GetHashKey(v.model)
                
                RequestModel(pedHash)
                while not HasModelLoaded(pedHash) do
                    Wait(1)
                end
                
                local ped = CreatePed(4, pedHash, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, true)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                
                if v.scenario then
                    TaskStartScenarioInPlace(ped, v.scenario, 0, true)
                end
                
                createdPeds[k] = ped
            elseif distance >= 50 and createdPeds[k] then
                DeletePed(createdPeds[k])
                createdPeds[k] = nil
            end
        end
        Wait(1000)
    end
end)

-- wardrobe

CreateThread(function()
    RequestModel(GetHashKey(Config.wardrobePed))
    while not HasModelLoaded(GetHashKey(Config.wardrobePed)) do
        Wait(100)
    end

    wardrobePed = CreatePed(4, GetHashKey(Config.wardrobePed), Config.wardrobePedLoc.x, Config.wardrobePedLoc.y, Config.wardrobePedLoc.z, Config.wardrobePedLoc.w, false, true)
    FreezeEntityPosition(wardrobePed, true)
    SetEntityInvincible(wardrobePed, true)
    SetBlockingOfNonTemporaryEvents(wardrobePed, true)

    if Config.Target == 'qb' then
        exports['qb-target']:AddTargetEntity(wardrobePed, {
            options = {
                {
                    label = locale('wardrobe_target'),
                    job = Config.Locations2.Duty.job,
                    icon = 'fa-solid fa-shirt',
                    action = function()
                        OpenAppearanceMenu()
                    end,
                    canInteract = function()
                        return onDuty
                    end,
                }
            },
            distance = 2.5
        })
    elseif Config.Target == 'ox' then
        exports.ox_target:addLocalEntity(wardrobePed, {
            name = 'access_wardrobe',
            label = locale('wardrobe_target'),
            icon = 'fa-solid fa-shirt',
            groups = Config.Locations2.Duty.job,
            distance = 2.5,
            onSelect = function()
                OpenAppearanceMenu()
            end,
            canInteract = function()
                return onDuty
            end,
        })
    end
end)

function OpenAppearanceMenu()
    if Config.Appearance == 'qb' then
        TriggerEvent('qb-clothing:client:openMenu')
    elseif Config.Appearance == 'esx' then
        TriggerEvent('esx_skin:openMenu')
    elseif Config.Appearance == 'illenium' then
        TriggerEvent("illenium-appearance:client:openClothingShopMenu")
    elseif Config.Appearance == 'fivem' then
        TriggerEvent('fivem-appearance:client:openMenu')
    end
end

-- delivery

local deliveryPed = nil
local deliveryTargetPed = nil
local currentDeliveryLocation = nil
local currentDeliveryItems = {}
local targetType = Config.Target
local currentDeliveryPlayerSrc = nil 

CreateThread(function()
    RequestModel(GetHashKey(Config.DeliveryPedModel))
    while not HasModelLoaded(GetHashKey(Config.DeliveryPedModel)) do
        Wait(100)
    end

    deliveryPed = CreatePed(4, GetHashKey(Config.DeliveryPedModel), Config.DeliveryPedLocation.x, Config.DeliveryPedLocation.y, Config.DeliveryPedLocation.z, Config.DeliveryPedLocation.w, false, true)
    FreezeEntityPosition(deliveryPed, true)
    SetEntityInvincible(deliveryPed, true)
    SetBlockingOfNonTemporaryEvents(deliveryPed, true)
    if Config.Target == 'qb' then
        exports['qb-target']:AddTargetEntity(deliveryPed, {
            options = {
                {
                    label = locale('start_delivery_target'),
                    icon = 'fa-solid fa-burger',
                    job = Config.Locations2.Duty.job,
                    action = function(entity)
                        TriggerServerEvent('burgershot_delivery:startDelivery')
                    end,
                    canInteract = function()
                        return onDuty
                    end,
                },
                {
                    label = locale('return_veh'),
                    icon = 'fa-solid fa-car',
                    job = Config.Locations2.Duty.job,
                    action = function(entity)
                        ReturnVehicle()
                    end,
                    canInteract = function()
                        return onDuty
                    end,
                },
            },
            distance = 2.5
        })
    elseif Config.Target == 'ox' then
        exports.ox_target:addLocalEntity(deliveryPed, {
            {
                name = 'burgershot_delivery_start',
                label = locale('start_delivery_target'),
                icon = 'fa-solid fa-burger',
                distance = 2.5,
                groups = Config.Locations2.Duty.job,
                onSelect = function()
                    TriggerServerEvent('burgershot_delivery:startDelivery')
                end,
                canInteract = function()
                    return onDuty
                end,
            },
            {
                name = 'return_veh',
                label = locale('return_veh'),
                icon = 'fa-solid fa-car',
                distance = 2.5,
                groups = Config.Locations2.Duty.job,
                onSelect = function()
                    ReturnVehicle()
                end,
                canInteract = function()
                    return onDuty
                end,
            },
        })
        
    else
    end
end)

function ReturnVehicle()
    local playerCoords = GetEntityCoords(PlayerPedId())  
    local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 8.0, 0, 71)  

    if DoesEntityExist(vehicle) then  
        DeleteEntity(vehicle)
    else
        lib.notify({
            title = locale('vehicle_not_found')
        })
    end
end

RegisterNetEvent('burgershot_delivery:setDeliveryLocation', function(deliveryLocation, deliveryItems, playerSrc)
    currentDeliveryLocation = deliveryLocation
    currentDeliveryItems = deliveryItems
    currentDeliveryPlayerSrc = playerSrc

    lib.notify({
        title = locale('delivery_accepted'),
        type = 'success'
    })

    local model = GetHashKey(Config.DeliveryVehicle)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(100) end
    local vehicle = CreateVehicle(model, Config.DeliveryVehSpawnCoord.x, Config.DeliveryVehSpawnCoord.y, Config.DeliveryVehSpawnCoord.z, Config.DeliveryVehSpawnCoord.w, true, false)
    if DoesEntityExist(vehicle) then
        SetVehicleNumberPlateText(vehicle, "BURGERSHOT")
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetEntityAsMissionEntity(vehicle, true, true) 
        SetModelAsNoLongerNeeded(model)
    else
    end    

    SetNewWaypoint(deliveryLocation.x, deliveryLocation.y)

    CreateThread(function()
        local rngPed = math.random(1, #Config.DeliveryTargetPedModels)
        local buyerPed = GetHashKey(Config.DeliveryTargetPedModels[rngPed])

        RequestModel(buyerPed)
        while not HasModelLoaded(buyerPed) do
            Wait(100)
        end

        deliveryTargetPed = CreatePed(4, buyerPed, deliveryLocation.x, deliveryLocation.y, deliveryLocation.z, deliveryLocation.w, false, true)
        FreezeEntityPosition(deliveryTargetPed, true)
        SetEntityInvincible(deliveryTargetPed, true)
        SetBlockingOfNonTemporaryEvents(deliveryTargetPed, true)

        if Config.Target == 'qb' then
            exports['qb-target']:AddTargetEntity(deliveryTargetPed, {
                options = {
                    {
                        label = locale('deliver_target'),
                        job = Config.Locations2.Duty.job,
                        action = function(entity, player) 
                            local playerServerId = GetPlayerServerId(PlayerId())
                            if playerServerId == currentDeliveryPlayerSrc then
                                TriggerServerEvent('burgershot_delivery:completeDelivery', currentDeliveryPlayerSrc)
                            else
                            end
                        end
                    }
                },
                distance = 2.5
            })
        elseif Config.Target == 'ox' then
            exports.ox_target:addLocalEntity(deliveryTargetPed, {
                name = 'burgershot_delivery_complete',
                label = locale('deliver_target'),
                icon = 'fa-solid fa-burger',
                distance = 2.5,
                groups = Config.Locations2.Duty.job,
                onSelect = function()
                    local playerServerId = GetPlayerServerId(PlayerId())
                    if playerServerId == currentDeliveryPlayerSrc then
                        TriggerServerEvent('burgershot_delivery:completeDelivery', currentDeliveryPlayerSrc)
                    else
                    end
                end,
            })
        else
        end
    end)
end)

RegisterNetEvent('burgershot_delivery:deliveryCompleted', function(moneyReward)
    currentDeliveryLocation = nil
    currentDeliveryItems = {}
    currentDeliveryPlayerSrc = nil

    if DoesEntityExist(deliveryTargetPed) then
        DeletePed(deliveryTargetPed)
        deliveryTargetPed = nil
    end

    lib.notify({
        title = locale('delivery_completed'),
        type = 'success'
    })
end)

-- blip

local blip = AddBlipForCoord(Config.Ordering[1].coords.x, Config.Ordering[1].coords.y, Config.Ordering[1].coords.z)
SetBlipSprite(blip, 106)
SetBlipDisplay(blip, 4)
SetBlipScale(blip, 0.8)
SetBlipColour(blip, 5)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName('STRING')
AddTextComponentString(locale('blip_label'))
EndTextCommandSetBlipName(blip)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(createdPeds) do
            if DoesEntityExist(v) then
                DeletePed(v)
            end
        end
    end
end)