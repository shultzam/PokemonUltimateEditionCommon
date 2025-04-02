-- The DeckBuilder object should live at {13.50, 1.40, 31.50}.
-- https://api.tabletopsimulator.com/base/#spawnobject
-- https://api.tabletopsimulator.com/object/#setcustomobject
-- https://api.tabletopsimulator.com/custom-game-objects/#custom-card

function onLoad()
  -- Make this object not interactable.
  self.interactable = false
  self.setLock(true)
  self.setPosition({13.5, 1.5, 31.5})
  self.setRotation({0, 180, 0})
end

-- The scale to use for all cards.
CARD_SCALE = {2.12, 1.00, 2.11}

-- A table of card backs.
CARD_BACK_URLS = {
  default = "https://steamusercontent-a.akamaihd.net/ugc/41201955293156728/A6F430EEBBDBC1B5FEF77B0D0134D6A7C5FFA6BA/",
  event = "https://steamusercontent-a.akamaihd.net/ugc/41201955293156641/5D47086C919A98CB7785AEB1DD56C1B2504BAC61/",
  pokeballs = "https://steamusercontent-a.akamaihd.net/ugc/41201327654156520/872ED53E811F0EC9E667DC4C30B7232C1C419F77/",
  tera_type = "https://steamusercontent-a.akamaihd.net/ugc/41201327654156477/6095A2918358D17AA36770E6FAF9AE3EDAB06BB0/",
  tm = "https://steamusercontent-a.akamaihd.net/ugc/2492256070866424138/1FE6941F3DE7B046E07CC3BDA3931F4EF4BEA3B7/",
  type_enhancer = "https://steamusercontent-a.akamaihd.net/ugc/41201327654156506/EBB6392674DF472811A6BCD448BF5D2FE4BDA3FF/",
  z_crystal = "https://steamusercontent-a.akamaihd.net/ugc/41201327654156459/B24C29B1871DEF728A62C42586DE7BAF4BA6F511/"
}

