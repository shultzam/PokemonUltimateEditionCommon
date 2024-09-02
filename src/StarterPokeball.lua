local pokeballs = { "ec1e4b", "9c4411", "c988ea", "2cf16d", "986cb5", "f66036", "e46f90" }
local evoPokeballs = { "757125", "6fd4a0", "23f409", "caf1c8", "35376b", "f353e7", "68c4b0" }
local gyms = { "20bcd5", "ec01e5", "f2f4fe", "d8dc51", "b564fd", "22cc88", "c4bd30", "c9dd73" }

local gen1Pokeballs = { "681d76", "d7d981", "818525", "30391b", "758036", "bb73fd", "78fdbb" }
local gen1EvoPokeballs = { "e9d043", "7de53d", "f30baf", "ceb9a5", "5293ec", "98bf25", "01efbd" }
local gen1LeadersArr = { "1adc9d", "8b26e1", "3ddf5f", "c3b5fb" }

local gen2Pokeballs = { "d87f03", "2fd969", "2c76f4", "710bab", "521e8b", "9f4fb9", "f5d806" }
local gen2EvoPokeballs = { "c6e80b", "d86df8", "f59319", "538c67", "6f201a", "ad0f19", "02db20" }
local gen2LeadersArr = { "d6be18", "c3650f", "ec20b2", "e68807" }

local gen3Pokeballs = { "e05c61", "b3ede1", "80c3c3", "5ded3e", "4f4570", "ee7d71", "feea6b" }
local gen3EvoPokeballs = { "31b1ec", "9b3ecb", "613cb1", "1b49a8", "8d3dfb", "fd9bcb", "1bf5ba" }
local gen3LeadersArr = { "797253", "61d7e4", "2a9746", "a926ef" }

local gen4Pokeballs = { "be7627", "8079e7", "49e675", "f7a234", "fadfc3", "a63903", "9f5985" }
local gen4EvoPokeballs = { "cccfb4", "e15056", "24a5c8", "a7d340", "bfb915", "7eb6b9", "96a1c9" }
local gen4LeadersArr = { "d6b981", "9b50d1", "537124", "e98f45" }

local gen5Pokeballs = { "291a17", "890df4", "1341cb", "6ee713", "de1f71", "48a192", "296ec5" }
local gen5EvoPokeballs = { "db9cda", "425115", "aefa83", "cb4ad6", "e16953", "8abcf1", "59de2d" }
local gen5LeadersArr = { "cd0374", "fe76e1", "3869d0", "524ba4" }

local gen6Pokeballs = { "590ae3", "d80d72", "ce15ef", "9fe972", "7f1ebb", "401e23", "1fa353" }
local gen6EvoPokeballs = { "315a95", "f02e17", "943c81", "c67911", "de7f1f", "750e11", "21b1c8" }
local gen6LeadersArr = { "150632", "c85052", "ba0a27", "5498d4" }

local gen7Pokeballs = { "426038", "b3a265", "a77d5e", "44c820", "4903d2", "652a56", "405d8e" }
local gen7EvoPokeballs = { "6d2737", "2b7b9b", "79e3f4", "21ba50", "74eeff", "432142", "79ee2f" }
local gen7LeadersArr = { "58ca45", "157ff9", "eeba9c", "72fcef" }

local gen8Pokeballs = { "307988", "09cb0e", "99b8aa", "d6ef76", "0faf4d", "ad4ceb", "a1750a" }
local gen8EvoPokeballs = { "bc1673", "4f7b73", "2d873a", "a32b0d", "d2b2ca", "637026", "02689f" }
local gen8LeadersArr = { "227356", "b47fe7", "8e8fd2", "96992a" }

local gen9Pokeballs = { "3168f8", "de981e", "7ced83", "345260", "d63e7c", "3fcea5", "79df8a" }
local gen9EvoPokeballs = { "9c010b", "03ea82", "4217d6", "6ae5c4", "8963b5", "0dc3f5", "4e3f1d" }
local gen9LeadersArr = { "e4988b", "7269d7", "80f567", "6f3326" }

