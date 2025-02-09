if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qb' then
    QBCORE = exports['qb-core']:GetCoreObject()
end

local function ConvertToQBItems(items)
    local qbItems = {}
    for _, item in ipairs(items) do
        table.insert(qbItems, {
            name = item.name,
            amount = 9999, 
            price = item.price
        })
    end
    return qbItems
end

Citizen.CreateThread(function()
    for i = 1, #Config.Resotrani, 1 do
        for j = 1, #Config.Resotrani[i].stashovi, 1 do
            local v = Config.Resotrani[i].stashovi[j]
            if Config.Inventory == 'ox' then
                print('kreno')
                exports.ox_inventory:RegisterStash(v.name, v.label, v.slots, v.weight)
                print('nece')
            elseif Config.Inventory == 'qs' then
                exports['qs-inventory']:RegisterStash(v.name, v.label, v.slots, v.weight)
            end
        end
    end

    for i = 1, #Config.Locations, 1 do
        local v = Config.Locations[i]
        
        if Config.Inventory == 'ox' then
            exports.ox_inventory:RegisterShop(v.name, {
                name = v.label,
                inventory = v.Items
            })
        elseif Config.Inventory == 'qb' then
            local qbItems = ConvertToQBItems(v.Items) 
            exports['qb-inventory']:CreateShop({
                name = v.name,
                label = v.label,
                slots = #qbItems,
                items = qbItems
            })
        elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:RegisterShop(v.name, v.label, v.Itemi)
        end
    end
end)


local function getPlayer(source)
    if Config.Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Config.Framework == 'qb' then
        return QBCORE.Functions.GetPlayer(source)
    end
    return nil
end

lib.callback.register('tj_restaurants:giveItem', function(source, data)
    local xPlayer = getPlayer(source)
    if not xPlayer then return end

    if data.recipe then
        for k, v in pairs(data.recipe) do
            if Config.Inventory == 'ox' then
                exports.ox_inventory:RemoveItem(source, v.name, v.amount)
            elseif Config.Inventory == 'qb' then
                xPlayer.Functions.RemoveItem(v.name, v.amount) 
            elseif Config.Inventory == 'qs' then
                exports['qs-inventory']:RemoveItem(source, v.name, v.amount)
            end
        end
    end

    if data.item then
        if Config.Framework == 'esx' and Config.Inventory ~= 'qs' then
            xPlayer.addInventoryItem(data.item, 1)
        elseif Config.Framework == 'qb' and Config.Inventory ~= 'qs' then
            xPlayer.Functions.AddItem(data.item, 1)
        elseif Config.Framework == 'esx' or Config.Framework == 'qb' and Config.Inventory ~= 'qs' then
            exports['qs-inventory']:AddItem(source, data.item, 1)
        end
    end
end)

lib.callback.register('tj_restaurants:checkItems', function(source, itemData)
    local xPlayer = getPlayer(source)

    if not xPlayer then return false end  

    for k, v in pairs(itemData) do
        local item = nil

        if Config.Inventory == 'ox' then
            if Config.Framework == 'qb' then
                item = xPlayer.Functions.GetItemByName(v.name)
            elseif Config.Framework == 'esx' then
                item = xPlayer.getInventoryItem(v.name)
            end
        elseif Config.Inventory == 'qb' then
            item = xPlayer.Functions.GetItemByName(v.name)
        elseif Config.Inventory == 'qs' then
            item = exports['qs-inventory']:HasItem(source, v.name)  
        end

        if not item or (item.count or 0) < tonumber(v.amount) then
            return true  
        end
    end

    return false
end)


local orders = {}
local lastOrderId = 0

local function generateOrderId()
    lastOrderId = lastOrderId + 1
    return lastOrderId
end

