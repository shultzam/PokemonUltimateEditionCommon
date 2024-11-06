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
local customEvoPokeballs = { "95fee8", "8a1c9a", "7f2cd7", "0d33b3", "8faab4", "34858b", "59b163" }
local customLeadersArr = { "ab33b9", "f6be1f", "be2f56", "94584c" }

-- The Starter Pokeball should be placed at {0, 2.69, 34}.
local buttonRelativePosition = { 0, -1, 2.3 }

local setup_done = false

-- Custom Gym Leader Options.
local NONE_SELECT = 0
local ALLOW_SELECT = 1
local ALWAYS_SELECT = 2

-- GUIDs.
local elite4GymGuid = "a0f650"
local rivalGymGuid = "c970ca"
local teamRocketGymGuid = "19db0d"

-- Initial badge GUIDs.
local original_badge_guids = { "bce8e0", "a83bf0", "286901", "cbbade", "c81eab", "23b4f1", "e53b76", "9b0053" }

-- Iniital Rack GUIDs. These are based on the Johto GUIDs, since that is the initial state of the racks.
-- Order: Yellow, Green, Blue, Red, Purple, Orange.
local initial_rack_guids = { "8b1324", "b085a0", "7a85a9", "7af2f7", "b581f3", "e3d3fd" }

-- The standard and extras pokeball GUIDs.
local standard_guid = "35950f"
local map_specific_guid = "18e364"

-- Counter GUIDs.
local def_counter_guid = "b76b2a"
local atk_counter_guid = "73b431"

-- Stupid Arena text GUID.
local arena_text_guid = "f0b393"

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
    -- Load the required map shenanigans.
    setup_map(params.selected_map)

    -- Tokens
    if params.selectedGens[1] then
        setupPokeballs(gen1Pokeballs, pokeballs)
        setupPokeballs(gen1EvoPokeballs, evoPokeballs)
    end

    if params.selectedGens[2] then
        setupPokeballs(gen2Pokeballs, pokeballs)
        setupPokeballs(gen2EvoPokeballs, evoPokeballs)
        if not params.selectedGens[1] then
        	setupPokeballs(gen1EvoPokeballs, evoPokeballs)
        end
    end

    if params.selectedGens[3] then
        setupPokeballs(gen3Pokeballs, pokeballs)
        setupPokeballs(gen3EvoPokeballs, evoPokeballs)
        if not params.selectedGens[2] then
        	setupPokeballs(gen2EvoPokeballs, evoPokeballs)
        end
    end

    if params.selectedGens[4] then
        setupPokeballs(gen4Pokeballs, pokeballs)
        setupPokeballs(gen4EvoPokeballs, evoPokeballs)
        if not params.selectedGens[3] then
        	setupPokeballs(gen3EvoPokeballs, evoPokeballs)
        end
        if not params.selectedGens[2] then
        	setupPokeballs(gen2EvoPokeballs, evoPokeballs)
        end
        if not params.selectedGens[1] then
        	setupPokeballs(gen1EvoPokeballs, evoPokeballs)
        end
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

    -- Delete Saves on starting
    local tmpelite4Gym = getObjectFromGUID(elite4GymGuid)
    local tmprivalGym = getObjectFromGUID(rivalGymGuid)
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
        -- Random Leaders.
        local gen

        -- Keep track of the leaders we have already retrieved. Can't retrieve them twice, lol.
        local leadersRetrieved = {}

        -- Initialize the Gym Leaders pokeballs list.
        local gymPokeballs = { gen1LeadersArr[1], gen2LeadersArr[1], gen3LeadersArr[1], gen4LeadersArr[1], gen5LeadersArr[1], gen6LeadersArr[1], gen7LeadersArr[1], gen8LeadersArr[1], gen9LeadersArr[1] }

        for i = 1, 8 do
            -- Check if we need to consider custom Gym Leaders.
            local pokeballs = shallowCopy(gymPokeballs)
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
        local elite4Gym = getObjectFromGUID(elite4GymGuid)
        for i = 1, 4 do
            -- Check if we need to consider custom Elite 4s.
            local pokeballs = shallowCopy(eliteFourPokeballs)
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
        local rivalGym = getObjectFromGUID(rivalGymGuid)
        for i = 1, 3 do
            -- Check if we need to consider custom Rivals.
            local pokeballs = shallowCopy(rivalPokeballs)
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
        local teamRocketGym = getObjectFromGUID(teamRocketGymGuid)
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
    elseif params.leadersGen == -2 then
        -- Chaos: ENGAGE.

        -- Gens 1-8.
        for i = 1, 8 do
            local gym = getObjectFromGUID(gyms[i])
            gym.call("setLeaderGUID", { "CHAOS" })
        end

        -- Elite 4.
        local elite4Gym = getObjectFromGUID(elite4GymGuid)
        elite4Gym.call("setLeaderGUID", { "CHAOS" })

        -- Rival.
        local rivalGym = getObjectFromGUID(rivalGymGuid)
        rivalGym.call("setLeaderGUID", { "CHAOS" })

        -- Team Rocket.
        local teamRocketGym = getObjectFromGUID(teamRocketGymGuid)
        teamRocketGym.call("setLeaderGUID", { "CHAOS" })
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

        -- Update the setup_done flag.
        setup_done = true
    end
