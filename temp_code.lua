

-- TEMP
local genPokeballs = { "681d76", "d7d981", "818525", "30391b", "758036", "bb73fd", "78fdbb", "d87f03", "2fd969", "2c76f4", 
"710bab", "521e8b", "9f4fb9", "f5d806", "e05c61", "b3ede1", "80c3c3", "5ded3e", "4f4570", "ee7d71", "feea6b", "be7627", 
"8079e7", "49e675", "f7a234", "fadfc3", "a63903", "9f5985", "291a17", "890df4", "1341cb", "6ee713", "de1f71", "48a192", 
"296ec5", "590ae3", "d80d72", "ce15ef", "9fe972", "7f1ebb", "401e23", "1fa353", "426038", "b3a265", "a77d5e", "44c820", 
"4903d2", "652a56", "405d8e", "307988", "09cb0e", "99b8aa", "d6ef76", "0faf4d", "ad4ceb", "a1750a", "3168f8", "de981e", 
"7ced83", "345260", "d63e7c", "3fcea5", "79df8a" }
local genEvoPokeballs = { "e9d043", "7de53d", "f30baf", "ceb9a5", "5293ec", "98bf25", "01efbd", "c6e80b", "d86df8", "f59319", 
"538c67", "6f201a", "ad0f19", "02db20", "31b1ec", "9b3ecb", "613cb1", "1b49a8", "8d3dfb", "fd9bcb", "1bf5ba", "cccfb4", 
"e15056", "24a5c8", "a7d340", "bfb915", "7eb6b9", "96a1c9", "db9cda", "425115", "aefa83", "cb4ad6", "e16953", "8abcf1", 
"59de2d", "315a95", "f02e17", "943c81", "c67911", "de7f1f", "750e11", "21b1c8", "6d2737", "2b7b9b", "79e3f4", "21ba50", 
"74eeff", "432142", "79ee2f", "bc1673", "4f7b73", "2d873a", "a32b0d", "d2b2ca", "637026", "02689f", "9c010b", "03ea82", 
"4217d6", "6ae5c4", "8963b5", "0dc3f5", "4e3f1d" }
local battlemodelsList = { battlemodels_GUID }

-- TEMP | Apply appropriate tag to all pokemon chips and all models.
-- NOTE: this code would go into onLoad() in Global.lua.
--[[
  1. Spawn in the TEMP TAG POKEBALL
  2. Copy the genXPokeballs and genXEvoPokeballs from StarterPokeball.lua to this file.
  3. Run the following on one list at a time.
  4. Save game.
]]
local pokeballs_list = genPokeballs
for pokeball_index=1, #pokeballs_list do
  -- Get handle to the home pokeball and temp pokeball.
  local home_pokeball = getObjectFromGUID(pokeballs_list[pokeball_index])
  local temp_pokeball = getObjectFromGUID("e08c3e")

  -- Loop through each item in the pokeball.
  for token_index = 1, #home_pokeball.getObjects() do
    -- Take object from home pokeball.
    local token = home_pokeball.takeObject({})

    -- Apply the tag to the Pokemon TOKEN.
    token.addTag("Pokemon Token")

    -- Put the Pokemon into  into the temp pokeball.
    temp_pokeball.putObject(token)
  end

  -- Now take the object back from the temp pokeball and put them back 
  -- into the home pokeball.
  for token_index = 1, #temp_pokeball.getObjects() do
    home_pokeball.putObject(temp_pokeball.takeObject({}))
  end
end

local pokeballs_list = genEvoPokeballs
for pokeball_index=1, #pokeballs_list do
  -- Get handle to the home pokeball and temp pokeball.
  local home_pokeball = getObjectFromGUID(pokeballs_list[pokeball_index])
  local temp_pokeball = getObjectFromGUID("e08c3e")

  -- Loop through each item in the pokeball.
  for token_index = 1, #home_pokeball.getObjects() do
    -- Take object from home pokeball.
    local token = home_pokeball.takeObject({})

    -- Apply the tag to the Pokemon TOKEN.
    token.addTag("Pokemon Token")

    -- Put the Pokemon into  into the temp pokeball.
    temp_pokeball.putObject(token)
  end

  -- Now take the object back from the temp pokeball and put them back 
  -- into the home pokeball.
  for token_index = 1, #temp_pokeball.getObjects() do
    home_pokeball.putObject(temp_pokeball.takeObject({}))
  end
end

-- The models take much more effort. Move them back and forth into the temp pokeball on seperate saves.
local pokeballs_list = battlemodelsList
for pokeball_index=1, #pokeballs_list do
  -- Get handle to the home pokeball and temp pokeball.
  local home_pokeball = getObjectFromGUID(pokeballs_list[pokeball_index])
  local temp_pokeball = getObjectFromGUID("e08c3e")

  -- Loop through each item in the pokeball.
  for model_index = 1, #home_pokeball.getObjects() do
    -- Take object from home pokeball.
    local model = home_pokeball.takeObject({})

    -- Apply the tag to the Pokemon Model.
    model.addTag("Pokemon Model")

    -- Put the Pokemon into  into the temp pokeball.
    temp_pokeball.putObject(model)
  end
end

-- Get handle to the home pokeball and temp pokeball.
local home_pokeball = getObjectFromGUID(battlemodels_GUID)
local temp_pokeball = getObjectFromGUID("e08c3e")

-- Loop through each item in the pokeball.
for model_index = 1, #temp_pokeball.getObjects() do
  -- Take object from home pokeball.
  local model = temp_pokeball.takeObject({})

  -- Put the Pokemon into the home pokeball.
  home_pokeball.putObject(model)
end