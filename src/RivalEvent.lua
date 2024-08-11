local pinkButtonPos = {-1.6, -3.15, 5}
local greenButtonPos = {0, -3.15, 5}
local blueButtonPos = {1.6, -3.15, 5}
local yellowButtonPos = {-0.8, -3.15, 6.5}
local redButtonPos = {0.8, -3.15, 6.5}

local region = nil
local trainerName = nil
local pokemonData = nil
local battleManager = "de7152"

-- Model button fields.
-- NOTE: It is pretty silly to tie the model buttons to this object but Rival Event object is permanent and really close to 
--       the button locations. I am not proud, but may the future developers here not judge me too harshly.
local MODEL_SIZE_CHANGE_STEP = 1.5
local SPAWN_DELAY_CHANGE_STEP = 0.1
local optionX = -45.0
local optionY = -3.15
local optionZ = -3.2
local options_shown = false
local option_buttons = {}

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

  -- Model button functionality
  self.tooltip = false
  self.createButton({ --Apply settings button
      label="3D Model Options", click_function="click_model_options",
      function_owner=self, tooltip="Click to show options for the 3D models",
      position={optionX, optionY, optionZ}, height=2000, width=7000, font_size=1000,
  })
end

function createButtons()  
  self.createButton({
    label="+", click_function="battlePink",
    function_owner=self, tooltip="Start Pink Rival Event Battle",
    position=pinkButtonPos, height=700, width=700, font_size=400, color={255, 0, 255}
  })
  self.createButton({
    label="+", click_function="battleGreen",
    function_owner=self, tooltip="Start Green Rival Event Battle",
    position=greenButtonPos, height=700, width=700, font_size=400, color={0, 255, 0}
  })
  self.createButton({
    label="+", click_function="battleBlue",
    function_owner=self, tooltip="Start Blue Rival Event Battle",
    position=blueButtonPos, height=700, width=700, font_size=400, color={0, 0, 255}
  })
  self.createButton({
    label="+", click_function="battleYellow",
    function_owner=self, tooltip="Start Yellow Rival Event Battle",
    position=yellowButtonPos, height=700, width=700, font_size=400, color={255, 255, 0}
  })
  self.createButton({
    label="+", click_function="battleRed",
    function_owner=self, tooltip="Start Red Rival Event Battle",
    position=redButtonPos, height=700, width=700, font_size=400, color={255, 0, 0}
  })
end

function moveOtherButtons(visible)
  local yPos = visible and -3.15 or 1000
  self.editButton({index=0, position={pinkButtonPos[1], yPos, pinkButtonPos[3]}})
  self.editButton({index=2, position={blueButtonPos[1], yPos, blueButtonPos[3]}})
  self.editButton({index=3, position={yellowButtonPos[1], yPos, yellowButtonPos[3]}})
  self.editButton({index=4, position={redButtonPos[1], yPos, redButtonPos[3]}})
end

function moveAllButtons(visible)
  local yPos = visible and -3.15 or 1000
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
    position=greenButtonPos, color={1, 1, 1}
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
    position=greenButtonPos, color={0, 255, 0}
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

-- Helper to get the GUID of the pokemon we want to send to the arena based on the tier. This
-- assumes that pokemonData is not nil but will check.
function getRivalPokemonGuid(tier)
  if tier == nil then return end
  if pokemonData == nil then return end

  -- Unless this data gets more complicated, we can just get the index.
  return pokemonData[tier]
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

