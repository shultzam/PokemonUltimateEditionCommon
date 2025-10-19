gymButtonPos = {-7.3, 0, 2.9}

gymData = nil
pokemonData = nil
battleManager = "de7152"

-- Chaos related fields.
chaos = false
tier = 7
genLeadersPokeballGuids = { "1adc9d", "d6be18", "797253", "d6b981", "cd0374", "150632", "58ca45", "227356", "e4988b", "c4a729", "76b037" }
customLeadersPokeballGuid = "ab33b9"
leaderGuid = nil
currentGen = nil

function onSave()
  saved_data = JSON.encode({saveGymData=gymData, savePokemonData=pokemonData, chaos=chaos})
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
  end

  self.createButton({ --Apply settings button
    label="+", click_function="battle",
    function_owner=self, tooltip="Start Gym Battle",
    position=gymButtonPos, rotation={0,0,0}, height=800, width=800, font_size=20000
  })
end

function battle()
  -- Ensure we have gym data OR we are in chaos mode.
  if gymData == nil and not chaos then return end

  -- Get a handle on the Battle Manager.
  local battleManager = getObjectFromGUID(battleManager)
  if battleManager.call("getDefenderType") ~= nil then return end

  if chaos then
    -- Get a GUID for a random gen.
    local random_leader_params = Global.call("RandomGymGuidOfTier", {gen=math.random(1, 10), tier=tier, retrievedList={}})
    leaderGuid = random_leader_params.guid
    currentGen = random_leader_params.leader_gen

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
  if battleManager.call("sendToArenaGym", params) then
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
  data.teraType = newPokemonData.teraType
  data.teraActive = newPokemonData.teraActive

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