-- A table containing card info for deck building.
CARD_INFO = {
  -- Item Cards.
  amulet_count = { name="Amulet Coin", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150134/E3FE0FC78B0003737AFD3AF35CAEB19B57384F37/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  apricorn = { name="Apricorn", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706515617775/CAD1BC74C508F15508E02C763C401BB88B9154F1/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  berry = { name="Berry", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150233/769B0826468514AB3163C61E081E48B6965AFAE7/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  bicycle = { name="Bicycle", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150290/011FEC43E088692F4CECBFE1C1BC0FC1942184F1/", back=CARD_BACK_URLS.default },
  black_flute = { name="Black Flute", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150342/E1D5AC2F92BC14C3CFE1990D3D1338B0A7D24943/", back=CARD_BACK_URLS.default },
  dynamax_band = { name="Dynamax Band", front="https://steamusercontent-a.akamaihd.net/ugc/2471992409973827418/E4DA3C267A33C69AB7D46918EBDA435D34591EE4/", back=CARD_BACK_URLS.default },
  escape_rope = { name="Escape Rope", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150465/D3DF81CB2D62AD8862FAEA6B397BFDE11F607EF7/", back=CARD_BACK_URLS.default },
  eviolite = { name="Eviolite", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150522/F03C3D08FD3CE8D2C83E1AB861AAC39838509066/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  xp_share = { name="XP Share", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150585/8E21EBC3006B47575A51C48CF7D9B9C1CB83CF4F/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  full_heal = { name="Full Heal", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150705/38322A4B99B23ABAA4493C0B4E6C8B671826C44C/", back=CARD_BACK_URLS.default },
  item_finder = { name="Item Finder", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150840/3309269717B61AA20E97849F42E64911EB964345/", back=CARD_BACK_URLS.default },
  kings_rock = { name="King's Rock", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150917/17E3550ECCDE75AA5F2B30CA6AECEA9E846F7999/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  leftovers = { name="Leftovers", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150962/0B2903C823941F37AEED5270C79C48A72970A943/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  lucky_egg = { name="Lucky Egg", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150995/B10052B11C3B8E372C519E1BED5B6ADF0DF1892D/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  max_potion = { name="Max Potion", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151043/5D1B27146BEB6335D6140A01EBF58497168F35C2/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  max_revive = { name="Max Revive", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151114/338D5726B6F1EB7A3E184B6D16AF1DEE8C22190E/", back=CARD_BACK_URLS.default },
  mega_bracelet = { name="Mega Bracelet", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561344203/9F154534E97E702C4F1E687B6ED23E75E107E912/", back=CARD_BACK_URLS.default },
  mega_stone = { name="Mega Stone", front="https://steamusercontent-a.akamaihd.net/ugc/2471992409973825886/A6AE517ADCD5F764BBCD260187D763D51AFBF04D/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  poke_doll = { name="Poké Doll", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151180/FDA9042B364268FF80E7D61EBB8420E217AEA49B/", back=CARD_BACK_URLS.default },
  potion = { name="Potion", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151265/146C45F039C6BAAD8679A352EC1BDD1F38707A80/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  quick_claw = { name="Quick Claw", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151342/2DBFA81EBF5912840C40EDFE136D80749E3B374F/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  rare_candy = { name="Rare Candy", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151458/764170166A691049E10555349155C1F01CE11BD6/", back=CARD_BACK_URLS.default },
  razor_claw = { name="Razor Claw", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151546/730F4D3D24F56C4017440C9AD869E2BAE9E43C81/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  repel = { name="Repel", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151783/47DD9873DCD0319317F547D0CB67309124508BA3/", back=CARD_BACK_URLS.default },
  revive = { name="Revive", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293151970/75665598F9D26CB6729DB215A0E62365DF1720ED/", back=CARD_BACK_URLS.default },
  running_shoes = { name="Running Shoes", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152084/ABD1FF9C055ED560FCE38FCF63E8C873446F6289/", back=CARD_BACK_URLS.default },
  shiny_charm = { name="Shiny Charm", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152143/CB96207FB130320788DB971D229CAC4C8940B425/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  technical_machine = { name="Technical Machine", front="https://steamusercontent-a.akamaihd.net/ugc/2455116747421290612/EA9E44F3969D65D9620BCE5662A2600AA5AC1FE3/", back=CARD_BACK_URLS.default },
  tera_orb = { name="Tera Orb", front="https://steamusercontent-a.akamaihd.net/ugc/2470865328664418629/2A99AB333FADB9DE1BFF9BA887CE402C74D8DC1F/", back=CARD_BACK_URLS.default },
  treasure = { name="Treasure", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152301/7BC580A33FCF3D63AFBE569DD471B45BD2AA0394/", back=CARD_BACK_URLS.default },
  type_enhancer = { name="Type Enhancer", front="https://steamusercontent-a.akamaihd.net/ugc/2455116747421234131/64AEE19D01D795A9BB0E4BE4F2743DDA09C490CF/", back=CARD_BACK_URLS.default },
  vitamin = { name="Vitamin", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152384/01453266CBE75DEDEF4757A7714790687F44EA6E/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  weather_rock = { name="Weather Rock", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152469/A00C7024F300B7558A9BA28BFAA26C0E231AD325/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  wide_lens = { name="Wide Lens", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152604/38988185D46C09D8C3E940D464434D8D1CEDEAAC/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  zoom_lens = { name="Zoom Lens", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293153033/D1E3D6F817024E5025BD947F276ADBF87FA3A6BA/", back=CARD_BACK_URLS.default, tags = {"Item"} },
  z_ring = { name="Z Ring", front="https://steamusercontent-a.akamaihd.net/ugc/2470865328664542801/A6DAF88FFCA79D49E848B5D1D6E4D13293387E45/", back=CARD_BACK_URLS.default },

  -- Pokeballs.
  dream_ball = { name="Dream Ball", front="https://steamusercontent-a.akamaihd.net/ugc/2371796196896414129/B648D7A81371B374E917C6DA77AC31945463FAA8/", back=CARD_BACK_URLS.default },
  great_ball = { name="Great Ball", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561343517/FA69CFFB06BA3733B674E9FDABFCA85BBF82E41D/", back=CARD_BACK_URLS.default },
  poke_ball = { name="Poké Ball", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561343621/C547916F20658BCB4151AF21B37F0FD646560BD9/", back=CARD_BACK_URLS.default },
  safari_ball = { name="Safari Ball", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706515633917/7876987BE70B7B7E8FC53982C0CDF7F61BFFF828/", back=CARD_BACK_URLS.default },
  ultra_ball = { name="Ultra Ball", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561343437/7DBD02BE4ED72BA5B29EC3E5A1587627AF645E0A/", back=CARD_BACK_URLS.default },

  -- Battle Cards.
  dire_hit = { name="Dire Hit", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150413/87A36F05D05D69F5800F3EF7D11E2C15052AFBFF/", back=CARD_BACK_URLS.default },
  guard_spec = { name="Guard Spec", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293150777/9B89FAF6B2A1DE45FF13E62646CCD420D5AE9FD6/", back=CARD_BACK_URLS.default },
  x_accuracy = { name="X Accuracy", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152743/86AC1D50764455E776CEDF75CB5750D8B87DF0EF/", back=CARD_BACK_URLS.default },
  x_attack = { name="X Attack", front="https://steamusercontent-a.akamaihd.net/ugc/41201955293152795/C1CAE2C101DD2085BCA0AD1E57566FF743DFE310/", back=CARD_BACK_URLS.default },
  x_defense = { name="X Defense", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706515695154/9C9F742F738488A08A96EE628581951EAB3FA6B8/", back=CARD_BACK_URLS.default },
}

-- Custom Cards.
CUSTOM_CARD_INFO = {}

-- Standard Deck used across all maps.
STANDARD_ITEM_DECK = {
  -- Attach cards.
  { card=CARD_INFO.zoom_lens, count=2 },
  { card=CARD_INFO.razor_claw, count=2 },
  { card=CARD_INFO.eviolite, count=2 },
  { card=CARD_INFO.shiny_charm, count=3 },
  { card=CARD_INFO.amulet_count, count=3 },
  { card=CARD_INFO.wide_lens, count=3 },
  { card=CARD_INFO.kings_rock, count=3 },
  { card=CARD_INFO.vitamin, count=2 },
  { card=CARD_INFO.quick_claw, count=2 },
  { card=CARD_INFO.leftovers, count=2 },
  { card=CARD_INFO.xp_share, count=2 },
  { card=CARD_INFO.berry, count=5 },
  { card=CARD_INFO.lucky_egg, count=2 },
  { card=CARD_INFO.weather_rock, count=4 },

  -- Battle boosters.
  { card=CARD_INFO.x_attack, count=3 },
  { card=CARD_INFO.x_defense, count=3 },
  { card=CARD_INFO.x_accuracy, count=3 },
  { card=CARD_INFO.dire_hit, count=3 },
  { card=CARD_INFO.guard_spec, count=3 },
  { card=CARD_INFO.guard_spec, count=3 },

  -- Card Draw.
  { card=CARD_INFO.apricorn, count=3 },
  { card=CARD_INFO.technical_machine, count=4 },
  { card=CARD_INFO.type_enhancer, count=3 },
  { card=CARD_INFO.tera_orb, count=3 },
  { card=CARD_INFO.z_ring, count=3 },

  -- Pokeballs.
  { card=CARD_INFO.poke_ball, count=4 },
  { card=CARD_INFO.great_ball, count=3 },
  { card=CARD_INFO.ultra_ball, count=2 },

  -- Action.
  { card=CARD_INFO.full_heal, count=2 },
  { card=CARD_INFO.treasure, count=3 },
  { card=CARD_INFO.repel, count=4 },
  { card=CARD_INFO.black_flute, count=3 },
  { card=CARD_INFO.running_shoes, count=4 },
  { card=CARD_INFO.max_revive, count=3 },
  { card=CARD_INFO.revive, count=4 },
  { card=CARD_INFO.max_potion, count=3 },
  { card=CARD_INFO.potion, count=3 },
  { card=CARD_INFO.rare_candy, count=2 },
  { card=CARD_INFO.bicycle, count=2 },
  { card=CARD_INFO.item_finder, count=3 },
  { card=CARD_INFO.escape_rope, count=4 },
  { card=CARD_INFO.poke_doll, count=3 },
}

-- Add-ons specific to each map for the standard deck.
ITEM_DECK_MAP_ADD_ONS = {
  Kanto = {
    { card=CARD_INFO.safari_ball, count=4 }
  },
  Johto = {
    { card=CARD_INFO.safari_ball, count=4 }
  },
  Hoenn = {},
  Sinnoh = {
    { card=CARD_INFO.safari_ball, count=4 }
  },
  Unova = {
    { card=CARD_INFO.dream_ball, count=4 }
  },
  Kalos = {},
  Alola = {},
  Galar = {},
  Paldea = {},
  ["Orange Islands"] = {}
}

-- Custom items.
-- Format: { card_info, count }
CUSTOM_ITEM_CARDS = {}

EVEN_CARD_INFO = {
  alpha_pokemon = { name="Alpha Pokémon", front="https://steamusercontent-a.akamaihd.net/ugc/2447224599432732219/87C6BCD6605729CC9A34A02BA5AA40BAB6BB902F/", back=CARD_BACK_URLS.event, tags = {"Item"} },
  game_corner = { name="Game", front="https://steamusercontent-a.akamaihd.net/ugc/2449485971643558322/E8BCF8279721F2C5F05C28A0485588CF7F1E8327/", back=CARD_BACK_URLS.event },
  chance_card = { name="Chance Card", front="https://steamusercontent-a.akamaihd.net/ugc/2451736358374337674/2B29B317557B4B3E8C631DCBAE120E93C6E6B2DC/", back=CARD_BACK_URLS.event },
  wonder_trade = { name="Wonder Trade", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561343348/7C2F518F86FE8280C2FCAFB4D063416406EA1FA7/", back=CARD_BACK_URLS.event },
  pick_up_item_1 = { name="Pick Up Item (1)", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561343293/89DBBDD7B11E4F433C15134C382E0087960908AE/", back=CARD_BACK_URLS.event },
  pick_up_item_2 = { name="Pick Up Item (2)", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561343214/93654150B8AECFA9C1D28495ED796B4F239E5370/", back=CARD_BACK_URLS.event },
  pokemon_egg = { name="Pokémon Egg", front="https://steamusercontent-a.akamaihd.net/ugc/2468621052561342109/5E6B22361DCB29DF36DE1B498EDC36B6FC8CBAB9/", back=CARD_BACK_URLS.event },
  rival_battle = { name="Rival Battle", front="https://steamusercontent-a.akamaihd.net/ugc/2447224599432732045/F4FFD4EA51EBB324E8181FFF5B71C0545771B5AF/", back=CARD_BACK_URLS.event },
  blimp_ride = { name="Blimp Ride", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706488322163/7054FA496E9377273776F28F809FB747DBAD5D24/", back=CARD_BACK_URLS.event },
  poke_mart = { name="Poké Mart", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706488318525/628C180B474C9B475A58E8EA0EA4F38F97F7A60A/", back=CARD_BACK_URLS.event },
  pokemon_center = { name="Pokémon Center", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706488316188/1C7A7A9986BEF843C92DD65120AEDE3902793A8C/", back=CARD_BACK_URLS.event },
  team_rocket = { name="Team Rocket", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706488307427/B8740BE0ED8AAF3DDF7DC5325931360A7F02C198/", back=CARD_BACK_URLS.event },
  fossil_discovery = { name="Fossil Discovery", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706488295278/0033A24FD1F6D092BC93A0ED755B637AF9C71D2D/", back=CARD_BACK_URLS.event },
  day_care = { name="Day Care", front="https://steamusercontent-a.akamaihd.net/ugc/2492256706488293904/6D765228B74227AC6C119E0DBF19D06951427315/", back=CARD_BACK_URLS.event },
  trainer_battle_1 = { name="Trainer Battle (1)", front="https://steamusercontent-a.akamaihd.net/ugc/41202108852833766/B3305AABAB1A97A0A93A733A8DC4321759A204FD/", back=CARD_BACK_URLS.event },
  trainer_battle_2 = { name="Trainer Battle (2)", front="https://steamusercontent-a.akamaihd.net/ugc/41202108852833832/B895DB599BEE6C3DC62CE1587D8BC37896F06EB8/", back=CARD_BACK_URLS.event },
  roaming_legend = { name="Roaming Legend", front="https://steamusercontent-a.akamaihd.net/ugc/2059880067052353378/4C4D1BD812FE96DF29D97355B0B7431B5C4A171C/", back=CARD_BACK_URLS.event },
  lets_fight = { name="Let's Fight!", front="https://steamusercontent-a.akamaihd.net/ugc/41202108852841486/E9EFD75F57FB468D8E0D971C7AFF00DB08B7541D/", back=CARD_BACK_URLS.event },

  -- Map Specific.
  explore_underground = { name="Explore Undergroud", front="https://steamusercontent-a.akamaihd.net/ugc/2451736358374337752/5AB8B70043B76B902AAAEAF690AEC8B22C2A2962/", back=CARD_BACK_URLS.event },
  max_raid_battle = { name="Max Raid Battle", front="https://steamusercontent-a.akamaihd.net/ugc/2455117542099024824/AB04C4C941F51BF833F68E95E75FBDB793250715/", back=CARD_BACK_URLS.event },
  area_zero = { name="Area Zero", front="https://steamusercontent-a.akamaihd.net/ugc/2455117542099024748/FEE328BC384BABD2787F0358A6DF51B1A11A3486/", back=CARD_BACK_URLS.event }
}

-- Event deck used across all maps.
STANDARD_EVENT_DECK = {
  { card=EVEN_CARD_INFO.alpha_pokemon, count=3 },
  { card=EVEN_CARD_INFO.game_corner, count=3 },
  { card=EVEN_CARD_INFO.chance_card, count=5 },
  { card=EVEN_CARD_INFO.wonder_trade, count=5 },
  { card=EVEN_CARD_INFO.pick_up_item_1, count=8 },
  { card=EVEN_CARD_INFO.pick_up_item_2, count=8 },
  { card=EVEN_CARD_INFO.pokemon_egg, count=4 },
  { card=EVEN_CARD_INFO.rival_battle, count=5 },
  { card=EVEN_CARD_INFO.blimp_ride, count=4 },
  { card=EVEN_CARD_INFO.poke_mart, count=6 },
  { card=EVEN_CARD_INFO.pokemon_center, count=4 },
  { card=EVEN_CARD_INFO.team_rocket, count=4 },
  { card=EVEN_CARD_INFO.fossil_discovery, count=2 },
  { card=EVEN_CARD_INFO.day_care, count=3 },
  { card=EVEN_CARD_INFO.trainer_battle_1, count=6 },
  { card=EVEN_CARD_INFO.trainer_battle_2, count=6 },
  { card=EVEN_CARD_INFO.roaming_legend, count=4 },
  { card=EVEN_CARD_INFO.lets_fight, count=6 },
}

-- Add-ons specific to each map for the event deck.
EVENT_MAP_ADD_ONS = {
  Kanto = {},
  Johto = {},
  Hoenn = {},
  Sinnoh = {
    { card=EVEN_CARD_INFO.explore_underground, count=4 }
  },
  Unova = {},
  Kalos = {},
  Alola = {},
  Galar = {
    { card=EVEN_CARD_INFO.max_raid_battle, count=4 }
  },
  Paldea = {
    { card=EVEN_CARD_INFO.area_zero, count=4}
  },
  ["Orange Islands"] = {}
}

-- Custom Event cards.
-- Format: { card_info, count }
CUSTOM_EVENT_CARDS = {}

-- Booster deck used across all maps.
STANDARD_BOOSTER_DECK = {
  { card=CARD_INFO.x_attack, count=6 },
  { card=CARD_INFO.x_defense, count=6 },
  { card=CARD_INFO.x_accuracy, count=6 },
  { card=CARD_INFO.dire_hit, count=6 },
  { card=CARD_INFO.guard_spec, count=6 },
  { card=CARD_INFO.guard_spec, count=6 },
}

-- Pokeballs deck used across all maps.
POKEBALLS_DECK = {}

-- Tera Type deck used across all maps.
TERA_TYPE_DECK = {}

-- Technical Machine deck used across all maps.
TM_DECK = {}

-- Type Enhancer deck used across all maps.
TYPE_ENHANCER_DECK = {}

-- Z-Crystals deck used across all maps.
Z_CRYSTALS_DECK = {}

--------------------------------------------
-- Functions
--------------------------------------------

-- Helper function used to create a custom card.
function create_card(params, card_data)
  -- Spawn a base card. The offset helps the deck get auto-shuffled.
  local offset = math.random(10, 26) * 0.1
  local card = spawnObject(
    {
      type = "CardCustom",
      position = {params.position[1], params.position[2] + offset, params.position[3]},
      rotation = params.rotation,
      scale = CARD_SCALE,
      sound = false
    }
  )

  -- Give the base card its custom parameters.
  card.setCustomObject(
    {
      type = 0,   -- Rounded Rectangle
      face = card_data.front,
      back = card_data.back,
      sideways = false
    }
  )

  -- Name the item card.
  card.setName(card_data.name)

  -- Assign the tags, if applicable.
  if card_data.tags ~= nil then
    for tag_index=1, #card_data.tags do
      card.addTag(card_data.tags[tag_index])
    end
  end
end

-- Helper function to build a standard item card deck.
-- Arguments:
--  map
--  type (Item, Event, Booster, Shop, ...)
--  position
--  rotation
function build_card_deck(params)
  -- Determine which deck we are building.
  local deck = {}
  local add_ons = {}
  local custom_cards = {}
  if params.type == "Item" then
    deck = STANDARD_ITEM_DECK
    add_ons = ITEM_DECK_MAP_ADD_ONS
    custom_cards = CUSTOM_ITEM_CARDS
  elseif params.type == "Event" then
    deck = STANDARD_EVENT_DECK
    add_ons = EVENT_MAP_ADD_ONS
    custom_cards = CUSTOM_EVENT_CARDS
  elseif params.type == "Booster" then
    deck = STANDARD_BOOSTER_DECK
  else
    print("Unrecognized deck type: " .. tostring(params.type))
    return
  end

  -- Loop through the Item Card deck params.
  for index = 1, #deck do
    local card_data = deck[index].card

    -- We need to spawn a set count of this card.
    for card_index=1, deck[index].count do
      create_card(params, card_data)
    end
  end

  -- Determine if any map-specific item cards need to be spawned.
  local map_item_cards = add_ons[params.map] or {}
  -- Loop through the Item Card map add ons.
  for index = 1, #map_item_cards do
    local map_card_data = map_item_cards[index].card

    -- We need to spawn a set count of this card.
    for card_index=1, map_item_cards[index].count do
      create_card(params, map_card_data)
    end
  end

  -- Determine if any custom item cards need to be spawned.
  for index=1, #custom_cards do
    local custom_card_data = custom_cards[index].card
    print("TEMP | custom_card_data: " .. dump_table(custom_card_data))

    -- We need to spawn a set count of this card.
    for card_index=1, custom_card_data[index].count do
      create_card(params, custom_card_data)
    end
  end
end

-- Helper function to get the standard item card config.
function get_item_card_config()
  return STANDARD_ITEM_DECK
end

-- Helper function to get the standard event card config.
function get_event_card_config()
  return STANDARD_EVENT_DECK
end

-- Helper function to get the standard booster card config.
function get_booster_card_config()
  return BOOSTER_DECK
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