ESX = exports['es_extended']:getSharedObject()
lib.locale()
local Items = {}
local description = {}
local prijavio = false
local opraoruke = false
PlayerData = {}

local isMenuOpen = false

local function toggleMenu()
    local items = {}

    if Config.Resotrani[1].menu[2].Itemi then
        for _, item in ipairs(Config.Resotrani[1].menu[2].Itemi) do
            table.insert(items, {
                label = item.label,
                item = item.item,
                description = item.description or 'not available',
                image = item.image or 'default-image-url.jpg',
                price = item.price or 0
            })
        end
    end

    if Config.Resotrani[1].menu[4].Itemi then
        for _, item in ipairs(Config.Resotrani[1].menu[5].Itemi) do
            table.insert(items, {
                label = item.label,
                item = item.item,
                description = item.description or 'not available',
                image = item.image or 'default-image-url.jpg',
                price = item.price or 0
            })
        end
    end

    if Config.Resotrani[1].menu[4].Itemi then
        for _, item in ipairs(Config.Resotrani[1].menu[1].Itemi) do
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
    for i = 1, #Config.Lokacije, 1 do
        local v = Config.Lokacije[i]
        exports.qtarget:AddBoxZone(v.name, v.target.coords, v.target.width, v.target.lenght, {
                name = v.name,
                heading = v.target.heading,
                debugPoly = false,
                minZ = v.target.minZ,
                maxZ = v.target.maxZ,
            }, 
            {   
                options = {
                    {
                        icon = v.target.icon,
                        label = v.target.label,
                        action = v.target.action,
                        job = v.target.job,
                        canInteract = function()
                            return prijavio and opraoruke end,
                    },
                },
                distance = 5.0
            }
        )
    end

    for i = 1, #Config.Resotrani, 1 do
        for j =1, #Config.Resotrani[i].stashovi, 1 do
            local v = Config.Resotrani[i].stashovi[j]
            exports.qtarget:AddBoxZone(v.name, v.target.coords, v.target.width, v.target.lenght, {
                    name = v.name,
                    heading = v.target.heading,
                    debugPoly = false,
                    minZ = v.target.minZ,
                    maxZ = v.target.maxZ,
                }, 
                {   
                    options = {
                        {
                            icon = v.target.icon,
                            label = v.target.label,
                            job = Config.Resotrani[i].job,
                            action = v.target.action,
                            canInteract = function()
                                return prijavio and opraoruke end,
                        },
                    },
                    distance = 5.0
                }
            )
        end

        for j =1, #Config.Resotrani[i].menu, 1 do
            local v = Config.Resotrani[i].menu[j]
            exports.qtarget:AddBoxZone(v.menuName, v.target.coords, v.target.width, v.target.lenght, {
                name = v.name,
                heading = v.target.heading,
                debugPoly = false,
                minZ = v.target.minZ,
                maxZ = v.target.maxZ,
            }, 
            {   
                options = {
                    {
                        icon = v.target.icon,
                        label = v.target.label,
                        job = Config.Resotrani[i].job,
                        action = v.target.action,
                        canInteract = function()
                            return prijavio and opraoruke end,
                    },
                },
                distance = 5.0
            })
        end
    end
end)

