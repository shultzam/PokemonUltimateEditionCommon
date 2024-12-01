SHOP_DECK_GUID = "fdf0f6"
BOOSER_DECK_GUID = "acfa1d"

PLAYER_COIN_GUIDS = {
  Yellow = "b08b0e",
  Green = "fe0861",
  Blue = "92cb92",
  Red = "252975",
  Purple = "b15f1b",
  Orange = "68de04"
}

CARDS = {
  -- Left.
  poke_ball = { name = "Poke Ball", cost = 4},
  great_ball = { name = "Great Ball", cost = 8},
  ultra_ball = { name = "Ultra Ball", cost = 12},
  apricorn = { name = "Apricorn", cost = 8},
  potion = { name = "Potion", cost = 4},
  max_potion = { name = "Max Potion", cost = 8},
  revive = { name = "Revive", cost = 6},
  max_revive = { name = "Max Revive", cost = 16},
  full_heal = { name = "Full Heal", cost = 2},
  escape_rope = { name = "Escape Rope", cost = 2},
  bicycle = { name = "Bicycle", cost = 16},
  poke_doll = { name = "Poke Doll", cost = 4},
  berry = { name = "Berry", cost = 8},
  -- Right.
  boost_item = { name = "Boost Item", cost = 4},
  vitamin = { name = "Vitamin", cost = 25},
  -- legendary_evo_item (12)
  tm = { name = "Technical Machine", cost = 12},
  type_enhancer = { name = "Type Enhancer", cost = 16},
  mega_bracelet = { name = "Mega Bracelet", cost = 10},
  mega_stone = { name = "Mega Stone", cost = 8},
  z_ring = { name = "Z-Ring", cost = 18},
  dynamax_band = { name = "Dynamax Band", cost = 20},
  tera_orb = { name = "Tera Orb", cost = 18},
  running_shoes = { name = "Running Shoes", cost = 6},
  repel = { name = "Repel", cost = 4}
}

-- Button constants.
BUTTON_LEFT_X = -0.4
BUTTON_RIGHT_X = 0.65
BUTTON_Y = 0.15

function onLoad()
  -- Remove tooltip for the chart.
  self.tooltip = false

  -- Create the purchase buttons.
  create_buttons()
end

function create_buttons()
  self.createButton({ -- Pokeball.
    click_function="purchase_pokeball",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, -1.2}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.poke_ball.name
  })

  self.createButton({ -- Great ball.
    click_function="purchase_great_ball",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, -1.0}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.great_ball.name
  })

  self.createButton({ -- Ultra ball.
    click_function="purchase_ultra_ball",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, -0.8}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.ultra_ball.name
  })

  self.createButton({ -- Apricorn.
    click_function="purchase_apricorn",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, -0.55}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.apricorn.name
  })

  self.createButton({ -- Potion.
    click_function="purchase_potion",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, -0.35}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.potion.name
  })

  self.createButton({ -- Max Potion.
    click_function="purchase_max_potion",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, -0.15}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.max_potion.name
  })

  self.createButton({ -- Revive.
    click_function="purchase_revive",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 0.05}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.revive.name
  })

  self.createButton({ -- Max Revive.
    click_function="purchase_max_revive",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 0.3}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.max_revive.name
  })

  self.createButton({ -- Full Heal.
    click_function="purchase_full_heal",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 0.55}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.full_heal.name
  })

  self.createButton({ -- Escape Rope.
    click_function="purchase_escape_rope",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 0.75}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.escape_rope.name
  })

  self.createButton({ -- Bicycle.
    click_function="purchase_bicycle",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 0.95}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.bicycle.name
  })

  self.createButton({ -- Poke Doll.
    click_function="purchase_poke_doll",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 1.2}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.poke_doll.name
  })

  self.createButton({ -- Berry.
    click_function="purchase_berry",
    function_owner=self,
    position={BUTTON_LEFT_X, BUTTON_Y, 1.4}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.berry.name
  })

  self.createButton({ -- Boost Items.
    click_function="purchase_boost_item",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, -1.2}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.boost_item.name
  })

  self.createButton({ -- Vitamin.
    click_function="purchase_vitamin",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, -1.0}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.vitamin.name
  })

  self.createButton({ -- Legendary Evo.
    click_function="purchase_legendary_evo",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, -0.8}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase Legendary Evo"
  })

  self.createButton({ -- Technical Machine.
    click_function="purchase_tm",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, -0.58}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.tm.name
  })

  self.createButton({ -- Type Enhancer.
    click_function="purchase_type_enhancer",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, -0.35}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.type_enhancer.name
  })

  self.createButton({ -- Mega Bracelet.
    click_function="purchase_mega_bracelet",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, -0.15}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.mega_bracelet.name
  })

  self.createButton({ -- Mega Stone.
    click_function="purchase_mega_stone",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, 0.1}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.mega_stone.name
  })

  self.createButton({ -- Z-Ring.
    click_function="purchase_z_ring",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, 0.3}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.z_ring.name
  })

  self.createButton({ -- Dynamax Band.
    click_function="purchase_dynamax_band",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, 0.53}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.dynamax_band.name
  })

  self.createButton({ -- Tera Orb.
    click_function="purchase_tera_orb",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, 0.75}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.tera_orb.name
  })

  self.createButton({ -- Running Shoes.
    click_function="purchase_running_shoes",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, 0.95}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.running_shoes.name
  })

  self.createButton({ -- Repel.
    click_function="purchase_repel",
    function_owner=self,
    position={BUTTON_RIGHT_X, BUTTON_Y, 1.2}, height=5, width=420, color={1,1,1,0},
    tooltip = "Purchase " .. CARDS.repel.name
  })
