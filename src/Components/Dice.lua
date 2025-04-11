function onLoad()
    lifespan = 3
    spin_speed = 0
    rise_speed = 2
    grow_speed = 0
    font_size = 5
    flash_max = true
    sound_max = false
    sound_min = false
    log_chat = false
    parent_guid = "card01"
    roll_active = false
    rv = self.getRotationValues() or false
    -- Custom additions.
    do_rising_text = false
    dice_type = "movement"
    RECORD_KEEPER_GUID = "ab319d"
end

function onDrop(a)
    -- trigger(a)
end

function onRandomize(a)
    trigger(a)
end

function trigger(a)
    if roll_active then
        return false
    end
    roll_active = true
    Wait.condition(function()
        roll_active = false
        local b = self.getRotationValue() or false
        -- Adjust D8 values for crit dice.
        if dice_type == "d8" then
          if b == 6 then
            b = 5
          elseif b == 7 or b == 8 then
            b = 6
          end
        end
        if not b or not rv then
            log("Dice " .. self.guid .. " does not have a valid rotation value set! Unable to show roll value.")
            return false
        end
        local c = self.getPosition() + Vector({0, 1 + font_size / 5, 0})
        local d = nil
        if do_rising_text then
          d = spawnObject({
              type = "3DText",
              position = c,
              sound = true
          })
          d.TextTool.setValue(tostring(b))
          d.TextTool.setFontColor(self.getColorTint())
          d.TextTool.setFontSize(font_size * 24)
        end
        Wait.frames(function()
            -- Record the rolled value of the die.
            local record_keeper = getObjectFromGUID(RECORD_KEEPER_GUID)
            if record_keeper then
              record_keeper.call("record_dice_roll", { dice_type = dice_type, value = b, player_name = Player[a].steam_name })
            end

            if do_rising_text then
              d.interactable = false
              d.auto_raise = false
              rise(d, c)
              spin(d, {0, spin_speed * 18, 0})
              grow(d, font_size * 24)
            end
            log("Score is " .. b)
            if log_chat then
                local e = a
                if self.getName() and self.getName() ~= "" then
                    e = e .. " | " .. self.getName()
                end
                printToAll("[" .. e .. "] " .. Player[a].steam_name .. " rolled a " .. b, a)
            end
            local max_val = rv[#rv].value
            if dice_type == "d8" then max_val = 6 end
            if do_rising_text and ((sound_max or flash_max) and b == max_val) then
                if flash_max then
                    flash(self)
                    flash(d)
                end
                if sound_max and getObjectFromGUID(parent_guid) then
                    getObjectFromGUID(parent_guid).AssetBundle.playTriggerEffect(0)
                end
            end
            if b == 1 and sound_min and getObjectFromGUID(parent_guid) then
                getObjectFromGUID(parent_guid).AssetBundle.playTriggerEffect(1)
            end
            Wait.time(function()
              if do_rising_text then d.destruct() end
            end, lifespan)
        end, 1)
    end, function()
        return self.resting
    end, 30, function()
        log("Timeout exceeded waiting for dice to come to a stop")
        roll_active = false
    end)
end

function rise(d, c)
    if not getObjectFromGUID(d.guid) then
        return false
    end
    d.setPosition(c)
    c[2] = c[2] + rise_speed / 100;
    Wait.frames(function()
        rise(d, c)
    end, 1)
end

function spin(d, f)
    if not getObjectFromGUID(d.guid) then
        return false
    end
    d.setRotationSmooth(f, false, true)
    f[2] = f[2] + spin_speed * 5;
    Wait.time(function()
        spin(d, f)
    end, 0.5)
end

function grow(d, font_size)
    if not getObjectFromGUID(d.guid) then
        return false
    end
    d.TextTool.setFontSize(font_size)
    Wait.time(function()
        grow(d, font_size * (grow_speed + 100) / 100)
    end, 0.1)
end

function flash(d, g)
    if not getObjectFromGUID(d.guid) or g and g > 20 then
        return false
    end
    local a = g or 1;
    local h = self.getColorTint()
    if a % 2 == 0 then
        h = randomColor()
    end
    if d.tag == "3D Text" then
        d.TextTool.setFontColor(h)
    else
        d.highlightOn(h, 0.1)
    end
    Wait.time(function()
        flash(d, a + 1)
    end, 0.2)
end

function randomColor()
    local i = math.random;
    return {i(255) / 255, i(255) / 255, i(255) / 255}
end
