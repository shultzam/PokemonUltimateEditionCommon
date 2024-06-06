--------------------------------------------------------------------------------
-- Rack Data
--------------------------------------------------------------------------------
local playerColour = "Red"

local diceBagGUID = "3c7dbc"
local figureGUID = "c036ba"

local evolveRotation = 180

local xRotSend = 0
local yRotSend = 0
local zRotSend = 0
local xRotRecall = 0
local yRotRecall = 0
local zRotRecall = 0

local rackPosition = {x=21.50,y=0.14,z=-48.00}

--------------------------------------------------------------------------------
-- Generic Data
--------------------------------------------------------------------------------
local battleManager = "de7152"

local isAttacking = false
local isDefending = false
local autoCamera = false

-- Positions
local badgesXPos = {0.15, -0.15, -0.35, -0.65, -0.85, -1.15, -1.35, -1.65}
local pokemonXPos = {1.475,0.885,0.295,-0.295,-0.885,-1.475}
local pokemonZPos = -0.1
local statusZPos = -0.5
local itemZPos = 0.46
local yLoc = 0.21 -- Button YPos
local zLoc = 0.89 -- Att/Def/Recall ZPos

-- Data
local rackData = {{},{},{},{},{},{}}

-- Arena Data
local inArena = false
local isAttacker = false
local arenaIndex = 0

function onLoad()
  self.tooltip = false

  self.createButton({label="REFRESH", click_function="rackRefreshPokemon", function_owner=self, tooltip="Refresh Pokémon", position={-0.80, yLoc, -0.92}, rotation={0,0,0}, height=60, width=150, font_size=30})
  self.createButton({label="POINTS", click_function="rackCalcPoints", function_owner=self, tooltip="Calculate Points", position={-0.80, yLoc, -0.79}, rotation={0,0,0}, height=60, width=150, font_size=30})
  self.createButton({label="FIGURE", click_function="panToPlayer", function_owner=self, tooltip="Move Camera to Trainer Figure", position={-1.37, yLoc, -0.815}, rotation={0,0,0}, height=52, width=150, font_size=30})
  self.createButton({label="ARENA", click_function="showArena", function_owner=Global, tooltip="Move Camera to Arena", position={-1.37, yLoc, -0.92}, rotation={0,0,0}, height=52, width=150, font_size=30})
  self.createButton({label="OFF", click_function="toggleAutoCamera", function_owner=self, tooltip="Toggle Auto Camera", position={-1.108, yLoc, -0.815}, rotation={0,0,0}, height=52, width=90, font_size=30})

  for i=1, 6 do
      local xPos = -1.6 + ( 0.59 * (i-1))
      self.createButton({label="ATT", click_function="attack"..i, function_owner=self, tooltip="",position={xPos, 1000, zLoc}, rotation={0,0,0}, height=60, width=130, font_size=30}) -- Attack Button
      self.createButton({label="DEF", click_function="defend"..i, function_owner=self, tooltip="",position={xPos + 0.26, 1000, zLoc}, rotation={0,0,0}, height=60, width=130, font_size=30}) -- Defend Button
      self.createButton({label="-", click_function="decrease"..i, function_owner=self, tooltip="",position={xPos - 0.09, 1000, 0.02}, rotation={0,0,0}, height=50, width=50, font_size=30}) -- Level Down Button
      self.createButton({label="+", click_function="increase"..i, function_owner=self, tooltip="",position={xPos + 0.34, 1000, 0.02}, rotation={0,0,0}, height=50, width=50, font_size=30}) -- Level Up Button
      self.createButton({label="RECALL", click_function="rackRecall", function_owner=self, tooltip="",position={-1.47 + ((i-1) * 0.59), 1000, zLoc}, rotation={0,0,0}, height=60, width=130, font_size=30,}) -- Recall Button
      self.createButton({label="E", click_function="evolve"..i, function_owner=self, tooltip="",position={pokemonXPos[7-i] + 0.215, 1000, pokemonZPos + 0.025}, rotation={0,0,0}, height=50, width=50, font_size=30}) -- Evolve Button
      self.createButton({label="1", click_function="evolve"..i, function_owner=self, tooltip="", position={pokemonXPos[7-i] + 0.19, 1000, pokemonZPos + 0.025}, rotation={0,0,0}, height=50, width=25, font_size=40}) -- Evolve1 Button
      self.createButton({label="2", click_function="evolveTwo"..i, function_owner=self, tooltip="",position={pokemonXPos[7-i] + 0.24, 1000, pokemonZPos + 0.025}, rotation={0,0,0}, height=50, width=25, font_size=40}) -- Evolve2 Button
  end
  rackRefreshPokemon()
