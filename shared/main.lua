Config = {
    Lokacije = { -- Locations for shops
        {
            label = 'Butcher',
            name = 'butcher_shop',
            Itemi = {
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
                job = 'vtigrovi',
                action = function()
                    exports.ox_inventory:openInventory('shop', { type = 'butcher_shop'})
                end
            },
        },
        {
            label = 'Veggies',
            name = 'veg_shop',
            Itemi = {
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
                job = 'vtigrovi',
                action = function()
                    exports.ox_inventory:openInventory('shop', { type = 'veg_shop'})
                end
            },
        }
    },

    Resotrani = {
        {
            job = 'burgershot', -- job required to access burgershot
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
                            exports.ox_inventory:openInventory('stash', 'burgershot_cookedfood')
                        end
                    },
                    label = 'Cooked food',
                    name = 'burgershot_cookedfood',
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
                            exports.ox_inventory:openInventory('stash', 'burgershot_readyfood')
                        end
                    },
                    label = 'Ready food',
                    name = 'burgershot_readyfood',
                    weight = 50000,
                    slots = 50,
                },
            },
            menu = { -- menu options
                {
                    id = 'drinks',
                    label = 'Pravljenje sokova',
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
                    Itemi = { -- items in menu
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
                    menuName = 'pravljenje_hrane',
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
                            lib.showContext('pravljenje_hrane')
                        end
                    },
                    Itemi = {
                        {
                            label = 'Bleeder',
                            item = 'bleeder',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-bleeder.png',
                            description = 'Best burger around the town with fresh ingridients',
                            recept = { -- recipe for making items
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
                            recept = {
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
                            recept = {
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
                            recept = {
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
                            recept = {
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
                    menuName = 'secenje',
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
                            lib.showContext('secenje')
                        end
                    },
                    Itemi = {
                        {
                            label = 'Slice potato',
                            item = 'cutpotato',
                            recept = {
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
                            recept = {
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
                            recept = {
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
                            recept = {
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
                    menuName = 'rostilj',
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
                            lib.showContext('rostilj')
                        end
                    },
                    Itemi = {
                        {
                            label = 'Burger patty',
                            item = 'cookedburgerpatty',
                            recept = {
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
                            recept = {
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
                    Itemi = {
                        {
                            label = 'Fries',
                            item = 'fries',
                            price = 15,
                            image = 'https://items.bit-scripts.com/images/food/burger-fries.png',
                            description = 'Fresh fries from organic potato',
                            recept = {
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
                            recept = {
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

Config.OrdersLoc = { -- locations for target for orders menu
    {
        coords = vector3(-1194.91, -893.2, 13.97),
        size = vec3(1.0, 1.0, 1.0),
        rotation = 345 
    },
}

Config.Ordering = { -- target location for ordering menu
    {
        coords = vector3(-1193.67, -894.62, 13.97),
        size = vec3(1.0, 2.0, 1.0),
        rotation = 300.0
    },
}

Config.Locations = { -- duty locations
    Duty = {
        coords = vec3(-1178.57, -897.04, 12.97),
        size = {1.0, 3.0},
        heading = 305.0,
        minZ = 10.77834,
        maxZ = 13.87834,
        job = "vtigrovi"
    },
    WashingHands = { -- washing hands locations
        coords = vec3(-1197.49, -902.69, 12.97),
        size = {1.0, 1.2},
        heading = 35.0,
        minZ = 10.77834,
        maxZ = 13.37834,
        job = "vtigrovi"
    }
}