local customPokeballs = { "a927cf", "acd90d", "63bb92", "88b157", "8aaeef", "915bb4", "47780a" }
local customEvoPokeballs = { "95fee8", "8a1c9a", "7f2cd7", "0d33b3", "8faab4" }
local customLeadersArr = { "ab33b9", "f6be1f", "be2f56", "94584c" }

-- The Starter Pokeball should be placed at {0, 2.69, 34}.
local buttonRelativePosition = { 0, -1, 2.3 }

local setup_done = false

-- Custom Gym Leader Options.
local NONE_SELECT = 0
local ALLOW_SELECT = 1
local ALWAYS_SELECT = 2

function onSave()
    return JSON.encode({settings_done=setup_done})
end

function onLoad(saved_data)
    -- Check for saved settings.
    local save_table
    if saved_data and saved_data ~= "" then
        save_table = JSON.decode(saved_data)
    end

    if save_table then
        setup_done = save_table.settings_done
    end

    -- Safety check on fields.
    if setup_done == nil then
        setup_done = false
    end

    if setup_done then
        self.createButton({ --Apply settings button
            label = "Start Game",
            click_function = "start",
            function_owner = self,
            tooltip = "Click to start game. Only click this when every player has a starter Pokémon.",
            position = buttonRelativePosition,
            rotation = { 0, 0, 0 },
            height = 600,
            width = 2000,
            font_size = 300,
        })
    else
        self.createButton({ --Apply settings button
            label = "Settings",
            click_function = "settings",
            function_owner = self,
            tooltip = "Setup Game",
            position = buttonRelativePosition,
            rotation = { 0, 0, 0 },
            height = 600,
            width = 2000,
            font_size = 300,
        })
    end
end