end


function toggleAutoCamera()

  local buttonIndex = 4
  if autoCamera then
    autoCamera = false
    self.editButton({index=buttonIndex, label="OFF"})
  else
    autoCamera = true
    self.editButton({index=buttonIndex, label="ON"})
  end
end

function panToPlayer(obj, color)

  local pokeOnePosX = getObjectFromGUID(figureGUID).getPosition()[1]
  local pokeOnePosZ = getObjectFromGUID(figureGUID).getPosition()[3]

  Player[color].lookAt({
      position = {x=pokeOnePosX,y=0.14,z=pokeOnePosZ},
      pitch    = 60,
      yaw      = 0,
      distance = 25,
  })
end


function rackRefreshPokemon()
    local params = {
        pokemonXPos = pokemonXPos,
        pokemonZPos = pokemonZPos,
        rackData = rackData,
        xPos = xPos,
        yLoc = yLoc,
        zLoc = zLoc,
        rackGUID = self.getGUID()
    }

    local battleManager = getObjectFromGUID(battleManager)
    rackData = battleManager.call("refreshPokemon", params)
end


function rackSendToArena(params)

  inArena = true
  isAttacker = params.isAttacker
  arenaIndex = params.index
  local arenaParams = {
      index = params.index,
      isAttacker = params.isAttacker,
      zPos = pokemonZPos,
      slotData = rackData[params.index],
      inArena = true,
      playerColour = playerColour,
      pokemonXPos = pokemonXPos,
      pokemonZPos = pokemonZPos,
      pokemonLevels = pokemonLevels,
      statusZPos = statusZPos,
      itemArenaPos = itemArenaPos,
      statusArenaPos = statusArenaPos,
      itemZPos = itemZPos,
      xRotSend = xRotSend,
      yRotSend = yRotSend,
      zRotSend = zRotSend,
      yLoc = yLoc,
      zLoc = zLoc,
      rackGUID = self.getGUID(),
      autoCamera = autoCamera
  }

    getObjectFromGUID(battleManager).call("sendToArena", arenaParams)
end


function rackRecall()

  inArena = false
  local recallParams = {
      playerColour = playerColour,
      isAttacker = isAttacker,
      arenaAttack = arenaAttack,
      rackPosition = rackPosition,
      xRotRecall = xRotRecall,
      yRotRecall = yRotRecall,
      zRotRecall = zRotRecall,
      yLoc = yLoc,
      zLoc = zLoc,
      pokemonXPos = pokemonXPos,
      pokemonZPos = pokemonZPos,
      statusZPos = statusZPos,
      itemZPos = itemZPos,
      index = arenaIndex,
      arenaAttack = arenaAttack,
      rackGUID = self.getGUID(),
      autoCamera = autoCamera
  }
    getObjectFromGUID(battleManager).call("recall", recallParams)
end


function checkLevel(index, modifier, evolving)

    local params = {
        index = index,
        modifier = modifier,
        inArena = inArena,
        isAttacker = isAttacker,
        slotData = rackData[index],
        itemZPos = itemZPos,
        pokemonXPos = pokemonXPos,
        pokemonZPos = pokemonZPos,
        diceBagGUID = diceBagGUID,
        yRotRecall = yRotRecall,
        playerColour = playerColour,
        yLoc = yLoc,
        zLoc = zLoc,
        rackGUID = self.getGUID()
    }

    rackData[index] = getObjectFromGUID(battleManager).call("setLevel", params)
end


function rackEvolve(index, oneOrTwo)

    local evolveParams = {
        evolveRotation = evolveRotation,
        inArena = inArena,
        index = index,
        isAttacker = isAttacker,
        playerColour = playerColour,
        pokemonXPos = pokemonXPos,
        pokemonZPos = pokemonZPos,
        oneOrTwo = oneOrTwo,
        rackGUID = self.getGUID(),
        slotData = rackData[index]
    }

    local pokemonData = rackData[index]
    local evolveData = pokemonData.evoData[1]
    local evolveCost
    if type(evolveData.cost) == "string" then 
        evolveCost = 0
    else
        evolveCost = evolveData.cost
    end

    local evolveData = getObjectFromGUID(battleManager).call("evolvePoke", evolveParams)

    -- If we have multiple evolutions, the pokemon doesn't evolve straight away
    if evolveData ~= nil then
      rackData[index] = evolveData
    end

    checkLevel(index, -evolveCost, false)
