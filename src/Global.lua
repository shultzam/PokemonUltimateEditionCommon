--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]

currentTrack = 1

local deploy_pokeballs = { "9c4411", "c988ea", "2cf16d", "986cb5", "f66036", "e46f90" }
local customPokeballs = { "a927cf", "acd90d", "63bb92", "88b157", "8aaeef", "915bb4", "47780a" }

-- Pokeball Colours
PINK = 1
GREEN = 2
BLUE = 3
YELLOW = 4
RED = 5
LEGENDARY = 6
MEGA = 7
FOSSIL = 8

-- Status Effects
BURN = 0
FREEZE = 1
PARALYSIS = 2
POISON = 3
SLEEP = 4
CONFUSE = 5

-- Gym Leader gen selects from the dropdown.
GEN_1_SELECT = "Gen I"
GEN_2_SELECT = "Gen II"
GEN_3_SELECT = "Gen III"
GEN_4_SELECT = "Gen IV"
GEN_5_SELECT = "Gen V"
GEN_6_SELECT = "Gen VI"
GEN_7_SELECT = "Gen VII"
GEN_8_SELECT = "Gen VIII"
GEN_9_SELECT = "Gen IX"
RANDOM_SELECT = "Random"
CHAOS_SELECT = "Chaos"

-- Custom Gym Leader Options.
local NONE_SELECT = 0
local ALLOW_SELECT = 1
local ALWAYS_SELECT = 2

-- Event Rival region selection.
KANTO_REGION = "Kanto"
JOHTO_REGION = "Johto"
HOENN_REGION = "Hoenn"
SINNOH_REGION = "Sinnoh"
UNOVA_REGION = "Unova"
KALOS_REGION = "Kalos"
ALOLA_REGION = "Alola"
GALAR_REGION = "Galar"
PALDEA_REGION = "Paldea"

-- Setup Variables
leadersGen = 1 -- NOTE: 0 = Custom
hasEnoughPokemon = true
customAndTooFewLeaders = false
randomStarters = false
battleScripting = false
aiDifficulty = 0

-- Save Data
customGen = false
eventRivalRegion = KANTO_REGION
customGymLeaderOption = NONE_SELECT

--[[ 
  NOTE: Lua cannot handle sparse arrays and, apparently, false terms can create sparse array
        behavior (see https://stackoverflow.com/a/17974661). An online interpreter suggests
        true/false is immune but something funky is going on here where *sometimes* only 
        gens 1-4 are considered enabled. ]]
selectedGens = {true,true,true,true,true,true,true,true,true}

-- Model tables and variables.
battlemodels_GUID = 'bebe24'
active_chips = {}
active_models = {}
models_enabled = true
global_scale = 2
spawn_delay = 0
spawn_scale = 100

-- Funky music variables. Most remix tracks were created by GlitchxCity.
original_music_enabled = true
remix_music_enabled = false

-- The current route playlist.
local route_playlist = {}

local original_route_tracks =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898689460/46D48965B1EEDADAB14C15184FCDB41C9998C83D/", title = "Route Music 1" },
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898697980/2D46041C40896534AC54D157FC6C3CAC1F00A7E9/", title = "Route Music 2" },
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898696675/0CC89B7B48CAF248149CF2DE43DADBC1FDD260E2/", title = "Route Music 3" },
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898694456/A95CDF7833368368BFB8EDCDB6E77E19785F3B7F/", title = "Route Music 4" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713830665/51AFCA6A1D2F74287F7065D153AE4893CFE65EE4/", title = "Route 10" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713833558/A53A7FA0DDCE1D5B076B323E61F603370D958414/", title = "Route 209" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713839101/D00A83FF04F6E8E7EC93A284D1264B3A88618721/", title = "Route 201" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713842461/880B9A4E1D19545259DC3B3A27EE29D8EADB0047/", title = "Route 101" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713845152/8C7AF47689CE1827BF64C68D710A231B4A943F33/", title = "Route 216" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2468621052563305438/9B9E73DCD8DF26F6B187C8F338E4D1286222AC61/", title = "Route 203" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2468621052563478724/47F188A77141A2ECF0A6B93682CC2619ABAA1551/", title = "Eterna Forest" }
}

local remix_route_tracks =
{
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028803851/B22ED35F5A56BEA363EC533F15644DD7E0374638/", title = "Victory Road (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028803230/A4A5840B1A37900C68C985CA1521B4CED2366044/", title = "Route 113 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2468621052563295753/F290CFB65047AA9D078CA6A20879C7CDB03FB781/", title = "Eterna Forest (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2468621052563298173/F7FEAAE3F5A0F2FCF535CE4CDF4AB12C2F7EBA11/", title = "Blueberry Academy (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028802590/99A2EF8299E6FE2DE426B61942EB407780A33FF6/", title = "Route 111 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028802137/77BDABC8614017705FAD5AAEF5C96D15E561AA8B/", title = "Route 12 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028801573/7FE76872DEDF6387994FE1ED00507AE6F1DF9FA5/", title = "Route 47 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028801082/87616A87332EEA03D724CC620EB9E8248C6B0E62/", title = "Route 209 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028800688/408BCF30B46E9BF7F98B45095DB123401484A2AD/", title = "Route 201 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028800156/2F35C1E183D28E7CE2E177B6BFD34B01667403F8/", title = "Route 10 (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028799577/FE8FC0E512097D4E2FC1F99E4D186219D7C08AD2/", title = "Route 19 (Remix)" }
}

local team_rocket_playlist = {}

local original_team_rocket_tracks =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/2465233915448769574/09A09106156072F227DB6D44211395F1545DFB9C/", title = "Team Rocket Battle Music" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351494466/E735E7793EFD0FB37790D2B6E394FAB5DBBE9419/", title = "Rocket Powered Disaster 20" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351495962/FCA4C8DFB2639C2F56347C3B5968881ACF22066B/", title = "Rocket Powered Disaster" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2468621052563292855/5D79017D7825BF0B9B8F30E581FF42096EDFA1DB/", title = "Victory Road (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2468621052563309229/7B364DC85C8BFD0F9F29AAFCD79D463ED1E7E9CF/", title = "Team Flare" }
}

local remix_team_rocket_tracks =
{

}

local battle_playlist = {}

local original_battle_tracks =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/1023949407635181294/DF75C7F7429A20B290E9C39CA1A391F5217CB3BB/", title = "Gym Battle Music 1" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351469017/83C3A3A8906183F09ED5F3FBED856E3DE94BF847/", title = "A Formidable Opponent Appears"},
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351472196/9F8A243CFFDF2783A35AF2B8E34CDDAF90BCE76C/", title = "Gym Battle Music - Track 14"},
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351474956/24853183DAFC85171508106801F146DAFF5FD9A7/", title = "Gym Battle Music - Scramble" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351479148/191BEBD2158D686534CD2CFC3D75B10E88FB2994/", title = "Gym Battle Music - Absolute Death" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351481972/9CFAC33E67467F93004DEAA08084922D5BBEEE7A/", title = "Gym Battle Music - Kanto" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351490133/C15770511BBAEE88551E1C332FCD8A26A4F543EB/", title = "Gym Battle Music - Johto" }
}

local remix_battle_tracks =
{
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028870838/2ED898438B7BB0C8A5A4D2FE28AEC3AE7C97FAD2/", title = "Marnie Battle (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028870236/21D89ADDAEBBAD59826034DB8DF6E9B591EE9ED4/", title = "Gym Leader Battle (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028869777/4E36D699DE8AC0A123C587F5F335F48B03E351C7/", title = "Chariman Rose Battle (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028869358/A1810B013A118E3D91C22E5C3351D45E57839C69/", title = "Wild Battle (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028868963/B8C4D01C5DDAA157C84D98A5F3F956D8BA629CF7/", title = "Crescent Battle (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028868419/62544351CC026B12CE6502471C4BA741FD16B04A/", title = "Lake Trio Battle (Remix)" }
}

local rival_playlist = {}

local original_rival_tracks =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/2465233915448687664/638298CFD4041533322CB8E537B98923EAA776EE/", title = "Cynthia Battle Music" }
}

local remix_rival_tracks =
{
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028911521/6139DD8F3476B4A76B6B12147527CAE049ECE117/", title = "Hop Battle (Remix)" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802345028911129/145437929E36475541505FDDE1EB0C3A99F6AF16/", title = "Hoenn Rival Battle (Remix)" },
}

local elite_4_playlist = {}

local original_elite_4_tracks =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898724461/766C5BF1EB28C474D2366F8223F98C5F083770D0/", title = "Elite 4 Battle Music" },
  { url = "https://steamusercontent-a.akamaihd.net/ugc/2380802651775268813/AA1A5E098A632268F8CAB404F79C913868FF6A72/", title = "XY Elite 4 Battle Music" }
}

local remix_elite_4_tracks =
{
  
}

-- Supported camera locations.
local ARENA = 0
local FIGURE = 1
local RACK = 2

-- Scripted House Rules.
local HR_hard_gym_leaders = false
local HR_dual_type_effectiveness = false
local HR_hp_rule_2 = false

-- Dual Type Effectiveness related GUIDs.
local TYPES_BAG_GUID = "98d9a7"
local TYPE_TOKEN_GUID_TABLE =
{
  { type = "Bug",      guid = "36b0e6" },
  { type = "Dark",     guid = "7160fc" },
  { type = "Dragon",   guid = "01d861" },
  { type = "Electric", guid = "7b723b" },
  { type = "Fairy",    guid = "03c837" },
  { type = "Fighting", guid = "877980" },
  { type = "Fire",     guid = "b71dbd" },
  { type = "Flying",   guid = "f0b824" },
  { type = "Ghost",    guid = "38a3f5" },
  { type = "Grass",    guid = "2f59c9" },
  { type = "Ground",   guid = "dc8567" },
  { type = "Ice",      guid = "28d8ab" },
  { type = "Normal",   guid = "a46212" },
  { type = "Poison",   guid = "21a2e7" },
  { type = "Psychic",  guid = "ef39a7" },
  { type = "Rock",     guid = "956166" },
  { type = "Steel",    guid = "bd8dd9" },
  { type = "Water",    guid = "3f3089" },
}

local active_secondary_type_tokens = {}

-- Base Health Tracker object.
-- TODO: object.setColorTint()
local BASE_HEALTH_OBJECT_GUID = "5ab909"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom data fields
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Custom Gym Data
--
-- You no longer need to create a complete suite of Gym Leaders to have your custom Gym Leaders used!
-- Just create what you want and the available Gym Leaders, Rivals, etc. will be used to fill in the
-- rest.
--
-- In order for this data to be utilizied, you must choose the appropriate Custom Gym Leader option 
-- during setup. Here are the options:
--  * None       - Default. Your custom gym leaders will not be considered when choosing Gym Leaders,
--                 even if Random Gym Leaders are chosen.
--  * Allow      - Custom Gym Leaders will be considered when the game is choosing Gym Leaders. This
--                 means that if you chose Gen II Gym Leaders, your Gym Leader has a 1/X chance of 
--                 being chosen when the game selects Gym Leaders.
--  * Always Use - Custom Gym Leaders will be considered first. If there is one custom available for
--                 a aprticular tier (Gym II, Rival, Team Rocket, etc.) it will always be chosen. If
--                 You made multiple for a particular tier, as many will be chosen as needed before
--                 using default Gym Leaders for the chosen Gen of Gym Leaders. For example, if you
--                 made 2 Rivals then both would be chosen at Setup and then the third Rival would
--                 be chosen based on the selcted Gen of Gym Leaders (Gen Whatever or Random).
--
-- RECOMMENDATION: To properly edit this field do the following:
--   1- This only works at setup. So first, save your game.
--   2- In the TTS script editor: Copy the entirety of this script and paste it into a text editor
--       of your choice (Npp or VS Code offer syntax highlighting which helps prevent silly mistakes)
--   3- In the text editor: make your changes as needed
--   OPTIONAL: Save off your customGymData field into a text file on your Desktop so you don't have 
--             to recreate it in the future
--   4- In the text editor: CTRL+A -> CTRL+C to copy the entirety of this script with your changes
--   5- In the TTS script editor: CTRL+A -> CTRL+V to overwrite the entirety of the old script with
--       your new version
--   6- In the TTS script editor: at the top-left of the window, click Save & Play.
--   7- Now, move your Gym Leader to their appropriate Pokeball (Custom Gym Leaders, Custom Elite 4, etc.)
--   8- Save your game *again*.
--   9- Start the game whenever you are ready. Ensure you choose the appropriate Custom Gym Leader option.
--   10-You did it. :)
--
-- MODEL NOTES:
--   1- To use a custom model:
--      * get the Model GUID and add it to the custom Gym data below
--         - right-click the custom model > Scripting > Copy GUID to clipboard
--      * prior to starting the game, put the model in the models Pokeball (tiny, black, top-left of the table)
--   2- To use an existing model: look for the model_GUID field in the existing Pokemon data. I suggest you copy any effects and offsets as well.
--
-- LEADER POKEMON NOTES:
--   1- The first type is the only type that matters for opponent effectiveness. Dual-type effectiveness is not in this game (yet?).
--   2- STAB calculations, though not perfect, are calulated using both types (dumb, I know). But it really only affects the inital counter values on the table.

-- gymTier field values:
--    gyms tiers: 1-8
--    elite4    : 9
--    champion  : 10
--    TR        : 11
--
-- Any questions, ask us in Discord: https://discord.gg/kU9XD7tXAV
customGymData =
{
  -- Champion Example.
  {
    guid = "5aae38",          -- Card GUID. (Host: right-click the card > Scripting > Copy GUID to clipboard)
    trainerName = "Kyruya",   -- Name of the trainer.
    gen = "custom",           -- Gen field. Always use "custom".
    gymTier = 10,             -- Gym Tier. See the comment above this table for valid values.
    pokemon = {               -- The leader's Pokemon. NOTE: Unique moves also need to be added to customMoveData. CTRL+F to see if the move is already in the moveData table.
      { name = "Noivern",   level = 9,  types = { "Dragon" },          moves = { "Flamethrower", "Hurricane", "Draco Meteor" }, model_GUID = "212e94", spawn_effect="Status Attack" },
      { name = "Cramorant", level = 10, types = { "Electric", "Ice" }, moves = { "Gulping Missle", "Ice Beam", "Surf" },        model_GUID = "2b1b24"  } }
  }
}

-----------------------------------------------------------------------------------------
-- Custom Move Data
--
-- RECOMMENDATION: To properly edit this field do the following:
--   1- Save your game
--   2- In the TTS script editor: Copy the entirety of this script and paste it into a text editor
--       of your choice (Npp or VS Code offer syntax highlighting which helps prevent silly mistakes)
--   3- In the text editor: make your changes as needed
--   OPTIONAL: Save off your customMoveData field into a text file on your Desktop so you don't have 
--             to recreate it in the future
--   4- In the text editor: CTRL+A -> CTRL+C to copy the entirety of this script with your changes
--   5- In the TTS script editor: CTRL+A -> CTRL+V to overwrite the entirety of the old script with
--       your new version
--   6- In the TTS script editor: at the top-left of the window, click Save & Play. You did it. :)
--
-- NOTES: 
--   1- The dice field is mandatory but does not affect the game in its current state
--   2- The STAB field is mandatory but only affects the initial counter values on the table
--   3- The effects field is optional and does not affect the game in its current state
--   4- The name, power and type fields are actually important. If you want your move to behave 
--       appropriately with the Battle Arena, fill them out in a case-sensitive matter with care.
--   5- If you are entering moves here, they should not share the same name with an existing move.
--       The move logic searches through the base game moves first and if the move names are identical
--       then the custom version will never get seen.
--
-- Any questions, ask us in Discord: https://discord.gg/kU9XD7tXAV
customMoveData = 
{
  -- Example moves.
  {name="Draco Meteor",     power=3,   type="Dragon",   dice=6, STAB=true,     effects={{name="AttackDown", target="Self"}} },
  {name="Gulping Missle",   power=1,   type="Electric", dice=6, STAB=true,     effects={{name="Paralyse", target="Enemy"}} },
}

-----------------------------------------------------------------------------------------
-- Custom Pokemon Data
--
-- In order for this data to be utilizied, you must choose the appropriate Pokemon Generation option 
-- during setup. When choosing your Gens of Pokemon, ensure Custom is also toggled.
--
-- RECOMMENDATION: To properly edit this field do the following:
--   1- This only works at setup. So first, save your game.
--   2- In the TTS script editor: Copy the entirety of this script and paste it into a text editor
--       of your choice (Npp or VS Code offer syntax highlighting which helps prevent silly mistakes)
--   3- In the text editor: make your changes as needed
--   OPTIONAL: Save off your customPokemonData field into a text file on your Desktop so you don't have 
--             to recreate it in the future
--   4- In the text editor: CTRL+A -> CTRL+C to copy the entirety of this script with your changes
--   5- In the TTS script editor: CTRL+A -> CTRL+V to overwrite the entirety of the old script with
--       your new version
--   6- In the TTS script editor: at the top-left of the window, click Save & Play.
--   7- If new: Apply the Pokemon Token tag to each of your tokens by right-clicking, click Tags and 
--              illuminate the Pokemon Token tag in the list.
--   8- If new: Right-click each of your new pokemon tokens and click Save Object. Now, if you respawn 
--              these tokens from saved objects in the future they will have the same GUID.
--   9- Back in the game, it is RECOMMENDED to apply the tag of "Pokemon Token" to your token to get some
--      of this mod's built-in functionality to work for your token. Not mandatory though.
--   10-Now, move your Custom Tokens to their appropriate Pokeballs (Custom Pink, Green, Yellow, etc.),
--      NOTE: If they are an evo token, they must go in the evo Pokeball for their color.
--   11-Save your game *again*.
--   12-Start the game whenever you are ready. Ensure Custom Pokemon are enabled in the setup window.
--   13-You did it. :)
--
-- MODEL NOTES:
--   1- To use a custom model:
--      * get the Model GUID and add it to the custom Gym data below
--         - right-click the custom model > Scripting > Copy GUID to clipboard
--      * prior to starting the game, put the model in the models Pokeball (tiny, black, top-left of the table)
--   2- To use an existing model: look for the model_GUID field in the existing Pokemon data. I suggest you copy any effects and offsets as well.
--
-- DATA NOTES:
--   1- Pokemon evolutions require duplicate tokens - one for catching as a wild and one or more for evolution purposes. There are examples all 
--       throughout the codebase that you can reference. Shown below is how Bulbasaur knows it evolves into Ivysaur and how Ivysaur evolves into 
--       to which tokens are available to grab. The duplicate GUIDs are mandatory because there can be multiple Venesaurs at the same time. 
--       Venusaur. Note the duplicate guids fields as they give reference  For example, the first Venasaur could be caught on a red tile. In 
--       addition, an Ivysaur could be caught and evolve into the second Venasaur. Finally, a Trainer could start with Bulbasaur and evolve it 
--       all the way to Venasaur - making the third concurrent Venasaur on the table. This is how it do :).
--       Example evolving code:
--       { name = "Bulbasaur",   level = 1, types = { "Grass", "Poison" },    moves = { "Vine Whip", "Tackle" },          guids = { "d79fc7" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "8d43e0" } } } },
--       { name = "Ivysaur",     level = 3, types = { "Grass", "Poison" },    moves = { "Poison Powder", "Razor Leaf" },  guids = { "60bde3", "8d43e0" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "85a0be", "6e6869" } } } },
--       { name = "Venusaur",    level = 5, types = { "Grass", "Poison" },    moves = { "Double-Edge", "Solar Beam" },    guids = { "e69464", "85a0be", "6e6869" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "c941db", "305e33" } }, 
--                                                                                                                                                                             { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "0fdf45", "55e05e" } } },
--       As you can see, Bulbasaur has one entry called evoData that describes the Ivysaur that it can evolve to. Only the evo token (8d43e0) for 
--       Ivysaur is specified in the evoData, not the wild token (60bde3). For simplicty, in a guids field, the left GUID will be the wild, and after 
--       that are for evo GUIDs. Continuing on, the Ivysaur lists two GUIDs in its evoData (85a0be & 6e6869) that correspond to the evo GUIDs of Venusaur. 
--       Venasaur is interesting because it can evolve into two different variants (the Mega and GMax variants). These evolutions are special and are 
--       identified by the "cost" field being set to "Mega" or "GMax" as appropriate and also the presence of the cycle=true field. This allows Mega and 
--       Gmax Pokemon to devolve.
--
--       Aside from evolution info, the level field identifies its base level, types and moves are self-explanatory. For models, use the model_GUID field.
--
-- Any questions, ask us in Discord: https://discord.gg/kU9XD7tXAV
customPokemonData =
{
  { name = "Pikachu", level = 1, types = { "Electric" }, moves = { "Electroweb", "Leer" }, guids = { "77331c", "d7835d" } }
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  DATA
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Add Pokemon here that are always included regardless of gens configured at the start of the game.
boardPokemonData = 
{
  -- Gen I only.
  { name = "Snorlax",     level = 4, types = { "Normal" },          moves = { "Body Slam", "Yawn" },         guids = { "d1ee94", "d4b8d9" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "318baa", "cc9678" } } }, model_GUID = "829f1b", spawn_effect="Physical Attack", custom_scale=0.8 },
  -- Gen II only.
  { name = "Red Gyarados",level = 5, types = { "Water", "Flying" }, moves = { "Dragon Rage", "Waterfall" },  guids = { "390ee2" }, evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "bc99f5" } } }, model_GUID = "628aa3", custom_scale=0.75 },
  { name = "Sudowoodo",   level = 3, types = { "Rock" },            moves = { "Rock Throw", "Mimic" },       guids = { "315879" }, model_GUID = "b0f59f", spawn_effect="Physical Attack" }
}

-- These are pokemon that live in the Fossil Pokeball for use during the fossil event card.
fossilPokeballPokemonData =
{
  -- Gen I.
  { name = "Omanyte",     level = 4, types = { "Rock", "Water" },      moves = { "Spike Cannon", "Water Gun" },    guids = { "a7a570" },                    evoData = { { cost = 2, ball = FOSSIL, gen = 1, guids = { "78f088" }, model_GUID = "78ec0f" } }, model_GUID = "9a4753" },
  { name = "Omastar",     level = 6, types = { "Rock", "Water" },      moves = { "Hydro Pump", "Horn Attack" },    guids = { "8bb73e", "78f088" }, model_GUID = "78ec0f" },
  { name = "Kabuto",      level = 4, types = { "Rock", "Water" },      moves = { "Harden", "Absorb" },             guids = { "60f75b" },                    evoData = { { cost = 2, ball = FOSSIL, gen = 1, guids = { "cd2b61" }, model_GUID = "bd4880" } }, model_GUID = "f2a8a6" },
  { name = "Kabutops",    level = 6, types = { "Rock", "Water" },      moves = { "Hydro Pump", "Slash" },          guids = { "03f2a5", "cd2b61" }, model_GUID = "bd4880" },
  { name = "Aerodactyl",  level = 4, types = { "Rock", "Flying" },     moves = { "Hyper Beam", "Wing Attack" },    guids = { "90e141" },                    evoData = { { cost = "Mega", ball = FOSSIL, gen = 1, cycle = true, guids = { "01108b" }, model_GUID = "411f15", spawn_effect="Mega Evolve" } }, model_GUID = "ba21f7" },
  { name = "Mega Aerodactyl", level = 5, types = { "Rock", "Flying" }, moves = { "Ancient Power", "Iron Head" },   guids = { "01108b" },                    evoData = { { cost = 0, ball = FOSSIL, gen = 1, cycle = true, guids = { "90e141" } } }, model_GUID = "411f15", spawn_effect="Mega Evolve" },

  -- Gen III.
  { name = "Lileep",      level = 2, types = { "Rock", "Grass" },      moves = { "Confuse Ray", "Acid" },          guids = { "d9cc5c" },                    evoData = { { cost = 3, ball = FOSSIL, gen = 3, guids = { "5b2008" }, model_GUID = "a8c907" } }, model_GUID = "77fdf5" },
  { name = "Cradily",     level = 5, types = { "Rock", "Grass" },      moves = { "Ancient Power", "Amnesia" },     guids = { "dcaf7c", "5b2008" }, model_GUID = "a8c907" },
  { name = "Anorith",     level = 2, types = { "Rock", "Bug" },        moves = { "Rock Blast", "Water Gun" },      guids = { "25cda8" },                    evoData = { { cost = 3, ball = FOSSIL, gen = 3, guids = { "ed394a" }, model_GUID = "812ce0" } }, model_GUID = "5b5bf7" },
  { name = "Armaldo",     level = 5, types = { "Rock", "Bug" },        moves = { "Ancient Power", "Fury Cutter" }, guids = { "1e3aa3", "ed394a" }, model_GUID = "812ce0" },

  -- Gen IV.
  { name = "Cranidos",    level = 2, types = { "Rock" },               moves = { "Assurance", "Headbutt" },        guids = { "2f9039" },                    evoData = { { cost = 2, ball = FOSSIL, gen = 4, guids = { "8dcea0" }, model_GUID = "163e32", spawn_effect="Physical Attack" } }, model_GUID = "c3204c", spawn_effect="Physical Attack" },
  { name = "Rampardos",   level = 4, types = { "Rock" },               moves = { "Zen Headbutt", "Head Smash" },   guids = { "1df34d", "8dcea0" }, model_GUID = "163e32", spawn_effect="Physical Attack" },
  { name = "Shieldon",    level = 2, types = { "Rock", "Steel" },      moves = { "Metal Sound", "Taunt" },         guids = { "5ea701" },                    evoData = { { cost = 2, ball = FOSSIL, gen = 4, guids = { "23917a" }, model_GUID = "9d8d6d" } }, model_GUID = "1d508b" },
  { name = "Bastiodon",   level = 4, types = { "Rock", "Steel" },      moves = { "Ancient Power", "Iron Head" },   guids = { "6acab9", "23917a" }, model_GUID = "9d8d6d", custom_scale=0.7 },

  -- Gen V.
  { name = "Tirtouga",    level = 4, types = { "Water", "Rock" },      moves = { "Shell Smash", "Water Gun" },     guids = { "0c4e88" },                    evoData = { { cost = 2, ball = FOSSIL, gen = 5, guids = { "471602" }, model_GUID = "212e44" } }, model_GUID = "8bbd45" },
  { name = "Carracosta",  level = 6, types = { "Water", "Rock" },      moves = { "Ancient Power", "Aqua Tail" },   guids = { "b1ab90", "471602" }, model_GUID = "212e44" },
  { name = "Archen",      level = 4, types = { "Rock", "Flying" },     moves = { "Quick Attack", "Dragon Claw" },  guids = { "03a4fe" },                    evoData = { { cost = 2, ball = FOSSIL, gen = 5, guids = { "8eb336" }, model_GUID = "e52be5", spawn_effect="Physical Attack" } }, model_GUID = "fe5542" },
  { name = "Archeops",    level = 6, types = { "Rock", "Flying" },     moves = { "Ancient Power", "Wing Attack" }, guids = { "e5d4b8", "8eb336" }, model_GUID = "e52be5", spawn_effect="Physical Attack" },

  -- Gen VI.
  { name = "Tyrunt",      level = 4, types = { "Rock", "Dragon" },     moves = { "Stomp", "Bite" },                guids = { "82c698" },                     evoData = { { cost = 2, ball = FOSSIL, gen = 6, guids = { "3b26e9" }, model_GUID = "e8c337", spawn_effect="Status Attack" } }, model_GUID = "f6e97c" },
  { name = "Tyrantrum",   level = 6, types = { "Rock", "Dragon" },     moves = { "Head Smash", "Dragon Claw" },    guids = { "57cab1", "3b26e9" }, model_GUID = "e8c337", spawn_effect="Status Attack" },
  { name = "Amaura",      level = 4, types = { "Rock", "Ice" },        moves = { "Take Down", "Icy Wind" },        guids = { "2f33d9" },                     evoData = { { cost = 2, ball = FOSSIL, gen = 6, guids = { "8ae857" }, model_GUID = "17494e", spawn_effect="Physical Attack" } }, model_GUID = "73d866" },
  { name = "Aurorus",     level = 6, types = { "Rock", "Ice" },        moves = { "Aurora Beam", "Ancient Power" }, guids = { "08a1a8", "8ae857" }, model_GUID = "17494e", spawn_effect="Physical Attack" },

  -- Gen VIII.
  { name = "Dracozolt",   level = 4, types = { "Electric", "Dragon" }, moves = { "Ancient Power", "Discharge" },   guids = { "615501" }, model_GUID = "37afb9", custom_scale=0.8 },
  { name = "Arctozolt",   level = 4, types = { "Electric", "Ice" },    moves = { "Ancient Power", "Freeze-Dry" },  guids = { "d053c4"}, model_GUID = "58dc46" }, 
  { name = "Dracovish",   level = 4, types = { "Water", "Dragon" },    moves = { "Dragon Rush", "Ancient Power" }, guids = { "b72461"}, model_GUID = "8f7c9c" }, 
  { name = "Arctovish",   level = 4, types = { "Water", "Ice" },       moves = { "Ancient Power", "Liquidation" }, guids = { "7f0a8a"}, model_GUID = "d1ae37" }
}

gen1PokemonData =
{
  -- Gen 1 1-50
  { name = "Bulbasaur",   level = 1, types = { "Grass", "Poison" },    moves = { "Vine Whip", "Tackle" },          guids = { "d79fc7" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "8d43e0" } } }, model_GUID = "e1b027", spawn_effect="Physical Attack" },
  { name = "Ivysaur",     level = 3, types = { "Grass", "Poison" },    moves = { "Poison Powder", "Razor Leaf" },  guids = { "60bde3", "8d43e0" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "85a0be", "6e6869" } } }, model_GUID = "19c53c", offset={x=0, y=0.075, z=0} },
  { name = "Venusaur",    level = 5, types = { "Grass", "Poison" },    moves = { "Double-Edge", "Solar Beam" },    guids = { "e69464", "85a0be", "6e6869" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "c941db", "305e33" }, model_GUID = "40331c", spawn_effect="Mega Evolve" }, 
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "0fdf45", "55e05e" } } }, 
                                                                                                                                                            model_GUID = "452ac8", spawn_effect="Physical Attack", custom_scale=0.6, offset={x=0,y=0,z=-0.1} },
  { name = "Charmander",  level = 1, types = { "Fire" },               moves = { "Ember", "Scratch" },             guids = { "28e8ab" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "7c5381" } } }, model_GUID = "3226f2" },
  { name = "Charmeleon",  level = 3, types = { "Fire" },               moves = { "Flamethrower", "Slash" },        guids = { "e40822", "7c5381" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "6a3112", "8b9dab" } } }, model_GUID = "2bf00e" },
  { name = "Charizard",   level = 5, types = { "Fire", "Flying" },     moves = { "Fire Spin", "Wing Attack" },     guids = { "1c82ed", "6a3112", "8b9dab" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "79685a", "f0024f" }, model_GUID = "29611d", spawn_effect="Mega Evolve" },
                                                                                                                                                                        { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "1344e7", "64108c" }, model_GUID = "3da16c", spawn_effect="Mega Evolve" },
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "9cb6b5", "c4abad" } } }, 
                                                                                                                                                            model_GUID = "27261b", spawn_effect="Status Attack" },
  { name = "Squirtle",    level = 1, types = { "Water" },              moves = { "Bubble", "Tackle" },             guids = { "88717f" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "e89741" } } }, model_GUID = "a96b7f" },
  { name = "Wartortle",   level = 3, types = { "Water" },              moves = { "Water Gun", "Bite" },            guids = { "cb8d39", "e89741" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "1783ad", "427b16" }, model_GUID = "54ea11" } }, model_GUID = "99fd39" },
  { name = "Blastoise",   level = 5, types = { "Water" },              moves = { "Hydro Pump", "Skull Bash" },     guids = { "80eaa8", "1783ad", "427b16" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "b28b0e", "0845e3" }, model_GUID = "08b8f9", spawn_effect="Mega Evolve" }, 
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "308530", "b981cd" } } }, 
                                                                                                                                                            model_GUID = "54ea11" },
  { name = "Caterpie",    level = 1, types = { "Bug" },                moves = { "String Shot" },                  guids = { "1b2082" },                    evoData = { { cost = 1, ball = PINK, gen = 1, guids = { "358aff" } } }, model_GUID = "7c8b8a" },
  { name = "Metapod",     level = 2, types = { "Bug" },                moves = { "Harden", "Tackle" },             guids = { "7d6dcc", "358aff" },          evoData = { { cost = 1, ball = GREEN, gen = 1, guids = { "25d791", "d36522" } } }, model_GUID = "3f9c36" },
  { name = "Butterfree",  level = 3, types = { "Bug", "Flying" },      moves = { "Psybeam", "Gust" },              guids = { "3cb9ed", "25d791", "d36522" },evoData = { { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "614df5", "47362b" } } }, model_GUID = "77c6f3" },
  { name = "Weedle",      level = 1, types = { "Bug", "Poison" },      moves = { "String Shot" },                  guids = { "4dd71c" },                    evoData = { { cost = 1, ball = PINK, gen = 1, guids = { "91bded" } } }, model_GUID = "535929" },
  { name = "Kakuna",      level = 2, types = { "Bug", "Poison" },      moves = { "Poison Sting", "Harden" },       guids = { "daa46b", "91bded" },          evoData = { { cost = 1, ball = GREEN, gen = 1, guids = { "73c602", "61f84a" } } }, model_GUID = "b46efe" },
  { name = "Beedrill",    level = 3, types = { "Bug", "Poison" },      moves = { "Twineedle", "Rage" },            guids = { "f8894f", "73c602", "61f84a" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "d4066d", "f8819a" } } }, model_GUID = "68937e", spawn_effect="Status Attack"  },
  { name = "Pidgey",      level = 1, types = { "Flying", "Normal" },   moves = { "Sand Attack", "Gust" },          guids = { "ffa899" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "35b436" } } }, model_GUID = "e042f9" },
  { name = "Pidgeotto",   level = 3, types = { "Flying", "Normal" },   moves = { "Quick Attack", "Whirlwind" },    guids = { "7d5ef0", "35b436" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "45e30a", "9f1834" } } }, model_GUID = "47d87b", spawn_effect="Physical Attack" },
  { name = "Pidgeot",     level = 5, types = { "Flying", "Normal" },   moves = { "Mirror Move", "Wing Attack" },   guids = { "1d36ba", "45e30a", "9f1834" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "9844cb", "9be58b" } } }, model_GUID = "831415" },
  { name = "Rattata",     level = 1, types = { "Normal" },             moves = { "Tail Whip", "Tackle" },          guids = { "e2226d" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "1533cd" } } }, model_GUID = "dd6f20" },
  { name = "Raticate",    level = 3, types = { "Normal" },             moves = { "Hyper Fang", "Super Fang" },     guids = { "50866f", "1533cd" }, model_GUID = "2539f9" },
  { name = "Spearow",     level = 1, types = { "Flying", "Normal" },   moves = { "Leer", "Peck" },                 guids = { "b2ebc5" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "7598db" } } }, model_GUID = "f508f3" },
  { name = "Fearow",      level = 3, types = { "Flying", "Normal" },   moves = { "Mirror Move", "Drill Peck" },    guids = { "5b5a42", "7598db" }, model_GUID = "c4b8b6" },
  { name = "Ekans",       level = 1, types = { "Poison" },             moves = { "Wrap", "Leer" },                 guids = { "a04efa" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "297aec" } } }, model_GUID = "ac74d9" },
  { name = "Arbok",       level = 3, types = { "Poison" },             moves = { "Acid", "Bite" },                 guids = { "4d4660", "297aec" }, model_GUID = "0df3c1" },
  { name = "Pikachu",     level = 1, types = { "Electric" },           moves = { "Thunder Shock", "Growl" },       guids = { "a17986", "e5c82a" },          evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "654bd9", "3541ed" } }, 
                                                                                                                                                                        { cost = 2, ball = BLUE, gen = 1, guids = { "1e53ce", "ef1a51" }, model_GUID = "ac9e94", spawn_effect="Physical Attack" }, 
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "e932e9", "558a12" } } }, 
                                                                                                                                                            model_GUID = "813555", spawn_effect="Status Attack" },
  { name = "Raichu",      level = 3, types = { "Electric" },           moves = { "Thunderbolt", "Slam" },          guids = { "ffd6fb", "654bd9", "3541ed" }, model_GUID = "ce46d3" },
  { name = "Sandshrew",   level = 1, types = { "Ground" },             moves = { "Sand Attack", "Scratch" },       guids = { "6a3193" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "f4408c" } } }, model_GUID = "6ac711" },
  { name = "Sandslash",   level = 3, types = { "Ground" },             moves = { "Swift", "Dig" },                 guids = { "53db8f", "f4408c" }, model_GUID = "14e1b5" },
  { name = "Nidoran",     level = 1, types = { "Poison" },             moves = { "Growl", "Scratch" },             guids = { "a89779" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "1809dc" } } }, model_GUID = "585515", spawn_effect="Physical Attack" },
  { name = "Nidorina",    level = 3, types = { "Poison" },             moves = { "Poison Sting", "Bite" },         guids = { "ea4a3c", "1809dc" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "965607", "4e6a63" } } }, model_GUID = "22488e" },
  { name = "Nidoqueen",   level = 5, types = { "Poison", "Ground" },   moves = { "Superpower", "Body Slam" },      guids = { "95b3f2", "965607", "4e6a63" }, model_GUID = "c91f41" },
  { name = "Nidoran",     level = 1, types = { "Poison" },             moves = { "Leer", "Tackle" },               guids = { "593d68" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "ed4f88" } } }, model_GUID = "3bb97e", spawn_effect="Physical Attack" },
  { name = "Nidorino",    level = 3, types = { "Poison" },             moves = { "Poison Sting", "Horn Attack" },  guids = { "2978c9", "ed4f88" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "faca75", "1ede33" } } }, model_GUID = "ebed42", offset={x=0,y=0,z=-0.1} },
  { name = "Nidoking",    level = 5, types = { "Poison", "Ground" },   moves = { "Megahorn", "Thrash" },           guids = { "7c6422", "faca75", "1ede33" }, model_GUID = "b038db", offset={x=0,y=0,z=-0.2} },
  { name = "Clefairy",    level = 2, types = { "Fairy" },              moves = { "Double Slap", "Sing" },          guids = { "ed88e4", "04404a" },          evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "a4ce76", "b56e5c" } } }, model_GUID = "782a2e" },
  { name = "Clefable",    level = 3, types = { "Fairy" },              moves = { "Disarming Voice", "Metronome" }, guids = { "b31265", "a4ce76", "b56e5c" }, model_GUID = "b1a7ba" },
  { name = "Vulpix",      level = 2, types = { "Fire" },               moves = { "Quick Attack", "Ember" },        guids = { "11e2aa" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "ea4691" } } }, model_GUID = "7e6d40" },
  { name = "Ninetales",   level = 5, types = { "Fire" },               moves = { "Flamethrower", "Fire Spin" },    guids = { "7cfe42", "ea4691" }, model_GUID = "42c4da" },
  { name = "Jigglypuff",  level = 1, types = { "Normal", "Fairy" },    moves = { "Sing", "Pound" },                guids = { "8d3afd", "81f395" },          evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "e72190", "247fe0" } } }, model_GUID = "92122e" },
  { name = "Wigglytuff",  level = 4, types = { "Normal", "Fairy" },    moves = { "Play Rough", "Body Slam" },      guids = { "e4e003", "e72190", "247fe0" }, model_GUID = "499574", spawn_effect="Physical Attack" },
  { name = "Zubat",       level = 1, types = { "Poison", "Flying" },   moves = { "Leech Life", "Screech" },        guids = { "e36eed" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "975f18" } } }, model_GUID = "6ce120", spawn_effect="Physical Attack" },
  { name = "Golbat",      level = 3, types = { "Poison", "Flying" },   moves = { "Supersonic", "Bite" },           guids = { "77b2b2", "975f18" },          evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "79419e", "1d7367" } } }, model_GUID = "9b980c" },
  { name = "Oddish",      level = 2, types = { "Grass", "Poison" },    moves = { "Poison Powder", "Absorb" },      guids = { "f5c9ab" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "3e7844" } } }, model_GUID = "79e706" },
  { name = "Gloom",       level = 3, types = { "Grass", "Poison" },    moves = { "Stun Spore", "Acid" },           guids = { "22f1f2", "3e7844" },          evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "529150", "19dbd1" } }, { cost = 1, ball = YELLOW, gen = 2, guids = { "fd44a1", "14e4ad" } } }, model_GUID = "aa2f29", spawn_effect="Physical Attack" },
  { name = "Vileplume",   level = 4, types = { "Grass", "Poison" },    moves = { "Sludge Bomb", "Solar Beam" },    guids = { "a65fdf", "529150", "19dbd1" }, model_GUID = "588b3f" },
  { name = "Paras",       level = 2, types = { "Bug", "Grass" },       moves = { "Stun Spore", "Scratch" },        guids = { "f3604e" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "7bae4e" } } }, model_GUID = "07242c", spawn_effect="Physical Attack" },
  { name = "Parasect",    level = 3, types = { "Bug", "Grass" },       moves = { "Spore", "Slash" },               guids = { "021746", "7bae4e" }, model_GUID = "5beef7" },
  { name = "Venonat",     level = 3, types = { "Bug", "Poison" },      moves = { "Stun Spore", "Confusion" },      guids = { "c85b55" },                    evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "25e898" } } }, model_GUID = "dd0526" },
  { name = "Venomoth",    level = 4, types = { "Bug", "Poison" },      moves = { "Sleep Powder", "Leech Life" },   guids = { "2c7de6", "25e898" }, model_GUID = "530c83" },
  -- Gen 1 51-99
  { name = "Diglett",     level = 2, types = { "Ground" },             moves = { "Scratch", "Dig" },               guids = { "b79f00" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "3f6942" } } }, model_GUID = "808d36" },
  { name = "Dugtrio",     level = 4, types = { "Ground" },             moves = { "Earthquake", "Slash" },          guids = { "cfcb95", "3f6942" }, model_GUID = "b4d340", custom_scale=0.8 },
  { name = "Meowth",      level = 2, types = { "Normal" },             moves = { "Pay Day", "Bite" },              guids = { "312c52" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "98722a" } }, { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "48e2c5" } } }, model_GUID = "9e0a72", spawn_effect="Physical Attack" },
  { name = "Persian",     level = 4, types = { "Normal" },             moves = { "Fury Swipes", "Slash" },         guids = { "d56c1a", "98722a" }, model_GUID = "ae2934", offset={x=0, y=0, z=-0.1} },
  { name = "Psyduck",     level = 2, types = { "Water" },              moves = { "Fury Swipes", "Disable" },       guids = { "eeee17" },                    evoData = { { cost = 3, ball = RED, gen = 1, guids = { "4696b8" } } }, model_GUID = "7b6cb0" },
  { name = "Golduck",     level = 5, types = { "Water" },              moves = { "Confusion", "Hydro Pump" },      guids = { "5b9964", "4696b8" }, model_GUID = "e26653" },
  { name = "Mankey",      level = 2, types = { "Fighting" },           moves = { "Low Kick", "Scratch" },          guids = { "c8da5c" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "8b1126" } } }, model_GUID = "85b071", spawn_effect="Physical Attack" },
  { name = "Primeape",    level = 4, types = { "Fighting" },           moves = { "Seismic Toss", "Thrash" },       guids = { "a237dd", "8b1126" },          evoData = { { cost = 1, ball = RED, gen = 9, guids = { "b68eb7", "6b4dfa" } } }, model_GUID = "2b471e", spawn_effect="Physical Attack" },
  { name = "Growlithe",   level = 2, types = { "Fire" },               moves = { "Ember", "Roar" },                guids = { "7c2b34" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "43d4c1" } } }, model_GUID = "b8f54f" },
  { name = "Arcanine",    level = 5, types = { "Fire" },               moves = { "Flamethrower", "Bite" },         guids = { "e52b25", "43d4c1" }, model_GUID = "d89ae7", custom_scale=0.7 },
  { name = "Poliwag",     level = 2, types = { "Water" },              moves = { "Hypnosis", "Bubble" },           guids = { "ecd6a3" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "10f79d" } } }, model_GUID = "c271fd", spawn_effect="Physical Attack" },
  { name = "Poliwhirl",   level = 4, types = { "Water" },              moves = { "Amnesia", "Water Gun" },         guids = { "fd5498", "10f79d" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "b75a29", "50bf9d" } }, 
                                                                                                                                                                        { cost = 2, ball = RED, gen = 2, guids = { "9a1b0b", "b21ff9" } } }, model_GUID = "865416" },
  { name = "Poliwrath",   level = 6, types = { "Water", "Fighting" },  moves = { "Body Slam", "Hydro Pump" },      guids = { "133f27", "b75a29", "50bf9d" }, model_GUID = "24f90c", custom_scale=0.8, offset={x=0, y=0, z=-0.1} },
  { name = "Abra",        level = 2, types = { "Psychic" },            moves = { "Teleport" },                     guids = { "4986cd" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "345d18" } } }, model_GUID = "f338a0" },
  { name = "Kadabra",     level = 3, types = { "Psychic" },            moves = { "Confusion", "Disable" },         guids = { "da1937", "345d18" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "fa44b9", "74c0b4" } } }, model_GUID = "635cd5" },
  { name = "Alakazam",    level = 5, types = { "Psychic" },            moves = { "Psychic", "Reflect" },           guids = { "7117a7", "fa44b9", "74c0b4" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "9eade5", "8132c3" } } }, model_GUID = "c3804e" },
  { name = "Machop",      level = 2, types = { "Fighting" },           moves = { "Low Kick" },                     guids = { "646972" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "0821c2" } } }, model_GUID = "4a5304", spawn_effect="Physical Attack" },
  { name = "Machoke",     level = 4, types = { "Fighting" },           moves = { "Karate Chop", "Leer" },          guids = { "797adf", "0821c2" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "ff6a7f", "518720" } } }, model_GUID = "e7cc3a" },
  { name = "Machamp",     level = 6, types = { "Fighting" },           moves = { "Submission", "Seismic Toss" },   guids = { "b5109b", "ff6a7f", "518720" },evoData = { { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "8d22d5", "1bc1d8" } } }, model_GUID = "94b0de", spawn_effect="Physical Attack" },
  { name = "Bellsprout",  level = 2, types = { "Grass", "Poison" },    moves = { "Vine Whip", "Wrap" },            guids = { "a3cef8" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "4e1d04" } } }, model_GUID = "4ca9db" },
  { name = "Weepinbell",  level = 3, types = { "Grass", "Poison" },    moves = { "Sleep Powder", "Acid" },         guids = { "77bc48", "4e1d04" },          evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "1b329c", "e31246" } } }, model_GUID = "961d7f" },
  { name = "Victreebell", level = 5, types = { "Grass", "Poison" },    moves = { "Razor Leaf", "Slam" },           guids = { "a380e7", "1b329c", "e31246" }, model_GUID = "be71b4", spawn_effect="Physical Attack" },
  { name = "Tentacool",   level = 1, types = { "Water", "Poison" },    moves = { "Poison Sting", "Wrap" },         guids = { "7701e4" },                    evoData = { { cost = 3, ball = BLUE, gen = 1, guids = { "71015b" } } }, model_GUID = "2aefb2" },
  { name = "Tentacruel",  level = 4, types = { "Water", "Poison" },    moves = { "Hydro Pump", "Acid" },           guids = { "4afcb3", "71015b" }, model_GUID = "9dfad1" },
  { name = "Geodude",     level = 1, types = { "Rock", "Ground" },     moves = { "Defense Curl", "Rock Throw" },   guids = { "57f1ed" },                    evoData = { { cost = 3, ball = BLUE, gen = 1, guids = { "f54a1b" } } }, model_GUID = "df4771", spawn_effect="Physical Attack"  },
  { name = "Graveler",    level = 4, types = { "Rock", "Ground" },     moves = { "Self-Destruct", "Rollout" },     guids = { "fbe7bb", "f54a1b" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "4cbb8a", "0a8182" } } }, model_GUID = "f38eaa", spawn_effect="Physical Attack" },
  { name = "Golem",       level = 6, types = { "Rock", "Ground" },     moves = { "Explosion", "Earthquake" },      guids = { "904780", "4cbb8a", "0a8182" }, model_GUID = "aa0bdd", spawn_effect="Physical Attack" },
  { name = "Ponyta",      level = 4, types = { "Fire" },               moves = { "Take Down", "Ember" },           guids = { "67fd81" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "b92f63" } } }, model_GUID = "a1a9ce" },
  { name = "Rapidash",    level = 6, types = { "Fire" },               moves = { "Stomp", "Fire Spin" },           guids = { "f651d6", "b92f63" }, model_GUID = "20403e", custom_scale=0.7, offset={x=0, y=0, z=0.1} },
  { name = "Slowpoke",    level = 2, types = { "Water", "Psychic" },   moves = { "Confusion", "Disable" },         guids = { "fb1925" },                    evoData = { { cost = 3, ball = RED, gen = 1, guids = { "4b8280" } }, { cost = 3, ball = RED, gen = 2, guids = { "83160e" } } }, model_GUID = "f89c9b", custom_scale=0.8 },
  { name = "Slowbro",     level = 5, types = { "Water", "Psychic" },   moves = { "Water Gun", "Psychic" },         guids = { "adce28", "4b8280" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "6060e8", "083e93" } } }, model_GUID = "6cd8f3", custom_scale=0.85 },
  { name = "Magnemite",   level = 3, types = { "Electric", "Steel" },  moves = { "Thunder Shock", "Tackle" },      guids = { "23a41e" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "7a8fae" } } }, model_GUID = "947e98" },
  { name = "Magneton",    level = 4, types = { "Electric", "Steel" },  moves = { "Thunderbolt", "Swift" },         guids = { "0e43ae", "7a8fae" },          evoData = { { cost = 2, ball = RED, gen = 4, guids = { "dedadf", "618210" } } }, model_GUID = "f82ef9" },
  { name = "Farfetch'd",  level = 3, types = { "Flying", "Normal" },   moves = { "Swords Dance", "Peck" },         guids = { "489e66" }, model_GUID = "946c27", spawn_effect="Physical Attack" },
  { name = "Doduo",       level = 3, types = { "Flying", "Normal" },   moves = { "Fury Attack", "Peck" },          guids = { "9e2524" },                    evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "ee2d7d" } } }, model_GUID = "1bd0bc" },
  { name = "Dodrio",      level = 4, types = { "Flying", "Normal" },   moves = { "Tri Attack", "Drill Peck" },     guids = { "bdd1d3", "ee2d7d" }, model_GUID = "299ecd" },
  { name = "Seel",        level = 4, types = { "Water" },              moves = { "Aurora Beam", "Take Down" },     guids = { "e71d19" },                    evoData = { { cost = 1, ball = RED, gen = 1, guids = { "8621ed" } } }, model_GUID = "954d89" },
  { name = "Dewgong",     level = 5, types = { "Water", "Ice" },       moves = { "Headbutt", "Ice Beam" },         guids = { "46abb5", "8621ed" }, model_GUID = "6fa3a7", spawn_effect="Physical Attack" },
  { name = "Grimer",      level = 4, types = { "Poison" },             moves = { "Poison Gas", "Pound" },          guids = { "b0bb78" },                    evoData = { { cost = 1, ball = RED, gen = 1, guids = { "e86ddd" } } }, model_GUID = "3e38eb", custom_scale=0.85 },
  { name = "Muk",         level = 5, types = { "Poison" },             moves = { "Acid Armor", "Sludge" },         guids = { "78a11c", "e86ddd" }, model_GUID = "813b8b", custom_scale=0.5 },
  { name = "Shellder",    level = 2, types = { "Water" },              moves = { "Clamp", "Protect" },             guids = { "b7a634" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "24e258" } } }, model_GUID = "4be354", spawn_effect="Physical Attack" },
  { name = "Cloyster",    level = 4, types = { "Water", "Ice" },       moves = { "Aurora Beam", "Water Pulse" },   guids = { "fb7658", "24e258" }, model_GUID = "73e384" },
  { name = "Gastly",      level = 3, types = { "Ghost", "Poison" },    moves = { "Confuse Ray" },                  guids = { "36f853" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "f1eac8" } } }, model_GUID = "20085a" },
  { name = "Haunter",     level = 4, types = { "Ghost", "Poison" },    moves = { "Hypnosis", "Lick" },             guids = { "0f5b22", "f1eac8" },          evoData = { { cost = 1, ball = RED, gen = 1, guids = { "7d5d39", "ad0856" } } ,}, model_GUID = "13b866" },
  { name = "Gengar",      level = 5, types = { "Ghost", "Poison" },    moves = { "Sludge Bomb", "Night Shade" },   guids = { "fe0809", "7d5d39", "ad0856" },evoData = { { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "774eaa", "1b8bc7" } },
                                                                                                                                                                        { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "5ef98c", "68c539" } } }, 
                                                                                                                                                            model_GUID = "4638bc" },
  { name = "Onix",        level = 2, types = { "Rock", "Ground" },     moves = { "Rock Throw", "Screech" },        guids = { "575fcf" },                    evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "9248b4" } } }, model_GUID = "f5b6ad", custom_scale=0.7, offset={x=0,y=0,z=0.3} },
  { name = "Drowzee",     level = 2, types = { "Psychic" },            moves = { "Confusion", "Disable" },         guids = { "5bda37" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "56108c" } } }, model_GUID = "2ceecd" },
  { name = "Hypno",       level = 4, types = { "Psychic" },            moves = { "Headbutt", "Psychic" },          guids = { "08ee2c", "56108c" }, model_GUID = "beca37", offset={x=0, y=0, z=-0.05} },
  { name = "Krabby",      level = 2, types = { "Water" },              moves = { "Vise Grip", "Bubble" },          guids = { "54a03e" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "aa3008" } } }, model_GUID = "75755a" },
  { name = "Kingler",     level = 4, types = { "Water" },              moves = { "Crabhammer", "Guillotine" },     guids = { "f18035", "aa3008" },          evoData = { { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "1fa11f", "9edb28" } } }, model_GUID = "894758", custom_scale=0.8 },
  -- Gen 1 100-151
  { name = "Voltorb",     level = 2, types = { "Electric" },           moves = { "Self-Destruct", "Screech" },     guids = { "7963a6" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "fd080d" } } }, model_GUID = "37bc9d", spawn_effect="Physical Attack" },
  { name = "Electrode",   level = 4, types = { "Electric" },           moves = { "Explosion", "Rollout" },         guids = { "d292b7", "fd080d" }, model_GUID = "2fb88b", spawn_effect="Physical Attack" },
  { name = "Exeggcute",   level = 3, types = { "Grass", "Psychic" },   moves = { "Hypnosis", "Barrage" },          guids = { "c271ca" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "a29b99" } }, { cost = 2, ball = RED, gen = 5, guids = { "56fca1" } } }, model_GUID = "618cb8" },
  { name = "Exeggutor",   level = 5, types = { "Grass", "Psychic" },   moves = { "Solar Beam", "Egg Bomb" },       guids = { "61be01", "a29b99" }, model_GUID = "cc6a34" },
  { name = "Cubone",      level = 3, types = { "Ground" },             moves = { "Bone Club", "Rage" },            guids = { "9bb943" },                    evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "921715" } }, { cost = 1, ball = YELLOW, gen = 7, guids = { "04850a" } } }, model_GUID = "e899ae", spawn_effect="Physical Attack" },
  { name = "Marowak",     level = 4, types = { "Ground" },             moves = { "Bonemerang", "Thrash" },         guids = { "f416a8", "921715" }, model_GUID = "c9b2ac" },
  { name = "Hitmonlee",   level = 4, types = { "Fighting" },           moves = { "Double Kick", "Mega Kick" },     guids = { "1e6425", "10087d" }, model_GUID = "d821ab", spawn_effect="Physical Attack", offset={x=0, y=0, z=-0.08} },
  { name = "Hitmonchan",  level = 4, types = { "Fighting" },           moves = { "Mega Punch", "Counter" },        guids = { "ffe3b0", "d55591" }, model_GUID = "4fea7f", spawn_effect="Physical Attack" },
  { name = "Lickitung",   level = 4, types = { "Normal" },             moves = { "Lick", "Slam" },                 guids = { "6abe93" },                    evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "5d1069" } } }, model_GUID = "d27c75" },
  { name = "Koffing",     level = 3, types = { "Poison" },             moves = { "Smog", "Tackle" },               guids = { "902c83" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "923b8f" } }, { cost = 2, ball = RED, gen = 8, guids = { "dccfa4" } } }, model_GUID = "b853ca" },
  { name = "Weezing",     level = 5, types = { "Poison" },             moves = { "Self-Destruct", "Sludge" },      guids = { "934454", "923b8f" }, model_GUID = "921e94" },
  { name = "Rhyhorn",     level = 4, types = { "Ground", "Rock" },     moves = { "Fury Attack", "Horn Attack" },   guids = { "b40a42" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "6922c6" } } }, model_GUID = "99c208", custom_scale=0.85 },
  { name = "Rhydon",      level = 6, types = { "Ground", "Rock" },     moves = { "Horn Drill", "Earthquake" },     guids = { "2cb778", "6922c6" },          evoData = { { cost = 1, ball = RED, gen = 4, guids = { "1665fe", "f2b985" } } }, model_GUID = "2c20b7", custom_scale=0.8 },
  { name = "Chansey",     level = 4, types = { "Normal" },             moves = { "Double Slap", "Sing" },          guids = { "0f0dcb", "ee10ff" },          evoData = { { cost = 1, ball = RED, gen = 2, guids = { "5b9024", "774d72" } } }, model_GUID = "87d9f4" },
  { name = "Tangela",     level = 3, types = { "Grass" },              moves = { "Vine Whip", "Bind" },            guids = { "1ca74c" },                    evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "5965cd" } } }, model_GUID = "9ff5ec" },
  { name = "Kangaskhan",  level = 4, types = { "Normal" },             moves = { "Dizzy Punch", "Bite" },          guids = { "cf2b95" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "0eb8c8" } } }, model_GUID = "98bc9e", custom_scale=0.6, offset={x=0, y=0, z=0.05} },
  { name = "Horsea",      level = 2, types = { "Water" },              moves = { "Bubble", "Leer" },               guids = { "17d28f" },                    evoData = { { cost = 3, ball = RED, gen = 1, guids = { "a87dc7" } } }, model_GUID = "16af3c" },
  { name = "Seadra",      level = 5, types = { "Water" },              moves = { "Smokescreen", "Bubble Beam" },   guids = { "f5b456", "a87dc7" },          evoData = { { cost = 1, ball = RED, gen = 2, guids = { "0b677f", "3b17f1" } } }, model_GUID = "9c2ba7" },
  { name = "Goldeen",     level = 2, types = { "Water" },              moves = { "Horn Attack", "Peck" },          guids = { "7ba0cd" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "4d1c92" } } }, model_GUID = "b633e8" },
  { name = "Seaking",     level = 5, types = { "Water" },              moves = { "Fury Attack", "Waterfall" },     guids = { "0fbe89", "4d1c92" }, model_GUID = "429324" },
  { name = "Staryu",      level = 2, types = { "Water" },              moves = { "Water Gun", "Tackle" },          guids = { "887830" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "e03570" } } }, model_GUID = "792e94", spawn_effect="Physical Attack" },
  { name = "Starmie",     level = 5, types = { "Water", "Psychic" },   moves = { "Hydro Pump", "Swift" },          guids = { "4f6664", "e03570" }, model_GUID = "1072a5" },
  { name = "Mr. Mime",    level = 3, types = { "Psychic", "Fairy" },   moves = { "Confusion", "Barrier" },         guids = { "5c3184", "8315de" }, model_GUID = "b25a93" },
  { name = "Scyther",     level = 4, types = { "Bug", "Flying" },      moves = { "Fury Cutter", "Slash" },         guids = { "36242b" },                    evoData = { { cost = 1, ball = RED, gen = 2, guids = { "22e6a3" } }, { cost = 1, ball = RED, gen = 8, guids = { "18d390" } } }, model_GUID = "a98dea" },
  { name = "Jynx",        level = 4, types = { "Ice", "Psychic" },     moves = { "Lovely Kiss", "Ice Punch" },     guids = { "7fad23", "4bc360" }, model_GUID = "43c517", custom_scale=0.9 },
  { name = "Electabuzz",  level = 4, types = { "Electric" },           moves = { "Thunder Punch", "Screech" },     guids = { "00e028", "749909" },          evoData = { { cost = 2, ball = RED, gen = 4, guids = { "11f593", "896d6e" } } }, model_GUID = "ad494f" },
  { name = "Magmar",      level = 4, types = { "Fire" },               moves = { "Fire Punch", "Smog" },           guids = { "e92ee6", "a0aed6" },          evoData = { { cost = 2, ball = RED, gen = 4, guids = { "bc96fe", "ebafae" } } }, model_GUID = "ff3210" },
  { name = "Pinsir",      level = 4, types = { "Bug" },                moves = { "X-Scissor", "Vise Grip" },       guids = { "141f37" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "202a18" } } }, model_GUID = "4e7512" },
  { name = "Tauros",      level = 4, types = { "Normal" },             moves = { "Take Down", "Swagger" },         guids = { "904903" }, model_GUID = "797eb7", spawn_effect="Physical Attack", custom_scale=0.85 },
  { name = "Magikarp",    level = 1, types = { "Water" },              moves = { "Splash" },                       guids = { "f877ca" },                    evoData = { { cost = 2, ball = GREEN, gen = 1, guids = { "985830" } } }, model_GUID = "48944e", spawn_effect="Physical Attack" },
  { name = "Gyarados",    level = 3, types = { "Water", "Flying" },    moves = { "Dragon Rage", "Bite" },          guids = { "d14d19", "985830" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "f45bf6", "4d5c16" } } }, model_GUID = "bb17bd", custom_scale=0.75 }, 
  { name = "Lapras",      level = 3, types = { "Water", "Ice" },       moves = { "Body Slam", "Ice Beam" },        guids = { "a465e9" },                    evoData = { { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "f23aef" } } }, model_GUID = "ae0d8f", custom_scale=0.8, offset={x=0, y=0.2, z=-0.1} },
  { name = "Ditto",       level = 4, types = { "Normal" },             moves = { "Transform" },                    guids = { "c2023e" }, model_GUID = "babb44" },
  { name = "Eevee",       level = 3, types = { "Normal" },             moves = { "Quick Attack", "Bite" },         guids = { "690870" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "98756d" }, model_GUID = "b8e8a6" }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 1, guids = { "090cce" }, model_GUID = "c86032" }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 1, guids = { "901417" }, model_GUID = "323c42" }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 2, guids = { "63caca" }, model_GUID = "33d105" }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 2, guids = { "5daac2" }, model_GUID = "c8a52c" }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 4, guids = { "25ef7b" }, model_GUID = "9f14e6" }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 4, guids = { "549166" }, model_GUID = "8884ba" },
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 6, guids = { "7ea880" }, model_GUID = "381a03" },
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, cycle = true, guids = { "6041c6" }, model_GUID = "b49fe8" } }, 
                                                                                                                                                            model_GUID = "b37bcd" },
  { name = "Vaporeon",    level = 5, types = { "Water" },              moves = { "Aurora Beam", "Hydro Pump" },    guids = { "dc74f4", "98756d" }, model_GUID = "b8e8a6" },
  { name = "Jolteon",     level = 5, types = { "Electric" },           moves = { "Pin Missile", "Thunder" },       guids = { "7309b7", "090cce" }, model_GUID = "c86032" },
  { name = "Flareon",     level = 5, types = { "Fire" },               moves = { "Fire Blast", "Smog" },           guids = { "2eadbb", "901417" }, model_GUID = "323c42" },
  { name = "Porygon",     level = 2, types = { "Normal" },             moves = { "Conversion", "Sharpen" },        guids = { "f4d087" },                    evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "145660" } } }, model_GUID = "7e5d3b" },
  { name = "Omanyte",     level = 4, types = { "Rock", "Water" },      moves = { "Spike Cannon", "Water Gun" },    guids = { "7c9350" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "4bad46" } } }, model_GUID = "9a4753" },
  { name = "Omastar",     level = 6, types = { "Rock", "Water" },      moves = { "Hydro Pump", "Horn Attack" },    guids = { "fcdf06", "4bad46" }, model_GUID = "78ec0f" },
  { name = "Kabuto",      level = 4, types = { "Rock", "Water" },      moves = { "Harden", "Absorb" },             guids = { "adad5d" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "b99ba9" } } }, model_GUID = "f2a8a6" },
  { name = "Kabutops",    level = 6, types = { "Rock", "Water" },      moves = { "Hydro Pump", "Slash" },          guids = { "2fbb99", "b99ba9" }, model_GUID = "bd4880" },
  { name = "Aerodactyl",  level = 4, types = { "Rock", "Flying" },     moves = { "Hyper Beam", "Wing Attack" },    guids = { "b69470" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "5ffdbe" } } }, model_GUID = "ba21f7"  },
  { name = "Snorlax",     level = 4, types = { "Normal" },             moves = { "Body Slam", "Yawn" },            guids = { "81f09a", "a017f9" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "318baa", "cc9678" } } }, model_GUID = "829f1b", spawn_effect="Physical Attack", custom_scale=0.8 },
  { name = "Articuno",    level = 7, types = { "Ice", "Flying" },      moves = { "Mirror Coat", "Blizzard" },      guids = { "0e47e0" }, model_GUID = "fd860a" },
  { name = "Zapdos",      level = 7, types = { "Electric", "Flying" }, moves = { "Thunder", "Drill Peck" },        guids = { "810844" }, model_GUID = "0e0c94" },
  { name = "Moltres",     level = 7, types = { "Fire", "Flying" },     moves = { "Sky Attack", "Flamethrower" },   guids = { "cf5cee" }, model_GUID = "edf3cc", spawn_effect="Physical Attack" },
  { name = "Dratini",     level = 2, types = { "Dragon" },             moves = { "Wrap", "Leer" },                 guids = { "7a8c75" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "3add33" } } }, model_GUID = "1e6e11" },
  { name = "Dragonair",   level = 4, types = { "Dragon" },             moves = { "Thunder Wave", "Slam" },         guids = { "7189e9", "3add33" },          evoData = { { cost = 3, ball = RED, gen = 1, guids = { "bd4406", "1b136e" } } }, model_GUID = "a88377" },
  { name = "Dragonite",   level = 7, types = { "Dragon", "Flying" },   moves = { "Dragon Rage", "Hyper Beam" },    guids = { "907860", "bd4406", "1b136e" }, model_GUID = "fa47e5" },
  { name = "Mewtwo",      level = 7, types = { "Psychic" },            moves = { "Shadow Ball", "Future Sight" },  guids = { "d78d06" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "bf8dc5" } }, { cost = "Mega", ball = MEGA, gen = 1, cycle = true, guids = { "a4bdc6" } } }, model_GUID = "8dad23" },
  { name = "Mew",         level = 7, types = { "Psychic" },            moves = { "Ancient Power", "Psychic" },     guids = { "d68dfc" }, model_GUID = "5dbae0", spawn_effect="Physical Attack" },

  -- Mega evolutions.
  { name = "Mega Blastoise",    level = 6,    types = { "Water" },     moves = { "Flash Cannon", "Scald" },         guids = { "b28b0e", "0845e3" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "80eaa8", "1783ad", "427b16" }, model_GUID = "54ea11" } }, model_GUID = "08b8f9", spawn_effect="Mega Evolve" },
  { name = "GMax Blastoise",    level = 5,    types = { "Water" },     moves = { "Cannonade", "Strike" },           guids = { "308530", "b981cd" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "80eaa8", "1783ad", "427b16" }, model_GUID = "54ea11" } }, model_GUID = "d1dd67", custom_scale=0.45, offset={x=0, y=0, z=-0.03} },
  { name = "Mega Venusaur",     level = 6,    types = { "Grass", "Poison" }, moves = { "Sludge Bomb", "Petal Dance" }, guids = { "c941db", "305e33" },      evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "e69464", "85a0be", "6e6869" }, model_GUID = "452ac8", spawn_effect="Physical Attack" } }, model_GUID = "40331c", spawn_effect="Mega Evolve", custom_scale=0.65 },
  { name = "GMax Venusaur",     level = 5,    types = { "Grass", "Poison" }, moves = { "Vine Lash", "Strike" },     guids = { "0fdf45", "55e05e" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "e69464", "85a0be", "6e6869" }, model_GUID = "452ac8", spawn_effect="Physical Attack" } }, model_GUID = "8f8e22", custom_scale=0.35, offset={x=0, y=0, z=-0.03} },
  { name = "Mega Charizard X",  level = 6,    types = { "Fire", "Dragon" }, moves = { "Dragon Claw", "Inferno" },   guids = { "79685a", "f0024f" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "1c82ed", "6a3112", "8b9dab" }, model_GUID = "27261b", spawn_effect="Status Attack" } }, model_GUID = "29611d", spawn_effect="Mega Evolve" },
  { name = "Mega Charizard Y",  level = 6,    types = { "Fire", "Flying" }, moves = { "Air Slash", "Inferno" },     guids = { "1344e7", "64108c" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "1c82ed", "6a3112", "8b9dab" }, model_GUID = "27261b", spawn_effect="Status Attack" } }, model_GUID = "3da16c", spawn_effect="Mega Evolve" },
  { name = "GMax Charizard",    level = 6,    types = { "Fire", "Flying" }, moves = { "Wildfire", "Airstream" },    guids = { "9cb6b5", "c4abad" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "1c82ed", "6a3112", "8b9dab" }, model_GUID = "27261b", spawn_effect="Status Attack" } }, model_GUID = "156d05", custom_scale=0.5, offset={x=0, y=0, z=-0.03} },
  { name = "Mega Alakazam",     level = 6,    types = { "Psychic" },   moves = { "Dazzling Gleam", "Future Sight" },guids = { "9eade5", "8132c3" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "7117a7", "fa44b9", "74c0b4" } } }, model_GUID = "ef33f5", spawn_effect="Mega Evolve" },
  { name = "GMax Pikachu",      level = 1,    types = { "Electric" },  moves = { "Volt Crash", "Guard" },           guids = { "e932e9", "558a12" },         evoData = { { cost = 0, ball = PINK, gen = 1, cycle = true, guids = { "a17986", "e5c82a" } } }, model_GUID = "18bec8", custom_scale=1.1 },
  { name = "GMax Butterfree",   level = 3,    types = { "Bug", "Flying" }, moves = { "Befuddle", "Airstream" },     guids = { "614df5", "47362b" },         evoData = { { cost = 0, ball = GREEN, gen = 1, cycle = true, guids = { "3cb9ed", "25d791", "d36522" } } }, model_GUID = "f8fc86" },
  { name = "GMax Machamp",      level = 6,    types = { "Fighting" },  moves = { "Chi Strike", "Strike" },          guids = { "8d22d5", "1bc1d8" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "b5109b", "ff6a7f", "518720" } } }, model_GUID = "9636c9", custom_scale=0.65, offset={x=0, y=0, z=-0.03} },
  { name = "GMax Meowth",       level = 2,    types = { "Normal" },    moves = { "Gold Rush", "Darkness"},          guids = { "48e2c5" },                   evoData = { { cost = 0, ball = PINK, gen = 1, cycle = true, guids = { "312c52" } } }, model_GUID = "bc9ef1" },
  { name = "Mega Pidgeot",      level = 6,    types = { "Flying", "Normal" }, moves = { "Steel Wing", "Hurricane"}, guids = { "9844cb", "9be58b" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "1d36ba", "45e30a", "9f1834" } } }, model_GUID = "a6d82a", spawn_effect="Mega Evolve" },
  { name = "Mega Beedrill",     level = 4,    types = { "Bug", "Poison" }, moves = { "Poison Jab", "X-Scissor"},    guids = { "d4066d", "f8819a" },         evoData = { { cost = 0, ball = GREEN, gen = 1, cycle = true, guids = { "f8894f", "73c602", "61f84a" } } }, model_GUID = "ef20d1", spawn_effect="Mega Evolve" },
  { name = "GMax Gengar",       level = 5,    types = { "Ghost", "Poison" }, moves = { "Terror", "Ooze" },          guids = { "774eaa", "1b8bc7" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "fe0809", "7d5d39", "ad0856" } } }, model_GUID = "501df0", custom_scale=0.3 },
  { name = "Mega Slowbro",      level = 6,    types = { "Water", "Psychic" }, moves = { "Zen Headbutt", "Blizzard" }, guids = { "6060e8", "083e93" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "adce28", "4b8280" } } }, model_GUID = "53ee2c", spawn_effect="Mega Evolve" },
  { name = "GMax Kingler",      level = 4,    types = { "Water" },     moves = { "Foam Burst", "Guard" },           guids = { "1fa11f", "9edb28" },         evoData = { { cost = 0, ball = YELLOW, gen = 1, cycle = true, guids = { "f18035", "aa3008" } } }, model_GUID = "dc1beb", custom_scale=0.6 },
  { name = "Mega Pinsir",       level = 5,    types = { "Bug" },       moves = { "Struggle Bug", "Seismic Toss" },  guids = { "202a18" },                   evoData = { { cost = 0, ball = YELLOW, gen = 1, cycle = true, guids = { "141f37" } } }, model_GUID = "9a4265", spawn_effect="Mega Evolve" },
  { name = "Mega Kangaskhan",   level = 5,    types = { "Normal" },    moves = { "Hyper Beam", "Focus Blast" },     guids = { "0eb8c8" },                   evoData = { { cost = 0, ball = YELLOW, gen = 1, cycle = true, guids = { "cf2b95" } } }, model_GUID = "62422f", spawn_effect="Mega Evolve", custom_scale=0.9 },
  { name = "GMax Lapras",       level = 3,    types = { "Water", "Ice" }, moves = { "Resonance", "Strike" },        guids = { "f23aef" },                   evoData = { { cost = 0, ball = BLUE, gen = 1, cycle = true, guids = { "a465e9" } } }, model_GUID = "404c5e", offset={x=0, y=2, z=0}, custom_scale=0.35 },
  { name = "GMax Eevee",        level = 3,    types = { "Normal" },    moves = { "Darkness", "Cuddle" },            guids = { "6041c6" },                   evoData = { { cost = 0, ball = GREEN, gen = 1, cycle = true, guids = { "690870" } } }, model_GUID = "b49fe8", custom_scale=0.8 },
  { name = "Mega Aerodactyl",   level = 5,    types = { "Rock", "Flying" }, moves = { "Ancient Power", "Iron Head" }, guids = { "5ffdbe" },                   evoData = { { cost = 0, ball = YELLOW, gen = 1, cycle = true, guids = { "b69470" } } }, model_GUID = "411f15", spawn_effect="Mega Evolve" },
  { name = "GMax Snorlax",      level = 4,    types = { "Normal" },    moves = { "Replenish", "Strike" },           guids = { "318baa", "cc9678" },         evoData = { { cost = 0, ball = BLUE, gen = 1, cycle = true, guids = { "81f09a", "a017f9" } } }, model_GUID = "7bff14", offset={x=0, y=1.25, z=0}, custom_scale=0.6 },
  { name = "Mega Gyarados",     level = 4,    types = { "Water", "Dark" }, moves = { "Water Pulse", "Crunch" },   guids = { "f45bf6", "4d5c16" },         evoData = { { cost = 0, ball = GREEN, gen = 1, cycle = true, guids = { "d14d19", "985830" } } }, model_GUID = "601ecc", spawn_effect="Mega Evolve", custom_scale=0.75 },
  { name = "Mega Mewtwo X",     level = 8,    types = { "Psychic", "Fighting" }, moves = { "Aura Sphere", "Psystrike" }, guids = { "bf8dc5" },                   evoData = { { cost = 0, ball = LEGENDARY, gen = 1, cycle = true, guids = { "d78d06" } } }, model_GUID = "fb5dae", spawn_effect="Mega Evolve" },
  { name = "Mega Mewtwo Y",     level = 8,    types = { "Psychic" },   moves = { "Psycho Cut", "Me First" },        guids = { "a4bdc6" },                   evoData = { { cost = 0, ball = LEGENDARY, gen = 1, cycle = true, guids = { "d78d06" } } }, model_GUID = "18fa55", spawn_effect="Mega Evolve" },
  { name = "Mega Gengar",       level = 6,    types = { "Ghost", "Poison" }, moves = { "Shadow Ball", "Dream Eater" }, guids = { "5ef98c", "68c539" },         evoData = { { cost = 0, ball = RED, gen = 1, cycle = true, guids = { "fe0809", "7d5d39", "ad0856" } } }, model_GUID = "72228f", offset={x=0, y=1.0, z=0} },
} 

gen2PokemonData =
{
  -- Gen 2 152-200
  { name = "Chikorita",  level = 1, types = { "Grass" },             moves = { "Bullet Seed", "Growl" },          guids = { "cbe3c6" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "7ca3d7" } } }, model_GUID = "3d382c" },
  { name = "Bayleef",    level = 3, types = { "Grass" },             moves = { "Razor Leaf", "Reflect" },         guids = { "e64a46", "7ca3d7" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "595e82", "1d0c75" }, model_GUID = "574537" } }, model_GUID = "d25fd0" },
  { name = "Meganium",   level = 5, types = { "Grass" },             moves = { "Body Slam", "Solar Beam" },       guids = { "97ddd4", "595e82", "1d0c75" }, model_GUID = "574537", custom_scale=0.85 },
  { name = "Cyndaquil",  level = 1, types = { "Fire" },              moves = { "Smokescreen", "Ember" },          guids = { "8b91c9" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "4fe850" } } }, model_GUID = "75e0a9" },
  { name = "Quilava",    level = 3, types = { "Fire" },              moves = { "Flame Wheel", "Quick Attack" },   guids = { "ec0bac", "4fe850" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "444d49", "aef275" } }, { cost = 2, ball = RED, gen = 8, guids = { "e8349c", "c86580" } } }, model_GUID = "103870" },
  { name = "Typhlosion", level = 5, types = { "Fire" },              moves = { "Flamethrower", "Swift" },         guids = { "7ce124", "444d49", "aef275" }, evolveGen = 2, model_GUID = "ac8e3f" },
  { name = "Totodile",   level = 1, types = { "Water" },             moves = { "Growl", "Bite" },                 guids = { "9f245a" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "1915a6" } } }, model_GUID = "252f4b" },
  { name = "Croconaw",   level = 3, types = { "Water" },             moves = { "Water Gun", "Rage" },             guids = { "0f1ac8", "1915a6" },           evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "d723a2", "4c2d4e" } } }, model_GUID = "4015b5" },
  { name = "Feraligatr", level = 4, types = { "Water" },             moves = { "Waterfall", "Slash" },            guids = { "b382a4", "d723a2", "4c2d4e" }, model_GUID = "e93ead", spawn_effect="Status Attack", custom_scale=0.8, offset={x=0,y=0,z=-0.1} },
  { name = "Sentret",    level = 1, types = { "Normal" },            moves = { "Defense Curl", "Scratch" },       guids = { "dc2eea" },                     evoData = { { cost = 1, ball = GREEN, gen = 2, guids = { "db025b" } } }, model_GUID = "9fb1dd" },
  { name = "Furret",     level = 2, types = { "Normal" },            moves = { "Fury Swipes", "Slam" },           guids = { "bddff6", "db025b" }, model_GUID = "ce5492", spawn_effect="Physical Attack" },
  { name = "Hoothoot",   level = 1, types = { "Flying", "Normal" },  moves = { "Growl", "Peck" },                 guids = { "2cd22d" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "57ec65" } } }, model_GUID = "05738c" },
  { name = "Noctowl",    level = 3, types = { "Flying", "Normal" },  moves = { "Take Down", "Reflect" },          guids = { "89f5ff", "57ec65" }, model_GUID = "b09535" },
  { name = "Ledyba",     level = 1, types = { "Bug", "Flying" },     moves = { "Comet Punch", "Tackle" },         guids = { "83168b" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "0b2791" } } }, model_GUID = "3f5d68" },
  { name = "Ledian",     level = 3, types = { "Bug", "Flying" },     moves = { "Reflect", "Swift" },              guids = { "3d93ed", "0b2791" }, model_GUID = "fa91c6" },
  { name = "Spinarak",   level = 1, types = { "Bug", "Poison" },     moves = { "Poison Sting", "Constrict" },     guids = { "4a74ab" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "f8e383" } } }, model_GUID = "726bd6" },
  { name = "Ariados",    level = 3, types = { "Bug", "Poison" },     moves = { "Night Shade", "Leech Life" },     guids = { "6027c1", "f8e383" }, model_GUID = "3dd86d" },
  { name = "Crobat",     level = 5, types = { "Poison", "Flying" },  moves = { "Confuse Ray", "Wing Attack" },    guids = { "c8cb11", "79419e", "1d7367" }, model_GUID = "40d4cd" },
  { name = "Chinchou",   level = 3, types = { "Water", "Electric" }, moves = { "Thunder Wave", "Bubble" },        guids = { "5cd23a" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "3bb655" } } }, model_GUID = "bb0ea1", spawn_effect="Physical Attack" },
  { name = "Lanturn",    level = 4, types = { "Water", "Electric" }, moves = { "Hydro Pump", "Spark" },           guids = { "ca2f7d", "3bb655" }, model_GUID = "0a7fe3" },
  { name = "Pichu",      level = 0, types = { "Electric" },          moves = { "Tail Whip" },                     guids = { "7a0478" },                     evoData = { { cost = 1, ball = PINK, gen = 2, guids = { "e5c82a" } } }, model_GUID = "a3f444", spawn_effect="Physical Attack" },
  { name = "Cleffa",     level = 0, types = { "Fairy" },             moves = { "Sweet Kiss" },                    guids = { "5f28fe" },                     evoData = { { cost = 2, ball = PINK, gen = 2, guids = { "04404a" } } }, model_GUID = "2b3bf8" },
  { name = "Igglybuff",  level = 0, types = { "Normal", "Fairy" },   moves = { "Defense Curl" },                  guids = { "c288dc" },                     evoData = { { cost = 1, ball = PINK, gen = 2, guids = { "81f395" } } }, model_GUID = "366974" },
  { name = "Togepi",     level = 0, types = { "Fairy" },             moves = { "Charm" },                         guids = { "b85f3c" },                     evoData = { { cost = 2, ball = PINK, gen = 2, guids = { "abaff2" } } }, model_GUID = "6ba65d", spawn_effect="Physical Attack" },
  { name = "Togetic",    level = 2, types = { "Fairy", "Flying" },   moves = { "Safeguard", "Fairy Wind" },       guids = { "f8ed52", "abaff2" },           evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "020ecc", "3786d0" } } }, model_GUID = "06393b" },
  { name = "Natu",       level = 3, types = { "Psychic", "Flying" }, moves = { "Leer", "Peck" },                  guids = { "d743cd" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "a31065" } } }, model_GUID = "a511f7" },
  { name = "Xatu",       level = 4, types = { "Psychic", "Flying" }, moves = { "Future Sight", "Confuse Ray" },   guids = { "c056ff", "a31065" }, model_GUID = "a72b40" },
  { name = "Mareep",     level = 1, types = { "Electric" },          moves = { "Growl", "Tackle" },               guids = { "64aa14" },                     evoData = { { cost = 1, ball = GREEN, gen = 2, guids = { "6e25fb" } } }, model_GUID = "2d0cf1" },
  { name = "Flaaffy",    level = 2, types = { "Electric" },          moves = { "Thunder Shock", "Light Screen" }, guids = { "65023c", "6e25fb" },           evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "433542", "089edd" } } }, model_GUID = "332cde" },
  { name = "Ampharos",   level = 4, types = { "Electric" },          moves = { "Thunder Wave", "Thunder" },       guids = { "57b26e", "433542", "089edd" }, evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "f282f0", "16d003" } } }, model_GUID = "2fede5" },
  { name = "Bellossom",  level = 4, types = { "Grass" },             moves = { "Sleep Powder", "Solar Beam" },    guids = { "eda382", "14e4ad", "fd44a1" }, model_GUID = "29999f", spawn_effect="Physical Attack" },
  { name = "Marill",     level = 2, types = { "Water", "Fairy" },    moves = { "Defense Curl", "Water Gun" },     guids = { "d42c6f", "e76d9a" },           evoData = { { cost = 1, ball = BLUE, gen = 2, guids = { "47a0c6", "1ad3a2" } } }, model_GUID = "c97a48" },
  { name = "Azumarill",  level = 3, types = { "Water", "Fairy" },    moves = { "Waterfall", "Rollout" },          guids = { "972ac4", "47a0c6", "1ad3a2" }, model_GUID = "f7eb12" },
  { name = "Sudowoodo",  level = 3, types = { "Rock" },              moves = { "Rock Throw", "Mimic" },           guids = { "539dea", "eeca81" }, model_GUID = "b0f59f", spawn_effect="Physical Attack" },
  { name = "Politoed",   level = 6, types = { "Water" },             moves = { "Hydro Pump", "Swagger" },         guids = { "67f2a8", "9a1b0b", "b21ff9" }, model_GUID = "6bf45b" },
  { name = "Hoppip",     level = 1, types = { "Grass", "Flying" },   moves = { "Tail Whip", "Tackle" },           guids = { "485f54" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "996e19" } } }, model_GUID = "76212b" },
  { name = "Skiploom",   level = 3, types = { "Grass", "Flying" },   moves = { "Poison Powder", "Stun Spore" },   guids = { "e1c8ca", "996e19" },           evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "18d441", "66e564" } } }, model_GUID = "4e9313", spawn_effect="Physical Attack" },
  { name = "Jumpluff",   level = 4, types = { "Grass", "Flying" },   moves = { "Sleep Powder", "Mega Drain" },    guids = { "766518", "18d441", "66e564" }, model_GUID = "08d23f", spawn_effect="Physical Attack" },
  { name = "Aipom",      level = 2, types = { "Normal" },            moves = { "Sand Attack", "Scratch" },        guids = { "7da245" },                     evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "06f1a9" } } }, model_GUID = "89ec0d" },
  { name = "Sunkern",    level = 2, types = { "Grass" },             moves = { "Absorb", "Pound" },               guids = { "2a0f37" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "da3544" } } }, model_GUID = "21d5b5" },
  { name = "Sunflora",   level = 4, types = { "Grass" },             moves = { "Petal Dance", "Razor Leaf" },     guids = { "f43c37", "da3544" }, model_GUID = "912dc4" },
  { name = "Yanma",      level = 2, types = { "Bug", "Flying" },     moves = { "Quick Attack", "Hypnosis" },      guids = { "df3c90" },                     evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "e093cb" } } }, model_GUID = "4b8bdf", spawn_effect="Physical Attack" },
  { name = "Wooper",     level = 1, types = { "Water", "Ground" },   moves = { "Water Gun", "Tail Whip" },        guids = { "3403ab" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "5281dd" } } }, model_GUID = "5a0e02" },
  { name = "Quagsire",   level = 3, types = { "Water", "Ground" },   moves = { "Earthquake", "Slam" },            guids = { "1813f8", "5281dd" }, model_GUID = "59c07d", custom_scale=0.9 },
  { name = "Espeon",     level = 5, types = { "Psychic" },           moves = { "Psybeam", "Swift" },              guids = { "6fdb1c", "5daac2" }, model_GUID = "c8a52c" },
  { name = "Umbreon",    level = 5, types = { "Dark" },              moves = { "Confuse Ray", "Feint Attack" },   guids = { "a074fb", "63caca" }, model_GUID = "33d105" },
  { name = "Murkrow",    level = 3, types = { "Dark", "Flying" },    moves = { "Feint Attack", "Peck" },          guids = { "d39237" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "4f1558" } } }, model_GUID = "77f5c2" },
  { name = "Slowking",   level = 5, types = { "Water", "Psychic" },  moves = { "Headbutt", "Psychic" },           guids = { "f0d007", "83160e" }, model_GUID = "bcb9f2", custom_scale=0.85 },
  { name = "Misdreavus", level = 4, types = { "Ghost" },             moves = { "Confuse Ray", "Psywave" },        guids = { "86b019" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "496256" } } }, model_GUID = "01ca5e", spawn_effect="Physical Attack" },
  -- Gen 2 201-251
  { name = "Unown",      level = 1, types = { "Psychic" },           moves = { "Hidden Power" },                  guids = { "0dc6f9" }, model_GUID = "c85a56" ,spawn_effect="Hidden Power" },
  { name = "Wobbuffet",  level = 2, types = { "Psychic" },           moves = { "Safeguard", "Counter" },          guids = { "5dd7a5", "0bbbae" }, model_GUID = "8b6825" },
  { name = "Girafarig",  level = 2, types = { "Normal", "Psychic" }, moves = { "Confusion", "Tackle" },           guids = { "1fc55d" },                     evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "f18198" } } }, model_GUID = "3310c2" },
  { name = "Pineco",     level = 2, types = { "Bug" },               moves = { "Protect", "Tackle" },             guids = { "0d263c" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "7b0bfe" } } }, model_GUID = "75f82e", spawn_effect="Physical Attack" },
  { name = "Forretress", level = 4, types = { "Bug", "Steel" },      moves = { "Double-Edge", "Spikes" },         guids = { "669297", "7b0bfe" }, model_GUID = "6fe49a" },
  { name = "Dunsparce",  level = 1, types = { "Normal" },            moves = { "Rage", "Glare" },                 guids = { "e86d8a" },                     evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "9c40ab" } } }, model_GUID = "13a6d1", custom_scale=0.85, offset={x=0, y=0, z=-0.05} },
  { name = "Gligar",     level = 4, types = { "Ground", "Flying" },  moves = { "Feint Attack", "Quick Attack" },  guids = { "f15436" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "96a4fa" } } }, model_GUID = "9c099b" },
  { name = "Steelix",    level = 4, types = { "Steel", "Ground" },   moves = { "Iron Tail", "Crunch" },           guids = { "93482a", "9248b4" },           evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "8b5001", "86038a" } } }, model_GUID = "a4d334", custom_scale=0.7 },
  { name = "Snubbull",   level = 2, types = { "Fairy" },             moves = { "Charm", "Rage" },                 guids = { "d85741" },                     evoData = { { cost = 1, ball = BLUE, gen = 2, guids = { "5351ec" } } }, model_GUID = "9de6f6" },
  { name = "Granbull",   level = 3, types = { "Fairy" },             moves = { "Bite", "Lick" },                  guids = { "13fcb1", "5351ec" }, model_GUID = "bf082d" },
  { name = "Qwilfish",   level = 4, types = { "Water", "Poison" },   moves = { "Poison Sting", "Water Gun" },     guids = { "d28384" }, model_GUID = "4dc2b1" },
  { name = "Scizor",     level = 5, types = { "Steel", "Bug" },      moves = { "Metal Claw", "Wing Attack" },     guids = { "7e05b1", "22e6a3" },           evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "ae958f", "1bb3d8" } } }, model_GUID = "334cc6", spawn_effect="Status Attack" },
  { name = "Shuckle",    level = 2, types = { "Bug", "Rock" },       moves = { "Withdraw", "Wrap" },              guids = { "3d91d1" }, model_GUID = "53a551", spawn_effect="Physical Attack" },
  { name = "Heracross",  level = 4, types = { "Bug", "Fighting" },   moves = { "Horn Attack", "Counter" },        guids = { "6f8ffe" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "926476" } } }, model_GUID = "11f35c" },
  { name = "Sneasel",    level = 3, types = { "Dark", "Ice" },       moves = { "Feint Attack", "Quick Attack" },  guids = { "c13dc3" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "9b517e" } } }, model_GUID = "b0f068" },
  { name = "Teddiursa",  level = 3, types = { "Normal" },            moves = { "Fury Swipes", "Lick" },           guids = { "e9f2b7" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "415c99" } } }, model_GUID = "729770" },
  { name = "Ursaring",   level = 4, types = { "Normal" },            moves = { "Feint Attack", "Thrash" },        guids = { "e48590", "415c99" },           evoData = { { cost = 2, ball = RED, gen = 8, guids = { "7684c6", "2c6eaa" } }, { cost = 2, ball = RED, gen = 8, guids = { "0af179", "d9574b" } } }, model_GUID = "aa222b", custom_scale=0.9, offset={x=0, y=0, z=-0.06} },
  { name = "Slugma",     level = 4, types = { "Fire" },              moves = { "Ember", "Smog" },                 guids = { "9c822d" },                     evoData = { { cost = 1, ball = RED, gen = 2, guids = { "b1cc91" } } }, model_GUID = "964d48" },
  { name = "Magcargo",   level = 5, types = { "Fire", "Rock" },      moves = { "Flamethrower", "Rock Slide" },    guids = { "3cadf7", "b1cc91" }, model_GUID = "bc7776" },
  { name = "Swinub",     level = 3, types = { "Ice", "Ground" },     moves = { "Powder Snow", "Tackle" },         guids = { "cbd281" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "e3f6d9" } } }, model_GUID = "a9fba7", spawn_effect="Physical Attack" },
  { name = "Piloswine",  level = 5, types = { "Ice", "Ground" },     moves = { "Take Down", "Blizzard" },         guids = { "79cc3d", "e3f6d9" },           evoData = { { cost = 1, ball = RED, gen = 4, guids = { "bac5e2", "3e9a5e" } } }, model_GUID = "3aabb9" },
  { name = "Corsola",    level = 3, types = { "Water", "Rock" },     moves = { "Ancient Power", "Bubble Beam" },  guids = { "180047" }, model_GUID = "cf84d4", spawn_effect="Physical Attack" },
  { name = "Remoraid",   level = 3, types = { "Water" },             moves = { "Psybeam", "Water Gun" },          guids = { "c6633d" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "93e4e2" } } }, model_GUID = "b820cf" },
  { name = "Octillery",  level = 4, types = { "Water" },             moves = { "Octazooka", "Ice Beam" },         guids = { "ae520a", "93e4e2" }, model_GUID = "4c27f5" },
  { name = "Delibird",   level = 3, types = { "Ice", "Flying" },     moves = { "Present" },                       guids = { "6588c5" }, model_GUID = "a62b3b", spawn_effect="Physical Attack" },
  { name = "Mantine",    level = 3, types = { "Water", "Flying" },   moves = { "Bubble Beam", "Wing Attack" },    guids = { "1142f0", "6fd093" }, model_GUID = "5f4b59", spawn_effect="Physical Attack" },
  { name = "Skarmory",   level = 4, types = { "Steel", "Flying" },   moves = { "Steel Wing", "Swift" },           guids = { "cfa0f1" }, model_GUID = "790101", spawn_effect="Physical Attack" },
  { name = "Houndour",   level = 2, types = { "Dark", "Fire" },      moves = { "Ember", "Bite" },                 guids = { "0e8e22" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "cf82ee" } } }, model_GUID = "b635fd" },
  { name = "Houndoom",   level = 4, types = { "Dark", "Fire" },      moves = { "Flamethrower", "Crunch" },        guids = { "5ef848", "cf82ee" },           evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "b27904", "41f460" } } }, model_GUID = "875a93" },
  { name = "Kingdra",    level = 6, types = { "Dragon", "Water" },   moves = { "Hydro Pump", "Twister" },         guids = { "bc99c5", "0b677f", "3b17f1" }, model_GUID = "fd04bb" },
  { name = "Phanpy",     level = 3, types = { "Ground" },            moves = { "Take Down", "Rollout" },          guids = { "7c1ad0" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "980292" } } }, model_GUID = "1f0941" },
  { name = "Donphan",    level = 4, types = { "Ground" },            moves = { "Horn Attack", "Earthquake" },     guids = { "dcdc1d", "980292" }, model_GUID = "7fa132", spawn_effect="Physical Attack", custom_scale=0.8, offset={x=0, y=0, z=-0.03} },
  { name = "Porygon2",   level = 4, types = { "Normal" },            moves = { "Tri Attack", "Conversion2" },     guids = { "b7c99b", "145660" },           evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "89624f", "ccdbee" } } }, model_GUID = "26714f" },
  { name = "Stantler",   level = 2, types = { "Normal" },            moves = { "Hypnosis", "Tackle" },            guids = { "3ba296" },                     evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "163267" } } }, model_GUID = "fc0116" },
  { name = "Smeargle",   level = 3, types = { "Normal" },            moves = { "Sketch", "Sketch" },              guids = { "5496a6" }, model_GUID = "5efe03" },
  { name = "Tyrogue",    level = 1, types = { "Fighting" },          moves = { "Tackle" },                        guids = { "b896b9" },                     evoData = { { cost = 3, ball = BLUE, gen = 1, guids = { "d55591" } }, 
                                                                                                                                                                        { cost = 3, ball = BLUE, gen = 1, guids = { "10087d" } }, 
                                                                                                                                                                        { cost = 3, ball = BLUE, gen = 2, guids = { "b53d14" } } }, model_GUID = "9f3f98" },
  { name = "Hitmontop",  level = 4, types = { "Fighting" },          moves = { "Triple Kick", "Quick Attack" },   guids = { "1aeec6", "b53d14" }, model_GUID = "f2168b", spawn_effect="Physical Attack" },
  { name = "Smoochum",   level = 1, types = { "Ice", "Psychic" },    moves = { "Pound", "Lick" },                 guids = { "961d64" },                     evoData = { { cost = 3, ball = YELLOW, gen = 2, guids = { "4bc360" } } }, model_GUID = "bb561b" },
  { name = "Elekid",     level = 1, types = { "Electric" },          moves = { "Quick Attack", "Leer" },          guids = { "b6056a" },                     evoData = { { cost = 3, ball = YELLOW, gen = 2, guids = { "749909" } } }, model_GUID = "9b06da" },
  { name = "Magby",      level = 1, types = { "Fire" },              moves = { "Smokescreen", "Smog" },           guids = { "a47ff8" },                     evoData = { { cost = 3, ball = YELLOW, gen = 2, guids = { "a0aed6" } } }, model_GUID = "1649bb" },
  { name = "Miltank",    level = 2, types = { "Normal" },            moves = { "Heal Bell", "Tackle" },           guids = { "8d2189" }, model_GUID = "cd7e0e", spawn_effect="Physical Attack" },
  { name = "Blissey",    level = 5, types = { "Normal" },            moves = { "Light Screen", "Egg Bomb" },       guids = { "27e857", "5b9024", "774d72" }, model_GUID = "7c05e0", spawn_effect="Status Attack" },
  { name = "Raikou",     level = 7, types = { "Electric" },          moves = { "Crunch", "Spark" },               guids = { "07ea8b" }, model_GUID = "e1797a", custom_scale=0.75 },
  { name = "Entei",      level = 7, types = { "Fire" },              moves = { "Fire Blast", "Bite" },            guids = { "dbfb71" }, model_GUID = "690ea9", custom_scale=0.65 },
  { name = "Suicune",    level = 7, types = { "Water" },             moves = { "Aurora Beam", "Hydro Pump" },     guids = { "ab44f1" }, model_GUID = "7829ea", custom_scale=0.75 },
  { name = "Larvitar",   level = 2, types = { "Rock", "Ground" },    moves = { "Bite", "Leer" },                  guids = { "625880" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "aa8662" } } }, model_GUID = "4f2d64" },
  { name = "Pupitar",    level = 4, types = { "Rock", "Ground" },    moves = { "Earthquake", "Screech" },         guids = { "159d4d", "aa8662" },           evoData = { { cost = 3, ball = RED, gen = 2, guids = { "7195d5", "5764be" } } }, model_GUID = "772458" },
  { name = "Tyranitar",  level = 7, types = { "Rock", "Dark" },      moves = { "Rock Slide", "Crunch" },          guids = { "d2d545", "7195d5", "5764be" }, evoData = { { cost = "Mega", ball = MEGA, gen = 2, cycle = true, guids = { "bb5cd0", "0cd52e" } } }, model_GUID = "46679d" },
  { name = "Lugia",      level = 7, types = { "Psychic", "Flying" }, moves = { "Future Sight", "Aeroblast" },     guids = { "5e4745" }, model_GUID = "a1d05e" },
  { name = "Ho-oh",      level = 7, types = { "Fire", "Flying" },    moves = { "Ancient Power", "Sacred Fire" },  guids = { "22569b" }, model_GUID = "7be9e1" },
  { name = "Celebi",     level = 7, types = { "Psychic", "Grass" },  moves = { "Solar Beam", "Psychic" },         guids = { "4d10a7" },  model_GUID = "981fe7" },

  -- Mega evolutions.
  { name = "Mega Ampharos",     level = 5,    types = { "Electric", "Dragon" }, moves = { "Charge Beam", "Dragon Pulse" }, guids = { "f282f0", "16d003" },            evoData = { { cost = 0, ball = YELLOW, gen = 2, cycle = true, guids = { "57b26e", "433542", "089edd" } } }, model_GUID = "333b22", spawn_effect="Mega Evolve" },
  { name = "Mega Red Gyarados", level = 6,    types = { "Water", "Flying" }, moves = { "Water Pulse", "Crunch" },      guids = { "bc99f5" },                      evoData = { { cost = 0, ball = YELLOW, gen = 2, cycle = true, guids = { "390ee2" } } }, model_GUID = "55036d" },     -- Technically gen II only.
  { name = "Mega Steelix",      level = 5,    types = { "Steel", "Ground" }, moves = { "Earthquake", "Rock Slide" },   guids = { "8b5001", "86038a" },            evoData = { { cost = 0, ball = BLUE, gen = 2, cycle = true, guids = { "93482a", "9248b4" } } }, model_GUID = "f5a482", spawn_effect="Physical Attack", custom_scale=0.7, offset={x=0, y=0, z=0.5} },
  { name = "Mega Scizor",       level = 6,    types = { "Bug", "Steel" },    moves = { "Night Slash", "X-Scissor" },   guids = { "ae958f", "1bb3d8" },            evoData = { { cost = 0, ball = RED, gen = 2, cycle = true, guids = { "7e05b1", "22e6a3" } } }, model_GUID = "4175df", spawn_effect="Mega Evolve" },
  { name = "Mega Heracross",    level = 5,    types = { "Bug", "Fighting" }, moves = { "Close Combat", "Megahorn" },   guids = { "926476" },                      evoData = { { cost = 0, ball = BLUE, gen = 2, cycle = true, guids = { "6f8ffe" } } }, model_GUID = "cbdd77", spawn_effect="Mega Evolve" },
  { name = "Mega Houndoom",     level = 5,    types = { "Dark", "Fire" },    moves = { "Dark Pulse", "Inferno" },      guids = { "b27904", "41f460" },            evoData = { { cost = 0, ball = YELLOW, gen = 2, cycle = true, guids = { "5ef848", "cf82ee" } } }, model_GUID = "acbb9d", spawn_effect="Mega Evolve", custom_scale=0.9 },
  { name = "Mega Tyranitar",    level = 8,    types = { "Rock", "Dark" },    moves = { "Stone Edge", "Earthquake" },   guids = { "bb5cd0", "0cd52e" },            evoData = { { cost = 0, ball = RED, gen = 2, cycle = true, guids = { "d2d545", "7195d5", "5764be" } } }, model_GUID = "0bd382", spawn_effect="Mega Evolve" },
}

gen3PokemonData =
{
  -- Gen 3 252-300
  { name = "Treecko",    level = 1, types = { "Grass" },    moves = { "Quick Attack", "Absorb" },             guids = { "cd2a1e" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "71f6d0" } } }, model_GUID = "0fb049" },
  { name = "Grovyle",    level = 3, types = { "Grass" },    moves = { "Leaf Blade", "Slam" },                 guids = { "fc07df", "71f6d0" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "6acdb2", "8d967c" } } }, model_GUID = "7c33a8" },
  { name = "Sceptile",   level = 5, types = { "Grass" },    moves = { "Solar Beam", "Iron Tail" },            guids = { "01d5b8", "6acdb2", "8d967c" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "3921c1", "3563ba" } } }, model_GUID = "cb8b63", spawn_effect="Status Attack", custom_scale=0.9 },
  { name = "Torchic",    level = 1, types = { "Fire" },     moves = { "Ember", "Growl" },                     guids = { "dfac41" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "0d3fc1" } } }, model_GUID = "215780", spawn_effect="Physical Attack" },
  { name = "Combusken",  level = 3, types = { "Fire", "Fighting" }, moves = { "Double Kick", "Blaze Kick" },  guids = { "af5888", "0d3fc1" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "6b6eaa", "e4fcc7" } } }, model_GUID = "87fbb3", spawn_effect="Physical Attack" },
  { name = "Blaziken",   level = 5, types = { "Fire", "Fighting" },     moves = { "Sky Uppercut", "Overheat" }, guids = { "b3e3d0", "6b6eaa", "e4fcc7" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "7b81ef", "641ef5" } } }, model_GUID = "868292", spawn_effect="Status Attack" },
  { name = "Mudkip",     level = 1, types = { "Water" },    moves = { "Mud-Slap", "Water Gun" },              guids = { "18d937" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "80e724" } } }, model_GUID = "7bb712" },
  { name = "Marshtomp",  level = 3, types = { "Water", "Ground" }, moves = { "Muddy Water", "Take Down" },    guids = { "9d8a4b", "80e724" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "0f2fe4", "93c652" } } }, model_GUID = "e7b84a" },
  { name = "Swampert",   level = 5, types = { "Water", "Ground" }, moves = { "Hydro Pump", "Earthquake" },    guids = { "46c207", "0f2fe4", "93c652" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "f5dc2f", "045bc8" } } }, model_GUID = "215a22", spawn_effect="Status Attack", custom_scale=0.7, offset={x=0, y=0, z=-0.05} },
  { name = "Poochyena",  level = 1, types = { "Dark" },     moves = { "Howl", "Tackle" },                     guids = { "484c8e" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "ad5677" } } }, model_GUID = "0266ca" },
  { name = "Mightyena",  level = 3, types = { "Dark" },     moves = { "Take Down", "Crunch" },                guids = { "d14a45", "ad5677" }, model_GUID = "4e25db" },
  { name = "Zigzagoon",  level = 1, types = { "Normal" },   moves = { "Sand Attack", "Tackle" },              guids = { "8effad" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "fea2c0" } } }, model_GUID = "fa2eb0" },
  { name = "Linoone",    level = 3, types = { "Normal" },   moves = { "Fury Swipes", "Slash" },               guids = { "49547c", "fea2c0" }, model_GUID = "1fbab6" },
  { name = "Wurmple",    level = 1, types = { "Bug" },      moves = { "String Shot" },                        guids = { "3b1e3a" },                     evoData = { { cost = 1, ball = PINK, gen = 3, guids = { "3756cf" } }, { cost = 1, ball = PINK, gen = 3, guids = { "b2567d" } } }, model_GUID = "564350" },
  { name = "Silcoon",    level = 2, types = { "Bug" },      moves = { "Harden", "Tackle" },                   guids = { "814073", "3756cf" },           evoData = { { cost = 1, ball = GREEN, gen = 3, guids = { "64e59c", "4a79ea" } } }, model_GUID = "7b3acf", spawn_effect="Physical Attack" },
  { name = "Beautifly",  level = 3, types = { "Bug", "Flying" }, moves = { "Silver Wind", "Mega Drain" },     guids = { "f16171", "64e59c", "4a79ea" }, model_GUID = "96fd4b" },
  { name = "Cascoon",    level = 2, types = { "Bug" },      moves = { "Poison Sting", "Harden" },             guids = { "2e69ca", "b2567d" },           evoData = { { cost = 1, ball = GREEN, gen = 3, guids = { "bf6b7d", "2ee4fc" } } }, model_GUID = "8e5dc9", spawn_effect="Physical Attack" },
  { name = "Dustox",     level = 3, types = { "Bug", "Poison" }, moves = { "Silver Wind", "Light Screen" },   guids = { "f63e23", "bf6b7d", "2ee4fc" }, model_GUID = "5e829e" },
  { name = "Lotad",      level = 1, types = { "Water", "Grass" }, moves = { "Astonish", "Absorb" },           guids = { "497b82" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "92c70d" } } }, model_GUID = "9bf1cf" },
  { name = "Lombre",     level = 3, types = { "Water", "Grass" }, moves = { "Fury Swipes", "Water Gun" },     guids = { "3081f1", "92c70d" },           evoData = { { cost = 1, ball = BLUE, gen = 3, guids = { "043d72", "6c7ae8" } } }, model_GUID = "f664d4" },
  { name = "Ludicolo",   level = 4, types = { "Water", "Grass" }, moves = { "Nature Power", "Razor Leaf" },   guids = { "8f090f", "043d72", "6c7ae8" }, model_GUID = "bb247f" },
  { name = "Seedot",     level = 1, types = { "Grass" },    moves = { "Quick Attack", "Growth" },             guids = { "b3dcac" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "9e2cc8" } } }, model_GUID = "a55367" },
  { name = "Nuzleaf",    level = 3, types = { "Grass", "Dark" }, moves = { "Extrasensory", "Fake Out" },      guids = { "489f1b", "9e2cc8" },           evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "f02406", "288090" } } }, model_GUID = "807cc5", spawn_effect="Physical Attack" },
  { name = "Shiftry",    level = 5, types = { "Grass", "Dark" }, moves = { "Nature Power", "Feint Attack" },  guids = { "eb4137", "f02406", "288090" }, model_GUID = "a97e03" },
  -- Gen 3 276-300
  { name = "Taillow",    level = 2, types = { "Flying", "Normal" }, moves = { "Growl", "Peck" },              guids = { "93cbde" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "3e7919" } } }, model_GUID = "f9efda" },
  { name = "Swellow",    level = 4, types = { "Flying", "Normal" }, moves = { "Quick Attack", "Aerial Ace" }, guids = { "fd1fd2", "3e7919" }, model_GUID = "430ab8", spawn_effect="Physical Attack" },
  { name = "Wingull",    level = 1, types = { "Water", "Flying" },  moves = { "Water Gun", "Mist" },          guids = { "018621" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "b53aec" } } }, model_GUID = "2ba1b1" },
  { name = "Pelipper",   level = 3, types = { "Water", "Flying" },  moves = { "Water Pulse", "Wing Attack" }, guids = { "3fd851", "b53aec" }, model_GUID = "dff0ed" },
  { name = "Ralts",      level = 1, types = { "Psychic", "Fairy" }, moves = { "Confusion" },                  guids = { "92ca7a" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "61a3fe" } } }, model_GUID = "3240f8" },
  { name = "Kirlia",     level = 3, types = { "Psychic", "Fairy" }, moves = { "Will-O-Wisp", "Psychic" },     guids = { "260dd4", "61a3fe" },           evoData = { { cost = 2, ball = RED, gen = 4, guids = { "491632", "2956c7" } }, { cost = 2, ball = RED, gen = 3, guids = { "a58279", "9ef381" } } }, model_GUID = "9624b5", spawn_effect="Physical Attack" },
  { name = "Gardevoir",  level = 5, types = { "Psychic", "Fairy" }, moves = { "Shock Wave", "Future Sight" }, guids = { "fe8f9a", "a58279", "9ef381" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "13d6a2", "7f7d21" } } }, model_GUID = "8c5fec" },
  { name = "Surskit",    level = 1, types = { "Bug", "Water" },     moves = { "Bubble" },                     guids = { "f47f95" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "899d71" } } }, model_GUID = "15b02f" },
  { name = "Masquerain", level = 3, types = { "Bug", "Flying" },    moves = { "Silver Wind", "Bubble Beam" }, guids = { "6f6a4b", "899d71" }, model_GUID = "f71175" },
  { name = "Shroomish",  level = 1, types = { "Grass" },    moves = { "Stun Spore", "Tackle" },               guids = { "afce65" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "b2b675" } } }, model_GUID = "f9ef26" },
  { name = "Breloom",    level = 3, types = { "Grass", "Fighting" },    moves = { "Dynamic Punch", "Mega Drain" }, guids = { "54f6b2", "b2b675" }, model_GUID = "d12809" },
  { name = "Slakoth",    level = 2, types = { "Normal" },   moves = { "Scratch" },                            guids = { "0e7e5b" },                     evoData = { { cost = 1, ball = BLUE, gen = 3, guids = { "bb497c" } } }, model_GUID = "33417e" },
  { name = "Vigoroth",   level = 3, types = { "Normal" },   moves = { "Counter", "Slash" },                   guids = { "167d17", "bb497c" },           evoData = { { cost = 3, ball = RED, gen = 3, guids = { "9e0b51", "eed73b" } } }, model_GUID = "4d9117" },
  { name = "Slaking",    level = 6, types = { "Normal" },   moves = { "Feint Attack", "Covet" },              guids = { "beea0e", "9e0b51", "eed73b" }, model_GUID = "66bcca" },
  { name = "Nincada",    level = 2, types = { "Bug", "Ground" }, moves = { "Fury Swipes", "Mud-Slap" },       guids = { "6a52b9" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "2f18cb" } }, { cost = 2, ball = BLUE, gen = 3, guids = { "b9a6c3" } } }, model_GUID = "17a5c0" },
  { name = "Ninjask",    level = 4, types = { "Bug", "Flying" }, moves = { "Swords Dance", "Leech Life" },    guids = { "5fca25", "2f18cb" }, model_GUID = "ae5abc" },
  { name = "Shedinja",   level = 4, types = { "Bug", "Ghost" },  moves = { "Shadow Ball", "Protect" },        guids = { "1a8813", "b9a6c3" }, model_GUID = "ceaedf" },
  { name = "Whismur",    level = 2, types = { "Normal" },   moves = { "Astonish", "Pound" },                  guids = { "86e898" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "9b89d3" } } }, model_GUID = "c4ec15" },
  { name = "Loudred",    level = 4, types = { "Normal" },   moves = { "Hyper Voice", "Screech" },             guids = { "c874a8", "9b89d3" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "f2324f", "5b1de6" } } }, model_GUID = "d404f1" },
  { name = "Exploud",    level = 6, types = { "Normal" },   moves = { "Extrasensory", "Echoed Voice" },       guids = { "bebdb9", "f2324f", "5b1de6" }, model_GUID = "1567e6" },
  { name = "Makuhita",   level = 2, types = { "Fighting" }, moves = { "Arm Thrust", "Tackle" },               guids = { "52f60d" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "9266af" } } }, model_GUID = "b12e69" },
  { name = "Hariyama",   level = 4, types = { "Fighting" }, moves = { "Smelling Salts", "Vital Throw" },      guids = { "840d39", "9266af" }, model_GUID = "25ea1f", custom_scale=0.4 },
  { name = "Azurill",    level = 0, types = { "Normal", "Fairy" }, moves = { "Bubble" },                      guids = { "4132b8" },                     evoData = { { cost = 2, ball = GREEN, gen = 2, guids = { "e76d9a" } } }, model_GUID = "3c11df" },
  { name = "Nosepass",   level = 3, types = { "Rock" },     moves = { "Thunder Wave", "Rock Throw" },         guids = { "d3a1d5" },                     evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "261bac" } } }, model_GUID = "ef03a1" },
  { name = "Skitty",     level = 2, types = { "Normal" },   moves = { "Double Slap", "Attract" },             guids = { "2ded89" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "9cca58" } } }, model_GUID = "701147" },
  -- Gen 3 301-325
  { name = "Delcatty",   level = 4, types = { "Normal" },   moves = { "Double-Edge", "Feint Attack" },        guids = { "5498b5", "9cca58" }, model_GUID = "aa3ec0" },
  { name = "Sableye",    level = 4, types = { "Dark", "Ghost" }, moves = { "Astonish", "Knock Off" },         guids = { "d0ddb7" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "ad6245" } } }, model_GUID = "184d06", spawn_effect="Physical Attack" },
  { name = "Mawile",     level = 4, types = { "Steel", "Fairy" }, moves = { "Iron Defense", "Crunch" },       guids = { "825f3c" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "901321" } } }, model_GUID = "71f869", offset={x=0, y=0, z=-0.05} },
  { name = "Aron",       level = 2, types = { "Steel", "Rock" }, moves = { "Headbutt", "Mud-Slap" },          guids = { "2bdf79" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "1ad335" } } }, model_GUID = "156c85", spawn_effect="Physical Attack" },
  { name = "Lairon",     level = 4, types = { "Steel", "Rock" }, moves = { "Metal Claw", "Rock Throw" },      guids = { "fc819f", "1ad335" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "19c95d", "037e57" } } }, model_GUID = "d48d21", custom_scale=0.75 },
  { name = "Aggron",     level = 6, types = { "Steel", "Rock" }, moves = { "Earthquake", "Iron Tail" },       guids = { "a5daad", "19c95d", "037e57" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "8f5016", "b94e60" } } }, model_GUID = "ce1109", custom_scale=0.8 },
  { name = "Meditite",   level = 2, types = { "Fighting", "Psychic" }, moves = { "Hidden Power", "Detect" },  guids = { "8cae23" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "925a8f" } } }, model_GUID = "da149f" },
  { name = "Medicham",   level = 4, types = { "Fighting" }, moves = { "Confusion", "Brick Break" },           guids = { "1b2da9", "925a8f" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "19680e", "97834f" } } }, model_GUID = "1e9b7e" },
  { name = "Electrike",  level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Quick Attack" },       guids = { "e37270" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "24b582" } } }, model_GUID = "b0e819" },
  { name = "Manectric",  level = 4, types = { "Electric" }, moves = { "Thunder", "Bite" },                    guids = { "66eddf", "24b582" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "a96290", "70bf71" } } }, model_GUID = "27ca2d", custom_scale=0.9, offset={x=0, y=0, z=-0.03} },
  { name = "Plusle",     level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Spark" },              guids = { "78d266" }, model_GUID = "1ff9eb" },
  { name = "Minun",      level = 2, types = { "Electric" }, moves = { "Quick Attack", "Spark" },              guids = { "37efd6" }, model_GUID = "401c47" },
  { name = "Volbeat",    level = 2, types = { "Bug" },      moves = { "Double-Edge", "Signal Beam" },         guids = { "b1d72d" }, model_GUID = "65b9bd" },
  { name = "Illumise",   level = 2, types = { "Bug" },      moves = { "Silver Wind", "Covet" },               guids = { "d3520a" }, model_GUID = "0f073f" },
  { name = "Roselia",    level = 3, types = { "Grass", "Poison" }, moves = { "Magical Leaf", "Body Slam" },   guids = { "6c4ab2", "7e165f" },           evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "4aa1de", "46f8dc" } } }, model_GUID = "6b1bd7" },
  { name = "Gulpin",     level = 2, types = { "Poison" },   moves = { "Poison Gas", "Pound" },                guids = { "c08fc1" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "aac35d" } } }, model_GUID = "933c2f" },
  { name = "Swalot",     level = 4, types = { "Poison" },   moves = { "Sludge Bomb", "Body Slam" },           guids = { "2a3068", "aac35d" }, model_GUID = "f5cf00", custom_scale=0.6, offset={x=0, y=0, z=-0.1} },
  { name = "Carvanha",   level = 2, types = { "Water", "Dark" }, moves = { "Rage", "Bite" },                  guids = { "1f850b" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "7d206a" } } }, model_GUID = "1dd6cf", spawn_effect="Physical Attack" },
  { name = "Sharpedo",   level = 4, types = { "Water", "Dark" }, moves = { "Waterfall", "Crunch" },           guids = { "852350", "7d206a" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "3127db", "b7e979" } } }, model_GUID = "129bd7", spawn_effect="Physical Attack" },
  { name = "Wailmer",    level = 3, types = { "Water" },    moves = { "Whirlpool", "Rollout" },               guids = { "bf7581" },                     evoData = { { cost = 2, ball = RED, gen = 3, guids = { "58fe14" } } }, model_GUID = "b372d4", custom_scale=0.7 },
  { name = "Wailord",    level = 5, types = { "Water" },    moves = { "Body Slam", "Water Spout" },           guids = { "b1528a", "58fe14" }, model_GUID = "8bc97a", custom_scale=0.3, offset={x=0, y=1.25, z=0} },
  { name = "Numel",      level = 2, types = { "Fire", "Ground" }, moves = { "Take Down", "Ember" },           guids = { "dda685" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "4bfb16" } } }, model_GUID = "d8750f", spawn_effect="Physical Attack" },
  { name = "Camerupt",   level = 4, types = { "Fire", "Ground" }, moves = { "Eruption", "Fissure" },          guids = { "2bbebf", "4bfb16" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "bc021e", "01cfea" } } }, model_GUID = "f266b1", spawn_effect="Physical Attack", custom_scale=0.6, offset={x=0, y=0, z=-0.1} },
  { name = "Torkoal",    level = 3, types = { "Fire" },     moves = { "Flamethrower", "Iron Defense" },       guids = { "61c078" }, model_GUID = "ad6f78", spawn_effect="Physical Attack" },
  { name = "Spoink",     level = 2, types = { "Psychic" },  moves = { "Confuse Ray", "Magic Coat" },          guids = { "93357d" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "b51484" } } }, model_GUID = "a84666" },
  -- Gen 3 326-350
  { name = "Grumpig",    level = 4, types = { "Psychic" },  moves = { "Psywave", "Bounce" },                  guids = { "23135a", "b51484" }, model_GUID = "fb1029" },
  { name = "Spinda",     level = 3, types = { "Normal" },   moves = { "Teeter Dance", "Thrash" },             guids = { "35a124" }, model_GUID = "e3708f" },
  { name = "Trapich",    level = 2, types = { "Ground" },   moves = { "Sand Attack", "Bite" },                guids = { "4c47d2" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "17e4c4" } } }, model_GUID = "835c79" },
  { name = "Vibrava",    level = 4, types = { "Ground", "Dragon" }, moves = { "Crunch", "Dig" },              guids = { "df1c5c", "17e4c4" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "7bb147", "5974bb" } } }, model_GUID = "944da2" },
  { name = "Flygon",     level = 6, types = { "Ground", "Dragon" }, moves = { "Dragon Breath", "Sand Tomb" }, guids = { "7574b6", "7bb147", "5974bb" }, model_GUID = "c8d0b6" },
  { name = "Cacnea",     level = 2, types = { "Grass" },    moves = { "Pin Missile", "Absorb" },              guids = { "62770e" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "16b950" } } }, model_GUID = "c6b9de", spawn_effect="Physical Attack" },
  { name = "Cactune",    level = 4, types = { "Grass", "Dark" }, moves = { "Needle Arm", "Spikes" },          guids = { "f8b287", "16b950" }, model_GUID = "3a509b" },
  { name = "Swablu",     level = 2, types = { "Flying", "Normal" }, moves = { "Sing", "Peck" },               guids = { "6b6c4b" },                     evoData = { { cost = 3, ball = RED, gen = 3, guids = { "d2b5c5" } } }, model_GUID = "7b086f" },
  { name = "Altaria",    level = 5, types = { "Dragon", "Flying" }, moves = { "Sky Attack", "Dragon Breath" },guids = { "10ef80", "d2b5c5" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "de28d4", "bfe185" } } }, model_GUID = "9a2210" },
  { name = "Zangoose",   level = 3, types = { "Normal" },   moves = { "Crush Claw", "False Swipe" },          guids = { "5b9f59" }, model_GUID = "2a763c" },
  { name = "Seviper",    level = 3, types = { "Poison" },   moves = { "Poison Tail", "Glare" },               guids = { "b7456d" }, model_GUID = "684d0d", spawn_effect="Physical Attack" },
  { name = "Lunatone",   level = 4, types = { "Rock", "Psychic" }, moves = { "Rock Throw", "Psychic" },       guids = { "79e4f0" }, model_GUID = "de6094" },
  { name = "Solrock",    level = 4, types = { "Rock", "Psychic" },     moves = { "Solar Beam", "Rock Slide" },guids = { "563547" }, model_GUID = "12e752" },
  { name = "Barboach",   level = 3, types = { "Water", "Ground" },    moves = { "Mud-Slap", "Water Gun" },    guids = { "3bd71b" },                     evoData = { { cost = 1, ball = YELLOW, gen = 3, guids = { "acc732" } } }, model_GUID = "5db694" },
  { name = "Whiscash",   level = 4, types = { "Water", "Ground" },    moves = { "Future Sight", "Earthquake" }, guids = { "f40ebb", "acc732" }, model_GUID = "08dca8" },
  { name = "Corpish",    level = 2, types = { "Water" },    moves = { "Bubble", "Leer" },                     guids = { "b159a5" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "193126" } } }, model_GUID = "7fe1a7" },
  { name = "Crawdaunt",  level = 4, types = { "Water", "Dark" }, moves = { "Crabhammer", "Knock Off" },       guids = { "cb83d3", "193126" }, model_GUID = "e834ac" },
  { name = "Baltoy",     level = 2, types = { "Ground", "Psychic" }, moves = { "Ancient Power", "Rapid Spin" },guids = { "9d4ab4" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "cadeb5" } } }, model_GUID = "9df0cf", spawn_effect="Physical Attack" },
  { name = "Claydol",    level = 4, types = { "Ground", "Psychic" }, moves = { "Hyper Beam", "Psybeam" },     guids = { "406223", "cadeb5" }, model_GUID = "af6fb3", spawn_effect="Physical Attack" },
  { name = "Lileep",     level = 2, types = { "Rock", "Grass" }, moves = { "Confuse Ray", "Acid" },           guids = { "c92a11" },                     evoData = { { cost = 3, ball = RED, gen = 3, guids = { "87d1f8" } } }, model_GUID = "77fdf5" },
  { name = "Cradily",    level = 5, types = { "Rock", "Grass" }, moves = { "Ancient Power", "Amnesia" },      guids = { "6d9326", "87d1f8" }, model_GUID = "a8c907" },
  { name = "Anorith",    level = 2, types = { "Rock", "Bug" }, moves = { "Rock Blast", "Water Gun" },     guids = { "8ac1a7" },                     evoData = { { cost = 3, ball = RED, gen = 3, guids = { "388697" } } }, model_GUID = "5b5bf7" },
  { name = "Armaldo",    level = 5, types = { "Rock", "Bug" }, moves = { "Ancient Power", "Fury Cutter" },    guids = { "7438a0", "388697" }, model_GUID = "812ce0" },
  { name = "Feebas",     level = 3, types = { "Water" },    moves = { "Confuse Ray", "Tackle" },              guids = { "4e5c37" },                     evoData = { { cost = 2, ball = RED, gen = 3, guids = { "51191e" } } }, model_GUID = "e88279" },
  { name = "Milotic",    level = 5, types = { "Water" },    moves = { "Water Pulse", "Mirror Coat" },         guids = { "8933c3", "51191e" }, model_GUID = "ab980b", spawn_effect="Physical Attack", offset={x=0, y=1.0, z=0} },
  -- Gen 3 351-375
  { name = "Castform",   level = 3, types = { "Normal" },   moves = { "Future Sight", "Body Slam" },          guids = { "95eabc" }, model_GUID = "80fd3b", ball = BLUE },
  { name = "Rainy Castform", level = 3, types = { "Water" },moves = { "Shock Wave", "Weather Ball Water" },   guids = { "4d93ae" }, model_GUID = "f710a9", ball = BLUE },
  { name = "Snowy Castform", level = 3, types = { "Ice" },  moves = { "Shadow Ball", "Weather Ball Ice" },    guids = { "0a700e" }, model_GUID = "bd28db", ball = BLUE },
  { name = "Sunny Castform", level = 3, types = { "Fire" }, moves = { "Solar Beam", "Weather Ball Fire" },    guids = { "1c9e4b" }, model_GUID = "e9d2d3", ball = BLUE },
  { name = "Kecleon",    level = 3, types = { "Normal" },   moves = { "Slash", "Thief" },                     guids = { "964da3" }, model_GUID = "223e93", spawn_effect="Physical Attack"},
  { name = "Shuppet",    level = 3, types = { "Ghost" },    moves = { "Will-O-Wisp", "Feint Attack" },        guids = { "7db1af" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "8da560" } } }, model_GUID = "44e392", spawn_effect="Physical Attack" },
  { name = "Banette",    level = 5, types = { "Ghost" },    moves = { "Shadow Ball", "Dark Pulse" },          guids = { "8845d6", "8da560" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "ff844c", "e69f55" } } }, model_GUID = "36b0e4" },
  { name = "Duskull",    level = 3, types = { "Ghost" },    moves = { "Confuse Ray", "Astonish" },            guids = { "937014" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "6ad885" } } }, model_GUID = "34ab19" },
  { name = "Dusclops",   level = 5, types = { "Ghost" },    moves = { "Shadow Punch", "Future Sight" },       guids = { "d12d2a", "6ad885" },           evoData = { { cost = 1, ball = RED, gen = 4, guids = { "59c3d9", "0a1b22" } } }, model_GUID = "24a945" },
  { name = "Tropius",    level = 4, types = { "Grass", "Flying" }, moves = { "Magical Leaf", "Gust" },        guids = { "bc8bd9" }, model_GUID = "bdb162" },
  { name = "Chimecho",   level = 4, types = { "Psychic" },  moves = { "Psychic", "Heal Bell" },               guids = { "a3b83f", "a78de8" }, model_GUID = "85d340" },
  { name = "Absol",      level = 4, types = { "Dark" },     moves = { "Slash", "Bite" },                      guids = { "ae6097" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "bec9aa" } } }, model_GUID = "4f2184" },
  { name = "Wynaut",     level = 1, types = { "Psychic" },  moves = { "Mirror Coat" },                        guids = { "00fb6f" },                     evoData = { { cost = 1, ball = GREEN, gen = 2, guids = { "0bbbae" } } }, model_GUID = "c16e96" },
  { name = "Snorunt",    level = 3, types = { "Ice" },      moves = { "Powder Snow", "Bite" },                guids = { "ea6e1a" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "c7849b" } }, { cost = 2, ball = YELLOW, gen = 4, guids = { "f5d09d" } } }, model_GUID = "f8ae98" },
  { name = "Glalie",     level = 5, types = { "Ice" },      moves = { "Headbutt", "Ice Beam" },               guids = { "dda975", "c7849b" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "863de0", "e7322f" } } }, model_GUID = "95fc87" },
  { name = "Spheal",     level = 3, types = { "Ice", "Water" }, moves = { "Powder Snow", "Rollout" },         guids = { "2bdc76" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "c38813" } } }, model_GUID = "d81c2a", spawn_effect="Physical Attack" },
  { name = "Sealeo",     level = 4, types = { "Ice", "Water" }, moves = { "Aurora Beam", "Water Gun" },       guids = { "3bb7d0", "c38813" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "3e2333", "cd24a1" } } }, model_GUID = "9a0533", custom_scale=0.7 },
  { name = "Walrein",    level = 6, types = { "Ice", "Water" }, moves = { "Body Slam", "Blizzard" },          guids = { "426535", "3e2333", "cd24a1" }, model_GUID = "74dec1", custom_scale=0.65 },
  { name = "Clamperl",   level = 3, types = { "Water" },    moves = { "Iron Defense", "Clamp" },              guids = { "e5e8a2" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "abf53c" } }, { cost = 2, ball = YELLOW, gen = 2, guids = { "f9ff3b" } } }, model_GUID = "b7775d" },
  { name = "Huntail",    level = 5, types = { "Water" },    moves = { "Water Pulse", "Crunch" },              guids = { "c1decf", "abf53c" }, model_GUID = "3a571e" },
  { name = "Gorebyss",   level = 5, types = { "Water" },    moves = { "Water Pulse", "Psychic" },             guids = { "3f3ac3", "f9ff3b" }, model_GUID = "377c59", spawn_effect="Physical Attack" },
  { name = "Relicanth",  level = 4, types = { "Water", "Rock" }, moves = { "Ancient Power", "Waterfall" },    guids = { "4f27e5" }, model_GUID = "18af25" },
  { name = "Luvdisc",    level = 3, types = { "Water" },    moves = { "Sweet Kiss", "Water Gun" },            guids = { "ccfa1c" }, model_GUID = "4b04ed", spawn_effect="Physical Attack" },
  { name = "Bagon",      level = 3, types = { "Dragon" },   moves = { "Rage", "Bite" },                       guids = { "b2c277" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "69d8be" } } }, model_GUID = "36437d" },
  { name = "Shelgon",    level = 5, types = { "Dragon" },   moves = { "Headbutt", "Crunch" },                 guids = { "bc895a", "69d8be" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "5bca28", "c6ee70" } } }, model_GUID = "261dc5", spawn_effect="Physical Attack" },
  { name = "Salamence",  level = 7, types = { "Dragon", "Flying" }, moves = { "Dragon Claw", "Fly" },         guids = { "17dd50", "5bca28", "c6ee70" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "896101", "d2f176" } } }, model_GUID = "32c729" },
  { name = "Beldum",     level = 2, types = { "Steel", "Psychic" }, moves = { "Take Down" },                  guids = { "ddca67" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "3292b4" } } }, model_GUID = "49faaa" },
  { name = "Metang",     level = 4, types = { "Steel", "Psychic" }, moves = { "Metal Claw", "Confusion" },    guids = { "61c017", "3292b4" },           evoData = { { cost = 3, ball = RED, gen = 2, guids = { "566a44", "a7b544" } } }, model_GUID = "11e387" },
  -- Gen 3 376-386
  { name = "Metagross",  level = 7, types = { "Steel", "Psychic" }, moves = { "Meteor Mash", "Psychic" },     guids = { "b13068", "566a44", "a7b544" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "e7382b", "90b29c" } } }, model_GUID = "69d7a3", spawn_effect="Status Attack", custom_scale=0.5 },
  { name = "Regirock",   level = 7, types = { "Rock" },     moves = { "Ancient Power", "Superpower" },        guids = { "f0f700" }, model_GUID = "a0b835" },
  { name = "Regice",     level = 7, types = { "Ice" },      moves = { "Zap Cannon", "Ice Beam" },             guids = { "3cc4aa" }, model_GUID = "8864ef" },
  { name = "Registeel",  level = 7, types = { "Steel" },    moves = { "Flash Cannon", "Hyper Beam" },         guids = { "c73d22" }, model_GUID = "7a9464", spawn_effect="Status Attack" },
  { name = "Latias",     level = 7, types = { "Dragon", "Psychic" }, moves = { "Dragon Breath", "Mist Ball" },guids = { "605532" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "5c8c7e" } } }, model_GUID = "ad2b2b" },
  { name = "Latios",     level = 7, types = { "Dragon", "Psychic" },   moves = { "Dragon Breath", "Luster Purge" }, guids = { "2ef165" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "75de4c" } } }, model_GUID = "bbe9d2" },
  { name = "Kyogre",     level = 7, types = { "Water" },    moves = { "Water Spout", "Ice Beam" },            guids = { "2fd702" },                     evoData = { { cost = "Blue Orb", ball = LEGENDARY, gen = 3, cycle = true, guids = { "b31acd" } } }, model_GUID = "a7e721", offset={x=0, y=1.25, z=-0.3} },
  { name = "Primal Kyogre", level = 7, types = { "Water" }, moves = { "Ancient Power", "Origin Pulse" },      guids = { "b31acd" },                     evoData = { { cost = 0, ball = LEGENDARY, gen = 3, cycle = true, guids = { "2fd702" } } }, model_GUID = "ec46fa", spawn_effect="Primal Evolution", custom_scale=0.5, offset={x=0, y=1.0, z=0} },
  { name = "Groudon",    level = 7, types = { "Ground" },   moves = { "Earthquake", "Fire Blast" },           guids = { "ef5ee2" },                     evoData = { { cost = "Red Orb", ball = LEGENDARY, gen = 3, cycle = true, guids = { "0d318f" } } }, model_GUID = "2bba90", custom_scale=0.3 },
  { name = "Primal Groudon", level = 7, types = { "Ground", "Fire" }, moves = { "Precipise Blades", "Lava Plume" }, guids = { "0d318f" },             evoData = { { cost = 0, ball = LEGENDARY, gen = 3, cycle = true, guids = { "ef5ee2" } } }, model_GUID = "0e9a71", spawn_effect="Primal Evolution", custom_scale=0.3 },
  { name = "Rayquaza",   level = 7, types = { "Dragon", "Flying" }, moves = { "Extreme Speed", "Dragon Claw" }, guids = { "3ae691" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, cycle = true, guids = { "45f389" } } }, model_GUID = "265715" },
  { name = "Jirachi",    level = 7, types = { "Steel", "Psychic" }, moves = { "Doom Desire", "Psychic" },     guids = { "48d5bf" }, model_GUID = "3df5b6" },
  { name = "Normal Deoxys", level = 7, types = { "Psychic" },  moves = { "Psycho Boost", "Night Shade" },     guids = { "f4e2fe" }, model_GUID = "87e928", spawn_effect="Status Attack", ball = LEGENDARY },
  { name = "Attack Deoxys", level = 7, types = { "Psychic" },  moves = { "Psycho Boost", "Night Shade" },     guids = { "14dbf9" }, model_GUID = "f020bf", spawn_effect="Status Attack", ball = LEGENDARY },
  { name = "Defense Deoxys", level = 7, types = { "Psychic" },  moves = { "Psycho Boost", "Night Shade" },    guids = { "e619f1" }, model_GUID = "f257b1", spawn_effect="Status Attack", ball = LEGENDARY },
  { name = "Speed Deoxys", level = 7, types = { "Psychic" },  moves = { "Psycho Boost", "Night Shade" },      guids = { "70bbfa" }, model_GUID = "a1a235", spawn_effect="Status Attack", ball = LEGENDARY },

  -- Mega evolutions.
  { name = "Mega Sceptile",     level = 6,    types = { "Grass", "Dragon" }, moves = { "Dual Chop", "Leaf Storm" },   guids = { "3921c1", "3563ba" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "01d5b8", "6acdb2", "8d967c" } } }, model_GUID = "d3060f", spawn_effect="Mega Evolve" },
  { name = "Mega Blaziken",     level = 6,    types = { "Fire", "Fighting" }, moves = { "Brave Bird", "Flare Blitz" }, guids = { "7b81ef", "641ef5" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "b3e3d0", "6b6eaa", "e4fcc7" } } }, model_GUID = "54893e", spawn_effect="Mega Evolve" },
  { name = "Mega Swampert",     level = 6,    types = { "Water", "Ground" },  moves = { "Focus Blast", "Scald" },      guids = { "f5dc2f", "045bc8" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "46c207", "0f2fe4", "93c652" } } }, model_GUID = "436a81", spawn_effect="Mega Evolve", custom_scale=0.75 },
  { name = "Mega Gardevoir",    level = 6,    types = { "Psychic", "Fairy" }, moves = { "Magical Leaf", "Moonblast" }, guids = { "13d6a2", "7f7d21" }, evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "fe8f9a", "a58279", "9ef381" } } }, model_GUID = "17dce9", spawn_effect="Mega Evolve" },
  { name = "Mega Sableye",      level = 5,    types = { "Dark", "Ghost" }, moves = { "Shadow Claw", "Dream Eater" }, guids = { "ad6245" },                evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "d0ddb7" } } }, model_GUID = "6f99c4", spawn_effect="Physical Attack" },
  { name = "Mega Mawile",       level = 5,    types = { "Steel", "Fairy" }, moves = { "Play Rough", "Iron Head" },   guids = { "901321" },                evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "825f3c" } } }, model_GUID = "de3150", spawn_effect="Mega Evolve" },
  { name = "Mega Aggron",       level = 7,    types = { "Steel", "Rock" }, moves = { "Iron Head", "Stone Edge" },    guids = { "8f5016", "b94e60" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "a5daad", "19c95d", "037e57" } } }, model_GUID = "103b64", spawn_effect="Mega Evolve", custom_scale=0.4 },
  { name = "Mega Medicham",     level = 5,    types = { "Fighting", "Psychic" },moves = { "Zen Headbutt", "Ice Punch" }, guids = { "19680e", "97834f" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "1b2da9", "925a8f" } } }, model_GUID = "2c439f", spawn_effect="Mega Evolve" },
  { name = "Mega Manectric",    level = 5,    types = { "Electric" },moves = { "Thunder Fang", "Hyper Beam" },guids = { "a96290", "70bf71" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "66eddf", "24b582" } } }, model_GUID = "f4b774", spawn_effect="Mega Evolve", custom_scale=0.7, offset={x=0, y=0, z=-0.1} },
  { name = "Mega Sharpedo",     level = 5,    types = { "Water", "Dark" },  moves = { "Night Slash", "Scald" },      guids = { "3127db", "b7e979" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "852350", "7d206a" } } }, model_GUID = "16ed43", spawn_effect="Mega Evolve" },
  { name = "Mega Camerupt",     level = 5,    types = { "Fire", "Ground" }, moves = { "Lava Plume", "Stone Edge" },  guids = { "bc021e", "01cfea" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "2bbebf", "4bfb16" } } }, model_GUID = "05b840", spawn_effect="Mega Evolve", custom_scale=0.35 },
  { name = "Mega Altaria",      level = 6,    types = { "Dragon", "Fairy" },moves = { "Moonblast", "Hurricane" },    guids = { "de28d4", "bfe185" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "10ef80", "d2b5c5" } } }, model_GUID = "f74c1f", spawn_effect="Mega Evolve" },
  { name = "Mega Banette",      level = 6,    types = { "Ghost" },   moves = { "Dazzling Gleam", "Night Shade" },guids = { "ff844c", "e69f55" },   evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "8845d6", "8da560" } } }, model_GUID = "cd84f5", spawn_effect="Mega Evolve" },
  { name = "Mega Absol",        level = 5,    types = { "Dark" },    moves = { "Night Slash", "Ice Beam" },   guids = { "bec9aa" },                evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "ae6097" } } }, model_GUID = "ac5e55", spawn_effect="Mega Evolve" },
  { name = "Mega Glalie",       level = 6,    types = { "Ice" },     moves = { "Ice Fang", "Crunch" },        guids = { "863de0", "e7322f" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "dda975", "c7849b" } } }, model_GUID = "f84e20", spawn_effect="Mega Evolve" },
  { name = "Mega Metagross",    level = 8,    types = { "Steel", "Psychic" }, moves = { "Flash Cannon", "Meteor Beam" },guids = { "e7382b", "90b29c" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "b13068", "566a44", "a7b544" } } }, model_GUID = "501574", spawn_effect="Mega Evolve", custom_scale=0.95 },
  { name = "Mega Latios",       level = 8,    types = { "Dragon", "Psychic" },  moves = { "Dragon Claw", "Aerial Ace" }, guids = { "75de4c" },                evoData = { { cost = 0, ball = LEGENDARY, gen = 3, cycle = true, guids = { "2ef165" } } }, model_GUID = "77ff84", spawn_effect="Mega Evolve" },
  { name = "Mega Latias",       level = 8,    types = { "Dragon", "Psychic" },  moves = { "Dragon Pulse", "Aerial Ace" }, guids = { "5c8c7e" },               evoData = { { cost = 0, ball = LEGENDARY, gen = 3, cycle = true, guids = { "605532" } } }, model_GUID = "f182f8", spawn_effect="Mega Evolve" },
  { name = "Mega Rayquaza",     level = 8,    types = { "Dragon", "Flying" },  moves = { "Dragon Ascent", "Dragon Pulse" },guids = { "45f389" },             evoData = { { cost = 0, ball = LEGENDARY, gen = 3, cycle = true, guids = { "3ae691" } } }, model_GUID = "147c09", spawn_effect="Mega Evolve", custom_scale=0.7 },
  { name = "Mega Salamence",    level = 8,    types = { "Dragon", "Flying" },  moves = { "Dragon Breath", "Fire Blast" },guids = { "896101", "d2f176" },   evoData = { { cost = 0, ball = LEGENDARY, gen = 3, cycle = true, guids = { "17dd50", "5bca28", "c6ee70" } } }, model_GUID = "ed6dfd", spawn_effect="Mega Evolve" },
}

gen4PokemonData =
{
  -- Gen 4 387-400
  { name = "Turtwig",    level = 1, types = { "Grass" },    moves = { "Withdraw", "Tackle" },            guids = { "cacd94" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "ff1b43" } } }, model_GUID = "02eeef" },
  { name = "Grotle",     level = 3, types = { "Grass" },    moves = { "Razor Leaf", "Bite" },            guids = { "20d958", "ff1b43" },                    evoData = { { cost = 2, ball = RED, gen = 4, guids = { "cfebcb", "3f2eaa" } } }, model_GUID = "89af8c", custom_scale=0.9 },
  { name = "Torterra",   level = 5, types = { "Grass", "Ground" }, moves = { "Leaf Storm", "Earthquake" }, guids = { "902030", "cfebcb", "3f2eaa" }, model_GUID = "542b09", custom_scale=0.65 },
  { name = "Chimchar",   level = 1, types = { "Fire" },     moves = { "Ember", "Taunt" },                guids = { "cd904d" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "8cd8f7" } } }, model_GUID = "cc51f2", spawn_effect="Physical Attack" },
  { name = "Monferno",   level = 3, types = { "Fire", "Fighting" },moves = { "Flame Wheel", "Mach Punch" }, guids = { "2ba1c0", "8cd8f7" },                 evoData = { { cost = 2, ball = RED, gen = 4, guids = { "aa0bb2", "38ad9f" } } }, model_GUID = "c2e9c2", spawn_effect="Physical Attack" },
  { name = "Infernape",  level = 5, types = { "Fire", "Fighting" },moves = { "Close Combat", "Flare Blitz" }, guids = { "6c7166", "aa0bb2", "38ad9f" }, model_GUID = "b04364", custom_scale=0.85 },
  { name = "Piplup",     level = 1, types = { "Water" },    moves = { "Growl", "Peck" },                 guids = { "ad1a53" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "707fe1" } } }, model_GUID = "c9b643" },
  { name = "Prinplup",   level = 3, types = { "Water" },    moves = { "Bubble Beam", "Metal Claw" },     guids = { "7a3199", "707fe1" },                    evoData = { { cost = 2, ball = RED, gen = 4, guids = { "0e9d7b", "fe588c" } } }, model_GUID = "7931f6" },
  { name = "Empoleon",   level = 5, types = { "Water", "Steel" }, moves = { "Hydro Pump", "Drill Peck" },guids = { "3cdce6", "0e9d7b", "fe588c" }, model_GUID = "85b6c8", spawn_effect="Status Attack" },
  { name = "Starly",     level = 1, types = { "Flying", "Normal" }, moves = { "Quick Attack", "Growl" },      guids = { "d5a011" },                         evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "4bb90a" } } }, model_GUID = "befb97" },
  { name = "Staravia",   level = 3, types = { "Flying", "Normal" }, moves = { "Wing Attack", "Whirlwind" },   guids = { "54063f", "4bb90a" },               evoData = { { cost = 2, ball = RED, gen = 4, guids = { "799437", "7ab20e" } } }, model_GUID = "2ea0b8", spawn_effect="Physical Attack" },
  { name = "Staraptor",  level = 5, types = { "Flying", "Normal" }, moves = { "Close Combat", "Brave Bird" }, guids = { "efc2ec", "799437", "7ab20e" }, model_GUID = "88b32f" },
  { name = "Bidoof",     level = 1, types = { "Normal" },   moves = { "Defense Curl", "Rollout" },       guids = { "8d27fd" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "29158c" } } }, model_GUID = "9cf4d2", spawn_effect="Physical Attack" },
  { name = "Bibarel",    level = 3, types = { "Normal", "Water" }, moves = { "Hyper Fang", "Water Gun" },guids = { "56a0e9", "29158c" }, model_GUID = "8d4c2c" },
  -- Gen 4 401-425
  { name = "Kricketot",  level = 1, types = { "Bug" },      moves = { "Growl" },                         guids = { "f48a32" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "9adb49" } } }, model_GUID = "196500" },
  { name = "Kricketune", level = 3, types = { "Bug" },      moves = { "Night Slash", "Bug Buzz" },       guids = { "8351a3", "9adb49" }, model_GUID = "7d4ba3" },
  { name = "Shinx",      level = 1, types = { "Electric" }, moves = { "Tackle", "Roar" },                guids = { "1215b7" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "fee2be" } } }, model_GUID = "19c7df" },
  { name = "Luxio",      level = 3, types = { "Electric" }, moves = { "Discharge", "Bite" },             guids = { "bfac8d", "fee2be" },                    evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "d7fc60", "782359" } } }, model_GUID = "6a78f1" },
  { name = "Luxray",     level = 4, types = { "Electric" }, moves = { "Thunder Fang", "Crunch" },        guids = { "dbd6ac", "d7fc60", "782359" }, model_GUID = "2fe437" },
  { name = "Budew",      level = 1, types = { "Grass", "Poison" }, moves = { "Stun Spore", "Absorb" },   guids = { "235bf8" },                              evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "7e165f" } } }, model_GUID = "b6d264" },
  { name = "Roserade",   level = 5, types = { "Grass", "Poison" }, moves = { "Sludge Bomb", "Leaf Storm" }, guids = { "dbf33b", "4aa1de", "46f8dc" }, model_GUID = "62a471", spawn_effect="Physical Attack" },
  { name = "Cranidos",   level = 2, types = { "Rock" },     moves = { "Assurance", "Headbutt" },         guids = { "e230a3" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "9bc735" } } }, model_GUID = "c3204c", spawn_effect="Physical Attack" },
  { name = "Rampardos",  level = 4, types = { "Rock" },     moves = { "Zen Headbutt", "Head Smash" },    guids = { "fa103e", "9bc735" }, model_GUID = "163e32", spawn_effect="Physical Attack" },
  { name = "Shieldon",   level = 2, types = { "Rock", "Steel" }, moves = { "Metal Sound", "Taunt" },     guids = { "f7d63e" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "c13d61" } } }, model_GUID = "1d508b" },
  { name = "Bastiodon",  level = 4, types = { "Rock", "Steel" }, moves = { "Ancient Power", "Iron Head" }, guids = { "904ec7", "c13d61" }, model_GUID = "9d8d6d", custom_scale=0.7 },
  { name = "Sandy Burmy", level = 1, types = { "Bug" },     moves = { "Hidden Power" },                  guids = { "5d3c35" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "679480", "0cf537", "bdc120" } }, { cost = 2, ball = GREEN, gen = 4, guids = { "50757b" } } }, model_GUID = "2d9ce9", ball = PINK }, -- Sandy
  { name = "Plant Burmy", level = 1, types = { "Bug" },     moves = { "Hidden Power" },                  guids = { "398f3a" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "679480", "0cf537", "bdc120" } }, { cost = 2, ball = GREEN, gen = 4, guids = { "b53138" } } }, model_GUID = "507709", ball = PINK }, -- Plant
  { name = "Trash Burmy", level = 1, types = { "Bug" },     moves = { "Hidden Power" },                  guids = { "ebd97a" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "679480", "0cf537", "bdc120" } }, { cost = 2, ball = GREEN, gen = 4, guids = { "2ed231" } } }, model_GUID = "fda7da", ball = PINK }, -- Trash
  { name = "Mothim",     level = 3, types = { "Bug", "Flying" },moves = { "Silver Wind", "Air Slash" },  guids = { "f97f24", "679480", "0cf537", "bdc120" }, model_GUID = "687bf9" },
  { name = "Sandy Wormadam", level = 3, types = { "Ground", "Bug" }, moves = { "Bug Bite", "Psychic" },  guids = { "1f8c4d", "50757b" }, model_GUID = "a52d8f", ball = GREEN },                                                                                                                                                                            -- Sandy
  { name = "Plant Wormadam", level = 3, types = { "Grass", "Bug" }, moves = { "Razor Leaf", "Bug Bite" },guids = { "ae14d4", "b53138" }, model_GUID = "b143f6", ball = GREEN },                                                                                                                                                                            -- Plant
  { name = "Trash Wormadam", level = 3, types = { "Steel", "Bug" },moves = { "Mirror Shot", "Bug Bite" },guids = { "9bfe68", "2ed231" }, model_GUID = "56eb94", ball = GREEN },                                                                                                                                                                            -- Trash
  { name = "Combee",     level = 2, types = { "Bug", "Flying" }, moves = { "Gust" },                     guids = { "1e577e" },                              evoData = { { cost = 1, ball = BLUE, gen = 4, guids = { "caab8e" } } }, model_GUID = "2b2090" },
  { name = "Vespiquen",  level = 3, types = { "Bug", "Flying" }, moves = { "Attack Order", "Power Gem" },guids = { "13494d", "caab8e" }, model_GUID = "5ab244" },
  { name = "Pachirisu",  level = 2, types = { "Electric" }, moves = { "Spark", "Swift" },                guids = { "bc8f33" }, model_GUID = "9045db" },
  { name = "Buizel",     level = 2, types = { "Water" },    moves = { "Sonic Boom", "Aqua Jet" },        guids = { "445666" },                              evoData = { { cost = 1, ball = GREEN, gen = 4, guids = { "4e2c8a" } } }, model_GUID = "a6a1a5" },
  { name = "Floatzel",   level = 3, types = { "Water" },    moves = { "Razor Wind", "Whirlpool" },       guids = { "d3a821", "4e2c8a" }, model_GUID = "136547", offset={x=0, y=0, z=0.05} },
  { name = "Cherubi",    level = 2, types = { "Grass" },    moves = { "Growth", "Tackle" },              guids = { "d8ddcb" },                              evoData = { { cost = 1, ball = GREEN, gen = 4, guids = { "c2a7bd" } } }, model_GUID = "a6957e" },
  { name = "Cherrim",    level = 3, types = { "Grass" },    moves = { "Take Down", "Solar Beam" },       guids = { "72c4b8", "c2a7bd" },model_GUID = "d4aaec", spawn_effect="Physical Attack" },
  { name = "Shellos",    level = 2, types = { "Water" },    moves = { "Trump Card", "Counter" },         guids = { "aa6021" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "9cf8af" } } }, model_GUID = "a02a0e" },
  { name = "Shellos",    level = 2, types = { "Water" },    moves = { "Mirror Coat", "Mud-Slap" },       guids = { "45b543" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "ad747a" } } }, model_GUID = "18c1c1" },
  { name = "East Gastrodon", level = 4, types = { "Water", "Ground" }, moves = { "Mud Bomb", "Body Slam" }, guids = { "8d67bb", "9cf8af" }, model_GUID = "a2bd5c" },
  { name = "West Gastrodon", level = 4, types = { "Water", "Ground" }, moves = { "Muddy Water", "Hidden Power" }, guids = { "dc4e3a", "ad747a" }, model_GUID = "c75552" },
  { name = "Ambipom",    level = 4, types = { "Normal" },   moves = { "Double Hit", "Nasty Plot" },      guids = { "892365", "06f1a9" }, model_GUID = "c47da4" },
  { name = "Drifloon",   level = 2, types = { "Ghost", "Flying" }, moves = { "Astonish", "Gust" },       guids = { "04345a" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "f87c2e" } } }, model_GUID = "d98126", spawn_effect="Physical Attack" },
  -- Gen 4 426-450
  { name = "Drifblim",   level = 4, types = { "Ghost", "Flying" }, moves = { "Ominous Wind", "Explosion" }, guids = { "36bed9", "f87c2e" }, model_GUID = "6fb952", spawn_effect="Physical Attack" },
  { name = "Buneary",    level = 2, types = { "Normal" },   moves = { "Quick Attack", "Jump Kick" },     guids = { "73996a" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "1d4012" } } }, model_GUID = "e6b1f1", spawn_effect="Physical Attack" },
  { name = "Lopunny",    level = 4, types = { "Normal" },   moves = { "Dizzy Punch", "Bounce" },         guids = { "ca0de0", "1d4012" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 4, cycle = true, guids = { "782df2", "c8a630" } } }, model_GUID = "48d04f", spawn_effect="Physical Attack" },
  { name = "Mismagius",  level = 5, types = { "Ghost" },    moves = { "Shadow Sneak", "Power Gem" },     guids = { "f0ec65", "496256" }, model_GUID = "a81efd", spawn_effect="Physical Attack" },
  { name = "Honchkrow",  level = 4, types = { "Dark", "Flying" }, moves = { "Wing Attack", "Dark Pulse" }, guids = { "a76d5e", "4f1558" }, model_GUID = "67c739" },
  { name = "Glameow",    level = 2, types = { "Normal" },   moves = { "Fury Swipes", "Charm" },          guids = { "c31fe7" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "468535" } } }, model_GUID = "bf33c1" },
  { name = "Purugly",    level = 4, types = { "Normal" },   moves = { "Sucker Punch", "Slash" },         guids = { "739efa", "468535" }, model_GUID = "40381a" },
  { name = "Chingling",  level = 2, types = { "Psychic" },  moves = { "Confusion", "Wrap" },             guids = { "3c321b" },                              evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "a78de8" } } }, model_GUID = "077587" },
  { name = "Stunky",     level = 2, types = { "Poison", "Dark" },   moves = { "Poison Gas", "Scratch" }, guids = { "350900" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "ce1be6" } } }, model_GUID = "4f2c9f" },
  { name = "Skuntank",   level = 4, types = { "Poison", "Dark" }, moves = { "Flamethrower", "Night Slash" }, guids = { "b80e55", "ce1be6" }, model_GUID = "142926" },
  { name = "Bronzor",    level = 2, types = { "Steel", "Psychic" }, moves = { "Confuse Ray", "Confusion" }, guids = { "76ab01" },                           evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "793185" } } }, model_GUID = "f3570a", spawn_effect="Physical Attack" },
  { name = "Bronzong",   level = 4, types = { "Steel", "Psychic" }, moves = { "Extrasensory", "Iron Head" }, guids = { "c70883", "793185" }, model_GUID = "422285" },
  { name = "Bonsly",     level = 1, types = { "Rock" },     moves = { "Fake Tears" },                    guids = { "992ede" },                              evoData = { { cost = 2, ball = GREEN, gen = 2, guids = { "eeca81" } } }, model_GUID = "e95207", spawn_effect="Physical Attack" },
  { name = "Mime Jr.",   level = 1, types = { "Psychic", "Fairy" }, moves = { "Double Slap" },           guids = { "6a4ef5" },                              evoData = { { cost = 2, ball = GREEN, gen = 1, guids = { "8315de" } }, { cost = 2, ball = GREEN, gen = 8, guids = { "8cfe98" }, model_GUID = "8e52ef" } }, model_GUID = "c86aff", spawn_effect="Physical Attack" },
  { name = "Happiny",    level = 1, types = { "Normal" },   moves = { "Pound" },                         guids = { "f6fbf5" },                              evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "ee10ff" } } }, model_GUID = "8f2981" },
  { name = "Chatot",     level = 3, types = { "Flying", "Normal" }, moves = { "Hyper Voice", "Chatter" },guids = { "85be31" }, model_GUID = "8a2ee8" },
  { name = "Spiritomb",  level = 3, types = { "Ghost", "Dark" }, moves = { "Shadow Sneak", "Dark Pulse" }, guids = { "3ade63" }, model_GUID = "0a6f0d" },
  { name = "Gible",      level = 2, types = { "Dragon", "Ground" },   moves = { "Sand Attack", "Tackle" }, guids = { "190d89" },                            evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "9b47dd" } } }, model_GUID = "a7c469", spawn_effect="Physical Attack" },
  { name = "Gabite",     level = 4, types = { "Dragon", "Ground" },   moves = { "Dragon Rage", "Take Down" }, guids = { "75db3d", "9b47dd" },               evoData = { { cost = 3, ball = RED, gen = 4, guids = { "998146", "935739" } } }, model_GUID = "284eb4" },
  { name = "Garchomp",   level = 7, types = { "Dragon", "Ground" },   moves = { "Dragon Rush", "Slash" },guids = { "16aa2c", "998146", "935739" },          evoData = { { cost = "Mega", ball = MEGA, gen = 4, cycle = true, guids = { "c45879", "e044da" } } }, model_GUID = "232447", spawn_effect="Status Attack", custom_scale=0.8, offset={x=0, y=0, z=-0.05} },
  { name = "Munchlax",   level = 2, types = { "Normal" },   moves = { "Tackle", "Lick" },                guids = { "ca2ab3" },                              evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "a017f9" } } }, model_GUID = "7315d0", spawn_effect="Physical Attack" },
  { name = "Riolu",      level = 2, types = { "Fighting" }, moves = { "Quick Attack", "Counter" },       guids = { "7bef81" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "153e4f" } } }, model_GUID = "b900ca" },
  { name = "Lucario",    level = 4, types = { "Fighting", "Steel" }, moves = { "Dragon Pulse", "Force Palm" },    guids = { "cd3901", "153e4f" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 4, cycle = true, guids = { "c203c6", "95d4d4" } } }, model_GUID = "6f7542" },
  { name = "Hippopotas", level = 2, types = { "Ground" },   moves = { "Sand Attack", "Take Down" },      guids = { "48588f" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "5f7329" } } }, model_GUID = "0a645f", spawn_effect="Physical Attack", offset={x=0, y=0, z=-0.1} },
  { name = "Hippowdon",  level = 4, types = { "Ground" },   moves = { "Earthquake", "Crunch" },          guids = { "073c65", "5f7329" }, model_GUID = "b43ee9", spawn_effect="Physical Attack", custom_scale=0.3, offset={x=0, y=0, z=-0.04} },
  -- Gen 4 451-475
  { name = "Skorupi",    level = 2, types = { "Poison", "Bug" }, moves = { "Poison Fang", "Pin Missile" }, guids = { "12a4d7" },                            evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "2cdfe7" } } }, model_GUID = "f7b7d8" },
  { name = "Drapion",    level = 4, types = { "Poison", "Dark" }, moves = { "Cross Poison", "Crunch" },  guids = { "7faa88", "2cdfe7" }, model_GUID = "5178e7", custom_scale=0.8 },
  { name = "Croagunk",   level = 2, types = { "Poison", "Fighting" }, moves = { "Mud-Slap", "Pursuit" }, guids = { "8a87c5" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "edeba6" } } }, model_GUID = "924639" },
  { name = "Toxicroak",  level = 4, types = { "Poison", "Fighting" }, moves = { "Poison Jab", "Revenge" }, guids = { "2f6517", "edeba6" }, model_GUID = "8604f0" },
  { name = "Carnivine",  level = 3, types = { "Grass" },    moves = { "Power Whip", "Feint Attack" },    guids = { "6ae25c" }, model_GUID = "f29340" },
  { name = "Finneon",    level = 2, types = { "Water" },    moves = { "Water Gun", "Attract" },          guids = { "4e7881" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "eff442" } } }, model_GUID = "ee9976" },
  { name = "Lumineon",   level = 4, types = { "Water" },    moves = { "Water Pulse", "U-Turn" },         guids = { "5e8443", "eff442" }, model_GUID = "5d8ca7", spawn_effect="Physical Attack" },
  { name = "Mantyke",    level = 1, types = { "Water", "Flying" }, moves = { "Supersonic", "Bubble" },   guids = { "ea3133" },                              evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "6fd093" } } }, model_GUID = "ac4168", spawn_effect="Physical Attack" },
  { name = "Snover",     level = 4, types = { "Ice", "Grass" }, moves = { "Powder Snow", "Razor Leaf" }, guids = { "770f5b" },                              evoData = { { cost = 2, ball = RED, gen = 4, guids = { "985066" } } }, model_GUID = "b548ea" },
  { name = "Abomasnow",  level = 6, types = { "Ice", "Grass" }, moves = { "Wood Hammer", "Ice Punch" },  guids = { "fc423f", "985066" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 4, cycle = true, guids = { "c0f0bc", "72076f" } } }, model_GUID = "c003e7", custom_scale=0.8 },
  { name = "Weavile",    level = 4, types = { "Dark", "Ice" }, moves = { "Dark Pulse", "Icy Wind" },     guids = { "57a02c", "9b517e" }, model_GUID = "ded7dd", spawn_effect="Physical Attack" },
  { name = "Magnezone",  level = 6, types = { "Electric", "Steel" }, moves = { "Zap Cannon", "Mirror Shot" }, guids = { "c53a51", "dedadf", "618210" }, model_GUID = "e901bd" },
  { name = "Lickilicky", level = 5, types = { "Normal" },   moves = { "Power Whip", "Me First" },        guids = { "dc8977", "5d1069" }, model_GUID = "8a81dd", spawn_effect="Physical Attack" },
  { name = "Rhyperior",  level = 7, types = { "Ground", "Rock" }, moves = { "Rock Wrecker", "Megahorn" },guids = { "ee964b", "1665fe", "f2b985" },  model_GUID = "860bbc", spawn_effect="Physical Attack", custom_scale=0.65 },
  { name = "Tangrowth",  level = 4, types = { "Grass" },    moves = { "Ancient Power", "Power Whip" },   guids = { "c5ddd7", "5965cd" }, model_GUID = "49f976", custom_scale=0.7, offset={x=0, y=0, z=0} },
  { name = "Electivire", level = 6, types = { "Electric" }, moves = { "Giga Impact", "Thunder" },        guids = { "6787dc", "11f593", "896d6e" }, model_GUID = "15ad3d", custom_scale=0.8 },
  { name = "Magmortar",  level = 6, types = { "Fire" },     moves = { "Lava Plume", "Hyper Beam" },      guids = { "f7000a", "bc96fe", "ebafae" }, model_GUID = "1ba6f9" },
  { name = "Togekiss",   level = 4, types = { "Fairy", "Flying" }, moves = { "Aura Sphere", "Air Slash" }, guids = { "d9bab2", "020ecc", "3786d0" }, model_GUID = "94ed87" },
  { name = "Yanmega",    level = 4, types = { "Bug", "Flying" }, moves = { "Night Slash", "Air Slash" }, guids = { "040022", "e093cb" }, model_GUID = "5efa44" },
  { name = "Leafeon",    level = 5, types = { "Grass" },    moves = { "Leaf Blade", "Fury Cutter" },     guids = { "e6b356", "25ef7b" }, model_GUID = "9f14e6" },
  { name = "Glaceon",    level = 5, types = { "Ice" },      moves = { "Aqua Tail", "Ice Fang" },         guids = { "d990cc", "549166" }, model_GUID = "8884ba" },
  { name = "Gliscor",    level = 5, types = { "Ground", "Flying" }, moves = { "Poison Jab", "X-Scissor" }, guids = { "9344ba", "96a4fa" }, model_GUID = "0389d0" },
  { name = "Mamoswine",  level = 6, types = { "Ice", "Ground" }, moves = { "Earthquake", "Blizzard" },   guids = { "ae18c1", "bac5e2", "3e9a5e" }, model_GUID = "3f4e29", custom_scale=0.6 },
  { name = "Porygon-Z",  level = 5, types = { "Normal" },   moves = { "Zap Cannon", "Hyper Beam" },      guids = { "8b5275", "89624f", "ccdbee" }, model_GUID = "42158e" },
  { name = "Gallade",    level = 5, types = { "Psychic", "Fighting" },  moves = { "Close Combat", "Psycho Cut" },    guids = { "e00be3", "491632", "2956c7" },          evoData = { { cost = "Mega", ball = MEGA, gen = 4, cycle = true, guids = { "762e3d", "f77da3" } } }, model_GUID = "04f582" },
  -- Gen 4 476-493
  { name = "Probopass",  level = 5, types = { "Rock", "Steel" }, moves = { "Magnet Bomb", "Stone Edge" },guids = { "c36f28", "261bac" }, model_GUID = "3a1a8d" },
  { name = "Dusknoir",   level = 6, types = { "Ghost" },    moves = { "Shadow Punch", "Seismic Toss" },  guids = { "40e69b", "59c3d9", "0a1b22" }, model_GUID = "14f5fa" },
  { name = "Frosslass",  level = 5, types = { "Ice", "Ghost" }, moves = { "Ominous Wind", "Ice Fang" },  guids = { "44d36b", "f5d09d" }, model_GUID = "21d87a" },
  { name = "Rotom",      level = 3, types = { "Electric", "Ghost" }, moves = { "Ominous Wind", "Thunder Shock" }, guids = { "631643" }, model_GUID = "480b20", spawn_effect="Physical Attack", ball = BLUE },
  { name = "Mow Rotom",  level = 3, types = { "Electric", "Grass" }, moves = { "Ominous Wind", "Leaf Storm" }, guids = { "9c2b53" }, model_GUID = "cd771b", ball = BLUE },
  { name = "Heat Rotom", level = 3, types = { "Electric", "Fire" }, moves = { "Ominous Wind", "Overheat" }, guids = { "119ba7" }, model_GUID = "154dd8", ball = BLUE },
  { name = "Wash Rotom", level = 3, types = { "Electric", "Water" }, moves = { "Ominous Wind", "Hydro Pump" }, guids = { "e60f49" }, model_GUID = "c5364f", ball = BLUE },
  { name = "Fan Rotom",  level = 3, types = { "Electric", "Flying" }, moves = { "Ominous Wind", "Air Slash" }, guids = { "2fc387" }, model_GUID = "274d14", spawn_effect="Physical Attack", ball = BLUE },
  { name = "Frost Rotom",level = 3, types = { "Electric", "Ice" }, moves = { "Ominous Wind", "Blizzard" }, guids = { "313204" }, model_GUID = "671b5d", ball = BLUE },
  { name = "Uxie",       level = 7, types = { "Psychic" },  moves = { "Thunder Punch", "Psychic" },      guids = { "7161bc" }, model_GUID = "0d927b", spawn_effect="Physical Attack" },
  { name = "Mesprit",    level = 7, types = { "Psychic" },  moves = { "Extrasensory", "Fire Punch" },    guids = { "206d05" }, model_GUID = "ac091c" },
  { name = "Azelf",      level = 7, types = { "Psychic" },  moves = { "Zen Headbutt", "Ice Punch" },     guids = { "51e346" }, model_GUID = "5e98bd", spawn_effect="Physical Attack" },
  { name = "Dialga",     level = 7, types = { "Steel", "Dragon" }, moves = { "Flash Cannon", "Roar of Time" }, guids = { "99da0e" }, model_GUID = "776fdc", spawn_effect="Physical Attack", custom_scale=0.35, offset={x=0, y=0, z=-0.03}, ball = LEGENDARY },
  { name = "Origin Dialga", level = 7, types = { "Steel", "Dragon" }, moves = { "Dragon Claw", "Iron Tail" },  guids = { "d8b8d3" }, model_GUID = "239ed0", spawn_effect="Physical Attack", custom_scale=0.35, offset={x=0, y=0, z=-0.03}, ball = LEGENDARY },
  { name = "Palkia",     level = 7, types = { "Water", "Dragon" },    moves = { "Spacial Rend", "Aqua Tail" },  guids = { "99bbae" }, model_GUID = "42a6d1", custom_scale=0.35, offset={x=0, y=0, z=-0.03}, ball = LEGENDARY },
  { name = "Origin Palkia", level = 7, types = { "Water", "Dragon" }, moves = { "Dragon Pulse", "Hydro Pump" }, guids = { "6a9a3d" }, model_GUID = "a4da49", custom_scale=0.35, offset={x=0, y=0, z=-0.03}, ball = LEGENDARY },
  { name = "Heatran",    level = 7, types = { "Fire", "Steel" }, moves = { "Magma Storm", "Earth Power" },    guids = { "d6bd2b" }, model_GUID = "7343d2", spawn_effect="Status Attack", custom_scale=0.4, offset={x=0, y=0, z=-0.06}  },
  { name = "Regigigas",  level = 7, types = { "Normal" }, moves = { "Dizzy Punch", "Revenge" },        guids = { "04ae8e" }, model_GUID = "0ddf47", spawn_effect="Status Attack", custom_scale=0.45, offset={x=0, y=0, z=-0.03} },
  { name = "Giratina",   level = 7, types = { "Dragon", "Ghost" }, moves = { "Shadow Claw", "Dragon Claw" }, guids = { "e1ea2d" }, model_GUID = "086e6b", custom_scale=0.3, ball = LEGENDARY },
  { name = "Origin Giratina", level = 7, types = { "Ghost", "Dragon" }, moves = { "Dragon Breath", "Shadow Force" }, guids = { "e1ea2d" }, model_GUID = "4dd635", custom_scale=0.3, ball = LEGENDARY },
  { name = "Cresselia",  level = 7, types = { "Psychic" },  moves = { "Aurora Beam", "Psycho Cut" },     guids = { "d22af4" }, model_GUID = "a4dcf2" },
  { name = "Phione",     level = 5, types = { "Water" },    moves = { "Acid Armor", "Dive" },            guids = { "3379b4" }, model_GUID = "b0bae4", spawn_effect="Physical Attack" },
  { name = "Manaphy",    level = 7, types = { "Water" },    moves = { "Water Pulse", "Tail Glow" },      guids = { "4eb57f" }, model_GUID = "5cc85d" },
  { name = "Darkrai",    level = 7, types = { "Dark" },     moves = { "Dream Eater", "Dark Pulse" },     guids = { "dd87aa" }, model_GUID = "aa2219", spawn_effect="Status Attack" },
  { name = "Land Shaymin",level = 7, types = { "Grass" },   moves = { "Play Rough", "Seed Flare" }, guids = { "821809" }, model_GUID = "dca507", spawn_effect="Status Attack", ball = LEGENDARY },
  { name = "Sky Shaymin",level = 7, types = { "Flying", "Grass" }, moves = { "Magical Leaf", "Air Slash" }, guids = { "215c3b" }, model_GUID = "1e692f", spawn_effect="Status Attack", ball = LEGENDARY },
  { name = "Arceus",     level = 7, types = { "Normal" },   moves = { "Earth Power", "Judgement" },      guids = { "fbb914" }, model_GUID = "bf4818", custom_scale=0.65 },

  -- Mega evolutions.
  { name = "Mega Lopunny",     level = 5,    types = { "Normal", "Fighting" },moves = { "High Jump Kick", "Mega Kick" },   guids = { "782df2", "c8a630" },      evoData = { { cost = 0, ball = BLUE, gen = 3, cycle = true, guids = { "ca0de0", "1d4012" } } }, model_GUID = "0308a7", spawn_effect="Mega Evolve" },
  { name = "Mega Garchomp",    level = 8,    types = { "Dragon", "Ground" },            moves = { "Dragon Claw", "Stone Edge" },     guids = { "c45879", "e044da" },      evoData = { { cost = 0, ball = RED, gen = 3, cycle = true, guids = { "16aa2c", "998146", "935739" } } }, model_GUID = "233df5", spawn_effect="Mega Evolve" },
  { name = "Mega Lucario",     level = 5,    types = { "Fighting", "Steel" }, moves = { "Flash Cannon", "Focus Blast" }, guids = { "c203c6", "95d4d4" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "cd3901", "153e4f" } } }, model_GUID = "a2c359", spawn_effect="Mega Evolve" },
  { name = "Mega Abomasnow",   level = 7,    types = { "Grass", "Ice" },      moves = { "Focus Blast", "Blizzard" },       guids = { "c0f0bc", "72076f" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "fc423f", "985066" } } }, model_GUID = "b1ae77", spawn_effect="Mega Evolve", custom_scale=0.8, offset={x=0, y=0, z=-0.05} },
  { name = "Mega Gallade",     level = 6,    types = { "Psychic", "Fighting" }, moves = { "Focus Blast", "Night Slash" },  guids = { "762e3d", "f77da3" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, cycle = true, guids = { "e00be3", "491632", "2956c7" } } }, model_GUID = "8ad8e0", spawn_effect="Mega Evolve", offset={x=0, y=0, z=-0.05} },
}

gen5PokemonData =
{
  -- Gen 5 494-526
  { name = "Victini",         level = 7, types = { "Psychic", "Fire" }, moves = { "Zen Headbutt", "Searing Shot" }, guids = { "49fa0d" }, model_GUID = "a96393", spawn_effect="Physical Attack" },
  { name = "Snivy",           level = 1, types = { "Grass" },    moves = { "Vine Whip", "Tackle" },            guids = { "bd4952" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "98096d" }, model_GUID = "cb1ef6" } }, model_GUID = "dd3268" },
  { name = "Servine",         level = 3, types = { "Grass" },    moves = { "Leaf Tornado", "Wrap" },           guids = { "e2e93d", "98096d" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "1934f3", "66a00d" }, model_GUID = "df3e9d", spawn_effect="Physical Attack" } }, model_GUID = "cb1ef6", offset={x=0, y=0, z=0.1} },
  { name = "Serperior",       level = 5, types = { "Grass" },    moves = { "Leaf Storm", "Coil" },             guids = { "1934f3", "2dc582", "66a00d" }, model_GUID = "df3e9d", spawn_effect="Physical Attack" },
  { name = "Tepig",           level = 1, types = { "Fire" },     moves = { "Ember", "Tackle" },                guids = { "b8c770" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "14b2e7" }, model_GUID = "1142b7" } }, model_GUID = "f8a647" },
  { name = "Pignite",         level = 3, types = { "Fire", "Fighting" }, moves = { "Arm Thrust", "Flame Charge" }, guids = { "14b2e7", "d214c9" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "666751", "5d555c" }, model_GUID = "83bed3" } }, model_GUID = "1142b7" },
  { name = "Emboar",          level = 5, types = { "Fire", "Fighting" }, moves = { "Hammer Arm", "Flare Blitz" },  guids = { "e51210", "666751", "5d555c" }, model_GUID = "83bed3" },
  { name = "Oshawott",        level = 1, types = { "Water" },    moves = { "Water Gun", "Tackle" },            guids = { "4c80d6" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "1eef77" }, model_GUID = "4544f3", spawn_effect="Physical Attack" } }, model_GUID = "ed7cad" },
  { name = "Dewott",          level = 3, types = { "Water" },    moves = { "Fury Cutter", "Aqua Jet" },        guids = { "89e6b6", "1eef77" },           evoData = { { cost = 2, ball = RED, gen = 8, guids = { "769c18", "c7dc10" } },
                                                                                                                                                                     { cost = 2, ball = RED, gen = 5, guids = { "b351eb", "d8975e" }, model_GUID = "027855", spawn_effect="Physical Attack" } }, 
                                                                                                                                                         model_GUID = "4544f3", spawn_effect="Physical Attack" },
  { name = "Samurott",        level = 5, types = { "Water" },    moves = { "Razor Shell", "Aerial Ace" },      guids = { "49d4d0", "b351eb", "d8975e" }, model_GUID = "027855", spawn_effect="Physical Attack", custom_scale=0.85 },
  { name = "Patrat",          level = 1, types = { "Normal" },   moves = { "Bite", "Leer" },                   guids = { "8c09ef" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "fd2a3f" }, model_GUID = "446cbb" } }, model_GUID = "95e22a" },
  { name = "Watchog",         level = 3, types = { "Normal" },   moves = { "Hyper Fang", "Detect" },           guids = { "509c3b", "fd2a3f" }, model_GUID = "446cbb" },
  { name = "Lillipup",        level = 1, types = { "Normal" },   moves = { "Odor Sleuth", "Tackle" },          guids = { "d5ebdb" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "408da5" }, model_GUID = "fe0927" } }, model_GUID = "a3d331" },
  { name = "Herdier",         level = 3, types = { "Normal" },   moves = { "Take Down", "Bite" },              guids = { "a02c78", "408da5" },           evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "4e8f54", "52057b" }, model_GUID = "eff43c" } }, model_GUID = "fe0927" },
  { name = "Stoutland",       level = 5, types = { "Normal" },   moves = { "Giga Impact", "Crunch" },          guids = { "cb77e7", "4e8f54", "52057b" }, model_GUID = "eff43c", custom_scale=0.8 },
  { name = "Purrloin",        level = 1, types = { "Dark" },     moves = { "Fury Swipes", "Assurance" },       guids = { "c28158" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "5a5d10" }, model_GUID = "0d58f0" } }, model_GUID = "ad8e41" },
  { name = "Liepard",         level = 3, types = { "Dark" },     moves = { "Hone Claws", "Slash" },            guids = { "3f7259", "5a5d10" }, model_GUID = "0d58f0", custom_scale=0.8 },
  { name = "Pansage",         level = 2, types = { "Grass" },    moves = { "Fury Swipes", "Vine Whip" },       guids = { "eec2b1" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "23924b" }, model_GUID = "962b36" } }, model_GUID = "0febb6" },
  { name = "Simisage",        level = 3, types = { "Grass" },    moves = { "Seed Bomb", "Bite" },              guids = { "a6b59b", "23924b" }, model_GUID = "962b36" },
  { name = "Pansear",         level = 2, types = { "Fire" },     moves = { "Fury Swipes", "Flame Charge" },    guids = { "2597b5" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "404ff7" }, model_GUID = "d7786a" } }, model_GUID = "790b25" },
  { name = "Simisear",        level = 3, types = { "Fire" },     moves = { "Flame Burst", "Bite" },            guids = { "265b2a", "404ff7" }, model_GUID = "d7786a" },
  { name = "Panpour",         level = 2, types = { "Water" },    moves = { "Fury Swipes", "Water Gun" },       guids = { "3da3a1" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "a0d19e" }, model_GUID = "7ca32a" } }, model_GUID = "446aff" },
  { name = "Simipour",        level = 3, types = { "Water" },    moves = { "Scald", "Bite" },                  guids = { "c8641e", "a0d19e" }, model_GUID = "7ca32a" },
  { name = "Munna",           level = 2, types = { "Psychic" },  moves = { "Psywave", "Yawn" },                guids = { "3c0505" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "198c08" }, model_GUID = "f742b2" } }, model_GUID = "d7cfc6" },
  { name = "Musharna",        level = 3, types = { "Psychic" },  moves = { "Hypnosis", "Psybeam" },            guids = { "91179d", "198c08" }, model_GUID = "f742b2" },
  { name = "Pidove",          level = 1, types = { "Flying", "Normal" }, moves = { "Growl", "Gust" }, guids = { "723bbc" },                     evoData = { { cost = 2, ball = GREEN, gen = 5, guids = { "fa3490" }, model_GUID = "0f8928" } }, model_GUID = "4f6c26" },
  { name = "Tranquil",        level = 3, types = { "Flying", "Normal" }, moves = { "Feather Dance", "Razor Wind" }, guids = { "3d420b", "fa3490" },           evoData = { { cost = 1, ball = YELLOW, gen = 5, guids = { "c37df9", "3bbd1b" }, model_GUID = "e4c215" } }, model_GUID = "0f8928" },
  { name = "Unfezant",        level = 4, types = { "Flying", "Normal" }, moves = { "Air Slash", "Facade" },    guids = { "f71153", "c37df9", "3bbd1b" }, model_GUID = "e4c215" },
  { name = "Blitzle",         level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Flame Charge" },   guids = { "c3f811" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "a00b30" }, model_GUID = "1f6bb5", spawn_effect="Physical Attack" } }, model_GUID = "14eed5" },
  { name = "Zebstrika",       level = 4, types = { "Electric" }, moves = { "Wild Charge", "Stomp" },           guids = { "718d9a", "a00b30" }, model_GUID = "1f6bb5", spawn_effect="Physical Attack" },
  { name = "Roggenrola",      level = 2, types = { "Rock" },     moves = { "Sand Attack", "Headbutt" },        guids = { "f96286" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "b65495" }, model_GUID = "a80816", spawn_effect="Physical Attack" } }, model_GUID = "5e5531" },
  { name = "Boldore",         level = 4, types = { "Rock" },     moves = { "Rock Blast", "Iron Defense" },     guids = { "28e251", "b65495" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "826c9d", "f3f8a9" }, model_GUID = "0162ba" } }, model_GUID = "a80816", spawn_effect="Physical Attack" },
  { name = "Gigalith",        level = 6, types = { "Rock" },     moves = { "Sandstorm", "Rock Slide" },        guids = { "6c7072", "826c9d", "f3f8a9" }, model_GUID = "0162ba", custom_scale=0.6, offset={x=0, y=0, z=-0.05} },
  -- Gen 5 527-550
  { name = "Woobat",          level = 1, types = { "Psychic", "Flying" },  moves = { "Confusion", "Odor Sleuth" }, guids = { "6264c2" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "8f6353" }, model_GUID = "97b4e6" } }, model_GUID = "5d9f84" },
  { name = "Swoobat",         level = 3, types = { "Psychic", "Flying" },  moves = { "Heart Stamp", "Gust" },  guids = { "a3b9cf", "8f6353" }, model_GUID = "97b4e6" },
  { name = "Drilbur",         level = 2, types = { "Ground" },   moves = { "Fury Swipes", "Mud-Slap" },        guids = { "b7fbbf" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "777dd0" }, model_GUID = "dccc9b", spawn_effect="Status Attack" } }, model_GUID = "a49ea4" },
  { name = "Excadrill",       level = 4, types = { "Ground", "Steel" }, moves = { "Metal Claw", "Dig" },       guids = { "8ce447", "777dd0" }, model_GUID = "dccc9b", spawn_effect="Status Attack" },
  { name = "Audino",          level = 4, types = { "Normal" },   moves = { "Take Down", "Attract" },           guids = { "b81637" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 5, cycle = true, guids = { "0c7909" }, model_GUID = "793f23", spawn_effect="Mega Evolve" } }, model_GUID = "134409" },
  { name = "Timburr",         level = 2, types = { "Fighting" }, moves = { "Low Kick", "Leer" },               guids = { "89aae4" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "e8de1c" }, model_GUID = "0dfde4", spawn_effect="Physical Attack" } }, model_GUID = "334885", spawn_effect="Physical Attack" },
  { name = "Gurdurr",         level = 4, types = { "Fighting" }, moves = { "Dynamic Punch", "Chip Away" },     guids = { "84d209", "e8de1c" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "2c58d6", "36840e" }, model_GUID = "04bed2" } }, model_GUID = "0dfde4", spawn_effect="Physical Attack" },
  { name = "Conkeldurr",      level = 6, types = { "Fighting" }, moves = { "Hammer Arm", "Stone Edge" },       guids = { "29c9eb", "2c58d6", "36840e" }, model_GUID = "04bed2", custom_scale=0.65, offset={x=0, y=0, z=-0.15} },
  { name = "Tympole",         level = 2, types = { "Water" },    moves = { "Supersonic", "Bubble" },           guids = { "348d4f" },                     evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "18532d" }, model_GUID = "62c539", spawn_effect="Physical Attack" } }, model_GUID = "70136d" },
  { name = "Palpitoad",       level = 4, types = { "Water", "Ground" }, moves = { "Echoed Voice", "Bubble Beam" }, guids = { "fd66e4", "18532d" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "a738c3", "373635" }, model_GUID = "f1d4fb" } }, model_GUID = "62c539", spawn_effect="Physical Attack" },
  { name = "Seismitoad",      level = 5, types = { "Water", "Ground" }, moves = { "Muddy Water", "Mud Shot" }, guids = { "578f18", "a738c3", "373635" }, model_GUID = "f1d4fb" },
  { name = "Throh",           level = 4, types = { "Fighting" }, moves = { "Bulk Up", "Seismic Toss" },        guids = { "72fcf5" }, model_GUID = "74563b" },
  { name = "Sawk",            level = 4, types = { "Fighting" }, moves = { "Bulk Up", "Counter" },             guids = { "15a56f" }, model_GUID = "1f8cae" },
  { name = "Sewaddle",        level = 1, types = { "Bug", "Grass" }, moves = { "String Shot", "Tackle" },      guids = { "1e8149" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "013008" }, model_GUID = "0e2bb5" } }, model_GUID = "2a3547" },
  { name = "Swadloon",        level = 2, types = { "Bug", "Grass" }, moves = { "Struggle Bug", "Protect" },    guids = { "434424", "013008" },           evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "fe4a27", "7e7b85" }, model_GUID = "788aa1" } }, model_GUID = "0e2bb5" },
  { name = "Leavanny",        level = 4, types = { "Bug", "Grass" }, moves = { "Leaf Blade", "X-Scissor" },    guids = { "e12b22", "fe4a27", "7e7b85" }, model_GUID = "788aa1" },
  { name = "Venipede",        level = 2, types = { "Bug", "Poison" }, moves = { "Poison Sting", "Defense Curl" }, guids = { "98f18f" },                     evoData = { { cost = 1, ball = BLUE, gen = 5, guids = { "703d36" }, model_GUID = "0f9af9", spawn_effect="Physical Attack" } }, model_GUID = "07a778" },
  { name = "Whirlipede",      level = 3, types = { "Bug", "Poison" }, moves = { "Rollout", "Protect" },        guids = { "562f04", "703d36" },           evoData = { { cost = 1, ball = YELLOW, gen = 5, guids = { "c997bd", "ae213b" }, model_GUID = "6b8b44", spawn_effect="Physical Attack" } }, model_GUID = "0f9af9", spawn_effect="Physical Attack", custom_scale=0.8 }, -- Trash
  { name = "Scolipede",       level = 4, types = { "Bug", "Poison" }, moves = { "Poison Tail", "Steamroller" }, guids = { "111f3c", "c997bd", "ae213b" }, model_GUID = "6b8b44", spawn_effect="Physical Attack", custom_scale=0.8, offset={x=0, y=0.08, z=0} },
  { name = "Cottonee",        level = 2, types = { "Grass", "Fairy" }, moves = { "Stun Spore", "Growth" },     guids = { "e12ddb" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "4f1ca9" }, model_GUID = "2437bd", spawn_effect="Physical Attack" } }, model_GUID = "e5da38", spawn_effect="Physical Attack" },
  { name = "Whimsicott",      level = 4, types = { "Grass", "Fairy" }, moves = { "Moonblast", "Gust" },        guids = { "5a123d", "4f1ca9" }, model_GUID = "2437bd", spawn_effect="Physical Attack" },
  { name = "Petilil",         level = 2, types = { "Grass" },    moves = { "Growth", "Absorb" },               guids = { "2ecb05" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "693b62" }, model_GUID = "312e7e" }, 
                                                                                                                                                                     { cost = 2, ball = BLUE, gen = 5, guids = { "13e980" } } }, 
                                                                                                                                                         model_GUID = "f7466a", spawn_effect="Physical Attack" },
  { name = "Lilligant",       level = 4, types = { "Grass" },    moves = { "Teeter Dance", "Mega Drain" },     guids = { "28e67a", "693b62" }, model_GUID = "312e7e" },
  { name = "Blue Basculin",   level = 2, types = { "Water" },    moves = { "Aqua Jet", "Chip Away" },          guids = { "5ee961" }, model_GUID = "76e2c8", ball = GREEN },
  { name = "Red Basculin",    level = 2, types = { "Water" },    moves = { "Aqua Jet", "Bite" },               guids = { "8e451c" }, model_GUID = "1aad2b", ball = GREEN },
  -- Gen 5 551-576
  { name = "Sandile",         level = 2, types = { "Ground", "Dark" },   moves = { "Sand Attack", "Bite" },    guids = { "0ec450" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "89573c" }, model_GUID = "4cf233" } }, model_GUID = "2e2c75" },
  { name = "Krokorok",        level = 4, types = { "Ground", "Dark" }, moves = { "Sandstorm", "Assurance" },   guids = { "9857a1", "89573c" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "5d317d", "abaa08" }, model_GUID = "1455fe" } }, model_GUID = "4cf233", offset={x=0, y=0, z=0.06} },
  { name = "Krookodile",      level = 6, types = { "Ground", "Dark" },   moves = { "Earthquake", "Foul Play" },guids = { "ab0970", "5d317d", "abaa08" }, model_GUID = "1455fe" },
  { name = "Darumaka",        level = 3, types = { "Fire" },     moves = { "Fire Fang", "Rollout" },           guids = { "fd08bc" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "929881" }, model_GUID = "4693f5" },
                                                                                                                                                                     { cost = 2, ball = YELLOW, gen = 5, guids = { "8425ea" }, model_GUID = "e68195" } }, 
                                                                                                                                                         model_GUID = "5f8571", spawn_effect="Physical Attack" },
  { name = "Darmanitan",      level = 5, types = { "Fire" },     moves = { "Fire Punch", "Superpower" },       guids = { "1c3955", "8425ea" }, model_GUID = "e68195", offset={x=0, y=0, z=-0.1}, ball = YELLOW },  -- Red
  { name = "Zen Darmanitan",  level = 5, types = { "Fire", "Psychic" }, moves = { "Zen Headbutt", "Fire Punch" }, guids = { "7c085e", "929881" }, model_GUID = "4693f5", ball = YELLOW },                          -- Blue
  { name = "Maractus",        level = 3, types = { "Grass" },    moves = { "Needle Arm", "Peck" },             guids = { "b2f6e7" }, model_GUID = "3832b0" },
  { name = "Dwebble",         level = 2, types = { "Bug", "Rock" },      moves = { "Rock Blast", "Fury Cutter" }, guids = { "68671d" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "eb163e" }, model_GUID = "de316c" } }, model_GUID = "553572" },
  { name = "Crustle",         level = 4, types = { "Bug", "Rock" }, moves = { "Rock Slide", "X-Scissor" },     guids = { "459bcf", "eb163e" }, model_GUID = "de316c", custom_scale=0.7, offset={x=0, y=0, z=-0.1} },
  { name = "Scraggy",         level = 3, types = { "Dark", "Fighting" }, moves = { "Headbutt", "Low Kick" },   guids = { "aaaf84" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "d2d70d" }, model_GUID = "b9d27b", spawn_effect="Physical Attack" } }, model_GUID = "6e59e2" },
  { name = "Scrafty",         level = 5, types = { "Dark", "Fighting" }, moves = { "High Jump Kick", "Payback" }, guids = { "ef3715", "d2d70d" }, model_GUID = "b9d27b", spawn_effect="Physical Attack" },
  { name = "Sigilyph",        level = 5, types = { "Psychic", "Flying" }, moves = { "Mirror Move", "Psybeam" },guids = { "53ef88" }, model_GUID = "71ed95" },
  { name = "Yamask",          level = 3, types = { "Ghost" },    moves = { "Will-O-Wisp", "Astonish" },        guids = { "ae058d" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "dfb551" }, model_GUID = "76a330" } }, model_GUID = "5304a8" },
  { name = "Cofagrigus",      level = 5, types = { "Ghost" },    moves = { "Ominous Wind", "Curse" },          guids = { "bff908", "dfb551" }, model_GUID = "76a330" },
  { name = "Tirtouga",        level = 4, types = { "Water", "Rock" }, moves = { "Shell Smash", "Water Gun" },  guids = { "69a6f1" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "ff9d76" }, model_GUID = "212e44" } }, model_GUID = "8bbd45" },
  { name = "Carracosta",      level = 6, types = { "Water", "Rock" }, moves = { "Ancient Power", "Aqua Tail" },guids = { "493a52", "ff9d76" }, model_GUID = "212e44" },
  { name = "Archen",          level = 4, types = { "Rock", "Flying" }, moves = { "Quick Attack", "Dragon Claw" }, guids = { "dfadef" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "fe2d6b" }, model_GUID = "e52be5", spawn_effect="Physical Attack" } }, model_GUID = "fe5542" },
  { name = "Archeops",        level = 6, types = { "Rock", "Flying" }, moves = { "Ancient Power", "Wing Attack" }, guids = { "d1e259", "fe2d6b" }, model_GUID = "e52be5", spawn_effect="Physical Attack" },
  { name = "Trubbish",        level = 3, types = { "Poison" },   moves = { "Clear Smog", "Pound" },            guids = { "c0ee99" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "427e7e" }, model_GUID = "317f1f" } }, model_GUID = "8eef4f" },
  { name = "Garbodor",        level = 5, types = { "Poison" },   moves = { "Explosion", "Sludge" },            guids = { "5e6faf", "427e7e" },           evoData = { { cost = "GMax", ball = MEGA, gen = 5, cycle = true, guids = { "43b26e", "a13dc7" } } }, model_GUID = "317f1f", custom_scale=0.7 },
  { name = "Zorua",           level = 3, types = { "Dark" },     moves = { "Fury Swipes", "Fake Tears" },      guids = { "852f7a" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "f5a315" }, model_GUID = "fb10d4" } }, model_GUID = "04ebbd" },
  { name = "Zoroark",         level = 5, types = { "Dark" },     moves = { "Shadow Claw", "Night Daze" },      guids = { "99e127", "f5a315" }, model_GUID = "fb10d4" },
  { name = "Minccino",        level = 3, types = { "Normal" },   moves = { "Baby-Doll Eyes", "Echoed Voice" }, guids = { "4619bc" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "dbc5fd" }, model_GUID = "320a12" } }, model_GUID = "dccefe", spawn_effect="Physical Attack" },
  { name = "Cinccino",        level = 4, types = { "Normal" },   moves = { "Swift", "Sing" },                  guids = { "fd401d", "dbc5fd" }, model_GUID = "320a12" },
  { name = "Gothita",         level = 2, types = { "Psychic" },  moves = { "Confusion", "Pound" },             guids = { "2c8314" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "3c3dd3" }, model_GUID = "afdfbd" } }, model_GUID = "ce5c02" },
  { name = "Gothorita",       level = 4, types = { "Psychic" },  moves = { "Psybeam", "Charm" },               guids = { "1a4be0", "3c3dd3" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "b7fdb2", "193950" }, model_GUID = "e6fa75" } }, model_GUID = "afdfbd" },
  { name = "Gothitelle",      level = 6, types = { "Psychic" },  moves = { "Future Sight", "Fake Tears" },     guids = { "95e45e", "b7fdb2", "193950" }, model_GUID = "e6fa75" },
  -- Gen 5 577-601
  { name = "Solosis",         level = 2, types = { "Psychic" },  moves = { "Rollout", "Charm" },               guids = { "4ffe17" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "428bdd" }, model_GUID = "5681e1" } }, model_GUID = "cd2f3b" },
  { name = "Duosion",         level = 4, types = { "Psychic" },  moves = { "Hidden Power", "Light Screen" },   guids = { "6251de", "428bdd" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "783bd2", "e40ad5" }, model_GUID = "43a8c7", spawn_effect="Physical Attack" } }, model_GUID = "5681e1" },
  { name = "Reuniclus",       level = 6, types = { "Psychic" },  moves = { "Dizzy Punch", "Psychic" },         guids = { "fd8189", "783bd2", "e40ad5" }, model_GUID = "43a8c7", spawn_effect="Physical Attack" },
  { name = "Ducklett",        level = 2, types = { "Water", "Flying" }, moves = { "Feather Dance", "Water Gun" }, guids = { "194e14" },                     evoData = { { cost = 3, ball = YELLOW, gen = 5, guids = { "e43f99" }, model_GUID = "653e11" } }, model_GUID = "0ea94c" },
  { name = "Swanna",          level = 5, types = { "Water", "Flying" }, moves = { "Water Pulse", "Air Slash" }, guids = { "955306", "e43f99" }, model_GUID = "653e11" },
  { name = "Vanillite",       level = 2, types = { "Ice" },      moves = { "Icicle Spear", "Astonish" },       guids = { "746959" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "67e645" }, model_GUID = "aa33f1", spawn_effect="Physical Attack" } }, model_GUID = "a60d6e" },
  { name = "Vanillish",       level = 4, types = { "Ice" },      moves = { "Mirror Shot", "Icy Wind" },        guids = { "a2fe81", "67e645" },           evoData = { { cost = 2, ball = RED, gen = 4, guids = { "642461", "98f88f" }, model_GUID = "7abd8f" } }, model_GUID = "aa33f1", spawn_effect="Physical Attack" },
  { name = "Vanilluxe",       level = 6, types = { "Ice" },      moves = { "Mirror Coat", "Blizzard" },        guids = { "c69af0", "642461", "98f88f" }, model_GUID = "7abd8f" },
  { name = "Spring Deerling", level = 2, types = { "Normal", "Grass" }, moves = { "Camouflage", "Tackle" },    guids = { "7fe6be" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "2a61be" }, model_GUID = "9b9805" } }, model_GUID = "fe766f", ball = PINK }, -- Spring
  { name = "Spring Sawsbuck", level = 4, types = { "Normal", "Grass" }, moves = { "Take Down", "Nature Power" }, guids = { "02874b", "2a61be" }, model_GUID = "9b9805", ball = YELLOW },                                                                                                          -- Spring
  { name = "Autumn Deerling", level = 2, types = { "Normal", "Grass" }, moves = { "Camouflage", "Tackle" },    guids = { "9ce73b" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "1f9d13" }, model_GUID = "8aaef9" } }, model_GUID = "aa4a1c", ball = PINK }, -- Autumn
  { name = "Autumn Sawsbuck", level = 4, types = { "Normal", "Grass" }, moves = { "Take Down", "Nature Power" }, guids = { "494757", "1f9d13" }, model_GUID = "8aaef9", ball = YELLOW },                                                                                                          -- Autumn
  { name = "Summer Deerling", level = 2, types = { "Normal", "Grass" }, moves = { "Camouflage", "Tackle" },    guids = { "de2c41" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "426c52" }, model_GUID = "8bb6ad" } }, model_GUID = "e544e1", ball = PINK }, -- Summer
  { name = "Summer Sawsbuck", level = 4, types = { "Normal", "Grass" }, moves = { "Take Down", "Nature Power" }, guids = { "a1bde0", "426c52" }, model_GUID = "8bb6ad", ball = YELLOW },                                                                                                          -- Summer
  { name = "Winter Deerling", level = 2, types = { "Normal", "Grass" }, moves = { "Camouflage", "Tackle" },    guids = { "90a5b6" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "4ef3be" }, model_GUID = "77fc07" } }, model_GUID = "b1f364", ball = PINK }, -- Winter
  { name = "Winter Sawsbuck", level = 4, types = { "Normal", "Grass" }, moves = { "Take Down", "Nature Power" }, guids = { "853bba", "4ef3be" }, model_GUID = "77fc07", ball = YELLOW },                                                                                                          -- Winter
  { name = "Emolga",          level = 3, types = { "Electric", "Flying" }, moves = { "Quick Attack", "Spark" }, guids = { "21c0e7" }, model_GUID = "dad8a0", spawn_effect="Physical Attack" },
  { name = "Karrablast",      level = 3, types = { "Bug" },      moves = { "Fury Cutter", "Peck" },            guids = { "a987fe" },                     evoData = { { cost = 1, ball = YELLOW, gen = 5, guids = { "2fbc4e" }, model_GUID = "e4c099" } }, model_GUID = "66ec18" },
  { name = "Escavalier",      level = 4, types = { "Bug", "Steel" }, moves = { "Iron Head", "Bug Buzz" },      guids = { "79dfaa", "2fbc4e" }, model_GUID = "e4c099" },
  { name = "Foongus",         level = 3, types = { "Grass", "Poison" }, moves = { "Astonish", "Absorb" },      guids = { "ee2a78" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "13d1d6" }, model_GUID = "b1f388" } }, model_GUID = "06f3ae" },
  { name = "Amoongus",        level = 5, types = { "Grass", "Poison" }, moves = { "Clear Smog", "Mega Drain" }, guids = { "b61f79", "13d1d6" }, model_GUID = "b1f388" },
  { name = "Frillish (M)",    level = 4, types = { "Water", "Ghost" }, moves = { "Bubble Beam", "Absorb" },    guids = { "a28f5d" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "8ac9cc" }, model_GUID = "b219d0", spawn_effect="Physical Attack" } }, model_GUID = "4d5963", ball = BLUE }, -- Blue
  { name = "Jellicent (M)",   level = 6, types = { "Water", "Ghost" }, moves = { "Ominous Wind", "Water Pulse" }, guids = { "366348", "8ac9cc" }, model_GUID = "b219d0", spawn_effect="Physical Attack", ball = RED },                                                                                                          -- Blue
  { name = "Frillish (F)",    level = 4, types = { "Water", "Ghost" }, moves = { "Bubble Beam", "Absorb" },    guids = { "60ba9e" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "f7a5b5" }, model_GUID = "82eae8", spawn_effect="Physical Attack" } }, model_GUID = "f693fb", ball = BLUE }, -- Pink
  { name = "Jellicent (F)",   level = 6, types = { "Water", "Ghost" }, moves = { "Ominous Wind", "Water Pulse" }, guids = { "8fd291", "f7a5b5" }, model_GUID = "82eae8", spawn_effect="Physical Attack", ball = RED },                                                                                                          -- Pink
  { name = "Alomomola",       level = 3, types = { "Water" },    moves = { "Safeguard", "Brine" },             guids = { "9c2e47" }, model_GUID = "987107" },
  { name = "Joltik",          level = 2, types = { "Bug", "Electric" }, moves = { "Fury Cutter", "Absorb" },   guids = { "c4adc9" },                     evoData = { { cost = 3, ball = YELLOW, gen = 5, guids = { "4f2f10" }, model_GUID = "f565f0" } }, model_GUID = "b967c0", spawn_effect="Physical Attack", custom_scale=3.0 },
  { name = "Galvantula",      level = 5, types = { "Bug", "Electric" }, moves = { "Electroweb", "Bug Bite" },  guids = { "1e7df7", "4f2f10" }, model_GUID = "f565f0", custom_scale=0.9 },
  { name = "Ferroseed",       level = 3, types = { "Grass", "Steel" }, moves = { "Pin Missile", "Mirror Shot" }, guids = { "4801d8" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "d1ce01" }, model_GUID = "37e34d" } }, model_GUID = "46fbe9" },
  { name = "Ferrothorn",      level = 5, types = { "Grass", "Steel" }, moves = { "Iron Defense", "Power Whip" }, guids = { "1419cf", "d1ce01" }, model_GUID = "37e34d", custom_scale=0.5, offset={x=0, y=0, z=-0.03} },
  { name = "Klink",           level = 3, types = { "Steel" },    moves = { "Thunder Shock", "Vise Grip" },     guids = { "4ee23b" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "17a2ae" }, model_GUID = "8388d7", spawn_effect="Physical Attack" } }, model_GUID = "f1c2b1", spawn_effect="Physical Attack" },
  { name = "Klang",           level = 5, types = { "Steel" },    moves = { "Mirror Shot", "Screech" },         guids = { "00b5c3", "17a2ae" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "c5a2bf", "47e417" }, model_GUID = "f57695" } }, model_GUID = "8388d7", spawn_effect="Physical Attack" },
  { name = "Klinklang",       level = 6, types = { "Steel" },    moves = { "Gear Grind", "Discharge" },        guids = { "5108f3", "c5a2bf", "47e417" }, model_GUID = "f57695" },
  -- Gen 5 602-637
  { name = "Tynamo",          level = 3, types = { "Electric" }, moves = { "Thunder Wave", "Tackle" },         guids = { "033989" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "8cec3c" }, model_GUID = "e93792" } }, model_GUID = "d78a62" },
  { name = "Eelektrik",       level = 5, types = { "Electric" }, moves = { "Charge Beam", "Acid" },            guids = { "170118", "8cec3c" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "74b8ad", "1e9b7b" }, model_GUID = "155948", spawn_effect="Physical Attack" } }, model_GUID = "e93792" },
  { name = "Eelektross",      level = 6, types = { "Electric" }, moves = { "Discharge", "Crunch" },            guids = { "340824", "74b8ad", "1e9b7b" }, model_GUID = "155948", spawn_effect="Physical Attack" },
  { name = "Elgyem",          level = 3, types = { "Psychic" },  moves = { "Headbutt", "Psybeam" },            guids = { "f5a0a7" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "9c471b" }, model_GUID = "824281", spawn_effect="Physical Attack" } }, model_GUID = "fca2da" },
  { name = "Beheeyem",        level = 5, types = { "Psychic" },  moves = { "Zen Headbutt", "Hidden Power" },   guids = { "aa886c", "9c471b" }, model_GUID = "824281", spawn_effect="Physical Attack" },
  { name = "Litwick",         level = 3, types = { "Ghost", "Fire" }, moves = { "Will-O-Wisp", "Astonish" },   guids = { "32bd77" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "c3de22" }, model_GUID = "90d56c", spawn_effect="Physical Attack" } }, model_GUID = "ed8fd6" },
  { name = "Lampent",         level = 5, types = { "Ghost", "Fire" }, moves = { "Fire Spin", "Curse" },        guids = { "7135eb", "c3de22" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "5a029a", "1d0a91" }, model_GUID = "de2e80" } }, model_GUID = "90d56c", spawn_effect="Physical Attack" },
  { name = "Chandelure",      level = 6, types = { "Ghost", "Fire" }, moves = { "Shadow Ball", "Flame Burst" },guids = { "a1dddd", "5a029a", "1d0a91" }, model_GUID = "de2e80" },
  { name = "Axew",            level = 2, types = { "Dragon" },   moves = { "Assurance", "Scratch" },           guids = { "b44616" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "989343" }, model_GUID = "e5baeb" } }, model_GUID = "c209ac" },
  { name = "Fraxure",         level = 4, types = { "Dragon" },   moves = { "Swords Dance", "Dragon Claw" },    guids = { "983f37", "989343" },           evoData = { { cost = 3, ball = RED, gen = 5, guids = { "c776ab", "bf4902" }, model_GUID = "18b97d" } }, model_GUID = "e5baeb" },
  { name = "Haxorus",         level = 7, types = { "Dragon" },   moves = { "Dual Chop", "Giga Impact" },       guids = { "913d4a", "c776ab", "bf4902" }, model_GUID = "18b97d" },
  { name = "Cubchoo",         level = 3, types = { "Ice" },      moves = { "Powder Snow", "Charm" },           guids = { "0d7df1" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "7ef288" }, model_GUID = "54bff7" } }, model_GUID = "085ee7" },
  { name = "Beartic",         level = 5, types = { "Ice" },      moves = { "Icicle Crash", "Thrash" },         guids = { "c83c3a", "7ef288" }, model_GUID = "54bff7", custom_scale=0.85 },
  { name = "Cryogonal",       level = 4, types = { "Ice" },      moves = { "Sheer Cold", "Light Screen" },     guids = { "68294a" }, model_GUID = "37b1ac", spawn_effect="Physical Attack" },
  { name = "Shelmet",         level = 3, types = { "Bug" },      moves = { "Acid Armor", "Mega Drain" },       guids = { "898892" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "f95e65" }, model_GUID = "98569d" } }, model_GUID = "0f788a", spawn_effect="Physical Attack" },
  { name = "Accelgor",        level = 4, types = { "Bug" },      moves = { "Me First", "U-Turn" },             guids = { "41989c", "f95e65" }, model_GUID = "98569d" },
  { name = "Stunfisk",        level = 3, types = { "Ground", "Electric" }, moves = { "Thunder Shock", "Mud-Slap" }, guids = { "2db3e2" }, model_GUID = "4a9d6e" },
  { name = "Mienfoo",         level = 4, types = { "Fighting" }, moves = { "Force Palm", "Calm Mind" },        guids = { "ff78e9" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "3e2f17" }, model_GUID = "afd151" } }, model_GUID = "05f772", spawn_effect="Physical Attack" },
  { name = "Mienshao",        level = 6, types = { "Fighting" }, moves = { "High Jump Kick", "Bounce" },       guids = { "ad66a7", "3e2f17" }, model_GUID = "afd151" },
  { name = "Druddigon",       level = 5, types = { "Dragon" },   moves = { "Dragon Claw", "Night Slash" },     guids = { "0dc4b0" }, model_GUID = "e0e534", custom_scale=0.8 },
  { name = "Golett",          level = 3, types = { "Ground", "Ghost" }, moves = { "Dynamic Punch", "Iron Defense" }, guids = { "181a0d" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "3cbe89" }, model_GUID = "002dc3" } }, model_GUID = "560b71" },
  { name = "Golurk",          level = 5, types = { "Ground", "Ghost" }, moves = { "Shadow Punch", "Earthquake" }, guids = { "209c3f", "3cbe89" }, model_GUID = "002dc3", custom_scale=0.8 },
  { name = "Pawniard",        level = 3, types = { "Dark", "Steel" }, moves = { "Metal Claw", "Slash" },       guids = { "259499" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "b85238" }, model_GUID = "753f92" } }, model_GUID = "4aa17e" },
  { name = "Bisharp",         level = 5, types = { "Dark", "Steel" }, moves = { "Guillotine", "Night Slash" }, guids = { "cd8ee8", "b85238" },           evoData = { { cost = 1, ball = RED, gen = 9, guids = { "d49464", "8625f7" }, model_GUID = "3296ae" } }, model_GUID = "753f92" },
  { name = "Bouffalant",      level = 4, types = { "Normal" },   moves = { "Head Charge", "Megahorn" },        guids = { "91e1a4" }, model_GUID = "3296ae", custom_scale=0.65, offset={x=0, y=0, z=-0.1} },
  { name = "Rufflet",         level = 3, types = { "Flying", "Normal" }, moves = { "Hone Claws", "Peck" },     guids = { "f52196" },                     evoData = { { cost = 3, ball = RED, gen = 5, guids = { "f1a656" }, model_GUID = "3f59cc" }, 
                                                                                                                                                                     { cost = 3, ball = RED, gen = 8, guids = { "aaa239" } } }, 
                                                                                                                                                         model_GUID = "bc0883" },
  { name = "Braviary",        level = 6, types = { "Flying", "Normal" }, moves = { "Crush Claw", "Aerial Ace" }, guids = { "8def45", "f1a656" }, model_GUID = "a5fe68" },
  { name = "Vullaby",         level = 3, types = { "Dark", "Flying" }, moves = { "Fury Attack", "Nasty Plot" }, guids = { "8c8d4a" },                     evoData = { { cost = 3, ball = RED, gen = 5, guids = { "d9a365" }, model_GUID = "fa9bd5" } }, model_GUID = "bc6308" },
  { name = "Mandibuzz",       level = 6, types = { "Dark", "Flying" }, moves = { "Bone Rush", "Air Slash" },   guids = { "21182a", "d9a365" }, model_GUID = "fa9bd5" },
  { name = "Heatmor",         level = 4, types = { "Fire" },     moves = { "Incinerate", "Odor Sleuth" },      guids = { "cd2a36" }, model_GUID = "571def" },
  { name = "Durant",          level = 4, types = { "Bug", "Steel" }, moves = { "Metal Sound", "Bug Bite" },    guids = { "96b5d6" }, model_GUID = "0b8592" },
  { name = "Deino",           level = 3, types = { "Dark", "Dragon" }, moves = { "Assurance", "Headbutt" },    guids = { "6e0580" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "cc9679" }, model_GUID = "bbc115", spawn_effect="Physical Attack" } }, model_GUID = "119c86" },
  { name = "Zweilous",        level = 5, types = { "Dark", "Dragon" }, moves = { "Dragon Pulse", "Bite" },     guids = { "751bca", "cc9679" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "573535", "6edcb7" }, model_GUID = "2621b5", spawn_effect="Status Attack" } }, model_GUID = "bbc115", spawn_effect="Physical Attack", custom_scale=0.8 },
  { name = "Hydreigon",       level = 7, types = { "Dark", "Dragon" }, moves = { "Outrage", "Crunch" },        guids = { "d1c597", "573535", "6edcb7" }, model_GUID = "2621b5", spawn_effect="Status Attack" },
  { name = "Larvesta",        level = 4, types = { "Bug", "Fire" }, moves = { "Leech Life", "Ember" },         guids = { "ec4a46" },                     evoData = { { cost = 3, ball = RED, gen = 5, guids = { "b9c1a0" }, model_GUID = "c9ed3b" } }, model_GUID = "68b192" },
  { name = "Volcarona",       level = 7, types = { "Bug", "Fire" }, moves = { "Fiery Dance", "Hurricane" },    guids = { "ad5421", "b9c1a0" }, model_GUID = "c9ed3b" },
  -- Gen 5 638-649
  { name = "Cobalion",        level = 7, types = { "Steel", "Fighting" }, moves = { "Sacred Sword", "Iron Head" }, guids = { "55fe44" }, model_GUID = "8d4715", custom_scale=0.7 },
  { name = "Terrakion",       level = 7, types = { "Rock", "Fighting" }, moves = { "Sacred Sword", "Rock Slide" }, guids = { "21e3a7" }, model_GUID = "f48c6a", custom_scale=0.65 },
  { name = "Virizion",        level = 7, types = { "Grass", "Fighting" }, moves = { "Sacred Sword", "Leaf Blade" }, guids = { "97db25" }, model_GUID = "774eac", custom_scale=0.85 },
  { name = "Incarnate Tornadus", level = 7, types = { "Flying" },moves = { "Bleakwind Storm", "Thrash" },      guids = { "d1658f" }, model_GUID = "af1db1", ball = LEGENDARY },
  { name = "Therian Tornadus",level = 7, types = { "Flying" },   moves = { "Bleakwind Storm", "Focus Blast" }, guids = { "916000" }, model_GUID = "f7abb5", ball = LEGENDARY },
  { name = "Incarnate Thundurus",  level = 7, types = { "Electric", "Flying" }, moves = { "Wildbolt Storm", "Fly" }, guids = { "723ca9" }, model_GUID = "0a0b98", ball = LEGENDARY },
  { name = "Therian Thundurus", level = 7, types = { "Electric", "Flying" }, moves = { "Wildbolt Storm", "Focus Blast" }, guids = { "a2c518" }, model_GUID = "13842a", ball = LEGENDARY },
  { name = "Reshiram",        level = 7, types = { "Dragon", "Fire" }, moves = { "Blue Flare", "Dragon Pulse" }, guids = { "5b8987" },                     evoData = { { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, cycle = true, guids = { "d5117a" }, model_GUID = "653151" } }, model_GUID = "d9cc98", spawn_effect="Status Attack", offset={x=0, y=1.0, z=0}, idle_effect="Run" },
  { name = "White Kyurem",    level = 7, types = { "Dragon", "Ice" },   moves = { "Fusion Flare", "Ice Beam" }, guids = { "d5117a" },              evoData = { { cost = 0, ball = LEGENDARY, gen = 5, cycle = true, guids = { "5b8987" }, model_GUID = "d9cc98", spawn_effect="Status Attack" } }, model_GUID = "653151", offset={x=0, y=1.0, z=0}, idle_effect="Run", custom_scale=0.75 }, -- White Kyurem (for Reshiram)
  { name = "Zekrom",          level = 7, types = { "Dragon", "Electric" }, moves = { "Bolt Strike", "Dragon Claw" }, guids = { "879958" },                     evoData = { { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, cycle = true, guids = { "d20352" }, model_GUID = "9f42db" } }, model_GUID = "463700", spawn_effect="Status Attack", offset={x=0, y=1.0, z=0}, idle_effect="Run" },
  { name = "Black Kyurem",    level = 7, types = { "Dragon", "Ice" },   moves = { "Fusion Bolt", "Ice Beam" }, guids = { "d20352" },              evoData = { { cost = 0, ball = LEGENDARY, gen = 5, cycle = true, guids = { "879958" } } }, model_GUID = "9f42db", offset={x=0, y=1.0, z=0}, idle_effect="Run", custom_scale=0.75 }, -- Black Kyurem (for Zekrom)
  { name = "Incarnate Landorus", level = 7, types = { "Ground", "Flying" }, moves = { "Sandsear Storm", "Focus Blast" },  guids = { "ee0f97" }, model_GUID = "a7e86f", spawn_effect="Status Attack" },
  { name = "Therian Landorus",level = 7, types = { "Ground", "Flying" }, moves = { "Sandsear Storm", "Stone Edge" }, guids = { "596a60" }, model_GUID = "604304" },
  { name = "Kyurem",          level = 7, types = { "Dragon", "Ice" },   moves = { "Dragon Breath", "Glaciate" }, guids = { "3a2734" },              evoData = { { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, cycle = true, guids = { "6be4f3" }, model_GUID = "9f42db" }, 
                                                                                                                                                                     { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, cycle = true, guids = { "28742a" }, model_GUID = "653151" } }, 
                                                                                                                                                         model_GUID = "be9a02", spawn_effect="Status Attack", custom_scale=0.6 },
  { name = "Black Kyurem",    level = 7, types = { "Dragon", "Ice" },   moves = { "Fusion Bolt", "Ice Beam" }, guids = { "6be4f3" },              evoData = { { cost = 0, ball = LEGENDARY, gen = 5, cycle = true, guids = { "3a2734" }, model_GUID = "be9a02", spawn_effect="Status Attack" } }, model_GUID = "9f42db", offset={x=0, y=1.0, z=0}, idle_effect="Run", custom_scale=0.75 }, -- Black Kyurem (for Kyurem)
  { name = "White Kyurem",    level = 7, types = { "Dragon", "Ice" },   moves = { "Fusion Flare", "Ice Beam" },guids = { "28742a" },              evoData = { { cost = 0, ball = LEGENDARY, gen = 5, cycle = true, guids = { "3a2734" }, model_GUID = "be9a02", spawn_effect="Status Attack" } }, model_GUID = "653151", offset={x=0, y=1.0, z=0}, idle_effect="Run", custom_scale=0.75 }, -- White Kyurem (for Kyurem)
  { name = "Ordinary Keldeo", level = 7, types = { "Water", "Fighting" }, moves = { "Sacred Sword", "Aqua Tail" }, guids = { "d825d0" }, model_GUID = "97905c", ball = LEGENDARY },
  { name = "Resolute Keldeo", level = 7, types = { "Water", "Fighting" }, moves = { "Sacred Sword", "Hydro Pump" }, guids = { "e0356d" }, model_GUID = "4465a6", ball = LEGENDARY },
  { name = "Meloetta",        level = 7, types = { "Normal", "Psychic" }, moves = { "Relic Song", "Psychic" }, guids = { "893ae6" }, model_GUID = "eb62fb", ball = LEGENDARY },
  { name = "Pirouette Meloetta", level = 7, types = { "Normal", "Fighting" },moves = { "Close Combat", "Relic Song" }, guids = { "430037" }, model_GUID = "e83612", spawn_effect="Status Attack", ball = LEGENDARY },
  { name = "Genesect",        level = 7, types = { "Bug", "Steel" },    moves = { "Signal Beam", "Techno Blast" }, guids = { "a0f8a1" }, model_GUID = "da9000" },

  -- Mega evolutions.
  { name = "Mega Audino",     level = 5,    types = { "Fairy", "Normal" }, moves = { "Disarming Voice", "Double-Edge" },  guids = { "0c7909" },                      evoData = { { cost = 0, ball = BLUE, gen = 5, cycle = true, guids = { "b81637" }, model_GUID = "134409" } }, model_GUID = "793f23", spawn_effect="Mega Evolve" },
  { name = "GMax Garbodor",   level = 5,    types = { "Poison" },          moves = { "Malador", "Strike" },               guids = { "43b26e", "a13dc7" },            evoData = { { cost = 0, ball = YELLOW, gen = 5, cycle = true, guids = { "5e6faf", "427e7e" }, model_GUID = "317f1f" } }, model_GUID = "3a0074", offset={x=0, y=1.25, z=0}, custom_scale=0.45 },
}

gen6PokemonData =
{
  -- Gen 6 650-678
  { name = "Chespin",     level = 1, types = { "Grass" },    moves = { "Growl", "Vine Whip" },               guids = { "68e630" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "742ae2" }, model_GUID = "11c320" } }, model_GUID = "bfb1c9" },
  { name = "Quilladin",   level = 3, types = { "Grass" },    moves = { "Pin Missile", "Needle Arm" },        guids = { "001c72", "742ae2" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "4b2bfb", "b1fb69" }, model_GUID = "176400" } }, model_GUID = "11c320" },
  { name = "Chesnaught",  level = 5, types = { "Grass", "Fighting" }, moves = { "Spiky Shield", "Hammer Arm" }, guids = { "9377c5", "4b2bfb", "b1fb69" }, model_GUID = "176400" },
  { name = "Fennekin",    level = 1, types = { "Fire" },     moves = { "Ember", "Howl" },                    guids = { "311f76" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "2b10a5" }, model_GUID = "61a7d9" } }, model_GUID = "95501e", spawn_effect="Status Attack" },
  { name = "Braixen",     level = 3, types = { "Fire" },     moves = { "Fire Spin", "Light Screen" },        guids = { "c5d7f0", "2b10a5" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "9d0714", "ab189f" }, model_GUID = "8879bd" } }, model_GUID = "61a7d9" },
  { name = "Delphox",     level = 5, types = { "Fire", "Psychic" }, moves = { "Mystical Fire", "Psyshock" }, guids = { "cab045", "9d0714", "ab189f" }, model_GUID = "8879bd" },
  { name = "Froakie",     level = 1, types = { "Water" },    moves = { "Quick Attack", "Bubble" },           guids = { "2e6ec8" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "d74138" }, model_GUID = "1c8a04" } }, model_GUID = "8d83d9" },
  { name = "Frogadier",   level = 3, types = { "Water" },    moves = { "Water Pulse", "Bounce" },            guids = { "2ac3d0", "d74138" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "5dbd84", "3bf77c" }, model_GUID = "222e7b", spawn_effect="Status Attack" } }, model_GUID = "1c8a04" },
  { name = "Greninja",    level = 5, types = { "Water", "Dark" }, moves = { "Water Shuriken", "Night Slash" }, guids = { "6e82bc", "5dbd84", "3bf77c" }, model_GUID = "222e7b", spawn_effect="Status Attack", custom_scale=0.8, offset={x=0, y=0, z=-0.1} },
  { name = "Bunnelby",    level = 1, types = { "Normal" },   moves = { "Double Slap", "Leer" },              guids = { "dd60c8" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "fa6708" }, model_GUID = "016627" } }, model_GUID = "0a6a17" },
  { name = "Diggersby",   level = 3, types = { "Normal", "Fighting" },   moves = { "Super Fang", "Dig" },    guids = { "f7395c", "fa6708" }, model_GUID = "016627" },
  { name = "Fletchling",  level = 1, types = { "Flying", "Normal" }, moves = { "Growl", "Peck" },            guids = { "10f8ac" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "d4e15c" }, model_GUID = "516206", spawn_effect="Physical Attack" } }, model_GUID = "1a27c7" },
  { name = "Fletchinder", level = 3, types = { "Fire", "Flying" },   moves = { "Razor Wind", "Ember" },      guids = { "780fa6", "d4e15c" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "562fca", "b7ce61" }, model_GUID = "efd523", spawn_effect="Physical Attack" } }, model_GUID = "516206", spawn_effect="Physical Attack" },
  { name = "Talonflame",  level = 5, types = { "Fire", "Flying" },   moves = { "Steel Wing", "Flare Blitz" }, guids = { "2b826a", "562fca", "b7ce61" }, model_GUID = "efd523", spawn_effect="Physical Attack" },
  { name = "Scatterbug",  level = 1, types = { "Bug" },      moves = { "String Shot", "Tackle" },            guids = { "2fc6c4" },                     evoData = { { cost = 1, ball = PINK, gen = 6, guids = { "4a3c46" }, model_GUID = "a4a4dc" } }, model_GUID = "2e6d23" },
  { name = "Spewpa",      level = 2, types = { "Bug" },      moves = { "Protect", "Harden" },                guids = { "88a3f1", "4a3c46" },           evoData = { { cost = 1, ball = GREEN, gen = 6, guids = { "d4e7b2", "a619c3" }, model_GUID = "4ea111" } }, model_GUID = "a4a4dc" },
  { name = "Vivillon",    level = 3, types = { "Bug", "Flying" }, moves = { "Quiver Dance", "Gust" },        guids = { "68cecb", "d4e7b2", "a619c3" }, model_GUID = "4ea111" },
  { name = "Litleo",      level = 2, types = { "Fire", "Normal" }, moves = { "Noble Roar", "Ember" },        guids = { "8e2e3f" },                     evoData = { { cost = 3, ball = YELLOW, gen = 6, guids = { "318002" }, model_GUID = "4b1422" } }, model_GUID = "61abba", spawn_effect="Physical Attack" },
  { name = "Pyroar",      level = 5, types = { "Fire", "Normal" }, moves = { "Echoed Voice", "Incinerate" }, guids = { "eefb5c", "318002" }, model_GUID = "4b1422", custom_scale=0.85 },
  { name = "Flabebe",     level = 1, types = { "Fairy" },    moves = { "Fairy Wind", "Tackle" },             guids = { "de8ea6" },                     evoData = { { cost = 2, ball = GREEN, gen = 6, guids = { "342092" }, model_GUID = "51e3b5" } }, model_GUID = "84d07d" },
  { name = "Floette",     level = 3, types = { "Fairy" },    moves = { "Misty Terrain", "Magical Leaf" },    guids = { "ed9c70", "342092" },           evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "f389c7", "b23f51" }, model_GUID = "b2407e", spawn_effect="Physical Attack" } }, model_GUID = "51e3b5" },
  { name = "Florges",     level = 4, types = { "Fairy" },    moves = { "Petal Dance", "Moonblast" },         guids = { "cd9f20", "f389c7", "b23f51" }, model_GUID = "b2407e", spawn_effect="Physical Attack" },
  { name = "Skiddo",      level = 2, types = { "Grass" },    moves = { "Take Down", "Vine Whip" },           guids = { "0d26ba" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "982e96" }, model_GUID = "88d0b0", spawn_effect="Status Attack" } }, model_GUID = "c613ad" },
  { name = "Gogoat",      level = 4, types = { "Grass" },    moves = { "Aerial Ace", "Horn Leech" },         guids = { "2ab034", "982e96" }, model_GUID = "88d0b0", spawn_effect="Status Attack" },
  { name = "Pancham",     level = 2, types = { "Fighting" }, moves = { "Arm Thrust", "Work Up" },            guids = { "bf3855" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "cf6845" }, model_GUID = "bc9f87", spawn_effect="Status Attack" } }, model_GUID = "0c4abd" },
  { name = "Pangoro",     level = 4, types = { "Fighting", "Dark" }, moves = { "Circle Throw", "Night Slash" },      guids = { "068e59", "cf6845" }, model_GUID = "bc9f87", spawn_effect="Status Attack", custom_scale=0.8 },
  { name = "Furfrou",     level = 3, types = { "Normal" },   moves = { "Retaliate", "Charm" },               guids = { "e7d9dd" }, model_GUID = "86252d" },
  { name = "Espurr",      level = 2, types = { "Psychic" },  moves = { "Disarming Voice", "Confusion" },     guids = { "53beaa" },                     evoData = { { cost = 1, ball = GREEN, gen = 6, guids = { "bb2e78" }, model_GUID = "c2df10" }, 
                                                                                                                                                                   { cost = 1, ball = GREEN, gen = 6, guids = { "8e85d5" }, model_GUID = "3357e1" } }, 
                                                                                                                                                       model_GUID = "11f232" },
  { name = "Meowstic (F)", level = 3, types = { "Psychic" }, moves = { "Charm", "Psybeam" },                 guids = { "15d501", "8e85d5", }, model_GUID = "3357e1", ball = GREEN }, -- Female
  { name = "Meowstic (M)", level = 3, types = { "Psychic" }, moves = { "Sucker Punch", "Psybeam" },          guids = { "519e39", "bb2e78" }, model_GUID = "c2df10", ball = GREEN },  -- Male
  -- Gen 6 679-700
  { name = "Honedge",     level = 3, types = { "Steel", "Ghost" }, moves = { "Swords Dance", "Fury Cutter" }, guids = { "fdfef9" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "889a70" }, model_GUID = "429a84", spawn_effect="Physical Attack" } }, model_GUID = "db85f6", spawn_effect="Physical Attack" },
  { name = "Doublade",    level = 5, types = { "Steel", "Ghost" }, moves = { "Shadow Sneak", "Slash" },      guids = { "7456e9", "889a70" },           evoData = { { cost = 1, ball = RED, gen = 6, guids = { "a22c4a", "cc32a1" }, model_GUID = "eed99a", idle_effect="Shield Idle", run_effect="Shield Move", spawn_effect="Shield Stance", faint_effect="Shield Faint" }, 
                                                                                                                                                                   { cost = 1, ball = RED, gen = 6, guids = { "52ba90", "f7ff82" }, model_GUID = "a6b120", spawn_effect="Blade Stance" } },
                                                                                                                                                       model_GUID = "429a84", spawn_effect="Physical Attack" },
  { name = "Blade Aegislash", level = 6, types = { "Steel", "Ghost" }, moves = { "Sacred Sword", "Iron Head" },     guids = { "94735b", "52ba90", "f7ff82" }, model_GUID = "a6b120", spawn_effect="Blade Stance", ball = RED },                                                                                     -- Sword Version
  { name = "Shield Aegislash", level = 6, types = { "Steel", "Ghost" }, moves = { "Sacred Sword", "King's Shield" }, guids = { "adf3ec", "a22c4a", "cc32a1" }, model_GUID = "eed99a", idle_effect="Shield Idle", run_effect="Shield Move", spawn_effect="Shield Stance", faint_effect="Shield Faint", ball = RED }, -- Shield Version
  { name = "Spritzee",    level = 3, types = { "Fairy" },    moves = { "Fairy Wind", "Attract" },            guids = { "ee6a18" },                     evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "b0e63a" }, model_GUID = "c86d86" } }, model_GUID = "24fb10" },
  { name = "Aromatisse",  level = 4, types = { "Fairy" },    moves = { "Moonblast", "Heal Pulse" },          guids = { "ee7504", "b0e63a" }, model_GUID = "c86d86" },
  { name = "Swirlix",     level = 3, types = { "Fairy" },    moves = { "Play Nice", "Fairy Wind" },          guids = { "bfc548" },                     evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "45a974" }, model_GUID = "f15bb3" } }, model_GUID = "f67993" },
  { name = "Slurpuff",    level = 4, types = { "Fairy" },    moves = { "Cotton Guard", "Play Rough" },       guids = { "5fecfe", "45a974" }, model_GUID = "f15bb3" },
  { name = "Inkay",       level = 2, types = { "Dark", "Psychic" }, moves = { "Hypnosis", "Peck" },          guids = { "c8dc46" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "0dca90" }, model_GUID = "76d4d2" } }, model_GUID = "95c70d" },
  { name = "Malamar",     level = 4, types = { "Dark", "Psychic" }, moves = { "Superpower", "Foul Play" },   guids = { "8bd2d5", "0dca90" }, model_GUID = "76d4d2" },
  { name = "Binacle",     level = 3, types = { "Rock", "Water" }, moves = { "Shell Smash", "Clamp" },        guids = { "2c77cd" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "3ed28a" }, model_GUID = "7acdd8" } }, model_GUID = "d68ddb", spawn_effect="Physical Attack" },
  { name = "Barbaracle",  level = 4, types = { "Rock", "Water" }, moves = { "Razor Shell", "Cross Chop" },   guids = { "e9dd78", "c6fcdc" }, model_GUID = "7acdd8" },
  { name = "Skrelp",      level = 3, types = { "Poison", "Water" }, moves = { "Poison Tail", "Water Gun" },  guids = { "183099" },                     evoData = { { cost = 3, ball = RED, gen = 6, guids = { "661d8b" }, model_GUID = "2c5c3c" } }, model_GUID = "47af48" },
  { name = "Dragalge",    level = 6, types = { "Poison", "Dragon" }, moves = { "Dragon Pulse", "Hydro Pump" }, guids = { "3a948e", "661d8b" }, model_GUID = "2c5c3c" },
  { name = "Clauncher",   level = 3, types = { "Water" },    moves = { "Aqua Jet", "Vise Grip" },            guids = { "913807" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "63a317" }, model_GUID = "3bdfca" } }, model_GUID = "7d382e" },
  { name = "Clawitzer",   level = 5, types = { "Water" },    moves = { "Dark Pulse", "Crabhammer" },         guids = { "b296af", "63a317" }, model_GUID = "3bdfca" },
  { name = "Helioptile",  level = 3, types = { "Electric", "Normal" }, moves = { "Thunder Shock", "Quick Attack" }, guids = { "8f08fa" },                     evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "50ff69" }, model_GUID = "7d0f27" } }, model_GUID = "6c28be" },
  { name = "Heliolisk",   level = 4, types = { "Electric", "Normal" }, moves = { "Razor Wind", "Volt Switch" }, guids = { "817046", "50ff69" }, model_GUID = "7d0f27" },
  { name = "Tyrunt",      level = 4, types = { "Rock", "Dragon" }, moves = { "Stomp", "Bite" },              guids = { "fdb796" },                     evoData = { { cost = 2, ball = RED, gen = 6, guids = { "fc4eb1" }, model_GUID = "e8c337", spawn_effect="Status Attack" } }, model_GUID = "f6e97c" },
  { name = "Tyrantrum",   level = 6, types = { "Rock", "Dragon" }, moves = { "Head Smash", "Dragon Claw" },  guids = { "784474", "fc4eb1" }, model_GUID = "e8c337", spawn_effect="Status Attack", custom_scale=0.65 },
  { name = "Amaura",      level = 4, types = { "Rock", "Ice" }, moves = { "Take Down", "Icy Wind" },         guids = { "43451f" },                     evoData = { { cost = 2, ball = RED, gen = 6, guids = { "bba475" }, model_GUID = "17494e", spawn_effect="Physical Attack" } }, model_GUID = "73d866" },
  { name = "Aurorus",     level = 6, types = { "Rock", "Ice" }, moves = { "Aurora Beam", "Ancient Power" },  guids = { "4170ac", "bba475" }, model_GUID = "17494e", spawn_effect="Physical Attack", custom_scale=0.8 },
  { name = "Sylveon",     level = 5, types = { "Fairy" },    moves = { "Moonblast", "Swift" },               guids = { "8de192", "7ea880" }, model_GUID = "381a03" },
  -- Gen 6 701-721
  { name = "Hawlucha",    level = 3, types = { "Fighting", "Flying" }, moves = { "Hone Claws", "Flying Press" }, guids = { "ecc5ed" }, model_GUID = "c7140e", spawn_effect="Status Attack" },
  { name = "Dedenne",     level = 2, types = { "Electric", "Fairy" }, moves = { "Charm", "Nuzzle" },         guids = { "251e0f" }, model_GUID = "f90863" },
  { name = "Carbink",     level = 3, types = { "Rock", "Fairy" }, moves = { "Stealth Rock", "Sharpen" },     guids = { "bd24b2" }, model_GUID = "9c0cd8", spawn_effect="Physical Attack" },
  { name = "Goomy",       level = 2, types = { "Dragon" },   moves = { "Absorb", "Bubble" },                 guids = { "525dda" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "2a9ba9" }, model_GUID = "1ac031" } }, model_GUID = "07df6f" },
  { name = "Sliggoo",     level = 4, types = { "Dragon" },   moves = { "Muddy Water", "Dragon Pulse" },      guids = { "86de80", "2a9ba9" },           evoData = { { cost = 3, ball = RED, gen = 6, guids = { "84a03d", "980868" }, model_GUID = "35c5e9", spawn_effect="Status Attack" } }, model_GUID = "1ac031" },
  { name = "Goodra",      level = 7, types = { "Dragon" },   moves = { "Power Whip", "Outrage" },            guids = { "4010f0", "84a03d", "980868" }, model_GUID = "35c5e9", spawn_effect="Status Attack" },
  { name = "Klefki",      level = 3, types = { "Steel", "Fairy" }, moves = { "Metal Sound", "Fairy Wind" },  guids = { "72532e" }, model_GUID = "4b6f52", spawn_effect="Physical Attack" },
  { name = "Phantump",    level = 3, types = { "Ghost", "Grass" }, moves = { "Feint Attack", "Curse" },      guids = { "c97328" },                     evoData = { { cost = 1, ball = YELLOW, gen = 6, guids = { "e3f03d" } } }, model_GUID = "fc0113" },
  { name = "Trevenant",   level = 4, types = { "Ghost", "Grass" }, moves = { "Wood Hammer", "Phantom Force" }, guids = { "eea302", "e3f03d" }, model_GUID = "4a56ba" },
  { name = "Pumpkaboo",   level = 3, types = { "Ghost", "Grass" }, moves = { "Bullet Seed", "Astonish" },    guids = { "a2221a" },                     evoData = { { cost = 1, ball = YELLOW, gen = 6, guids = { "607cf8" }, model_GUID = "16c782" } }, model_GUID = "c5c891" },
  { name = "Gourgeist",   level = 4, types = { "Ghost", "Grass" }, moves = { "Seed Bomb", "Explosion" },     guids = { "0bae76", "607cf8" }, model_GUID = "16c782" },
  { name = "Bergmite",    level = 3, types = { "Ice" },      moves = { "Icy Wind", "Harden" },               guids = { "cc9804" },                     evoData = { { cost = 2, ball = RED, gen = 6, guids = { "9c5313" }, model_GUID = "fc938c", spawn_effect="Status Attack" }, 
                                                                                                                                                                   { cost = 2, ball = RED, gen = 8, guids = { "2edcdb" } } }, 
                                                                                                                                                       model_GUID = "517919", spawn_effect="Physical Attack" },
  { name = "Avalugg",     level = 5, types = { "Ice" },      moves = { "Skull Bash", "Avalanche" },          guids = { "3b9191", "9c5313" }, model_GUID = "fc938c", spawn_effect="Status Attack", custom_scale=0.28, offset={x=0, y=0, z=-0.15} },
  { name = "Noibat",      level = 3, types = { "Flying", "Dragon" }, moves = { "Razor Wind", "Bite" },       guids = { "eaed3f" },                     evoData = { { cost = 3, ball = RED, gen = 6, guids = { "350e64" }, model_GUID = "212e94", spawn_effect="Status Attack" } }, model_GUID = "f0c07f" },
  { name = "Noivern",     level = 6, types = { "Flying", "Dragon" }, moves = { "Dragon Pulse", "Air Slash" }, guids = { "1b1569", "350e64" }, model_GUID = "212e94", spawn_effect="Status Attack" },
  { name = "Xerneas",     level = 7, types = { "Fairy" },    moves = { "Moonblast", "Megahorn" },            guids = { "ef3078" }, model_GUID = "d0ee6e" },
  { name = "Yveltal",     level = 7, types = { "Dark", "Flying" }, moves = { "Dark Pulse", "Oblivion Wing" },guids = { "341630" }, model_GUID = "c48f86", spawn_effect="Status Attack" },
  { name = "10% Zygarde", level = 7, types = { "Dragon", "Ground" }, moves = { "Land's Wrath", "Glare" },    guids = { "84fad7" },                     evoData = { { cost = "Zygarde Cube", ball = LEGENDARY, gen = 6, guids = { "eae5f7" }, model_GUID = "fd9300", spawn_effect="Status Attack" } }, model_GUID = "c0079c", spawn_effect="Status Attack" },   -- 10%
  { name = "50% Zygarde", level = 7, types = { "Dragon", "Ground" }, moves = { "Dragon Breath", "Earthquake" }, guids = { "eae5f7" },                     evoData = { { cost = "Zygarde Cube", ball = LEGENDARY, gen = 6, guids = { "ea5e61" }, model_GUID = "d70d3c", spawn_effect="Physical Attack" } }, model_GUID = "fd9300", spawn_effect="Status Attack", offset={x=0, y=1.0, z=0}, idle_effect="Run" }, -- 50%
  { name = "Complete Zygarde", level = 8, types = { "Dragon", "Ground" }, moves = { "Extreme Speed", "Outrage" }, guids = { "ea5e61" }, model_GUID = "d70d3c", spawn_effect="Physical Attack", custom_scale=0.4 },                                                                                                                                                                    -- Complete
  { name = "Diancie",     level = 7, types = { "Rock", "Fairy" }, moves = { "Diamond Storm", "Light Screen" }, guids = { "dfd970" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 5, cycle = true, guids = { "9addeb" }, model_GUID = "33befa", spawn_effect="Special Attack" } }, model_GUID = "e25fa5" },
  { name = "Hoopa",       level = 7, types = { "Psychic", "Ghost" },  moves = { "Hyperspace Hole", "Phantom Force" }, guids = { "2dc848" },                     evoData = { { cost = "Prison Bottle", ball = LEGENDARY, gen = 6, cycle = true, guids = { "59d7f4" }, model_GUID = "434623", custom_scale=0.7 } }, model_GUID = "ef60ef", spawn_effect="Status Attack" },
  { name = "Unbound Hoopa",level = 7, types = { "Psychic", "Dark" }, moves = { "Hyperspace Fury", "Psychic" }, guids = { "59d7f4" },                     evoData = { { cost = 0, ball = LEGENDARY, gen = 6, cycle = true, guids = { "2dc848" }, model_GUID = "ef60ef", spawn_effect="Status Attack" } }, model_GUID = "434623", custom_scale=0.7 },
  { name = "Volcanion",   level = 7, types = { "Fire", "Water" }, moves = { "Steam Eruption", "Incinerate" }, guids = { "b4f0b0" }, model_GUID = "86e6c6" },

  -- Mega evolutions.
  { name = "Mega Diancie",level = 8, types = { "Rock", "Fairy" },     moves = { "Moonblast", "Stone Edge" },          guids = { "9addeb" },                     evoData = { { cost = 0, ball = LEGENDARY, gen = 5, cycle = true, guids = { "dfd970" }, model_GUID = "e25fa5" } }, model_GUID = "33befa", spawn_effect="Special Attack" },
}

gen7PokemonData =
{
  -- Gen 7 722-750
  { name = "Rowlet",       level = 1, types = { "Grass", "Flying" },    moves = { "Leafage", "Growl" },        guids = { "df9287" }, model_GUID = "494cbe",           evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "1c84d5" }, model_GUID = "7a6739" } } },
  { name = "Dartrix",      level = 3, types = { "Grass", "Flying" },    moves = { "Razor Leaf", "Peck" },      guids = { "71d957", "1c84d5" }, model_GUID = "7a6739", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "2416c8", "9bef15" }, model_GUID = "d35cbf", spawn_effect="Status Attack", offset={x=0, y=0.115, z=0} }, 
                                                                                                                                                                                  { cost = 2, ball = RED, gen = 8, guids = { "cf7b80", "5ada77" } } } }, 
  { name = "Decidueye",    level = 5, types = { "Grass", "Ghost" }, moves = { "Spirit Shackle", "Leaf Blade" }, guids = { "d50f86", "2416c8", "9bef15" }, model_GUID = "d35cbf", spawn_effect="Status Attack", offset={x=0, y=0.115, z=0} },
  { name = "Litten",       level = 1, types = { "Fire" },     moves = { "Ember", "Growl" },                    guids = { "03a2c1" }, model_GUID = "bc40dd", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "1ae631" }, model_GUID = "84c6db" } } },
  { name = "Torracat",     level = 3, types = { "Fire" },     moves = { "Fury Swipes", "Fire Fang" },          guids = { "4d7ec6", "1ae631" }, model_GUID = "84c6db", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "38e353", "45ba93" }, model_GUID = "bc10fb" } } },
  { name = "Incineroar",   level = 5, types = { "Fire", "Dark" }, moves = { "Flare Blitz", "Darkest Lariat" }, guids = { "3f1566", "38e353", "45ba93" }, model_GUID = "bc10fb" },
  { name = "Popplio",      level = 1, types = { "Water" },    moves = { "Water Gun", "Growl" },                guids = { "9364c2" }, model_GUID = "c96d82", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "454874" }, model_GUID = "0aa113" } } },
  { name = "Brionne",      level = 3, types = { "Water" },    moves = { "Icy Wind", "Aqua Jet" },              guids = { "d3529d", "454874" }, model_GUID = "0aa113", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "d62cf2", "4026a1" }, model_GUID = "bd9d9f" } } },
  { name = "Primarina",    level = 5, types = { "Water", "Fairy" }, moves = { "Moonblast", "Sparkling Aria" }, guids = { "de4d6a", "d62cf2", "4026a1" }, model_GUID = "bd9d9f", offset={x=0, y=1.0, z=0.03}, idle_effect="Run" },
  { name = "Pikipek",      level = 1, types = { "Flying", "Normal" }, moves = { "Growl", "Peck" },             guids = { "441f65" }, model_GUID = "b81a90", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "5e7eae" }, model_GUID = "1d959d" } } },
  { name = "Trumbeak",     level = 3, types = { "Flying", "Normal" }, moves = { "Rock Blast", "Echoed Voice" }, guids = { "c5f660", "5e7eae" }, model_GUID = "1d959d", evoData = { { cost = 1, ball = YELLOW, gen = 7, guids = { "8f7253", "4fda79" }, model_GUID = "2c6bc3" } } },
  { name = "Toucannon",    level = 4, types = { "Flying", "Normal" }, moves = { "Beak Blast", "Hyper Voice" }, guids = { "a9acd3", "8f7253", "4fda79" }, model_GUID = "2c6bc3" },
  { name = "Yungoos",      level = 1, types = { "Normal" },   moves = { "Sand Attack", "Tackle" },             guids = { "195460" }, model_GUID = "d77420", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "fa17b3" }, model_GUID = "902af6" } } },
  { name = "Gumshoos",     level = 3, types = { "Normal" },   moves = { "Super Fang", "Crunch" },              guids = { "28ee0f", "fa17b3" }, model_GUID = "902af6" },
  { name = "Grubbin",      level = 1, types = { "Bug" },      moves = { "Vise Grip", "String Shot" },          guids = { "505be7" }, model_GUID = "094700", evoData = { { cost = 2, ball = GREEN, gen = 7, guids = { "545c8d" }, model_GUID = "f5e6f0" } } },
  { name = "Charjabug",    level = 3, types = { "Bug", "Electric" }, moves = { "Mud-Slap", "Bug Bite" },       guids = { "918808", "545c8d" }, model_GUID = "f5e6f0", evoData = { { cost = 1, ball = YELLOW, gen = 7, guids = { "be9f22", "59664c" }, model_GUID = "d539ed" } } },
  { name = "Vikavolt",     level = 4, types = { "Bug", "Electric" }, moves = { "Zap Cannon", "X-Scissor" },    guids = { "8ee928", "be9f22", "59664c" }, model_GUID = "d539ed" },
  { name = "Crabrawler",   level = 3, types = { "Fighting" }, moves = { "Rock Smash", "Crabhammer" },          guids = { "ff2869" }, model_GUID = "cc10c3", spawn_effect="Physical Attack", evoData = { { cost = 1, ball = YELLOW, gen = 7, guids = { "7021bf" }, model_GUID = "bd1445" } } },
  { name = "Crabominable", level = 4, types = { "Fighting", "Ice" }, moves = { "Dynamic Punch", "Ice Hammer" },guids = { "1689aa", "7021bf" }, model_GUID = "bd1445" },
  { name = "Baile Oricorio", level = 3, types = { "Fire", "Flying" }, moves = { "Feather Dance", "Rev. Dance Fire" },  guids = { "bafd29" }, model_GUID = "f5fc3a", spawn_effect="Physical Attack", ball = BLUE },
  { name = "Pa'u Oricorio",level = 3, types = { "Psychic", "Flying" }, moves = { "Feather Dance", "Rev. Dance Psychic" }, guids = { "9f5d17" }, model_GUID = "19413b", spawn_effect="Physical Attack", ball = BLUE },
  { name = "Pom-Pom Oricorio", level = 3, types = { "Electric", "Flying" }, moves = { "Feather Dance", "Rev. Dance Electric" }, guids = { "f22afb" }, model_GUID = "e5b28a", spawn_effect="Physical Attack", ball = BLUE },
  { name = "Sensu Oricorio", level = 3, types = { "Ghost", "Flying" },  moves = { "Feather Dance", "Rev. Dance Ghost" }, guids = { "a16f96" }, model_GUID = "a5d034", spawn_effect="Physical Attack", ball = BLUE },
  { name = "Cutiefly",     level = 1, types = { "Bug", "Fairy" }, moves = { "Fairy Wind", "Absorb" },          guids = { "ffc7e4" }, model_GUID = "7703b3", evoData = { { cost = 2, ball = GREEN, gen = 7, guids = { "aa05a4" }, model_GUID = "a1c941", spawn_effect="Physical Attack" } } },
  { name = "Ribombee",     level = 3, types = { "Bug", "Fairy" }, moves = { "Dazzling Gleam", "Pollen Puff" }, guids = { "aa05a4", "97144c" }, model_GUID = "a1c941", spawn_effect="Physical Attack" },
  { name = "Rockruff",     level = 2, types = { "Rock" },     moves = { "Howl", "Bite" },                      guids = { "e4bb33" }, model_GUID = "aaf680", evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "802af7" }, model_GUID = "be2395" },
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 7, guids = { "5411a7" }, model_GUID = "226b04" },
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 7, guids = { "ff8dda" }, model_GUID = "5e3a9d" } } },
  { name = "Dusk Lycanroc", level = 4, types = { "Rock" },    moves = { "Crush Claw", "Accelerock" },          guids = { "34164a", "802af7" }, model_GUID = "be2395", ball = YELLOW }, -- Orange
  { name = "Midday Lycanroc", level = 4, types = { "Rock" },  moves = { "Sucker Punch", "Accelerock" },        guids = { "9ecf49", "5411a7" }, model_GUID = "226b04", ball = YELLOW }, -- Brown
  { name = "Midnight Lycanroc", level = 4, types = { "Rock" },moves = { "Rock Slide", "Counter" },             guids = { "9af49a", "ff8dda" }, model_GUID = "5e3a9d", ball = YELLOW }, -- Red
  { name = "Wishiwashi",   level = 4, types = { "Water" },    moves = { "Beat Up", "Brine" },                  guids = { "acfcee" }, model_GUID = "7da1df", custom_scale = 0.35 },
  { name = "Mareanie",     level = 3, types = { "Poison", "Water" }, moves = { "Wide Guard", "Toxic Spikes" }, guids = { "45598a" }, model_GUID = "437e25", spawn_effect="Physical Attack", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "bd3b27" }, model_GUID = "0abc27" } } },
  { name = "Toxapex",      level = 5, types = { "Poison", "Water" }, moves = { "Bane. Bunker", "Poison Jab" }, guids = { "e0c877", "bd3b27" }, model_GUID = "0abc27" },
  { name = "Mudbray",      level = 2, types = { "Ground" },   moves = { "Double Kick", "Mud-Slap" },           guids = { "482345" }, model_GUID = "d128ab", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "c06039" }, model_GUID = "28b051", spawn_effect="Physical Attack" } } },
  { name = "Mudsdale",     level = 4, types = { "Ground" },   moves = { "H. Horsepower", "Stomp" },            guids = { "d66f99", "c06039" }, model_GUID = "28b051", spawn_effect="Physical Attack", custom_scale=0.5, offset={x=0, y=0, z=-0.05} },

  -- Gen 7 751-775
  { name = "Dewpider",     level = 1, types = { "Water", "Bug" }, moves = { "Infestation", "Bubble" },         guids = { "7e97f0" }, model_GUID = "51f953", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "ff2e27" }, model_GUID = "049687", spawn_effect="Physical Attack", custom_scale=0.7 } } },
  { name = "Araquanid",    level = 3, types = { "Water", "Bug" }, moves = { "Bubble Beam", "Lunge" },          guids = { "7fe018", "ff2e27" }, model_GUID = "049687", spawn_effect="Physical Attack", custom_scale=0.7 },
  { name = "Fomantis",     level = 2, types = { "Grass" },    moves = { "Growth", "Leafage" },                 guids = { "e2dcdc" }, model_GUID = "7b424f", spawn_effect="Physical Attack", evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "09b260" }, model_GUID = "8cd3d5", spawn_effect="Physical Attack" } } },
  { name = "Lurantis",     level = 4, types = { "Grass" },    moves = { "Petal Blizzard", "Slash" },           guids = { "d98b01", "09b260" }, model_GUID = "8cd3d5", spawn_effect="Physical Attack" },
  { name = "Morelull",     level = 1, types = { "Grass", "Fairy" }, moves = { "Astonish", "Absorb" },          guids = { "b8f494" }, model_GUID = "81ff79", evoData = { { cost = 2, ball = GREEN, gen = 7, guids = { "e803ee" }, model_GUID = "5430cf" } } },
  { name = "Shiinotic",    level = 3, types = { "Grass", "Fairy" }, moves = { "Sleep Powder", "Moonblast" },   guids = { "24d418", "e803ee" }, model_GUID = "5430cf" },
  { name = "Salandit",     level = 2, types = { "Poison", "Fire" }, moves = { "Ember", "Smog" },               guids = { "433a74" }, model_GUID = "b90790", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "f517cd" }, model_GUID = "29570d" } } },
  { name = "Salazzle",     level = 4, types = { "Poison", "Fire" }, moves = { "Venom Drench", "Flame Burst" }, guids = { "73d1a4", "f517cd" }, model_GUID = "29570d" },
  { name = "Stufful",      level = 2, types = { "Normal", "Fighting" }, moves = { "Baby-Doll Eyes", "Tackle" }, guids = { "6e26ce" }, model_GUID = "556b6f", spawn_effect="Physical Attack", evoData = { { cost = 1, ball = BLUE, gen = 7, guids = { "91caa3" }, model_GUID = "7d4606", spawn_effect="Status Attack" } } },
  { name = "Bewear",       level = 3, types = { "Normal", "Fighting" }, moves = { "Take Down", "Hammer Arm" }, guids = { "c3a8f1", "91caa3" }, model_GUID = "7d4606", spawn_effect="Status Attack", custom_scale=0.9 },
  { name = "Bounsweet",    level = 2, types = { "Grass" },    moves = { "Rapid Spin", "Play Nice" },           guids = { "a96b34" }, model_GUID = "631d93", evoData = { { cost = 1, ball = GREEN, gen = 7, guids = { "d564cd" }, model_GUID = "3d1e61" } } },
  { name = "Steenee",      level = 3, types = { "Grass" },    moves = { "Double Slap", "Magical Leaf" },       guids = { "e5f221", "d564cd" }, model_GUID = "3d1e61", evoData = { { cost = 1, ball = BLUE, gen = 7, guids = { "e8a54a", "9d1fcf" }, model_GUID = "496a15" } } },
  { name = "Tsareena",     level = 4, types = { "Grass" },    moves = { "Trop Kick", "Stomp" },                guids = { "376bc7", "e8a54a", "9d1fcf" }, model_GUID = "496a15" },
  { name = "Comfey",       level = 3, types = { "Fairy" },    moves = { "Petal Dance", "Wrap" },               guids = { "c3291e" }, model_GUID = "91d031" },
  { name = "Oranguru",     level = 4, types = { "Normal", "Psychic" }, moves = { "Zen Headbutt", "Foul Play" },guids = { "82400d" }, model_GUID = "474004", custom_scale=0.8, offset={x=0, y=0, z=-0.08} },
  { name = "Passimian",    level = 4, types = { "Fighting" }, moves = { "Close Combat", "Thrash" },            guids = { "73f4a7" }, model_GUID = "afbf79", custom_scale=0.9, offset={x=0, y=0, z=0.1} },
  { name = "Wimpod",       level = 2, types = { "Bug", "Water" }, moves = { "Struggle Bug" },                  guids = { "ce812c" }, model_GUID = "3b177b", evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "0042df" }, model_GUID = "f4e89c" } } },
  { name = "Golisopod",    level = 4, types = { "Bug", "Water" }, moves = { "First Impression", "Razor Shell" }, guids = { "3b9008", "0042df" }, model_GUID = "f4e89c" },
  { name = "Sandygast",    level = 4, types = { "Ghost", "Ground" }, moves = { "Sand Tomb", "Sandstorm" },     guids = { "cc4a08" }, model_GUID = "c2f276", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "263266" }, model_GUID = "d2d150" } } },
  { name = "Palossand",    level = 6, types = { "Ghost", "Ground" }, moves = { "Earth Power", "Iron Defense" }, guids = { "58aab6", "263266" }, model_GUID = "d2d150", custom_scale=0.6 },
  { name = "Pyukumuku",    level = 3, types = { "Water" },    moves = { "Safeguard", "Toxic" },                guids = { "6e7540" }, model_GUID = "22fc93" },
  { name = "Type: Null",   level = 4, types = { "Normal" },   moves = { "Crush Claw", "Aerial Ace" },          guids = { "814ff2" }, model_GUID = "f0496f", custom_scale=0.8, offset={x=0, y=0, z=-0.06}, evoData = { { cost = 2, ball = RED, gen = 7, guids = { "7a7849" }, model_GUID = "7d0a3d" } } },
  { name = "Silvally",     level = 6, types = { "Normal" },   moves = { "Multi-Attack", "Tri Attack" },        guids = { "458263", "7a7849" }, model_GUID = "7d0a3d" },
  { name = "Red Core Minior", level = 4, types = { "Rock", "Flying" }, moves = { "Cosmic Power", "Swift" },    guids = { "6d5742" }, model_GUID = "f9ea82", ball = BLUE }, -- Pink
  { name = "Meteor Minior",level = 4, types = { "Rock", "Flying" }, moves = { "Shell Smash", "Power Gem" },    guids = { "6c5dae" }, model_GUID = "1bfee7", ball = BLUE }, -- Brown
  { name = "Komala",       level = 6, types = { "Normal" },   moves = { "Wood Hammer", "Yawn" },               guids = { "248d7f" }, model_GUID = "c45c5f", spawn_effect="Physical Attack" },

  -- Gen 7 776-809
  { name = "Turtonator",   level = 5, types = { "Fire", "Dragon" }, moves = { "Dragon Pulse", "Overheat" },    guids = { "7497e6" }, model_GUID = "4c274a", spawn_effect="Status Attack", custom_scale=0.6 },
  { name = "Togedemaru",   level = 3, types = { "Electric", "Steel" }, moves = { "Zing Zap", "Rollout" },      guids = { "1778b2" }, model_GUID = "e7484b" },
  { name = "Mimikyu",      level = 4, types = { "Ghost", "Fairy" }, moves = { "Play Rough", "Mimic" },         guids = { "ba3859" }, model_GUID = "48082a" },
  { name = "Bruxish",      level = 4, types = { "Water", "Psychic" }, moves = { "Psychic Fangs", "Crunch" },   guids = { "9d31bb" }, model_GUID = "70f19d" },
  { name = "Drampa",       level = 5, types = { "Dragon", "Normal" }, moves = { "Dragon Rage", "Hyper Voice" }, guids = { "c2e75e" }, model_GUID = "d1667b", custom_scale=0.7 },
  { name = "Dhelmise",     level = 5, types = { "Ghost", "Grass" }, moves = { "Power Whip", "Anchor Shot" },   guids = { "2e8c2e" }, model_GUID = "af1f36", spawn_effect="Physical Attack" },
  { name = "Jangmo-o",     level = 2, types = { "Dragon" },   moves = { "Headbutt", "Screech" },               guids = { "9c4545" }, model_GUID = "c693f2", evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "20c6cc" }, model_GUID = "54dfcc" } } },
  { name = "Hakamo-o",     level = 4, types = { "Dragon", "Fighting" }, moves = { "Dragon Dance", "Sky Uppercut" },    guids = { "3671cc", "20c6cc" }, model_GUID = "54dfcc", evoData = { { cost = 3, ball = RED, gen = 7, guids = { "6377a7", "79e0d1" }, model_GUID = "cbb201", spawn_effect="Status Attack" } } },
  { name = "Kommo-o",      level = 7, types = { "Dragon", "Fighting" }, moves = { "Clanging Scales", "Close Combat" }, guids = { "51cc27", "6377a7", "79e0d1" }, model_GUID = "cbb201", spawn_effect="Status Attack" },
  { name = "Tapu Koko",    level = 7, types = { "Electric", "Fairy" }, moves = { "Nature's Madness", "Spark" }, guids = { "c5bd66" }, model_GUID = "0cf91d" },
  { name = "Tapu Lele",    level = 7, types = { "Psychic", "Fairy" }, moves = { "Nature's Madness", "Psybeam" }, guids = { "c2d946" }, model_GUID = "ff3a30", spawn_effect="Physical Attack" },
  { name = "Tapu Bulu",    level = 7, types = { "Grass", "Fairy" }, moves = { "Nature's Madness", "Horn Leech" }, guids = { "d099d1" }, model_GUID = "c5f3b1", spawn_effect="Status Attack" },
  { name = "Tapu Fini",    level = 7, types = { "Water", "Fairy" }, moves = { "Nature's Madness", "Water Pulse" }, guids = { "573f6c" }, model_GUID = "0ade9c", spawn_effect="Status Attack" },
  { name = "Cosmog",       level = 2, types = { "Psychic" },  moves = { "Teleport", "Splash" },                guids = { "4067b4" }, model_GUID = "1ba3f7", spawn_effect="Physical Attack", evoData = { { cost = 3, ball = YELLOW, gen = 7, guids = { "dd8d38" }, model_GUID = "02834c" } } },
  { name = "Cosmoem",      level = 5, types = { "Psychic" },  moves = { "Cosmic Power", "Teleport" },          guids = { "2d4e82", "dd8d38" }, model_GUID = "02834c", evoData = { { cost = 2, ball = LEGENDARY, gen = 7, guids = { "2c0206" }, model_GUID = "20b6ae", spawn_effect="Status Attack", custom_scale=0.7 }, 
                                                                                                                                                                                  { cost = 2, ball = LEGENDARY, gen = 7, guids = { "5228d9" }, model_GUID = "aedf14", custom_scale=0.7 } } },
  { name = "Solgaleo",     level = 7, types = { "Psychic", "Steel" },  moves = { "Zen Headbutt", "Sunsteel Strike" },   guids = { "2337ba", "5228d9" }, model_GUID = "aedf14", custom_scale=0.4, offset={x=0, y=0, z=-0.05}, evoData = { { cost = "N-Solarizer", ball = LEGENDARY, gen = 7, cycle = true, guids = { "c65377", "d63d82" }, model_GUID = "9aed20", custom_scale=0.7 } } },
  { name = "Dusk Mane Necrozma",level = 7, types = { "Psychic", "Steel" }, moves = { "Sunsteel Strike", "Prism. Laser" }, guids = { "c65377", "d63d82" }, model_GUID = "9aed20", custom_scale=0.3, offset={x=0, y=0, z=-0.02}, evoData = { { cost = 0, ball = LEGENDARY, gen = 7, cycle = true, guids = { "2337ba", "5228d9" }, model_GUID = "aedf14", custom_scale=0.7 } } }, -- Dusk Mane (for Solgaleo)
  { name = "Lunala",       level = 7, types = { "Psychic", "Ghost" },  moves = { "Moongeist Beam", "Dream Eater" },     guids = { "d118b4", "2c0206" }, model_GUID = "20b6ae", spawn_effect="Status Attack", custom_scale=0.7, evoData = { { cost = "N-Lunarizer", ball = LEGENDARY, gen = 7, cycle = true, guids = { "2f92e5", "b01111" }, model_GUID = "94ea0e", spawn_effect="Status Attack", custom_scale=0.7 } } },
  { name = "Dawn Wings Necrozma",level = 7, types = { "Psychic", "Ghost" },  moves = { "Moongeist Beam", "Prism. Laser" },guids = { "2f92e5", "b01111" }, model_GUID = "94ea0e", spawn_effect="Status Attack", custom_scale=0.7, evoData = { { cost = 0, ball = LEGENDARY, gen = 7, cycle = true, guids = { "d118b4", "2c0206" }, model_GUID = "20b6ae", spawn_effect="Status Attack", custom_scale=0.7 } } },  -- Dawn Wings (for Lunala)
  { name = "Nihilego",     level = 7, types = { "Rock", "Poison" }, moves = { "Head Smash", "Venoshock" },     guids = { "e53d16" }, model_GUID = "24211e" },
  { name = "Buzzwole",     level = 7, types = { "Bug", "Fighting" }, moves = { "Dynamic Punch", "Lunge" },     guids = { "b97547" }, model_GUID = "d4bad7" },
  { name = "Pheromosa",    level = 7, types = { "Bug", "Fighting" }, moves = { "High Jump Kick", "Silver Wind" }, guids = { "6b596f" }, model_GUID = "9c9628" },
  { name = "Xurkitree",    level = 7, types = { "Electric" }, moves = { "Zap Cannon", "Power Whip" },          guids = { "c291b1" }, model_GUID = "dd3362", spawn_effect="Status Attack", custom_scale=0.7, offset={x=0, y=0, z=-0.06} },
  { name = "Celesteela",   level = 7, types = { "Steel", "Flying" }, moves = { "Iron Head", "Air Slash" },     guids = { "6b8a57" }, model_GUID = "4ed33c", custom_scale=0.3 },
  { name = "Kartana",      level = 7, types = { "Grass", "Steel" }, moves = { "Sacred Sword", "Leaf Blade" },  guids = { "94790b" }, model_GUID = "96978b", spawn_effect="Status Attack" },
  { name = "Guzzlord",     level = 7, types = { "Dark", "Dragon" }, moves = { "Dragon Rush", "Crunch" },       guids = { "ed1c1b" }, model_GUID = "2754d6", spawn_effect="Status Attack", custom_scale=0.3, offset={x=0, y=0, z=-0.13} },
  { name = "Necrozma",     level = 7, types = { "Psychic" },  moves = { "Photon Geyser", "Night Slash" },      guids = { "ec14da" }, model_GUID = "907d48", spawn_effect="Status Attack", evoData = { { cost = "N-Solarizer", ball = LEGENDARY, gen = 7, cycle = true, guids = { "6366eb" }, model_GUID = "9aed20", custom_scale=0.7 },   -- Dusk Mane
                                                                                                                                                                     { cost = "N-Lunarizer", ball = LEGENDARY, gen = 7, cycle = true, guids = { "1bdda7" }, model_GUID = "94ea0e", spawn_effect="Status Attack", custom_scale=0.7 },   -- Dawn Wings
                                                                                                                                                                     { cost = "Ultranecrozium Z", ball = LEGENDARY, gen = 7, cycle = true, guids = { "370a4c" }, model_GUID = "6becd1", custom_scale=0.5 } } },
  { name = "Dusk Mane Necrozma",level = 7, types = { "Psychic", "Steel" },  moves = { "Sunsteel Strike", "Prism. Laser" },guids = { "6366eb" }, model_GUID = "9aed20", custom_scale=0.3, offset={x=0, y=0, z=-0.02}, evoData = { { cost = 0, ball = LEGENDARY, gen = 7, cycle = true, guids = { "ec14da" }, model_GUID = "907d48", spawn_effect="Status Attack" } } },  -- Dusk Mane (for Necrozma)
  { name = "Dawn Wings Necrozma",level = 7, types = { "Psychic", "Ghost" },  moves = { "Moongeist Beam", "Prism. Laser" },guids = { "1bdda7" }, model_GUID = "94ea0e", spawn_effect="Status Attack", custom_scale=0.7, evoData = { { cost = 0, ball = LEGENDARY, gen = 7, cycle = true, guids = { "ec14da" }, model_GUID = "907d48", spawn_effect="Status Attack" } } },  -- Dawn Wings (for Necrozma)
  { name = "Ultra Necrozma",level = 7, types = { "Psychic", "Dragon" },  moves = { "Moongeist Beam", "Sunsteel Strike" },guids = { "370a4c" }, model_GUID = "6becd1", custom_scale=0.5, evoData = { { cost = 0, ball = LEGENDARY, gen = 7, cycle = true, guids = { "ec14da" }, model_GUID = "907d48", spawn_effect="Status Attack" } } },
  { name = "Magearna",     level = 7, types = { "Steel", "Fairy" }, moves = { "Flash Cannon", "Fleur Cannon" },guids = { "0ac3f1" }, model_GUID = "318474" },
  { name = "Marshadow",    level = 7, types = { "Fighting", "Ghost" }, moves = { "Close Combat", "Spectral Thief" }, guids = { "8e8527" }, model_GUID = "bd5b48" },
  { name = "Poipole",      level = 5, types = { "Poison" },   moves = { "Fury Attack", "Toxic" },              guids = { "6cadb0" }, model_GUID = "94b4e8", spawn_effect="Physical Attack", evoData = { { cost = 2, ball = LEGENDARY, gen = 7, guids = { "c42a20" }, model_GUID = "e435dd", spawn_effect="Physical Attack" } } },
  { name = "Naganadel",    level = 7, types = { "Poison", "Dragon" }, moves = { "Poison Jab", "Dragon Pulse" }, guids = { "4d5ae0", "c42a20" }, model_GUID = "e435dd", spawn_effect="Physical Attack" },
  { name = "Stakataka",    level = 7, types = { "Rock", "Steel" }, moves = { "Rock Blast", "Iron Defense" },   guids = { "1446e4" }, model_GUID = "2e57e4", spawn_effect="Status Attack", custom_scale=0.3 },
  { name = "Blacephalon",  level = 7, types = { "Fire", "Ghost" }, moves = { "Shadow Ball", "Mind Blown" },    guids = { "38816d" }, model_GUID = "d38e89" },
  { name = "Zeraora",      level = 7, types = { "Electric" }, moves = { "Hone Claws", "Plasma Fists" },        guids = { "3bc718" }, model_GUID = "7451bb" },
  { name = "Meltan",       level = 5, types = { "Steel" },    moves = { "Flash Cannon", "Acid Armor" },        guids = { "abc2d5" } ,                    evoData = { { cost = 2, ball = LEGENDARY, gen = 7, guids = { "aec8ec" } } }, model_GUID = "71bac2" },
  { name = "Melmetal",     level = 7, types = { "Steel" },    moves = { "Dbl. Iron Bash", "Hyper Beam" },      guids = { "f35bd5", "aec8ec" },           evoData = { { cost = "GMax", ball = MEGA, gen = 7, cycle = true, guids = { "89bba5", "00eaca" } } }, model_GUID = "362454", custom_scale=0.7 },

  -- Gen 7 Alolan
  { name = "Alolan Rattata",      level = 1, types = { "Dark", "Normal" },     moves = { "Tail Whip", "Pursuit" },              guids = { "8dc2dc" }, model_GUID = "53c2a4", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "673f0e" }, model_GUID = "905fd9" } } },
  { name = "Alolan Raticate",     level = 3, types = { "Dark", "Normal" },     moves = { "Super Fang", "Crunch" },              guids = { "924294", "673f0e" }, model_GUID = "905fd9" },
  { name = "Alolan Raichu",       level = 3, types = { "Electric", "Psychic" }, moves = { "Thunder Shock", "Psychic" },         guids = { "65a373", "1e53ce", "ef1a51" }, model_GUID = "ac9e94", spawn_effect="Physical Attack" },
  { name = "Alolan Sandshrew",    level = 1, types = { "Ice", "Steel" },       moves = { "Powder Snow", "Defense Curl" },       guids = { "e51fcd" }, model_GUID = "52ee91", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "be4022" }, model_GUID = "2b6482" } } },
  { name = "Alolan Sandslash",    level = 3, types = { "Ice", "Steel" },       moves = { "Metal Claw", "Icicle Crash" },        guids = { "2f3bf2", "be4022" }, model_GUID = "2b6482" },
  { name = "Alolan Vulpix",       level = 2, types = { "Ice" },                moves = { "Powder Snow", "Confuse Ray" },        guids = { "edcd10" }, model_GUID = "cbe5dc", evoData = { { cost = 3, ball = YELLOW, gen = 7, guids = { "e0f9e1" }, model_GUID = "654f90" } } },
  { name = "Alolan Ninetales",    level = 5, types = { "Ice" },                moves = { "Aurora Beam", "Extrasensory" },       guids = { "950de0", "e0f9e1" }, model_GUID = "654f90" },
  { name = "Alolan Diglett",      level = 2, types = { "Ground", "Steel" },    moves = { "Metal Claw", "Sand Attack" },         guids = { "a70b67" }, model_GUID = "714593", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "b91f7c" }, model_GUID = "461e52" } } },
  { name = "Alolan Dugtrio",      level = 4, types = { "Ground", "Steel" },    moves = { "Iron Head", "Dig" },                  guids = { "f4d5cc", "b91f7c" }, model_GUID = "461e52" },
  { name = "Alolan Meowth",       level = 2, types = { "Dark" },               moves = { "Growl", "Bite" },                     guids = { "8df15f" }, model_GUID = "bcee34", spawn_effect="Physical Attack", evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "ccd8e9" }, model_GUID = "0684cc" } } },
  { name = "Alolan Persian",      level = 4, types = { "Dark" },               moves = { "Feint Attack", "Screech" },           guids = { "3986bc", "ccd8e9" }, model_GUID = "0684cc", custom_scale=0.9, offset={x=0, y=0, z=-0.05} },
  { name = "Alolan Geodude",      level = 1, types = { "Rock", "Electric" },   moves = { "Rock Throw", "Charge" },              guids = { "c5d66d" }, model_GUID = "0b6e11", evoData = { { cost = 3, ball = BLUE, gen = 7, guids = { "01562b" }, model_GUID = "27bcd3" } } },
  { name = "Alolan Graveler",     level = 4, types = { "Rock", "Electric" },   moves = { "Thunder Punch", "Self-Destruct" },    guids = { "38fa09", "01562b" }, model_GUID = "27bcd3", evoData = { { cost = 2, ball = RED, gen = 7, guids = { "b21424", "7702b6" }, model_GUID = "18e42a", spawn_effect="Physical Attack" } } },
  { name = "Alolan Golem",        level = 6, types = { "Rock", "Electric" },   moves = { "Stone Edge", "Spark" },               guids = { "6e7cf6", "b21424", "7702b6" }, model_GUID = "18e42a", spawn_effect="Physical Attack" },
  { name = "Alolan Grimer",       level = 4, types = { "Poison", "Dark" },     moves = { "Disable", "Bite" },                   guids = { "c9ea3a" }, model_GUID = "9b4419", evoData = { { cost = 1, ball = RED, gen = 7, guids = { "d5d023" }, model_GUID = "7e8a7f" } } },
  { name = "Alolan Muk",          level = 5, types = { "Poison", "Dark" },     moves = { "Poison Fang", "Crunch" },             guids = { "20e759", "d5d023" }, model_GUID = "7e8a7f", custom_scale=0.5 },
  { name = "Alolan Exeggutor",    level = 5, types = { "Grass", "Dragon" },    moves = { "Dragon Hammer", "Seed Bomb" },        guids = { "2b8a77", "56fca1" }, model_GUID = "e56668" },
  { name = "Alolan Marowak",      level = 5, types = { "Fire", "Ghost" },      moves = { "Shadow Bone", "Bone Club" },          guids = { "04850a" }, model_GUID = "245f21" },

  -- Mega evolutions.
  { name = "GMax Melmetal",       level = 7, types = { "Steel" },    moves = { "Meltdown", "Strike" },                guids = { "89bba5", "00eaca" },           evoData = { { cost = 0, ball = LEGENDARY, gen = 7, cycle = true, guids = { "f35bd5", "aec8ec" } } }, model_GUID = "b839e1", custom_scale=0.6 },
}

gen8PokemonData =
{
  -- Gen 8 810-834
  { name = "Grookey",       level = 1, types = { "Grass" }, moves = { "Branch Poke", "Growl" },    guids = { "4c56ac" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "b22689" }, model_GUID = "51e7b2" } }, model_GUID = "4cb51b" },
  { name = "Thwackey",      level = 3, types = { "Grass" }, moves = { "Double Hit", "Razor Leaf" },   guids = { "ad204e", "b22689" },     evoData = { { cost = 2, ball = RED, gen = 8, guids = { "2eba49", "f9d565" }, model_GUID = "2a352f" } }, model_GUID = "51e7b2" },
  { name = "Rillaboom",     level = 5, types = { "Grass" }, moves = { "Drum Beating", "Boomburst" },     guids = { "d4a518", "2eba49", "f9d565" },            evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "d98c1f", "712942" }, model_GUID = "6e7118" } }, model_GUID = "2a352f" },
  { name = "Scorbunny",     level = 1, types = { "Fire" }, moves = { "Ember", "Growl" },         guids = { "d5c9cd" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "5cef8f" }, model_GUID = "e1dd29" } }, model_GUID = "003ce3" },
  { name = "Raboot",        level = 3, types = { "Fire" }, moves = { "Double Kick", "Flame Charge" }, guids = { "a179de", "5cef8f" },   evoData = { { cost = 2, ball = RED, gen = 8, guids = { "e52d3f", "77f114" }, model_GUID = "edbb96" } }, model_GUID = "e1dd29" },
  { name = "Cinderace",     level = 5, types = { "Fire" }, moves = { "Pyro Ball", "Bounce" }, guids = { "68e885", "e52d3f", "77f114" },                       evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "0ae3eb", "35db21" }, model_GUID = "5fd307" } }, model_GUID = "edbb96" },
  { name = "Sobble",        level = 1, types = { "Water" }, moves = { "Water Gun", "Growl" },    guids = { "732820" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "767be0" },  model_GUID = "066200" } }, model_GUID = "4fb88c" },
  { name = "Drizzile",      level = 3, types = { "Water" }, moves = { "Water Pulse", "Tearful Look" }, guids = { "1ff7e7", "767be0" },    evoData = { { cost = 2, ball = RED, gen = 8, guids = { "caa8d1", "70e2dd" }, model_GUID = "289431" } },  model_GUID = "066200"  },
  { name = "Inteleon",      level = 5, types = { "Water" }, moves = { "Snipe Shot", "U-Turn" }, guids = { "a87b0f", "caa8d1", "70e2dd" },                     evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "834995", "e4f6e7" }, model_GUID = "1e011b" } }, model_GUID = "289431" },
  { name = "Skwovet",       level = 1, types = { "Normal" }, moves = { "Tail Whip", "Bite" },          guids = { "0092fc" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "0f5cf9" }, model_GUID = "a5ecec" } }, model_GUID = "400005" },
  { name = "Greedent",      level = 3, types = { "Normal" }, moves = { "Stuff Cheeks", "Covet" },  guids = { "7d0ad9", "0f5cf9" }, model_GUID = "a5ecec" },
  { name = "Rookidee",      level = 1, types = { "Flying" }, moves = { "Fury Attack", "Peck" }, guids = { "6d058d"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "aac3a7" } } }, model_GUID = "581f48" },
  { name = "Corvisquire",   level = 3, types = { "Flying" }, moves = { "Hone Claws", "Drill Peck" },     guids = { "817152", "aac3a7" },     evoData = { { cost = 3, ball = RED, gen = 8, guids = { "29b1df", "39c41f"} } }, model_GUID = "b1809c" },
  { name = "Corviknight",   level = 6, types = { "Flying", "Steel" }, moves = { "Brave Bird", "Steel Wing" }, guids = { "d80b24", "29b1df", "39c41f" },                evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "ea919f", "1c820c" }, model_GUID = "751679" } }, model_GUID = "1515e6" },
  { name = "Blipbug",       level = 1, types = { "Bug" }, moves = { "Struggle Bug"}, guids = { "e534da" },              evoData = { { cost = 1, ball = PINK, gen = 8, guids = { "fa8ba4" } } }, model_GUID = "6446d0" },
  { name = "Dottler",       level = 2, types = { "Bug", "Psychic" }, moves = { "Confusion", "Reflect" }, guids = { "a228d5", "fa8ba4" },    evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "6e7247", "eb4403" } } }, model_GUID = "b0de96"},
  { name = "Orbeetle",      level = 4, types = { "Bug", "Psychic" }, moves = { "Bug Buzz", "Psychic" }, guids = { "4150f3", "6e7247", "eb4403" },                        evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "27ad44", "aee305" } } }, model_GUID = "a6d4d8" },
  { name = "Nickit",        level = 1, types = { "Dark" }, moves = { "Quick Attack", "Thief" },      guids = { "7e6383"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "cf334e" }, model_GUID = "fdee2d" } }, model_GUID = "e3debf" },
  { name = "Thievul",       level = 3, types = { "Dark" }, moves = { "Tail Slap", "Snarl" }, guids = { "37a9d1", "cf334e" }, model_GUID = "fdee2d" },
  { name = "Gossifleur",    level = 2, types = { "Grass" }, moves = { "Rapid Spin", "Leafage" },     guids = { "bbf00f" }, evoData = { { cost = 1, ball = GREEN, gen = 8, guids = { "f8b45c" } } }, model_GUID = "2f875e"  }, 
  { name = "Eldegoss",      level = 3, types = { "Grass" }, moves = { "Cotton Guard", "Hyper Voice" },     guids = { "4f25ee", "f8b45c" }, model_GUID = "227ab8"  },
  { name = "Wooloo",        level = 1, types = { "Normal" }, moves = { "Double Kick", "Defense Curl" },     guids = { "f627d1" }, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "17bfff" } } }, model_GUID = "d2c51c"  }, 
  { name = "Dubwool",       level = 3, types = { "Normal" }, moves = { "Cotton Guard", "Headbutt" },     guids = { "9bc17c", "17bfff" }, model_GUID = "d79f30"  },
  { name = "Chewtle",       level = 1, types = { "Water" }, moves = { "Water Gun", "Protect" },  guids = { "9ea87e" }, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "bf22b0" } } }, model_GUID = "273314"},
  { name = "Drednaw",       level = 3, types = { "Water", "Rock" }, moves = { "Razor Shell", "Jaw Lock" },         guids = { "620b5e", "bf22b0" },                    evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "8054c2", "5cb470" }, model_GUID = "72b7ce" } }, model_GUID = "0ab337", custom_scale=0.8 },

  -- Gen 8 835-858
  { name = "Yamper",        level = 1, types = { "Electric" }, moves = { "Nuzzle", "Roar" }, guids = { "71d863" }, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "d10387" }, model_GUID = "daf531" } }, model_GUID = "4b1edc" },
  { name = "Boltund",       level = 3, types = { "Electric" }, moves = { "Wild Charge", "Bite" },   guids = { "fa69eb", "d10387" }, model_GUID = "daf531" }, 
  { name = "Rolycoly",      level = 1, types = { "Rock" }, moves = { "Rock Polish", "Rapid Spin" },   guids = { "152d0a"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "19ffab"} } }, model_GUID = "15b462" }, 
  { name = "Carkol",        level = 3, types = { "Rock", "Fire" }, moves = { "Rock Blast", "Flame Charge" },  guids = { "7e1e68", "19ffab"}, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "678720", "5eecb1"} } }, model_GUID = "527563"  }, -- 
  { name = "Coalossal",     level = 5, types = { "Rock", "Fire" }, moves = { "Ancient Power", "Incinerate" }, guids = { "6ac20e", "678720", "5eecb1" },                evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "423aca", "6407e4" }, model_GUID = "dfe276" } }, model_GUID = "e7e32a", custom_scale=0.7 },
  { name = "Applin",        level = 2, types = { "Grass", "Dragon" }, moves = { "Astonish", "Withdraw" },  guids = { "5d39a1" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "508cc7" }, model_GUID = "c9aba6" }, { cost = 2, ball = YELLOW, gen = 8, guids = { "3a326b" }, model_GUID = "8997a1" }, { cost = 2, ball = YELLOW, gen = 9, guids = { "951a30" } } }, model_GUID = "bf6fb1"},
  { name = "Flapple",       level = 4, types = { "Grass", "Dragon" }, moves = { "Grav Apple", "Dragon Pulse" }, guids = { "beb575", "508cc7" },                    evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "c4ec8a", "975b3c" }, model_GUID = "62fbcf" } }, model_GUID = "c9aba6" },
  { name = "Appletun",      level = 4, types = { "Grass", "Dragon" }, moves = { "Apple Acid", "Dragon Pulse" },  guids = { "a26f34", "3a326b" },                   evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "945af3", "31aacc" }, model_GUID = "b87e45" } }, model_GUID = "8997a1" },
  { name = "Silicobra",     level = 3, types = { "Ground" }, moves = { "Sandstorm", "Wrap" }, guids = { "2f1d01" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "3e0da6"} } }, model_GUID = "69f041" },
  { name = "Sandaconda",    level = 5, types = { "Ground" }, moves = { "Sand Tomb", "Coil" }, guids = { "c91baf", "3e0da6" },                            evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "2e2482", "3ab61a" }, model_GUID = "1e2e60" } }, model_GUID = "d15ad0" },
  { name = "Cramorant",     level = 4, types = { "Flying", "Water" }, moves = { "Spit Up", "Dive" },  guids = { "55ee12"}, model_GUID = "2b1b24" }, 
  { name = "Arrokuda",      level = 2, types = { "Water" }, moves = { "Fury Attack", "Aqua Jet" }, guids = { "642dca"}, evoData = { { cost = 1, ball = GREEN, gen = 8, guids = { "e1ccdd" }, model_GUID = "2d9e7c" } }, model_GUID = "95b4b0" },
  { name = "Barraskewda",   level = 3, types = { "Water" }, moves = { "Double-Edge", "Liquidation" },     guids = { "1e3235", "e1ccdd" }, model_GUID = "2d9e7c" },
  { name = "Toxel",         level = 2, types = { "Electric", "Poison" }, moves = { "Tearful Look", "Nuzzle" },  guids = { "21446c" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "bea82d" }, model_GUID = "42a6c3" }, { cost = 2, ball = YELLOW, gen = 8, guids = { "a7277f" }, model_GUID = "4d9bff" }  }, model_GUID = "37cb24" },
  { name = "Amped Toxtricity", level = 4, types = { "Electric", "Poison" }, moves = { "Boomburst", "Overdrive" },    guids = { "0c6876", "bea82d" },                            evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "1644af", "f8615c" }, model_GUID = "7c090f" } }, model_GUID = "42a6c3", ball = YELLOW }, -- Amped Form
  { name = "Low-Key Toxtricity", level = 4, types = { "Electric", "Poison" }, moves = { "Poison Jab", "Overdrive" },  guids = { "67ec92", "a7277f" },                           evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "8c4dd2", "e01e0a" }, model_GUID = "7c090f" } }, model_GUID = "4d9bff", ball = YELLOW }, -- Low Key Form
  { name = "Sizzlipede",    level = 2, types = { "Fire", "Bug" }, moves = { "Wrap", "Ember" }, guids = { "d3aefa"}, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "bf95c2" }, model_GUID = "a1917b" } }, model_GUID = "746584" },
  { name = "Centiskorch",   level = 4, types = { "Fire", "Bug" }, moves = { "Flame Wheel", "Bug Bite" },   guids = { "5b2923", "bf95c2" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "457776", "f8726f" }, model_GUID = "6bd6e4" } }, model_GUID = "a1917b", offset={x=0, y=0, z=0.03} },
  { name = "Clobbopus",     level = 3, types = { "Fighting" }, moves = { "Rock Smash", "Taunt" }, guids = { "5ddd8c" }, evoData = { { cost = 1, ball = BLUE, gen = 8, guids = { "4725cb" }, model_GUID = "693233" } }, model_GUID = "9e835b" },
  { name = "Grapploct",     level = 4, types = { "Fighting" }, moves = { "Octazooka", "Octolock" }, guids = { "d20c3d", "4725cb"}, model_GUID = "693233" },
  { name = "Sinistea",      level = 3, types = { "Ghost" }, moves = { "Astonish", "Mega Drain" }, guids = { "db3703"}, evoData = { { cost = 1, ball = BLUE, gen = 8, guids = { "584ee3" }, model_GUID = "11b1fd" } }, model_GUID = "7a2208" },
  { name = "Polteageist",   level = 4, types = { "Ghost" }, moves = { "Curse", "Protect" },  guids = { "9b2f6e", "584ee3" }, model_GUID = "11b1fd" },
  { name = "Hatenna",       level = 2, types = { "Psychic" }, moves = { "Confusion", "Play Nice" },    guids = { "c0efd5"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "fc0b6e" }, model_GUID = "7f2434" } }, model_GUID = "712415" },
  { name = "Hattrem",       level = 4, types = { "Psychic" }, moves = { "Disarming Voice", "Brutal Swing" },  guids = { "c29b93", "fc0b6e"}, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "9cfe10", "42db1f" }, model_GUID = "9ac795" } }, model_GUID = "7f2434" },
  { name = "Hatterene",     level = 6, types = { "Psychic", "Fairy" }, moves = { "Dazzling Gleam", "Psybeam" },  guids = { "e711fc", "9cfe10", "42db1f" },                   evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "0fab1b", "73ef1b" }, model_GUID = "9219a8" } }, model_GUID = "9ac795" },

  -- Gen 8 859-884
  { name = "Impidimp",      level = 3, types = { "Dark", "Fairy" }, moves = { "Assurance", "Swagger"}, guids = { "955f8e" },            evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "09d5df" }, model_GUID = "9cc006" } }, model_GUID = "b49ec1" },
  { name = "Morgrem",       level = 5, types = { "Dark", "Fairy" }, moves = { "Sucker Punch", "Play Rough" },       guids = { "372fdf", "09d5df" }, evoData = { { cost = 1, ball = RED, gen = 8, guids = { "09fbc4", "1d1bc9" }, model_GUID = "3db539" } }, model_GUID = "9cc006" },
  { name = "Grimmsnarl",    level = 6, types = { "Dark", "Fairy" }, moves = { "Spirit Break", "Foul Play" }, guids = { "9a62bf", "09fbc4", "1d1bc9" },                       evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "671823", "325e58" }, model_GUID = "e31f45" } }, model_GUID = "3db539" },
  { name = "Obstagoon",     level = 5, types = { "Dark", "Normal" }, moves = { "Night Slash", "Counter" },   guids = { "355878", "f9576c", "18880a" }, model_GUID = "89cdcd" },
  { name = "Perrserker",    level = 4, types = { "Steel" }, moves = { "Iron Head", "Swagger" },      guids = { "352cd9", "33995d" }, model_GUID = "7ae05b" },
  { name = "Cursola",       level = 5, types = { "Ghost" }, moves = { "Night Shade", "Mirror Coat" },       guids = { "05fc5b", "ac68fa" }, model_GUID = "b8f109" },
  { name = "Sirfetch'd",    level = 5, types = { "Fighting" }, moves = { "Knock Off", "Brick Break" }, guids = { "d7a5ef", "166853"}, model_GUID = "158014" }, 
  { name = "Mr. Rime",      level = 5, types = { "Ice", "Psychic" }, moves = { "Ice Punch", "Psybeam" }, guids = { "f05e97", "f5e748", "2de3e8"}, model_GUID = "908864" },
  { name = "Runerigus",     level = 5, types = { "Ground", "Ghost" }, moves = { "Earthquake", "Curse" }, guids = { "78c895", "b8d9ee"}, model_GUID = "999baf" },
  { name = "Milcery",       level = 2, types = { "Fairy" }, moves = { "Sweet Kiss", "Tackle" }, guids = { "d07981"},                                                 evoData = { { cost = 1, ball = BLUE, gen = 8, guids = { "f57bd3" } } }, model_GUID = "a82cac" },
  { name = "Alcremie",      level = 3, types = { "Fairy" }, moves = { "Dazzling Gleam", "Decorate" }, guids = { "71833d", "f57bd3" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "3c5cba", "0b4ee1" } } }, model_GUID = "44047f" },
  { name = "Falinks",       level = 4, types = { "Fighting" }, moves = { "First Impression", "No Retreat" }, guids = { "8bb381" }, model_GUID = "913225", custom_scale=0.75 },
  { name = "Pincurchin",    level = 3, types = { "Electric" }, moves = { "Toxic Spikes", "Zing Zap" }, guids = { "4657b0" }, model_GUID = "4c0765" },
  { name = "Snom",          level = 2, types = { "Ice", "Bug" }, moves = { "Powder Snow", "Struggle Bug" }, guids = { "b1d7df" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "8b539d" }, model_GUID = "aa5643" } }, model_GUID = "b248ab" },
  { name = "Frosmoth",      level = 4, types = { "Ice", "Bug" }, moves = { "Quiver Dance", "Icy Wind" }, guids = { "613ae8", "8b539d" }, model_GUID = "aa5643" },
  { name = "Stonjourner",   level = 4, types = { "Rock" }, moves = { "Wide Guard", "Mega Kick" }, guids = { "ad7026" }, model_GUID = "317554", custom_scale=0.7 },
  { name = "Ice Eiscue",    level = 3, types = { "Ice" }, moves = { "Headbutt", "Hail" }, guids = { "7367d0" }, model_GUID = "399eee", ball = BLUE  }, -- Ice
  { name = "Noice Eiscue",  level = 3, types = { "Ice" }, moves = { "Amnesia", "Mist" }, guids = { "7da34a" }, ball = BLUE },                          -- Noice, I believe we don't have a model for this version
  { name = "Indeedee",      level = 3, types = { "Psychic", "Normal" }, moves = { "Disarming Voice", "Psychic" }, guids = { "d23303"  }, model_GUID = "1cb82f" },
  { name = "Full Belly Morpeko", level = 3, types = { "Electric" }, moves = { "Aura Wheel Electric", "Thrash" }, guids = { "d7c95a" }, model_GUID = "6393df", ball = BLUE }, -- Yellow Happy :)
  { name = "Hangry Morpeko", level = 3, types = { "Dark" }, moves = { "Aura Wheel Dark", "Thrash" }, guids = { "ccf33f" }, model_GUID = "1128d8", ball = BLUE },             -- Purple Angry :(
  { name = "Cufant",        level = 3, types = { "Steel" }, moves = { "Rock Smash", "Iron Defense" }, guids = { "e94da5" }, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "bb0dab" }, model_GUID = "fa0704" } }, model_GUID = "a37dd9" },
  { name = "Copperajah",    level = 5, types = { "Steel" }, moves = { "H. Horsepower", "Iron Head" }, guids = { "772688", "bb0dab" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "ad2c75", "1e68f7" }, model_GUID = "be6c58" } }, model_GUID = "fa0704", custom_scale=0.4 },
  { name = "Dracozolt",     level = 4, types = { "Electric", "Dragon" }, moves = { "Ancient Power", "Discharge" }, guids = { "8c8145" }, model_GUID = "37afb9", custom_scale=0.8 },
  { name = "Arctozolt",     level = 4, types = { "Electric", "Ice" }, moves = { "Ancient Power", "Freeze-Dry" }, guids = { "21422d"}, model_GUID = "58dc46" }, 
  { name = "Dracovish",     level = 4, types = { "Water", "Dragon" }, moves = { "Dragon Rush", "Ancient Power" }, guids = { "79900c"}, model_GUID = "8f7c9c" }, 
  { name = "Arctovish",     level = 4, types = { "Water", "Ice" }, moves = { "Ancient Power", "Liquidation" }, guids = { "d8d24a"}, model_GUID = "d1ae37" },
  { name = "Duraludon",     level = 5, types = { "Steel", "Dragon" }, moves = { "Metal Claw", "Dragon Claw" }, guids = { "19c226" }, evoData = { { cost = 1, ball = RED, gen = 9, guids = { "3a6873" } }, 
                                                                                                                                                 { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "e17508", "ff891b" }, model_GUID = "a14b0f" } }, 
                                                                                                                           model_GUID = "397452", custom_scale=0.85 }, 
  { name = "Dreepy",        level = 2, types = { "Dragon", "Ghost" }, moves = { "Infestation", "Astonish" }, guids = { "947a92" }, evoData = { { cost = 3, ball = YELLOW, gen = 8, guids = { "b9b3ac" } } }, model_GUID = "b500da" }, 
  { name = "Drakloak",      level = 5, types = { "Dragon", "Ghost" }, moves = { "Double Hit", "Dragon Pulse" }, guids = { "0dd987", "b9b3ac" }, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "0fafd7", "89c1a8" } } }, model_GUID = "d04b70" }, 
  { name = "Dragapult",     level = 7, types = { "Dragon", "Ghost" }, moves = { "Dragon Darts", "Phantom Force" }, guids = { "ccc405", "0fafd7", "89c1a8" }, model_GUID = "1f4890" },
  { name = "Zacian",        level = 7, types = { "Fairy" }, moves = { "Sacred Sword", "Moonblast" }, guids = { "e97b5b" }, evoData = { { cost = "Rusted Sword", ball = LEGENDARY, gen = 8, cycle = true, guids = { "c3ff51"}, model_GUID = "6dccb4" } }, model_GUID = "659f7c", custom_scale=0.6, offset={x=0, y=0, z=-0.2} },
  { name = "Crowned Sword Zacian", level = 8, types = { "Fairy", "Steel" }, moves = { "Behemoth Blade", "Play Rough" }, guids = { "c3ff51" }, evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "e97b5b"}, model_GUID = "659f7c" } }, model_GUID = "6dccb4", custom_scale=0.6, offset={x=0, y=0, z=-0.2} },                 -- C. Sword
  { name = "Zamazenta",     level = 7, types = { "Fighting" }, moves = { "Iron Defense", "Revenge" }, guids = { "925e6b" }, evoData = { { cost = "Rusted Shield", ball = LEGENDARY, gen = 8, cycle = true, guids = { "51a0ef" }, model_GUID = "37f3aa" } }, model_GUID = "a27a5b", custom_scale=0.6, offset={x=0, y=0, z=-0.2} },
  { name = "Crowned Shield Zamazenta", level = 8, types = { "Fighting", "Steel" }, moves = { "Behemoth Bash", "Close Combat" }, guids = { "51a0ef" }, evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "925e6b"}, model_GUID = "a27a5b" } }, model_GUID = "37f3aa", custom_scale=0.6, offset={x=0, y=0, z=-0.2} },         -- C. Shield
  { name = "Eternatus",     level = 7, types = { "Poison" }, moves = { "Cross Poison", "D-max Cannon" }, guids = { "c0d41b" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "e78955" } } }, model_GUID = "b03c9c", custom_scale=0.3 },
  { name = "Kubfu",         level = 5, types = { "Fighting" }, moves = { "Headbutt", "Counter" }, guids = { "312af1" }, evoData = { { cost = "Scroll of Waters", ball = LEGENDARY, gen = 8, guids = { "ab896e"} },       -- Rapid Strike
                                                                                                                                    { cost = "Scroll of Darkness", ball = LEGENDARY, gen = 8, guids = { "015ff0"} } },   -- Single Strike
                                                                                                                        model_GUID = "bed41b" },
  { name = "RS Urshifu",    level = 7, types = { "Fighting", "Water" }, moves = { "Surging Strikes", "Brick Break" }, guids = { "ab896e" },   evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "bf033c" }, model_GUID = "6c1d60" } }, model_GUID = "6f4ae9", idle_effect="Rapid Idle", custom_scale=0.85 },   -- Rapid Strike
  { name = "SS Urshifu",    level = 7, types = { "Fighting", "Dark" }, moves = { "Wicked Blow", "Brick Break" }, guids = { "015ff0" },       evoData = { { cost = "GMax", ball = MEGA, gen = 8, cycle = true, guids = { "dd3373" }, model_GUID = "4491c0" } }, model_GUID = "bde30a", custom_scale=0.35, offset={x=0, y=0, z=-0.03} }, -- Single Strike
  { name = "Zarude",        level = 7, types = { "Dark", "Grass" }, moves = { "Jungle Healing", "Brutal Swing" }, guids = { "651f81" }, model_GUID = "0ab53f", offset={x=0, y=0, z=-0.03} }, 
  { name = "Regieleki",     level = 7, types = { "Electric" }, moves = { "Thunder Cage", "Hyper Beam" }, guids = { "45a74f" }, model_GUID = "8f56ea" },
  { name = "Regidrago",     level = 7, types = { "Dragon" }, moves = { "Dragon Energy", "Thrash" }, guids = { "2ec2b8" }, model_GUID = "ca1c89" }, 
  { name = "Glastrier",     level = 7, types = { "Ice" }, moves = { "Icicle Crash", "Iron Defense" }, guids = { "05139e" }, evoData = { { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, guids = { "5e40a8" } } }, model_GUID = "3225b8", custom_scale=0.8 }, 
  { name = "Ice Rider Calyrex", level = 8, types = { "Psychic", "Ice" }, moves = { "Glacial Lance", "Psychic" }, guids = { "5e40a8" },  evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "05139e" } } }, model_GUID = "e85209", custom_scale=0.8 }, -- Ice Rider  (for Glastrier)
  { name = "Spectrier",     level = 7, types = { "Ghost" }, moves = { "Shadow Ball", "Thrash" }, guids = { "3b4d86" }, evoData = { { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, guids = { "86748a" }, model_GUID = "58493a" } }, model_GUID = "3186ca", custom_scale=0.8 }, 
  { name = "Shadow Rider Calyrex", level = 8, types = { "Psychic", "Ghost" }, moves = { "Astral Barrage", "Psychic" }, guids = { "86748a" }, evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "3b4d86" } } }, model_GUID = "58493a", custom_scale=0.8 }, -- Shadow Rider (for Spectrier)
  { name = "Calyrex",       level = 7, types = { "Psychic", "Grass" }, moves = { "Energy Ball", "Psychic" }, guids = { "c91740"}, evoData = { { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, cycle = true, guids = { "3b7a04" }, model_GUID = "58493a", custom_scale=0.8 }, 
                                                                                                                                              { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, cycle = true, guids = { "004eaf" }, model_GUID = "e85209" } }, model_GUID = "858f74", custom_scale=0.8 }, 
  { name = "Shadow Rider Calyrex", level = 8, types = { "Psychic", "Ghost" }, moves = { "Astral Barrage", "Psychic" }, guids = { "3b7a04" }, evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "c91740" }, model_GUID = "858f74" } }, model_GUID = "58493a", custom_scale=0.8 }, -- Shadow Rider (for Calyrex)
  { name = "Ice Rider Calyrex", level = 8, types = { "Psychic", "Ice" }, moves = { "Glacial Lance", "Psychic" }, guids = { "004eaf" },  evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "c91740" }, model_GUID = "858f74" } }, model_GUID = "e85209", custom_scale=0.8 }, -- Ice Rider  (for Calyrex)
  { name = "Wyrdeer",       level = 4, types = { "Normal", "Psychic" }, moves = { "Psyshield Bash", "Double-Edge" }, guids = { "dabd21", "163267" }, model_GUID = "91a281", offset={x=0, y=0.05, z=0} },
  { name = "Kleavor",       level = 5, types = { "Bug", "Rock" }, moves = { "Stone Axe", "X-Scissor" }, guids = { "deef29", "18d390" }, model_GUID = "21f652", offset={x=0, y=0.05, z=0} },
  { name = "Ursaluna",      level = 6, types = { "Ground", "Normal" }, moves = { "Headlong Rush", "Play Rough" }, guids = { "b3110d", "7684c6", "2c6eaa" }, model_GUID = "5a426a", custom_scale=0.7, offset={x=0, y=0.8, z=0}, ball = RED },
  { name = "Bloodmoon Ursaluna", level = 6, types = { "Ground", "Normal" }, moves = { "Blood Moon", "Moonlight" }, guids = { "05e0a2", "0af179", "d9574b" }, model_GUID = "44b5bf", custom_scale=0.85, ball = RED },
  { name = "Basculegion",   level = 4, types = { "Water", "Ghost" }, moves = { "Wave Crash", "Phantom Force" }, guids = { "e2e65c", "357bf0" }, model_GUID = "808171", custom_scale={x=0, y=0.6, z=0} },
  { name = "Sneasler",      level = 5, types = { "Fighting", "Poison" }, moves = { "Close Combat", "Slash" }, guids = { "20e684", "8b5f40" }, model_GUID = "21f924" },
  { name = "Overqwil",      level = 5, types = { "Dark", "Poison" }, moves = { "Dark Pulse", "Poison Jab" }, guids = { "c891fc", "a4fb02" }, model_GUID = "79b584" },
  { name = "Incarnate Enamorus", level = 7, types = { "Fairy", "Flying" }, moves = { "Spring. Storm", "Superpower" }, guids = { "3ba79b" }, ball = LEGENDARY }, -- Non-Turtle Version
  { name = "Therian Enamorus", level = 7, types = { "Fairy", "Flying" }, moves = { "Spring. Storm", "Outrage" }, guids = { "52580d" }, ball = LEGENDARY },      -- Turtle Version
  
  -- GenVIII Hisuian, Galarian
  { name = "Galarian Zigzagoon",level = 1, types = { "Dark", "Normal" }, moves = { "Pin Missile", "Leer" }, guids = { "2eae89"},            evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "513b01"}, model_GUID = "af2407" } }, model_GUID = "4e078d" },
  { name = "Galarian Linoone", level = 3, types = { "Dark", "Normal" }, moves = { "Take Down", "Lick" },   guids = { "967c36", "513b01" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "18880a", "f9576c"}, model_GUID = "89cdcd" } }, model_GUID = "af2407" }, 
  { name = "Galarian Meowth",  level = 2, types = { "Steel" },  moves = { "Fury Swipes", "Metal Claw" },   guids = { "9df32b" },           evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "33995d"}, model_GUID = "7ae05b" } }, model_GUID = "5bd893" },
  { name = "Galarian Corsola", level = 3, types = { "Ghost" },  moves = { "Ancient Power", "Astonish" },   guids = { "eb13ff" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "ac68fa"}, model_GUID = "b8f109" } }, model_GUID = "14efc9" },
  { name = "Galarian Farfetch'd",level = 3, types = { "Fighting" }, moves = { "Sand Attack", "Slam" },     guids = { "2a641b" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "166853"} } }, model_GUID = "2eca14" },
  { name = "Galarian Mr. Mime",level = 3, types = { "Ice", "Psychic" },    moves = { "Ice Shard", "Encore" }, guids = { "ad9b7a", "8cfe98" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "f5e748", "2de3e8"}, model_GUID = "908864" } }, model_GUID = "8e52ef" },
  { name = "Galarian Yamask",  level = 3, types = { "Ground", "Ghost" }, moves = { "Brutal Swing", "Astonish" }, guids = { "fb6107" },           evoData = { { cost = 2, ball = RED, gen = 8, guids = { "b8d9ee"}, model_GUID = "999baf" } }, model_GUID = "a15bc0" }, 
  { name = "Hisuian Basculin", level = 2, types = { "Water" },  moves = { "Aqua Jet", "Crunch" },          guids = { "039880" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "357bf0"} } } },
  { name = "Hisuian Sneasel",  level = 3, types = { "Fighting", "Poison" },moves = { "Swords Dance", "Poison Jab" }, guids = { "fd17a9" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "8b5f40"} } }, model_GUID = "18d833", offset={x=0, y=0.21, z=-0.13}, custom_scale=0.6 },
  { name = "Hisuian Qwilfish", level = 4, types = { "Dark", "Poison" }, moves = { "Pin Missile", "Spikes" }, guids = { "d2929c" },           evoData = { { cost = 1, ball = YELLOW, gen = 8, guids = { "a4fb02"} } }, model_GUID = "8d1ab5", offset={x=0, y=0.21, z=-0.07}, custom_scale=0.6 },
  { name = "Hisuian Growlithe",level = 2, types = { "Fire", "Rock" }, moves = { "Rock Blast", "Bite" },   guids = { "0c6d18" },           evoData = { { cost = 3, ball = YELLOW, gen = 8, guids = { "fde268"} } }, model_GUID = "b0e54c", offset={x=0, y=0.21, z=-0.16}, custom_scale=0.55 }, 
  { name = "Hisuian Arcanine", level = 5, types = { "Fire", "Rock" },   moves = { "Rock Slide", "Fire Fang" }, guids = { "943d83", "fde268" }, model_GUID = "dd5f25", offset={x=0, y=0.21, z=-0.10}, custom_scale=0.4 },
  { name = "Galarian Ponyta",  level = 4, types = { "Psychic" },moves = { "Take Down", "Confusion" },      guids = { "918a64" },           evoData = { { cost = 2, ball = RED , gen = 8, guids = { "de6ae0"}, model_GUID = "725893", custom_scale=0.7 } }, model_GUID = "c8e066" }, 
  { name = "Galarian Rapidash",level = 6, types = { "Psychic", "Fairy" },moves = { "Dazzling Gleam", "Psybeam" },   guids = { "33cf1f", "de6ae0" }, model_GUID = "725893", custom_scale=0.7, offset={x=0, y=0, z=0.1} },
  { name = "Galarian Slowpoke",level = 2, types = { "Psychic" },moves = { "Confusion", "Acid" },           guids = { "c5b427" },           evoData = { { cost = 3, ball = RED , gen = 8, guids = { "a3217c"}, model_GUID = "0db618" }, { cost = 3, ball = RED , gen = 8, guids = { "e01e53"}, model_GUID = "eab949" } }, model_GUID = "7080db", custom_scale=0.75 }, 
  { name = "Galarian Slowbro", level = 5, types = { "Poison", "Psychic" }, moves = { "Shell Side Arm", "Water Pulse" }, guids = { "8bb5c6", "a3217c" }, model_GUID = "0db618" },
  { name = "Galarian Slowking",level = 5, types = { "Poison", "Psychic" }, moves = { "Power Gem", "Eerie Spell" },    guids = { "d817c2", "e01e53" }, model_GUID = "eab949" },
  { name = "Hisuian Voltorb",  level = 2, types = { "Electric", "Grass" }, moves = { "Thunder Wave", "Energy Ball" }, guids = { "1de2a1" },         evoData = { { cost = 2, ball = BLUE , gen = 8, guids = { "31ab95"} } }, model_GUID = "17404b", offset={x=0, y=0.21, z=-0.07}, custom_scale=0.6 }, 
  { name = "Hisuian Electrode",level = 4, types = { "Electric", "Grass" }, moves = { "Thunder Shock", "Chloroblast" }, guids = { "af44ee", "31ab95" }, model_GUID = "b551e2", offset={x=0, y=0.30, z=-0.09}, custom_scale=0.6 },
  { name = "Galarian Weezing", level = 5, types = { "Poison", "Fairy" }, moves = { "Strange Steam", "Sludge" },     guids = { "8864bd", "dccfa4" }, model_GUID = "e96342" },
  { name = "Galarian Articuno",level = 7, types = { "Psychic", "Flying" }, moves = { "Freezing Glare", "Hurricane" }, guids = { "df62df" }, model_GUID = "c2b05c" },
  { name = "Galarian Zapdos",  level = 7, types = { "Fighting", "Flying" },moves = { "Close Combat", "Drill Peck" }, guids = { "43f2c8" }, model_GUID = "8b0171"  },
  { name = "Galarian Moltres", level = 7, types = { "Dark", "Flying" }, moves = { "Sky Attack", "Fiery Wrath" },   guids = { "f194d1" }, model_GUID = "fa0b19" },
  { name = "Hisuian Typhlosion", level = 5, types = { "Fire", "Ghost" }, moves = { "Flamethrower", "Shadow Ball" }, guids = { "4ece6d", "e8349c", "c86580" }, model_GUID = "bf4883", offset={x=0, y=0.25, z=-0.2}, custom_scale=0.45 },
  { name = "Hisuian Samurott", level = 5, types = { "Water", "Dark" },  moves = { "Ceaseless Edge", "Razor Shell" }, guids = { "1e7846", "769c18", "c7dc10" }, model_GUID = "06c978", offset={x=0, y=0.3, z=-0.07}, custom_scale=0.6 },
  { name = "Hisuian Lilligant",level = 5, types = { "Grass", "Fighting" },  moves = { "Rock Smash", "Leaf Blade" },   guids = { "a1d8b8", "13e980" }, model_GUID = "f3f647", offset={x=0, y=0.21, z=-0.09}, custom_scale=0.6 },
  { name = "Galarian Darumaka",level = 3, types = { "Ice" },    moves = { "Ice Fang", "Rollout" },        guids = { "d2942a" },            evoData = { { cost = 2, ball = YELLOW , gen = 8, guids = { "382428" }, model_GUID = "433977" }, 
                                                                                                                                                       { cost = 2, ball = YELLOW , gen = 8, guids = { "d37822" }, model_GUID = "d9be07" } }, model_GUID = "7fd1c8" }, 
  { name = "Galarian Darmanitan",level = 5, types = { "Ice" },  moves = { "Ice Punch", "Superpower" },    guids = { "c14bd8", "d37822" }, model_GUID = "d9be07", ball = YELLOW },          -- Ice
  { name = "Galarian Zen Darmanitan",level = 5, types = { "Ice", "Fire" },  moves = { "Ice Punch", "Fire Punch" }, guids = { "f87608", "382428" }, model_GUID = "433977", ball = YELLOW }, -- Ice/Fire
  { name = "Hisuian Zorua",    level = 3, types = { "Normal", "Ghost" }, moves = { "Shadow Sneak", "Nasty Plot" }, guids = { "b25340" },            evoData = { { cost = 2, ball = YELLOW , gen = 8, guids = { "f46ea3"} } }, model_GUID = "da8dd7", offset={x=0, y=0.21, z=-0.14}, custom_scale=0.6 }, 
  { name = "Hisuian Zoroark",  level = 5, types = { "Normal", "Ghost" }, moves = { "Bitter Malice", "Foul Play" }, guids = { "b02e47", "f46ea3" }, model_GUID = "ddf643", offset={x=0, y=0.21, z=-0.09}, custom_scale=0.6 },
  { name = "Galarian Stunfisk",level = 3, types = { "Ground", "Steel" }, moves = { "Metal Claw", "Mud Shot" },     guids = { "d1fcec" }, model_GUID = "c91cc9" },
  { name = "Hisuian Braviary", level = 6, types = { "Psychic", "Flying" },moves = { "Esper Wing", "Brave Bird" },   guids = { "29010a", "aaa239" }, model_GUID = "7a1e79", offset={x=0, y=0.21, z=-0.07}, custom_scale=0.6 },
  { name = "Hisuian Sliggoo",  level = 4, types = { "Steel", "Dragon" },  moves = { "Dragon Pulse", "Acid Armor" }, guids = { "105e3c", "3ed28a" },  evoData = { { cost = 3, ball = RED , gen = 8, guids = { "3d0228", "c49cfb"} } }, model_GUID = "d73f52", offset={x=0, y=0.21, z=-0.1}, custom_scale=0.5 },
  { name = "Hisuian Goodra",   level = 7, types = { "Steel", "Dragon" },  moves = { "Iron Head", "Hydro Pump" },    guids = { "81bf31", "3d0228", "c49cfb" }, model_GUID = "837255", offset={x=0, y=0.21, z=-0.07}, custom_scale=0.6 }, 
  { name = "Hisuian Avalugg",  level = 5, types = { "Ice", "Rock" }, moves = { "Rock Slide", "Ice Shard" }, guids = { "06528c", "2edcdb" }, model_GUID = "9c5c23", custom_scale=0.28, offset={x=0, y=0.21, z=-0.15} },
  { name = "Hisuian Decidueye",level = 5, types = { "Grass", "Fighting" },  moves = { "Triple Arrows", "Leaf Storm" }, guids = { "655289", "cf7b80", "5ada77" }, model_GUID = "195008", offset={x=0, y=0.3, z=-0.07}, custom_scale=0.6 },

  -- Mega evolutions.
  { name = "GMax Rillaboom",       level = 5, types = { "Grass" },    moves = { "Drum Solo", "Strike" },                guids = { "d98c1f", "712942" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "d4a518", "2eba49", "f9d565" }, model_GUID = "2a352f" } }, model_GUID = "6e7118", custom_scale=0.3 },
  { name = "GMax Cinderace",       level = 5, types = { "Fire" },     moves = { "Fireball", "Airstream" },              guids = { "0ae3eb", "35db21" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "68e885", "e52d3f", "77f114" }, model_GUID = "edbb96" } }, model_GUID = "5fd307", custom_scale=0.65 },
  { name = "GMax Inteleon",        level = 5, types = { "Water" },    moves = { "Hydro Snipe", "Flutterby" },           guids = { "834995", "e4f6e7" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "a87b0f", "caa8d1", "70e2dd" }, model_GUID = "289431" } }, model_GUID = "1e011b", offset={x=-0.03, y=0, z=0.04} },
  { name = "GMax Corviknight",     level = 6, types = { "Flying", "Steel" }, moves = { "Wind Rage", "Steelspike" },     guids = { "ea919f", "1c820c" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "d80b24", "29b1df", "39c41f" }, model_GUID = "1515e6" } }, model_GUID = "751679" },
  { name = "GMax Orbeetle",        level = 4, types = { "Bug", "Psychic" }, moves = { "Gravitas", "Flutterby" },        guids = { "27ad44", "aee305" },       evoData = { { cost = 0, ball = BLUE, gen = 8, cycle = true, guids = { "4150f3", "6e7247", "eb4403" } } }, model_GUID = "100a08" },
  { name = "GMax Drednaw",         level = 3, types = { "Water", "Rock" }, moves = { "Stonesurge", "Darkness" },        guids = { "8054c2", "5cb470" },       evoData = { { cost = 0, ball = BLUE, gen = 8, cycle = true, guids = { "620b5e", "bf22b0" }, model_GUID = "0ab337" } }, model_GUID = "72b7ce", custom_scale=0.7 },
  { name = "GMax Coalossal",       level = 5, types = { "Rock", "Fire" }, moves = { "Volcalith", "Flare" },             guids = { "423aca", "6407e4" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "6ac20e", "678720", "5eecb1" }, model_GUID = "e7e32a" } }, model_GUID = "dfe276", custom_scale=0.6 },
  { name = "GMax Flapple",         level = 4, types = { "Grass", "Dragon" },    moves = { "Tartness", "Wyrmwind" },     guids = { "c4ec8a", "975b3c" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "beb575", "508cc7" }, model_GUID = "c9aba6" } }, model_GUID = "62fbcf", custom_scale=0.5, offset={x=0, y=1.0, z=0} },
  { name = "GMax Appletun",        level = 4, types = { "Grass", "Dragon" },    moves = { "Sweetness", "Wyrmwind" },    guids = { "945af3", "31aacc" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "a26f34", "3a326b" }, model_GUID = "8997a1" } }, model_GUID = "b87e45", custom_scale=0.5, offset={x=0, y=1.0, z=0} },
  { name = "GMax Sandaconda",      level = 5, types = { "Ground" },   moves = { "Sandblast", "Guard" },                 guids = { "2e2482", "3ab61a" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "c91baf", "3e0da6" }, model_GUID = "d15ad0" } }, model_GUID = "1e2e60" },
  { name = "GMax Toxtricity",      level = 4, types = { "Electric", "Poison" }, moves = { "Stun Shock", "Ooze" },       guids = { "1644af", "f8615c" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "0c6876", "bea82d" }, model_GUID = "42a6c3" } }, model_GUID = "7c090f", custom_scale=0.5 },
  { name = "GMax Toxtricity",      level = 4, types = { "Electric", "Poison" }, moves = { "Stun Shock", "Ooze" },       guids = { "8c4dd2", "e01e0a" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "67ec92", "a7277f" }, model_GUID = "4d9bff" } }, model_GUID = "7c090f", custom_scale=0.5 },
  { name = "GMax Centiskorch",     level = 4, types = { "Fire", "Bug" },     moves = { "Centiferno", "Flutterby" },     guids = { "457776", "f8726f" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "5b2923", "bf95c2" }, model_GUID = "a1917b" } }, model_GUID = "6bd6e4", custom_scale=0.65 },
  { name = "GMax Hatterene",       level = 6, types = { "Psychic", "Fairy" },  moves = { "Mindstorm", "Smite" },        guids = { "0fab1b", "73ef1b" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "e711fc", "9cfe10", "42db1f" }, model_GUID = "9ac795" } }, model_GUID = "9219a8" },
  { name = "GMax Grimmsnarl",      level = 6, types = { "Dark", "Fairy" }, moves = { "Snooze", "Starfall" },            guids = { "671823", "325e58" },       evoData = { { cost = 0, ball = RED, gen = 8, cycle = true, guids = { "9a62bf", "09fbc4", "1d1bc9" }, model_GUID = "3db539" } }, model_GUID = "e31f45", custom_scale=0.7 },
  { name = "GMax Alcremie",        level = 3, types = { "Fairy" },    moves = { "Finale", "Guard" },                    guids = { "3c5cba", "0b4ee1" },       evoData = { { cost = 0, ball = BLUE, gen = 8, cycle = true, guids = { "71833d", "f57bd3" } } }, model_GUID = "c54873", custom_scale=0.4, offset={x=0, y=1.0, z=0} },
  { name = "GMax Copperajah",      level = 5, types = { "Steel" },    moves = { "Steelsurge", "Quake" },                guids = { "ad2c75", "1e68f7" },       evoData = { { cost = 0, ball = BLUE, gen = 8, cycle = true, guids = { "772688", "bb0dab" } } }, model_GUID = "be6c58", custom_scale=0.6 },
  { name = "GMax Duraludon",       level = 5, types = { "Steel", "Dragon" },    moves = { "Wyrmwind", "Depletion" },    guids = { "e17508", "ff891b" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, cycle = true, guids = { "19c226" }, model_GUID = "397452" } }, model_GUID = "a14b0f", custom_scale=0.5 },
  { name = "GMax Eternatus",       level = 7, types = { "Poison", "Dragon" },   moves = { "Eternabeam", "Ooze" },                 guids = { "e78955" },                 evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "c0d41b" } } }, model_GUID = "865247", offset={x=0, y=0, z=1.5} },
  { name = "GMax R.S. Urshifu",    level = 7, types = { "Fighting", "Water" }, moves = { "Rapid Flow", "Knuckle" },     guids = { "bf033c" },                 evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "ab896e" } } }, model_GUID = "6c1d60", custom_scale=0.7 },
  { name = "GMax S.S. Urshifu",    level = 7, types = { "Fighting", "Dark" }, moves = { "One Blow", "Knuckle" },        guids = { "dd3373" },                 evoData = { { cost = 0, ball = LEGENDARY, gen = 8, cycle = true, guids = { "015ff0" } } }, model_GUID = "4491c0", custom_scale=0.7 },
}

gen9PokemonData =
{
  -- Gen 9 906-925
  { name = "Sprigatito",    level = 1, types = { "Grass" }, moves = { "Tail Whip", "Leafage" },    guids = { "49980a" },               evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "d04b95" } } }, model_GUID = "e259a9", offset={x=0, y=0.035, z=0} },
  { name = "Floragato",     level = 3, types = { "Grass" }, moves = { "Hone Claws", "Seed Bomb" },   guids = { "195a4d", "d04b95" },     evoData = { { cost = 2, ball = RED, gen = 9, guids = { "2b0cec", "603216" } } }, model_GUID = "43882c", offset={x=0, y=0.035, z=0} },
  { name = "Meowscarada",   level = 5, types = { "Grass", "Dark" }, moves = { "Flower Trick", "Knock Off" },     guids = { "7b87eb", "2b0cec", "603216" }, model_GUID = "5684f7" },
  { name = "Fuecoco",       level = 1, types = { "Fire" }, moves = { "Ember", "Leer" },         guids = { "53ad3b" },               evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "2a93fc" } } }, model_GUID = "1f41ed", offset={x=0, y=0.035, z=0} },
  { name = "Crocalor",      level = 3, types = { "Fire" }, moves = { "Incinerate", "Bite" }, guids = { "f49cc4", "2a93fc" },   evoData = { { cost = 2, ball = RED, gen = 9, guids = { "0528b7", "91d3a3" } } }, model_GUID = "54f5c5", offset={x=0, y=0.2, z=0} },
  { name = "Skeledirge",    level = 5, types = { "Fire", "Ghost" }, moves = { "Shadow Ball", "Torch Song" }, guids = { "6b9ddf", "0528b7", "91d3a3" }, model_GUID = "57d1c7", offset={x=0, y=0.11, z=0} },
  { name = "Quaxly",        level = 1, types = { "Water" }, moves = { "Water Gun", "Growl" },    guids = { "4a2233" },               evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "76b74f" } } }, model_GUID = "14aae3" },
  { name = "Quaxwell",      level = 3, types = { "Water" }, moves = { "Feather Dance", "Aqua Jet" }, guids = { "dc2818", "76b74f" },    evoData = { { cost = 2, ball = RED, gen = 9, guids = { "517d88", "7bf3d4" } } }, model_GUID = "676de9", offset={x=0, y=0.02, z=0} },
  { name = "Quaquaval",     level = 5, types = { "Water", "Fighting" }, moves = { "Aqua Step", "Counter" }, guids = { "07d04b", "517d88", "7bf3d4" }, model_GUID = "8db18f", offset={x=0, y=0.015, z=0} },
  { name = "Lechonk",       level = 1, types = { "Normal" }, moves = { "Tackle", "Tail Whip" }, guids = { "fa7a0e" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "731928" } }, { cost = 2, ball = BLUE, gen = 9, guids = { "9bc692" } } }, model_GUID = "066e52", offset={x=0, y=0.07, z=0} },
  { name = "Oinkologne (F)",level = 3, types = { "Normal" }, moves = { "Headbutt", "Yawn" },  guids = { "286c12", "731928" }, model_GUID = "2e147e", offset={x=0, y=0.05, z=0}, ball = BLUE },
  { name = "Oinkologne (M)",level = 3, types = { "Normal" }, moves = { "Take Down", "Work Up" }, guids = { "4a7427", "9bc692" }, model_GUID = "999693", offset={x=0, y=0.05, z=0}, ball = BLUE },
  { name = "Tarountula",    level = 1, types = { "Bug" }, moves = { "String Shot", "Tackle" },     guids = { "990287" },     evoData = { { cost = 2, ball = GREEN, gen = 9, guids = { "c3494f" } } }, model_GUID = "98fc19" },
  { name = "Spidops",       level = 3, types = { "Bug" }, moves = { "Circle Throw", "Silk Trap" }, guids = { "df9262", "c3494f" }, model_GUID = "c6e615", offset={x=0, y=0.05, z=0} },
  { name = "Nymble",        level = 1, types = { "Bug" }, moves = { "Double Kick", "Leer" }, guids = { "6bf5d7" }, evoData = { { cost = 2, ball = GREEN, gen = 9, guids = { "a8959f" } } }, model_GUID = "278a93" },
  { name = "Lokix",         level = 3, types = { "Bug", "Dark" }, moves = { "First Impression", "Assurance" }, guids = { "2f2f62", "a8959f" }, model_GUID = "c8e6c8", offset={x=0, y=0.025, z=0} },
  { name = "Pawmi",         level = 1, types = { "Electric" }, moves = { "Nuzzle", "Growl" }, guids = { "6126de" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "27ce58" } } }, model_GUID = "61a3c8", offset={x=0, y=0.04, z=0} },
  { name = "Pawmo",         level = 3, types = { "Electric", "Fighting" }, moves = { "Arm Thrust", "Spark" }, guids = { "63603f", "27ce58" }, evoData = { { cost = 1, ball = YELLOW, gen = 9, guids = { "d01611", "508f9a" } } }, model_GUID = "ec93e5", offset={x=0, y=0.015, z=0} },
  { name = "Pawmot",        level = 4, types = { "Electric", "Fighting" }, moves = { "Revival Blessing", "Discharge" }, guids = { "b34f73", "d01611", "508f9a" }, model_GUID = "06aaa6" },
  { name = "Tandemaus",     level = 2, types = { "Normal" }, moves = { "Baby-Doll Eyes", "Super Fang" },     guids = { "4400f3" }, evoData = { { cost = 1, ball = GREEN, gen = 9, guids = { "d8928e" } } }, model_GUID = "115d4b"  }, 
  { name = "Maushold",      level = 3, types = { "Normal" }, moves = { "Pop. Bomb", "Beat Up" },     guids = { "eb502b", "d8928e" }, model_GUID = "833536"  },

  -- Gen 9 926-949
  { name = "Fidough",       level = 1, types = { "Fairy" }, moves = { "Baby-Doll Eyes", "Covet" }, guids = { "4e8b42" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "acaf9b" } } }, model_GUID = "974906", offset={x=0, y=0.025, z=0} },
  { name = "Dachsbun",      level = 3, types = { "Fairy" }, moves = { "Play Rough", "Crunch" },   guids = { "90d0bb", "acaf9b" }, model_GUID = "a4dea5", offset={x=0, y=0.035, z=0} }, 
  { name = "Smoliv",        level = 2, types = { "Grass", "Normal" }, moves = { "Growth", "Absorb" },   guids = { "478ad3" }, evoData = { { cost = 1, ball = GREEN, gen = 9, guids = { "70af04" } } }, model_GUID = "369e79" }, 
  { name = "Dolliv",        level = 3, types = { "Grass", "Normal" }, moves = { "Seed Bomb", "Tackle" },   guids = { "c00c7c", "70af04" }, evoData = { { cost = 2, ball = YELLOW, gen = 9, guids = { "46e56c", "8bf8dd" } } }, model_GUID = "6c7c13", offset={x=0, y=0.06, z=0} },
  { name = "Arboliva",      level = 5, types = { "Grass", "Normal" }, moves = { "Grassy Terrain", "Terrain Pulse" }, guids = { "31acf0", "46e56c", "8bf8dd" }, model_GUID = "644663", offset={x=0, y=0.025, z=0} },
  { name = "Squawkabilly",  level = 3, types = { "Flying", "Normal" }, moves = { "Mimic", "Fly" },  guids = { "1968bc" }, model_GUID = "e3085d", offset={x=0, y=0.025, z=0} },
  { name = "Nacli",         level = 2, types = { "Rock" }, moves = { "Rock Throw", "Harden" }, guids = { "3b9f04" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "0d54a8" } } }, model_GUID = "e2f332"  },
  { name = "Naclstack",     level = 4, types = { "Rock" }, moves = { "Salt Cure", "Mud Shot" },  guids = { "69cf19", "0d54a8" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "1c0e4e", "7c6d2b" } } }, model_GUID = "300175", offset={x=0, y=0.05, z=0} },
  { name = "Garganacl",     level = 6, types = { "Rock" }, moves = { "Hammer Arm", "Stone Edge" }, guids = { "9aaabb", "1c0e4e", "7c6d2b" }, model_GUID = "0ffa2c", offset={x=0, y=0.05, z=0} },
  { name = "Charcadet",     level = 3, types = { "Fire" }, moves = { "Flame Charge", "Astonish" }, guids = { "0f63f8" },  evoData = { { cost = 1, ball = YELLOW, gen = 9, guids = { "7a4b5f" } }, { cost = 1, ball = YELLOW, gen = 9, guids = { "3fc935" } } }, model_GUID = "002c16" },
  { name = "Armarouge",     level = 4, types = { "Fire", "Psychic" }, moves = { "Lava Plume", "Psyshock" },  guids = { "72da86", "7a4b5f" }, model_GUID = "1283d5", offset={x=0, y=0.03, z=0} }, 
  { name = "Ceruledge",     level = 4, types = { "Fire", "Ghost" }, moves = { "Shadow Claw", "Fire Spin" }, guids = { "9d5def", "3fc935" }, model_GUID = "5bcb74", offset={x=0, y=0.03, z=0} }, 
  { name = "Tadbulb",       level = 2, types = { "Electric" }, moves = { "Thunder Shock", "Mud-Slap" },     guids = { "fc24d2" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "7dbae8" } } }, model_GUID = "cfebba", offset={x=0, y=0.05, z=0} }, 
  { name = "Bellibolt",     level = 3, types = { "Electric" }, moves = { "Sucker Punch", "Discharge" },  guids = { "d11554", "7dbae8" }, model_GUID = "7753e7", custom_scale=0.8, offset={x=0, y=0.03, z=0} }, 
  { name = "Wattrel",       level = 2, types = { "Electric", "Flying" }, moves = { "Growl", "Peck" },    guids = { "388592" },  evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "a10303" } } }, model_GUID = "a285c1", offset={x=0, y=0.05, z=0} },
  { name = "Kilowattrel",   level = 4, types = { "Electric", "Flying" }, moves = { "Dual Wingbeat", "Spark" },    guids = { "81d760", "a10303" }, model_GUID = "af9df4"  },
  { name = "Maschiff",      level = 2, types = { "Dark" }, moves = { "Bite", "Roar" }, guids = { "8cb576" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "41dfa5" } } }, model_GUID = "33b41b", offset={x=0, y=0.08, z=0} },
  { name = "Mabosstiff",    level = 4, types = { "Dark" }, moves = { "Double-Edge", "Jaw Lock" },   guids = { "3e9b8c", "41dfa5" }, model_GUID = "f4d83c", offset={x=0, y=0.4, z=0} }, 
  { name = "Shroodle",      level = 2, types = { "Poison", "Normal" }, moves = { "Fury Swipes", "Acid Spray" }, guids = { "bd638c" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "74dde9" } } }, model_GUID = "d41d88", offset={x=0, y=0.05, z=0} },
  { name = "Grafaiai",      level = 3, types = { "Poison", "Normal" }, moves = { "Poison Jab", "Slash" }, guids = { "32bf28", "74dde9" }, model_GUID = "b9a306", offset={x=0, y=0.08, z=0} },
  { name = "Bramblin",      level = 3, types = { "Grass", "Ghost" }, moves = { "Bullet Seed", "Rollout" }, guids = { "845718" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "6160d0" } } }, model_GUID = "7a6b7e" }, 
  { name = "Brambleghast",  level = 4, types = { "Grass", "Ghost" }, moves = { "Phantom Force", "Mega Drain" },  guids = { "651132", "6160d0" }, model_GUID = "b786a2", offset={x=0, y=0.08, z=0} }, 
  { name = "Toedscool",     level = 2, types = { "Ground", "Grass" }, moves = { "Absorb", "Wrap" },    guids = { "81b348" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "fdc646" } } }, model_GUID = "077ead", offset={x=0, y=0.05, z=0} },
  { name = "Toedscruel",    level = 4, types = { "Ground", "Grass" }, moves = { "Power Whip", "Mud Shot" },  guids = { "73fe95", "fdc646" }, model_GUID = "0ac636", offset={x=0, y=0.08, z=0} },

  -- Gen 9 950-975
  { name = "Klawf",         level = 4, types = { "Rock" }, moves = { "Rock Slide", "X-Scissor" }, guids = { "3478a3" }, model_GUID = "544071" },
  { name = "Capsakid",      level = 3, types = { "Grass" }, moves = { "Headbutt", "Leafage" },       guids = { "136e8c" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "feb4ee" } } }, model_GUID = "ba1773", offset={x=0, y=0.06, z=0} }, 
  { name = "Scovillain",    level = 4, types = { "Grass", "Fire" }, moves = { "Flamethrower", "Spicy Extract" }, guids = { "89e811", "feb4ee" }, model_GUID = "d32bc2", offset={x=0, y=0.05, z=0} },
  { name = "Rellor",        level = 3, types = { "Bug" }, moves = { "Struggle Bug", "Rollout" },   guids = { "e30571" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "ba0ca7" } } }, model_GUID = "947205", offset={x=0, y=0.05, z=0} },
  { name = "Rabsca",        level = 4, types = { "Bug", "Psychic" }, moves = { "Bug Buzz", "Psychic" },      guids = { "2de0bb", "ba0ca7" }, model_GUID = "e06b27" },
  { name = "Flittle",       level = 3, types = { "Psychic" }, moves = { "Confusion", "Peck" },       guids = { "ee1263" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "ba6a6d" } } }, model_GUID = "a5094b" },
  { name = "Espathra",      level = 5, types = { "Psychic" }, moves = { "Feather Dance", "Lumina Crash" }, guids = { "857c58", "ba6a6d" }, model_GUID = "e2c2ec" }, 
  { name = "Tinkatink",     level = 2, types = { "Fairy", "Steel" }, moves = { "Astonish", "Fairy Wind" }, guids = { "c3d19f" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "e71fa5" } } }, model_GUID = "be9ee6", offset={x=0, y=0.08, z=0.08} }, 
  { name = "Tinkatuff",     level = 4, types = { "Fairy", "Steel" }, moves = { "Flash Cannon", "Brutal Swing" }, guids = { "e7f434", "e71fa5" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "746894", "b76ffe" } } }, model_GUID = "8b4cd9", offset={x=0, y=0.065, z=0} },
  { name = "Tinkaton",      level = 6, types = { "Fairy", "Steel" }, moves = { "Gigaton Hammer", "Play Rough" }, guids = { "1dd00a", "746894", "b76ffe" }, model_GUID = "3e73d2", offset={x=0, y=0.09, z=0} }, 
  { name = "Wiglett",       level = 2, types = { "Water" }, moves = { "Mud-Slap", "Aqua Jet" }, guids = { "525157" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "f7f56d" } } }, model_GUID = "418999", offset={x=0, y=0.05, z=0} },
  { name = "Wugtrio",       level = 4, types = { "Water" }, moves = { "Sucker Punch", "Triple Dive" }, guids = { "a82b90", "f7f56d" }, model_GUID = "d1417a", offset={x=0, y=0.5, z=0} },
  { name = "Bombirdier",    level = 4, types = { "Flying", "Dark" }, moves = { "Dual Wingbeat", "Knock Off" }, guids = { "ed2e7c" }, model_GUID = "7cbbd7"  },
  { name = "Finizen",       level = 5, types = { "Water" }, moves = { "Double Hit", "Aqua Jet" }, guids = { "0873a6" }, evoData = { { cost = 1, ball = RED, gen = 9, guids = { "ffb871" } }, { cost = 1, ball = RED, gen = 9, guids = { "e40792" } } }, model_GUID = "dae5c1", offset={x=0, y=0.05, z=0} },
  { name = "Hero Palafin",  level = 6, types = { "Water" }, moves = { "Close Combat", "Jet Punch" }, guids = { "b40995", "e40792" }, model_GUID = "4e48f2", ball = RED },
  { name = "Zero Palafin",  level = 6, types = { "Water" }, moves = { "Zen Headbutt", "Flip Turn" }, guids = { "fd6f39", "ffb871" }, model_GUID = "ca3455", ball = RED },
  { name = "Varoom",        level = 3, types = { "Steel", "Poison" }, moves = { "Screech", "Smog" }, guids = { "039292" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "f620af" } } }, model_GUID = "108e50", offset={x=0, y=0.05, z=0} }, 
  { name = "Revavroom",     level = 5, types = { "Steel", "Poison" }, moves = { "Spin Out", "Sludge" }, guids = { "be3478", "f620af" }, model_GUID = "b52a71" }, 
  { name = "Cyclizar",      level = 4, types = { "Dragon", "Normal" }, moves = { "Dragon Rush", "Quick Attack" }, guids = { "7282b5"  }, model_GUID = "c6de36", custom_scale=0.6, offset={x=0, y=0.08, z=0} },
  { name = "Orthworm",      level = 3, types = { "Steel" }, moves = { "Earthquake", "Iron Tail" }, guids = { "9b54aa" }, model_GUID = "ca265d", custom_scale=0.5, offset={x=0, y=0.05, z=-0.05} }, 
  { name = "Glimmet",       level = 2, types = { "Rock", "Poison" }, moves = { "Toxic Spikes", "Rock Throw" }, guids = { "731ab7" }, evoData = { { cost = 2, ball = YELLOW, gen = 9, guids = { "58f282" } } }, model_GUID = "7e547c", offset={x=0, y=0.05, z=0} },
  { name = "Glimmora",      level = 4, types = { "Rock", "Poison" }, moves = { "Ancient Power", "Mortal Spin" }, guids = { "137bbd", "58f282" }, model_GUID = "53b746", offset={x=0, y=0.1, z=0} },
  { name = "Greavard",      level = 2, types = { "Ghost" }, moves = { "Growl", "Lick" }, guids = { "f0f80b" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "54b1df" } } }, model_GUID = "235491", offset={x=0, y=0.05, z=0} },
  { name = "Houndstone",    level = 4, types = { "Ghost" }, moves = { "Last Respects", "Dig" }, guids = { "b7d0d5", "54b1df" }, model_GUID = "b41299", offset={x=0, y=0.08, z=0} },                   
  { name = "Flamigo",       level = 3, types = { "Flying", "Fighting" }, moves = { "Double Kick", "Air Slash" }, guids = { "29bdc6" }, model_GUID = "576665" }, 
  { name = "Cetoddle",      level = 3, types = { "Ice" }, moves = { "Echoed Voice", "Ice Shard" }, guids = { "cc2b2f" }, evoData = { { cost = 1, ball = YELLOW, gen = 9, guids = { "3a0f0c" } } }, model_GUID = "673d94", offset={x=0, y=0.05, z=0} }, 
  { name = "Cetitan",       level = 4, types = { "Ice" }, moves = { "Double-Edge", "Ice Spinner" }, guids = { "22914e", "3a0f0c" }, model_GUID = "0196c4", custom_scale=0.5, offset={x=0, y=0.15, z=-0.12} },
  
  --Gen 9 976-1000
  { name = "Veluza",        level = 3, types = { "Water", "Psychic" }, moves = { "Psychic Fangs", "Fillet Away" }, guids = { "f19255" }, model_GUID = "585814", offset={x=0, y=0.05, z=0} }, 
  { name = "Dondozo",       level = 4, types = { "Water" }, moves = { "Wave Crash", "Order Up" }, guids = { "1703be" }, model_GUID = "59fb5d", custom_scale=0.3, offset={x=0, y=0.75, z=-0.025} }, 
  { name = "Curly Tatsugiri", level = 3, types = { "Dragon", "Water" }, moves = { "Water Pulse", "Dragon Pulse" }, guids = { "799368" }, model_GUID = "f23915", offset={x=0, y=0.05, z=0}, ball = BLUE },
  { name = "Droopy Tatsugiri", level = 3, types = { "Dragon", "Water" }, moves = { "Mirror Coat", "Dragon Pulse" }, guids = { "6e1311" }, model_GUID = "2be0f3", ball = BLUE },
  { name = "Stretchy Tatsugiri", level = 3, types = { "Dragon", "Water" }, moves = { "Nasty Plot", "Dragon Pulse" }, guids = { "a3ec4b" }, model_GUID = "e04ac1", ball = BLUE },
  { name = "Annihilape",    level = 5, types = { "Fighting", "Ghost" }, moves = { "Cross Chop", "Rage Fist" }, guids = { "87727d", "b68eb7", "6b4dfa" }, model_GUID = "bfd3d8" },
  { name = "Clodsire",      level = 3, types = { "Poison", "Ground" }, moves = { "Poison Tail", "Mud Shot" }, guids = { "11f231", "9299e4" }, model_GUID = "ed4234", offset={x=0, y=0.65, z=0} },
  { name = "Farigiraf",     level = 3, types = { "Normal", "Psychic" }, moves = { "Twin Beam", "Stomp" }, guids = { "ec3c21", "f18198" }, model_GUID = "6135b5", offset={x=0, y=0.08, z=0} }, 
  { name = "Dudunsparce",   level = 3, types = { "Normal" }, moves = { "Drill Run", "Hyper Drill" }, guids = { "f840fc", "9c40ab" }, model_GUID = "881817", offset={x=0, y=0.13, z=0} },
  { name = "Kingambit",     level = 6, types = { "Dark", "Steel" }, moves = { "Kowtow Cleave", "Iron Head" }, guids = { "97afd6", "d49464", "8625f7" }, model_GUID = "291920" },
  { name = "Great Tusk",    level = 5, types = { "Ground", "Fighting" }, moves = { "Brick Break", "Bulldoze" }, guids = { "00e061" }, model_GUID = "177723", custom_scale=0.35, offset={x=0, y=0.05, z=-0.08} },
  { name = "Scream Tail",   level = 3, types = { "Fairy", "Psychic" }, moves = { "Play Rough", "Psychic Fangs" }, guids = { "d2d1fc" }, model_GUID = "bba12d", offset={x=0, y=0.09, z=0} }, 
  { name = "Brute Bonnet",  level = 4, types = { "Grass", "Dark" }, moves = { "Sucker Punch", "Mega Drain" }, guids = { "d97f22" }, model_GUID = "dcbff5", offset={x=0, y=0.12, z=0} }, 
  { name = "Flutter Mane",  level = 4, types = { "Ghost", "Fairy" }, moves = { "Phantom Force", "Moonblast" }, guids = { "60305f" }, model_GUID = "366287" },
  { name = "Slither Wing",  level = 6, types = { "Bug", "Fighting" }, moves = { "Superpower", "Bug Bite" }, guids = { "163a86" }, model_GUID = "b0584a", offset={x=0, y=0.5, z=0} }, 
  { name = "Sandy Shocks",  level = 4, types = { "Electric", "Ground" }, moves = { "Earth Power", "Discharge" }, guids = { "c61a67" }, model_GUID = "6997f6", offset={x=0, y=0.07, z=0} }, 
  { name = "Iron Treads",   level = 5, types = { "Ground", "Steel" }, moves = { "Iron Head", "Earthquake" }, guids = { "2bba66" }, model_GUID = "a95a53", offset={x=0, y=0.08, z=0} }, 
  { name = "Iron Bundle",   level = 3, types = { "Ice", "Water" }, moves = { "Freeze-Dry", "Flip Turn" }, guids = { "90d798" }, model_GUID = "0a3a0d" },
  { name = "Iron Hands",    level = 4, types = { "Fighting", "Electric" }, moves = { "Thunder Punch", "Arm Thrust" }, guids = { "7b45a3" }, model_GUID = "d9346e" }, 
  { name = "Iron Jugulis",  level = 7, types = { "Dark", "Flying" }, moves = { "Dark Pulse", "Air Slash" }, guids = { "ff30bd" }, model_GUID = "b7947e" },
  { name = "Iron Moth",     level = 6, types = { "Fire", "Poison" }, moves = { "Sludge Wave", "Overheat" }, guids = { "68bff5" }, model_GUID = "397944" }, 
  { name = "Iron Thorns",   level = 7, types = { "Rock", "Electric" }, moves = { "Thunder Fang", "Stone Edge" }, guids = { "38c0c7" }, model_GUID = "e6ef22"  }, 
  { name = "Frigibax",      level = 2, types = { "Dragon", "Ice" }, moves = { "Icy Wind", "Leer" }, guids = { "3f40d1" }, evoData = { { cost = 2, ball = YELLOW, gen = 9, guids = { "907d41" } } }, model_GUID = "8a702e", offset={x=0, y=0.05, z=0} }, 
  { name = "Arctibax",      level = 4, types = { "Dragon", "Ice" }, moves = { "Dragon Claw", "Bite" }, guids = { "33a8b3", "907d41" }, evoData = { { cost = 3, ball = RED, gen = 9, guids = { "1dad71", "805f61" } } }, model_GUID = "22189b", offset={x=0, y=0.08, z=0} }, 
  { name = "Baxcalibur",    level = 7, types = { "Dragon", "Ice" }, moves = { "Icicle Crash", "Glaive Rush" }, guids = { "1d7ffe", "1dad71", "805f61" }, model_GUID = "f78096", offset={x=0, y=0.23, z=0} },
  { name = "Gimmighoul",    level = 3, types = { "Ghost" }, moves = { "Astonish", "Tackle" }, guids = { "c63945" }, evoData = { { cost = 3, ball = RED, gen = 9, guids = { "fa534f" } } }, model_GUID = "27ef3b" },
  { name = "Gholdengo",     level = 6, types = { "Steel", "Ghost" }, moves = { "Shadow Ball", "Make It Rain" }, guids = { "38ac21", "fa534f" }, model_GUID = "47cda4", offset={x=0, y=0.05, z=0} },

  --Gen 9 1001-1025
  { name = "Wo-Chien",      level = 7, types = { "Grass", "Dark" }, moves = { "Leaf Storm", "Ruination" }, guids = { "f9f24e" }, model_GUID = "0b9110", custom_scale=0.4, offset={x=0, y=0.03, z=0} },
  { name = "Chien-Pao",     level = 7, types = { "Ice", "Dark"  }, moves = { "Icicle Crash", "Ruination" }, guids = { "a4d468" }, model_GUID = "4907da", offset={x=0, y=0.1, z=0} }, 
  { name = "Ting-Lu",       level = 7, types = { "Ground", "Dark" }, moves = { "Earth Power", "Ruination" }, guids = { "c37f93" }, model_GUID = "bee4a1", custom_scale=0.85, offset={x=0, y=0, z=-0.03} },
  { name = "Chi-Yu",        level = 7, types = { "Fire", "Dark" }, moves = { "Lava Plume", "Ruination" }, guids = { "b9c9fd" }, model_GUID = "9b9d99"  },
  { name = "Roaring Moon",  level = 7, types = { "Dragon", "Dark" }, moves = { "Night Slash", "Dragon Claw" }, guids = { "eac784" }, model_GUID = "be6188", offset={x=0, y=1.25, z=0} },
  { name = "Iron Valiant",  level = 5, types = { "Fairy", "Fighting" }, moves = { "Close Combat", "Spirit Break" }, guids = { "d1f07b" }, model_GUID = "ea7156" },
  { name = "Koraidon",      level = 7, types = { "Fighting", "Dragon" }, moves = { "Collision Course", "Outrage" }, guids = { "a7a93a" }, model_GUID = "1a2585", custom_scale=0.7, offset={x=0, y=0.02, z=-0.03} }, 
  { name = "Miraidon",      level = 7, types = { "Electric", "Dragon" }, moves = { "Electro Drift", "Outrage" }, guids = { "c00d7b" }, model_GUID = "9319a8" },
  { name = "Walking Wake",  level = 7, types = { "Water", "Dragon" }, moves = { "Dragon Breath", "Hydro Pump" }, guids = { "f1495e" }, model_GUID = "eb0d69", offset={x=0, y=0.4, z=0} },
  { name = "Iron Leaves",   level = 7, types = { "Grass", "Psychic" }, moves = { "Solar Blade", "Psyblade" }, guids = { "6519a8" }, model_GUID = "b3f9e1", offset={x=0, y=0.08, z=0} },
  { name = "Dipplin",       level = 4, types = { "Grass", "Dragon" }, moves = { "Infestation", "Dragon Tail" }, guids = { "2990ba", "951a30" }, evoData = { { cost = 1, ball = RED, gen = 9, guids = { "7b9062", "e5ee39" } } }, model_GUID = "756f2e", offset={x=0, y=0.08, z=0} }, 
  { name = "Hydrapple",     level = 5, types = { "Grass", "Dragon" }, moves = { "Fickle Beam", "Syrup Bomb" }, guids = { "dcee5f", "7b9062", "e5ee39" }, model_GUID = "6cfa18", offset={x=0, y=0.06, z=0} },
  { name = "Poltchageist",  level = 3, types = { "Grass", "Ghost" }, moves = { "Astonish", "Absorb" }, guids = { "147af7" }, evoData = { { cost = 1, ball = BLUE , gen = 9, guids = { "fae06f" } } }, model_GUID = "c9df55" }, 
  { name = "Sinistcha",     level = 4, types = { "Grass", "Ghost" }, moves = { "Matcha Gotcha", "Hex" }, guids = { "9df0d7", "fae06f" }, model_GUID = "5548f3", offset={x=0, y=0.08, z=0} },
  { name = "Okidogi",       level = 7, types = { "Fighting", "Poison" }, moves = { "Force Palm", "Poison Jab" }, guids = { "e4b697" }, model_GUID = "6bc44c", offset={x=0, y=0.02, z=-0.05} }, 
  { name = "Munkidori",     level = 7, types = { "Psychic", "Poison" }, moves = { "Sludge Wave", "Future Sight" }, guids = { "db6cf9" }, model_GUID = "2cb705", offset={x=0, y=0.05, z=-0.03} },
  { name = "Fezandipiti",   level = 7, types = { "Fairy", "Poison" }, moves = { "Cross Poison", "Moonblast" }, guids = { "855095" }, model_GUID = "c1f95f", offset={x=0, y=0.08, z=0} },
  { name = "Teal Ogerpon",  level = 7, types = { "Grass" }, moves = { "Ivy Cudgel Grass", "Counter" }, guids = { "a92e73" }, model_GUID = "8bd4f2", offset={x=0, y=0.125, z=0}, ball = LEGENDARY },               -- Grass
  { name = "Cornerstone Ogerpon", level = 7, types = { "Rock", "Grass" }, moves = { "Ivy Cudgel Rock", "Counter" }, guids = { "210bcc" }, model_GUID = "59a998", offset={x=0, y=0.125, z=0}, ball = LEGENDARY },  -- Rock
  { name = "Hearthflame Ogerpon", level = 7, types = { "Fire", "Grass" }, moves = { "Ivy Cudgel Fire", "Counter" }, guids = { "480b42" }, model_GUID = "3cbcf7", offset={x=0, y=0.155, z=0}, ball = LEGENDARY },  -- Fire
  { name = "Wellspring Ogerpon", level = 7, types = { "Water", "Grass" }, moves = { "Ivy Cudgel Water", "Counter" }, guids = { "ce1aac" }, model_GUID = "c7fad2", offset={x=0, y=0.155, z=0}, ball = LEGENDARY }, -- Water
  { name = "Archaludon",    level = 6, types = { "Steel", "Dragon" }, moves = { "Electro Shot", "Breaking Swipe" }, guids = { "3d2744", "3a6873" }, model_GUID = "eaa506" },
  { name = "Gouging Fire",  level = 7, types = { "Fire", "Dragon" }, moves = { "Raging Fury", "Dragon Claw" }, guids = { "ae5249" }, model_GUID = "888c80", custom_scale=0.35, offset={x=0,y=0,z=-0.1} },
  { name = "Raging Bolt",   level = 7, types = { "Electric", "Dragon" }, moves = { "Dragon Hammer", "Thunderclap" }, guids = { "d32bf4" }, model_GUID = "fa6e02", custom_scale=0.45, offset={x=0, y=0, z=-0.06} }, 
  { name = "Iron Boulder",  level = 7, types = { "Rock", "Psychic" }, moves = { "Mighty Cleave", "Psycho Cut" }, guids = { "fa15fd" }, model_GUID = "5cc279", custom_scale=0.8, offset={x=0, y=0.05, z=-0.03} }, 
  { name = "Iron Crown",    level = 7, types = { "Steel", "Psychic" }, moves = { "Tachyon Cutter", "Future Sight" }, guids = { "fae0a8" }, model_GUID = "14aae9", offset={x=0, y=0.05, z=-0.03} },
  { name = "Terapagos",     level = 7, types = { "Normal" }, moves = { "Tera Starstorm", "Protect" }, guids = { "686877" }, model_GUID = "3978cf", offset={x=0, y=0.08, z=0} }, 
  { name = "Pecharunt",     level = 7, types = { "Poison", "Ghost" }, moves = { "Malignant Chain", "Shadow Ball" }, guids = { "114b25" }, model_GUID = "95aeac", offset={x=0, y=0.1, z=0} }, 
  { name = "Combat Tauros", level = 4, types = { "Fighting" }, moves = { "Double-Edge", "Raging Bull Fighting" }, guids = { "16d4a9" }, model_GUID = "4b1408", custom_scale=0.85, offset={x=0, y=0.075, z=0}, ball = YELLOW },       -- Fighting
  { name = "Aqua Tauros",   level = 4, types = { "Water", "Fighting" }, moves = { "Double Kick", "Raging Bull Water" }, guids = { "e464b6" }, model_GUID = "8b48ce", custom_scale=0.85, offset={x=0, y=0.075, z=0}, ball = YELLOW }, -- Water
  { name = "Blaze Tauros",  level = 4, types = { "Fire", "Fighting" }, moves = { "Double Kick", "Raging Bull Fire" }, guids = { "723f82" }, model_GUID = "5827a9", custom_scale=0.85, offset={x=0, y=0.075, z=0}, ball = YELLOW },   -- Fire
  { name = "Paldean Wooper",level = 1, types = { "Poison", "Ground" }, moves = { "Toxic Spikes", "Slam" }, guids = { "d95619" }, evoData = { { cost = 2, ball = BLUE , gen = 9, guids = { "9299e4" } } }, model_GUID = "41ff5e" }
}

genData = { gen1PokemonData, gen2PokemonData, gen3PokemonData, gen4PokemonData, gen5PokemonData, gen6PokemonData, gen7PokemonData, gen8PokemonData, gen9PokemonData }

moveData =
{
    -- Bug
    {name="Attack Order",   power=2,      type="Bug",       dice=8, STAB=true   },
    {name="Bug Bite",       power=2,      type="Bug",       dice=6, STAB=true   },
    {name="Bug Buzz",       power=2,      type="Bug",       dice=6, aTAB=true,  effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Defend Order",   power=0,      type="Bug",       dice=6, STAB=false, effects={{name="AttackDown2", target="Enemy"}} },
    {name="Fell Stinger",   power=1,      type="Bug",       dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="First Impression",power=2,     type="Bug",       dice=6, STAB=true,  effects={{name="Priority", target="Self"}} },
    {name="Fury Cutter",    power=1,      type="Bug",       dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Infestation",    power=2,      type="Bug",       dice=4, STAB=true,  effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Leech Life",     power=2,      type="Bug",       dice=6, STAB=true   },
    {name="Lunge",          power=3,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Megahorn",       power=3,      type="Bug",       dice=6, STAB=true   },
    {name="Pin Missile",    power=1,      type="Bug",       dice=4, STAB=true,  effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Pollen Puff",    power=3,      type="Bug",       dice=6, STAB=true   },
    {name="Quiver Dance",   power=0,      type="Bug",       dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Signal Beam",    power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Silk Trap",      power=0,      type="Bug",       dice=6, STAB=false, effects={{name="Protect"}} },
    {name="Silver Wind",    power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Steamroller",    power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="String Shot",    power=0,      type="Bug",       dice=6, STAB=false  },
    {name="Struggle Bug",   power=1,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Tail Glow",      power=0,      type="Bug",       dice=4, STAB=false, effects={{name="AttackUp2", target="Self"}} },
    {name="Twineedle",      power=1,      type="Bug",       dice=4, STAB=true,  effects={{name="Poison", target="Enemy", chance=5},{name="ExtraDice", target="Self"}} },
    {name="U-Turn",         power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="Switch", target="Self"}} },
    {name="X-Scissor",      power=2,      type="Bug",       dice=6, STAB=true   },
    {name="Befuddle",       power=2,      type="Bug",       dice=6, STAB=true,  effects={{"Custom"}} },
    {name="Flutterby",      power=3,      type="Bug",       dice=6, STAB=true,  effects={{"Custom"}} },
    {name="Savage Spin-Out",power=4,      type="Bug",       dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Pounce",         power=1,      type="Bug",       dice=6, STAB=true   },
    
    -- Dark
    {name="Assurance",      power=1,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Aura Wheel Dark",power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Beat Up",        power="Enemy",type="Dark",      dice=6, STAB=false },
    {name="Bite",           power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Brutal Swing",   power=2,      type="Dark",      dice=6, STAB=true },
    {name="Ceaseless Edge", power=3,      type="Dark",      dice=8, STAB=true },
    {name="Crunch",         power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Darkest Lariat", power=3,      type="Dark",      dice=6, STAB=true  },
    {name="Dark Pulse",     power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Embargo",        power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Fake Tears",     power=0,      type="Dark",      dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}} },
    {name="Feint Attack",   power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Fiery Wrath",    power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Foul Play",      power="Enemy",type="Dark",      dice=6, STAB=false  },
    {name="Hone Claws",     power=0,      type="Dark",      dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}}},
    {name="Hyperspace Fury",power=3,      type="Dark",      dice=6, STAB=false, effects={{name="AttackUp", target="Self"}} },
    {name="Jaw Lock",       power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Knock Off",      power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Kowtow Cleave",  power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Nasty Plot",     power=0,      type="Dark",      dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}} },
    {name="Night Slash",    power=2,      type="Dark",      dice=8, STAB=true   },
    {name="Payback",        power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Pursuit",        power=1,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} }, 
    {name="Punishment",     power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} }, 
    {name="Snarl",          power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Sucker Punch",   power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="Priority", target="Self"}}},
    {name="Ruination",      power="Enemy",type="Dark",      dice=6, STAB=true },
    {name="Taunt",          power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Thief",          power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Torment",        power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Wicked Blow",    power=3,      type="Dark",      dice=8, STAB=true },
    {name="Wicked Torque",  power=2,      type="Dark",      dice=8, STAB=true,  effects={{name="Sleep", target="Enemy", chance=6}} },
    {name="Throat Chop",    power=2,      type="Dark",      dice=6, STAB=true },
    {name="Darkness",       power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"} } },
    {name="Snooze",         power=2,      type="Dark",      dice=8, STAB=true,  effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="One Blow",       power=4,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"} } },
    {name="Night Daze",     power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Snatch",         power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"} } },
    {name="Black Hole Eclipse",power=4,   type="Dark",      dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Malicious Moonsault",power=5,  type="Dark",      dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },

    -- Dragon
    {name="D-max Cannon",   power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Dragon Claw",    power=2,      type="Dragon",    dice=6, STAB=true   },
    {name="Dragon Dance",   power=0,      type="Dragon",    dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}} },
    {name="Dragon Darts",   power=1,      type="Dragon",    dice=4, STAB=true,  effects={{name="ExtraDice", target="Self"}} },
    {name="Dragon Breath",  power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Dragon Energy",  power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Dragon Hammer",  power=3,      type="Dragon",    dice=6, STAB=true   },
    {name="Dragon Pulse",   power=2,      type="Dragon",    dice=6, STAB=true   },
    {name="Dragon Rage",    power=4,      type="Dragon",    dice=4, STAB=true,  effects={{name="Neutral", target="Self"}} },
    {name="Dragon Rush",    power=2,      type="Dragon",    dice=4, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Dragon Tail",    power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="Switch", target="Enemy"}} },
    {name="Dual Chop",      power=1,      type="Dragon",    dice=4, STAB=true,  effects={{name="ExtraDice", target="Self"}} },
    {name="Clanging Scales",power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Fickle Beam",    power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Glaive Rush",    power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Order Up",       power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Outrage",        power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="Confuse", target="Self", chance=5}} },
    {name="Roar of Time",   power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="Recharge", target="Self"}} },
    {name="Spacial Rend",   power=2,      type="Dragon",    dice=8, STAB=true   },
    {name="Twister",        power=1,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Breaking Swipe", power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}} },
    {name="Dragon Ascent",  power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Wyrmwind",       power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Eternabeam",     power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="Recharge", target="Self"}} },
    {name="Devastating Drake",power=4,    type="Dragon",    dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Clangorous Soulblaze",power=5, type="Dragon",    dice=6, STAB=false, effects={{name="Recharge", target="Self"}, {name="AttackUp", target="Self"}} },

    -- Electric
    {name="Aura Wheel Electric",power=3,  type="Electric",  dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Bolt Strike",    power=5,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Charge",         power=0,      type="Electric",  dice=6, STAB=false, effects={{name="AttackUp", target="Self", chance=3}} },
    {name="Charge Beam",    power=1,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"} } },
    {name="Discharge",      power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Electroweb",     power=2,      type="Electric",  dice=6, STAB=true},
    {name="Electro Ball",   power="Self", type="Electric",  dice=6, STAB=false},
    {name="Electro Drift",  power=2,      type="Electric",  dice=6, STAB=true},
    {name="Electro Shot",   power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"},{name="Recharge", target="Self"}}},
    {name="Fusion Bolt",    power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Nuzzle",         power=1,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy"}}},
    {name="Overdrive",      power=2,      type="Electric",  dice=6, STAB=true},
    {name="Plasma Fists",   power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Rev. Dance Electric",power=2,  type="Electric",  dice=6, STAB=true},
    {name="Shock Wave",     power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Spark",          power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Thunderbolt",    power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Thunderclap",    power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Priority", target="Self"} }},
    {name="Thunder",        power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Thunder Cage",   power=2,      type="Electric",  dice=4, STAB=true,  effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Thunder Fang",   power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Thunder Shock",  power=1,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Thunder Punch",  power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Thunder Wave",   power=0,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy"}} },
    {name="Volt Swtich",    power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Switch", target="Self"}} },
    {name="Wild Charge",    power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Wildbolt Storm", power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Zap Cannon",     power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=4}} },
    {name="Zing Zap",       power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Volt Tackle",    power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=5}} },
    {name="Volt Crash",     power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy"}} },
    {name="Stun Shock",     power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Gigavolt Havoc", power=4,      type="Electric",  dice=6, STAB=false, effects={{name="Recharge", target="Self"}} }, -- , , 
    {name="Catastropika",   power=5,      type="Electric",  dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="10MV Thunderbolt",power=5,     type="Electric",  dice=8, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Stoked Sparksurfer",power=4,   type="Electric",  dice=6, STAB=false, effects={{name="Recharge", target="Self"}, {name="Paralyse", target="Enemy", chance=5}} },
    {name="Volt Switch",    power=3,      type="Electric",  dice=6, STAB=false, effects={{name="Switch", target="Self"}} },
    {name="Eerie Impulse",  power=0,      type="Electric",  dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}} },

    -- Fairy
    {name="Baby-Doll Eyes", power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown", target="Enemy"}} },
    {name="Dazzling Gleam", power=2,      type="Fairy",     dice=6, STAB=true },
    {name="Charm",          power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown2", target="Enemy"}} },
    {name="Fairy Wind",     power=1,      type="Fairy",     dice=6, STAB=true},
    {name="Play Rough",     power=2,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Sweet Kiss",     power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Confuse", target="Enemy", chance=2}} },
    {name="Decorate",       power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}} },
    {name="Disarming Voice",power=1,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Fleur Cannon",   power=3,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}}},
    {name="Misty Terrain",  power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Nature's Madness",power="Enemy",type="Fairy",    dice=6, STAB=false },
    {name="Magical Torque", power=2,      type="Fairy",     dice=6, STAB=true,  effects={{name="Confuse", target="Enemy", chance=5}} },
    {name="Moonblast",      power=2,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Moonlight",      power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Protect", target="Self"},{name="Custom"}} },
    {name="Spirit Break",   power=2,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}} },
    {name="Spring. Storm",  power=2,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=6},{name="AttackUp", target="Self", chance=6}} },
    {name="Strange Steam",  power=3,      type="Fairy",     dice=6, STAB=true,  effects={{name="Confuse", target="Enemy", chanc=6}} },
    {name="Draining Kiss",  power=2,      type="Fairy",     dice=6, STAB=true},
    {name="Heal Pulse",     power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Custom"}, {name="Recharge", target="Self"}} },
    {name="Smite",          power=2,      type="Fairy",     dice=6, STAB=true,  effects={{name="Confuse", target="Enemy"}} },
    {name="Starfall",       power=3,      type="Fairy",     dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Finale",         power=3,      type="Fairy",     dice=6, STAB=true},
    {name="Twinkle Tackle", power=4,      type="Fairy",     dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Let's Snuggle Forever", power=5, type="Fairy",   dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Guardian of Alola", power="Enemy", type="Fairy", dice=8, STAB=false, effects={{name="Recharge", target="Self"}} },
    
    -- Fighting
    {name="Aura Sphere",    power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Arm Thrust",     power=1,      type="Fighting",  dice=4, STAB=true,  effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Bulk Up",        power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="AttackDown", target="Enemy"},{name="AttackUp", target="Self"}} },
    {name="Brick Break",    power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Body Press",     power=2,      type="Fighting",  dice=6, STAB=true },
    {name="Circle Throw",   power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="Switch", target="Enemy"}} },
    {name="Counter",        power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Close Combat",   power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Collision Course",power=3,     type="Fighting",  dice=8, STAB=true},
    {name="Combat Torque",  power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Cross Chop",     power=2,      type="Fighting",  dice=8, STAB=true},
    {name="Detect",         power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Double Kick",    power=1,      type="Fighting",  dice=4, STAB=true,  effects={{name="ExtraDice", target="Self"}} },
    {name="Drain Punch",    power=2,      type="Fighting",  dice=4, STAB=true},
    {name="Dynamic Punch",  power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="Confuse", target="Enemy", chance=4}} },
    {name="Flying Press",   power=3,      type="Flying",    dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Focus Blast",    power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Focus Punch",    power=3,      type="Fighting",  dice=6, STAB=true},
    {name="Force Palm",     power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Hammer Arm",     power=2,      type="Fighting",  dice=6, STAB=true},
    {name="High Jump Kick", power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=6}} },
    {name="Jump Kick",      power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=6}} },
    {name="Karate Chop",    power=1,      type="Fighting",  dice=8, STAB=true},
    {name="Low Kick",       power=1,      type="Fighting",  dice=4, STAB=true},
    {name="Mach Punch",     power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Priority", target="Self"}} },
    {name="No Retreat",     power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="Priority", target="Self"}, {name="AttackUp2", target="Self"}} },
    {name="Octolock",       power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="Custom"},{name="AttackUp2", target="Self"}} },
    {name="Power-Up Punch", power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Raging Bull Fighting",power=2, type="Fighting",  dice=6, STAB=true},
    {name="Revenge",        power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Rock Smash",     power=1,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Sacred Sword",   power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Secret Sword",   power=3,      type="Fighting",  dice=6, STAB=true},
    {name="Seismic Toss",   power="Self", type="Fighting",  dice=6, STAB=false},
    {name="Sky Uppercut",   power=3,      type="Fighting",  dice=6, STAB=true},
    {name="Storm Throw",    power=3,      type="Fighting",  dice=8, STAB=true},
    {name="Submission",     power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=6}} },
    {name="Superpower",     power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Triple Arrows",  power=1,      type="Fighting",  dice=8, STAB=true, effects={{name="AttackUp", target="Self"}} },
    {name="Triple Kick",    power=-1,     type="Fighting",  dice=4, STAB=false, effects={{name="ExtraDice2", target="Self"}} },
    {name="Vital Throw",    power=2,      type="Fighting",  dice=6, STAB=true},
    {name="Wake-up Slap",   power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Rolling Kick",   power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Knuckle",        power=4,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="All-Out Pummeling", power=4,   type="Fighting",  dice=6, STAB=false, effects={{name="Recharge", target="Self"} } },
    {name="Chi Strike",     power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="ExtraDice", target="Self"}} },

    -- Fire
    {name="Blaze Kick",     power=3,      type="Fire",    dice=8, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Blazing Torque", power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Blue Flare",     power=4,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Ember",          power=1,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Eruption",       power=4,      type="Fire",    dice=6, STAB=true},
    {name="Fiery Dance",    power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=4}} },
    {name="Fire Fang",      power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}, {name="AttackDown", target="Enemy", chance=6}} },
    {name="Fire Blast",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Fire Lash",      power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Fire Punch",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Fire Spin",      power=1,      type="Fire",    dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Flame Wheel",    power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Flame Burst",    power=2,      type="Fire",    dice=6, STAB=true},
    {name="Flame Charge",   power=1,      type="Fire",    dice=6, STAB=true,    effects={{name="Priority", target="Self"}}},
    {name="Flamethrower",   power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Flare Blitz",    power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6},{name="Burn", target="Enemy", chance=6}} },
    {name="Fusion Flare",   power=2,      type="Fire",    dice=6, STAB=false,   effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Heat Crash",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom", chance=4}} },
    {name="Incinerate",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Inferno",        power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=4}} },
    {name="Ivy Cudgel Fire",power=2,      type="Fire",    dice=8, STAB=true},
    {name="Lava Plume",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Magma Storm",    power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Mind Blown",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Mystical Fire",  power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackDown"}} },
    {name="Overheat",       power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Pyro Ball",      power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Raging Bull Fire",power=2,     type="Fire",    dice=6, STAB=false},
    {name="Raging Fury",    power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Confuse", target="Self", chance=5}} },
    {name="Rev. Dance Fire",power=2,      type="Fire",    dice=6, STAB=true},
    {name="Sacred Fire",    power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=4}} },
    {name="Searing Shot",   power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Torch Song",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Weather Ball Fire",power=2,    type="Fire",    dice=6, STAB=true},
    {name="Will-O-Wisp",    power=0,      type="Fire",    dice=6, STAB=false,   effects={{name="Burn", target="Enemy", chance=2}} },
    {name="Wildfire",       power=2,      type="Fire",    dice=6, STAB=false,   effects={{name="ExtraDice", target="self"}} },
    {name="Fireball",       power=4,      type="Fire",    dice=6, STAB=true},
    {name="Flare",          power=4,      type="Fire",    dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Centiferno",     power=2,      type="Fire",    dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Inferno Overdrive", power=4,   type="Fire",    dice=6, STAB=false,   effects={{name="Recharge", target="Self"} } },
    {name="Blast Burn",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Recharge", target="Self"} } },
    {name="Fire Pledge",    power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Heat Wave",      power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },

    -- Flying
    {name="Aerial Ace",     power=3,      type="Flying",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Air Cutter",     power=2,      type="Flying",  dice=8, STAB=true},
    {name="Air Slash",      power=2,      type="Flying",  dice=8, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Aeroblast",      power=3,      type="Flying",  dice=8, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Beak Blast",     power=3,      type="Flying",  dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=4}} },
    {name="Bleakwind Storm",power=3,      type="Flying",  dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=5}} },
    {name="Bounce",         power=2,      type="Flying",  dice=6, STAB=true,    effects={{name="Paralyse", target="Enemy", chance=5}}},
    {name="Brave Bird",     power=4,      type="Flying",  dice=6, STAB=true,    effects={{name="KO", target="Self"}} },
    {name="Chatter",        power=2,      type="Flying",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Drill Peck",     power=2,      type="Flying",  dice=6, STAB=true},
    {name="Dual Wingbeat",  power=3,      type="Flying",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self"}} },
    {name="Gust",           power=1,      type="Flying",  dice=6, STAB=true},
    {name="Fly",            power=3,      type="Flying",  dice=6, STAB=true},
    {name="Feather Dance",  power=0,      type="Flying",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Hurricane",      power=4,      type="Flying",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=5}} },
    {name="Mirror Move",    power=0,      type="Flying",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Oblivion Wing",  power=3,      type="Flying",  dice=6, STAB=true},
    {name="Peck",           power=1,      type="Flying",  dice=6, STAB=true},
    {name="Sky Attack",     power=3,      type="Flying",  dice=8, STAB=true,    effects={{name="Recharge", target="Self"},{name="AttackDown", target="Enemy", chance=5}} },
    {name="Sunny Day",      power=0,      type="Flying",  dice=8, STAB=false,   effects={{name="Custom"}} },
    {name="Wing Attack",    power=2,      type="Flying",  dice=6, STAB=true},
    {name="Airstream",      power=3,      type="Flying",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Supersonic Skystrike",power=4, type="Flying",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"} } },
    {name="Wind Rage",      power=4,      type="Flying",  dice=6, STAB=true,  effects={{name="Custom"}} },

    -- Ghost
    {name="Astral Barrage", power=3,      type="Ghost",   dice=6, STAB=true},
    {name="Astonish",       power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Bitter Malice",  power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=5}} },
    {name="Confuse Ray",    power=0,      type="Ghost",   dice=6, STAB=false,   effects={{name="Confuse", target="Enemy"}} },
    {name="Curse",          power=0,      type="Ghost",   dice=6, STAB=false,   effects={{name="KO", target="Self", chance=4},{name="Curse", target="Enemy"}} },
    {name="Hex",            power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Last Respects",  power=0,      type="Ghost",   dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Lick",           power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Moongeist Beam", power=2,      type="Ghost",   dice=6, STAB=true},
    {name="Night Shade",    power="Self", type="Ghost",   dice=6, STAB=false},
    {name="Ominous Wind",   power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Phantom Force",  power=2,      type="Ghost",   dice=6, STAB=true},
    {name="Rage Fist",      power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Rev. Dance Ghost",power=2,     type="Ghost",   dice=6, STAB=true},
    {name="Shadow Ball",    power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}}},
    {name="Shadow Bone",    power=2,      type="Ghost",   dice=6, STAB=true},
    {name="Shadow Claw",    power=2,      type="Ghost",   dice=8, STAB=true},
    {name="Shadow Force",   power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Shadow Punch",   power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Shadow Sneak",   power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Spectral Thief", power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Spirit Shackle", power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Terror",         power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Never-Ending Nightmare", power=4,type="Ghost", dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Sinister Arrow Raid", power=5, type="Ghost",   dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Soul-Stealing 7* Strike",power=5, type="Ghost", dice=6, STAB=false,  effects={{name="Recharge", target="Self"}} },
    {name="Menacing Moonraze Maelstrom",power=4,type="Ghost", dice=6, STAB=false, effects={{name="Recharge", target="Self"}, {name="Priority", target="Self"}} },

    -- Grass
    {name="Absorb",         power=1,      type="Grass",   dice=6, STAB=true},
    {name="Apple Acid",     power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Aromatherapy",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Branch Poke",    power=1,      type="Grass",   dice=6, STAB=true},
    {name="Bullet Seed",    power=1,      type="Grass",   dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Chloroblast",    power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Cotton Guard",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Cotton Spore",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Drum Beating",   power=2,      type="Grass",   dice=6, STAB=true},
    {name="Energy Ball",    power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Flower Trick",   power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Giga Drain",     power=2,      type="Grass",   dice=6, STAB=true},
    {name="Grass Knot",     power=1,      type="Grass",   dice=6, STAB=true},
    {name="Grass Whistle",  power=0,      type="Grass",   dice=6, STAB=false},
    {name="Grassy Terrain", power=0,      type="Grass",   dice=6, STAB=false,    effects={{name="Custom"}}},
    {name="Grav Apple",     power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Horn Leech",     power=2,      type="Grass",   dice=6, STAB=true},
    {name="Ivy Cudgel Grass",power=2,     type="Grass",   dice=8, STAB=true},
    {name="Jungle Healing", power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Custom"},{name="Protect", target="Self"}}},
    {name="Leafage",        power=1,      type="Grass",   dice=8, STAB=true},
    {name="Leaf Blade",     power=2,      type="Grass",   dice=8, STAB=true},
    {name="Leaf Storm",     power=3,      type="Grass",   dice=4, STAB=true,    effects={{name="AttackDown", target="Self"}} },
    {name="Leaf Tornado",   power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}}},
    {name="Magical Leaf",   power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Matcha Gotcha",  power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Mega Drain",     power=2,      type="Grass",   dice=6, STAB=true},
    {name="Needle Arm",     power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Petal Blizzard", power=2,      type="Grass",   dice=6, STAB=true},
    {name="Petal Dance",    power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Confuse", target="Self", chance=5}} },
    {name="Power Whip",     power=3,      type="Grass",   dice=6, STAB=true},
    {name="Razor Leaf",     power=2,      type="Grass",   dice=8, STAB=true},
    {name="Seed Bomb",      power=3,      type="Grass",   dice=6, STAB=true},
    {name="Seed Flare",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp2", target="Self", chance=4}} },
    {name="Sleep Powder",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=3}} },
    {name="Solar Beam",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Solar Blade",    power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Spicy Extract",  power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Spiky Shield",   power=1,      type="Grass",   dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Spore",          power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Sleep", target="Enemy"}} },
    {name="Stun Spore",     power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Paralyse", target="Enemy", chance=3}} },
    {name="Syrup Bomb",     power=2,      type="Grass",   dice=6, STAB=true},
    {name="Trailblaze",     power=1,      type="Grass",   dice=6, STAB=true,    effects={{name="Priority", target="Self"}}},
    {name="Trop Kick",      power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}}},
    {name="Vine Whip",      power=3,      type="Grass",   dice=6, STAB=true},
    {name="Wood Hammer",    power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Vine Lash",      power=2,      type="Grass",   dice=6, STAB=false,   effects={{name="ExtraDice", target="Self"}} },
    {name="Drum Solo",      power=4,      type="Grass",   dice=6, STAB=true},
    {name="Tartness",       power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Sweetness",      power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Bloom Doom",     power=4,      type="Grass",   dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Frenzy Plant",   power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Grass Pledge",   power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="Custom"}} },

    -- Ground
    {name="Bone Club",      power=2,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Bone Rush",      power=1,      type="Ground",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Bonemerang",     power=1,      type="Ground",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self"}} },
    {name="Bulldoze",       power=2,      type="Ground",  dice=6, STAB=true},
    {name="Dig",            power=2,      type="Ground",  dice=6, STAB=true},
    {name="Drill Run",      power=2,      type="Ground",  dice=8, STAB=true},
    {name="Earth Power",    power=2,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Earthquake",     power=2,      type="Ground",  dice=6, STAB=true},
    {name="Fissure",        power=0,      type="Ground",  dice=6, STAB=false,   effects={{name="KO", chance=5, target="Enemy"}} },
    {name="H. Horsepower",  power=3,      type="Ground",  dice=6, STAB=true},
    {name="Headlong Rush",  power=3,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackDown", target="Self"}} },
    {name="Land's Wrath",   power=3,      type="Ground",  dice=6, STAB=true},
    {name="Magnitude",      power=2,      type="Ground",  dice=6, STAB=true,    effects={{name="D4Dice", target="Self", chance=3},{name="ExtraDice", target="Self", chance="6"}}},
    {name="Mud Bomb",       power=2,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Mud Shot",       power=2,      type="Ground",  dice=6, STAB=true},
    {name="Mud-Slap",       power=1,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}} },
    {name="Sand Attack",    power=0,      type="Ground",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Sand Tomb",      power=1,      type="Ground",  dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Sandsear Storm", power=3,      type="Ground",  dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Spikes",         power=0,      type="Ground",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Precipise Blades",power=4,     type="Ground",  dice=6, STAB=true},
    {name="Quake",          power=3,      type="Ground",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Tectonic Rage",  power=4,      type="Ground",  dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },

    -- Ice
    {name="Aurora Beam",    power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Avalanche",      power=2,      type="Ice",     dice=6, STAB=true},
    {name="Blizzard",       power=3,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Freeze-Dry",     power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Glacial Lance",  power=3,      type="Ice",     dice=6, STAB=true},
    {name="Glaciate",       power=2,      type="Ice",     dice=6, STAB=true},
    {name="Hail",           power=0,      type="Ice",     dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Ice Beam",       power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Ice Fang",       power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Ice Hammer",     power=2,      type="Ice",     dice=6, STAB=true},
    {name="Ice Punch",      power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Ice Shard",      power=1,      type="Ice",     dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Ice Spinner",    power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Icicle Crash",   power=3,      type="Ice",     dice=4, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Icicle Spear",   power=1,      type="Ice",     dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Icy Wind",       power=2,      type="Ice",     dice=6, STAB=true},
    {name="Mist",           power=0,      type="Ice",     dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Powder Snow",    power=1,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Sheer Cold",     power=0,      type="Ice",     dice=6, STAB=true,    effects={{name="KO", target="Enemy", chance=5}} },
    {name="Weather Ball Ice",power=3,     type="Ice",     dice=6, STAB=true},
    {name="Resonance",      power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Subzero Slammer",power=4,      type="Ice",     dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Snowscape",      power=0,      type="Ice",     dice=6, STAB=false,   effects={{name="Custom"}} },

    -- Normal
    {name="Attract",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Barrage",        power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Body Slam",      power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Bind",           power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Blood Moon",     power=2,      type="Normal",  dice=6, STAB=true},
    {name="Boomburst",      power=4,      type="Normal",  dice=6, STAB=true},
    {name="Camouflage",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Chip Away",      power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Comet Punch",    power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Constrict",      power=1,      type="Normal",  dice=6, STAB=true},
    {name="Conversion",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Conversion2",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Covet",          power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Crush Claw",     power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=4}} },
    {name="Defense Curl",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Disable",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Dizzy Punch",    power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=5}} },
    {name="Double-Edge",    power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Double Hit",     power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self"}} },
    {name="Double Slap",    power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Double Team",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Echoed Voice",   power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Egg Bomb",       power=2,      type="Normal",  dice=6, STAB=true},
    {name="Encore",         power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Explosion",      power=5,      type="Normal",  dice=6, STAB=true,    effects={{name="KO", target="Self"}} },
    {name="Extreme Speed",  power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Facade",         power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Fake Out",       power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}} },
    {name="False Swipe",    power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Fillet Away",    power="Enemy",type="Normal",  dice=6, STAB=false },
    {name="Focus Energy",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Fury Attack",    power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Fury Swipes",    power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Giga Impact",    power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Glare",          power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Paralyse", target="Enemy"}} },
    {name="Growl",          power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Growth",         power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Guillotine",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="KO", target="Enemy", chance=5}} },
    {name="Harden",         power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Head Charge",    power=4,      type="Normal",  dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Headbutt",       power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Heal Bell",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Hidden Power",   power=2,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Horn Attack",    power=2,      type="Normal",  dice=6, STAB=true},
    {name="Horn Drill",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="KO", target="Enemy", chance=5}} },
    {name="Howl",           power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Hyper Beam",     power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Hyper Drill",    power=2,      type="Normal",  dice=6, STAB=true },
    {name="Hyper Fang",     power=2,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Hyper Voice",    power=2,      type="Normal",  dice=6, STAB=false},
    {name="Judgement",      power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Leer",           power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Lovely Kiss",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=3}} },
    {name="Mean Look",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Me First",       power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Mega Kick",      power=3,      type="Normal",  dice=6, STAB=true},
    {name="Mega Punch",     power=2,      type="Normal",  dice=6, STAB=true},
    {name="Metronome",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Mimic",          power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Minimize",       power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Multi-Attack",   power=4,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Nature Power",   power=0,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Noble Roar",     power=0,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackDown2", target="Enemy"}} },
    {name="Odor Sleuth",    power=0,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Pay Day",        power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom", chance=6}} },
    {name="Perish Song",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Play Nice",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Pop. Bomb",      power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=2}}},
    {name="Pound",          power=1,      type="Normal",  dice=6, STAB=true},
    {name="Present",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Extra Dice", target="Self", chance=6}} },
    {name="Protect",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Quick Attack",   power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Rage",           power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Relic Song",     power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Sleep", target="Enemy", chance=6}} },
    {name="Rapid Spin",     power=1,      type="Normal",  dice=6, STAB=true},
    {name="Retaliate",      power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Revival Blessing",power=2,     type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Roar",           power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Switch", target="Enemy"}} },
    {name="Razor Wind",     power=2,      type="Normal",  dice=8, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Safeguard",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Self-Destruct",  power=4,      type="Normal",  dice=6, STAB=true,    effects={{name="KO", target="Self"}} },
    {name="Scratch",        power=1,      type="Normal",  dice=6, STAB=true},
    {name="Screech",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Sharpen",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Shell Smash",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"},{name="Custom"}} },
    {name="Sing",           power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="Sketch",         power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Skull Bash",     power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Slam",           power=2,      type="Normal",  dice=6, STAB=true},
    {name="Slash",          power=2,      type="Normal",  dice=8, STAB=true},
    {name="Smelling Salts", power=2,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Smokescreen",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Sonic Boom",     power=2,      type="Normal",  dice=4, STAB=false,   effects={{name="Neutral", target="Self"}} },
    {name="Spike Cannon",   power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Spit Up",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Splash",         power=0,      type="Normal",  dice=6, STAB=false},
    {name="Stomp",          power=2,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Stuff Cheeks",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Super Fang",     power="Enemy",type="Normal",  dice=6, STAB=false},
    {name="Supersonic",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Confuse", target="Enemy", chance=4}} },
    {name="Swagger",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Confuse", target="Enemy"}} },
    {name="Swift",          power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Swords Dance",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Tackle",         power=1,      type="Normal",  dice=6, STAB=true},
    {name="Tail Slap",      power=2,      type="Normal",  dice=4, STAB=false,   effects={{name="ExtraDice", target="Self"}} },
    {name="Tail Whip",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Take Down",      power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Tearful Look",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Techno Blast",   power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy"}} },
    {name="Tera Starstorm", power=4,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Terrain Pulse",  power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Teeter Dance",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Confuse", target="Enemy"}} },
    {name="Thrash",         power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Confuse", target="Self", chance=5}} },
    {name="Transform",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Tri Attack",     power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom", chance=5}} },
    {name="Trump Card",     power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Uproar",         power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Vise Grip",      power=2,      type="Normal",  dice=6, STAB=true},
    {name="Whirlwind",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Switch", target="Enemy"}} },
    {name="Work Up",        power=0,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackUp2", target="Self"}}},
    {name="Wrap",           power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Wring Out",      power="Enemy",type="Normal",  dice=6, STAB=true},
    {name="Yawn",           power=0,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Captivate",      power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Rock Climb",     power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=5}} },
    {name="Strength",       power=2,      type="Normal",  dice=6, STAB=true},
    {name="Strike",         power=4,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Gold Rush",      power=3,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}, {name="Confuse", target="Enemy"} } },
    {name="Cuddle",         power=3,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Replenish",      power=3,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Guard",          power=3,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Secret Power",   power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Snore",          power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Breakneck Blitz", power=4,     type="Normal",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Extreme Evoboost", power=0,    type="Normal",  dice=6, STAB=true,    effects={{name="AttackUp2", target="Self"}, {name="AttackDown2", target="Enemy"}} },
    {name="Pulverizing Pancake", power=5, type="Normal",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },

    -- Poison
    {name="Acid",           power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Acid Armor",     power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Acid Spray",     power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="AttackDown2", target="Enemy"}} },
    {name="Bane. Bunker",   power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Custom"},{name="Poison", target="Enemy", chance=4}} },
    {name="Clear Smog",     power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Cross Poison",   power=2,      type="Poison",  dice=6, STAB=true},
    {name="Coil",           power=0,      type="Poison",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self"},{name="AttackDown", target="Enemy"}} },
    {name="Malignant Chain",power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=4}} },
    {name="Mortal Spin",    power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="Custom"},{name="Poison", target="Enemy"}} },
    {name="Noxious Torque", power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Poison Fang",    power=1,      type="Poison",  dice=8, STAB=true,    effects={{name="Poison", target="Enemy", chance=4}} },
    {name="Poison Gas",     power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Poison", target="Enemy", chance=2}} },
    {name="Poison Jab",     power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Poison Powder",  power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Poison", target="Enemy", chance=3}} },
    {name="Poison Sting",   power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Poison Tail",    power=1,      type="Poison",  dice=8, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },
    {name="Shell Side Arm", power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },
    {name="Smog",           power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=4}} },
    {name="Sludge",         power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Sludge Bomb",    power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Sludge Wave",    power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },
    {name="Toxic",          power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Poison", target="Enemy", chance=2}} },
    {name="Toxic Spikes",   power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Venom Drench",   power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Venoshock",      power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Ooze",           power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Acid Downpour",  power=4,      type="Poison",  dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Malador",        power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy"}} },
    {name="Gunk Shot",      power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },

    -- Psychic
    {name="Amnesia",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Barrier",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Calm Mind",      power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Confusion",      power=1,      type="Psychic", dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Cosmic Power",   power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Dream Eater",    power="Sleep",type="Psychic", dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="Eerie Spell",    power=3,      type="Psychic", dice=6, STAB=true     },
    {name="Esper Wing",     power=3,      type="Psychic", dice=8, STAB=true     },
    {name="Extrasensory",   power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Freezing Glare", power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="Frozen", target="Enemy", chance=6}} },
    {name="Future Sight",   power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Healing Wish",   power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"},{name="KO", target="Self"}} },
    {name="Heart Stamp",    power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Hyperspace Hole",power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Hypnosis",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="Imprison",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Light Screen",   power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Lumina Crash",   power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Luster Purge",   power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}} },
    {name="Magic Coat",     power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Meditate",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Mirror Coat",    power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Mist Ball",      power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}} },
    {name="Photon Geyser",  power=3,      type="Psychic", dice=6, STAB=true     },
    {name="Prism. Laser",   power=3,      type="Psychic", dice=6, STAB=true     },
    {name="Psybeam",        power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=4}} },
    {name="Psyblade",       power=3,      type="Psychic", dice=6, STAB=true     },
    {name="Psywave",        power="Self", type="Psychic", dice=6, STAB=false    },
    {name="Psychic",        power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Psychic Fangs",  power=3,      type="Psychic", dice=6, STAB=true },
    {name="Psycho Boost",   power=4,      type="Psychic", dice=6, STAB=true     },
    {name="Psycho Cut",     power=2,      type="Psychic", dice=8, STAB=true     },
    {name="Psyshield Bash", power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}}     },
    {name="Psyshock",       power=2,      type="Psychic", dice=6, STAB=true     },
    {name="Reflect",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Rev. Dance Psychic",power=2,   type="Psychic", dice=6, STAB=true},
    {name="Telekinesis",    power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Teleport",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Switch", target="Self"}} },
    {name="Twin Beam",      power=2,      type="Psychic", dice=4, STAB=true,    effects={{name="ExtraDice", target="Self"}} },
    {name="Zen Headbutt",   power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Psystrike",      power=2,      type="Psychic", dice=6, STAB=true},
    {name="Gravitas",       power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Mindstorm",      power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Shattered Psyche", power=4,    type="Psychic", dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Genesis Supernova", power=4,   type="Psychic", dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Light That Burns The Sky", power=4, type="Psychic", dice=8, STAB=false, effects={{name="Recharge", target="Self"}} },
    {name="Magic Room",     power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Agility",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Priority", target="Self"}} },
    {name="Acid Spray",     power=1,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Trick",          power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },

    -- Rock
    {name="Accelerock",     power=1,      type="Rock",    dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Ancient Power",  power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6},{name="AttackUp", target="Self", chance=6}} },
    {name="Diamond Storm",  power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}} },
    {name="Head Smash",     power=3,      type="Rock",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Ivy Cudgel Rock",power=2,      type="Rock",    dice=8, STAB=true},
    {name="Mighty Cleave",  power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Power Gem",      power=2,      type="Rock",    dice=6, STAB=true},
    {name="Rock Polish",    power=0,      type="Rock",    dice=6, STAB=false,   effects={{name="Priority", target="Self"}} },
    {name="Rock Slide",     power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Rock Throw",     power=1,      type="Rock",    dice=6, STAB=true},
    {name="Rollout",        power=1,      type="Rock",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Rock Blast",     power=1,      type="Rock",    dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Rock Tomb",      power=2,      type="Rock",    dice=6, STAB=true},
    {name="Rock Wrecker",   power=4,      type="Rock",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Salt Cure",      power=0,      type="Rock",    dice=8, STAB=false,   effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Sandstorm",      power=0,      type="Rock",    dice=8, STAB=false,   effects={{name="Custom"}} },
    {name="Stealth Rock",   power=0,      type="Rock",    dice=6, STAB=false,   effects={{name="Custom"}}},
    {name="Stone Axe",      power=2,      type="Rock",    dice=8, STAB=true},
    {name="Stone Edge",     power=2,      type="Rock",    dice=8, STAB=true},
    {name="Tera Blast",     power=2,      type="Rock",    dice=6, STAB=true},
    {name="Wide Guard",     power=0,      type="Rock",    dice=8, STAB=false,   effects={{"Protect", target="Self" }} },
    {name="Volcalith",      power=3,      type="Rock",    dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Sandblast",      power=3,      type="Rock",    dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Continental Crush", power=4,   type="Rock",    dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Splintered Stormshards", power=4, type="Rock", dice=6, STAB=false,   effects={{name="Recharge", target="Self"}} },
    {name="Meteor Beam",    power=3,      type="Rock",    dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    
    -- Steel
    {name="Anchor Shot",    power=1,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Autotomize",     power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackUp2", target="Self"}} },
    {name="Behemoth Bash",  power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Behemoth Blade", power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Doom Desire",    power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="Recharge", target="Self"}} },
    {name="Dbl. Iron Bash", power=1,      type="Steel",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self", chance=5}} },
    {name="Flash Cannon",   power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Gear Grind",     power=2,      type="Steel",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Gigaton Hammer", power=4,      type="Steel",  dice=4, STAB=true},
    {name="Gyro Ball",      power="Self", type="Steel",  dice=6, STAB=false},
    {name="Heavy Slam",     power=3,      type="Steel",  dice=6, STAB=true },
    {name="Iron Defense",   power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackDown2", target="Enemy"}} },
    {name="Iron Head",      power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Iron Tail",      power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=5}} },
    {name="King's Shield",  power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="Custom"}} },
    {name="Magnet Bomb",    power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self"}} },
    {name="Make It Rain",   power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Self"}, {name="Custom"}} },
    {name="Metal Burst",    power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="Custom"}} },
    {name="Metal Claw",     power=1,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Metal Mash",     power=1,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Metal Sound",    power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackUp2", target="Self"}} },
    {name="Meteor Mash",    power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Mirror Shot",    power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Shift Gear",     power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackUp2", target="Self", chance=6}} },
    {name="Spin Out",       power=2,      type="Steel",  dice=6, STAB=true },
    {name="Steel Wing",     power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Sunsteel Strike",power=2,      type="Steel",  dice=6, STAB=true },
    {name="Smart Strike",   power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self"}} },
    {name="Tachyon Cutter", power=1,      type="Steel",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Steelspike",     power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Steelsurge",     power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Depletion",      power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Corkscrew Crash", power=4,     type="Steel",  dice=6, STAB=false,    effects={{name="Recharge", target="Self"}} },
    {name="Searing Sunraze Smash", power=4, type="Steel", dice=6, STAB=false,   effects={{name="Recharge", target="Self"}, {name="Priority", target="Self"}} },
    {name="Meltdown",       power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },

    -- Water
    {name="Aqua Jet",       power=1,      type="Water",  dice=6, STAB=true,     effects={{name="Priority", target="Self"}} },
    {name="Aqua Step",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Priority", target="Self"}} },
    {name="Aqua Tail",      power=2,      type="Water",  dice=6, STAB=true},
    {name="Brine",          power=2,      type="Water",  dice=6, STAB=true},
    {name="Bubble",         power=1,      type="Water",  dice=6, STAB=true},
    {name="Bubble Beam",    power=2,      type="Water",  dice=6, STAB=true},
    {name="Clamp",          power=1,      type="Water",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Crabhammer",     power=2,      type="Water",  dice=8, STAB=true},
    {name="Dive",           power=2,      type="Water",  dice=6, STAB=true},
    {name="Flip Turn",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Switch", target="Self"}}},
    {name="Hydro Pump",     power=3,      type="Water",  dice=6, STAB=true},
    {name="Ivy Cudgel Water",power=2,     type="Water",  dice=8, STAB=true},
    {name="Jet Punch",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Priority"}}},
    {name="Liquidation",    power=2,      type="Water",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Muddy Water",    power=2,      type="Water",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Octazooka",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="AttackUp", target="Enemy", chance=4}} },
    {name="Raging Bull Water",power=2,    type="Water",  dice=6, STAB=true},
    {name="Rain Dance",     power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Razor Shell",    power=2,      type="Water",  dice=8, STAB=true},
    {name="Scald",          power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Snipe Shot",     power=2,      type="Water",  dice=8, STAB=true},
    {name="Sparkling Aria", power=2,      type="Water",  dice=6, STAB=true},
    {name='Steam Eruption', power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Surf",           power=1,      type="Water",  dice=6, STAB=true},
    {name="Surging Strikes",power=2,      type="Water",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}}},
    {name="Triple Dive",    power=1,      type="Water",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}}},
    {name="Water Gun",      power=1,      type="Water",  dice=6, STAB=true},
    {name="Water Pulse",    power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Water Shuriken", power=1,      type="Water",  dice=4, STAB=true,     effects={{name="Priority", target="Self"},{name="AttackUp", target="Self", chance=4}}},
    {name="Water Spout",    power=3,      type="Water",  dice=6, STAB=true},
    {name="Wave Crash",     power=3,      type="Water",  dice=6, STAB=true,     effects={{name="KO", target="Self", chance=6}} },
    {name="Waterfall",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Whirlpool",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Withdraw",       power=0,      type="Water",  dice=6, STAB=false,    effects={{name="AttackDown", target="Enemy"}} },
    {name="Weather Ball Water",power=2,   type="Water",  dice=6, STAB=true},
    {name="Origin Pulse",   power=3,      type="Water",  dice=6, STAB=true},
    {name="Cannonade",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Foam Burst",     power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Priority", target="Self"}} },
    {name="Hydro Snipe",    power=4,      type="Water",  dice=6, STAB=true},
    {name="Stonesurge",     power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Rapid Flow",     power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Hydro Vortex",   power=4,      type="Water",  dice=6, STAB=false,    effects={{name="Recharge", target="Self"}} },
    {name="Oceanic Operetta", power=5,    type="Water",  dice=6, STAB=false,    effects={{name="Recharge", target="Self"}} },
    {name="Chilling Water", power=1,      type="Water",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy"}} },
    {name="Hydro Cannon",   power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Recharge", target="Self"}} },
}

rivalData =
{
  -- Gen 1 Gary
  { 
    region = KANTO_REGION,
    trainerName = "Gary",
    pokemonData = {
      {
        guid = "657f91",
        tier = PINK,
        pokemon = {
          { name = "Pidgey", level = 1, types = { "Flying", "Normal" }, moves = { "Sand Attack", "Tackle" }, model_GUID = "e042f9" },
          { name = "Squirtle", level = 2, types = { "Water" }, moves = { "Water Gun", "Tackle" }, model_GUID = "a96b7f" } }
      },
      {
        guid = "6549e5",
        tier = GREEN,
        pokemon = {
          { name = "Eevee", level = 2, types = { "Normal" }, moves = { "Baby-Doll Eyes", "Take Down" }, model_GUID = "b37bcd" },
          { name = "Growlithe", level = 3, types = { "Fire" }, moves = { "Ember", "Bite" }, model_GUID = "b8f54f" } }
      },
      {
        guid = "44a527",
        tier = BLUE,
        pokemon = {
          { name = "Nidorino", level = 3, types = { "Poison" }, moves = { "Double Kick", "Poison Jab" }, model_GUID = "ebed42" },
          { name = "Wartortle", level = 4, types = { "Water" }, moves = { "Water Pulse", "Shell Smash" }, model_GUID = "99fd39" } }
      },
      {
        guid = "77d1c0",
        tier = YELLOW,
        pokemon = {
          { name = "Umbreon", level = 4, types = { "Dark" }, moves = { "Dark Pulse", "Confuse Ray" }, model_GUID = "33d105" },
          { name = "Arcanine", level = 5, types = { "Fire" }, moves = { "Flare Blitz", "Extreme Speed" }, model_GUID = "d89ae7", custom_scale=0.7, offset={x=0,y=0,z=-0.2} } }
      },
      {
        guid = "b67404",
        tier = RED,
        pokemon = {
          { name = "Nidoking", level = 5, types = { "Poison", "Ground" }, moves = { "Earthquake", "Sludge" }, model_GUID = "b038db" },
          { name = "Blastoise", level = 6, types = { "Water" }, moves = { "Hydro Pump", "Ice Beam" }, model_GUID = "54ea11" } }
      },
    }
  },
  -- Gen 2 Silver
  {
    region = JOHTO_REGION,
    trainerName = "Silver",
    pokemonData = {
      {
        guid = "ef6dcf",
        tier = PINK,
        pokemon = {
          { name = "Zubat", level = 1, types = { "Poison" }, moves = { "Absorb", "Supersonic" }, model_GUID = "6ce120", spawn_effect="Physical Attack" },
          { name = "Totodile", level = 2, types = { "Water" }, moves = { "Water Gun", "Tackle" }, model_GUID = "252f4b" },  }
      },
      {
        guid = "abd28a",
        tier = GREEN,
        pokemon = {
          { name = "Sneasel", level = 2, types = { "Dark", "Ice" }, moves = { "Ice Shard", "Fury Swipes" }, model_GUID = "b0f068" },
          { name = "Golbat", level = 3, types = { "Poison", "Flying" }, moves = { "Air Slash", "Bite" }, model_GUID = "9b980c" } }
      },
      {
        guid = "8cdf85",
        tier = BLUE,
        pokemon = {
          { name = "Haunter", level = 3, types = { "Ghost", "Poison" }, moves = { "Shadow Punch", "Curse" }, model_GUID = "13b866" },
          { name = "Croconaw", level = 4, types = { "Water" }, moves = { "Crunch", "Ice Fang" }, model_GUID = "4015b5" } }
      },
      {
        guid = "a347f1",
        tier = YELLOW,
        pokemon = {
          { name = "Crobat", level = 4, types = { "Poison", "Flying" }, moves = { "Poison Fang", "Leech Life" }, model_GUID = "40d4cd" },
          { name = "Feraligatr", level = 5, types = { "Water" }, moves = { "Aqua Tail", "Thrash" }, model_GUID = "e93ead", spawn_effect="Status Attack", custom_scale=0.8, offset={x=0,y=0,z=-0.1} } }
      },
      {
        guid = "ee4693",
        tier = RED,
        pokemon = {
          { name = "Alakazam", level = 5, types = { "Psychic" }, moves = { "Psychic", "Tri Attack" }, model_GUID = "c3804e" },
          { name = "Gengar", level = 6, types = { "Ghost", "Poison" }, moves = { "Hex", "Sludge Bomb" }, model_GUID = "4638bc" } }
      }
    }
  },  
  -- Gen 3 May
  {
    region = HOENN_REGION,
    trainerName = "May",
    pokemonData = {
      {
        guid = "868f64",
        tier = PINK,
        pokemon = {
          { name = "Skitty", level = 1, types = { "Normal" }, moves = { "Fake Out", "Tail Whip" }, model_GUID = "701147" },
          { name = "Torchic", level = 2, types = { "Fire" }, moves = { "Ember", "Scratch" }, model_GUID = "215780", spawn_effect="Physical Attack" } }
      },
      {
        guid = "bb0161",
        tier = GREEN,
        pokemon = {
          { name = "Eevee", level = 2, types = { "Normal" }, moves = { "Quick Attack", "Baby-Doll Eyes" }, model_GUID = "b37bcd" },
          { name = "Beautifly", level = 3, types = { "Bug", "Flying" }, moves = { "Gust", "Bug Bite" } , model_GUID = "96fd4b" } }
      },
      {
        guid = "3a096f",
        tier = BLUE,
        pokemon = {
          { name = "Wailmer", level = 3, types = { "Water" }, moves = { "Water Pulse", "Rollout" }, model_GUID = "b372d4", custom_scale=0.7 },
          { name = "Combusken", level = 4, types = { "Fire", "Fighting" }, moves = { "Double Kick", "Flame Charge" }, model_GUID = "87fbb3", spawn_effect="Physical Attack" } }
      },
      {
        guid = "7225fa",
        tier = YELLOW,
        pokemon = {
          { name = "Ludicolo", level = 4, types = { "Water", "Grass" }, moves = { "Energy Ball", "Bubble Beam" }, model_GUID = "bb247f" },
          { name = "Tropius", level = 5, types = { "Grass", "Flying" }, moves = { "Magical Leaf", "Air Slash" }, model_GUID = "bdb162" } }
      },
      {
        guid = "0403a2",
        tier = RED,
        pokemon = {
          { name = "Venusaur", level = 5, types = { "Grass", "Poison" }, moves = { "Razor Leaf", "Double-Edge" }, model_GUID = "452ac8", spawn_effect="Physical Attack", custom_scale=0.6, offset={x=0,y=0,z=-0.1} },
          { name = "Blaziken", level = 6, types = { "Fire", "Fighting" }, moves = { "Blaze Kick", "Bulk Up" }, model_GUID = "868292", spawn_effect="Status Attack" } }
      }
    }
  },
  -- Gen 4 Barry
  {
    region = SINNOH_REGION,
    trainerName = "Barry",
    pokemonData = {
      {
        guid = "38ea83",
        tier = PINK,
        pokemon = {
          { name = "Starly", level = 1, types = { "Flying" }, moves = { "Quick Attack", "Whirlwind" }, model_GUID = "befb97" },
          { name = "Piplup", level = 2, types = { "Water" }, moves = { "Water Gun", "Peck" }, model_GUID = "c9b643" } }
      },
      {
        guid = "28261e",
        tier = GREEN,
        pokemon = {
          { name = "Ponyta", level = 2, types = { "Fire" }, moves = { "Flame Charge", "Stomp" }, model_GUID = "a1a9ce" },
          { name = "Roselia", level = 3, types = { "Grass" }, moves = { "Absorb", "Stun Spore" }, model_GUID = "6b1bd7" } }
      },
      {
        guid = "7e432b",
        tier = BLUE,
        pokemon = {
          { name = "Heracross", level = 3, types = { "Bug", "Fighting" }, moves = { "Arm Thrust", "Pin Missile" }, model_GUID = "11f35c", offset={x=0, y=0, z=-0.3} },
          { name = "Prinplup", level = 4, types = { "Water" }, moves = { "Metal Claw", "Bubble Beam" }, model_GUID = "7931f6" } }
      },
      {
        guid = "c51cd3",
        tier = YELLOW,
        pokemon = {
          { name = "Rapidash", level = 4, types = { "Fire" }, moves = { "Fire Spin", "Megahorn" }, model_GUID = "20403e", custom_scale=0.7, offset={x=0, y=0, z=-0.1} },
          { name = "Roserade", level = 5, types = { "Grass", "Poison" }, moves = { "Magical Leaf", "Toxic Spikes" }, model_GUID = "62a471", spawn_effect="Physical Attack" } }
      },
      {
        guid = "96097f",
        tier = RED,
        pokemon = {
          { name = "Staraptor", level = 5, types = { "Flying", "Normal" }, moves = { "Aerial Ace", "Close Combat" }, model_GUID = "88b32f" },
          { name = "Empoleon", level = 6, types = { "Water" }, moves = { "Hydro Pump", "Ice Beam" }, model_GUID = "85b6c8", spawn_effect="Status Attack", offset={x=0,y=0.1,z=-0.2} } }
      }
    }
  },
  -- Gen 5 Bianca
  {
    region = UNOVA_REGION,
    trainerName = "Bianca",
    pokemonData = {
      {
        guid = "cfa438",
        tier = PINK,
        pokemon = {
          { name = "Lillipup", level = 1, types = { "Normal" }, moves = { "Tackle", "Leer" }, model_GUID = "a3d331" },
          { name = "Tepig", level = 2, types = { "Fire" }, moves = { "Ember", "Smog" }, model_GUID = "f8a647" } }
        },
      {
        guid = "2e52c1",
        tier = GREEN,
        pokemon = {
          { name = "Musharna", level = 2, types = { "Psychic" }, moves = { "Hypnosis", "Defense Curl" }, model_GUID = "f742b2" },
          { name = "Simisage", level = 3, types = { "Grass" }, moves = { "Vine Whip", "Lick" }, model_GUID = "962b36" } }
      },
      {
        guid = "5716e5",
        tier = BLUE,
        pokemon = {
          { name = "Minccino", level = 3, types = { "Normal" }, moves = { "Sing", "Charm" }, model_GUID = "dccefe", spawn_effect="Physical Attack" },
          { name = "Pignite", level = 4, types = { "Fire", "Fighting" }, moves = { "Arm Thrust", "Flame Charge" }, model_GUID = "1142b7" } }
      },
      {
        guid = "6ac44f",
        tier = YELLOW,
        pokemon = {
          { name = "Escavalier", level = 4, types = { "Bug", "Steel" }, moves = { "Iron Defense", "X-Scissor" }, model_GUID = "e4c099" },
          { name = "Stoutland", level = 5, types = { "Normal" }, moves = { "Work Up", "Retaliate" }, model_GUID = "eff43c", custom_scale=0.8 } }
      },
      {
        guid = "594f9f",
        tier = RED,
        pokemon = {
          { name = "Mienshao", level = 5, types = { "Fighting" }, moves = { "Force Palm", "Calm Mind" }, model_GUID = "afd151", offset={x=0, y=0, z=0.2} },
          { name = "Emboar", level = 6, types = { "Fire", "Fighting" }, moves = { "Wild Charge", "Flare Blitz" }, model_GUID = "83bed3" } }
      }
    }
  },
  -- Gen 6 Serena
  {
    region = KALOS_REGION,
    trainerName = "Serena",
    pokemonData = {
      {
        guid = "f109af",
        tier = PINK,
        pokemon = {
          { name = "Fletchling", level = 1, types = { "Flying", "Normal" }, moves = { "Peck", "Quick Attack" }, model_GUID = "1a27c7" },
          { name = "Fennekin", level = 2, types = { "Fire" }, moves = { "Ember", "Howl" }, model_GUID = "95501e", spawn_effect="Status Attack" } }
      },
      {
        guid = "5574e2",
        tier = GREEN,
        pokemon = {
          { name = "Espurr", level = 2, types = { "Psychic" }, moves = { "Confusion", "Covet" }, model_GUID = "11f232" },
          { name = "Pancham", level = 3, types = { "Fighting" }, moves = { "Arm Thrust", "Ice Punch" }, model_GUID = "0c4abd" } }
      },
      {
        guid = "6e2483",
        tier = BLUE,
        pokemon = {
          { name = "Meowstic (M)", level = 3, types = { "Psychic" }, moves = { "Psybeam", "Disarming Voice" }, model_GUID = "c2df10" },
          { name = "Braixen", level = 4, types = { "Fire" }, moves = { "Fire Spin", "Psybeam" }, model_GUID = "61a7d9" } }
      },
      {
        guid = "fda621",
        tier = YELLOW,
        pokemon = {
          { name = "Absol", level = 4, types = { "Dark" }, moves = { "Slash", "Bite" }, model_GUID = "4f2184" },
          { name = "Sylveon", level = 5, types = { "Fairy" }, moves = { "Fairy Wind", "Swift" }, model_GUID = "381a03" } }
      },
      {
        guid = "7d8af7",
        tier = RED,
        pokemon = {
          { name = "Altaria", level = 5, types = { "Dragon" }, moves = { "Dragon Pulse", "Dazzling Gleam" }, model_GUID = "9a2210" },
          { name = "Delphox", level = 6, types = { "Fire", "Psychic" }, moves = { "Mystical Fire", "Psychic" }, model_GUID = "8879bd", offset={x=0, y=0, z=0.08} } }
      }
    }
  },  
  -- Gen 7 Hau
  {
    region = ALOLA_REGION,
    trainerName = "Hau",
    pokemonData = {
      {
        guid = "6814d4",
        tier = PINK,
        pokemon = {
          { name = "Pichu", level = 1, types = { "Electric" }, moves = { "Nuzzle", "Tail Whip" }, model_GUID = "a3f444", spawn_effect="Physical Attack" },
          { name = "Rowlet", level = 2, types = { "Grass", "Flying" }, moves = { "Leafage", "Peck" }, model_GUID = "494cbe" } }
      },
      {
        guid = "d3ba66",
        tier = GREEN,
        pokemon = {
          { name = "Eevee", level = 2, types = { "Normal" }, moves = { "Quick Attack", "Bite" }, model_GUID = "b37bcd" },
          { name = "Pikachu", level = 3, types = { "Electric" }, moves = { "Thunder Shock", "Quick Attack" }, model_GUID = "813555", spawn_effect="Status Attack" } }
      },
      {
        guid = "226ec4",
        tier = BLUE,
        pokemon = {
          { name = "Komala", level = 3, types = { "Normal" }, moves = { "Sucker Punch", "Earthquake" }, model_GUID = "c45c5f", spawn_effect="Physical Attack" },
          { name = "Dartrix", level = 4, types = { "Grass", "Flying" }, moves = { "Razor Leaf", "Feather Dance" }, model_GUID = "7a6739" } }
      },
      {
        guid = "da96aa",
        tier = YELLOW,
        pokemon = {
          { name = "Raichu", level = 4, types = { "Electric" }, moves = { "Thunderbolt", "Psychic" }, model_GUID = "ac9e94", spawn_effect="Physical Attack" },
          { name = "Vaporeon", level = 5, types = { "Water" }, moves = { "Water Pulse", "Charm" }, model_GUID = "b8e8a6" } }
      },
      {
        guid = "698fc6",
        tier = RED,
        pokemon = {
          { name = "Noivern", level = 5, types = { "Dragon" }, moves = { "Dragon Pulse", "Air Slash" }, model_GUID = "212e94", spawn_effect="Status Attack" },
          { name = "Decidueye", level = 6, types = { "Grass", "Ghost" }, moves = { "Leaf Blade", "Spirit Shackle" }, model_GUID = "d35cbf", spawn_effect="Status Attack", offset={x=0, y=0.13, z=-0.125} } }
      }
    }
  },
  -- Gen 8 Hop
  {
    region = GALAR_REGION,
    trainerName = "Hop",
    pokemonData = {
      {
        guid = "930fd0",
        tier = PINK,
        pokemon = {
          { name = "Rookidee", level = 1, types = { "Flying" }, moves = { "Peck", "Leer" }, model_GUID = "581f48" },
          { name = "Scorbunny", level = 2, types = { "Fire" }, moves = { "Ember", "Quick Attack" }, model_GUID = "003ce3" } }
      },
      {
        guid = "c1d2e4",
        tier = GREEN,
        pokemon = {
          { name = "Wooloo", level = 2, types = { "Normal" }, moves = { "Tackle", "Defense Curl" }, model_GUID = "d2c51c", offset={x=0, y=0, z=0.075} },
          { name = "Cramorant", level = 3, types = { "Flying", "Water" }, moves = { "Dive", "Fury Attack" }, model_GUID = "2b1b24" } }
      },
      {
        guid = "8226c6",
        tier = BLUE,
        pokemon = {
          { name = "Corvisquire", level = 3, types = { "Flying" }, moves = { "Drill Peck", "Swagger" }, model_GUID = "b1809c" },
          { name = "Raboot", level = 4, types = { "Fire" }, moves = { "Flame Charge", "Double Kick" }, model_GUID = "e1dd29" } }
      },
      {
        guid = "b719c1",
        tier = YELLOW,
        pokemon = {
          { name = "Dubwool", level = 4, types = { "Normal" }, moves = { "Cotton Guard", "Zen Headbutt" }, model_GUID = "d79f30" },
          { name = "Snorlax", level = 5, types = { "Normal" }, moves = { "Giga Impact", "Amnesia" }, model_GUID = "829f1b", spawn_effect="Physical Attack", custom_scale=0.8 } }
      },
      {
        guid = "a2d68d",
        tier = RED,
        pokemon = {
          { name = "Corviknight", level = 5, types = { "Flying", "Steel" }, moves = { "Brave Bird", "Steel Wing" }, model_GUID = "1515e6" },
          { name = "Cinderace", level = 6, types = { "Fire" }, moves = { "Pyro Ball", "Double-Edge" }, model_GUID = "edbb96" } }
      },
    }
  },
  -- Gen 9 Nemona
  {
    region = PALDEA_REGION,
    trainerName = "Nemona",
    pokemonData = {
      {
        guid = "6e4f3f",
        tier = PINK,
        pokemon = {
          { name = "Pawmi", level = 1, types = { "Electric" }, moves = { "Nuzzle", "Quick Attack" }, model_GUID = "61a3c8" },
          { name = "Sprigatito", level = 2, types = { "Grass" }, moves = { "Leafage", "Scratch" }, model_GUID = "e259a9"  } }
      },
      {
        guid = "aa71f2",
        tier = GREEN,
        pokemon = {
          { name = "Rockruff", level = 2, types = { "Rock" }, moves = { "Howl", "Rock Throw" }, model_GUID = "aaf680" },
          { name = "Goomy", level = 3, types = { "Dragon" }, moves = { "Water Pulse", "Protect" }, model_GUID = "07df6f" } } --TODO: I think this is probably supposed to be a regional variant of Goomy but we do not have it *shrug*
      },
      {
        guid = "4ed134",
        tier = BLUE,
        pokemon = {
          { name = "Pawmo", level = 3, types = { "Electric", "Fighting" }, moves = { "Arm Thrust", "Spark" }, model_GUID = "ec93e5" },
          { name = "Floragato", level = 4, types = { "Grass" }, moves = { "Magical Leaf", "Bite" }, model_GUID = "43882c" } }
      },
      {
        guid = "d21049",
        tier = YELLOW,
        pokemon = {
          { name = "Midday Lycanroc", level = 4, types = { "Rock"}, moves = { "Accelerock", "Crunch" }, model_GUID = "226b04" },
          { name = "Goodra", level = 5, types = { "Dragon" }, moves = { "Dragon Pulse", "Ice Beam" }, model_GUID = "35c5e9", spawn_effect="Status Attack" } }
      },
      {
        guid = "91108c",
        tier = RED,
        pokemon = {
          { name = "Pawmot", level = 5, types = { "Electric", "Fighting" }, moves = { "Discharge", "Close Combat" }, model_GUID = "06aaa6" },
          { name = "Meowscarada", level = 6, types = { "Grass", "Dark" }, moves = { "Flower Trick", "Slash" }, model_GUID = "5684f7" } }
      }
    }
  }
}

gymData =
{
  -- GenI Team Rocket
  {
    guid = "0f87c4",
    trainerName = "Team Rocket",
    gen = 1,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Weezing", level = 5,  types = { "Poison" },            moves = { "Smokescreen", "Sludge", "Self-Destruct" }, model_GUID = "921e94" },
      { name = "Arbok",   level = 6,  types = { "Poison" },            moves = { "Screech", "Acid", "Bite" }, model_GUID = "0df3c1" } 
    }
  },
  -- GenII Team Rocket
  {
    guid = "81131f",
    trainerName = "Team Rocket",
    gen = 2,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Kangaskhan", level = 5, types = { "Normal" },           moves = { "Comet Punch", "Rage", "Sucker Punch" }, model_GUID = "98bc9e", custom_scale=0.7 },
      { name = "Nidoqueen",  level = 6, types = { "Poison", "Ground" }, moves = { "Poison Fang", "Body Slam", "Bite" }, model_GUID = "c91f41" }
    }
  },
  -- GenIII Team Rocket
  {
    guid = "d91038",
    trainerName = "Team Rocket",
    gen = 3,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Camerupt",   level = 5, types = { "Fire", "Ground" },     moves = { "Fissure", "Ember", "Earthquake" }, model_GUID = "f266b1", spawn_effect="Physical Attack", custom_scale=0.6, offset={x=0, y=0, z=-0.1} },
      { name = "Sharpedo",   level = 6, types = { "Water", "Dark" },      moves = { "Swagger", "Aqua Jet", "Crunch" }, model_GUID = "129bd7", spawn_effect="Physical Attack" }
    }
  },
  -- GenIV Team Rocket
  {
    guid = "25a357",
    trainerName = "Team Galactic",
    gen = 4,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Crobat",     level = 5, types = { "Poison", "Flying" },   moves = { "Poison Fang", "Air Cutter", "Bite" }, model_GUID = "40d4cd" },
      { name = "Honchkrow",  level = 6, types = { "Dark", "Flying" },     moves = { "Night Shade", "Drill Peck", "Feint Attack" }, model_GUID = "67c739" }
    }
  },
  -- GenV Team Rocket
  {
    guid = "c6bb6e",
    trainerName = "Team Plasma",
    gen = 5,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Zoroark",    level = 5, types = { "Dark" },               moves = { "Fury Swipes", "Hone Claws", "Feint Attack" }, model_GUID = "fb10d4" },
      { name = "Hydreigon",  level = 6, types = { "Dark", "Dragon" },     moves = { "Tri Attack", "Assurance", "Dragon Breath" }, model_GUID = "2621b5", spawn_effect="Status Attack" }
    }
  },
  -- GenVI Team Rocket
  {
    guid = "edb9ad",
    trainerName = "Team Flare",
    gen = 6,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Liepard",    level = 5, types = { "Dark" },               moves = { "Fury Swipes", "Hone Claws", "Play Rough" }, model_GUID = "0d58f0", custom_scale=0.8 },
      { name = "Pyroar",     level = 6, types = { "Fire", "Normal" },     moves = { "Noble Roar", "Crunch", "Flamethrower" }, model_GUID = "4b1422", custom_scale=0.85 }
    }
  },
  -- GenVII Team Rocket
  {
    guid = "85a301",
    trainerName = "Team Rocket",
    gen = 7,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Golisopod",  level = 5, types = { "Bug", "Water" },       moves = { "Swords Dance", "Razor Shell", "First Impression" }, model_GUID = "f4e89c" },
      { name = "Bewear",     level = 6, types = { "Normal", "Fighting" }, moves = { "Take Down", "Payback", "Hammer Arm" }, model_GUID = "7d4606", spawn_effect="Status Attack" }
    }
  },
  -- GenVIII Team Rocket
  {
    guid = "a5c540",
    trainerName = "Team Yell",
    gen = 8,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Linoone",    level = 5, types = { "Dark", "Normal" },     moves = { "Slash", "Hone Claws", "Pin Missile" }, model_GUID = "af2407" },
      { name = "Thievul",    level = 6, types = { "Dark" },               moves = { "Night Slash", "Sucker Punch", "Tail Slap" }, model_GUID = "fdee2d" }
    }
  },
  -- GenIX Team Rocket
  {
    guid = "5bf887",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Dachsbun",   level = 5, types = { "Fairy" },              moves = { "Crunch", "Mud-Slap", "Play Rough" }, model_GUID = "01312a" },
      { name = "Revavroom",  level = 6, types = { "Fairy" },              moves = { "Spin Out", "Confuse Ray", "Magical Torque" }, model_GUID = "27995d" }
    }
  },
  {
    guid = "d32942",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Torkoal",    level = 5, types = { "Fire" },               moves = { "Iron Defense", "Clear Smog", "Flame Wheel" }, model_GUID = "ad6f78", spawn_effect="Physical Attack" },
      { name = "Revavroom",  level = 6, types = { "Fire" },               moves = { "Swift", "Screech", "Blazing Torque" }, model_GUID = "27995d" }
    }
  },
  {
    guid = "7e5fa6",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Pawniard",   level = 5, types = { "Dark", "Steel" },      moves = { "Aerial Ace", "Metal Claw", "Fury Cutter" }, model_GUID = "4aa17e" },
      { name = "Revavroom",  level = 6, types = { "Dark" },               moves = { "Swift", "Metal Sound", "Wicked Torque" }, model_GUID = "27995d" }
    }
  },
  {
    guid = "148183",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Annihilape", level = 5, types = { "Fighting", "Ghost" },  moves = { "Rage Fist", "Fire Punch", "Ice Punch" }, model_GUID = "d78227" },
      { name = "Revavroom",  level = 6, types = { "Fighting" },           moves = { "Spin Out", "H. Horsepower", "Combat Torque" }, model_GUID = "27995d" }
    }
  },
  {
    guid = "908116",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Skuntank",   level = 5, types = { "Poison", "Dark" },     moves = { "Sucker Punch", "Venoshock", "Fury Swipes" }, model_GUID = "142926" },
      { name = "Revavroom",  level = 6, types = { "Poison" },             moves = { "Spin Out", "Flame Charge", "Noxious Torque" }, model_GUID = "27995d" }
    }
  },

  -- Gen I
  -- Gym Leaders
  {
    guid = "5ad999",
    trainerName = "Brock",
    gen = 1,
    gymTier = 1,
    pokemon = {
      { name = "Geodude", level = 2, types = { "Rock", "Ground" }, moves = { "Defense Curl", "Tackle", "Rock Throw" }, model_GUID = "df4771", spawn_effect="Physical Attack" },
      { name = "Onix",    level = 2, types = { "Rock", "Ground" }, moves = { "Screech", "Bind", "Rock Throw" }, model_GUID = "f5b6ad", custom_scale=0.7, offset={x=0,y=0,z=0.2} } }
  },
  {
    guid = "7e7d23",
    trainerName = "Misty",
    gen = 1,
    gymTier = 2,
    pokemon = {
      { name = "Staryu",  level = 3, types = { "Water" }, moves = { "Harden", "Water Gun", "Rapid Spin" }, model_GUID = "792e94", spawn_effect="Physical Attack" },
      { name = "Starmie", level = 3, types = { "Water", "Psychic" }, moves = { "Tackle", "Water Pulse", "Rapid Spin" }, model_GUID = "1072a5" } }
  },
  {
    guid = "e87599",
    trainerName = "Lt. Surge",
    gen = 1,
    gymTier = 3,
    pokemon = {
      { name = "Voltorb", level = 3, types = { "Electric" }, moves = { "Screech", "Sonic Boom", "Shock Wave" }, model_GUID = "37bc9d", spawn_effect="Physical Attack" },
      { name = "Raichu",  level = 4, types = { "Electric" }, moves = { "Quick Attack", "Mega Kick", "Shock Wave" }, model_GUID = "ce46d3" } }
  },
  {
    guid = "e251b8",
    trainerName = "Erika",
    gen = 1,
    gymTier = 4,
    pokemon = {
      { name = "Tangela",   level = 4, types = { "Grass" },           moves = { "Poison Powder", "Giga Drain", "Vine Whip" }, model_GUID = "9ff5ec" },
      { name = "Vileplume", level = 4, types = { "Grass", "Poison" }, moves = { "Acid", "Sleep Powder", "Petal Dance" }, model_GUID = "588b3f" } }
  },
  {
    guid = "26c22d",
    trainerName = "Sabrina",
    gen = 1,
    gymTier = 5,
    pokemon = {
      { name = "Mr. Mime", level = 5, types = { "Psychic" }, moves = { "Barrier", "Psybeam", "Double Slap" }, model_GUID = "b25a93" },
      { name = "Alakazam", level = 6, types = { "Psychic" }, moves = { "Reflect", "Psybeam", "Night Shade" }, model_GUID = "c3804e" } }
  },
  {
    guid = "10246c",
    trainerName = "Koga",
    gen = 1,
    gymTier = 6,
    pokemon = {
      { name = "Muk",     level = 5, types = { "Poison" }, moves = { "Toxic", "Moonblast", "Sludge" }, model_GUID = "813b8b", custom_scale=0.5 },
      { name = "Weezing", level = 6, types = { "Poison" }, moves = { "Protect", "Self-Destruct", "Sludge" }, model_GUID = "921e94" } }
  },
  {
    guid = "cca8ed",
    trainerName = "Blaine",
    gen = 1,
    gymTier = 7,
    pokemon = {
      { name = "Rapidash", level = 7, types = { "Fire" }, moves = { "Bounce", "Stomp", "Fire Spin" }, model_GUID = "20403e", custom_scale=0.7 },
      { name = "Arcanine", level = 7, types = { "Fire" }, moves = { "Crunch", "Outrage", "Flare Blitz" }, model_GUID = "d89ae7", custom_scale=0.7 } }
  },
  {
    guid = "7cda88",
    trainerName = "Giovanni",
    gen = 1,
    gymTier = 8,
    pokemon = {
      { name = "Dugtrio",  level = 8, types = { "Ground" }, moves = { "Sucker Punch", "Slash", "Dig" }, model_GUID = "b4d340", custom_scale=0.8 },
      { name = "Nidoking", level = 8, types = { "Poison", "Ground" }, moves = { "Poison Jab", "Megahorn", "Earthquake" }, model_GUID = "b038db" } }
  },

  -- Elite Four + Champion
  {
    guid = "bd572f",
    trainerName = "Lorelei",
    gen = 1,
    gymTier = 9,
    pokemon = {
      { name = "Cloyster", level = 9, types = { "Water", "Ice" }, moves = { "Protect", "Hydro Pump", "Aurora Beam" }, model_GUID = "73e384" },
      { name = "Lapras",   level = 10, types = { "Water", "Ice" }, moves = { "Body Slam", "Hydro Pump", "Blizzard" }, model_GUID = "ae0d8f", custom_scale=0.8, offset={x=0, y=0.2, z=-0.1} } }
  },
  {
    guid = "ec4724",
    trainerName = "Bruno",
    gen = 1,
    gymTier = 9,
    pokemon = {
      { name = "Hitmonlee", level = 9, types = { "Fighting" }, moves = { "Mega Kick", "Rolling Kick", "High Jump Kick" }, model_GUID = "d821ab", spawn_effect="Physical Attack" },
      { name = "Machamp",   level = 10, types = { "Fighting" }, moves = { "Earthquake", "Cross Chop", "Submission" }, model_GUID = "94b0de", spawn_effect="Physical Attack" } }
  },
  {
    guid = "0a1c4c",
    trainerName = "Agatha",
    gen = 1,
    gymTier = 9,
    pokemon = {
      { name = "Arbok",  level = 9, types = { "Poison" }, moves = { "Glare", "Crunch", "Sludge Bomb" }, model_GUID = "0df3c1" },
      { name = "Gengar", level = 10, types = { "Ghost", "Poison" },  moves = { "Confuse Ray", "Dream Eater", "Night Shade" }, model_GUID = "4638bc" } }
  },
  {
    guid = "9e7552",
    trainerName = "Lance",
    gen = 1,
    gymTier = 9,
    pokemon = {
      { name = "Gyarados",  level = 9, types = { "Water", "Flying" },  moves = { "Hyper Beam", "Dragon Rage", "Hydro Pump" }, model_GUID = "bb17bd", custom_scale=0.75 },
      { name = "Dragonite", level = 10, types = { "Dragon", "Flying" }, moves = { "Hyper Beam", "Dragon Rage", "Blizzard" }, model_GUID = "fa47e5" } }
  },

  {
    guid = "5686a8",
    trainerName = "Gary",
    gen = 1,
    gymTier = 10,
    pokemon = {
      { name = "Arcanine", level = 10,  types = { "Fire", "Dark" }, moves = { "Crunch", "Extreme Speed", "Flamethrower" }, model_GUID = "d89ae7", custom_scale=0.7 },
      { name = "Venusaur", level = 11, types = { "Grass", "Poison" }, moves = { "Growth", "Razor Leaf", "Solar Beam" }, model_GUID = "452ac8", spawn_effect="Physical Attack", custom_scale=0.6 } }
  },
  {
    guid = "f0b286",
    trainerName = "Gary",
    gen = 1,
    gymTier = 10,
    pokemon = {
      { name = "Pidgeot",   level = 10,  types = { "Flying", "Normal" }, moves = { "Feather Dance", "Mirror Move", "Sky Attack" }, model_GUID = "831415" },
      { name = "Blastoise", level = 11, types = { "Water" },            moves = { "Flash Cannon", "Blizzard", "Hydro Pump" }, model_GUID = "54ea11" } }
  },
  {
    guid = "874b94",
    trainerName = "Gary",
    gen = 1,
    gymTier = 10,
    pokemon = {
      { name = "Alakazam",  level = 10,  types = { "Psychic" },        moves = { "Reflect", "Shadow Ball", "Future Sight" }, model_GUID = "c3804e"  },
      { name = "Charizard", level = 11, types = { "Fire", "Flying" }, moves = { "Slash", "Aerial Ace", "Fire Blast" }, model_GUID = "27261b", spawn_effect="Status Attack" } }
  },

  -- Gen II
  -- Gym Leaders
  {
    guid = "d9713f",
    trainerName = "Falkner",
    gen = 2,
    gymTier = 1,
    pokemon = {
      { name = "Pidgey",    level = 2, types = { "Flying", "Normal" }, moves = { "Sand Attack", "Tackle", "Peck" }, model_GUID = "e042f9" },
      { name = "Pidgeotto", level = 2, types = { "Flying", "Normal" }, moves = { "Mud-Slap", "Tackle", "Gust" }, model_GUID = "47d87b", spawn_effect="Physical Attack" } }
  },
  {
    guid = "78fe04",
    trainerName = "Bugsy",
    gen = 2,
    gymTier = 2,
    pokemon = {
      { name = "Kakuna",  level = 3, types = { "Bug" },           moves = { "String Shot", "Harden", "Poison Sting" }, model_GUID = "b46efe" },
      { name = "Scyther", level = 3, types = { "Bug", "Flying" }, moves = { "Fury Cutter", "Quick Attack", "Wing Attack" }, model_GUID = "a98dea" } }
  },
  {
    guid = "932ee1",
    trainerName = "Whitney",
    gen = 2,
    gymTier = 3,
    pokemon = {
      { name = "Clefairy", level = 3, types = { "Fairy" },  moves = { "Mimic", "Metronome", "Moonblast" }, model_GUID = "782a2e" },
      { name = "Miltank",  level = 4, types = { "Normal" }, moves = { "Rollout", "Stomp", "Play Rough" }, model_GUID = "cd7e0e", spawn_effect="Physical Attack" } }
  },
  {
    guid = "6c22b9",
    trainerName = "Morty",
    gen = 2,
    gymTier = 4,
    pokemon = {
      { name = "Haunter", level = 4, types = { "Ghost", "Poison" }, moves = { "Mimic", "Hypnosis", "Night Shade" }, model_GUID = "13b866" },
      { name = "Gengar",  level = 4, types = { "Ghost", "Poison" }, moves = { "Sucker Punch", "Dream Eater", "Shadow Ball" }, model_GUID = "4638bc" } }
  },
  {
    guid = "1297c5",
    trainerName = "Chuck",
    gen = 2,
    gymTier = 5,
    pokemon = {
      { name = "Primeape",  level = 5, types = { "Fighting" },          moves = { "Rage", "Rock Slide", "Karate Chop" }, model_GUID = "2b471e", spawn_effect="Physical Attack" },
      { name = "Poliwrath", level = 6, types = { "Water", "Fighting" }, moves = { "Hypnosis", "Surf", "Dynamic Punch" }, model_GUID = "24f90c", custom_scale=0.8 } }
  },
  {
    guid = "9d44d1",
    trainerName = "Jasmine",
    gen = 2,
    gymTier = 6,
    pokemon = {
      { name = "Magnemite", level = 5, types = { "Electric", "Steel" }, moves = { "Thunder Wave", "Sonic Boom", "Thunderbolt" }, model_GUID = "947e98" },
      { name = "Steelix",   level = 6, types = { "Steel", "Ground" },   moves = { "Earthquake", "Screech", "Iron Tail" }, model_GUID = "a4d334", custom_scale=0.7 } }
  },
  {
    guid = "a713db",
    trainerName = "Pryce",
    gen = 2,
    gymTier = 7,
    pokemon = {
      { name = "Dewgong",   level = 7, types = { "Water", "Ice" },  moves = { "Headbutt", "Icy Wind", "Aurora Beam" }, model_GUID = "6fa3a7", spawn_effect="Physical Attack" },
      { name = "Piloswine", level = 7, types = { "Ice", "Ground" }, moves = { "Mud Bomb", "Ice Fang", "Blizzard" }, model_GUID = "3aabb9" } }
  },
  {
    guid = "9846bd",
    trainerName = "Clair",
    gen = 2,
    gymTier = 8,
    pokemon = {
      { name = "Dragonair", level = 8, types = { "Dragon" },          moves = { "Surf", "Fire Blast", "Dragon Breath" }, model_GUID = "a88377" },
      { name = "Kingdra",   level = 8, types = { "Water", "Dragon" }, moves = { "Surf", "Hyper Beam", "Dragon Breath" }, model_GUID = "fd04bb" } }
  },

  -- Elite Four + champion
  {
    guid = "746880",
    trainerName = "Will",
    gen = 2,
    gymTier = 9,
    pokemon = {
      { name = "Jynx", level = 9, types = { "Ice", "Psychic" },    moves = { "Lovely Kiss", "Ice Punch", "Psychic" }, model_GUID = "43c517", custom_scale=0.9 },
      { name = "Xatu", level = 10, types = { "Psychic", "Flying" }, moves = { "Confuse Ray", "Aerial Ace", "Psychic" }, model_GUID = "a72b40" } }
  },
  {
    guid = "9447fd",
    trainerName = "Koga",
    gen = 2,
    gymTier = 9,
    pokemon = {
      { name = "Forretress", level = 9, types = { "Bug", "Steel" },     moves = { "Spikes", "Swift", "Explosion" }, model_GUID = "6fe49a" },
      { name = "Crobat",     level = 10, types = { "Poison", "Flying" }, moves = { "Poison Fang", "Bite", "Wing Attack" }, model_GUID = "40d4cd" } }
  },
  {
    guid = "d99872",
    trainerName = "Bruno",
    gen = 2,
    gymTier = 9,
    pokemon = {
      { name = "Hitmontop", level = 9, types = { "Fighting" }, moves = { "Triple Kick", "Detect", "Counter" }, model_GUID = "f2168b", spawn_effect="Physical Attack" },
      { name = "Machamp",   level = 10, types = { "Fighting" }, moves = { "Rock Slide", "Vital Throw", "Cross Chop" }, model_GUID = "94b0de", spawn_effect="Physical Attack" } }
  },
  {
    guid = "d55f10",
    trainerName = "Karen",
    gen = 2,
    gymTier = 9,
    pokemon = {
      { name = "Umbreon",  level = 9, types = { "Dark" },         moves = { "Confuse Ray", "Payback", "Feint Attack" }, model_GUID = "33d105" },
      { name = "Houndoom", level = 10, types = { "Dark", "Fire" }, moves = { "Flamethrower", "Pursuit", "Crunch" }, model_GUID = "875a93" } }
  },

  {
    guid = "6601cb",
    trainerName = "Red",
    gen = 2,
    gymTier = 10,
    pokemon = {
      { name = "Pikachu", level = 10,  types = { "Electric" }, moves = { "Iron Tail", "Thunderbolt", "Volt Tackle" }, model_GUID = "813555", spawn_effect="Status Attack" },
      { name = "Snorlax", level = 11, types = { "Normal" },   moves = { "Crunch", "Blizzard", "Giga Impact" }, model_GUID = "829f1b", spawn_effect="Physical Attack", custom_scale=0.8 } }
  },
  {
    guid = "4cddc6",
    trainerName = "Lance",
    gen = 2,
    gymTier = 10,
    pokemon = {
      { name = "Charizard",  level = 10,  types = { "Fire", "Flying" }, moves = { "Slash", "Wing Attack", "Flamethrower" }, model_GUID = "27261b", spawn_effect="Status Attack" },
      { name = "Aerodactyl", level = 11, types = { "Rock", "Flying" }, moves = { "Hyper Beam", "Wing Attack", "Ancient Power" }, model_GUID = "ba21f7" } }
  },
  {
    guid = "6178d5",
    trainerName = "Lance",
    gen = 2,
    gymTier = 10,
    pokemon = {
      { name = "Gyarados",  level = 10,  types = { "Water" },  moves = { "Hyper Beam", "Surf", "Dragon Rage" }, model_GUID = "bb17bd", custom_scale=0.75 },
      { name = "Dragonite", level = 11, types = { "Dragon" }, moves = { "Hyper Beam", "Blizzard", "Thunder" }, model_GUID = "fa47e5" } }
  },

  -- Gen III
  -- Gym Leaders
  {
    guid = "a12ffa",
    trainerName = "Roxanne",
    gen = 3,
    gymTier = 1,
    pokemon = {
      { name = "Geodude",  level = 2, types = { "Rock", "Ground" }, moves = { "Defense Curl", "Tackle", "Rock Throw" }, model_GUID = "df4771", spawn_effect="Physical Attack" },
      { name = "Nosepass", level = 2, types = { "Rock" }, moves = { "Rock Tomb", "Tackle", "Rock Throw" }, model_GUID = "ef03a1" } }
  },
  {
    guid = "300c55",
    trainerName = "Brawly",
    gen = 3,
    gymTier = 2,
    pokemon = {
      { name = "Machop",   level = 3, types = { "Fighting" }, moves = { "Bulk Up", "Seismic Toss", "Low Kick" }, model_GUID = "4a5304", spawn_effect="Physical Attack" },
      { name = "Makuhita", level = 3, types = { "Fighting" }, moves = { "Sand Attack", "Arm Thrust", "Knock Off" }, model_GUID = "b12e69" } }
  },
  {
    guid = "fc6195",
    trainerName = "Wattson",
    gen = 3,
    gymTier = 3,
    pokemon = {
      { name = "Voltorb",   level = 3, types = { "Electric" }, moves = { "Sonic Boom", "Spark", "Self-Destruct" }, model_GUID = "37bc9d", spawn_effect="Physical Attack" },
      { name = "Manectric", level = 4, types = { "Electric" }, moves = { "Quick Attack", "Shock Wave", "Thunder Wave" }, model_GUID = "27ca2d", custom_scale=0.9 } }
  },
  {
    guid = "7fab48",
    trainerName = "Flannery",
    gen = 3,
    gymTier = 4,
    pokemon = {
      { name = "Slugma",  level = 4, types = { "Fire" }, moves = { "Light Screen", "Rock Slide", "Flamethrower" }, model_GUID = "964d48" },
      { name = "Torkoal", level = 4, types = { "Fire" }, moves = { "Protect", "Body Slam", "Overheat" }, model_GUID = "ad6f78", spawn_effect="Physical Attack" } }
  },
  {
    guid = "1e64be",
    trainerName = "Norman",
    gen = 3,
    gymTier = 5,
    pokemon = {
      { name = "Vigoroth", level = 5, types = { "Normal" }, moves = { "Feint Attack", "Slash", "Facade" }, model_GUID = "4d9117" },
      { name = "Slaking",  level = 6, types = { "Normal" }, moves = { "Feint Attack", "Focus Punch", "Facade" }, model_GUID = "66bcca" } }
  },
  {
    guid = "7fd11d",
    trainerName = "Winona",
    gen = 3,
    gymTier = 6,
    pokemon = {
      { name = "Pelipper", level = 5, types = { "Water", "Flying" },  moves = { "Supersonic", "Water Pulse", "Aerial Ace" }, model_GUID = "dff0ed" },
      { name = "Altaria",  level = 6, types = { "Dragon", "Flying" }, moves = { "Earthquake", "Dragon Breath", "Aerial Ace" }, model_GUID = "9a2210" } }
  },
  {
    guid = "f07fbc",
    trainerName = "Tate & Liza",
    gen = 3,
    gymTier = 7,
    pokemon = {
      { name = "Lunatone", level = 7, types = { "Rock", "Psychic" }, moves = { "Light Screen", "Moonblast", "Rock Slide" }, model_GUID = "de6094" },
      { name = "Solrock",  level = 7, types = { "Rock", "Psychic" }, moves = { "Psychic", "Solar Beam", "Flare Blitz" }, model_GUID = "12e752" } }
  },
  {
    guid = "02fd5e",
    trainerName = "Wallace",
    gen = 3,
    gymTier = 8,
    pokemon = {
      { name = "Whiscash", level = 8, types = { "Water", "Ground" }, moves = { "Amnesia", "Earthquake", "Water Pulse" }, model_GUID = "08dca8" },
      { name = "Milotic",  level = 8, types = { "Water" }, moves = { "Dragon Tail", "Blizzard", "Water Pulse" },  model_GUID = "ab980b", spawn_effect="Physical Attack", offset={x=0, y=1.0, z=0} } }
  },

  -- Elite Four
  {
    guid = "c20862",
    trainerName = "Phoebe",
    gen = 3,
    gymTier = 9,
    pokemon = {
      { name = "Sableye",  level = 9, types = { "Dark", "Ghost" },  moves = { "Psychic", "Shadow Ball", "Feint Attack" }, model_GUID = "184d06", spawn_effect="Physical Attack"  },
      { name = "Dusclops", level = 10, types = { "Ghost" }, moves = { "Future Sight", "Shadow Ball", "Ice Beam" }, model_GUID = "24a945" } }
  },
  {
    guid = "e7052f",
    trainerName = "Drake",
    gen = 3,
    gymTier = 9,
    pokemon = {
      { name = "Flygon",    level = 9, types = { "Ground", "Dragon" }, moves = { "Fly", "Dig", "Dragon Breath" }, model_GUID = "c8d0b6" },
      { name = "Salamence", level = 10, types = { "Dragon", "Flying" }, moves = { "Fly", "Flamethrower", "Dragon Claw" }, model_GUID = "32c729" } }
  },
  {
    guid = "0d0d9f",
    trainerName = "Glacia",
    gen = 3,
    gymTier = 9,
    pokemon = {
      { name = "Glalie",  level = 9, types = { "Ice" }, moves = { "Light Screen", "Crunch", "Ice Beam" }, model_GUID = "95fc87" },
      { name = "Walrein", level = 10, types = { "Ice", "Water" }, moves = { "Sheer Cold", "Surf", "Blizzard" }, model_GUID = "74dec1", custom_scale=0.75 } }
  },
  {
    guid = "1d1aa1",
    trainerName = "Sidney",
    gen = 3,
    gymTier = 9,
    pokemon = {
      { name = "Sharpedo", level = 9, types = { "Water", "Dark" }, moves = { "Slash", "Surf", "Crunch" }, model_GUID = "129bd7", spawn_effect="Physical Attack" },
      { name = "Absol",    level = 10, types = { "Dark" },  moves = { "Psycho Cut", "Aerial Ace", "Night Slash" }, model_GUID = "4f2184" } }
  },
  -- Champion
  {
    guid = "857b59",
    trainerName = "Steven",
    gen = 3,
    gymTier = 10,
    pokemon = {
      { name = "Claydol", level = 10,  types = { "Ground", "Psychic" }, moves = { "Earthquake", "Ancient Power", "Extrasensory" }, model_GUID = "af6fb3", spawn_effect="Physical Attack" },
      { name = "Aggron",  level = 11, types = { "Steel", "Rock" },  moves = { "Thunder", "Stone Edge", "Iron Tail" }, model_GUID = "ce1109", custom_scale=0.8 } }
  },
  {
    guid = "9b5e32",
    trainerName = "Steven",
    gen = 3,
    gymTier = 10,
    pokemon = {
      { name = "Skarmory", level = 10,  types = { "Steel", "Flying" }, moves = { "Spikes", "Aerial Ace", "Steel Wing" }, model_GUID = "790101", spawn_effect="Physical Attack" },
      { name = "Armaldo",  level = 11, types = { "Rock", "Bug" },  moves = { "Slash", "X-Scissor", "Ancient Power" }, model_GUID = "812ce0" } }
  },
  {
    guid = "f7b21f",
    trainerName = "Steven",
    gen = 3,
    gymTier = 10,
    pokemon = {
      { name = "Cradily",   level = 10,  types = { "Rock", "Grass" },  moves = { "Sludge Bomb", "Giga Drain", "Ancient Power" }, model_GUID = "a8c907" },
      { name = "Metagross", level = 11, types = { "Steel", "Psychic" }, moves = { "Psychic", "Meteor Mash", "Giga Impact" }, model_GUID = "69d7a3", spawn_effect="Status Attack", custom_scale=0.5 } }
  },

  -- Gen IV
  -- Gym Leaders
  {
    guid = "837e35",
    trainerName = "Roark",
    gen = 4,
    gymTier = 1,
    pokemon = {
      { name = "Onix",     level = 2, types = { "Rock", "Ground" }, moves = { "Screech", "Stealth Rock", "Rock Throw" }, model_GUID = "f5b6ad", custom_scale=0.7, offset={x=0,y=0,z=0.2} },
      { name = "Cranidos", level = 2, types = { "Rock" }, moves = { "Screech", "Pursuit", "Headbutt" }, model_GUID = "c3204c", spawn_effect="Physical Attack" } }
  },
  {
    guid = "e2826d",
    trainerName = "Gardenia",
    gen = 4,
    gymTier = 2,
    pokemon = {
      { name = "Cherubi",  level = 3, types = { "Grass" }, moves = { "Safeguard", "Dazzling Gleam", "Grass Knot" }, model_GUID = "a6957e" },
      { name = "Roserade", level = 3, types = { "Grass", "Poison" }, moves = { "Stun Spore", "Poison Sting", "Magical Leaf" }, model_GUID = "62a471", spawn_effect="Physical Attack" } }
  },
  {
    guid = "5b3c49",
    trainerName = "Maylene",
    gen = 4,
    gymTier = 3,
    pokemon = {
      { name = "Meditite", level = 3, types = { "Fighting", "Psychic" }, moves = { "Meditate", "Confusion", "Drain Punch" }, model_GUID = "da149f" },
      { name = "Lucario",  level = 4, types = { "Fighting", "Steel" }, moves = { "Metal Claw", "Bone Rush", "Force Palm" }, model_GUID = "6f7542" } }
  },
  {
    guid = "2c12d2",
    trainerName = "Crasher Wake",
    gen = 4,
    gymTier = 4,
    pokemon = {
      { name = "Quagsire", level = 4, types = { "Water", "Ground" }, moves = { "Rock Tomb", "Mud Bomb", "Water Pulse" }, model_GUID = "59c07d", custom_scale=0.9 },
      { name = "Floatzel", level = 4, types = { "Water" }, moves = { "Swift", "Ice Fang", "Aqua Jet" }, model_GUID = "136547" } }
  },
  {
    guid = "a6e3cb",
    trainerName = "Fantina",
    gen = 4,
    gymTier = 5,
    pokemon = {
      { name = "Duskull",   level = 5, types = { "Ghost" }, moves = { "Will-O-Wisp", "Shadow Sneak", "Future Sight" }, model_GUID = "34ab19" },
      { name = "Mismagius", level = 6, types = { "Ghost" }, moves = { "Magical Leaf", "Shadow Ball", "Psybeam" }, model_GUID = "a81efd", spawn_effect="Physical Attack" } }
  },
  {
    guid = "25c52f",
    trainerName = "Byron",
    gen = 4,
    gymTier = 6,
    pokemon = {
      { name = "Steelix",   level = 5, types = { "Steel", "Ground" }, moves = { "Ice Fang", "Earthquake", "Flash Cannon" }, model_GUID = "a4d334", custom_scale=0.7 },
      { name = "Bastiodon", level = 6, types = { "Rock", "Steel" },  moves = { "Iron Defense", "Stone Edge", "Metal Burst" }, model_GUID = "9d8d6d", custom_scale=0.7 } }
  },
  {
    guid = "3069f3",
    trainerName = "Candice",
    gen = 4,
    gymTier = 7,
    pokemon = {
      { name = "Abomasnow", level = 7, types = { "Grass", "Ice" }, moves = { "Avalanche", "Focus Blast", "Wood Hammer" }, model_GUID = "c003e7", custom_scale=0.8 },
      { name = "Frosslass", level = 7, types = { "Ice", "Ghost" },   moves = { "Blizzard", "Psychic", "Shadow Ball" }, model_GUID = "21d87a" } }
  },
  {
    guid = "f14c62",
    trainerName = "Volkner",
    gen = 4,
    gymTier = 8,
    pokemon = {
      { name = "Luxray",     level = 8, types = { "Electric" }, moves = { "Ice Fang", "Fire Fang", "Thunder Fang" }, model_GUID = "2fe437" },
      { name = "Electivire", level = 8, types = { "Electric" }, moves = { "Cross Chop", "Giga Impact", "Thunder Punch" }, model_GUID = "15ad3d", custom_scale=0.8 } }
  },

  -- Elite Four
  {
    guid = "9244aa",
    trainerName = "Lucian",
    gen = 4,
    gymTier = 9,
    pokemon = {
      { name = "Bronzong", level = 9, types = { "Steel", "Psychic" },   moves = { "Earthquake", "Gyro Ball", "Psychic" }, model_GUID = "422285" },
      { name = "Gallade",  level = 10, types = { "Psychic", "Fighting" }, moves = { "Leaf Blade", "Drain Punch", "Psycho Cut" }, model_GUID = "04f582" } }
  },
  {
    guid = "547ba3",
    trainerName = "Flint",
    gen = 4,
    gymTier = 9,
    pokemon = {
      { name = "Infernape", level = 9, types = { "Fire", "Fighting" }, moves = { "Mach Punch", "Thunder Punch", "Flare Blitz" }, model_GUID = "b04364", offset={x=0, y=0, z=0.1}, custom_scale=0.85 },
      { name = "Magmortar", level = 10, types = { "Fire" }, moves = { "Solar Beam", "Thunderbolt", "Flamethrower" }, model_GUID = "1ba6f9", offset={x=0, y=0, z=0.1} } }
  },
  {
    guid = "38ec9f",
    trainerName = "Bertha",
    gen = 4,
    gymTier = 9,
    pokemon = {
      { name = "Hippowdon", level = 9, types = { "Ground" }, moves = { "Ice Fang", "Earthquake", "Stone Edge" }, model_GUID = "b43ee9", spawn_effect="Physical Attack", custom_scale=0.4 },
      { name = "Rhyperior", level = 10, types = { "Ground", "Rock" }, moves = { "Megahorn", "Earthquake", "Rock Wrecker" }, model_GUID = "860bbc", spawn_effect="Physical Attack", custom_scale=0.65 } }
  },
  {
    guid = "af0b4e",
    trainerName = "Aaron",
    gen = 4,
    gymTier = 9,
    pokemon = {
      { name = "Heracross", level = 9, types = { "Bug", "Fighting" },    moves = { "Close Combat", "Night Slash", "Megahorn" }, model_GUID = "11f35c" },
      { name = "Drapion",   level = 10, types = { "Poison", "Dark" }, moves = { "Aerial Ace", "Cross Poison", "X-Scissor" }, model_GUID = "5178e7", custom_scale=0.8 } }
  },
  -- Champion
  {
    guid = "2648b8",
    trainerName = "Cynthia",
    gen = 4,
    gymTier = 10,
    pokemon = {
      { name = "Togekiss", level = 10,  types = { "Fairy", "Flying" },    moves = { "Aura Sphere", "Dazzling Gleam", "Air Slash" }, model_GUID = "94ed87" },
      { name = "Lucario",  level = 11, types = { "Fighting", "Steel" }, moves = { "Stone Edge", "Aura Sphere", "Flash Cannon" }, model_GUID = "6f7542" } }
  },
  {
    guid = "d10e0c",
    trainerName = "Cynthia",
    gen = 4,
    gymTier = 10,
    pokemon = {
      { name = "Roserade", level = 10,  types = { "Grass", "Poison" }, moves = { "Extrasensory", "Energy Ball", "Sludge Bomb" }, model_GUID = "62a471", spawn_effect="Physical Attack" },
      { name = "Milotic",  level = 11, types = { "Water" }, moves = { "Mirror Coat", "Surf", "Ice Beam" }, model_GUID = "ab980b", spawn_effect="Physical Attack", offset={x=0, y=1.0, z=0} } }
  },
  {
    guid = "25281e",
    trainerName = "Cynthia",
    gen = 4,
    gymTier = 10,
    pokemon = {
      { name = "Spiritomb", level = 10,  types = { "Ghost", "Dark" },  moves = { "Silver Wind", "Shadow Ball", "Dark Pulse" }, model_GUID = "0a6f0d" },
      { name = "Garchomp",  level = 11, types = { "Dragon", "Ground" }, moves = { "Earthquake", "Dragon Rush", "Giga Impact" }, model_GUID = "232447", spawn_effect="Status Attack", custom_scale=0.8 } }
  },

  -- Gen V
  -- Gym Leaders
  {
    guid = "4ad822",
    trainerName = "Cheren",
    gen = 5,
    gymTier = 1,
    pokemon = {
      { name = "Patrat",   level = 2, types = { "Normal" }, moves = { "Work Up", "Tackle", "Bite" }, model_GUID = "95e22a" },
      { name = "Lillipup", level = 2, types = { "Normal" }, moves = { "Work Up", "Quick Attack", "Bite" }, model_GUID = "a3d331" } }
  },
  {
    guid = "f01b5f",
    trainerName = "Roxie",
    gen = 5,
    gymTier = 2,
    pokemon = {
      { name = "Koffing",    level = 3, types = { "Poison" }, moves = { "Smog", "Tackle", "Assurance" }, model_GUID = "b853ca" },
      { name = "Whirlipede", level = 3, types = { "Bug", "Poison" },    moves = { "Venoshock", "Protect", "Pursuit" }, model_GUID = "0f9af9", spawn_effect="Physical Attack", custom_scale=0.8 } }
  },
  {
    guid = "d5fe45",
    trainerName = "Burgh",
    gen = 5,
    gymTier = 3,
    pokemon = {
      { name = "Dwebble",  level = 3, types = { "Bug", "Rock" }, moves = { "Sand Attack", "Struggle Bug", "Feint Attack" }, model_GUID = "553572" },
      { name = "Leavanny", level = 4, types = { "Bug", "Grass" }, moves = { "Grass Whistle", "Struggle Bug", "Razor Leaf" }, model_GUID = "788aa1" } }
  },
  {
    guid = "098cee",
    trainerName = "Elesa",
    gen = 5,
    gymTier = 4,
    pokemon = {
      { name = "Emolga",    level = 4, types = { "Electric", "Flying" }, moves = { "Thunder Wave", "Pursuit", "Spark" }, model_GUID = "dad8a0", spawn_effect="Physical Attack" },
      { name = "Zebstrika", level = 4, types = { "Electric" }, moves = { "Take Down", "Pursuit", "Shock Wave" }, model_GUID = "1f6bb5", spawn_effect="Physical Attack" } }
  },
  {
    guid = "de22b0",
    trainerName = "Clay",
    gen = 5,
    gymTier = 5,
    pokemon = {
      { name = "Krokorok",  level = 5, types = { "Ground", "Dark" }, moves = { "Swagger", "Sand Tomb", "Crunch" }, model_GUID = "4cf233" },
      { name = "Excadrill", level = 6, types = { "Ground", "Steel" }, moves = { "Slash", "Bulldoze", "Metal Claw" }, model_GUID = "dccc9b", spawn_effect="Status Attack"  } }
  },
  {
    guid = "22f826",
    trainerName = "Skyla",
    gen = 5,
    gymTier = 6,
    pokemon = {
      { name = "Swoobat", level = 5, types = { "Psychic", "Flying" }, moves = { "Amnesia", "Assurance", "Heart Stamp" }, model_GUID = "97b4e6" },
      { name = "Swanna",  level = 6, types = { "Water", "Flying" },   moves = { "Feather Dance", "Bubble Beam", "Air Slash" }, model_GUID = "653e11" } }
  },
  {
    guid = "9414b7",
    trainerName = "Drayden",
    gen = 5,
    gymTier = 7,
    pokemon = {
      { name = "Druddigon", level = 7, types = { "Dragon" }, moves = { "Crunch", "Slash", "Revenge" }, model_GUID = "e0e534", custom_scale=0.8 },
      { name = "Haxorus",   level = 7, types = { "Dragon" }, moves = { "Night Slash", "Slash", "Dragon Tail" }, model_GUID = "18b97d" } }
  },
  {
    guid = "052a06",
    trainerName = "Marlon",
    gen = 5,
    gymTier = 8,
    pokemon = {
      { name = "Carracosta", level = 8, types = { "Water", "Rock" }, moves = { "Shell Smash", "Rock Slide", "Scald" }, model_GUID = "212e44", offset={x=0, y=0, z=0.1} },
      { name = "Jellicent (M)",  level = 8, types = { "Water", "Ghost" }, moves = { "Ominous Wind", "Brine", "Scald" }, model_GUID = "b219d0", spawn_effect="Physical Attack" } }
  },

  -- Elite Four
  {
    guid = "254e2b",
    trainerName = "Shauntal",
    gen = 5,
    gymTier = 9,
    pokemon = {
      { name = "Golurk",     level = 9, types = { "Ground", "Ghost" }, moves = { "Brick Break", "Shadow Punch", "Earthquake" }, model_GUID = "002dc3", custom_scale=0.8 },
      { name = "Chandelure", level = 10, types = { "Ghost", "Fire" },  moves = { "Psychic", "Shadow Ball", "Fire Blast" },  model_GUID = "de2e80" } }
  },
  {
    guid = "9bec87",
    trainerName = "Marshal",
    gen = 5,
    gymTier = 9,
    pokemon = {
      { name = "Mienshao",   level = 9, types = { "Fighting" }, moves = { "Rock Slide", "Bounce", "High Jump Kick" }, model_GUID = "afd151" },
      { name = "Conkeldurr", level = 10, types = { "Fighting" }, moves = { "Stone Edge", "Hammer Arm", "Close Combat" }, model_GUID = "04bed2" } }
  },
  {
    guid = "1aa293",
    trainerName = "Grimsley",
    gen = 5,
    gymTier = 9,
    pokemon = {
      { name = "Scrafty", level = 9, types = { "Dark", "Fighting" }, moves = { "Poison Jab", "Brick Break", "Crunch" }, model_GUID = "b9d27b", spawn_effect="Physical Attack" },
      { name = "Bisharp", level = 10, types = { "Dark", "Steel" }, moves = { "Metal Claw", "Aerial Ace", "Night Slash" }, model_GUID = "753f92" } }
  },
  {
    guid = "d181f2",
    trainerName = "Caitlin",
    gen = 5,
    gymTier = 9,
    pokemon = {
      { name = "Sigilyph",   level = 9, types = { "Psychic", "Flying" }, moves = { "Ice Beam", "Air Slash", "Psychic" }, model_GUID = "71ed95" },
      { name = "Gothitelle", level = 10, types = { "Psychic" }, moves = { "Thunderbolt", "Shadow Ball", "Psychic" }, model_GUID = "e6fa75" } }
  },
  -- Champion
  {
    guid = "c17cfd",
    trainerName = "Iris",
    gen = 5,
    gymTier = 10,
    pokemon = {
      { name = "Hydreigon", level = 10,  types = { "Dark", "Dragon" }, moves = { "Flamethrower", "Focus Blast", "Dragon Pulse" }, model_GUID = "2621b5", spawn_effect="Status Attack" },
      { name = "Druddigon", level = 11, types = { "Dragon" }, moves = { "Thunder Punch", "Focus Blast", "Dragon Tail" }, model_GUID = "e0e534", custom_scale=0.8 } }
  },
  {
    guid = "9d2a12",
    trainerName = "Iris",
    gen = 5,
    gymTier = 10,
    pokemon = {
      { name = "Archeops", level = 10,  types = { "Rock", "Flying" },   moves = { "Dragon Claw", "Stone Edge", "Air Slash" }, model_GUID = "e52be5", spawn_effect="Physical Attack" },
      { name = "Haxorus",  level = 11, types = { "Dragon" }, moves = { "Dual Chop", "Slash", "Outrage" }, model_GUID = "18b97d" } }
  },
  {
    guid = "346c48",
    trainerName = "Alder",
    gen = 5,
    gymTier = 10,
    pokemon = {
      { name = "Bouffalant", level = 10,  types = { "Normal" },      moves = { "Stone Edge", "Megahorn", "Head Charge" }, model_GUID = "3296ae"  },
      { name = "Volcarona",  level = 11, types = { "Bug", "Fire" }, moves = { "Overheat", "Bug Buzz", "Hyper Beam" }, model_GUID = "c9ed3b" } }
  },

  -- Gen VI
  -- Gym Leaders
  {
    guid = "c49242",
    trainerName = "Viola",
    gen = 6,
    gymTier = 1,
    pokemon = {
      { name = "Surskit", level = 2, types = { "Bug", "Water" }, moves = { "Quick Attack", "Bubble", "Infestation" }, model_GUID = "15b02f" },
      { name = "Vivillon", level = 2, types = { "Bug", "Flying" }, moves = { "Harden", "Gust", "Infestation" }, model_GUID = "4ea111" } }
  },
  {
    guid = "c3ba0b",
    trainerName = "Grant",
    gen = 6,
    gymTier = 2,
    pokemon = {
      { name = "Amaura", level = 3, types = { "Rock", "Ice" }, moves = { "Thunder Wave", "Take Down", "Rock Tomb" }, model_GUID = "73d866"  },
      { name = "Tyrunt", level = 3, types = { "Rock", "Dragon" }, moves = { "Bite", "Stomp", "Rock Tomb" }, model_GUID = "f6e97c" } }
  },
  {
    guid = "75edd9",
    trainerName = "Korrina",
    gen = 6,
    gymTier = 3,
    pokemon = {
        { name = "Hawlucha", level = 3, types = { "Fighting", "Flying" }, moves = { "Hone Claws", "Wing Attack", "Flying Press" }, model_GUID = "c7140e", spawn_effect="Status Attack" },
        { name = "Lucario", level = 4, types = { "Fighting", "Steel" }, moves = { "Metal Sound", "Bone Rush", "Power-Up Punch" }, model_GUID = "6f7542"  } }
  },
  {
    guid = "ba6bd1",
    trainerName = "Ramos",
    gen = 6,
    gymTier = 4,
    pokemon = {
      { name = "Weepinbell", level = 4, types = { "Grass", "Poison" }, moves = { "Poison Powder", "Acid", "Grass Knot" }, model_GUID = "961d7f" },
      { name = "Gogoat", level = 4, types = { "Grass" }, moves = { "Bulldoze", "Take Down", "Razor Leaf" }, model_GUID = "88d0b0", spawn_effect="Status Attack" } }
  },
  {
    guid = "170341",
    trainerName = "Clemont",
    gen = 6,
    gymTier = 5,
    pokemon = {
      { name = "Magneton", level = 5, types = { "Electric", "Steel" }, moves = { "Tri Attack", "Mirror Shot", "Thunderbolt" }, model_GUID = "f82ef9" },
      { name = "Heliolisk", level = 6, types = { "Electric", "Normal" }, moves = { "Dark Pulse", "Focus Blast", "Thunderbolt" }, model_GUID = "7d0f27" } }
  },
  {
    guid = "ecfb59",
    trainerName = "Valerie",
    gen = 6,
    gymTier = 6,
    pokemon = {
      { name = "Mawile", level = 5, types = { "Steel", "Fairy" }, moves = { "Iron Defense", "Crunch", "Play Rough" }, model_GUID = "71f869" },
      { name = "Sylveon", level = 6, types = { "Fairy" }, moves = { "Charm", "Swift", "Dazzling Gleam" }, model_GUID = "381a03" } }
  },
  {
    guid = "3e6766",
    trainerName = "Olympia",
    gen = 6,
    gymTier = 7,
    pokemon = {
      { name = "Slowking", level = 7, types = { "Water", "Psychic" }, moves = { "Calm Mind", "Power Gem", "Psychic" }, model_GUID = "bcb9f2", custom_scale=0.85 },
      { name = "Meowstic (F)", level = 7, types = { "Psychic" }, moves = { "Calm Mind", "Shadow Ball", "Psychic" }, model_GUID = "3357e1" } }
  },
  {
    guid = "f47073",
    trainerName = "Wulfric",
    gen = 6,
    gymTier = 8,
    pokemon = {
      { name = "Cryogonal",level = 8, types = { "Ice" }, moves = { "Confuse Ray", "Flash Cannon", "Ice Beam" }, model_GUID = "37b1ac", spawn_effect="Physical Attack" },
      { name = "Avalugg",  level = 8, types = { "Ice" }, moves = { "Crunch", "Iron Defense", "Avalanche" }, model_GUID = "fc938c", spawn_effect="Status Attack", custom_scale=0.5 } }
  },

  -- Elite Four
  {
    guid = "970078",
    trainerName = "Wikstrom",
    gen = 6,
    gymTier = 9,
    pokemon = {
      { name = "Klefki", level = 9, types = { "Steel", "Fairy" }, moves = { "Spikes", "Dazzling Gleam", "Flash Cannon" }, model_GUID = "4b6f52", spawn_effect="Physical Attack" },
      { name = "Blade Aegislash", level = 10, types = { "Steel", "Ghost" }, moves = { "Shadow Claw", "Sacred Sword", "Iron Head" }, model_GUID = "a6b120", spawn_effect="Blade Stance" } }
  },
  {
    guid = "dfa5a5",
    trainerName = "Siebold",
    gen = 6,
    gymTier = 9,
    pokemon = {
      { name = "Clawitzer",  level = 9, types = { "Water" }, moves = { "Dark Pulse", "Aura Sphere", "Water Pulse" }, model_GUID = "3bdfca" },
      { name = "Barbaracle", level = 10, types = { "Rock", "Water" }, moves = { "Stone Edge", "Cross Chop", "Razor Shell" }, model_GUID = "7acdd8" } }
  },
  {
    guid = "3c4256",
    trainerName = "Drasna",
    gen = 6,
    gymTier = 9,
    pokemon = {
      { name = "Dragalge", level = 9, types = { "Poison", "Dragon" }, moves = { "Surf", "Sludge Bomb", "Dragon Pulse" }, model_GUID = "2c5c3c" },
      { name = "Noivern", level = 10, types = { "Flying", "Dragon" }, moves = { "Super Fang", "Air Slash", "Dragon Pulse" }, model_GUID = "212e94", spawn_effect="Status Attack"  } }
  },
  {
    guid = "c4d767",
    trainerName = "Malva",
    gen = 6,
    gymTier = 9,
    pokemon = {
      { name = "Pyroar", level = 9, types = { "Fire", "Normal" }, moves = { "Noble Roar", "Wild Charge", "Flamethrower" }, model_GUID = "4b1422", custom_scale=0.85 },
      { name = "Talonflame",  level = 10, types = { "Fire", "Flying" }, moves = { "Steel Wing", "Brave Bird", "Flare Blitz" }, model_GUID = "efd523", spawn_effect="Physical Attack" } }
  },
  -- Champion
  {
    guid = "a20a02",
    trainerName = "Diantha",
    gen = 6,
    gymTier = 10,
    pokemon = {
      { name = "Goodra", level = 10, types = { "Dragon" }, moves = { "Muddy Water", "Fire Blast", "Dragon Pulse" }, model_GUID = "35c5e9", spawn_effect="Status Attack" },
      { name = "Gardevoir", level = 11, types = { "Psychic", "Fairy" }, moves = { "Shadow Ball", "Psychic", "Moonblast" }, model_GUID = "8c5fec", offset={x=0, y=0, z=-0.2} } }
  },
  {
    guid = "4e871f",
    trainerName = "Diantha",
    gen = 6,
    gymTier = 10,
    pokemon = {
      { name = "Gourgeist", level = 10, types = { "Ghost", "Grass" }, moves = { "Shadow Sneak", "Phantom Force", "Seed Bomb" }, model_GUID = "16c782" },
      { name = "Aurorus", level = 11, types = { "Rock", "Ice" }, moves = { "Reflect", "Thunder", "Blizzard" }, model_GUID = "17494e", spawn_effect="Physical Attack" } }
  },
  {
    guid = "e9ea83",
    trainerName = "Diantha",
    gen = 6,
    gymTier = 10,
    pokemon = {
      { name = "Hawlucha", level = 10, types = { "Fighting", "Flying" }, moves = { "Swords Dance", "Poison Jab", "Flying Press" }, model_GUID = "c7140e", spawn_effect="Status Attack" },
      { name = "Tyrantrum", level = 11, types = { "Rock", "Dragon" }, moves = { "Crunch", "Dragon Claw", "Head Smash" }, model_GUID = "e8c337", spawn_effect="Status Attack", custom_scale=0.65 } }
  },

  -- Gen VII
  -- Gym Leaders
  {
    guid = "9d2d79",
    trainerName = "Totem",
    gen = 7,
    gymTier = 1,
    pokemon = {
      { name = "Yungoos", level = 2, types = { "Normal" }, moves = { "Super Fang", "Sand Attack", "Bite" },  model_GUID = "d77420" },
      { name = "Gumshoos", level = 2, types = { "Normal" }, moves = { "Hyper Fang", "Sand Attack", "Bite" }, model_GUID = "902af6" } }
  },
  {
    guid = "18bfc2",
    trainerName = "Totem",
    gen = 7,
    gymTier = 1,
    pokemon = {
      { name = "Rattata", level = 2, types = { "Dark", "Normal" }, moves = { "Tail Whip", "Tackle", "Bite" }, model_GUID = "53c2a4" },
      { name = "Raticate", level = 2, types = { "Dark", "Normal" }, moves = { "Tail Whip", "Quick Attack", "Bite" }, model_GUID = "905fd9" } }
  },
  {
    guid = "bc4cea",
    trainerName = "Hala",
    gen = 7,
    gymTier = 2,
    pokemon = {
        { name = "Makuhita", level = 3, types = { "Fighting" }, moves = { "Fake Out", "Sand Attack", "Arm Thrust" }, model_GUID = "b12e69" },
        { name = "Crabrawler", level = 3, types = { "Fighting" }, moves = { "Leer", "Pursuit", "Power-Up Punch" }, model_GUID = "cc10c3" } }
  },
  {
    guid = "f67255",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Salazzle", level = 3, types = { "Poison", "Fire" }, moves = { "Poison Fang", "Ember", "Nasty Plot" }, model_GUID = "29570d" },
      { name = "Marowak", level = 4, types = { "Fire", "Ghost" }, moves = { "Bonemerang", "Flame Wheel", "Shadow Bone" }, model_GUID = "245f21" } }
  },
  {
    guid = "2abaeb",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Comfey", level = 3, types = { "Fairy" }, moves = { "Growth", "Grass Knot", "Draining Kiss" }, model_GUID = "91d031" },
      { name = "Lurantis", level = 4, types = { "Grass" }, moves = { "X-Scissor", "Leaf Blade", "Night Slash" }, model_GUID = "8cd3d5", spawn_effect="Physical Attack" } }
  },
  {
    guid = "dd267b",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Salandit", level = 3, types = { "Poison", "Fire" }, moves = { "Smog", "Ember", "Dragon Pulse" }, model_GUID = "b90790" },
      { name = "Salazzle", level = 4, types = { "Poison", "Fire" }, moves = { "Smog", "Flamethrower", "Swagger" }, model_GUID = "29570d" } }
  },
  {
    guid = "913644",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Masquerain", level = 3, types = { "Bug", "Flying" }, moves = { "Bug Buzz", "Ominous Wind", "Gust" }, model_GUID = "f71175" },
      { name = "Araquanid", level = 4, types = { "Water", "Bug" }, moves = { "Infestation", "Crunch", "Bubble Beam" }, model_GUID = "049687", spawn_effect="Physical Attack" } }
  },
  {
    guid = "b09f56",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Alomomola", level = 3, types = { "Water" }, moves = { "Protect", "Double Slap", "Brine" }, model_GUID = "987107" },
      { name = "Wishiwashi", level = 4, types = { "Water" }, moves = { "Take Down", "Feint Attack", "Brine" },  model_GUID = "ec2225" } }
  },
  {
    guid = "294927",
    trainerName = "Olivia",
    gen = 7,
    gymTier = 4,
    pokemon = {
      { name = "Boldore", level = 4, types = { "Rock" }, moves = { "Mud-Slap", "Headbutt", "Rock Blast" }, model_GUID = "a80816", spawn_effect="Physical Attack" },
      { name = "Midnight Lycanroc", level = 4, types = { "Rock" }, moves = { "Bite", "Rock Throw", "Stone Edge" }, model_GUID = "5e3a9d" } }
  },
  {
    guid = "59c455",
    trainerName = "Totem",
    gen = 7,
    gymTier = 5,
    pokemon = {
      { name = "Banette", level = 5, types = { "Ghost" }, moves = { "Will-O-Wisp", "Sucker Punch", "Phantom Force" }, model_GUID = "36b0e4" },
      { name = "Mimikyu", level = 6, types = { "Ghost", "Fairy" }, moves = { "Charm", "Wood Hammer", "Shadow Claw" }, model_GUID = "48082a" } }
  },
  {
    guid = "890b4e",
    trainerName = "Totem",
    gen = 7,
    gymTier = 5,
    pokemon = {
      { name = "Dedenne", level = 5, types = { "Electric", "Fairy" }, moves = { "Charm", "Charge Beam", "Play Rough" }, model_GUID = "f90863" },
      { name = "Togedemaru", level = 6, types = { "Electric", "Steel" }, moves = { "Rollout", "Charge Beam", "Zing Zap" }, model_GUID = "e7484b" } }
  },
  {
    guid = "922673",
    trainerName = "Totem",
    gen = 7,
    gymTier = 5,
    pokemon = {
      { name = "Charjabug", level = 5, types = { "Bug", "Electric" }, moves = { "Iron Defense", "Bug Bite", "Spark" }, model_GUID = "f5e6f0" },
      { name = "Vikavolt", level = 6, types = { "Bug", "Electric" }, moves = { "Air Slash", "Bug Buzz", "Thunderbolt" }, model_GUID = "d539ed" } }
  },
  {
    guid = "75f2f1",
    trainerName = "Nanu",
    gen = 7,
    gymTier = 6,
    pokemon = {
      { name = "Krokorok", level = 5, types = { "Ground", "Dark" }, moves = { "Swagger", "Earthquake", "Crunch" }, model_GUID = "4cf233" },
      { name = "Persian", level = 6, types = { "Dark" }, moves = { "Slash", "Power Gem", "Dark Pulse" }, model_GUID = "ae2934" } }
  },
  {
    guid = "d0c8e0",
    trainerName = "Totem",
    gen = 7,
    gymTier = 7,
    pokemon = {
      { name = "Hakamo-o", level = 7, types = { "Dragon", "Fighting" }, moves = { "Noble Roar", "Dragon Claw", "Sky Uppercut" }, model_GUID = "54dfcc" },
      { name = "Kommo-o", level = 7, types = { "Dragon", "Fighting" }, moves = { "Noble Roar", "Dragon Tail", "Close Combat" }, model_GUID = "cbb201" } }
  },
  {
    guid = "b74bcc",
    trainerName = "Totem",
    gen = 7,
    gymTier = 7,
    pokemon = {
      { name = "Blissey", level = 7, types = { "Normal" }, moves = { "Light Screen", "Egg Bomb", "Double-Edge" }, model_GUID = "7c05e0", spawn_effect="Status Attack" },
      { name = "Ribombee", level = 7, types = { "Bug", "Fairy" }, moves = { "Struggle Bug", "Dazzling Gleam", "Silver Wind" }, model_GUID = "a1c941", spawn_effect="Physical Attack" } }
  },
  {
    guid = "8baab3",
    trainerName = "Hapu",
    gen = 7,
    gymTier = 8,
    pokemon = {
      { name = "Flygon", level = 8, types = { "Ground", "Dragon" }, moves = { "Dragon Breath", "Rock Slide", "Earth Power" }, model_GUID = "c8d0b6" },
      { name = "Mudsdale", level = 8, types = { "Ground" }, moves = { "Counter", "Heavy Slam", "Earthquake" }, model_GUID = "28b051", spawn_effect="Physical Attack", custom_scale=0.6 } }
   },
  
  -- Elite Four
  {
    guid = "7c12f8",
    trainerName = "Olivia",
    gen = 7,
    gymTier = 9,
    pokemon = {
      { name = "Probopass", level = 9, types = { "Rock", "Steel" }, moves = { "Power Gem", "Thunder Wave", "Earth Power" }, model_GUID = "3a1a8d" },
      { name = "Midnight Lycanroc", level = 10, types = { "Rock" }, moves = { "Stone Edge", "Counter", "Rock Climb" }, model_GUID = "5e3a9d" } }
  },
  {
    guid = "c34329",
    trainerName = "Molayne",
    gen = 7,
    gymTier = 9,
    pokemon = {
      { name = "Metagross",  level = 9, types = { "Steel", "Psychic" }, moves = { "Hammer Arm", "Meteor Mash", "Zen Headbutt" }, model_GUID = "69d7a3", spawn_effect="Status Attack", custom_scale=0.5 },
      { name = "Dugtrio", level = 10, types = { "Ground" }, moves = { "Stone Edge", "Iron Head", "Earthquake" }, model_GUID = "b4d340", custom_scale=0.8 } }
  },
  {
    guid = "504061",
    trainerName = "Kahili",
    gen = 7,
    gymTier = 9,
    pokemon = {
      { name = "Baile Oricorio", level = 9, types = { "Fire", "Flying" }, moves = { "Teeter Dance", "Air Slash", "Rev. Dance Fire" }, model_GUID = "f5fc3a", spawn_effect="Physical Attack" },
      { name = "Toucannon", level = 10, types = { "Flying", "Normal" }, moves = { "Hyper Voice", "Aerial Ace", "Flash Cannon" }, model_GUID = "2c6bc3" } }
  },
  {
    guid = "b9bd0e",
    trainerName = "Acerola",
    gen = 7,
    gymTier = 9,
    pokemon = {
      { name = "Dhelmise", level = 9, types = { "Ghost", "Ghost" }, moves = { "Slam", "Energy Ball", "Shadow Ball" }, model_GUID = "af1f36", spawn_effect="Physical Attack" },
      { name = "Palossand",  level = 10, types = { "Ghost", "Ground" }, moves = { "Iron Defense", "Earth Power", "Shadow Ball" }, model_GUID = "d2d150", offset={x=0, y=0, z=-0.15} } }
  },
  -- Champion
  {
    guid = "94f594",
    trainerName = "Kukui",
    gen = 7,
    gymTier = 10,
    pokemon = {
      { name = "Ninetales", level = 10, types = { "Ice" }, moves = { "Dazzling Gleam", "Ice Shard", "Blizzard" }, model_GUID = "654f90" },
      { name = "Primarina", level = 11, types = { "Water", "Fairy" }, moves = { "Captivate", "Sparkling Aria", "Moonblast" }, model_GUID = "bd9d9f" } }
  },
  {
    guid = "7faa66",
    trainerName = "Kukui",
    gen = 7,
    gymTier = 10,
    pokemon = {
      { name = "Midday Lycanroc", level = 10, types = { "Rock" }, moves = { "Crunch", "Accelerock", "Stone Edge" }, model_GUID = "226b04" },
      { name = "Incineroar", level = 11, types = { "Fire", "Dark" }, moves = { "Darkest Lariat", "Cross Chop", "Flare Blitz" }, model_GUID = "bc10fb" } }
  },
  {
    guid = "12326f",
    trainerName = "Hau",
    gen = 7,
    gymTier = 10,
    pokemon = {
      { name = "Raichu", level = 10, types = { "Electric" }, moves = { "Thunderbolt", "Psychic", "Focus Blast" }, model_GUID = "ac9e94", spawn_effect="Physical Attack" },
      { name = "Decidueye", level = 11, types = { "Grass", "Ghost" }, moves = { "Nasty Plot", "Spirit Shackle", "Leaf Blade" }, model_GUID = "d35cbf", spawn_effect="Status Attack", offset={x=0, y=0.115, z=0} } }
  },

  -- Gen VIII
  -- Gym Leaders
  {
    guid = "182d74",
    trainerName = "Milo",
    gen = 8,
    gymTier = 1,
    pokemon = {
      { name = "Gossifleur", level = 2, types = { "Grass" }, moves = { "Tackle", "Rapid Spin", "Magical Leaf" }, model_GUID = "2f875e"  },
      { name = "Eldegoss", level = 2, types = { "Grass" }, moves = { "Tackle", "Leafage", "Magical Leaf" }, model_GUID = "227ab8" } }
  },
  {
    guid = "c087f9",
    trainerName = "Nessa",
    gen = 8,
    gymTier = 2,
    pokemon = {
      { name = "Arrokuda", level = 3, types = { "Water" }, moves = { "Fury Attack", "Bite", "Aqua Jet" }, model_GUID = "95b4b0" },
      { name = "Drednaw", level = 3, types = { "Water", "Rock" }, moves = { "Headbutt", "Bite", "Razor Shell" }, model_GUID = "0ab337", custom_scale=0.8 } }
  },
  {
    guid = "08b1a8",
    trainerName = "Kabu",
    gen = 8,
    gymTier = 3,
    pokemon = {
      { name = "Arcanine", level = 3, types = { "Fire" }, moves = { "Will-O-Wisp", "Bite", "Flame Wheel" }, model_GUID = "d89ae7", custom_scale=0.7 },
      { name = "Centiskorch", level = 4, types = { "Fire", "Bug" }, moves = { "Coil", "Bug Bite", "Flame Wheel" }, model_GUID = "a1917b"  } }
  },
  {
    guid = "4f251c",
    trainerName = "Bea",
    gen = 8,
    gymTier = 4,
    pokemon = {
        { name = "Sirfetch'd", level = 4, types = { "Fighting" }, moves = { "Detect", "Brutal Swing", "Revenge" }, model_GUID = "158014" },
        { name = "Machamp", level = 4, types = { "Fighting" }, moves = { "Strength", "Knock Off", "Revenge" }, model_GUID = "94b0de", spawn_effect="Physical Attack" } }
  },
  {
    guid = "cad1a8",
    trainerName = "Allister",
    gen = 8,
    gymTier = 4,
    pokemon = {
        { name = "Cursola", level = 4, types = { "Ghost" }, moves = { "Curse", "Ancient Power", "Hex" }, model_GUID = "b8f109" },
        { name = "Gengar", level = 4, types = { "Ghost", "Poison" }, moves = { "Hypnosis", "Venoshock", "Hex" }, model_GUID = "4638bc" } }
  },
  {
    guid = "7749a1",
    trainerName = "Opal",
    gen = 8,
    gymTier = 5,
    pokemon = {
      { name = "Weezing", level = 5, types = { "Poison" }, moves = { "Fairy Wind", "Sludge", "Strange Steam" }, model_GUID = "e96342" },
      { name = "Alcremie", level = 5, types = { "Fairy" }, moves = { "Sweet Kiss", "Acid Armor", "Draining Kiss" }, model_GUID = "44047f" } }
  },
  {
    guid = "3ec0f8",
    trainerName = "Melony",
    gen = 8,
    gymTier = 6,
    pokemon = {
      { name = "Darmanitan", level = 5, types = { "Ice" }, moves = { "Icicle Crash", "Fire Fang", "Headbutt" }, model_GUID = "d9be07" },
      { name = "Lapras", level = 6, types = { "Water", "Ice" }, moves = { "Ice Beam", "Surf", "Sing" }, model_GUID = "ae0d8f", custom_scale=0.8, offset={x=0, y=0.2, z=-0.1} } }
  },
  {
    guid = "889940",
    trainerName = "Gordie",
    gen = 8,
    gymTier = 6,
    pokemon = {
      { name = "Stonjourner", level = 5, types = { "Rock" }, moves = { "Stealth Rock", "Body Slam", "Rock Tomb" }, model_GUID = "317554" },
      { name = "Coalossal", level = 5, types = { "Rock", "Fire" }, moves = { "Rock Blast", "Heat Crash", "Rock Tomb" }, model_GUID = "e7e32a" } }
  },
  {
    guid = "519731",
    trainerName = "Piers",
    gen = 8,
    gymTier = 7,
    pokemon = {
      { name = "Skuntank", level = 7, types = { "Poison", "Dark" }, moves = { "Screech", "Sucker Punch", "Snarl" }, model_GUID = "142926" },
      { name = "Obstagoon", level = 7, types = { "Dark", "Normal" }, moves = { "Counter", "Shadow Claw", "Throat Chop" }, model_GUID = "89cdcd" } }
  },
  {
    guid = "1752ad",
    trainerName = "Raihan",
    gen = 8,
    gymTier = 8,
    pokemon = {
      { name = "Sandaconda", level = 8, types = { "Ground" }, moves = { "Protect", "Fire Fang", "Earth Power" }, model_GUID = "d15ad0"},
      { name = "Duraludon", level = 8, types = { "Steel", "Dragon" }, moves = { "Stone Edge", "Iron Head", "Breaking Swipe" }, model_GUID = "397452" } }
  },

  -- Elite Four
  {
    guid = "5c28d7",
    trainerName = "Hop",
    gen = 8,
    gymTier = 9,
    pokemon = {
      { name = "Corviknight", level = 9, types = { "Flying", "Steel" }, moves = { "Light Screen", "Steel Wing", "Drill Peck" }, model_GUID = "1515e6" },
      { name = "Crowned Sword Zacian", level = 10, types = { "Fairy", "Steel" }, moves = { "Swords Dance", "Behemoth Bash", "Play Rough" }, model_GUID = "6dccb4", custom_scale=0.6 } }
  },
  {
    guid = "cb76dc",
    trainerName = "Marnie",
    gen = 8,
    gymTier = 9,
    pokemon = {
      { name = "Morpeko",  level = 9, types = { "Electric" }, moves = { "Seed Bomb", "Bite", "Aura Wheel Electric" }, model_GUID = "6393df" },
      { name = "Grimmsnarl", level = 10, types = { "Dark", "Fairy" }, moves = { "Spirit Break", "Darkest Lariat", "Play Rough" }, model_GUID = "3db539" } }
  },
  {
    guid = "6af720",
    trainerName = "Hop",
    gen = 8,
    gymTier = 9,
    pokemon = {
      { name = "Dubwool", level = 9, types = { "Normal" }, moves = { "Zen Headbutt", "Headbutt", "Double-Edge" }, model_GUID = "d79f30" },
      { name = "Crowned Shield Zamazenta", level = 10, types = { "Fighting", "Steel" }, moves = { "Iron Defense", "Behemoth Bash", "Close Combat" }, model_GUID = "37f3aa", custom_scale=0.6 } }
  },
  {
    guid = "7ed3ee",
    trainerName = "Bede",
    gen = 8,
    gymTier = 9,
    pokemon = {
      { name = "Galarian Rapidash", level = 9, types = { "Psychic", "Fairy" }, moves = { "Smart Strike", "Zen Headbutt", "Dazzling Gleam" }, model_GUID = "725893", custom_scale=0.7 },
      { name = "Hatterene",  level = 10, types = { "Psychic" }, moves = { "Dark Pulse", "Psychic", "Dazzling Gleam" }, model_GUID = "9ac795" } }
  },

  -- Champion
  {
    guid = "cf8621",
    trainerName = "Leon",
    gen = 8,
    gymTier = 10,
    pokemon = {
      { name = "Cinderace", level = 10, types = { "Fire" }, moves = { "Bounce", "Flame Charge", "Pyro Ball" }, model_GUID = "edbb96" },
      { name = "Blade Aegislash", level = 11, types = { "Steel", "Ghost" }, moves = { "Sacred Sword", "Shadow Ball", "Flash Cannon" }, model_GUID = "a6b120", spawn_effect="Blade Stance" } }
  },
  {
    guid = "cbea60",
    trainerName = "Leon",
    gen = 8,
    gymTier = 10,
    pokemon = {
      { name = "Rillaboom", level = 10, types = { "Grass" }, moves = { "Knock Off", "Razor Leaf", "Drum Beating" }, model_GUID = "2a352f" },
      { name = "Dragapult", level = 11, types = { "Dragon", "Ghost" }, moves = { "Dragon Darts", "Shadow Ball", "Dragon Breath" }, model_GUID = "1f4890" } }
  },
  {
    guid = "f0b4c9",
    trainerName = "Leon",
    gen = 8,
    gymTier = 10,
    pokemon = {
      { name = "Inteleon", level = 10, types = { "Water" }, moves = { "Tearful Look", "Liquidation", "Snipe Shot" }, model_GUID = "289431" },
      { name = "Charizard", level = 11, types = { "Fire", "Flying" }, moves = { "Ancient Power", "Air Slash", "Fire Blast" }, model_GUID = "27261b", spawn_effect="Status Attack" } }
  },

  -- Gen IX
  -- Gym Leaders
  {
    guid = "45dc59",
    trainerName = "Katy",
    gen = 9,
    gymTier = 1,
    pokemon = {
      { name = "Tarountula",level = 2, types = { "Bug" }, moves = { "Tackle", "Assurance", "Bug Bite" }, model_GUID = "98fc19" },
      { name = "Teddiursa", level = 2, types = { "Bug", "Normal" }, moves = { "Scratch", "Fury Swipes", "Fury Cutter" }, model_GUID = "729770" } }
  },
  {
    guid = "ad920b",
    trainerName = "Brassius",
    gen = 9,
    gymTier = 2,
    pokemon = {
      { name = "Smoliv",  level = 3, types = { "Grass", "Normal" },            moves = { "Tackle", "Growth", "Razor Leaf" }, model_GUID = "369e79" },
      { name = "Sudowoodo", level = 3, types = { "Grass", "Rock" }, moves = { "Counter", "Rock Throw", "Trailblaze" }, model_GUID = "b0f59f", spawn_effect="Physical Attack" } }
  },
  {
    guid = "7875a3",
    trainerName = "Iono",
    gen = 9,
    gymTier = 3,
    pokemon = {
      { name = "Bellibolt", level = 3, types = { "Electric" },  moves = { "Water Gun", "Mud-Slap", "Spark" }, model_GUID = "7753e7" },
      { name = "Mismagius",  level = 4, types = { "Electric", "Ghost" }, moves = { "Confuse Ray", "Hex", "Spark" }, model_GUID = "a81efd", spawn_effect="Physical Attack" } }
  },
  {
    guid = "68208c",
    trainerName = "Kofu",
    gen = 9,
    gymTier = 4,
    pokemon = {
      { name = "Wugtrio", level = 4, types = { "Water" }, moves = { "Headbutt", "Mud-Slap", "Water Pulse" }, model_GUID = "d1417a", offset={x=0, y=0.5, z=0} },
      { name = "Crabominable",  level = 4, types = { "Water" }, moves = { "Slam", "Rock Smash", "Crabhammer" }, model_GUID = "bd1445" } }
  },
  {
    guid = "51d9fc",
    trainerName = "Larry",
    gen = 9,
    gymTier = 5,
    pokemon = {
      { name = "Dudunsparce",  level = 5, types = { "Normal" },          moves = { "Glare", "Drill Run", "Hyper Drill" }, model_GUID = "881817", offset={x=0, y=0.08, z=0} },
      { name = "Staraptor", level = 6, types = { "Normal", "Flying" }, moves = { "Close Combat", "Aerial Ace", "Facade" }, model_GUID = "88b32f" } }
  },
  {
    guid = "e99877",
    trainerName = "Ryme",
    gen = 9,
    gymTier = 6,
    pokemon = {
      { name = "Houndstone", level = 5, types = { "Ghost" }, moves = { "Play Rough", "Crunch", "Phantom Force" }, model_GUID = "b41299"  },
      { name = "Toxtricity",   level = 6, types = { "Ghost", "Electric" },   moves = { "Hyper Voice", "Discharge", "Hex" }, model_GUID = "4d9bff" } }
  },
  {
    guid = "8a4bc5",
    trainerName = "Tulip",
    gen = 9,
    gymTier = 7,
    pokemon = {
      { name = "Farigiraf",   level = 7, types = { "Normal", "Psychic" },  moves = { "Stomp", "Zen Headbutt", "Crunch" }, model_GUID = "6135b5" },
      { name = "Florges", level = 7, types = { "Psychic" }, moves = { "Moonblast", "Psychic", "Petal Blizzard" }, model_GUID = "b2407e", spawn_effect="Physical Attack" } }
  },
  {
    guid = "808b43",
    trainerName = "Grusha",
    gen = 9,
    gymTier = 8,
    pokemon = {
      { name = "Cetitan", level = 8, types = { "Ice" },   moves = { "Double-Edge", "Liquidation", "Ice Shard" }, model_GUID = "0196c4", custom_scale=0.5 },
      { name = "Altaria",   level = 8, types = { "Ice" }, moves = { "Dragon Pulse", "Hurricane", "Ice Beam" }, model_GUID = "9a2210" } }
  },

  -- Elite Four + champion
  {
    guid = "47ed30",
    trainerName = "Larry",
    gen = 9,
    gymTier = 9,
    pokemon = {
      { name = "Tropius", level = 9, types = { "Grass", "Flying" },    moves = { "Dragon Pulse", "Solar Beam", "Air Slash" }, model_GUID = "bdb162"  },
      { name = "Flamigo", level = 10, types = { "Flying", "Fighting" }, moves = { "Liquidation", "Close Combat", "Brave Bird" }, model_GUID = "576665" } }
  },
  {
    guid = "7b612c",
    trainerName = "Hassel",
    gen = 9,
    gymTier = 9,
    pokemon = {
      { name = "Flapple",     level = 9, types = { "Grass", "Dragon" }, moves = { "Seed Bomb", "Dragon Rush", "Aerial Ace" }, model_GUID = "c9aba6"  },
      { name = "Baxcalibur", level = 10, types = { "Dragon", "Ice" },     moves = { "Brick Break", "Glaive Rush", "Icicle Crash" }, model_GUID = "f78096" } }
  },
  {
    guid = "e625ec",
    trainerName = "Rika",
    gen = 9,
    gymTier = 9,
    pokemon = {
      { name = "Camerupt", level = 9, types = { "Fire", "Ground" }, moves = { "Flash Cannon", "Earth Power", "Fire Blast" }, model_GUID = "f266b1", spawn_effect="Physical Attack", custom_scale=0.6, offset={x=0, y=0, z=-0.1} },
      { name = "Clodsire",   level = 10, types = { "Ground", "Poison" }, moves = { "Protect", "Earthquake", "Poison Jab" }, model_GUID = "2263bf" } }
  },
  {
    guid = "49c164",
    trainerName = "Poppy",
    gen = 9,
    gymTier = 9,
    pokemon = {
      { name = "Corviknight",  level = 9, types = { "Flying", "Steel" },         moves = { "Body Press", "Iron Head", "Brave Bird" }, model_GUID = "1515e6"  },
      { name = "Tinkaton", level = 10, types = { "Steel", "Fairy" }, moves = { "Play Rough", "Gigaton Hammer", "Stone Edge" }, model_GUID = "3e73d2" } }
  },
  {
    guid = "d2e704",
    trainerName = "Geeta",
    gen = 9,
    gymTier = 10,
    pokemon = {
      { name = "Avalugg", level = 10,  types = { "Ice" }, moves = { "Earthquake", "Crunch", "Avalanche" }, model_GUID = "fc938c", spawn_effect="Status Attack", custom_scale=0.5 },
      { name = "Veluza", level = 11, types = { "Water", "Psychic" },   moves = { "Psycho Cut", "Liquidation", "Ice Fang" }, model_GUID = "585814" } }
  },
  {
    guid = "971eca",
    trainerName = "Geeta",
    gen = 9,
    gymTier = 10,
    pokemon = {
      { name = "Gogoat",  level = 10,  types = { "Grass" }, moves = { "Zen Headbutt", "Bulk Up", "Horn Leech" }, model_GUID = "88d0b0", spawn_effect="Status Attack" },
      { name = "Kingambit", level = 11, types = { "Dark", "Steel" }, moves = { "Stone Edge", "Kowtow Cleave", "Iron Head" }, model_GUID = "291920" } }
  },
  {
    guid = "275bc9",
    trainerName = "Geeta",
    gen = 9,
    gymTier = 10,
    pokemon = {
      { name = "Espathra",  level = 10,  types = { "Psychic" },  moves = { "Lumina Crash", "Dazzling Gleam", "Feather Dance" }, model_GUID = "e2c2ec" },
      { name = "Glimmora", level = 11, types = { "Rock", "Poison" }, moves = { "Tera Blast", "Sludge Wave", "Earth Power" }, model_GUID = "53b746"  } }
  },
}

typeData =
{
  { name = "Bug",      effective = { "Grass", "Psychic", "Dark" },                    weak = { "Fire", "Flying", "Fighting", "Poison", "Ghost", "Fairy", "Steel" } },
  { name = "Dark",     effective = { "Ghost", "Psychic" },                            weak = { "Fighting", "Dark", "Fairy" } },
  { name = "Dragon",   effective = { "Dragon" },                                      weak = { "Steel", "Fairy" } },
  { name = "Electric", effective = { "Water", "Flying" },                             weak = { "Electric", "Grass", "Dragon", "Ground" } },
  { name = "Fairy",    effective = { "Fighting", "Dragon", "Dark" },                  weak = { "Fire", "Poison", "Steel" } },
  { name = "Fighting", effective = { "Normal", "Rock", "Ice", "Dark", "Steel" },      weak = { "Flying", "Poison", "Psychic", "Fairy", "Bug", "Ghost" } },
  { name = "Fire",     effective = { "Grass", "Bug", "Ice", "Steel" },                weak = { "Water", "Fire", "Rock", "Dragon" } },
  { name = "Flying",   effective = { "Grass", "Fighting", "Bug" },                    weak = { "Rock", "Electric", "Steel" } },
  { name = "Ghost",    effective = { "Ghost", "Psychic" },                            weak = { "Dark", "Normal" } },
  { name = "Grass",    effective = { "Water", "Rock", "Ground" },                     weak = { "Grass", "Fire", "Flying", "Bug", "Poison", "Dragon", "Steel" } },
  { name = "Ground",   effective = { "Fire", "Electric", "Rock", "Poison", "Steel" }, weak = { "Grass", "Bug", "Flying" } },
  { name = "Ice",      effective = { "Grass", "Flying", "Ground", "Dragon" },         weak = { "Water", "Fire", "Ice", "Steel" } },
  { name = "Normal",   effective = { "None" },                                        weak = { "Rock", "Steel", "Ghost" } },
  { name = "Poison",   effective = { "Grass", "Fairy" },                              weak = { "Rock", "Ground", "Poison", "Ghost", "Steel" } },
  { name = "Psychic",  effective = { "Fighting", "Poison" },                          weak = { "Psychic", "Steel", "Dark" } },
  { name = "Rock",     effective = { "Fire", "Flying", "Ice", "Bug" },                weak = { "Fighting", "Ground", "Steel" } },
  { name = "Steel",    effective = { "Ice", "Rock", "Fairy" },                        weak = { "Fire", "Water", "Electric", "Steel" } },
  { name = "Water",    effective = { "Fire", "Rock", "Ground" },                      weak = { "Water", "Grass", "Dragon" } },
}

tmData =
{
  { guid = "8de2c7", move = "Acid Spray" },
  { guid = "359a56", move = "Aerial Ace" },
  { guid = "763873", move = "Agility" },
  { guid = "c5e5b1", move = "Air Cutter" },
  { guid = "cac1d9", move = "Air Slash" },
  { guid = "763873", move = "Amnesia" },
  { guid = "663b5b", move = "Assurance" },
  { guid = "5b8981", move = "Attract" },
  { guid = "3137ca", move = "Aurora Veil" },
  { guid = "763873", move = "Aura Sphere" },
  { guid = "4ce536", move = "Avalanche" },
  { guid = "de0ff6", move = "Beat Up" },
  { guid = "c10f9c", move = "Blast Burn" },
  { guid = "b14290", move = "Blizzard" },
  { guid = "763873", move = "Body Press" },
  { guid = "2c5a57", move = "Body Slam" },
  { guid = "58cfee", move = "Bounce" },
  { guid = "8193c8", move = "Breaking Swipe" },
  { guid = "4cae29", move = "Brick Break" },
  { guid = "007ba3", move = "Brine" },
  { guid = "5efc53", move = "Brutal Swing" },
  { guid = "8d42fb", move = "Bubble Beam" },
  { guid = "625682", move = "Bullet Seed" },
  { guid = "a1d00f", move = "Bulk Up" },
  { guid = "e07f28", move = "Bulldoze" },
  { guid = "c0dd30", move = "Calm Mind" },
  { guid = "213749", move = "Captivate" },
  { guid = "22ddea", move = "Charge Beam" },
  { guid = "ecea32", move = "Charm" },
  { guid = "073dcd", move = "Chilling Water" },
  { guid = "74ec32", move = "Confide" },
  { guid = "13adc5", move = "Confuse Ray" },
  { guid = "19d648", move = "Counter" },
  { guid = "01fa85", move = "Cross Poison" },
  { guid = "763873", move = "Crunch" },
  { guid = "e8c19b", move = "Curse" },
  { guid = "f3d9d3", move = "Dark Pulse" },
  { guid = "e6484b", move = "Dazzling Gleam" },
  { guid = "ab2880", move = "Defense Curl" },
  { guid = "6552cc", move = "Detect" },
  { guid = "dc1ec9", move = "Dig" },
  { guid = "a15890", move = "Disarming Voice" },
  { guid = "52cd29", move = "Dive" },
  { guid = "432c9f", move = "Double-Edge" },
  { guid = "8e37c5", move = "Double Team" },
  { guid = "ebda3e", move = "Dragon Breath" },
  { guid = "c51f03", move = "Dragon Claw" },
  { guid = "0af6c5", move = "Dragon Dance" },
  { guid = "cd5bed", move = "Dragon Pulse" },
  { guid = "beb448", move = "Dragon Rage" },
  { guid = "4262e9", move = "Dragon Tail" },
  { guid = "05b3a2", move = "Draining Kiss" },
  { guid = "334b5d", move = "Dream Eater" },
  { guid = "697ad0", move = "Drill Run" },
  { guid = "1c8a4f", move = "Dynamic Punch" },
  { guid = "aef1c4", move = "Earthquake" },
  { guid = "dd1385", move = "Earth Power" },
  { guid = "1eecf5", move = "Echoed Voice" },
  { guid = "066471", move = "Eerie Impulse" },
  { guid = "79d579", move = "Egg Bomb" },
  { guid = "74c286", move = "Electroweb" },
  { guid = "4a4fc8", move = "Electric Terrain" },
  { guid = "749063", move = "Embargo" },
  { guid = "763873", move = "Encore" },
  { guid = "5548eb", move = "Energy Ball" },
  { guid = "4b23da", move = "Explosion" },
  { guid = "a37980", move = "Facade" },
  { guid = "56d9ff", move = "False Swipe" },
  { guid = "56d854", move = "Fake Tears" },
  { guid = "5675db", move = "Fissure" },
  { guid = "db2e5f", move = "Fire Blast" },
  { guid = "d944b4", move = "Fire Fang" },
  { guid = "20e23a", move = "Fire Pledge" },
  { guid = "799228", move = "Fire Punch" },
  { guid = "e1acc4", move = "Fire Spin" },
  { guid = "0f9ebe", move = "Flamethrower" },
  { guid = "ae9bcf", move = "Flame Charge" },
  { guid = "0ef51d", move = "Flash Cannon" },
  { guid = "47e2a7", move = "Fly" },
  { guid = "ca87d5", move = "Focus Blast" },
  { guid = "763873", move = "Foul Play" }, 
  { guid = "b9d5e3", move = "Frenzy Plant" },
  { guid = "6d819c", move = "Frost Breath" },
  { guid = "9b4dac", move = "Fury Cutter" },
  { guid = "763873", move = "Hail" }, 
  { guid = "ecf747", move = "Hex" },
  { guid = "5cb879", move = "Hyper Voice" },
  { guid = "e8b6dd", move = "Giga Drain" },
  { guid = "ab0c34", move = "Giga Impact" },
  { guid = "078f19", move = "Grassy Terrain" },
  { guid = "94c66f", move = "Grass Pledge" },
  { guid = "763873", move = "Gunk Shot" },
  { guid = "8bf926", move = "Headbutt" },
  { guid = "10b389", move = "Heat Wave" },
  { guid = "a6457a", move = "Hidden Power" },
  { guid = "80318f", move = "Hone Claws" },
  { guid = "6b27ce", move = "Horn Drill" },
  { guid = "763873", move = "Hurricane" },
  { guid = "763873", move = "Hydro Cannon" },
  { guid = "d9e8d9", move = "Hydro Pump" },
  { guid = "c5cc62", move = "Hyper Beam" },
  { guid = "567f75", move = "Ice Beam" },
  { guid = "3a115c", move = "Ice Fang" },
  { guid = "b80e18", move = "Ice Punch" },
  { guid = "4b694b", move = "Ice Spinner" },
  { guid = "cbce2e", move = "Icicle Spear" },
  { guid = "2f1c01", move = "Icy Wind" },
  { guid = "0ed62f", move = "Incinerate" },
  { guid = "774e67", move = "Infestation" },
  { guid = "e7c1c1", move = "Iron Defense" },
  { guid = "763873", move = "Iron Head" },
  { guid = "b54b26", move = "Iron Tail" },
  { guid = "5af05d", move = "Leaf Storm" },
  { guid = "f3b232", move = "Leech Life" },
  { guid = "0c0649", move = "Light Screen" },
  { guid = "df3243", move = "Liquidation" },
  { guid = "123723", move = "Low Kick" },
  { guid = "820caf", move = "Magic Room" },
  { guid = "03db6b", move = "Magical Leaf" },
  { guid = "a7d409", move = "Mega Drain" },
  { guid = "050288", move = "Mega Kick" },
  { guid = "af04d1", move = "Mega Punch" },
  { guid = "e51eda", move = "Metal Claw" },
  { guid = "9ac97b", move = "Metronome" },
  { guid = "389d60", move = "Mimic" },
  { guid = "3e07ab", move = "Misty Terrain" },
  { guid = "34ede1", move = "Mystical Fire" },
  { guid = "171693", move = "Mud-Slap" },
  { guid = "0b486a", move = "Mud Shot" },
  { guid = "a30baa", move = "Nature Power" },
  { guid = "763873", move = "Nasty Plot" },
  { guid = "763873", move = "Night Shade" },
  { guid = "2f1546", move = "Overheat" },
  { guid = "db7734", move = "Outrage" },
  { guid = "8cf6af", move = "Payback" },
  { guid = "04de91", move = "Pay Day" },
  { guid = "7461da", move = "Phantom Force" },
  { guid = "87c48d", move = "Pin Missile" },
  { guid = "2b502a", move = "Play Rough" },
  { guid = "3c8504", move = "Poison Jab" },
  { guid = "763873", move = "Poison Tail" },
  { guid = "f40303", move = "Pollen Puff" },
  { guid = "43ddaf", move = "Pounce" },
  { guid = "42e6b8", move = "Power Gem" },
  { guid = "b8803b", move = "Power-Up Punch" },
  { guid = "5973af", move = "Protect" },
  { guid = "763873", move = "Psybeam" },
  { guid = "4f7429", move = "Psychic" },
  { guid = "facbad", move = "Psychic Fangs" },
  { guid = "22bf1c", move = "Psychic Terrain" },
  { guid = "43b2c8", move = "Psycho Cut" },
  { guid = "ab8c87", move = "Psyshock" },
  { guid = "4c00f2", move = "Psywave" },
  { guid = "3cc223", move = "Rage" },
  { guid = "9b2eda", move = "Rain Dance" },
  { guid = "f7d637", move = "Razor Shell" },
  { guid = "be7b78", move = "Razor Wind" },
  { guid = "ffbce4", move = "Reflect" },
  { guid = "7e9799", move = "Retaliate" },
  { guid = "ff46ea", move = "Revenge" },
  { guid = "a1c9d5", move = "Roar" },
  { guid = "dd7d89", move = "Rock Blast" },
  { guid = "147ed3", move = "Rock Polish" },
  { guid = "d50326", move = "Rock Slide" },
  { guid = "0d7012", move = "Rock Smash" },
  { guid = "f8df98", move = "Rock Tomb" },
  { guid = "8ca146", move = "Safeguard" },
  { guid = "b174ff", move = "Sandstorm" },
  { guid = "1364aa", move = "Sand Tomb" },
  { guid = "e91a02", move = "Screech" },
  { guid = "89e169", move = "Secret Power" },
  { guid = "04f3ed", move = "Seed Bomb" },
  { guid = "3803de", move = "Seismic Toss" },
  { guid = "c294b2", move = "Self-Destruct" },
  { guid = "4e39c9", move = "Shock Wave" },
  { guid = "2f2fe7", move = "Shadow Ball" },
  { guid = "49d86e", move = "Shadow Claw" },
  { guid = "7b7ff4", move = "Silver Wind" },
  { guid = "9e3ae7", move = "Skull Bash" },
  { guid = "c9a50a", move = "Sky Attack" },
  { guid = "6452f8", move = "Sludge Bomb" },
  { guid = "9ba85b", move = "Sludge Wave" },
  { guid = "42459d", move = "Smart Strike" },
  { guid = "07a4c9", move = "Snarl" },
  { guid = "435fa1", move = "Snatch" },
  { guid = "789ef1", move = "Snore" },
  { guid = "71259c", move = "Snowscape" },
  { guid = "239858", move = "Solar Beam" },
  { guid = "866c7d", move = "Solar Blade" },
  { guid = "785c67", move = "Spikes" },
  { guid = "1699b4", move = "Stealth Rock" },
  { guid = "fd548b", move = "Steel Wing" },
  { guid = "e64f8f", move = "Stone Edge" },
  { guid = "106126", move = "Struggle Bug" },
  { guid = "d62534", move = "Submission" },
  { guid = "2f1ebc", move = "Sunny Day" },
  { guid = "8dc919", move = "Surf" },
  { guid = "eec7d0", move = "Swagger" },
  { guid = "1761ff", move = "Swift" },
  { guid = "ec0f9a", move = "Swords Dance" },
  { guid = "628b23", move = "Take Down" },
  { guid = "079609", move = "Tail Slap" },
  { guid = "e3d82f", move = "Taunt" },
  { guid = "1eed1b", move = "Teleport" },
  { guid = "999325", move = "Thief" },
  { guid = "c11fbb", move = "Thunder" },
  { guid = "522cd1", move = "Thunder Fang" },
  { guid = "ca860c", move = "Thunderbolt" },
  { guid = "e66c72", move = "Thunder Punch" },
  { guid = "dc297a", move = "Thunder Wave" },
  { guid = "287692", move = "Torment" },
  { guid = "55cdb2", move = "Toxic" },
  { guid = "fc61a7", move = "Toxic Spikes" },
  { guid = "763873", move = "Trailblaze" },
  { guid = "626cd3", move = "Tri Attack" },
  { guid = "a6d090", move = "Trick" },
  { guid = "691223", move = "U-Turn" },
  { guid = "09e4f5", move = "Venoshock" },
  { guid = "f08d89", move = "Volt Switch" },
  { guid = "775387", move = "Waterfall" },
  { guid = "f2eb34", move = "Water Gun" },
  { guid = "763873", move = "Water Pledge" },
  { guid = "1d4fed", move = "Water Pulse" },
  { guid = "347909", move = "Whirlpool" },
  { guid = "910668", move = "Whirlwind" },
  { guid = "1aeabe", move = "Wild Charge" },
  { guid = "c721a5", move = "Will-O-Wisp" },
  { guid = "370c4f", move = "Work Up" },
  { guid = "60616e", move = "X-Scissor" },
  { guid = "0a6b86", move = "Zap Cannon" },
  { guid = "054c77", move = "Zen Headbutt" },
}

zCrystalData =
{
  { guid = "2c591c", move = "Gigavolt Havoc",           overrides = {{ guids = { "a17986", "e5c82a" }, move = "Catastropika" }, 
                                                                     { guids = { "77331c", "d7835d" }, move = "10MV Thunderbolt" },
                                                                     { guids = { "65a373", "1e53ce", "ef1a51" }, move = "Stoked Sparksurfer" }}
  },
  { guid = "337c73", move = "Supersonic Skystrike" },
  { guid = "474469", move = "Savage Spin-Out" },
  { guid = "9da33f", move = "Black Hole Eclipse",       overrides = {{ guids = { "3f1566", "38e353", "45ba93" }, move = "Malicious Moonsault" } } },
  { guid = "a5f921", move = "Devastating Drake",        overrides = {{ guids = { "51cc27", "6377a7", "79e0d1" }, move = "Clangorous Soulblaze" } } },
  { guid = "b0ba3a", move = "Never-Ending Nightmare",   overrides = {{ guids = { "d50f86", "2416c8", "9bef15" }, move = "Sinister Arrow Raid" }, 
                                                                     { guids = { "8e8527" }, move = "Soul-Stealing 7* Strike" },
                                                                     { guids = { "d118b4", "2c0206" }, move = "Menacing Moonraze Maelstrom" }}
  },
  { guid = "88875f", move = "Bloom Doom" },
  { guid = "ca8a3a", move = "Tectonic Rage" },
  { guid = "21a039", move = "Twinkle Tackle",           overrides = {{ guids = { "ba3859" }, move = "Let's Snuggle Forever" }, 
                                                                     { guids = { "c5bd66", "c2d946", "d099d1", "573f6c" }, move = "Guardian of Alola" }}
  },
  { guid = "bbbb45", move = "Shattered Psyche",         overrides = {{ guids = { "d68dfc" }, move = "Genesis Supernova" }, 
                                                                     { guids = { "ec14da", "c65377", "d63d82", "6366eb", "2f92e5", "b01111", "1bdda7", "370a4c" }, move = "Light That Burns The Sky" }}
  },
  { guid = "130d52", move = "Breakneck Blitz",          overrides = {{ guids = { "690870" }, move = "Extreme Evoboost" }, 
                                                                     { guids = { "81f09a", "a017f9" }, move = "Pulverizing Pancake" }}
  },
  { guid = "84dde0", move = "Acid Downpour" },
  { guid = "6a40b4", move = "Subzero Slammer" },
  { guid = "bac4e8", move = "Hydro Vortex",             overrides = {{ guids = { "de4d6a", "d62cf2", "4026a1" }, move = "Oceanic Operetta" } } },
  { guid = "3987a4", move = "Corkscrew Crash",          overrides = {{ guids = { "2337ba", "5228d9" }, move = "Searing Sunraze Smash" } } },
  { guid = "9fc23f", move = "Inferno Overdrive" },
  { guid = "f18fd0", move = "All-Out Pummeling" },
  { guid = "7bbd40", move = "Continental Crush",        overrides = {{ guids = { "34164a", "802af7", "9ecf49", "5411a7", "9af49a", "ff8dda" }, move = "Splintered Stormshards" } } }
}

teraData =
{
  { guid = "e80e03", type = "Steel" },
  { guid = "0af6a7", type = "Water" },
  { guid = "000c14", type = "Rock" },
  { guid = "49d049", type = "Psychic" },
  { guid = "56d218", type = "Poison" },
  { guid = "040852", type = "Normal" },
  { guid = "9ba842", type = "Ice" },
  { guid = "967424", type = "Ground" },
  { guid = "75d7d9", type = "Grass" },
  { guid = "456160", type = "Ghost" },
  { guid = "11194a", type = "Flying" },
  { guid = "8863f0", type = "Fire" },
  { guid = "f53d3e", type = "Fighting" },
  { guid = "5eefbb", type = "Fairy" },
  { guid = "ff493b", type = "Electric" },
  { guid = "acf70e", type = "Dragon" },
  { guid = "27f2e3", type = "Dark" },
  { guid = "3bd105", type = "Bug" },
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  CAMERA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function showArena(obj, color)
  Player[color].lookAt({
    position = { x = -34.89, y = 0.96, z = 0.7 },
    pitch    = 90,
    yaw      = 0,
    distance = 20,
  })
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  DATA GETTERS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GetPokemonDataByGUID(params)
  if not params.guid then return nil end

  local data
  for i = 1, #selectedGens do
    if selectedGens[i] then
      data = getPokemonData(genData[i], params.guid)
      if data != nil then
        return data
      end
    end
  end

  -- Check custom Pokemon.
  if customGen then
    data = getPokemonData(customPokemonData, params.guid)
    if data != nil then
      return data
    end
  end
  
  -- Check the board Pokemon.
  data = getPokemonData(boardPokemonData, params.guid)
  if data != nil then
    return data
  end

  -- Check the fossil Pokemon.
  data = getPokemonData(fossilPokeballPokemonData, params.guid)
  if data != nil then
    return data
  end
end

function GetAnyPokemonDataByGUID(params)
  for i = 1, #selectedGens do
    local data = getPokemonData(genData[i], params.guid)
    if data != nil then
      return data
    end
  end
  if customGen then
    data = getPokemonData(customPokemonData, params.guid)
    if data != nil then
      return data
    end
  end
  
  -- Check the board Pokemon.
  data = getPokemonData(boardPokemonData, params.guid)
  if data != nil then
    return data
  end

  -- Check the fossil Pokemon.
  data = getPokemonData(fossilPokeballPokemonData, params.guid)
  if data != nil then
    return data
  end
end

function GetPokemonDataByName(params)
  local data
  for i = 1, #selectedGens do
    if selectedGens[i] then
      data = getPokemonDataName(genData[i], params.name)
      if data != nil then
        return data
      end
    end
  end
  if customGen then
    data = getPokemonDataName(customPokemonData, params.guid)
    if data != nil then
      return data
    end
  end

  -- Check the board Pokemon.
  data = getPokemonDataName(boardPokemonData, params.guid)
  if data != nil then
    return data
  end
  
  -- Check the fossil Pokemon.
  data = getPokemonData(fossilPokeballPokemonData, params.guid)
  if data != nil then
    return data
  end
  print("No Pokémon Data Found")
end

function getPokemonData(pokemonList, guid)
  for i = 1, #pokemonList do
    local data = pokemonList[i]
    local guids = data.guids
    for j = 1, #guids do
      if guids[j] == guid then
        return data
      end
    end
  end
  return nil
end

function getPokemonDataName(pokemonList, name)
  for i = 1, #pokemonList do
    local data = pokemonList[i]
    local names = data.name
    if names == name then
      return data
    end
  end
  return nil
end

function GetTypeDataByName(name)
  for i = 1, #typeData do
    local data = typeData[i]
    local typeName = data.name
    if typeName == name then
      return data
    end
  end
end

function GetTypeDataByGUID(params)
  for abcde = 1, #typeData do
    local data = typeData[abcde]
    local guids2 = data.guids
    for efghj = 1, #guids2 do
      if guids2[efghj] == params.guid then
        return data
      end
    end
  end
end

function GetGymDataByGUID(params)
  for i = 1, #gymData do
    local data = gymData[i]
    if data.guid == params.guid then
      return data
    end
  end

  -- If we get here, we didn't find the gym leader. Maybe is is custom? <.<
  -- TODO: check if customs are enabled.
  for i = 1, #customGymData do
    local data = customGymData[i]
    if data.guid == params.guid then
      return data
    end
  end

  print("Unable to find GymData for GUID: " .. tostring(params.guid))
  return {}
end

function GetRivalDataByRegion(region)
  for i = 1, #rivalData do
    local tempRivalData = rivalData[i]
    if tempRivalData.region == region then
      return tempRivalData
    end
  end
end

function GetRivalPokemonDataByGuid(guid)
  for i = 1, #rivalData do
    local tempRivalData = rivalData[i]
    for pokemonLevel = 1, #tempRivalData.pokemonData do
      if tempRivalData.pokemonData[pokemonLevel].guid == guid then
        return tempRivalData.pokemonData[pokemonLevel]
      end
    end
  end
end

function GetMoveDataByName(name)
  for i = 1, #moveData do
    local data = moveData[i]
    local moveName = data.name
    if moveName == name then
      return data
    end
  end

  -- If we get here, we didn't find the move data. Maybe is is custom? <.<
  for i = 1, #customMoveData do
    local data = customMoveData[i]
    local moveName = data.name
    if data.name == name then
      return data
    end
  end

  print("Unable to find move data for: " .. tostring(name))
  return {}
end

function GetMoveDataByGUID(params)
  for abcdefg = 1, #moveData do
    local data = moveData[abcdefg]
    local guids4 = data.guids
    for index = 1, #guids4 do
      if guids4[index] == params.guid then
        return data
      end
    end
  end
end

function GetTmDataByGUID(tmGuid)
  for i = 1, #tmData do
    local data = tmData[i]
    local guid = data.guid
    if guid == tmGuid then
      return data
    end
  end
  return nil
end

function GetZCrystalDataByGUID(params)
  for zCrystalIndex = 1, #zCrystalData do
    local data = zCrystalData[zCrystalIndex]
    local guid = data.guid
    if guid == params.zCrystalGuid then
      -- Check against override data, if present.
      if data.overrides ~= nil and params.pokemonGuid ~= nil then
        for overrideIndex = 1, #data.overrides do
          local override = data.overrides[overrideIndex]
          for guidIndex = 1, #override.guids do
            if override.guids[guidIndex] == params.pokemonGuid then
              local displayName = string.sub(override.move, 1, 15)
              if displayName != override.move then
                displayName = displayName .. ".."
              end
              return { guid = data.guid, move = override.move, displayName = displayName }
            end
          end
        end
      end

      -- Return whatever data we found since there were no overrides. Format the move name. 
      -- Anything above 17 characters need to be formatted.
      local displayName = string.sub(data.move, 1, 15)
      if displayName != data.move then
        displayName = displayName .. ".."
      end
      return { guid = data.guid, move = data.move, displayName = displayName }
    end
  end
  return nil
end

function GetTeraDataByGUID(teraGuid)
  for i = 1, #teraData do
    local data = teraData[i]
    local guid = data.guid
    if guid == teraGuid then
      return data
    end
  end
  return nil
end

function GetSelectedGens()
  return selectedGens
end

function GetAIDifficulty()
  return aiDifficulty
end

-- Shallow-copy a table. If our gym data gets more complicated (nested tables, etc.) we will need a
-- deep copy instead.
function ShallowCopy(orig_table)
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

-- Function to filter gym data on the "gen" and "gymTier" attribute. If you call this on 
-- gym data without the gen and gymTier attributes the return table will just be an empty {}.
function FilterGymDataOnTier(gen, tier, use_backup)
  if gymData == nil then return {} end

  -- First check if we are looking for a custom gym leader.
  if gen == "custom" then
    local new_index = 1
    local temp_arr = ShallowCopy(customGymData)
    local size_orig = #temp_arr
    for old_index, v in ipairs(temp_arr) do
        if v.gen == gen and v.gymTier == tier then
            temp_arr[new_index] = v
            new_index = new_index + 1
        end
    end
    for i = new_index, size_orig do temp_arr[i] = nil end
    if #temp_arr ~= 0 or not use_backup then
      return temp_arr
    end

    -- We didn't find any custom gym leader matching the parameters. Use standard leaders.
    -- This does not consider the selected gens lol.
    gen = math.random(1, 9)
  end

  local new_index = 1
  local temp_arr = ShallowCopy(gymData)
  local size_orig = #temp_arr
  for old_index, v in ipairs(temp_arr) do
      if v.gen == gen and v.gymTier == tier then
          temp_arr[new_index] = v
          new_index = new_index + 1
      end
  end
  for i = new_index, size_orig do temp_arr[i] = nil end
  return temp_arr
end

-- Retrieves a GUID randomly from the list of gym leaders for a gen and tier.
-- tier argument:
--    gyms     : 1-8
--    elite4   : 9
--    champion : 10
--    TR       : 11
function RandomGymGuidOfTier(params)
  if gymData == nil then return 0 end

  local new_list = FilterGymDataOnTier(params.gen, params.tier, true)
  if #new_list > 0 then
    local final_list = {}
    if params.retrievedList ~= nil and #params.retrievedList > 0 then
      for retrievedLeaderIndex=1, #params.retrievedList do
        for gymIndex=1, #new_list do
          if new_list[gymIndex].guid ~= params.retrievedList[retrievedLeaderIndex] then
            table.insert(final_list, new_list[gymIndex])
          end
        end
      end
    else
      return new_list[math.random(#new_list)].guid
    end
    if #final_list > 0 then
      return final_list[math.random(#final_list)].guid
    end

    -- Failed to find the Gym Leader so find a random leader. This occurs when we try 
    -- to grab more customs than are available.
    new_list = FilterGymDataOnTier(math.random(1, 9), params.tier, true)
    if #new_list > 0 then
      return new_list[math.random(#new_list)].guid
    end
  end

  local gymStringTable =
  {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = "Elite 4",
    [10] = "Rival",
    [11] = "Team Rocket",
  }

  local gymString = gymStringTable[params.tier]
  printToAll("Failed to find gym leader options for gen " .. tostring(params.gen) .. ", tier " .. tostring(gymString))
  return 0
end

-- Gets the count of custom leaders available for a tier.
-- tier argument:
--    gyms     : 1-8
--    elite4   : 9
--    champion : 10
--    TR       : 11
function GetCustomLeaderCount(params)
  if gymData == nil then return 0 end

  local new_list = FilterGymDataOnTier(params.gen, params.tier, false)
  local custom_count = #new_list
  if params.retrievedList ~= nil and #params.retrievedList > 0 then
    for retrievedLeaderIndex=1, #params.retrievedList do
      for gymIndex=1, #new_list do
        if new_list[gymIndex].guid == params.retrievedList[retrievedLeaderIndex] then
          custom_count = custom_count - 1
        end
      end
    end
  end
  return custom_count
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  SETUP
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function start(player, value, id)
  MusicPlayer.setPlaylist(route_playlist)
end

function ShowSettingsPopup()
  UI.show('Settings')
end

function closeSettings(player, value, id)
  UI.hide('Settings')
end

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

function onLoad(saved_data)
  -- Get a handle to the models bag object.
  battlemodels = getObjectFromGUID(battlemodels_GUID)
  if battlemodels == nil then
    printToAll("Unable to find Models Pokéball object :(")
  else
    -- Hide the models.
    --battlemodels.interactable = false
    --battlemodels.setLock(true)
    battlemodels.setPosition({-51, 0.5, 76})
  end

  -- Get a handle to the secondary type tokens object.
  local type_tokens_bag = getObjectFromGUID(TYPES_BAG_GUID)
  if type_tokens_bag == nil then
    printToAll("Unable to find Secondary Type Tokens bag object :(")
  else
    -- Hide the models.
    --battlemodels.interactable = false
    --battlemodels.setLock(true)
    type_tokens_bag.setPosition({-48, 0.5, 76})
  end

  -- TEMP | TODO: Apply appropriate tag to all pokemon chips and all models.
  --[[
    1. Spawn in the TEMP TAG POKEBALL
    2. Copy the genXPokeballs and genXEvoPokeballs from StarterPokeball.lua to this file.
    3. Run the following on one list at a time.
    4. Save game.
  ]]
  -- local pokeballs_list = genPokeballs
  -- for pokeball_index=1, #pokeballs_list do
  --   -- Get handle to the home pokeball and temp pokeball.
  --   local home_pokeball = getObjectFromGUID(pokeballs_list[pokeball_index])
  --   local temp_pokeball = getObjectFromGUID("e08c3e")

  --   -- Loop through each item in the pokeball.
  --   for token_index = 1, #home_pokeball.getObjects() do
  --     -- Take object from home pokeball.
  --     local token = home_pokeball.takeObject({})

  --     -- Apply the tag to the Pokemon TOKEN.
  --     token.addTag("Pokemon Token")

  --     -- Put the Pokemon into  into the temp pokeball.
  --     temp_pokeball.putObject(token)
  --   end

  --   -- Now take the object back from the temp pokeball and put them back 
  --   -- into the home pokeball.
  --   for token_index = 1, #temp_pokeball.getObjects() do
  --     home_pokeball.putObject(temp_pokeball.takeObject({}))
  --   end
  -- end

  -- local pokeballs_list = genEvoPokeballs
  -- for pokeball_index=1, #pokeballs_list do
  --   -- Get handle to the home pokeball and temp pokeball.
  --   local home_pokeball = getObjectFromGUID(pokeballs_list[pokeball_index])
  --   local temp_pokeball = getObjectFromGUID("e08c3e")

  --   -- Loop through each item in the pokeball.
  --   for token_index = 1, #home_pokeball.getObjects() do
  --     -- Take object from home pokeball.
  --     local token = home_pokeball.takeObject({})

  --     -- Apply the tag to the Pokemon TOKEN.
  --     token.addTag("Pokemon Token")

  --     -- Put the Pokemon into  into the temp pokeball.
  --     temp_pokeball.putObject(token)
  --   end

  --   -- Now take the object back from the temp pokeball and put them back 
  --   -- into the home pokeball.
  --   for token_index = 1, #temp_pokeball.getObjects() do
  --     home_pokeball.putObject(temp_pokeball.takeObject({}))
  --   end
  -- end

  -- The models take much more effort. Move them back and forth into the temp pokeball on seperate saves.
  -- local pokeballs_list = battlemodelsList
  -- for pokeball_index=1, #pokeballs_list do
  --   -- Get handle to the home pokeball and temp pokeball.
  --   local home_pokeball = getObjectFromGUID(pokeballs_list[pokeball_index])
  --   local temp_pokeball = getObjectFromGUID("e08c3e")

  --   -- Loop through each item in the pokeball.
  --   for model_index = 1, #home_pokeball.getObjects() do
  --     -- Take object from home pokeball.
  --     local model = home_pokeball.takeObject({})

  --     -- Apply the tag to the Pokemon Model.
  --     model.addTag("Pokemon Model")

  --     -- Put the Pokemon into  into the temp pokeball.
  --     temp_pokeball.putObject(model)
  --   end
  -- end

  -- Get handle to the home pokeball and temp pokeball.
  -- local home_pokeball = getObjectFromGUID(battlemodels_GUID)
  -- local temp_pokeball = getObjectFromGUID("e08c3e")

  -- -- Loop through each item in the pokeball.
  -- for model_index = 1, #temp_pokeball.getObjects() do
  --   -- Take object from home pokeball.
  --   local model = temp_pokeball.takeObject({})

  --   -- Put the Pokemon into the home pokeball.
  --   home_pokeball.putObject(model)
  -- end

  local save_table
  if saved_data and saved_data ~= "" then
    save_table = JSON.decode(saved_data)
  end
  
  if save_table then
    -- Models.
    models_enabled = save_table.enabled
    global_scale = save_table.model_scale
    spawn_delay = save_table.spawn_delay
    -- Selected Pokemon.
    selectedGens = save_table.selectedGens
    customGen = save_table.customGen
    customGymLeaderOption = save_table.customGymLeaderOption
    -- Music.
    original_music_enabled = save_table.original_music_enabled
    remix_music_enabled = save_table.remix_music_enabled
    -- House Rules.
    HR_hard_gym_leaders=save_table.HR_hard_gym_leaders
    HR_hp_rule_2=save_table.HR_hp_rule_2    
    HR_dual_type_effectiveness=save_table.HR_dual_type_effectiveness
  end

  -- Do some safety checks.
  if models_enabled == nil then
    models_enabled = false
  end
  if global_scale == nil then
    global_scale = 2
  end
  if spawn_delay == nil then
    spawn_delay = 0
  end
  if original_music_enabled == nil then
    original_music_enabled = true
  end
  if remix_music_enabled == nil then
    remix_music_enabled = false
  end

  -- Update the music playlists.
  update_playlists()

  -- Combine the data to look at fossil Pokemon, board Pokemon AND custom Pokemon too.
  local allData = genData
  table.insert(allData, boardPokemonData)
  table.insert(allData, fossilPokeballPokemonData)
  table.insert(allData, customPokemonData)

  index = 1
  local key = 1
  for _, singleGenData in pairs(allData) do
    for _, pokemon_base in pairs(singleGenData) do
      local saved_state
      if pokemon_base.states then
        for skey, pokemon_state in pairs(pokemon_base.states) do
          if save_table and save_table.base[key] and save_table.base[key].states[skey] then
            pokemon_state.created_before = save_table.base[key].states[skey].created_before
          else
            pokemon_state.created_before = false
          end
          if pokemon_state.custom_scale == nil then
            pokemon_state.custom_scale = 1
          end
        end
      else
        if save_table and save_table.base[key] then
          pokemon_base.created_before = save_table.base[key].created_before
        else
          pokemon_base.created_before = false
        end
        if pokemon_base.custom_scale == nil then
          pokemon_base.custom_scale = 1
        end
      end
      pokemon_base.in_creation = false
      if pokemon_base.idle_effect == nil then
        pokemon_base.idle_effect = "Idle"
      end
      if pokemon_base.run_effect == nil then
        pokemon_base.run_effect = "Run"
      end
      if pokemon_base.spawn_effect == nil then
        pokemon_base.spawn_effect = "Special Attack"
      end
      if pokemon_base.faint_effect == nil then
        pokemon_base.faint_effect = "Faint"
      end
      if pokemon_base.despawn_time == nil then
        pokemon_base.despawn_time = 1.0
      end
      if pokemon_base.offset == nil then
        pokemon_base.offset = {x=0, y=0, z=-0.17}
      else
        pokemon_base.offset = {x=pokemon_base.offset.x, y=pokemon_base.offset.y, z=pokemon_base.offset.z-0.17}
      end
      if pokemon_base.persistent_state == nil then
        pokemon_base.persistent_state = true
      end
      for _, guid in pairs(pokemon_base.guids) do
        -- Check for the board pokemon, since they were already created set them to created_before=true.
        if guid == "315879" or guid == "390ee2" then
          pokemon_base.created_before = true
        end

        active_chips[guid] = {
          chip_GUID = guid,
          base = pokemon_base,
          in_creation = false,
          picked_up = false
        }
        local chip = getObjectFromGUID(guid)
        if chip then
          active_chips[guid].chip = chip
          chip.registerCollisions()
        end
        if save_table and save_table.active[guid] then
          local pokemon = active_chips[guid]
          local active_save = save_table.active[guid]

          if active_save.state_key then
            pokemon.state_key = active_save.state_key
            pokemon.state = pokemon.base.states[active_save.state_key]
          end
          local model = getObjectFromGUID(active_save.model_GUID)
          if model then
            pokemon.model = model
            active_models[active_save.model_GUID] = pokemon
            if not pokemon.state then
              pokemon.state = pokemon.base
            end
            model.interactable = false
            model.dynamic_friction = 1
            model.mass = 0
            model.setLock(true)
            try_activate_effect({model=pokemon.model, effectName=pokemon.state.idle_effect or pokemon.base.idle_effect})
          end
          local secondary_type_token = getObjectFromGUID(active_save.secondary_type_token_guid)
          if secondary_type_token then
            pokemon.secondary_type_token = secondary_type_token
            active_secondary_type_tokens[active_save.secondary_type_token_guid] = pokemon
            secondary_type_token.interactable = false
            secondary_type_token.mass = 0
            secondary_type_token.dynamic_friction = 1
            secondary_type_token.setPosition(secondary_type_token_position(pokemon))
            secondary_type_token.setLock(false)
            secondary_type_token.jointTo(pokemon.chip, {
              ["type"]         = "Fixed",
              ["collision"]    = false,
              ["break_force"]  = math.infinity,
              ["break_torgue"] = math.infinity,
            })
          end
        end
      end
      key = key + 1
    end
  end
  printToAll("Save Data loaded!")

  -- GUI Toggles.
  -- Pokemon gens.
  UI.setAttribute("gen1ToggleBtn", "isOn", selectedGens[1])
  UI.setAttribute("gen2ToggleBtn", "isOn", selectedGens[2])
  UI.setAttribute("gen3ToggleBtn", "isOn", selectedGens[3])
  UI.setAttribute("gen4ToggleBtn", "isOn", selectedGens[4])
  UI.setAttribute("gen5ToggleBtn", "isOn", selectedGens[5])
  UI.setAttribute("gen6ToggleBtn", "isOn", selectedGens[6])
  UI.setAttribute("gen7ToggleBtn", "isOn", selectedGens[7])
  UI.setAttribute("gen8ToggleBtn", "isOn", selectedGens[8])
  UI.setAttribute("gen9ToggleBtn", "isOn", selectedGens[9])
  UI.setAttribute("customToggleBtn", "isOn", customGen)
  checkBeginState()
  -- House rules.
  UI.setAttribute("setHardGymLeaders", "isOn", HR_hard_gym_leaders)
  UI.setAttribute("setDualTypeEffectiveness", "isOn", HR_dual_type_effectiveness)
  --UI.setAttribute("setHpRule2", "isOn", HR_hp_rule_2)

  -- Rebind the hotkeys.
  addHotkey("Battle Wild Pokemon",  function(player_color, hovered_object, point, key_up) battle_wild_pokemon(hovered_object) end)
  addHotkey("Query Pokemon Info",  function(player_color, hovered_object, point, key_up) query_pokemon_info(hovered_object, player_color) end)
  addHotkey("Change Seat - Yellow", function(player_color, hovered_object, point, key_up) change_seat(player_color, "Yellow") end)
  addHotkey("Change Seat - Green",  function(player_color, hovered_object, point, key_up) change_seat(player_color, "Green") end)
  addHotkey("Change Seat - Blue",   function(player_color, hovered_object, point, key_up) change_seat(player_color, "Blue") end)
  addHotkey("Change Seat - Red",    function(player_color, hovered_object, point, key_up) change_seat(player_color, "Red") end)
  addHotkey("Change Seat - Purple", function(player_color, hovered_object, point, key_up) change_seat(player_color, "Purple") end)
  addHotkey("Change Seat - Orange", function(player_color, hovered_object, point, key_up) change_seat(player_color, "Orange") end)
  addHotkey("Pan Camera - Arena",   function(player_color, hovered_object, point, key_up) pan_camera(player_color, ARENA) end)
  addHotkey("Pan Camera - Figure",  function(player_color, hovered_object, point, key_up) pan_camera(player_color, FIGURE) end)
  addHotkey("Pan Camera - Rack",    function(player_color, hovered_object, point, key_up) pan_camera(player_color, RACK) end)

  print_changelog()
end

function print_changelog()
  printToAll("Last update on 09/22/2024 - v3.1 \
   - Added this Change Log :D \
   - Added new Hotkey to help with Wild Battle scripting (Options > Game Keys > Battle Wild Pokemon). Using this hotkey will provide you with additional Battle Arena buttons to speed up the game. \
   - New Recall buttons for Rival Events, Gym Leader and Trainer Battles \
   - Optional Scripted House Rules! \
     * Dual Types \
       o When playing Dual Type, look for the secondary type tokens on the Pokémon Token or configure the Query Pokemon Info game key in Options > Game Keys \
     * Chaos Gym Leaders \
       o This will cause Gym Leaders (of the same tier) to be randomly chosen from all Generations each time the gyms are battled \
   - Pokémon with multiple forms now have been merged into one, with multiple States. In wild situations, battle the default and, on catch, choose the form permanently (Right-click > choose State). \
   - Battle counters should be much more accurate \
   - Gen 9 Models now have (painfully slow) animations", 
  "Pink")
end

function onSave()
  local base_table = {}
  for key, pokemon_base in pairs(genData) do
    if (pokemon_base.states and any_state_created_before(pokemon_base.states)) or pokemon_base.created_before then
      local base_data = {}
      if pokemon_base.states then
        base_data.states={}
        for skey,pokemon_state in pairs(pokemon_base.states) do
          if pokemon_state.created_before then
            base_data.states[skey] = {
              created_before = pokemon_state.created_before
            }
          end
        end
      else
        base_data.created_before = pokemon_base.created_before
      end
      base_table[key] = base_data
    end
  end
  local active_table = {}
  for key,pokemon in pairs(active_chips) do
    -- Model.
    if pokemon.model then
      active_table[key] = {
        model_GUID = pokemon.model.getGUID()
      }
      if pokemon.state_key then
        active_table[key].state_key = pokemon.state_key
      end
    elseif pokemon.state_key then
      active_table[key] = {
        state_key = pokemon.state_key
      }
    end
    -- Secondary type token.
    if pokemon.secondary_type_token then
      if not active_table[key] then
        active_table[key] = {}
      end
      active_table[key].secondary_type_token_guid = pokemon.secondary_type_token.getGUID()
    end
  end

  -- Create the save table.
  local save_table = { 
    -- Models.
    enabled=models_enabled,
    model_scale=global_scale,
    spawn_delay=spawn_delay,
    -- Selected Pokemon.
    selectedGens=selectedGens,
    customGen=customGen,
    customGymLeaderOption=customGymLeaderOption,
    version=version,
    base=base_table,
    active=active_table,
    -- Music.
    original_music_enabled=original_music_enabled,
    remix_music_enabled=remix_music_enabled,
    -- House Rules.
    HR_hard_gym_leaders=HR_hard_gym_leaders,
    HR_hp_rule_2=HR_hp_rule_2,
    HR_dual_type_effectiveness=HR_dual_type_effectiveness
  }
  return JSON.encode(save_table)
end

function change_seat(player_color, new_color)
  Player[player_color].changeColor(new_color)
end

-- Function used for hotkeys.
function pan_camera(player_color, camera_location)
  -- Pan the camera to the specified location.
  if camera_location == ARENA then
    showArena(nil, player_color)
  elseif camera_location == FIGURE then
    panToPlayer(player_color)
  elseif camera_location == RACK then
    viewTeam(player_color)
  else
    print("Unsupported camera location specified in pan_camera: " .. tostring(camera_location))
  end
end

-- NOTE: This was taken from the racks. Ideally, we make this call there directly but 
--       I don't feel like updating the racks. Plus, the racks use their function leveraging
--       the obj field. That function didn't play nicely.
function panToPlayer(color)
  -- Determine the figure's GUID.
  local figureGUID = nil
  if color == "Yellow" then
    figureGUID = "f5f4be"
  elseif color == "Green" then
    figureGUID = "bdde77"
  elseif color == "Blue" then
    figureGUID = "f99b44"
  elseif color == "Red" then
    figureGUID = "c036ba"
  elseif color == "Purple" then
    figureGUID = "1d1174"
  elseif color == "Orange" then
    figureGUID = "f86514"
  else
    print("Unsupported color specified in panToPlayer: " .. tostring(color))
  end
  local pokeOnePosX = getObjectFromGUID(figureGUID).getPosition()[1]
  local pokeOnePosZ = getObjectFromGUID(figureGUID).getPosition()[3]

  Player[color].lookAt({
      position = {x=pokeOnePosX, y=0.14, z=pokeOnePosZ},
      pitch    = 60,
      yaw      = 0,
      distance = 25,
  })
end

-- NOTE: This was taken from the Battle Manager. Ideally, we make this call 
--       there directly but BM uses their function leveraging the obj field. 
--       That function didn't play nicely.
function viewTeam(team)
  if team == "Blue" then
    showPosition = {x=-21.50,y=0.14,z=-48}
    camYaw = 0
  elseif team == "Green" then
      showPosition = {x=-65,y=0.96,z=-21.5}
      camYaw = 90
  elseif team == "Orange" then
      showPosition = {x=65,y=0.96,z=21.5}
      camYaw = 270
  elseif team == "Purple" then
      showPosition = {x=65,y=0.96,z=-21.5}
      camYaw = 270
  elseif team == "Red" then
      showPosition = {x=21.50,y=0.14,z=-48}
      camYaw = 0
  elseif team == "Yellow" then
      showPosition = {x=-65,y=0.96,z=21.5}
      camYaw = 90
  end

  Player[team].lookAt({
      position = showPosition,
      pitch    = 60,
      yaw      = camYaw,
      distance = 25
  })
end

-- Function called by a Game Key to send a wile Pokemon to the arena. This function provides many buttons.
function battle_wild_pokemon(chip)
  -- Basic checks.
  if not chip or not chip.hasTag("Pokemon Token") then return end
  if not isFaceUp(chip) then
    print("You must flip the Pokémon Token before sneding it to the Arena for battle")
    return
  end

  -- Get a handle to the BattleManager.
  local battle_manager = getObjectFromGUID("de7152")
  if not battle_manager then
    -- Game over basically.
    printToAll("The BattleManager was not found. Hmm.")
    return
  end

  -- TODO: stop redeploying legendaries.

  -- Initialize the recall parameters.
  local chip_position = chip.getPosition()
  local color_index = nil

  -- Determine which color this pokemon came from. Use the Pokeball Colours constants for indexes.
  for pokeball_index=1, #deploy_pokeballs do
    local pokeball_object = getObjectFromGUID(deploy_pokeballs[pokeball_index])
    if not pokeball_object then
      printToAll("Failed to find pokeball with GUID " .. tostring(deploy_pokeballs[pokeball_index]) .. ". Hmm.")
      return
    end

    -- Get the Kanto locations for the Pokeball. NOTE: The Kanto locations do not have a middle parameter.
    local kanto_locations = pokeball_object.call("getKantoLocations")
    for kanto_index=1, #kanto_locations do
      -- See if the kanto location is within range.
      if math.abs(chip_position.x - kanto_locations[kanto_index][1]) < 0.1 and math.abs(chip_position.z - kanto_locations[kanto_index][2]) < 0.1 then
        color_index = pokeball_index
        break
      end
    end
  end

  -- Call moveAndBattleWildPokemon.
  local params = {
    chip_guid = chip.getGUID(),
    wild_battle_params = { 
      position = chip_position,
      color_index = color_index
    }
  }
  battle_manager.call("moveAndBattleWildPokemon", params)
end

-- Function called by a Game Key to query Pokemon info, specifically types.
function query_pokemon_info(item, player_color)
  -- Basic checks.
  if not item then return end
  if item.hasTag("Pokemon Token") and not isFaceUp(item) then return end

  -- Get the Pokemon data.
  local pokemon_data = GetAnyPokemonDataByGUID({guid=item.getGUID()})
  if pokemon_data then
    -- Print the Pokemon info.
    printToAll("Pokémon: " .. tostring(pokemon_data.name))
    printToAll(" Types: ")
    for type_index=1, #pokemon_data.types do
      local color = type_to_color_lookup(pokemon_data.types[type_index], pokemon_data.name)
      printToAll("  " .. pokemon_data.types[type_index], color)
    end
    if pokemon_data.evoData and #pokemon_data.evoData > 0 then
      print(" Evolutions:")
      for evo_index=1, #pokemon_data.evoData do
        local evo_data = GetAnyPokemonDataByGUID({guid=pokemon_data.evoData[evo_index]["guids"][1]})
        printToAll("  " .. evo_data.name)
        printToAll("   Types: ")
        for type_index=1, #evo_data.types do
          local color = type_to_color_lookup(evo_data.types[type_index], evo_data.name)
          printToAll("    " .. evo_data.types[type_index], color)
        end
      end
    end
    return
  end

  -- It's not a typical pokemon token. Maybe it is a rival. Try to get the rival data.
  local rival_data = GetRivalPokemonDataByGuid(item.getGUID())
  if rival_data then
    local pokemon_data = isFaceUp(item) and rival_data.pokemon[1] or rival_data.pokemon[2]
    if not pokemon_data then return end

    -- Print the Pokemon info.
    printToAll(tostring(rival_data.trainerName) .. "'s " .. tostring(pokemon_data.name))
    printToAll(" Types: ")
    for type_index=1, #pokemon_data.types do
      local color = type_to_color_lookup(pokemon_data.types[type_index], pokemon_data.name)
      printToAll("  " .. pokemon_data.types[type_index], color)
    end
    return
  end

  -- It is probably a Gym Leader.
  local gym_data = GetGymDataByGUID({guid=item.getGUID()})
  if gym_data then
    -- TODO: using command on BS causes error here.
    local pokemon_data = isFaceUp(item) and gym_data.pokemon[1] or gym_data.pokemon[2]

    -- Print the Pokemon info.
    printToAll(tostring(gym_data.trainerName) .. "'s " .. tostring(pokemon_data.name))
    printToAll(" Types: ")
    for type_index=1, #pokemon_data.types do
      local color = type_to_color_lookup(pokemon_data.types[type_index], pokemon_data.name)
      printToAll("  " .. pokemon_data.types[type_index], color)
    end
    return
  end
end

-- Color lookup function for logs. I tried to use a lookup table but Lua is trash.
function type_to_color_lookup(pokemon_type, pokemon_name)
  if not pokemon_type then return end
  if type(pokemon_type) ~= "string" then return end

  if pokemon_type == "Grass" then
    return {119/255, 204/255, 85/255}
  elseif pokemon_type == "Water" then
    return {51/255, 153/255, 255/255}
  elseif pokemon_type == "Fire" then
    return {255/255, 68/255, 34/255}
  elseif pokemon_type == "Poison" then
    return {170/255, 85/255, 153/255}
  elseif pokemon_type == "Ice" then
    return {102/255, 204/255, 255/255}
  elseif pokemon_type == "Dark" then
    return {119/255, 85/255, 68/255}
  elseif pokemon_type == "Steel" then
    return {170/255, 170/255, 187/255}
  elseif pokemon_type == "Psychic" then
    return {255/255, 85/255, 153/255}
  elseif pokemon_type == "Ghost" then
    return {106/255, 102/255, 187/255}
  elseif pokemon_type == "Fairy" then
    return {238/255, 153/255, 238/255}
  elseif pokemon_type == "Ground" then
    return {221/255, 187/255, 85/255}
  elseif pokemon_type == "Fighting" then
    return {187/255, 85/255, 68/255}
  elseif pokemon_type == "Normal" then
    return {255/255, 255/255, 255/255}
  elseif pokemon_type == "Dragon" then
    return {255/255, 215/255, 0/255}
  elseif pokemon_type == "Flying" then
    return {136/255, 153/255, 255/255}
  elseif pokemon_type == "Electric" then
    return {255/255, 204/255, 51/255}
  elseif pokemon_type == "Bug" then
    return {170/255, 187/255, 34/255}
  elseif pokemon_type == "Rock" then
    return {187/255, 170/255, 102/255}
  end

  -- Could not find the type.
  printToAll(pokemon_name .. " has a mistyped type: " .. tostring(pokemon_type) .. "; tell the developers :)")
  return "White"
end

-- Models function.
function any_state_created_before(states)
  for _, pokemon_state in pairs(states) do
    if pokemon_state.created_before then
      return true
    end
  end
  return false
end

function beginSetup(player, value, id)
  UI.hide('Settings')
  local params = {
    selectedGens = selectedGens,
    customGen = customGen,
    leadersGen = leadersGen,
    randomStarters = randomStarters,
    customGymLeaderOption = customGymLeaderOption
  }

  --[[ Initialize the random seed. I know, why 3? Well, when I only did this once Gen VII Gym 5
       deployed the same gym every. single. time. despite having 3 options. I added two more and
       things felt more random. Maybe we should add 3 more? *thinking* ]]
  math.randomseed(os.time())
  math.randomseed(os.time())
  math.randomseed(os.time())

  local battleManager = getObjectFromGUID("de7152")
  battleManager.call("setScriptingEnabled", battleScripting)

  local starterPokeball = getObjectFromGUID("ec1e4b")
  starterPokeball.call("beginSetup2", params)

  local rivalEventPokeball = getObjectFromGUID("432e69")
  rivalEventPokeball.call("setRivalRegion", eventRivalRegion)
end

-----------------
-- Pokemon gens.
-----------------

-- String to boolean lookup dict. This return nil if the lookup fails.
stringToBoolean = { ["True"]=true, ["true"]=true, ["False"]=false, ["false"]=false }

function gen1Set(player, isOn)
  selectedGens[1] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen2Set(player, isOn)
  selectedGens[2] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen3Set(player, isOn)
  selectedGens[3] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen4Set(player, isOn)
  selectedGens[4] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen5Set(player, isOn)
  selectedGens[5] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen6Set(player, isOn)
  selectedGens[6] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen7Set(player, isOn)
  selectedGens[7] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen8Set(player, isOn)
  selectedGens[8] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function gen9Set(player, isOn)
  selectedGens[9] = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

-----------------
-- Custom Pokemon.
-----------------

function customSet(player, isOn)
  customGen = stringToBoolean[isOn]
  enoughPokemon()
  checkBeginState()
end

function enoughPokemon()
  local numPokemon = 0
  if selectedGens[1] then
    numPokemon = numPokemon + 151
  end
  if selectedGens[2] then
    numPokemon = numPokemon + 100
  end
  if selectedGens[3] then
    numPokemon = numPokemon + 136
  end
  if selectedGens[4] then
    numPokemon = numPokemon + 107
  end
  if selectedGens[5] then
    numPokemon = numPokemon + 171
  end
  if selectedGens[6] then
    numPokemon = numPokemon + 73
  end
  if selectedGens[7] then
    numPokemon = numPokemon + 111
  end
  if selectedGens[8] then
    numPokemon = numPokemon + 133
  end
  if selectedGens[9] then
    numPokemon = numPokemon + 120
  end
  if customGen then
    local pokeball
    for i = 1, #customPokeballs do
      pokeball = getObjectFromGUID(customPokeballs[i])
      numPokemon = numPokemon + #pokeball.getObjects()
    end
  end

  -- Check the final count.
  if numPokemon < 150 then
    printToAll("WARNING: Less than 150 base Pokémon have been selected. This type of setup has not been tested thoroughly.")
  end
  hasEnoughPokemon = true
end

function randomStartersToggle()
  randomStarters = not randomStarters
end

-----------------
-- Gym Leaders.
-----------------

function genLeadersSet(player, option, id)
  if option == GEN_1_SELECT then
    setLeaders(1, true)
  elseif option == GEN_2_SELECT then
    setLeaders(2, true)
  elseif option == GEN_3_SELECT then
    setLeaders(3, true)
  elseif option == GEN_4_SELECT then
    setLeaders(4, true)
  elseif option == GEN_5_SELECT then
    setLeaders(5, true)
  elseif option == GEN_6_SELECT then
    setLeaders(6, true)
  elseif option == GEN_7_SELECT then
    setLeaders(7, true)
  elseif option == GEN_8_SELECT then
    setLeaders(8, true)
  elseif option == GEN_9_SELECT then
    setLeaders(9, true)
  elseif option == RANDOM_SELECT then
    setLeaders(-1, true)
  elseif option  == CHAOS_SELECT then
    setLeaders(-2, true)
  else
    printToAll("Unknown Leaders selected: " .. option, "Red")
  end
end

function customGymLeadersOptionsSet(player, option, id)
  if tonumber(option) > ALWAYS_SELECT then
    print("Unknown Custom Gym Leader option: " .. tostring(id))
    return
  end

  customGymLeaderOption = tonumber(option)
end

function getCustomGymLeadersOption()
  return customGymLeaderOption
end

function setLeaders(gen, isOn)
  if isOn == "True" then isOn = true end
  if isOn != true then return end
  leadersGen = gen

  -- Check if a House Rule was enabled that needs explained.
  if leadersGen == -2 then
    -- Chaos Gym Leaders.
    printToAll("\nChaos Gym Leaders: Enabled \
  - This will cause Gym Leaders (of the same tier) to be randomly chosen from all Generations each time the gyms are battled.", 
    "Pink")
  end

  if leadersGen == 0 then
    local starterPokeball = getObjectFromGUID("ec1e4b")
    customAndTooFewLeaders = not starterPokeball.call("hasEnoughCustomLeaders")
  else
    customAndTooFewLeaders = false
  end

  checkBeginState()
end

-----------------
-- Rival.
-----------------

function rivalRegionSet(player, option, id)
  setEventRivalRegion(option, true)
end

function setEventRivalRegion(region, isOn)
  if isOn == "True" then isOn = true end
  if isOn != true then return end

  -- I Tried to sanitize the region parameter but it kept causing errors. 
  -- Now we learn to trust. :)
  eventRivalRegion = region
end

-----------------
-- AI.
-----------------

function battleScriptingToggle()
  battleScripting = not battleScripting
end

function aiOff(player, isOn)
  setAIDifficulty(0, isOn)
end

function aiEasy(player, isOn)
  setAIDifficulty(1, isOn)
end

function aiMedium(player, isOn)
  setAIDifficulty(2, isOn)
end

function aiHard(player, isOn)
  setAIDifficulty(3, isOn)
end

function setAIDifficulty(difficulty, isOn)
  if isOn == "True" then isOn = true end
  if isOn != true then return end
  aiDifficulty = difficulty
end

function checkBeginState()
  UI.setAttribute("beginBtn", "interactable", hasEnoughPokemon and customAndTooFewLeaders == false)
end

-----------------
-- Scripted house rule setters and getters.
-----------------

function hardGymLeadersSet(player, isOn)
  HR_hard_gym_leaders = stringToBoolean[isOn]

  -- If Hard Gym Leaders was just turned on, give a log statement explaining the rules.
  if HR_hard_gym_leaders then
  --   printToAll("\nHard Gym Leaders: Enabled \
  -- - TODO ",
  --   "Pink")
  else
    printToAll("Hard Gym Leaders: Disabled")
  end
end

function hpRule2Set(player, isOn)
  HR_hp_rule_2 = stringToBoolean[isOn]

  -- If HP Rule 2 was just turned on, give a log statement explaining the rules.
  if HR_hp_rule_2 then
  --   printToAll("\nHP Rule 2: Enabled \
  -- - TODO ",
  --   "Pink")
  else
    printToAll("HP Rule 2: Disabled")
  end
end

function getHpRule2Set()
  return HR_hp_rule_2
end

function dualTypeEffectivenessSet(player, isOn)
  HR_dual_type_effectiveness = stringToBoolean[isOn]

  -- If Dual Type Effectiveness was just turned on, give a log statement explaining the rules.
  if HR_dual_type_effectiveness then
    printToAll("\nDual Type Effectiveness: Enabled \
  - Dual Type Effectiveness Rules: \
    * Secondary Pokémon types are considered for effectiveness. \
    * Super-Weak (-3) / Weak (-2) / Neutral / Effective (+2) / Super-Effective (+3)", 
    "Pink")
  else
    printToAll("Dual Type Effectiveness: Disabled")
  end
end

function getDualTypeEffectiveness()
  return HR_dual_type_effectiveness
end

-----------------
-- Dual Type.
-----------------

function getSecondaryTypeTokenBaseGuid(type)
  if not type then return nil end
  for i = 1, #TYPE_TOKEN_GUID_TABLE do
    if TYPE_TOKEN_GUID_TABLE[i].type == type then
      return TYPE_TOKEN_GUID_TABLE[i].guid
    end
  end

  return nil
end

function spawn_secondary_type_token(pokemon)
  -- Allow callers to pass in a GUID instead.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end

  -- Basic assertions.
  assert(pokemon.chip)
  assert(pokemon.secondary_type_token == nil)

  -- Grab the base token based of the needed type.
  local type_bag = getObjectFromGUID(TYPES_BAG_GUID)
  local base_type_guid = getSecondaryTypeTokenBaseGuid(pokemon.base.types[2])
  local base_type_object = type_bag.takeObject({guid=base_type_guid})

  -- Clone the base type object.
  local p = { position = secondary_type_token_position(pokemon), rotation = secondary_type_token_rotation(pokemon) }
  pokemon.secondary_type_token = base_type_object.clone(p)

  -- Adjust the token.
  pokemon.secondary_type_token.interactable = false
  pokemon.secondary_type_token.dynamic_friction = 1
  pokemon.secondary_type_token.mass = 0
  pokemon.secondary_type_token.setPosition(secondary_type_token_position(pokemon))
  pokemon.secondary_type_token.setRotation(secondary_type_token_rotation(pokemon))
  pokemon.secondary_type_token.setLock(false)
  pokemon.secondary_type_token.jointTo(pokemon.chip, {
    ["type"]         = "Fixed",
    ["collision"]    = false,
    ["break_force"]  = math.infinity,
    ["break_torgue"] = math.infinity,
  })

  -- Update the list of active secondary type tokens.
  active_secondary_type_tokens[pokemon.secondary_type_token.getGUID()] = pokemon

  -- Put the base type object back in the bag.
  type_bag.putObject(base_type_object)
end

function secondary_type_token_position(pokemon)
  -- Allow callers to pass in a GUID instead.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end

  -- Assert we have a chip.
  assert(pokemon.chip)
  
  local offset = {x=0.88, y=0, z=0.13}
  if pokemon.base and pokemon.base.token_offset then
    offset = {x=0.9-pokemon.base.token_offset.x, y=0-pokemon.base.token_offset.y, z=0.16-pokemon.base.token_offset.z}
  end
  return pokemon.chip.positionToWorld (
    pokemon.chip.positionToLocal(
      pokemon.chip.getPosition()+{x=0, y=pokemon.chip.getBounds().size[2], z=0}
    ) + offset
  )
end

function secondary_type_token_rotation(pokemon)
  -- Allow callers to pass in a GUID instead.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end
  assert(pokemon.chip)
  return {x=0, y=pokemon.chip.getRotation()[2], z=0}
end

-- Secondary type token check for spawn or despawn.
function check_for_spawn_or_despawn_secondary_type_token(pokemon)
  -- Allow callers to pass in a GUID instead of the actual objects. As far as I can tell,
  -- calling a function via Global.call() does not allow this.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end

  -- Rare case where we suck so badly we don't have type data.
  if not pokemon.base or not pokemon.base.types then return end

  if not HR_dual_type_effectiveness then return end
  if #pokemon.base.types < 2 then return end -- Some pokemon do not have a secondary type.
  if not pokemon.chip or (pokemon.secondary_type_token and not isFaceUp(pokemon.chip)) then
    if not pokemon.secondary_type_token then return end
    if pokemon.base.in_creation then
      Wait.condition(function() check_for_spawn_or_despawn_secondary_type_token(pokemon) end, function() return not pokemon.base.in_creation end)
      return
    end
    local pokemon_secondary_type_token = pokemon.secondary_type_token
    pokemon.secondary_type_token = nil
    if pokemon.chip and not pokemon.picked_up then
      Wait.time(function() despawn_secondary_type_token({pokemon=pokemon, secondary_type_token=pokemon_secondary_type_token}) end, 0.2)
    else
      despawn_secondary_type_token({pokemon=pokemon, secondary_type_token=pokemon_secondary_type_token})
    end
  elseif not pokemon.chip.resting then
    Wait.condition(function() check_for_spawn_or_despawn_secondary_type_token(pokemon) end, function() return not pokemon.chip or pokemon.chip.resting end)
  elseif not pokemon.secondary_type_token and (pokemon.isTwoFaced or isFaceUp(pokemon.chip)) then
    if pokemon.in_creation or pokemon.base.in_creation then
      Wait.condition(
        function() Wait.time(function() check_for_spawn_or_despawn_secondary_type_token(pokemon) end, 0.2) end,
        function() return not pokemon.in_creation and not pokemon.base.in_creation end
      )
    else
      -- Spawn in the the secondary type token.
      spawn_secondary_type_token(pokemon)
    end
  end
end

function despawn_secondary_type_token(params)
  -- Allow callers to pass in a GUID instead.
  if type(params.secondary_type_token) == "string" then
    params.secondary_type_token = getObjectFromGUID(params.secondary_type_token)
  end

  -- de7152 is the BattleManager. If this functionality tries to destroy the BattleManager then the whole game breaks, lol.
  if params.secondary_type_token.getGUID() == "de7152" then return end
  
  active_secondary_type_tokens[params.secondary_type_token.getGUID()] = nil
  params.pokemon.secondary_type_token = nil
  destroyObject(params.secondary_type_token)
end

function remove_from_active_active_secondary_type_tokens_by_GUID(guid)
  -- Remove the data from the table.
  active_secondary_type_tokens[guid] = nil
end

-- Get the active secondary type GUID for a token (or gym card, etc.).
function get_secondary_type_token_guid(chip_guid)
  for secondary_type_token_guid, pokemon_data in pairs(active_secondary_type_tokens) do
    if pokemon_data.chip_GUID == chip_guid then
      return secondary_type_token_guid
    end
  end

  -- No secondary type token found, return nil.
  return nil
end

-- Function to move a secondary type token.
function move_secondary_type_token(pokemon)
  -- Check if we are doing secondary type tokens or if we don't have one.
  if not HR_dual_type_effectiveness then return end

  -- Get the token GUID.
  local token_guid = get_secondary_type_token_guid(pokemon.pokemonGUID)
  if token_guid then
    local token = getObjectFromGUID(token_guid)
    if token then 
      token.setPosition(secondary_type_token_position(pokemon))
      token.setRotation(secondary_type_token_rotation(pokemon))
    end
  end
end

function wait_for_chip_secondary_type_token(pokemon)
  Wait.condition(
    function() 
      -- Check to spawn in the secondary type token.
      check_for_spawn_or_despawn_secondary_type_token(pokemon)
    end,
    function() return not pokemon.chip or pokemon.chip.resting or (pokemon.secondary_type_token==nil) == isFaceUp(pokemon.chip) end
  )
end

function get_active_secondary_type_tokens_by_GUID(guid)
  return active_secondary_type_tokens[guid]
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  MUSIC
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function PlayRouteMusic()
  MusicPlayer.setPlaylist(route_playlist)
  MusicPlayer.setCurrentAudioclip(route_playlist[math.random(#route_playlist)])
  MusicPlayer.repeat_track = false
  MusicPlayer.shuffle = true
  MusicPlayer.play()
end

function PlayOpeningMusic()
  currentTrack = MusicPlayer.playlist_index + 1
  parameters =
  {
    url = "http://cloud-3.steamusercontent.com/ugc/2469738072713807297/578FCF01CEB10CD9F19D296687F11F6CF7B15732/",
    title = "Theme Song"
  }
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = false
  MusicPlayer.play()
end

function PlayTrainerBattleMusic()
  currentTrack = MusicPlayer.playlist_index + 1
  parameters =
  {
    url = "http://cloud-3.steamusercontent.com/ugc/1023948871898692339/1921C30F85D84D3DA42FB922B89E8C3EDBA0035F/",
    title = "Battle Music"
  }
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlayGymBattleMusic()
  currentTrack = MusicPlayer.playlist_index + 1
  parameters = battle_playlist[math.random(#battle_playlist)]
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlayFinalBattleMusic()
  currentTrack = MusicPlayer.playlist_index + 1
  parameters = elite_4_playlist[math.random(#elite_4_playlist)]
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlayVictoryMusic()
  parameters =
  {
    url = "http://cloud-3.steamusercontent.com/ugc/1025076138129942019/D4A62C26EC339551E33D0319D0340384B1BDC69A/",
    title = "Victory Music"
  }
  MusicPlayer.setCurrentAudioclip(parameters)
end

function PlayRivalMusic()
  currentTrack = MusicPlayer.playlist_index + 1
  parameters = rival_playlist[math.random(#rival_playlist)]
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlaySilphCoBattleMusic()
  currentTrack = MusicPlayer.playlist_index + 1
  parameters = team_rocket_playlist[math.random(#team_rocket_playlist)]
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
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

--[[ Models code. 
  Models code was taken from this mod and modified (and added to) as needed for our use: 
      https://steamcommunity.com/sharedfiles/filedetails/?id=1108630722
  Apparently that mod took the models from other mods and those mods are gone. 
  So credit to the original creator is not easy to pinpoint. Still, we thank them!
]]--
function get_active_pokemon_by_GUID(guid, by_model_guid)
  if by_model_guid then
    return active_models[guid]
  else
    return active_chips[guid]
  end
end

-- This is just a dumber version of get_active_pokemon_by_GUID that is slimmed down so
-- it can be used by the BattleManager
function simple_get_active_pokemon_by_GUID(guid)
  return active_chips[guid]
end

-- Helper function used to insert data into the active chips list. This is used for
-- Gym Leaders, Rivals, etc.
function add_to_active_chips_by_GUID(params)
  -- Get the chip by its GUID.
  params.data.chip = getObjectFromGUID(params.data.chip_GUID)

  -- Wait until the <whatever> token is resting.
  Wait.condition(
    function()
      params.data.model = get_model_guid_on_top(params.data)
    end,
    function() -- Condition function
      return params.data.chip ~= nil and params.data.chip.resting and get_model_guid_on_top(params.data) ~= nil
    end,
    3
  )

  -- Check if some other model of this type was created already.
  params.data.base.created_before = has_model_been_created(params.data.base.name)
  
  -- Insert the data into the table.
  active_chips[params.guid] = params.data

  -- Return the created before flag. This helps the caller call check_for_spawn_or_despawn() correctly. (It is gross, yes.)
  return params.data.base.created_before
end

function has_model_been_created(name)
  -- Determine if one of the active chips has a model that was created.
  local return_value = true
  for _, pokemon in pairs(active_chips) do
    -- Check if this is our Pokemon chip we care about.
    if pokemon.base.name == name then
      if not pokemon.base.created_before then
        return_value = false

        -- Now the model has been created, modify the field for future model checks.
        pokemon.base.created_before = true
      end
    end
  end
  
  return return_value
end

-- Helper function used to remove data from the active chips list. This is used for
-- rival tokens and gym leaders.
function remove_from_active_chips_by_GUID(guid)
  -- Remove the data from the table.
  active_chips[guid] = nil
end

-- Get the active model GUID for a token (or gym card, etc.). This is useful to prevent despawning the base model each time.
function get_model_guid(token_guid)
  for model_guid, pokemon_data in pairs(active_models) do
    if pokemon_data.chip_GUID == token_guid then
      return model_guid
    end
  end

  -- No model found, return nil.
  return nil
end

function get_battlemodels_GUID()
  return battlemodels_GUID
end

function is_pokemon_chip(tbl)
  return get_active_pokemon_by_GUID(tbl.obj_GUID) ~= nil
end

-- Model spawn and despawn related functions
function isFaceUp(obj)
  if type(obj) == "string" then
    obj = getObjectFromGUID(obj)
  end
  if not obj then return false end
  return (obj.getTransformUp()[2] > 0)
end

function get_model_guid_on_top(pokemon)
  assert(pokemon.chip)
  local hits = Physics.cast({
    origin = model_position(pokemon, true),
    direction = {x=0, y=1, z=0},
    type = 3,
    size = pokemon.chip.getBounds().size
  })
  for i=1,#hits do
    if hits[i].hit_object ~= pokemon.chip then
      return hits[i].hit_object
    end
  end
  return nil
end

function has_something_on_top(pokemon)
  assert(pokemon.chip)
  -- TODO: occasional errors here?
  local check_size = pokemon.chip.getBounds().size
  check_size = { x=check_size.x / 2, y=check_size.y / 2, z=check_size.z / 2 }
  local hits = Physics.cast({
    origin = model_position(pokemon, true),
    direction = {x=0, y=1, z=0},
    type = 3,
    size = check_size
  })
  for i=1,#hits do
    -- GUID de7152 is the BattleManager. Somehow, Gym Leaders cards register as having it on top. Not sure why lol.
    if hits[i].hit_object ~= pokemon.model and hits[i].hit_object ~= pokemon.chip and hits[i].hit_object.getGUID() ~= "de7152" then
      return true
    end
  end
  return false
end

function get_pokemon_below(pokemon)
  assert(pokemon and pokemon.chip)
  local hits = Physics.cast({
    origin = model_position(pokemon, true),
    direction = {x=0, y=-1, z=0},
    type = 1
  })
  local number_pokemon_below = 0
  local pokemon_below = {}
  for i=1,#hits do
    if hits[i].hit_object ~= pokemon.chip then
      local hit_pokemon = get_active_pokemon_by_GUID(hits[i].hit_object.getGUID())
      if hit_pokemon then
        number_pokemon_below = number_pokemon_below + 1
        pokemon_below[number_pokemon_below] = hit_pokemon
      end
    end
  end
  return pokemon_below
end

function despawn_below(pokemon)
  if not pokemon or not pokemon.chip then return end
  local pokemon_below = get_pokemon_below(pokemon)
  for i=1,#pokemon_below do
    despawn_now(pokemon_below[i])
  end
end

function wait_for_chip(pokemon)
  Wait.condition(
    function() 
      -- Check to spawn in the model.
      check_for_spawn_or_despawn(pokemon)
    end,
    function() return not pokemon.chip or pokemon.chip.resting or (pokemon.model==nil) == isFaceUp(pokemon.chip) end
  )

end

-- Model check for spawn or despawn.
function check_for_spawn_or_despawn(pokemon)
  -- Allow callers to pass in a GUID instead of the actual objects. As far as I can tell,
  -- calling a function via Global.call() does not allow this.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end

  if not models_enabled then return end
  if not pokemon.base.model_GUID and not pokemon.base.states then return end -- some pokemon do not have a model yet
  if not pokemon.chip or (pokemon.model and not isFaceUp(pokemon.chip)) then
    if not pokemon.model or pokemon.in_creation then return end
    pokemon.in_creation = true
    if pokemon.model.getGUID() == pokemon.state.model_GUID then
      if pokemon.base.in_creation then
        pokemon.in_creation = false
        Wait.condition(function() check_for_spawn_or_despawn(pokemon) end, function() return not pokemon.base.in_creation end)
        return
      end
      pokemon.base.in_creation = true
    end
    local pokemon_model=pokemon.model
    pokemon.model=nil
    if pokemon.chip and not pokemon.picked_up and try_activate_effect({model=pokemon_model, effectName=pokemon.state.faint_effect or pokemon.base.faint_effect}) then
      Wait.time(function() despawn_model(pokemon, pokemon_model) end, pokemon.base.despawn_time)
    else
      despawn_model(pokemon, pokemon_model)
    end
  elseif not pokemon.chip.resting then
    Wait.condition(function() check_for_spawn_or_despawn(pokemon) end, function() return not pokemon.chip or pokemon.chip.resting end)
  elseif not pokemon.model and (pokemon.isTwoFaced or isFaceUp(pokemon.chip)) then
    if pokemon.in_creation or pokemon.base.in_creation then
      Wait.condition(
        function() Wait.time(function() check_for_spawn_or_despawn(pokemon) end, 0.7 --[[Time needed for despawn animation]]) end,
        function() return not pokemon.in_creation and not pokemon.base.in_creation end
      )
    elseif has_something_on_top(pokemon) then
      return
    else
      -- Spawn in the model.
      pokemon.in_creation = true
      pokemon.base.in_creation = true
      spawn_model(pokemon)
    end
  end
end

function despawn_now(pokemon)
  -- Allow callers to pass in a GUID instead of the actual objects. As far as I can tell,
  -- calling a function via Global.call() does not allow this.
  if type(pokemon.model) == "string" then
    pokemon.model = getObjectFromGUID(pokemon.model)
  end

  if not pokemon.model then return end
  if pokemon.in_creation then
    Wait.condition(function() despawn_now(pokemon) end, function() return not pokemon.in_creation end)
  else
    pokemon.in_creation = true
    if pokemon.model.getGUID() == pokemon.state.model_GUID then
      pokemon.base.in_creation = true
    end
    local pokemon_model = pokemon.model
    pokemon.model = nil
    despawn_model(pokemon, pokemon_model)
  end
end

function despawn_model(pokemon, model)
  -- de7152 is the BattleManager. If this functionality tries to destroy the BattleManager then the whole game breaks, lol.
  if model.getGUID() == "de7152" then return end

  active_models[model.getGUID()] = nil
  if model.getGUID() == pokemon.state.model_GUID then
    local despawn_scale = 1/spawn_scale
    if pokemon.scale_set then
      for _,scale in pairs(pokemon.scale_set) do
        despawn_scale = despawn_scale * scale
      end
      pokemon.scale_set = {}
    end
    scale_model(model, despawn_scale)
    battlemodels.putObject(model)
    if not pokemon.base.persistent_state then
      pokemon.state = nil
      pokemon.state_key = nil
    end
    pokemon.base.in_creation = false
  else
    destroyObject(model)
  end
  pokemon.in_creation = false
  assert(pokemon.model == nil)
end

function model_position(pokemon, without_offset)
  -- Allow callers to pass in a GUID instead.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end

  -- Assert we have a chip.
  assert(pokemon.chip)
  
  local offset = {x=0, y=0, z=0}
  if not without_offset then
    offset = pokemon.base.offset
    offset = {x=offset.x*global_scale, y=offset.y*global_scale, z=offset.z*global_scale}
  end
  return pokemon.chip.positionToWorld (
    pokemon.chip.positionToLocal(
      pokemon.chip.getPosition()+{x=0, y=pokemon.chip.getBounds().size[2], z=0}
    ) + offset
  )
end

function model_rotation(pokemon)
  assert(pokemon.chip)
  return {x=0, y=pokemon.chip.getRotation()[2], z=0}
end

function bag_contains(guid, bag)
  for _,obj in ipairs(bag.getObjects()) do
    if guid == obj.guid then
      return true
    end
  end
  return false
end

function spawn_model(pokemon)
  -- Allow callers to pass in a GUID instead.
  if type(pokemon.chip) == "string" then
    pokemon.chip = getObjectFromGUID(pokemon.chip)
  end

  assert(pokemon.chip)
  assert(pokemon.model == nil)
  if not pokemon.state then
    if pokemon.base.states then
      local r = math.random(1,#pokemon.base.states)
      pokemon.state = pokemon.base.states[r]
      pokemon.state_key = r
    else
      pokemon.state = pokemon.base

      -- Safety check in case the scale is missing.
      if pokemon.state.custom_scale == nil then
        pokemon.state.custom_scale = 1
      end
    end
  end

  -- Check if the model is already in use.
  base_model = getObjectFromGUID(pokemon.state.model_GUID)
  if base_model then
    local p = {
      position = model_position(pokemon)
    }
    pokemon.model = base_model.clone(p)
    pokemon.model.setPosition(model_position(pokemon))
    -- Override the rotation if given a custom rotation value.
    if pokemon.state.custom_rotation ~= nil then
      pokemon.model.setRotation(pokemon.state.custom_rotation)
    else
      pokemon.model.setRotation(model_rotation(pokemon))
    end
    Wait.condition(
      function()
        active_models[pokemon.model.getGUID()] = pokemon
        init_model(pokemon)
      end,
      function() return pokemon.model.getGUID() ~= pokemon.state.model_GUID end
    )
  elseif bag_contains(pokemon.state.model_GUID, battlemodels) then --check should not be needed if used correctly - but people tend to do crazy stuff
    active_models[pokemon.state.model_GUID] = pokemon
    local p = {
      position = model_position(pokemon),
      rotation = model_rotation(pokemon),
      guid = pokemon.state.model_GUID,
      smooth = false,
      callback_function = function(obj) spawn_callback(obj, futureName) end
    }
    -- Override the rotation if given a custom rotation value.
    if pokemon.state.custom_rotation ~= nil then
      p.rotation = pokemon.state.custom_rotation
    end
    local model_reference = battlemodels.takeObject(p)
    -- reset if pokemon hasn't spawned after 2 sec (e.g. if AssetBundle could not be loaded)
    Wait.condition(function() return end, function() return not pokemon.in_creation end, 2,
      function()
        assert(pokemon.model == nil)
        active_models[pokemon.state.model_GUID] = nil
        pokemon.in_creation = false
        pokemon.base.in_creation = false
      end
    )
  else -- for some reason model does not exist
    if pokemon.model_not_existent_message_printed == nil then
      printToAll("Model " .. pokemon.state.model_GUID .. " for " .. pokemon.state.name .. " does not exist. Have you deleted it? If this occurs frequently, please contact the developer. :-)")
      pokemon.model_not_existent_message_printed = true
    end
    pokemon.in_creation = false
    pokemon.base.in_creation = false
  end
end

function spawn_callback(obj, name)
  if not obj then return end -- AssetBundle has not been found
  local pokemon = active_models[obj.getGUID()]
  if not pokemon then return end -- Timeout before spawn happened
  pokemon.model = obj
  assert(pokemon.model.getGUID() == pokemon.state.model_GUID)
  if not pokemon.state.created_before then
    pokemon.model.setScale({global_scale, global_scale, global_scale})
    pokemon.state.created_before = true
    init_model(pokemon, true)
  else
    local scaling_vector = {x=global_scale, y=global_scale, z=global_scale}
    if pokemon.base.custom_scale then
      scaling_vector.x = scaling_vector.x * pokemon.base.custom_scale
      scaling_vector.y = scaling_vector.y * pokemon.base.custom_scale
      scaling_vector.z = scaling_vector.z * pokemon.base.custom_scale
    end
    pokemon.model.setScale(scaling_vector)
    init_model(pokemon)
  end
end

function init_model(pokemon, first_creation)
  pokemon.model.interactable = false
  pokemon.model.dynamic_friction = 1
  pokemon.model.mass = 0
  pokemon.model.setLock(true)
  pokemon.base.in_creation = false
  pokemon.in_creation = false
  Wait.condition(
    function()
      try_activate_effect({model=pokemon.model, effectName=pokemon.state.idle_effect or pokemon.base.idle_effect})
      Wait.time(
        function()
          try_activate_effect({model=pokemon.model, effectName=pokemon.state.spawn_effect or pokemon.base.spawn_effect})
          if first_creation then
            local scale_step = math.sqrt(math.sqrt(math.sqrt(pokemon.state.custom_scale)))
            pokemon.scale_set = {scale_step, scale_step, scale_step, scale_step, scale_step, scale_step, scale_step, scale_step}
            -- Wait 2 sec before scaling except if pokemon despawns in between
            Wait.time(function() scale_model_next(pokemon) end, 2)
          end
        end,
        spawn_delay
      )
    end,
    function() return not pokemon.model or (not pokemon.model.spawning and not pokemon.model.loading_custom) end
  )
end

function scale_model(pokemon_model, scale_factor)
  pokemon_model.scale(scale_factor)
  pokemon_model.mass = 0
end

function scale_model_next(pokemon)
  if not pokemon.model then return end
  for key, scale in pairs(pokemon.scale_set) do
    scale_model(pokemon.model, scale)
    pokemon.scale_set[key] = nil
    Wait.time(function() scale_model_next(pokemon) end, 0.05)
    return
  end
end

function try_activate_effect(params) -- model, effectName
  if not params.model then return false end
  if not params.effectName then return false end
  if not params.model.AssetBundle then return false end

  local triggerList = params.model.AssetBundle.getTriggerEffects()
  local loopingList = params.model.AssetBundle.getLoopingEffects()

  if (not triggerList or not loopingList) then
    return false
  end

  for _, effect in ipairs(triggerList) do
    if effect.name == params.effectName then
      params.model.AssetBundle.playTriggerEffect(effect.index)
      return true
    end
  end
  for _, effect in ipairs(loopingList) do
    if effect.name == params.effectName then
      params.model.AssetBundle.playLoopingEffect(effect.index)
      return true
    end
  end
  return false
end

-- pickup and drop related functions
function wait_for_empty_stack(pokemon)
  Wait.time(
    function()
      assert(pokemon)
      if not pokemon.chip then return end
      local hits = Physics.cast({
        origin = model_position(pokemon, true),
        direction = {x=0, y=1, z=0},
        type = 3,
        size = pokemon.chip.getBounds().size
      })
      local resting_on_top = false
      for i=1,#hits do
        if hits[i].hit_object ~= pokemon.model and hits[i].hit_object ~= pokemon.chip then
          if hits[i].hit_object.resting then
            resting_on_top = true
          else
            wait_for_empty_stack(pokemon)
            return
          end
        end
      end
      if not resting_on_top then
        -- Check to spawn in the model.
        check_for_spawn_or_despawn(pokemon)

        -- Check to spawn in the secondary type token.
        check_for_spawn_or_despawn_secondary_type_token(pokemon)
      end
    end,
    0.5
  )
end

function pickUp(pokemon)
  -- check for a token.
  if not pokemon then return end

  -- Wait for the token to come to rest.
  --wait_for_chip_secondary_type_token(pokemon)
  local token_guid = get_secondary_type_token_guid(pokemon.chip_GUID)
  if token_guid then
    despawn_secondary_type_token({pokemon=pokemon, secondary_type_token=token_guid})
  end

  -- Check for a model.
  if not pokemon.model then return end

  assert(pokemon.chip)
  pokemon.picked_up = true
  pokemon.model.setPosition(model_position(pokemon))
  pokemon.model.setLock(false)
  pokemon.model.jointTo(pokemon.chip, {
    ["type"]         = "Fixed",
    ["collision"]    = false,
    ["break_force"]  = math.infinity,
    ["break_torgue"] = math.infinity,
  })

  -- Active the running animation.
  try_activate_effect({model=pokemon.model, effectName=pokemon.state.run_effect or pokemon.base.run_effect})

  -- Wait for the token to come to rest.
  wait_for_chip(pokemon)
  local pokemon_below = get_pokemon_below(pokemon)
  for i=1,#pokemon_below do
    wait_for_empty_stack(pokemon_below[i])
  end
end

function drop(pokemon)
  if not pokemon then return end
  if not pokemon.model then
    Wait.condition(function() despawn_below(pokemon) end, function() return not pokemon.chip or pokemon.chip.resting end)
    return
  end
  assert(pokemon.chip)
  pokemon.model.jointTo()
  pokemon.model.setPosition(model_position(pokemon))
  pokemon.model.setRotation(model_rotation(pokemon))
  pokemon.model.setLock(true)
  try_activate_effect({model=pokemon.model, effectName=pokemon.state.idle_effect or pokemon.base.idle_effect})
  pokemon.picked_up = false
  Wait.condition(function() despawn_below(pokemon) walk_to_chip(pokemon) end, function() return not pokemon.model or not pokemon.chip or pokemon.chip.resting end)
end

function walk_to_chip(pokemon)
  if pokemon.chip and pokemon.model and isFaceUp(pokemon.chip) then
    pokemon.model.setPositionSmooth(model_position(pokemon), false, false)
    pokemon.model.setRotationSmooth(model_rotation(pokemon), false, false)
  else
    -- Check to spawn in the model.
    check_for_spawn_or_despawn(pokemon)
  end

  if pokemon.chip and isFaceUp(pokemon.chip) then
    
  else
    -- Check to spawn in the secondary type token.
    check_for_spawn_or_despawn_secondary_type_token(pokemon)
  end
end

function scale_models(tbl)
  local new_scale
  local new_scale
  if tbl.scale > 1 then
      new_scale = math.ceil(global_scale*tbl.scale*100)/100
  else
      new_scale = math.floor(global_scale*tbl.scale*100)/100
  end
  if new_scale > 0 then
      for _,pokemon in pairs(active_chips) do
          if pokemon.model then
              scale_model(pokemon.model, new_scale/global_scale)
              pokemon.model.setPosition(model_position(pokemon))
          end
      end
      global_scale = new_scale
  end
end

function toggle_models_enabled()
  -- If a battle is in progress, we do not allow toggling of models. 
  -- Gyms and rivals have despawn functionality but not respawn.
  local battleManager = getObjectFromGUID("de7152")
  if battleManager ~= nil then
    if battleManager.call("isBattleInProgress") then
      printToAll("Cannot toggle models during battle.")
      return
    end
  end

  if models_enabled then
    models_enabled = false
    for _, pokemon in pairs(active_chips) do
      despawn_now(pokemon)
    end
  else
    models_enabled = true
    for _, pokemon in pairs(active_chips) do
      if pokemon.chip then
        check_for_spawn_or_despawn(pokemon)
      end
    end
  end
end

function get_models_enabled()
  return models_enabled
end

function increase_spawn_delay(tbl)
  local new_delay = math.floor(100*(spawn_delay+tbl.delay))/100
  if new_delay >= 0 then
    spawn_delay = new_delay
  end
end

function get_spawn_delay()
  return spawn_delay
end

-- For Yellow Pokemon. Needs every chip to be listed in the pokemon table
function put_chips_to_container(tbl)
  local put_list = {}
  local put_nbr = 0
  for i=1, #tbl.chips do
    local pokemon=get_active_pokemon_by_GUID(tbl.chips[i].hit_object.guid)
    if pokemon and pokemon.chip then
      put_nbr = put_nbr + 1
      put_list[put_nbr] = pokemon.chip_GUID
      tbl.container.putObject(pokemon.chip)
    end
  end
  return put_list
end

-- further events
function onObjectLeaveContainer(container, leave_object)
  local pokemon = get_active_pokemon_by_GUID(leave_object.getGUID())
  if pokemon then
    pokemon.chip = leave_object
    pokemon.chip.registerCollisions()
    Wait.time(function() wait_for_chip(pokemon) end, 0.5 --[[ Prevent spawning while object is dealt]])
  end
end

function onObjectEnterContainer(container, enter_object)
  -- Debug only
  if (guid_nbr) then
    guid_nbr = guid_nbr + 1
    guid_list[guid_nbr] = enter_object.getGUID()
    if guid_list_with_names then
      names_list[guid_nbr] = enter_object.getName()
    end
  end

  -- Actual code
  local pokemon = get_active_pokemon_by_GUID(enter_object.getGUID())
  if pokemon then
    enter_object.unregisterCollisions()
    pokemon.chip = nil
    wait_for_chip(pokemon)
    
    pokemon.secondary_type_token = nil
    wait_for_chip_secondary_type_token(pokemon)
  end
end

function onObjectCollisionEnter(hit_object, collision_info)
  local pokemon = get_active_pokemon_by_GUID(hit_object.getGUID())
  if pokemon then
    wait_for_chip(pokemon)
    wait_for_chip_secondary_type_token(pokemon)
  end
end

function onObjectHover(player_color, hover_object)
  if hover_object then
    local pokemon = get_active_pokemon_by_GUID(hover_object.getGUID())
    if pokemon and next(Player[player_color].getHoldingObjects()) and Player[player_color].getHoldingObjects()[1].getGUID() ~= pokemon.chip_GUID then
      if pokemon.model and has_something_on_top(pokemon) then
        -- de7152 is the BattleManager. If this functionality tries to destroy the BattleManager then the whole game breaks, lol.
        if type(pokemon.model) == "string" and pokemon.model == "de7152" then return end
        if pokemon.model.getGUID() == "de7152" then return end

        -- Safely despawn the model.
        despawn_now(pokemon)
        wait_for_empty_stack(pokemon)
      end
    end
  end
end

function onObjectPickUp(player_color, picked_up_object)
  pickUp(get_active_pokemon_by_GUID(picked_up_object.getGUID()))
end

function onObjectDrop(player_color, dropped_object)
  drop(get_active_pokemon_by_GUID(dropped_object.getGUID()))
end

function onObjectDestroy(dying_object)
  local guid = dying_object.getGUID()
  local pokemon_by_chip = get_active_pokemon_by_GUID(guid)
  if pokemon_by_chip then
    pokemon_by_chip.chip = nil
    despawn_now(pokemon_by_chip)
  else
    local pokemon_by_model = get_active_pokemon_by_GUID(guid, true)
    if pokemon_by_model then
      -- model is destroyed even though chip isn't (may happen during table flip)
      pokemon_by_model.model = nil
      active_models[guid] = nil
    end
  end

  -- Destroy the secondary type token, if present.
  local secondary_type_token = get_secondary_type_token_guid(guid)
  if secondary_type_token then
    active_secondary_type_tokens[guid] = nil
    if pokemon_by_chip then
      pokemon_by_chip.secondary_type_token = nil
    end
    --destroyObject(secondary_type_token)
  end
end

-- This is a helper function to prevent models from stealing our token before going into the Battle Models pokeball. 
-- The models are bags. You can't make this stuff up.
function tryObjectEnterContainer(container, object)
  if container.hasTag("Pokemon Model") then
    -- Check if the model is still here.
    local model = getObjectFromGUID(container.getGUID())
    if model ~= nil then
      model.setScale({global_scale, global_scale, global_scale})
      battlemodels.putObject(model)
    end
    return false
  end
  return true -- Allows object to enter.
end

function onObjectStateChange(object, old_state_guid)
  -- Check if models are enabled.
  if object.hasTag("Pokemon Token") and models_enabled then
    -- Save off some data we care about.
    local pokemon_guid = object.guid
    local pokemon_position = object.getPosition()
    local pokemon_rotation = object.getRotation()

    -- Get the Pokemon data.
    local pokemon_data = GetPokemonDataByGUID({guid=pokemon_guid})
    if not pokemon_data then return end

    -- Check if there is a ball field.
    local color_index = 1
    if pokemon_data.ball then color_index = pokemon_data.ball end

    -- Get a handle on the pokeball that we care about.
    local pokeball = getObjectFromGUID(deploy_pokeballs[color_index])
    if not pokeball then
      print("Failed to get Pokeball handle to update the state model. Move this token to a pokeball and pull it back out to get and updated model.")
      return
    end

    -- Check if there is a secondary type token to despawn.
    if HR_dual_type_effectiveness then
      local token_guid = get_secondary_type_token_guid(old_state_guid)
      if token_guid then
        local pokemon = get_active_pokemon_by_GUID(pokemon_guid)
        despawn_secondary_type_token({pokemon=pokemon, secondary_type_token=token_guid})
      end
    end

    -- Put the Pokemon chip back in its place.
    pokeball.putObject(object)

    -- Wait for the token to go into the pokeball.
    Wait.condition(
      function()
        -- Take the chip back out of the pokeball.
        local takeParams = {guid = pokemon_guid, position = {pokemon_position.x, 1.5, pokemon_position.z}, rotation=pokemon_rotation}
        pokeball.takeObject(takeParams)
      end,
      function() -- Condition function
        return getObjectFromGUID(pokemon_guid) == nil
      end,
      2
    )
  end
end

---------------------------------
-- Funky music functionality.
---------------------------------

function toggle_original_music_enabled()
  if original_music_enabled then
    original_music_enabled = false
  else
    original_music_enabled = true
  end

  -- Update the playlist.
  update_playlists()
end

function toggle_remix_music_enabled()
  if remix_music_enabled then
    remix_music_enabled = false
  else
    remix_music_enabled = true
  end

  -- Update the playlist.
  update_playlists()
end

-- Updates the playlist based on the selected music choices.
function update_playlists()
  -- Check if the music player should be restarted.
  local restart_player = false
  if MusicPlayer.player_status == "Loading" or MusicPlayer.player_status == "Play" then
    restart_player = true
  end

  -- Clear all of the playlists.
  route_playlist = {}
  team_rocket_playlist = {}
  battle_playlist = {}
  rival_playlist = {}
  elite_4_playlist = {}

  -- Check for the music conditionals.
  if original_music_enabled then
    add_music_to_playlist(route_playlist, original_route_tracks, remix_route_tracks)
    add_music_to_playlist(team_rocket_playlist, original_team_rocket_tracks, remix_team_rocket_tracks)
    add_music_to_playlist(battle_playlist, original_battle_tracks, remix_battle_tracks)
    add_music_to_playlist(rival_playlist, original_rival_tracks, remix_rival_tracks)
    add_music_to_playlist(elite_4_playlist, original_elite_4_tracks, remix_elite_4_tracks)
  end
  if remix_music_enabled then
    add_music_to_playlist(route_playlist, remix_route_tracks, original_route_tracks)
    add_music_to_playlist(team_rocket_playlist, remix_team_rocket_tracks, original_team_rocket_tracks)
    add_music_to_playlist(battle_playlist, remix_battle_tracks, original_battle_tracks)
    add_music_to_playlist(rival_playlist, remix_rival_tracks, original_rival_tracks)
    add_music_to_playlist(elite_4_playlist, remix_elite_4_tracks, original_elite_4_tracks)
  end

  -- Restart the music if needed.
  if restart_player then
    -- Determine which playlist to load.
    -- NOTE: BattleManager uses the following values for types (better not change it! <.<).
    --[[
          PLAYER = 0
          GYM = 1
          TRAINER = 2
          WILD = 3
          RIVAL = 4
    ]]
    local battleManager = getObjectFromGUID("de7152")
    if getObjectFromGUID("ec1e4b") ~= nil then
      -- The setup is not complete, don't update the current song.
      return
    elseif not battleManager.call("isBattleInProgress") then
      PlayRouteMusic()
    else
      -- Check the defender type.
      local defenderType = battleManager.call("getDefenderType")
      if defenderType == 1 then
        -- Attacker is gym.
        PlayGymBattleMusic()
        return
      end

      local attackerType = battleManager.call("getAttackerType")
      if attackerType == 2 then
        -- Attacker is trainer.
        PlayTrainerBattleMusic()
        return
      elseif attackerType == 4 then
        -- Attacker is rival.
        PlayTrainerBattleMusic()
        return
      end

      -- Otherwise just play battle music.
      PlayTrainerBattleMusic()
    end
  end
end

-- Adds music to the prescribed playlist. Also includes a backup playlist variable in case the tracks is empty.
function add_music_to_playlist(playlist, tracks, backup_tracks)
  -- Protect ourselves from dumb people (me).
  if tracks == nil then
    tracks = {}
  end
  if backup_tracks == nil then
    backup_tracks = {}
  end

  if #tracks ~= 0 then
    for index, song in ipairs(tracks) do
      table.insert(playlist, song)
    end
  elseif #playlist == 0 then
    for index, song in ipairs(backup_tracks) do
      table.insert(playlist, song)
    end
  end
end

function get_original_music_enabled()
  return original_music_enabled
end

function get_remix_music_enabled()
  return remix_music_enabled
end