function click_model_options()
  if options_shown then
    options_shown = false
    for _,button_id in ipairs(option_buttons) do
      local button = findButton(button_id)
      if button then self.removeButton(button.index) end
    end
    option_buttons = {}
  else
    options_shown = true

    -- Enable Models
    self.createButton({
      label="Enable Models", click_function="splash", function_owner=self,
      position={optionX-3.0,optionY,optionZ+3.0}, height=0, width=0, font_size=600, font_color={1,1,1}
    })
    register_button("Enable Models")
    self.createButton({
      label="", click_function="toggle_models",
      function_owner=self, tooltip="Check to enable 3D models",
      position={optionX+2.0,optionY,optionZ+3.0}, height=400, width=400, font_size=600
    })
    register_button("toggle_models")
    set_enable_button()

    -- Model size
    self.createButton({
      label="Model Size", click_function="splash", function_owner=self,
      position={optionX-3.0,optionY,optionZ+4.5}, height=0, width=0, font_size=600, font_color={1,1,1}
    })
    register_button("Model Size")
    self.createButton({
      click_function="decrease_model_size",
      function_owner=self, tooltip="Click to decrease the model size",
      position={optionX+1.5,optionY,optionZ+4.5}, height=400, width=400, font_size=600, label="-"
    })
    register_button("decrease_model_size")
    self.createButton({
      click_function="increase_model_size",
      function_owner=self, tooltip="Click to increase the model size",
      position={optionX+2.5,optionY,optionZ+4.5}, height=400, width=400, font_size=600, label="+"
    })
    register_button("increase_model_size")

    -- Spawn delay
    self.createButton({
      label="Spawn Delay", click_function="splash", function_owner=self,
      position={optionX-3.25,optionY,optionZ+6.0}, height=0, width=0, font_size=600, font_color={1,1,1}
    })
    register_button("Spawn Delay")
    self.createButton({
      label="", click_function="splash_spawn_delay", function_owner=self,
      position={optionX+4.7,optionY,optionZ+6.0}, height=0, width=0, font_size=600, font_color={1,1,1}
    })
    register_button("splash_spawn_delay")
    set_spawn_delay_label()
    self.createButton({
      click_function="decrease_spawn_delay",
      function_owner=self, tooltip="Click to decrease the delay before the spawn animation shows (useful if some players cannot see the spawn animations).",
      position={optionX+1.5,optionY,optionZ+6.0}, height=400, width=400, font_size=600, label="-"
    })
    register_button("decrease_spawn_delay")
    self.createButton({
      click_function="increase_spawn_delay",
      function_owner=self, tooltip="Click to increase the delay before the spawn animation shows (useful if some players cannot see the spawn animations).",
      position={optionX+2.5,optionY,optionZ+6.0}, height=400, width=400, font_size=600, label="+"
    })
    register_button("increase_spawn_delay")
  end
end

function register_button(button_id)
  option_buttons[#option_buttons+1] = button_id
end

--Locates a button with a helper function
function findButton(button_id)
  for _, button in ipairs(self.getButtons()) do
    if button.label == button_id or button.click_function == button_id then
      return button
    end
  end
  return nil
end

function set_enable_button()
  local enable_button = findButton("toggle_models")
  if Global.call("get_models_enabled") then
    self.editButton({index=enable_button.index, label=string.char(10004), color={0,1,0}})
  else
    self.editButton({index=enable_button.index, label="", color={1,1,1}})
  end
end

function toggle_models()
  Global.Call("toggle_models_enabled")
  set_enable_button()
end

function increase_model_size()
  Global.Call("scale_models", {scale=MODEL_SIZE_CHANGE_STEP})
end

function decrease_model_size()
  Global.Call("scale_models", {scale=1/MODEL_SIZE_CHANGE_STEP})
end

function set_spawn_delay_label()
  local spawn_delay_label = findButton("splash_spawn_delay")
  self.editButton({index=spawn_delay_label.index, label=string.format("(%.1fs)", Global.Call("get_spawn_delay"))})
end

function increase_spawn_delay()
  Global.Call("increase_spawn_delay", {delay=SPAWN_DELAY_CHANGE_STEP})
  set_spawn_delay_label()
end

function decrease_spawn_delay()
  Global.Call("increase_spawn_delay", {delay=-SPAWN_DELAY_CHANGE_STEP})
  set_spawn_delay_label()
end

function splash()
  --But nothing happened!
end

function splash_spawn_delay()
  --Nothing happened! But with style.
end