RegisterServerEvent('tj_restaurants:createOrder')
AddEventHandler('tj_restaurants:createOrder', function(items, paymentMethod)
    if not items or #items == 0 then
        return
    end

    local totalPrice = 0

    for _, item in ipairs(items) do
        totalPrice = totalPrice + item.price
    end

    local xPlayer = getPlayer(source)

    local success = false

    if paymentMethod == 'cash' then
        if Config.Framework == 'esx' then
            if xPlayer.getMoney() >= totalPrice then
                xPlayer.removeInventoryItem('money', totalPrice)
                success = true
            end
        elseif Config.Framework == 'qb' and Config.Inventory == 'ox' then
            local cashBalance = exports.ox_inventory:Search(source, 'count', 'money') 
            if cashBalance >= totalPrice then
                exports.ox_inventory:RemoveItem(source, 'money', totalPrice) 
                success = true
            else
                return
            end
        elseif Config.Framework == 'qb' and Config.Inventory ~= 'ox' then
            if xPlayer.PlayerData.money.cash >= totalPrice then
                xPlayer.Functions.RemoveMoney('cash', totalPrice) 
                success = true
            end
        end
    elseif paymentMethod == 'card' then
        if Config.Framework == 'esx' then
            if xPlayer.getAccount('bank').money >= totalPrice then
                xPlayer.removeAccountMoney('bank', totalPrice)
                success = true
            end
        elseif Config.Framework == 'qb' then
            if xPlayer.PlayerData.money.bank >= totalPrice then
                xPlayer.Functions.RemoveMoney('bank', totalPrice) 
                success = true
            end
        end
    else
        return
    end

    if success then
        local orderId = generateOrderId()
        orders[orderId] = {
            id = orderId,
            items = items,
            totalPrice = totalPrice,
            status = 'pending'
        }

        local formattedItems = ""
        for _, item in pairs(items) do
            formattedItems = formattedItems .. item.name .. " - $" .. item.price .. "\n"
        end

        if Config.Inventory == 'ox' then
            exports.ox_inventory:AddItem(source, "receipt", 1, {
                description = "Order number: #" .. orderId .. " \nItems: " .. formattedItems .. " Price: $" .. orders[orderId].totalPrice 
            })
        elseif Config.Inventory == 'qb' then
            xPlayer.Functions.AddItem("receipt", 1, false, { 
                description = "Order number: #" .. orderId .. " \nItems: " .. formattedItems .. " Price: $" .. orders[orderId].totalPrice 
            })
        elseif Config.Inventory == 'qs' then
            exports['qs-inventory']:AddItem(source, "receipt", 1, nil, { 
                "Order number: #" .. orderId .. " \nItems: " .. formattedItems .. " Price: $" .. orders[orderId].totalPrice 
            })
        end
        TriggerClientEvent('tj_restaurants:orderCreated', source, orderId)
        SendDiscordLog("TJ Burgershot", "New order created. \nItems: " .. formattedItems .. "\n Player name: " .. GetPlayerName(source) .. "\n Total price: " .. totalPrice)
    else
    end
end)

RegisterServerEvent('tj_restaurants:getOrders')
AddEventHandler('tj_restaurants:getOrders', function()
    local activeOrders = {}
    for id, order in pairs(orders) do
        if order.status == 'pending' then
            table.insert(activeOrders, order)
        end
    end
    TriggerClientEvent('tj_restaurants:receiveOrders', source, activeOrders)
end)

RegisterServerEvent('tj_restaurants:acceptOrder')
AddEventHandler('tj_restaurants:acceptOrder', function(orderId)
    if orders[orderId] then
        orders[orderId].status = 'accepted'
        TriggerClientEvent('tj_restaurants:orderAccepted', source, orderId)
        SendDiscordLog("TJ Burgershot", "Order accepted. \nOrder ID: " .. orderId .. "\nWorker name: " .. GetPlayerName(source))
    end
end)

RegisterNetEvent('tj_burgershot:openShop', function(shopName)
    if Config.Inventory == 'qb' then
        exports['qb-inventory']:OpenShop(source, shopName)
    elseif Config.Inventory == 'qs' then
        exports['qs-inventory']:OpenShop(source, shopName)
    end
end)

RegisterServerEvent('tj_burgershot:openStash', function(stashName)
    if Config.Inventory == 'qb' then
        exports['qb-inventory']:OpenInventory(source, stashName)
    elseif Config.Inventory == 'qs' then
        exports['qs-inventory']:OpenStash(source, stashName)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= 'tj_burgershot') then
        while true do
            print("Don't change name of the script or else it won't work")
            Wait(1000)
        end
        return
    end
    orders = {}
    lastOrderId = 0
end)

-- logs

function SendDiscordLog(title, description, color)
    local embed = {
        {
            ["color"] = Config.LogColor or 5592405,
            ["title"] = title,
            ["description"] = description,
            ["thumbnail"] = {
                ["url"] = Config.DiscordLogo
            },
            ["footer"] = {
                ["text"] = os.date("%c")
            }
        }
    }

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = 'Admin Menu Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('tj_burgershot:sendDiscordLog')
AddEventHandler('tj_burgershot:sendDiscordLog', function(title, description)
    SendDiscordLog(title, description)
end)