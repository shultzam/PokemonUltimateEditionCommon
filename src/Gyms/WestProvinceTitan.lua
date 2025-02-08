gymButtonPos = {-8.4, 0, 5.1}
name = nil

battleManager = "de7152"
titanData = nil

-- Chaos related fields.
chaos = false
tier = 12
genLeadersPokeballGuid = "101621"
titanGuid = nil

function initialize()
  self.createButton({ --Apply settings button
      label="+", click_function="battle",
      function_owner=self, tooltip="Start Titan Battle",
      position=gymButtonPos, rotation={0,0,0}, height=600, width=600, font_size=15000
  })
end

function onSave()
    saved_data = JSON.encode({saveTitanData=titanData, saveTitanGuid=titanGuid, chaos=chaos})
    return saved_data
end

function onLoad(saved_data)
  if saved_data ~= "" then
      local loaded_data = JSON.decode(saved_data)
      if loaded_data.saveTitanData ~= nil then
          titanData = copyTable(loaded_data.saveTitanData)
      end
      if loaded_data.saveTitanGuid then
          titanGuid = loaded_data.saveTitanGuid
      end
      
      chaos = loaded_data.chaos
  end

  self.createButton({ --Apply settings button
    label="+", click_function="battle",
    function_owner=self, tooltip="Start Titan Battle",
    position=gymButtonPos, rotation={0,90,0}, height=800, width=800, font_size=20000
  })
end

function deleteSave() 
  titanData = nil
end

function battle()
  if not titanData and not chaos then return end

  -- Get a handle on the Battle Manager.
  local battleManager = getObjectFromGUID(battleManager)
  if battleManager.call("getDefenderType") ~= nil then return end

  if chaos then
    -- Get a GUID for a random gen.
    local random_leader_params = Global.call("RandomGymGuidOfTier", {gen=9, tier=tier, retrievedList={}})
    titanGuid = random_leader_params.guid

    -- Take the leader card out of the Pokeball and put it inside of.. myself.
    local pokeball = getObjectFromGUID(genLeadersPokeballGuid)
    local leaderCard = pokeball.takeObject({guid = titanGuid})
    self.putObject(leaderCard)

    -- Init this gym with this data.
    initGym(titanGuid)
  end
  
  -- Create the params.
  local params = {
    gymGUID = self.getGUID(),
    titanGUID = titanGuid,
    titanData = titanData
  }

  -- Send Team Rocket to the arena.
  if battleManager.call("sendToArenaTitan", params) then
    self.editButton({
        index=0, label="-", click_function="recall",
        function_owner=self, rotation={0,0,0}, tooltip="Recall Titan"
    })
  end
end

function recall()
  -- Tell BM to send the card back to us.
  local battleManager = getObjectFromGUID(battleManager)
  battleManager.call("recallGym")

  if chaos then
    -- Take the leader card out of.. myself and put it back into its Pokeball.
    local pokeball = getObjectFromGUID(genLeadersPokeballGuid)

    -- Wait until we have the gym card back.
    Wait.condition(
      function()
        -- Put the gym leader card back in its pokeball.
        local leaderCard = self.takeObject({guid = titanGuid})
        if leaderCard and pokeball then
          pokeball.putObject(leaderCard)
        end
    
        -- Clear the gym data of the previous Gym Leader.
        uninitGym()
      end,
      function() -- Condition function
        for _, contained_object in ipairs(self.getObjects()) do
          if contained_object.guid == titanGuid then
            return true
          end
        end
        return false
      end,
      5, -- 5 seconds, sheesh.
      function() -- Timeout function.
        print("Timeout occurred waiting for the Titan card, please place it back in the Gen 9 Titan Pokeball manually.")
    
        -- Clear the gym data of the previous Gym Leader.
        uninitGym()
      end
    )
  end

  Global.call("PlayRouteMusic",{})

  self.editButton({ --Apply settings button
      index=0, label="+", click_function="battle",
      function_owner=self, rotation={0,90,0}, tooltip="Start Titan Battle"
  })
end

function setTitanGUID(params)
  if params[1] == "CHAOS" then
    chaos = true
    return
  end
  initGym(params[1])
end

function initGym(guid)
  titanGuid = guid
  local data = Global.call("GetTitanDataByGUID", {guid=guid})
  titanData = {}
  titanData.name = data.name
  titanData.types = copyTable(data.types)
  titanData.level = data.level
  titanData.effects = {}
  titanData.teraType = data.teraType
  titanData.teraActive = data.teraActive

  titanData.moves = copyTable(data.moves)
  local movesData = {}
  for i=1, #data.moves do
    local moveData = copyTable(Global.call("GetMoveDataByName", data.moves[i]))
    moveData.status = DEFAULT
    moveData.isTM = false
    table.insert(movesData, moveData)
  end
  titanData.movesData = movesData

  titanData.model_GUID = data.model_GUID
  titanData.custom_scale = data.custom_scale
end

function uninitGym()
  titanData = nil
  titanGuid = nil
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