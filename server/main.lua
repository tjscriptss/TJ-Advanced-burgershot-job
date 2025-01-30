ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
    for i = 1, #Config.Resotrani, 1 do
        for j =1, #Config.Resotrani[i].stashovi, 1 do
            local v = Config.Resotrani[i].stashovi[j]
            exports.ox_inventory:RegisterStash(v.name, v.label, v.slots, v.weight)
        end
    end
    for i = 1, #Config.Lokacije, 1 do
        local v = Config.Lokacije[i]
        exports.ox_inventory:RegisterShop(v.name, {
            name = v.label,
            inventory = v.Itemi
        })
    end
end)

ESX.RegisterServerCallback('tj_restaurants:giveItem', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    if data.recept then
        for k,v in pairs(data.recept) do
            exports.ox_inventory:RemoveItem(xPlayer.source, v.name, v.amount)
        end
    end

    if data.item then
        xPlayer.addInventoryItem(data.item, 1)
    end
end)

lib.callback.register('tj_restaurants:checkItems', function(source, itemData)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    for k,v in pairs(itemData) do
        local item = xPlayer.getInventoryItem(v.name)
        if not item or item.count < tonumber(v.amount) then
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

    local xPlayer = ESX.GetPlayerFromId(source)

    local success = false
    
    if paymentMethod == 'cash' then
        if xPlayer.getMoney() >= totalPrice then
            xPlayer.removeMoney(totalPrice)
            success = true
        else
            return
        end
    elseif paymentMethod == 'card' then
        if xPlayer.getAccount('bank').money >= totalPrice then
            xPlayer.removeAccountMoney('bank', totalPrice)
            success = true
        else
            return
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
        exports.ox_inventory:AddItem(source, "receipt", 1, { 
            description = "Order number: #" .. orderId .. "\nPrice: $" .. orders[orderId].totalPrice
        }) 
        TriggerClientEvent('tj_restaurants:orderCreated', source, orderId)
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
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    orders = {}
    lastOrderId = 0
end)