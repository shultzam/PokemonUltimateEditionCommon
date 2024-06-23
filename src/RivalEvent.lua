local pinkButtonPos = {-0.75, -1.0, 1.5}
local greenButtonPos = {0, -1.0, 1.5}
local blueButtonPos = {0.75, -1.0, 1.5}
local yellowButtonPos = {-0.375, -1.0, 2.25}
local redButtonPos = {0.375, -1.0, 2.25}

local region = nil
local trainerName = nil
local pokemonData = nil
local battleManager = "de7152"

-- Event Rival region table.
local REGION_TABLE = {
  "Kanto",
  "Johto",
  "Hoenn",
  "Sinnoh",
  "Unova",
  "Kalos",
  "Alola",
  "Galar",
  "Paldea",
}

function onSave()
  local saved_data = JSON.encode({saveRegion=region, saveTrainerName=trainerName, savePokemonData=pokemonData})
  return saved_data
end

function onLoad(saved_data)
  if saved_data ~= "" and saved_data ~= nil then
    local loaded_data = JSON.decode(saved_data)
    if loaded_data.saveRegion ~= nil and loaded_data.saveTrainerName ~= nil and loaded_data.savePokemonData ~= nil then
      region = loaded_data.saveRegion
      trainerName = loaded_data.saveTrainerName
      pokemonData = copyTable(loaded_data.savePokemonData)
    end
  end

  -- Create the buttons and hide them if there is no data.
  createButtons()
  moveAllButtons(pokemonData ~= nil)
end

function createButtons()  
  self.createButton({
    label="+", click_function="battlePink",
    function_owner=self, tooltip="Start Pink Rival Event Battle",
    position=pinkButtonPos, rotation={0,0,0}, height=350, width=350, font_size=400, color={255, 0, 255}
  })
  self.createButton({
    label="+", click_function="battleGreen",
    function_owner=self, tooltip="Start Green Rival Event Battle",
    position=greenButtonPos, rotation={0,0,0}, height=350, width=350, font_size=400, color={0, 255, 0}
  })
  self.createButton({
    label="+", click_function="battleBlue",
    function_owner=self, tooltip="Start Blue Rival Event Battle",
    position=blueButtonPos, rotation={0,0,0}, height=350, width=350, font_size=400, color={0, 0, 255}
  })
  self.createButton({
    label="+", click_function="battleYellow",
    function_owner=self, tooltip="Start Yellow Rival Event Battle",
    position=yellowButtonPos, rotation={0,0,0}, height=350, width=350, font_size=400, color={255, 255, 0}
  })
  self.createButton({
    label="+", click_function="battleRed",
    function_owner=self, tooltip="Start Red Rival Event Battle",
    position=redButtonPos, rotation={0,0,0}, height=350, width=350, font_size=400, color={255, 0, 0}
  })
end

function moveOtherButtons(visible)
  local yPos = visible and -1.0 or 1000
  self.editButton({index=0, position={pinkButtonPos[1], yPos, pinkButtonPos[3]}})
  self.editButton({index=2, position={blueButtonPos[1], yPos, blueButtonPos[3]}})
  self.editButton({index=3, position={yellowButtonPos[1], yPos, yellowButtonPos[3]}})
  self.editButton({index=4, position={redButtonPos[1], yPos, redButtonPos[3]}})
end

function moveAllButtons(visible)
  local yPos = visible and -1.0 or 1000
  self.editButton({index=0, position={pinkButtonPos[1], yPos, pinkButtonPos[3]}})
  self.editButton({index=1, position={greenButtonPos[1], yPos, greenButtonPos[3]}})
  self.editButton({index=2, position={blueButtonPos[1], yPos, blueButtonPos[3]}})
  self.editButton({index=3, position={yellowButtonPos[1], yPos, yellowButtonPos[3]}})
  self.editButton({index=4, position={redButtonPos[1], yPos, redButtonPos[3]}})
end

function battle(tier)

  if tier == nil then return end
  if pokemonData == nil then return end

  -- Determine which GUID to send out.
  local pokemonTokenInfo = getRivalPokemonGuid(tier)
  local params = {
    pokeballGUID = self.getGUID(),
    trainerName = trainerName,
    pokemonGUID = pokemonTokenInfo.guid,
    pokemonData = pokemonTokenInfo.pokemon
  }

  -- Send the appropriate pokemon token to the arena via the Battle Manager.
  local battleManager = getObjectFromGUID(battleManager)
  local sent = battleManager.call("sendToArenaRival", params)

  -- The battle manager will log any failure to send (we hope!).
  if not sent then
    return
  end

  -- Drop all buttons except the button that was pressed to send the token to the gym. Set the yPos to 1000.
  moveOtherButtons(false)

  -- Edit the button belonging to the tier to say recall.
  self.editButton({
      index=1, label="-", click_function="recall",
      function_owner=self, tooltip="Recall Rival Event Battle",
      position=greenButtonPos, rotation={0,0,0}, color={1, 1, 1}
  })
end

function battlePink()
  battle(1)
end

function battleGreen()
  battle(2)
end

function battleBlue()
  battle(3)
end

function battleYellow()
  battle(4)
end

function battleRed()
  battle(5)
end

function recall()
  local battleManager = getObjectFromGUID(battleManager)
  battleManager.call("recallRival")

  Global.call("PlayRouteMusic",{})

  self.editButton({
    index=1, label="+", click_function="battleGreen",
    function_owner=self, tooltip="Start Green Rival Event Battle",
    position=greenButtonPos, rotation={0,0,0}, color={0, 255, 0}
  })

  -- Bring the other buttons back.
  moveOtherButtons(true)
end

function setRivalRegion(regionArg)
  -- Save the region.
  region = regionArg

  if region == "Random" then
    region = REGION_TABLE[math.random(1, #REGION_TABLE)]
  end

  -- Filter and save off the appropriate pokemon data.
  local rivalData = Global.call("GetRivalDataByRegion", region)
  trainerName = rivalData.trainerName
  pokemonData = copyTable(rivalData.pokemonData)

  -- Show the buttons.
  moveAllButtons(true)
end

-- TODO: what was this used for?
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

-- Helper to get the GUID of the pokemon we want to send to the arena based on the tier. This
-- assumes that pokemonData is not nil but will check.
function getRivalPokemonGuid(tier)
  if tier == nil then return end
  if pokemonData == nil then return end

  -- Unless this data gets more complicated, we can just get the index.
  return pokemonData[tier]
end

-- Shallow-copy a table. If our rival data gets more complicated (nested tables, etc.) we will need a
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