function beginSetup2(params)
    -- tokens
    if params.selectedGens[1] then
        setupPokeballs(gen1Pokeballs, pokeballs)
        setupPokeballs(gen1EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[2] then
        setupPokeballs(gen2Pokeballs, pokeballs)
        setupPokeballs(gen2EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[3] then
        setupPokeballs(gen3Pokeballs, pokeballs)
        setupPokeballs(gen3EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[4] then
        setupPokeballs(gen4Pokeballs, pokeballs)
        setupPokeballs(gen4EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[5] then
        setupPokeballs(gen5Pokeballs, pokeballs)
        setupPokeballs(gen5EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[6] then
        setupPokeballs(gen6Pokeballs, pokeballs)
        setupPokeballs(gen6EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[7] then
        setupPokeballs(gen7Pokeballs, pokeballs)
        setupPokeballs(gen7EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[8] then
        setupPokeballs(gen8Pokeballs, pokeballs)
        setupPokeballs(gen8EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[9] then
        setupPokeballs(gen9Pokeballs, pokeballs)
        setupPokeballs(gen9EvoPokeballs, evoPokeballs)
    end

    if params.customGen then
        setupPokeballs(customPokeballs, pokeballs)
        setupPokeballs(customEvoPokeballs, evoPokeballs)
    end

    local blueRack = getObjectFromGUID("b366ea")
    local greenRack = getObjectFromGUID("517511")
    local orangeRack = getObjectFromGUID("341ead")
    local purpleRack = getObjectFromGUID("a990ef")
    local redRack = getObjectFromGUID("06c308")
    local yellowRack = getObjectFromGUID("fc9c59")
    local reversiChip = getObjectFromGUID("97021e")

    local genParams = {
        genOne = params.selectedGens[1],
        genTwo = params.selectedGens[2],
        genThree = params.selectedGens[3],
        genFour = params.selectedGens[4],
        genFive = params.selectedGens[5],
        genSix = params.selectedGens[6],
        genSeven = params.selectedGens[7],
        genEight = params.selectedGens[8],
        genNine = params.selectedGens[9],
    }

    blueRack.call("setGen", genParams)
    greenRack.call("setGen", genParams)
    orangeRack.call("setGen", genParams)
    purpleRack.call("setGen", genParams)
    redRack.call("setGen", genParams)
    yellowRack.call("setGen", genParams)

    -- delete Saves on starting
    local tmpelite4Gym = getObjectFromGUID("a0f650")
    local tmprivalGym = getObjectFromGUID("c970ca")
    tmpelite4Gym.call("deleteSave")
    tmprivalGym.call("deleteSave")

    -- gyms
    if params.leadersGen == 1 then
        setupGyms(gen1LeadersArr, 1, params.customGymLeaderOption)
    elseif params.leadersGen == 2 then
        setupGyms(gen2LeadersArr, 2, params.customGymLeaderOption)
    elseif params.leadersGen == 3 then
        setupGyms(gen3LeadersArr, 3, params.customGymLeaderOption)
    elseif params.leadersGen == 4 then
        setupGyms(gen4LeadersArr, 4, params.customGymLeaderOption)
    elseif params.leadersGen == 5 then
        setupGyms(gen5LeadersArr, 5, params.customGymLeaderOption)
    elseif params.leadersGen == 6 then
        setupGyms(gen6LeadersArr, 6, params.customGymLeaderOption)
    elseif params.leadersGen == 7 then
        setupGyms(gen7LeadersArr, 7, params.customGymLeaderOption)
    elseif params.leadersGen == 8 then
        setupGyms(gen8LeadersArr, 8, params.customGymLeaderOption)
    elseif params.leadersGen == 9 then
        setupGyms(gen9LeadersArr, 9, params.customGymLeaderOption)
    elseif params.leadersGen == -1 then
        -- random leaders
        local gen

        -- Keep track of the leaders we have already retrieved. Can't retrieve them twice, lol.
        local leadersRetrieved = {}

        -- Initialize the Gym Leaders pokeballs list.
        local gymPokeballs = { gen1LeadersArr[1], gen2LeadersArr[1], gen3LeadersArr[1], gen4LeadersArr[1], gen5LeadersArr[1], gen6LeadersArr[1], gen7LeadersArr[1], gen8LeadersArr[1], gen9LeadersArr[1] }

        for i = 1, 8 do
            -- Check if we need to consider custom Gym Leaders.
            local pokeballs = ShallowCopy(gymPokeballs)
            local custom_leaders_available = customs_available(customLeadersArr[1], i, leadersRetrieved)
            if params.customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
                table.insert(pokeballs, customLeadersArr[1])
            elseif params.customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
                pokeballs = { customLeadersArr[1] }
            end

            -- Pick a random Gym Leaders pokeball from the list we have.
            gen = math.random(1, #pokeballs)
            local gymsPokeball = getObjectFromGUID(pokeballs[gen])
            if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[1]) or gen == 10 then
                gen = "custom"
            end
            local leader = nil
            if gymsPokeball.hasTag("MultipleGymLeaders") then
                local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen, tier=i, retrievedList=leadersRetrieved})
                leader = gymsPokeball.takeObject({ guid = leaderGuid })
            else
                local cardIndex = 8 - i
                leader = gymsPokeball.takeObject({ index = cardIndex })
            end

            -- Put the retrieved gym leader into the gym.
            local gym = getObjectFromGUID(gyms[i])
            gym.putObject(leader)
            gym.call("setLeaderGUID", { leader.guid })

            -- Add this to the leaders we have already retrieved list.
            table.insert(leadersRetrieved, leader.guid)
        end

        -- Initialize the Elite 4 pokeballs list and gym object.
        local eliteFourPokeballs = { gen1LeadersArr[2], gen2LeadersArr[2], gen3LeadersArr[2], gen4LeadersArr[2], gen5LeadersArr[2], gen6LeadersArr[2], gen7LeadersArr[2], gen8LeadersArr[2], gen9LeadersArr[2] }
        local elite4Gym = getObjectFromGUID("a0f650")
        for i = 1, 4 do
            -- Check if we need to consider custom Elite 4s.
            local pokeballs = ShallowCopy(eliteFourPokeballs)
            local custom_leaders_available = customs_available(customLeadersArr[2], 9, leadersRetrieved)
            if params.customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
                table.insert(pokeballs, customLeadersArr[2])
            elseif params.customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
                pokeballs = { customLeadersArr[2] }
            end

            gen = math.random(1, #pokeballs)
            local elite4Pokeball = getObjectFromGUID(pokeballs[gen])
            if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[2]) or gen == 10 then
                gen = "custom"
            end
            local leader = nil
            if elite4Pokeball.hasTag("MultipleGymLeaders") then
                local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen, tier=9, retrievedList=leadersRetrieved})
                leader = elite4Pokeball.takeObject({ guid = leaderGuid })
            else
                elite4Pokeball.shuffle()
                leader = elite4Pokeball.takeObject({})
            end
            elite4Gym.putObject(leader)
            elite4Gym.call("setLeaderGUID", { leader.guid })

            -- Add this to the leaders we have already retrieved list.
            table.insert(leadersRetrieved, leader.guid)
        end

        -- Initialize the Rivals pokeballs list and gym object.
        local rivalPokeballs = { gen1LeadersArr[3], gen2LeadersArr[3], gen3LeadersArr[3], gen4LeadersArr[3], gen5LeadersArr[3], gen6LeadersArr[3], gen7LeadersArr[3], gen8LeadersArr[3], gen9LeadersArr[3] }
        local rivalGym = getObjectFromGUID("c970ca")
        for i = 1, 3 do
            -- Check if we need to consider custom Rivals.
            local pokeballs = ShallowCopy(rivalPokeballs)
            local custom_leaders_available = customs_available(customLeadersArr[3], 10, leadersRetrieved)
            if params.customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
                table.insert(pokeballs, customLeadersArr[3])
            elseif params.customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
                pokeballs = { customLeadersArr[3] }
            end

            -- Determine the gen.
            gen = math.random(1, #pokeballs)
            local rivalPokeball = getObjectFromGUID(pokeballs[gen])
            if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[3]) or gen == 10 then
                gen = "custom"
            end
            local leader = nil
            if rivalPokeball.hasTag("MultipleGymLeaders") then
                local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen, tier=10, retrievedList=leadersRetrieved})
                leader = rivalPokeball.takeObject({ guid = leaderGuid })
            else
                rivalPokeball.shuffle()
                leader = rivalPokeball.takeObject({})
            end
            rivalGym.putObject(leader)
            rivalGym.call("setLeaderGUID", { leader.guid })

            -- Add this to the leaders we have already retrieved list.
            table.insert(leadersRetrieved, leader.guid)
        end

        -- Initialize the Team Rocket pokeballs list.
        local teamRocketPokeballs = { gen1LeadersArr[4], gen2LeadersArr[4], gen3LeadersArr[4], gen4LeadersArr[4], gen5LeadersArr[4], gen6LeadersArr[4], gen7LeadersArr[4], gen8LeadersArr[4], gen9LeadersArr[4] }

        -- Check if we need to consider custom Team Rockets.
        local custom_leaders_available = customs_available(customLeadersArr[4], 11, leadersRetrieved)
        if params.customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
            table.insert(teamRocketPokeballs, customLeadersArr[4])
        elseif params.customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
            teamRocketPokeballs = { customLeadersArr[4] }
        end
        
        -- Determine the gen.
        gen = math.random(1, #teamRocketPokeballs)
        local teamRocketGym = getObjectFromGUID("19db0d")
        local teamRocketPokeball = getObjectFromGUID(teamRocketPokeballs[gen])
        if (#teamRocketPokeballs == 1 and teamRocketPokeballs[1] == customLeadersArr[4]) or gen == 10 then
            gen = "custom"
        end
        local teamRocketLeader
        if teamRocketPokeball.hasTag("MultipleGymLeaders") then
            local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen, tier=11, retrievedList=leadersRetrieved})       -- 11 signifes Team Rocket.
            teamRocketLeader = teamRocketPokeball.takeObject({ guid = leaderGuid })
        else
            teamRocketPokeball.shuffle()
            teamRocketLeader = teamRocketPokeball.takeObject({})
        end
        teamRocketGym.putObject(teamRocketLeader)
        teamRocketGym.call("setLeaderGUID", { teamRocketLeader.guid })

        -- Add this to the leaders we have already retrieved list.
        table.insert(leadersRetrieved, teamRocketLeader.guid)
    end

    if params.randomStarters then
        self.editButton({index=0, position={0, 1000, 0}})
        Wait.condition(onSetupFinished, function() return not self.spawning and not self.loading_custom end)
    else
        -- Remove the settings button and change it to a Start Game button.
        self.removeButton(0)
        self.createButton({ --Apply settings button
            label = "Start Game",
            click_function = "start",
            function_owner = self,
            tooltip = "Click to start game. Only click this when every player has a starter Pokémon.",
            position = buttonRelativePosition,
            rotation = { 0, 0, 0 },
            height = 600,
            width = 2000,
            font_size = 300,
        })

        -- Since we moved the Starter Pokeball, let's broadcast a message and ping it.
        -- TODO: Remove this after a few updates.
        broadcastToAll("The Starter Pokéball has been moved to be more consistent across maps. Please check ping.", "Yellow")
        local seatedPlayers = getSeatedPlayers()
        if #seatedPlayers ~= 0 then
            local pingSelf = function() Player[seatedPlayers[1]].pingTable(getObjectFromGUID("ec1e4b").getPosition()) end
            Wait.time(pingSelf, 3)
            Wait.time(pingSelf, 5)
        end

        -- Update the setup_done flag.
        setup_done = true
    end
end

-- Helper function that checks if there are custom Gym Leaders available for a particular tier that have not already been selected.
function customs_available(pokeballGuid, tier, retrievedList)
    local targetPokeball = getObjectFromGUID(pokeballGuid)
    if #targetPokeball.getObjects() == 0 then return false end
    return Global.call("GetCustomLeaderCount", {gen="custom", tier=tier, retrievedList=retrievedList}) ~= 0
end

function onSetupFinished()
    print('Ready!')
    
    --self.deal(1)

    self.shuffle()
    local dealOneAndStart = 
        function() 
            self.deal(1) 
            start()
        end
    Wait.time(dealOneAndStart, 1)
end

-- Moves tokens from one group of Pokeballs to another group of Pokeballs
function setupPokeballs(pokeballArr, targetPokeballArr)
    for i = 1, #pokeballArr do
        local pokeball = getObjectFromGUID(pokeballArr[i])
        local targetPokeball = getObjectFromGUID(targetPokeballArr[i])
        for j = 1, #pokeball.getObjects() do
            targetPokeball.putObject(pokeball.takeObject({}))
        end
    end
end

-- Moves gym leader cards into respective gyms
function setupGyms(leadersArr, gen, customGymLeaderOption)
    -- Initialize the leaders retrieved list.
    local leadersRetrieved = {}

    -- Iniitalize some variables.
    local leader

    -- Loop through each gym.
    for i = 1, 8 do
        -- Check if we need to consider custom Gym Leaders.
        local pokeballs = { leadersArr[1] }
        local custom_leaders_available = customs_available(customLeadersArr[1], i, leadersRetrieved)
        if customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
            pokeballs = { leadersArr[1], customLeadersArr[1] }
        elseif customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
            pokeballs = { customLeadersArr[1] }
        end

        -- gen_index will be either the generation that was selected or the custom gen.
        local gen_index = math.random(1, #pokeballs)
        local gymsPokeball = getObjectFromGUID(pokeballs[gen_index])
        local gen_to_use = gen
        if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[1]) or gen_index == 2 then
            gen_to_use = "custom"
        end

        -- If this gym has multiple gym leader options per gym, we need to get creative about retrieving the correct gym.
        if gymsPokeball.hasTag("MultipleGymLeaders") then
            local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen_to_use, tier=i})
            leader = gymsPokeball.takeObject({ guid = leaderGuid })
        else
            leader = gymsPokeball.takeObject({})
        end

        -- Move the card.
        local gym = getObjectFromGUID(gyms[i])
        gym.putObject(leader)
        gym.call("setLeaderGUID", { leader.guid })

        -- Add this to the leaders we have already retrieved list.
        table.insert(leadersRetrieved, leader.guid)
    end

    local elite4Gym = getObjectFromGUID("a0f650")
    for i = 1, 4 do
        -- Check if we need to consider custom Gym Leaders.
        local pokeballs = { leadersArr[2] }
        local custom_leaders_available = customs_available(customLeadersArr[2], 9, leadersRetrieved)
        if customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
            pokeballs = { leadersArr[2], customLeadersArr[2] }
        elseif customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
            pokeballs = { customLeadersArr[2] }
        end
        
        -- gen_index will be either the generation that was selected or the custom gen.
        local gen_index = math.random(1, #pokeballs)
        local elite4Pokeball = getObjectFromGUID(pokeballs[gen_index])
        local gen_to_use = gen
        if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[2]) or gen_index == 2 then
            gen_to_use = "custom"
        end

        -- If this gym has multiple gym leader options per gym, we need to get creative about retrieving the correct gym.
        if elite4Pokeball.hasTag("MultipleGymLeaders") then
            local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen_to_use, tier=9})
            leader = elite4Pokeball.takeObject({ guid = leaderGuid })
        else
            leader = elite4Pokeball.takeObject({})
        end
        
        -- Move the card.
        elite4Gym.putObject(leader)
        elite4Gym.call("setLeaderGUID", { leader.guid })

        -- Add this to the leaders we have already retrieved list.
        table.insert(leadersRetrieved, leader.guid)
    end

    local rivalGym = getObjectFromGUID("c970ca")
    for i = 1, 3 do
        -- Check if we need to consider custom Rivals.
        local pokeballs = { leadersArr[3] }
        local custom_leaders_available = customs_available(customLeadersArr[3], 10, leadersRetrieved)
        if customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
            pokeballs = { leadersArr[3], customLeadersArr[3] }
        elseif customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
            pokeballs = { customLeadersArr[3] }
        end
        
        -- gen_index will be either the generation that was selected or the custom gen.
        local gen_index = math.random(1, #pokeballs)
        local rivalPokeball = getObjectFromGUID(pokeballs[gen_index])
        local gen_to_use = gen
        if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[3]) or gen_index == 2 then
            gen_to_use = "custom"
        end

        -- If this gym has multiple gym leader options per gym, we need to get creative about retrieving the correct gym.
        if rivalPokeball.hasTag("MultipleGymLeaders") then
            local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen_to_use, tier=10})
            leader = rivalPokeball.takeObject({ guid = leaderGuid })
        else
            leader = rivalPokeball.takeObject({})
        end

        -- Move the card.
        rivalGym.putObject(leader)
        rivalGym.call("setLeaderGUID", { leader.guid })

        -- Add this to the leaders we have already retrieved list.
        table.insert(leadersRetrieved, leader.guid)
    end

    -- Team Rocket.
    local silphCoGym = getObjectFromGUID("19db0d")

    -- Check if we need to consider custom Rivals.
    local pokeballs = { leadersArr[4] }
    local custom_leaders_available = customs_available(customLeadersArr[4], 11, leadersRetrieved)
    if customGymLeaderOption == ALLOW_SELECT and custom_leaders_available then
        pokeballs = { leadersArr[4], customLeadersArr[4] }
    elseif customGymLeaderOption == ALWAYS_SELECT and custom_leaders_available then
        pokeballs = { customLeadersArr[4] }
    end

    -- gen_index will be either the generation that was selected or the custom gen.
    local gen_index = math.random(1, #pokeballs)
    local silphCoPokeball = getObjectFromGUID(pokeballs[gen_index])
    local gen_to_use = gen
    if (#pokeballs == 1 and pokeballs[1] == customLeadersArr[4]) or gen_index == 2 then
        gen_to_use = "custom"
    end

    local teamRocketLeader
    if silphCoPokeball.hasTag("MultipleGymLeaders") then
        local leaderGuid = Global.call("RandomGymGuidOfTier", {gen=gen_to_use, tier=11})       -- 11 signifes Team Rocket.
        teamRocketLeader = silphCoPokeball.takeObject({ guid = leaderGuid })
    else
        teamRocketLeader = silphCoPokeball.takeObject({})
    end
    silphCoGym.putObject(teamRocketLeader)
    silphCoGym.call("setLeaderGUID", { teamRocketLeader.guid })

    -- Add this to the leaders we have already retrieved list.
    table.insert(leadersRetrieved, teamRocketLeader.guid)
end

function start()
    local pinkPokeball = getObjectFromGUID("9c4411")
    local greenPokeball = getObjectFromGUID("c988ea")
    local bluePokeball = getObjectFromGUID("2cf16d")
    local yellowPokeball = getObjectFromGUID("986cb5")
    local redPokeball = getObjectFromGUID("f66036")
    local legendaryPokeball = getObjectFromGUID("e46f90")

    if #self.getButtons() ~= 0 then
        self.removeButton(0)
    end

    -- Shuffle the decks that should be random.
    local itemDeck = getObjectFromGUID("30f8c1")
    itemDeck.shuffle()
    local eventDeck = getObjectFromGUID("656d8c")
    eventDeck.shuffle()
    local tmDeck = getObjectFromGUID("3ed1f5")
    tmDeck.shuffle()
    local pokeballDeck = getObjectFromGUID("e8bcad")
    pokeballDeck.shuffle()
    local zCrystalDeck = getObjectFromGUID("7df5b9")
    zCrystalDeck.shuffle()
    local typeBoosterDeck = getObjectFromGUID("13497d")
    typeBoosterDeck.shuffle()
    local teraTypesDeck = getObjectFromGUID("d60fd9")
    teraTypesDeck.shuffle()
    local boostItemsDeck = getObjectFromGUID("acfa1d")
    boostItemsDeck.shuffle()

    local pinkPokeball = getObjectFromGUID("9c4411")
    -- Move Starter Pokémon to Pink Pokéball
    for _ = 1, #self.getObjects() do
        local starterPokemon = self.takeObject({})
        if starterPokemon.getDescription() == "Starter Only" then
            starterPokemon.destruct()
        else
            pinkPokeball.putObject(starterPokemon)
        end
    end

    -- Deal out all pokeballs
    local dealPink = function() pinkPokeball.call("begin") end
    local dealGreen = function() greenPokeball.call("begin") end
    local dealBlue = function() bluePokeball.call("begin") end
    local dealYellow = function() yellowPokeball.call("begin") end
    local dealRed = function() redPokeball.call("begin") end
    local dealLegendary = function() legendaryPokeball.call("begin") end
    local destroy = function() self.destruct() end

    Wait.time(dealPink, 2)
    Wait.time(dealGreen, 3)
    Wait.time(dealBlue, 4)
    Wait.time(dealYellow, 5)
    Wait.time(dealRed, 6)
    Wait.time(dealLegendary, 7)
    Wait.time(destroy, 10)

    Global.call("PlayRouteMusic",{})
end

function settings()
    Global.call("PlayOpeningMusic",{})
    Global.call("ShowSettingsPopup",{})
end

-- Helper function to print a table.
function dump_table(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump_table(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

-- Shallow-copy a table. If our data gets more complicated (nested tables, etc.) we will need a
-- deep copy instead.
function ShallowCopy(orig_table)
    local orig_type = type(orig_table)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig_table) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig_table
    end
    return copy
  end