end

function purchase_pokeball(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.poke_ball)
end

function purchase_great_ball(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.great_ball)
end

function purchase_ultra_ball(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.ultra_ball)
end

function purchase_apricorn(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.apricorn)
end

function purchase_potion(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.potion)
end

function purchase_max_potion(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.max_potion)
end

function purchase_revive(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.revive)
end

function purchase_max_revive(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.max_revive)
end

function purchase_full_heal(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.full_heal)
end

function purchase_escape_rope(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.escape_rope)
end

function purchase_bicycle(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.bicycle)
end

function purchase_poke_doll(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.poke_doll)
end

function purchase_berry(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.berry)
end

function purchase_boost_item(obj, player_color, alt_click)
  purchase_booster(player_color)
end

function purchase_vitamin(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.vitamin)
end

function purchase_legendary_evo(obj, player_color, alt_click)
  printToAll("Purchasing Legendary Evo cards is not scripted. You gotta do this one yourself. :)", "Red")
end

function purchase_tm(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.tm)
end

function purchase_type_enhancer(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.type_enhancer)
end

function purchase_mega_bracelet(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.mega_bracelet)
end

function purchase_mega_stone(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.mega_stone)
end

function purchase_z_ring(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.z_ring)
end

function purchase_dynamax_band(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.dynamax_band)
end

function purchase_tera_orb(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.tera_orb)
end

function purchase_running_shoes(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.running_shoes)
end

function purchase_repel(obj, player_color, alt_click)
  purchase_item(player_color, CARDS.repel)
end

-- Helper function to purchase an item.
function purchase_item(player_color, item_info)
  -- Get a handle on this player's Pokecoin counter.
  local player_pokecoin_counter = get_player_pokecoin_counter(player_color)
  if player_pokecoin_counter then
    -- Check if the player is rich enough.
    if check_if_player_has_enough(player_color, player_pokecoin_counter, item_info) then
      -- Get the card from the shop deck.
      if get_card_from_shop_deck(player_color, item_info.name) then
        -- Log the purchase.
        printToAll(get_player_name(player_color) .. " purchased a " .. item_info.name .. " for " .. item_info.cost .. " Pokécoins.")
        -- Retrieved card successfully, deduct the count from the player.
        player_pokecoin_counter.call("adjustValue", -item_info.cost)
      else
        printToAll("Failed to find " .. item_info.name .. " in Shop Deck. Try searching through the discard pile and deduct the cost yourself.", "Red")
      end
    end
  end
end

-- Helper function to get a player's Steam name.
function get_player_name(player_color)
  local player_name = player_color
  if Player[player_color].steam_name then
      player_name = Player[player_color].steam_name
  end
  return player_name
end

-- Helper function to get a handle on a player's Pokecoin counter.
function get_player_pokecoin_counter(player_color)
  local player_coin_counter_guid = PLAYER_COIN_GUIDS[player_color]
  if not player_coin_counter_guid then return nil end
  return getObjectFromGUID(player_coin_counter_guid)
end

-- Helper function to check if a player has an certain amount of couns.
function check_if_player_has_enough(player_color, counter_obj, item_info)
  local player_coin_count = counter_obj.call("getValue")
  if player_coin_count < item_info.cost then
    printToAll(get_player_name(player_color) .. " does not have enough Pokécoins to purchase a " .. item_info.name .. " (" .. item_info.cost .. ").", "Red")
    return false
  end

  return true
end

-- Helper function to take a specific card from the Shop Items deck and put it in the player's hand.
function get_card_from_shop_deck(player_color, card_name)
  -- Get a handle on the deck.
  local shop_deck = getObjectFromGUID(SHOP_DECK_GUID)
  if shop_deck then
    -- Enumerate the deck and search for one we care about.
    for _, card in ipairs(shop_deck.getObjects()) do
      if card.name == card_name then
        -- Move the card to the top.
        local new_card = shop_deck.takeObject({index = card.index})

        -- Deal the top card to the player.
        new_card.deal(1, player_color)
        return true
      end
    end
  end

  -- Failed.
  return false
end

-- Helper function to take a specific card from the Booster Items deck.
function purchase_booster(player_color)
  -- Get a handle on this player's Pokecoin counter.
  local player_pokecoin_counter = get_player_pokecoin_counter(player_color)
  if player_pokecoin_counter then
    -- Check if the player is rich enough.
    if check_if_player_has_enough(player_color, player_pokecoin_counter, CARDS.boost_item) then
      -- Get the card from the shop deck.
      if get_card_from_booster_deck(player_color) then
        -- Log the purchase.
        printToAll(get_player_name(player_color) .. " purchased a " .. CARDS.boost_item.name .. " for " .. CARDS.boost_item.cost .. " Pokécoins.")
        -- Retrieved card successfully, deduct the count from the player.
        player_pokecoin_counter.call("adjustValue", -CARDS.boost_item.cost)
      else
        printToAll("Failed to find any cards in Booster Deck. Try searching through the discard pile and deduct the cost yourself.", "Red")
      end
    end
  end
end

-- Helper function to deal the top card from the booster deck.
function get_card_from_booster_deck(player_color)
  -- Get a handle on the deck.
  local booster_deck = getObjectFromGUID(BOOSER_DECK_GUID)
  if booster_deck then
    -- Deal the top card to the player.
    booster_deck.deal(1, player_color)
    return true
  end

  return false
end