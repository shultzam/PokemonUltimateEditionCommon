-- Roll data Keys.
KEY_D4 = "d4"
KEY_D6 = "whited6"
KEY_EFFECT = "redd6"
KEY_D8 = "d8"
KEY_MOVEMENT = "movement"

-- Lookup table for nice printouts.
SANITIZED_ROLL_TYPES = {
  [KEY_D4] = "D4",
  [KEY_D6] = "Attack",
  [KEY_EFFECT] = "Effect",
  [KEY_D8] = "Crit",
  [KEY_MOVEMENT] = "Movement"
}

-- Reported data keys.
KEY_CATCH = "catch"
KEY_WILD = "wild"
KEY_BATTLE = "battle"

VALUE_SUCCESS =  1
VALUE_FAILURE = -1

-- Roll Data.
roll_data = { }

-- Reported Data.
reported_data = { }

function onSave()
  local save_table = {
    roll_data=roll_data,
    reported_data=reported_data
  }
  return JSON.encode(save_table)
end

function onLoad(saved_data)
  -- Make this object not interactable.
  self.interactable = false
  self.setLock(true)
  self.setPosition({97.38, 1.96, 70.10})
  self.setRotation({0, 180, 0})

  local save_table
  if saved_data and saved_data ~= "" then
    save_table = JSON.decode(saved_data)
  end

  if save_table then
    roll_data=save_table.roll_data
    reported_data=save_table.reported_data
  end

  -- Do some safety checks.
  if roll_data == nil then
    roll_data = {}
  end
  if reported_data == nil then
    reported_data = {}
  end
  
  -- Create the button on top of the object to print current data.
  -- Left-click prints data to everone. Right-click prints data to self only.
  self.createButton({
    label="Print Roll Data",
    click_function="print_dice_rolls",
    function_owner=self,
    tooltip="Click to see roll your data",
    position={0, 0.5, 0},
    height=300,
    width=1350,
    font_size=200,
    color="White"
  })
end

-- Params:
--  TODO
function add_to_reported_data(params)
  -- Check that the type table exists.
end

function get_reported_data(player)

end

-- Params:
--  dice_type
--    whited6
--    redd6
--    d8
--    d4
--    movement
--  value
--  player_name
function record_dice_roll(params)
  -- Sanitizie the inputs.
  if params == nil then
    print("Record Keeper is rejecting data because no data was given; required: player_name, dice_type, value")
    return
  end
  if params.player_name == nil or params.dice_type == nil or params.value == nil then
    local data = {
      player_name = params.player_name or "nil",
      dice_type = params.dice_type or "nil",
      value = params.value or "nil"
    }
    print("Record Keeper is rejecting new data because data is missing: " .. dump_table(data))
    return
  end
  if type(params.value) ~= "number" then
    print("Record Keeper is rejecting new data because the value is not a number: " .. tostring(params.value))
    return
  end

  -- Ensure everything is a table.
  if roll_data[params.player_name] == nil then
    roll_data[params.player_name] = {}
  end
  if roll_data[params.player_name][params.dice_type] == nil then
    roll_data[params.player_name][params.dice_type] = {}
  end

  -- Insert the data.
  table.insert(roll_data[params.player_name][params.dice_type], params.value)
end

-- Fucntion to handle external requests for data.
function handle_roll_stats_request(params)
  -- Check for params.
  if params == nil or params.color == nil then return end

  print_dice_rolls(nil, params.color, nil)
end

-- Function called when clicking the button above the Record Keeper.
function print_dice_rolls(obj, color, alt)
  -- Get the roll data for the player.
  local data = get_roll_data(color, nil, alt)

  -- Check for data.
  if data == nil or data.roll_data == nil then
    -- get_roll_data() will log data not found.
    return
  end

  -- Print the data.
  printToAll(data.player .. "'s roll data:", color)
  for data_key, roll_table in pairs(data.roll_data) do
    local roll_type = data_key
    if SANITIZED_ROLL_TYPES[roll_type] ~= nil then
      roll_type = SANITIZED_ROLL_TYPES[roll_type]
    end

    -- Print the roll type.
    printToAll(print_string)
    
    -- Loop through metrics.
    for metric_key, value in pairs(roll_table) do
      if metric_key ~= "total" then
        if type(value) ~= "number" then value = 0 end
        printToAll("    " .. metric_key .. ": " .. tostring(value):sub(1,4))
      end
    end
  end
end

-- Returns a table with the player name and all recorded roll data in roll_data.
function get_roll_data(player, type, alt)
  -- Try to get the proper player name. player should just be the color.
  local color = player
  if roll_data[player] == nil then
    if Player[player] ~= nil then
      player = Player[player].steam_name
    end
  end

  -- If player is still nil then just return.
  if player == nil then
    printToAll("Failed to find player: " .. tostring(color))
    return { player = player }
  end

  -- Check if there is data.
  if roll_data[player] == nil then
    printToAll("No roll data found for " .. player)
    return { player = player }
  end
  if type ~= nil and roll_data[player][type] == nil then
    printToAll("No " .. tostring(type) .. " roll data found for " .. player)
    return { player = player }
  end

  -- Print the roll data.
  if type ~= nil then
    -- Return only the roll data of one type.
    return get_table_data(roll_data[player][type])
  else
    -- Return all roll data for this player.
    local return_table = {}
    return_table.roll_data = {}
    for key, roll_table in pairs(roll_data[player]) do
      return_table.roll_data[key] = get_table_data(roll_table)
    end

    -- Include the actual player name in the data.
    return_table.player = player

    -- Return the data.
    return return_table
  end
end

-- Helper function to get the mean of a table of values.
function mean(input_table)
  -- Ensure the data is a table.
  if type(input_table) ~= "table" then
    print("Cannot get sum for input parameter: not a table")
    return
  end

  -- Init some variables.
  local sum = 0
  local count= 0

  for k,v in pairs(input_table) do
    if type(v) == 'number' then
      sum = sum + v
      count = count + 1
    end
  end

  return (sum / count)
end

-- Helper function to get the standard deviation of a table of values.
function std_deviation(input_table)
  -- Ensure the data is a table.
  if type(input_table) ~= "table" then
    print("Cannot get sum for input parameter: not a table")
    return
  end

  -- Init some values.
  local vm
  local sum
  local sum = 0
  local count = 0
  local m = mean(input_table)

  -- Calculate.
  for k, v in pairs(input_table) do
    if type(v) == 'number' then
      vm = v - m
      sum = sum + (vm * vm)
      count = count + 1
    end
  end

  local result = math.sqrt(sum / (count-1))
  return result
end

-- Helper function to get the average and total of all values in a table.
-- Returns table with mean, std_dev and total.
function get_table_data(input_table)
  -- Ensure the data is a table.
  if type(input_table) ~= "table" then
    print("Cannot get metrics for input parameter: not a table")
    return
  end

  -- Return the data.
  local data = {
    mean = mean(input_table),
    std_dev = std_deviation(input_table),
    total = #input_table
  }
  return data
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