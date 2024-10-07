local gymButtonPos = {}

local gymData = nil
local pokemonData = nil
local battleManager = "de7152"

-- Chaos related fields.
local chaos = false
local tier = 4
local genLeadersPokeballGuids = { "1adc9d", "d6be18", "797253", "d6b981", "cd0374", "150632", "58ca45", "227356", "e4988b" }
local customLeadersPokeballGuid = "ab33b9"
local leaderGuid = nil
local currentGen = nil
local initialized = false

function initialize(gym_button_position)
  gymButtonPos = gym_button_position
  initialized = true

  self.createButton({ --Apply settings button
    label="+", click_function="battle",
    function_owner=self, tooltip="Start Gym Battle",
    position=gymButtonPos, rotation={0,0,0}, height=800, width=800, font_size=20000
  })
end

function onSave()
    saved_data = JSON.encode({saveGymData=gymData, savePokemonData=pokemonData, chaos=chaos, gym_button_position=gymButtonPos, initialized=initialized})
    return saved_data
end

function onLoad(saved_data)
  if saved_data ~= "" then
      local loaded_data = JSON.decode(saved_data)
      if loaded_data.saveGymData ~= nil and loaded_data.savePokemonData ~= nil then
        gymData = copyTable(loaded_data.saveGymData)
        pokemonData = copyTable(loaded_data.savePokemonData)
      end
      
      chaos = loaded_data.chaos
      gymButtonPos = loaded_data.gym_button_position
      initialized = loaded_data.initialized
  end

  if initialized then
    self.createButton({ --Apply settings button
        label="+", click_function="battle",
        function_owner=self, tooltip="Start Gym Battle",
        position=gymButtonPos, rotation={0,0,0}, height=800, width=800, font_size=20000
    })
  end
end

function battle()
  -- Ensure we have gym data OR we are in chaos mode.
  if gymData == nil and not chaos then return end

  if chaos then
    -- Get a GUID for a random gen.
    currentGen = math.random(1, 9)
    leaderGuid = Global.call("RandomGymGuidOfTier", {gen=currentGen, tier=tier, retrievedList={}})

    -- Take the leader card out of the Pokeball and put it inside of.. myself.
    local pokeball = getObjectFromGUID(genLeadersPokeballGuids[currentGen])
    local leaderCard = pokeball.takeObject({guid = leaderGuid})
    self.putObject(leaderCard)

    -- Init this gym with this data.
    initGym(leaderGuid)
  end

  -- Create the params.
  local params = {
    trainerName = gymData.trainerName,
    trainerGUID = gymData.guid,
    gymGUID = self.getGUID(),
    pokemon = pokemonData,
    isGymLeader = true,
    isSilphCo = false,
    isRival = false,
    isElite4 = false
  }

  -- Send the Gym Leader card to the arena.
  local battleManager = getObjectFromGUID(battleManager)
  local sentToArena = battleManager.call("sendToArenaGym", params)

  if sentToArena then
    self.editButton({
        index=0, label="-", click_function="recall",
        function_owner=self, tooltip="Recall Gym Leader",
        position= gymButtonPos, rotation={0,0,0}, height=800, width=800, font_size=20000
    })
  end
end

function recall()
  -- Tell BM to send the card back to us.
  local params = {gymGUID = self.getGUID()}
  local battleManager = getObjectFromGUID(battleManager)
  battleManager.call("recallGym", params)

  if chaos then
    -- Take the leader card out of.. myself and put it back into its Pokeball.
    local pokeball = getObjectFromGUID(genLeadersPokeballGuids[currentGen])

    -- Wait until we have the gym card back.
    Wait.condition(
      function()
        -- Put the gym leader card back in its pokeball.
        local leaderCard = self.takeObject({guid = leaderGuid})
        if leaderCard and pokeball then
          pokeball.putObject(leaderCard)
        end
    
        -- Clear the gym data of the previous Gym Leader.
        uninitGym()
      end,
      function() -- Condition function
        for _, contained_object in ipairs(self.getObjects()) do
          if contained_object.guid == leaderGuid then
            return true
          end
        end
        return false
      end,
      5, -- 5 seconds, sheesh.
      function() -- Timeout function.
        print("Timeout occurred waiting for the Gym Leader card, please place it back in the Gen " .. currentGen .. " Gym Leader Pokeball manually.")
    
        -- Clear the gym data of the previous Gym Leader.
        uninitGym()
      end
    )
  end

  Global.call("PlayRouteMusic",{})

  self.editButton({ --Apply settings button
      index=0, label="+", click_function="battle",
      function_owner=self, tooltip="Start Gym Battle",
      position= gymButtonPos, rotation={0,0,0}, height=800, width=800, font_size=20000
  })
end

function setLeaderGUID(params)
  if params[1] == "CHAOS" then
    chaos = true
    return
  end
  initGym(params[1])
end

function initGym(guid)
  pokemonData = {}
  gymData = Global.call("GetGymDataByGUID", {guid=guid})
  for i=1, #gymData.pokemon do
    local newPokemon = {}
    setNewPokemon(newPokemon, gymData.pokemon[i])
    table.insert(pokemonData, newPokemon)
  end
end

function uninitGym()
  gymData = {}
  pokemonData = {}
  currentGen = nil
  leaderGuid = nil
end

function setNewPokemon(data, newPokemonData)

  data.name = newPokemonData.name
  data.types = copyTable(newPokemonData.types)
  data.baseLevel = newPokemonData.level
  data.effects = {}

  data.moves = copyTable(newPokemonData.moves)
  local movesData = {}
  for i=1, #data.moves do
    moveData = copyTable(Global.call("GetMoveDataByName", data.moves[i]))
    moveData.status = DEFAULT
    moveData.isTM = false
    table.insert(movesData, moveData)
  end
  data.movesData = movesData
end


function copyTable (original)
  local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = copyTable(v)
		end
		copy[k] = v
	end
	return copy
end