end

-- Region name to generation lookup table.
local regionToGenNumberLookupTable = {
    ["Kanto"] = 1,
    ["Johto"] = 2,
    ["Hoenn"] = 3,
    ["Sinnoh"] = 4,
    ["Unova"] = 5,
    ["Kalos"] = 6,
    ["Alola"] = 7,
    ["Galar"] = 8,
    ["Paldea"] = 9,
    ["Orange Islands"] = 10
  }

function setup_map(selected_map_name)
    -- Get a handle on the Map Manager.
    local map_manager = getObjectFromGUID("026857")
    if not map_manager then
        printToAll("Cannot find the Map Manager :(. Reload the mod.", "Red")
        return
    end

    -- Get the map data from the Map Manager.
    local map_data = map_manager.call("get_map_data_for_region", selected_map_name)
    if not map_data then
        printToAll("Selected map has not been implemented yet: " .. tostring(selected_map_name) .. ". Reload the mod.", "Red")
        return
    end

    -- Snappoints.
    Global.setSnapPoints(map_data.snaps)

    -- Board Pokemon.
    local unusedBoardPokeball = getObjectFromGUID("a09162")
    if unusedBoardPokeball then
        if map_data.board_pokemon then
            for pokemon_i=1, #map_data.board_pokemon do
                local board_pokemon_data = copyTable(map_data.board_pokemon[pokemon_i])
                local token = unusedBoardPokeball.takeObject({ guid = board_pokemon_data.guid, position = board_pokemon_data.position, rotation = {0, 180, 0} })
            end
        end
    end

    -- Initialize Tier 1-8 Pokeballs with Kanto locations.
    -- NOTE: pokeball_index starts at 2 to skip over the Starter Pokeball object.
    for pokeball_index=2, #pokeballs do
        local pokeball = getObjectFromGUID(pokeballs[pokeball_index])
        if pokeball then
            -- The -1 offset here is because the Map Manager does not consider the Starter Pokeball being a part of this.
            pokeball.call("initialize", map_data.kanto_locations[pokeball_index-1])
        end
    end

    -- Get a handle on the pokeball with the standard items that are common to every map.
    local standard_items_pokeball = getObjectFromGUID(standard_guid)
    
    -- TTS does not like setting the state of something to its current state ID for some reason. 
    -- So keep track of the new state for future checks.
    local new_state_id = regionToGenNumberLookupTable[selected_map_name]

    -- Initialize and move the tier 1-8 gyms.
    for gym_index=1, #gyms do
        local gym = getObjectFromGUID(gyms[gym_index])
        if gym then
            local gym_info = copyTable(map_data.gyms_info[gym_index])
            -- Get the badge of this gym tier.
            local original_badge_guid = original_badge_guids[gym_index]
            local original_badge = standard_items_pokeball.takeObject({guid=original_badge_guid})
            if original_badge then
                -- Change this badge to the state of this region number.
                -- TTS does not like setting the state of something to its current state ID for some reason.
                if original_badge.getStateId() ~= new_state_id then
                    original_badge = original_badge.setState(new_state_id)
                end
                
                -- Clone the badge 5 times and put all clones into the gym.
                for badge_index = 1, 5 do
                    local cloned_badge = original_badge.clone()
                    gym.putObject(cloned_badge)
                end
    
                -- Put the original badge into the gym.
                gym.putObject(original_badge)
            else
                print("Failed to get the original badge for tier " .. tostring(gym_index))
            end
            
            -- Move the gym to its destination.
            move_gym_and_set_name({obj = gym, name = gym_info.name, position = gym_info.position, rotation = gym_info.rotation})
            gym.call("initialize", gym_info.button_pos)
        else
            print("ERROR: Could not find gym #" .. tostring(gym_index))
        end
    end

    -- Initialize the Elite 4 gym.
    local elite4Gym = getObjectFromGUID(elite4GymGuid)
    if elite4Gym then
        local gym_info = copyTable(map_data.gyms_info[9])
        move_gym_and_set_name({obj = elite4Gym, position = gym_info.position, rotation = gym_info.rotation})
        elite4Gym.call("initialize", gym_info.button_pos)
    else
        print("ERROR: Could not find Elite 4 Gym")
    end

    -- Initialize the Rival/Champion gym.
    local rivalGym = getObjectFromGUID(rivalGymGuid)
    if rivalGym then
        local gym_info = copyTable(map_data.gyms_info[10])
        move_gym_and_set_name({obj = rivalGym, position = gym_info.position, rotation = gym_info.rotation})
        rivalGym.call("initialize", { gym_button_position = gym_info.button_pos, victory_button_pos = gym_info.victory_button_pos })
    else
        print("ERROR: Could not find Rival Gym")
    end

    -- Initialize the Team Rocket gym.
    local teamRocketGym = getObjectFromGUID(teamRocketGymGuid)
    if teamRocketGym then
        local gym_info = copyTable(map_data.gyms_info[11])
        move_gym_and_set_name({obj = teamRocketGym, name = gym_info.name, position = gym_info.position, rotation = gym_info.rotation})
        teamRocketGym.call("initialize", { gym_button_position = gym_info.button_pos, gym_name = gym_info.name })
    else
        print("ERROR: Could not find Team Rocket Gym")
    end

    -- Initialize the racks.
    local rack_guid_param = {}
    for rack_index=1, #initial_rack_guids do
        -- Get the rack by its initial GUID.
        local rack = getObjectFromGUID(initial_rack_guids[rack_index])

        -- If there is no rack the user's may have deleted them already. Charge forward!
        local new_guid = nil
        if rack then
            if rack.getStateId() ~= new_state_id then
                rack = rack.setState(new_state_id)
            end
            rack.setLock(true)
            new_guid = rack.getGUID()
        else
            new_guid = nil
        end

        -- Append the new GUID to the rack GUID param we are sending to the Battle Manager.
        table.insert(rack_guid_param, new_guid)
    end

    -- Tell the BattleManager what the rack GUIDs are.
    local battle_manager = getObjectFromGUID("de7152")
    battle_manager.call("initialize", rack_guid_param)

    -- Loop through the decks.
    -- Deck order: Pokeballs, Shop Items, Boost Items, Item Cards, Event Cards, Z-Crystals, Type Boosters, Tera Types, TM Cards
    for deck_index=1, #map_data.deck_locations do
        -- Move the deck.
        local params = copyTable(map_data.deck_locations[deck_index])
        local deck_obj = standard_items_pokeball.takeObject({guid=params.guid})

        -- The Item Cards and Event Cards need some extra work since they change depending on the map.
        if deck_index == 4 or deck_index == 5 then
            -- Set the deck's state and shuffle it after .5 seconds.
            if deck_obj.getStateId() ~= new_state_id then
                deck_obj = deck_obj.setState(new_state_id)
            end
        end

        -- Shuffle the deck. The shop items don't really need to be shuffled but oh well.
        deck_obj.shuffle()

        -- Move the deck to its destination.
        deck_obj.setPosition(params.position)
        deck_obj.setRotation(params.rotation)
    end

    -- Unova has decks off the base table area. So we need to populate some empty text strings for its decks.
    if selected_map_name == "Unova" then
        -- Z-Crystal Deck.
        local z_crystal_deck = getObjectFromGUID("e01b2d")
        if z_crystal_deck then
            z_crystal_deck.TextTool.setValue("Z-Crystals")
        end
        -- Type Boosters Deck.
        local type_boosters_deck = getObjectFromGUID("012b94")
        if type_boosters_deck then
            type_boosters_deck.TextTool.setValue("Type Boosters")
        end
        -- Tera Types Deck.
        local tera_types_deck = getObjectFromGUID("b37916")
        if tera_types_deck then
            tera_types_deck.TextTool.setValue("Tera Types")
        end
    end

    -- Move counters.
    local def_counter = standard_items_pokeball.takeObject({guid=def_counter_guid, position={-30, 0.6, 10.72}, rotation={0,0,0}})
    def_counter.setLock(true)
    local atk_counter = standard_items_pokeball.takeObject({guid=atk_counter_guid, position={-30, 0.6, -10.72}, rotation={0,0,0}})
    atk_counter.setLock(true)

    -- Populate the "Arena" text.
    local arenaText = getObjectFromGUID(arena_text_guid)
    if arenaText then
        arenaText.TextTool.setValue("ARENA")
    end

    -- Move the additional items in the standard items list.
    for standard_index=1, #map_data.standard_items do
        local params = copyTable(map_data.standard_items[standard_index])
        local object_reference = standard_items_pokeball.takeObject(params)
        object_reference.setLock(true)
    end

    -- Get a reference to the map specific pokeball.
    local map_specific_pokeball = getObjectFromGUID(map_specific_guid)
    if not map_specific_pokeball then
        print("Could not find the Map Specific Pokéball")
        return
    end

    -- Move the Map Specific Items.
    for map_sepecfic_index=1, #map_data.map_specific_items do
        local params = copyTable(map_data.map_specific_items[map_sepecfic_index])
        local object_reference = map_specific_pokeball.takeObject(params)
        object_reference.setLock(true)
    end
end

-- Helper function to name a gym, move and rotate it to its desired location.
function move_gym_and_set_name(params)
    if params.name then
        params.obj.setName(params.name)
    end
    params.obj.setPosition(params.position)
    params.obj.setRotation(params.rotation)
    params.obj.setLock(true)
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

    local elite4Gym = getObjectFromGUID(elite4GymGuid)
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

    local rivalGym = getObjectFromGUID(rivalGymGuid)
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
    local silphCoGym = getObjectFromGUID(teamRocketGymGuid)

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
function shallowCopy(orig_table)
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

  function copyTable(original)
    local copy = {}
      for k, v in pairs(original) do
          if type(v) == "table" then
              v = copyTable(v)
          end
          copy[k] = v
      end
      return copy
  end