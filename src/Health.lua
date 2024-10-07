--[[
    Clean Counters v1.0.0

    
    Description:
    Clean Counters is exactly that! A nice looking counter.

    Clean Counters has a few features:
    - Left/Right click the name to increment or decrement the value.
    - Set the value directly by clicking on the value.
    - Name the counter by changing the object name. (You will need to update the value for the new name to show.)
    - Change the token color by changing the tint.
    - Toggle between black/white font using the context menu (Right-click object).
    - Toggle between using a value prefix like in RPG games for stats using the context menu.

    This mod was heavily inspired by the "Stats Counter" mod created by Steam user
    "Baobots". The same token was used, but the script is written from scratch.
    https://steamcommunity.com/sharedfiles/filedetails/?id=2352739177



    Changelog:
    9/3/2024 - Modified by Allen S. for usage in Pokemon Master Trainer Ultimate Edition (various mods)

    

    License (MIT):

    Copyright 2021 GBee

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in 
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
    of the Software, and to permit persons to whom the Software is furnished to do 
    so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all 
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
    THE SOFTWARE.
--]]


--[[ ===== CONSTANTS ===== --]]
FONT_COLOR_LIGHT = {1, 1, 1, 100}
FONT_COLOR_DARK  = {0, 0, 0, 100}
FONT_SIZE       = 1000
FONT_SIZE_SMALL = 750
VALUE_POS       = {0, 0.1, 0}
VALUE_POS_SMALL = {0, 0.1, -0.2}
TRANSPARENT     = {0, 0, 0, 0}

--[[
    Occurs when the object is loaded.
--]]
function onLoad(save_state)
    -- Load previous object state.
    if save_state == nil or save_state == "" then
        script_state = {
            value = 0,
            label = "Token",
            use_prefix = false,
            light_font = false,
        }
    else
        script_state = JSON.decode(save_state)
    end
    
    -- Create User-Interface.
    createUserInterface()
end

--[[
    Occurs when the object is saved.
--]]
function onSave()
    saved_data = JSON.encode(script_state)
    return saved_data
end

--[[
    Creates the initial user interface.
--]]
function createUserInterface() 
    self.createInput({
        function_owner = self,
        input_function = "onValueChanged",
        position = {0,0.1,-0.45},
        value = script_state.value,
        alignment = 3,
        height = 600,
        width = 1500,
        color = TRANSPARENT,
    })    

    self.createButton({
        click_function = "onIncrementDecrementClick",
        tooltip = "+/-",
        function_owner = self,
        position = {0,0.1,1.55},
        height = 600,
        width = 1500,
        font_size = 250,
        color = TRANSPARENT
    })

    self.addContextMenuItem("Toggle Prefix",
        function()
            script_state.use_prefix = not script_state.use_prefix
            refreshTokenUI()
        end, false)

    self.addContextMenuItem("Toggle Font Color",
        function()
            script_state.light_font = not script_state.light_font
            refreshTokenUI()
        end, false)

    refreshTokenUI()
end

--[[
    Occurs when a player manually changes the token value.
--]]
function onValueChanged(obj, color, input, stillEditing)
    if not stillEditing then
        if input == nil or input == "" then
            script_state.value = 0
        else
            local val = tonumber(input)
            if val ~= nil then
                script_state.value = val
            end
        end
        
        Wait.frames(refreshTokenUI, 1)
    end
end

--[[
    Occurs when the label is clicked.
    If right-clicked, the value will be decremented.
    If left-clicked the value will be incrememented.
--]]
function onIncrementDecrementClick(obj, color, alt)
    if alt then
        script_state.value = script_state.value - 1
    else
        script_state.value = script_state.value + 1
    end

    refreshTokenUI()
end

--[[
    Redisplays the new value and label.
--]]
function refreshTokenUI()
    -- Get current name for label.
    script_state.label = self.getName()

    -- Decide how to display the current value.
    local display_value = tostring(script_state.value)
    if script_state.use_prefix then
        display_value = toStringWithPrefix(script_state.value, true)
    end

    -- Decide the font size and value placement.
    local display_font_size = FONT_SIZE
    local display_value_pos = VALUE_POS
    if script_state.use_prefix then
        if math.abs(script_state.value) > 99 then
            display_font_size = FONT_SIZE_SMALL
            display_value_pos = VALUE_POS_SMALL
        end
    else
        if math.abs(script_state.value) > 999 then
            display_font_size = FONT_SIZE_SMALL
            display_value_pos = VALUE_POS_SMALL
        end
    end

    -- Decide font color.
    local display_font_color = FONT_COLOR_DARK
    if script_state.light_font then
        display_font_color = FONT_COLOR_LIGHT
    end

    -- Refresh UI
    self.editButton({
        index      = 0,
        label      = script_state.label,
        font_color = display_font_color,
    })

    --[[
        I ran into some strange behavior with self.editInput(...) when trying to
        change the font color. I found the only way to may it work consistently
        was to remove the input and recreate it.
    --]]
    self.removeInput(0)
    self.createInput({
        function_owner = self,
        input_function = "onValueChanged",
        position = display_value_pos,
        font_size  = display_font_size,
        font_color = display_font_color,
        value = display_value,
        alignment = 3,
        height = 800,
        width = 1500,
        color = TRANSPARENT,
    }) 
end

--[[
    Converts a number to a string with a prefix [+,-].
--]]
function toStringWithPrefix(num)
    if num >= 0 then
        return "+" .. tostring(num)
    else
        return tostring(num)
    end
end