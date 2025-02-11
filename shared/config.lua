Config = {
    Locations = { -- Locations for shops
        {
            label = 'Butcher',
            name = 'butcher_shop',
            Items = {
                { label = 'Burger patty', name = 'rawburgerpatty', price = 1 },
                { label = 'Vegan burger patty', name = 'veganburgerpatty', price = 2},
                { label = 'Vegan burger patty', name = 'nuggets', price = 1},
            },
            target = {
                coords = vector3(-1199.84, -904.07, 12.97),
                width = 1.0,
                lenght = 2.0,
                heading = 305,
                minZ = 10.56,
                maxZ = 13.56,
                icon = 'fa-solid fa-box',
                label = 'Open freezer',
                job = 'vagos',
                action = function()
                    if Config.Inventory == 'ox' then
                        exports.ox_inventory:openInventory('shop', { type = 'butcher_shop'})
                    elseif Config.Inventory == 'qb' then
                        TriggerServerEvent('tj_burgershot:openShop', 'butcher_shop')
                    elseif Config.Inventory == 'qs' then
                        TriggerServerEvent('tj_burgershot:openShop', 'butcher_shop')
                    end
                end
            },
        },
        {
            label = 'Veggies',
            name = 'veg_shop',
            Items = {
                { label = 'Potato', name = 'potato', price = 0.2 },
                { label = 'Onion', name = 'onion', price = 0.1 },
                { label = 'Toamto', name = 'tomato', price = 0.3 },
                { label = 'Burger bun', name = 'burgerbun', price = 0.8 },
                { label = 'Cheddar', name = 'cheddar', price = 1 },
                { label = 'Lettuce', name = 'lettuce', price = 0.4 },
            },
            target = {
                coords = vector3(-1201.41, -901.64, 13.97),
                width = 1.0,
                lenght = 4.2,
                heading = 305,
                minZ = 11.97,
                maxZ = 14.97,
                icon = 'fa-solid fa-box',
                label = 'Open fridge',
                job = 'vagos',
                action = function()
                    if Config.Inventory == 'ox' then
                        exports.ox_inventory:openInventory('shop', { type = 'veg_shop'})
                    elseif Config.Inventory == 'qb' then
                        TriggerServerEvent('tj_burgershot:openShop', 'veg_shop')
                    elseif Config.Inventory == 'qs' then
                        TriggerServerEvent('tj_burgershot:openShop', 'butcher_shop')
                    end
                end
            },
        }
    },

    Resotrani = {
        {
            job = 'vagos', -- job required to access burgershot
            stashovi = { -- stashes
                {
                    target = {
                        coords = vector3(-1199.65, -895.84, 12.97),
                        width = 1.0,
                        lenght = 1.4,
                        heading = 35,
                        minZ = 10.97,
                        maxZ = 13.97,
                        icon = 'fa-solid fa-box',
                        label = 'Cooked food',
                        action = function()
                            if Config.Inventory == 'ox' then
                                exports.ox_inventory:openInventory('stash', { id = 'CookedFood'})
                            elseif Config.Inventory == 'qb' then
                                local namee = "burgershootCooked"
                                TriggerServerEvent('tj_burgershot:openStash', 'CookedFood')
                            elseif Config.Inventory == 'qs' then
                                TriggerServerEvent('tj_burgershot:openStash', 'CookedFood')
                            end
                        end
                    },
                    label = 'Cooked food',
                    name = 'CookedFood',
                    weight = 50000,
                    slots = 50,
                },
                {
                    target = {
                        coords = vector3(-1195.34, -897.48, 13.97),
                        width = 1.2,
                        lenght = 3.4,
                        heading = 305,
                        minZ = 11.85,
                        maxZ = 14.05,
                        icon = 'fa-solid fa-box',
                        label = 'Ready food',
                        action = function()
                            if Config.Inventory == 'ox' then
                                exports.ox_inventory:openInventory('stash', { id = 'ReadyFood'})
                            elseif Config.Inventory == 'qb' then
                                TriggerServerEvent('tj_burgershot:openStash', 'ReadyFood')
                            elseif Config.Inventory == 'qs' then
                                TriggerServerEvent('tj_burgershot:openStash', 'CookedFood')
                            end
                        end
                    },
                    label = 'Ready food',
                    name = 'ReadyFood',
                    weight = 50000,
                    slots = 50,
                },
                -- {
                --     target = {
                --         coords = vector3(-1195.34, -897.48, 13.97),
                --         width = 1.2,
                --         lenght = 3.4,
                --         heading = 305,
                --         minZ = 11.85,
                --         maxZ = 14.05,
                --         icon = 'fa-solid fa-box',
                --         label = 'Counter',
                --         action = function()
                --             if Config.Inventory == 'ox' then
                --                 exports.ox_inventory:openInventory('stash', { id = 'counter'})
                --             elseif Config.Inventory == 'qb' then
                --                 TriggerServerEvent('tj_burgershot:openStash', 'counter')
                --             elseif Config.Inventory == 'qs' then
                --                 TriggerServerEvent('tj_burgershot:openStash', 'counter')
                --             end
                --         end
                --     },
                --     label = 'Ready food',
                --     name = 'counter',
                --     weight = 50000,
                --     slots = 10,
                -- },
            },
            menu = { -- menu options
                {
                    id = 'drinks',
                    label = 'Drinks menu',
                    menuName = 'drinksMenu',
                    target = {
                        coords = vector3(-1197.12, -894.28, 13.97),
                        width = 1.0,
                        lenght = 2.2,
                        heading = 305,
                        minZ = 11.97,
                        maxZ = 14.97,
                        icon = 'fa-solid fa-box',
                        label = 'Make drink',
                        action = function()
                            NapraviMenije()
                            lib.showContext('drinksMenu')
                        end
                    },
                    Items = { -- items in menu
                        {
                            label = 'Coke',
                            item = 'bscoke',
                            price = 5,
                            image = 'https://items.bit-scripts.com/images/drinks/burger-softdrink2.png',
                            description = 'Best drink in the town',
                        },
                        {
                            label = 'Coffee',
                            item = 'bscoffee',
                            price = 5,
                            image = 'https://items.bit-scripts.com/images/food/burger-coffee.png',
                            description = 'Best coffee in the town',
                        },
                        {
                            label = 'Milkshake',
                            item = 'milkshake',
                            price = 5,
                            image = 'https://items.bit-scripts.com/images/food/burger-milkshake.png',
                            description = 'Best milkshake in the town',
                        }
                    }
                },
                {
                    id = 'food',
                    label = 'Make food',
                    menuName = 'making_food',
                    target = {
                        coords = vector3(-1196.66, -899.33, 12.97),
                        width = 1.0,
                        lenght = 3.2,
                        heading = 35,
                        minZ = 10.97,
                        maxZ = 13.97,
                        icon = 'fa-solid fa-box',
                        label = 'Make food',
                        action = function()
                            NapraviMenije()
                            lib.showContext('making_food')
                        end
                    },
                    Items = {
                        {
                            label = 'Bleeder',
                            item = 'bleeder',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-bleeder.png',
                            description = 'Best burger around the town with fresh ingridients',
                            recipe = { -- recipe for making items
                                {
                                    label = 'Burger bun',
                                    name = 'burgerbun',
                                    amount = 1,
                                },
                                {
                                    label = 'Burger patty',
                                    name = 'cookedburgerpatty',
                                    amount = 1,
                                },
                                {
                                    label = 'Sliced lettuce',
                                    name = 'cutlettuce',
                                    amount = 2,
                                },
                                {
                                    label = 'Cheddar cheese',
                                    name = 'cheddar',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced tomato',
                                    name = 'cuttomato',
                                    amount = 2,
                                }
                            }
                        },
                        {
                            label = 'Heart stopper',
                            item = 'heartstopper',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-heartstopper.png',
                            description = 'Best burger around the town with fresh ingridients',
                            recipe = {
                                {
                                    label = 'Burger bun',
                                    name = 'burgerbun',
                                    amount = 1,
                                },
                                {
                                    label = 'Burger patty',
                                    name = 'cookedburgerpatty',
                                    amount = 4,
                                },
                                {
                                    label = 'Sliced lettuce',
                                    name = 'cutlettuce',
                                    amount = 3,
                                },
                                {
                                    label = 'Cheddar cheese',
                                    name = 'cheddar',
                                    amount = 5,
                                },
                                {
                                    label = 'Sliced tomato',
                                    name = 'cuttomato',
                                    amount = 3,
                                },
                            }
                        },
                        {
                            label = 'Vegan burger',
                            item = 'meatfree',
                            price = 7,
                            image = 'https://items.bit-scripts.com/images/food/dbl_hornburger.png',
                            description = 'Best burger around the town with fresh ingridients',
                            recipe = {
                                {
                                    label = 'Burger bun',
                                    name = 'burgerbun',
                                    amount = 1,
                                },
                                {
                                    label = 'Burger patty',
                                    name = 'cookedveganburgerpatty',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced lettuce',
                                    name = 'cutlettuce',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced tomato',
                                    name = 'cuttomato',
                                    amount = 1,
                                },
                            }
                        },
                        {
                            label = 'Torpedo',
                            item = 'torpedo',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-torpedo.png',
                            description = 'Best burger around the town with fresh ingridients',
                            recipe = {
                                {
                                    label = 'Burger bun',
                                    name = 'burgerbun',
                                    amount = 1,
                                },
                                {
                                    label = 'Burger patty',
                                    name = 'cookedburgerpatty',
                                    amount = 1,
                                },
                                {
                                    label = 'Sliced tomato',
                                    name = 'cuttomato',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced onion',
                                    name = 'cutonion',
                                    amount = 2,
                                },
                            }
                        },
                        {
                            label = 'Moneyshot burger',
                            item = 'moneyshot',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-moneyshot.png',
                            description = 'Best burger around the town with fresh ingridients',
                            recipe = {
                                {
                                    label = 'Burger bun',
                                    name = 'burgerbun',
                                    amount = 1,
                                },
                                {
                                    label = 'Burger patty',
                                    name = 'cookedburgerpatty',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced tomato',
                                    name = 'cuttomato',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced onion',
                                    name = 'cutonion',
                                    amount = 2,
                                },
                                {
                                    label = 'Sliced lettuce',
                                    name = 'cutlettuce',
                                    amount = 2,
                                },
                                {
                                    label = 'Cheddar cheese',
                                    name = 'cheddar',
                                    amount = 2,
                                },
                            },
                        },
                    },
                },
                {
                    id = 'cutting',
                    label = 'Cutting board',
                    menuName = 'cuttingBoard',
                    target = {
                        coords = vector3(-1197.42, -898.25, 12.97),
                        width = 1.0,
                        lenght = 3.2,
                        heading = 35,
                        minZ = 10.97,
                        maxZ = 13.97,
                        icon = 'fa-solid fa-box',
                        label = 'Cutting board',
                        action = function()
                            NapraviMenije()
                            lib.showContext('cuttingBoard')
                        end
                    },
                    Items = {
                        {
                            label = 'Slice potato',
                            item = 'cutpotato',
                            recipe = {
                                {
                                    label = 'Potato',
                                    name = 'potato',
                                    amount = 1,
                                }
                            }
                        },
                        {
                            label = 'Slice onion',
                            item = 'cutonion',
                            recipe = {
                                {
                                    label = 'Onion',
                                    name = 'onion',
                                    amount = 1,
                                }
                            }
                        },
                        {
                            label = 'Slice tomato',
                            item = 'cuttomato',
                            recipe = {
                                {
                                    label = 'Tomato',
                                    name = 'tomato',
                                    amount = 1,
                                }
                            }
                        },
                        {
                            label = 'Slice lettuce',
                            item = 'cutlettuce',
                            recipe = {
                                {
                                    label = 'Lettuce',
                                    name = 'lettuce',
                                    amount = 1,
                                }
                            }
                        },
                    },
                },
                {
                    id = 'cooking',
                    label = 'BBQ',
                    menuName = 'bbq',
                    target = {
                        coords = vector3(-1198.31, -894.97, 12.97),
                        width = 1.2,
                        lenght = 2.0,
                        heading = 35,
                        minZ = 10.97,
                        maxZ = 13.97,
                        icon = 'fa-solid fa-box',
                        label = 'BBQ',
                        action = function()
                            NapraviMenije()
                            lib.showContext('bbq')
                        end
                    },
                    Items = {
                        {
                            label = 'Burger patty',
                            item = 'cookedburgerpatty',
                            recipe = {
                                {
                                    label = 'Raw burger patty',
                                    name = 'rawburgerpatty',
                                    amount = 1,
                                },
                            }
                        },
                        {
                            label = 'Vegan Burger patty',
                            item = 'cookedveganburgerpatty',
                            recipe = {
                                {
                                    label = 'Raw vegan patty',
                                    name = 'veganburgerpatty',
                                    amount = 1,
                                },
                            }
                        },
                    },
                },
                {
                    id = 'deepfryer',
                    label = 'Deep fryer',
                    menuName = 'deepFryer',
                    target = {
                        coords = vector3(-1200.97, -896.72, 12.97),
                        width = 1.0,
                        lenght = 2.0,
                        heading = 35,
                        minZ = 10.97,
                        maxZ = 13.97,
                        icon = 'fa-solid fa-box',
                        label = 'Deep fryer',
                        action = function()
                            NapraviMenije()
                            lib.showContext('deepFryer')
                        end
                    },
                    Items = {
                        {
                            label = 'Fries',
                            item = 'fries',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-fries.png',
                            description = 'Fresh fries from organic potato',
                            recipe = {
                                {
                                    label = 'Cutted potato',
                                    name = 'cutpotato',
                                    amount = 1,
                                },
                            }
                        },
                        {
                            label = 'Chicken nuggets',
                            item = 'cookednuggets',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-shotnuggets.png',
                            description = 'Tasty chicken nuggets',
                            recipe = {
                                {
                                    label = 'Raw chicken nuggets',
                                    name = 'nuggets',
                                    amount = 1,
                                },
                            }
                        },
                    },
                },
            }
        }
    }
}