end


function rackCalcPoints(obj, color)
    local pointsParams = {
        badgesXPos = badgesXPos,
        rackGUID = self.getGUID(),
        rackColour = playerColour,
        clickerColour = color,
        rackData = rackData
    }
    getObjectFromGUID(battleManager).call("calcPoints", pointsParams)
end

function updatePokemonData(params)

  print(params.index)
  print(params.pokemonGUID)

  local evolvedPokemonData = Global.call("GetPokemonDataByGUID",{guid=params.pokemonGUID})
  print(evolvedPokemonData.name)
  print(evolvedPokemonData.types[1])
  setNewPokemon(rackData[params.index], evolvedPokemonData, params.pokemonGUID)

end

function setNewPokemon(data, newPokemonData, pokemonGUID)

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

  data.pokemonGUID = pokemonGUID
  if newPokemonData.evoData ~= nil then
    data.evoData = copyTable(newPokemonData.evoData)
  else
    data.evoData = nil
  end
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

--------------------------------------------------------------------------------
-- SLOT BUTTON FUNCTIONS
--------------------------------------------------------------------------------

function attack1()

    rackSendToArena({index = 1, isAttacker = true})
end

function attack2()

    rackSendToArena({index = 2, isAttacker = true})
end

function attack3()

    rackSendToArena({index = 3, isAttacker = true})
end

function attack4()

    rackSendToArena({index = 4, isAttacker = true})
end

function attack5()

    rackSendToArena({index = 5, isAttacker = true})
end

function attack6()

    rackSendToArena({index = 6, isAttacker = true})
end

function defend1()

    rackSendToArena({index = 1, isAttacker = false})
end

function defend2()

    rackSendToArena({index = 2, isAttacker = false})
end

function defend3()

    rackSendToArena({index = 3, isAttacker = false})
end

function defend4()

    rackSendToArena({index = 4, isAttacker = false})
end

function defend5()

    rackSendToArena({index = 5, isAttacker = false})
end

function defend6()

    rackSendToArena({index = 6, isAttacker = false})
end

function increase1()

    checkLevel(1, 1, false)
end

function increase2()

    checkLevel(2, 1, false)
end

function increase3()

    checkLevel(3, 1, false)
end

function increase4()

    checkLevel(4, 1, false)
end

function increase5()

    checkLevel(5, 1, false)
end

function increase6()

    checkLevel(6, 1, false)
end

function decrease1()

    checkLevel(1, -1, false)
end

function decrease2()

    checkLevel(2, -1, false)
end

function decrease3()

    checkLevel(3, -1, false)
end

function decrease4()

    checkLevel(4, -1, false)
end

function decrease5()

    checkLevel(5, -1, false)
end

function decrease6()

    checkLevel(6, -1, false)
end

function evolve1()

    rackEvolve(1, 1)
end

function evolve2()

    rackEvolve(2, 1)
end

function evolve3()

    rackEvolve(3, 1)
end

function evolve4()

    rackEvolve(4, 1)
end

function evolve5()

    rackEvolve(5, 1)
end

function evolve6()

    rackEvolve(6, 1)
end

function evolveTwo1()

    rackEvolve(1, 2)
end

function evolveTwo2()

    rackEvolve(2, 2)
end

function evolveTwo3()

    rackEvolve(3, 2)
end

function evolveTwo4()

    rackEvolve(4, 2)
end

function evolveTwo5()

    rackEvolve(5, 2)
end

function evolveTwo6()

    rackEvolve(6, 2)
end

--------------------------------------------------------------------------------
-- ARENA BUTTON FUNCTIONS
--------------------------------------------------------------------------------

function increase(mParams)

    checkLevel(arenaIndex, 1)
end

function decrease(mParams)

  checkLevel(arenaIndex, -1)
end

function evolveArena(attDefParams)

    if inArena != false then
        rackEvolve(arenaIndex, 1)
    end
end

function evolveTwoArena(attDefParams)

    if inArena != false then
        rackEvolve(arenaIndex, 2)
    end
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