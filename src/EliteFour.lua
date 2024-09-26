local gymButtonPos = {0,0,2}

local battleManager = "de7152"
local leadersData = {}

-- Chaos related fields.
local chaos = false
local tier = 9
local genLeadersPokeballGuids = { "8b26e1", "c3650f", "61d7e4", "9b50d1", "fe76e1", "c85052", "157ff9", "b47fe7", "7269d7" }
local customLeadersPokeballGuid = "f6be1f"
local leaderGuid = nil
local currentGen = nil

function onSave()
    saved_data = JSON.encode({saveLeadersData=leadersData, chaos=chaos})
    return saved_data
end

function onLoad(saved_data)
  if saved_data ~= "" then
      local loaded_data = JSON.decode(saved_data)
      if loaded_data.saveLeadersData ~= nil then
          leadersData = copyTable(loaded_data.saveLeadersData)
          chaos = loaded_data.chaos
      end
  end
  
  self.createButton({ --Apply settings button
      label="+", click_function="battle",
      function_owner=self, tooltip="Start Elite Four Battle",
      position= gymButtonPos, rotation={0,0,0}, height=800, width=800, font_size=20000
  })
end

function deleteSave() 
  leadersData = {}
end

function battle()
  if #leadersData == 0 and not chaos then return end

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

  -- Randomly get a leader data index.
  local leaderData = leadersData[math.random(1, #leadersData)]

  -- Create the params.
  local params = {
    trainerName = leaderData.trainerName,
    trainerGUID = leaderData.guid,
    gymGUID = self.getGUID(),
    isGymLeader = false,
    isSilphCo = false,
    isRival = false,
    isElite4 = true,
    pokemon = leaderData.pokemon
  }

  -- Send the Gym Leader card to the arena.
  local battleManager = getObjectFromGUID(battleManager)
  local sentToArena = battleManager.call("sendToArenaGym", params)

  if sentToArena then
    self.editButton({
        index=0, label="-", click_function="recall",
        function_owner=self, tooltip="Recall Elite Four Member"
    })
  end
end

function recall()
  -- Tell BM to send the card back to us.
  local battleManager = getObjectFromGUID(battleManager)
  battleManager.call("recallGym")

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
        print("Timeout occurred waiting for the Elite 4 card, please place it back in the Gen " .. currentGen .. " Elite 4 Pokeball manually.")
    
        -- Clear the gym data of the previous Gym Leader.
        uninitGym()
      end
    )
  end

  Global.call("PlayRouteMusic",{})

  self.editButton({ --Apply settings button
      index=0, label="+", click_function="battle",
      function_owner=self, tooltip="Start Elite Four Battle",
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
  local gymData = Global.call("GetGymDataByGUID", {guid=guid})
  local leaderData = {guid= gymData.guid, trainerName= gymData.trainerName}
  local pokemonData = {}
  for i=1, #gymData.pokemon do
    local newPokemon = {}
    setNewPokemon(newPokemon, gymData.pokemon[i])
    table.insert(pokemonData, newPokemon)
  end
  leaderData.pokemon = pokemonData
  table.insert(leadersData, leaderData)
end

function uninitGym()
  leadersData = {}
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