function NapraviMenije()
    for i = 1, #Config.Resotrani, 1 do
        for j =1, #Config.Resotrani[i].menu, 1 do
            local v = Config.Resotrani[i].menu[j]
            if v.id == 'drinks' then
                Items = {}
                for z =1, #v.Itemi, 1 do
                    Items[#Items + 1] = {
                        title = v.Itemi[z].label,
                        event = 'tj_restaurants:MakeDrink',
                        args = {
                            item = v.Itemi[z].item
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
                for z =1, #v.Itemi, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Itemi[z].recept)
            
                    for o = 1, #v.Itemi[z].recept, 1 do
                        description[z] = description[z] .. '\n' .. v.Itemi[z].recept[o].label .. ' x'.. v.Itemi[z].recept[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Itemi[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:MakeFood',
                        args = {
                            item = v.Itemi[z].item,
                            recept = v.Itemi[z].recept
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
                for z =1, #v.Itemi, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Itemi[z].recept)
            
                    for o = 1, #v.Itemi[z].recept, 1 do
                        description[z] = description[z] .. '\n' .. v.Itemi[z].recept[o].label .. ' x'.. v.Itemi[z].recept[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Itemi[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:makeBBQ',
                        args = {
                            item = v.Itemi[z].item,
                            recept = v.Itemi[z].recept
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
                for z =1, #v.Itemi, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Itemi[z].recept)
            
                    for o = 1, #v.Itemi[z].recept, 1 do
                        description[z] = description[z] .. '\n' .. v.Itemi[z].recept[o].label .. ' x'.. v.Itemi[z].recept[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Itemi[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:deepFryer',
                        args = {
                            item = v.Itemi[z].item,
                            recept = v.Itemi[z].recept
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
                for z =1, #v.Itemi, 1 do
                    description[z] = ''
                    local bool = lib.callback.await('tj_restaurants:checkItems', false, v.Itemi[z].recept)
            
                    for o = 1, #v.Itemi[z].recept, 1 do
                        description[z] = description[z] .. '\n' .. v.Itemi[z].recept[o].label .. ' x'.. v.Itemi[z].recept[o].amount
                    end
                    Items[#Items + 1] = {
                        title = v.Itemi[z].label,
                        description = description[z],
                        disabled = bool,
                        event = 'tj_restaurants:Cutting',
                        args = {
                            item = v.Itemi[z].item,
                            recept = v.Itemi[z].recept
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
    if not prijavio then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not opraoruke then
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
        ESX.TriggerServerCallback('tj_restaurants:giveItem', function() end, data)
    end
end)


AddEventHandler('tj_restaurants:MakeFood', function(data)
    if not prijavio then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not opraoruke then
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
            description = locale('make_bbq_fail'),
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
        ESX.TriggerServerCallback('tj_restaurants:giveItem', function() end, data)
    end
end)

AddEventHandler('tj_restaurants:makeBBQ', function(data)
    if not prijavio then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not opraoruke then
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
        prop = {
            model = `prop_tool_spatula`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
    }) then
        ESX.TriggerServerCallback('tj_restaurants:giveItem', function() end, data)
    end
end)

AddEventHandler('tj_restaurants:deepFryer', function(data)
    if not prijavio then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not opraoruke then
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
        ESX.TriggerServerCallback('tj_restaurants:giveItem', function() end, data)
    end
end)

AddEventHandler('tj_restaurants:Cutting', function(data)
    if not prijavio then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not opraoruke then
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
        ESX.TriggerServerCallback('tj_restaurants:giveItem', function() end, data)
    end
end)

RegisterNetEvent('trowe:duznost')
AddEventHandler('trowe:duznost', function()
    if prijavio then
        prijavio = false
        opraoruke = false
        lib.notify({
            title = locale('notify_title'),
            description = locale('signed_out'),
            type = 'success'
        })
    elseif not prijavio then
        prijavio = true
        lib.notify({
            title = locale('notify_title'),
            description = locale('signed_in'),
            type = 'success'
        })
    end
end)

RegisterNetEvent('trowe:periruke')
AddEventHandler('trowe:periruke', function()
    RequestAnimDict(missheist_agency3aig_23)
    while not HasAnimDictLoaded(missheist_agency3aig_23) do
        Wait(100)
    end
    
    TaskPlayAnim(PlayerPedId(), missheist_agency3aig_23, urinal_sink_loop, 8.0, -8.0, -1, 49, 0, false, false, false)
    
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
        opraoruke = true
        lib.notify({
            title = locale('notify_title'),
            description = locale('washed_hands'),
            type = 'success'
        })
    end
end)

exports.ox_target:addBoxZone({
	name = "Duty",
	coords = vec3(Config.Locations.Duty.coords.x, Config.Locations.Duty.coords.y, Config.Locations.Duty.coords.z),
	size = vec3(Config.Locations.Duty.size[1], Config.Locations.Duty.size[2], Config.Locations.Duty.maxZ - Config.Locations.Duty.minZ),
	rotation = Config.Locations.Duty.heading,
	debug = false,
	options = {
		{
			event = "trowe:duznost",
			icon = "fas fa-sign-in-alt",
			label = locale('duty_target'),
			job = Config.Locations.Duty.job,
		},
	},
	distance = 3.5
})

exports.ox_target:addBoxZone({
	name = "Washing",
	coords = vec3(Config.Locations.WashingHands.coords.x, Config.Locations.WashingHands.coords.y, Config.Locations.WashingHands.coords.z),
	size = vec3(Config.Locations.WashingHands.size[1], Config.Locations.WashingHands.size[2], Config.Locations.WashingHands.maxZ - Config.Locations.WashingHands.minZ),
	rotation = Config.Locations.WashingHands.heading,
	debug = false,
	options = {
		{
			event = "trowe:periruke",
			icon = "fas fa-hands-bubbles",
			label = locale('washing_hands_target'),
			job = Config.Locations.WashingHands.job,
		},
	},
	distance = 1.5
})


local function OpenOrderMenu()
    if not prijavio then
        lib.notify({
            title = locale('notify_title'),
            description = locale('not_signed_in'),
            type = 'error'
        })
        return
    elseif not opraoruke then
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
                    canInteract = function(entity, distance, coords, name)
                        return true
                    end
                }
            }
        })
    end
end)

CreateThread(function()
    for _, station in ipairs(Config.Ordering) do
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
                    canInteract = function(entity, distance, coords, name)
                        return true
                    end
                }
            }
        })
    end
end)
