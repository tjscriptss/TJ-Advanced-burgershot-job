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