Config.Framework = 'esx' -- 'esx' or 'qb'

Config.Inventory = 'ox' -- 'ox', 'qb' or 'qs' (qs is not teste so if you find and issue, contact us on discord: https://discord.gg/tbSF4N7eCb)

Config.Target = 'ox' -- 'qb' or 'ox'

Config.Appearance = 'illenium' -- 'illenium', 'esx', 'qb', 'fivem'

Config.OrdersLoc = { -- locations for target for orders menu
    {
        coords = vector3(-1194.91, -893.2, 13.97),
        size = vec3(1.0, 1.0, 1.0),
        rotation = 345,
        job = "burgershot"
    },
}

Config.Ordering = { -- target location for ordering menu
    {
        coords = vector3(-1193.67, -894.62, 13.97),
        size = vec3(1.0, 2.0, 1.0),
        rotation = 300.0,
    },
}

Config.Locations2 = { -- duty locations
    Duty = {
        coords = vec3(-1178.57, -897.04, 12.97),
        size = {1.0, 3.0},
        heading = 305.0,
        minZ = 10.77834,
        maxZ = 13.87834,
        job = 'vagos'
    },
    WashingHands = { -- washing hands locations
        coords = vec3(-1197.49, -902.69, 12.97),
        size = {1.0, 1.2},
        heading = 35.0,
        minZ = 10.77834,
        maxZ = 13.37834,
        job = 'vagos'
    },
    CarSpawner = { -- washing hands locations
        coords = vec3(-1169.934, -887.13, 14.03),
        size = {1.0, 1.2},
        heading = 120.80,
        minZ = 13.03,
        maxZ = 15.03,
        job = 'vagos'
    }
}

Config.Ped = { -- Ped for spawning vehicles
    {
        model = "csb_burgerdrug", 
        coords = vector4(-1169.9337, -887.1362, 14.0332, 120.8001),
        scenario = "WORLD_HUMAN_CLIPBOARD_FACILITY" 
    }
}

Config.SpawnLocation = vector4(-1167.0641, -888.6570, 13.0823, 125.0107) -- spawn loc for vehicles

Config.Vehicles = {
    {
        label = "Boxville",
        model = "boxville4"
    },
}

Config.DeliveryPedModel = "mp_m_shopkeep_01"
Config.DeliveryPedLocation = vector4(-1165.7096, -894.6837, 13.0244, 70.5930)
Config.DeliveryLocations = {
    vector4(-1384.5693, -976.7947, 7.9136, 301.6556), 
    vector4(850.5987, -532.6941, 56.9253, 266.6503), 
    vector4(967.1749, -451.5533, 61.7896, 217.7704), 
    vector4(976.5381, -580.3713, 58.8557, 30.6271), 
    vector4(1138.8711, -773.4993, 56.6444, 357.1865), 
    vector4(-2008.6937, 367.3537, 93.8143, 270.2294), 
    vector4(-1942.8223, 449.6412, 101.9280, 102.8495), 
    vector4(-1974.5514, 630.9545, 121.5362, 245.4470), 
    vector4(-1405.9438, 527.0224, 122.8312, 4.3520), 
}
Config.DeliveryTargetPedModels = {
    "a_f_m_fatbla_01", 
    "a_m_m_business_01",
    "s_m_m_ammucountry", 
}


Config.DeliveryItems = {
    "bleeder",
    "bscoke",
    "fries",
    "cookednuggets",
    "fries",
    "moneyshot",
    "torpedo",
    "meatfree",
    "heartstopper",
    "milkshake",
    "bscoffee"
}

Config.DeliveryMoney = { min = 500, max = 1000 }

Config.DeliveryVehSpawnCoord = vector4(-1163.8986, -891.1992, 13.1227, 123.5508)

Config.DeliveryVehicle = "boxville4"

Config.wardrobePed = "a_m_y_clubcust_01"
Config.wardrobePedLoc = vector4(-1181.5082, -900.6182, 12.9742, 30.2500)

-- Logs

Config.DiscordWebhook = 'https://discord.com/api/webhooks/1338146656771772426/jR4U88Iyvxy98AjXbt3VXRDt9b9M8DxoVjMgZ0AsvKcDkTKyUqmVSbpUjiWSMvrTV8DU' -- Paste your discord webhook here

Config.DiscordLogo = 'https://i.postimg.cc/y8hWKkBS/logoTJ.webp' -- Paste url for your logo

Config.LogColor = 2123412 -- Here you can change color of logs (https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812)