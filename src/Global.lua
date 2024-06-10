--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]

currentTrack = 1

local customPokeballs = { "a927cf", "acd90d", "63bb92", "88b157", "8aaeef", "915bb4", "47780a" }

-- Setup Variables
leadersGen = 1 -- 0 = Custom
hasEnoughPokemon = true
customAndTooFewLeaders = false
randomStarters = false
battleScripting = false
aiDifficulty = 0
-- Save Data
customGen = false

--[[ 
  NOTE: Lua cannot handle sparse arrays and, apparently, false terms can create sparse array
        behavior (see https://stackoverflow.com/a/17974661). An online interpreter suggests
        true/false is immune but something funky is going on here where *sometimes* only 
        gens 1-4 are considered enabled. ]]
selectedGens = {true,true,true,true,true,true,true,true,true}

-- Pokeball Colours
PINK = 1
GREEN = 2
BLUE = 3
YELLOW = 4
RED = 5
LEGENDARY = 6
MEGA = 7

-- Status Effects
BURN = 0
FREEZE = 1
PARALYSIS = 2
POISON = 3
SLEEP = 4
CONFUSE = 5

playlist =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898689460/46D48965B1EEDADAB14C15184FCDB41C9998C83D/", title = "Route Music 1" },
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898697980/2D46041C40896534AC54D157FC6C3CAC1F00A7E9/", title = "Route Music 2" },
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898696675/0CC89B7B48CAF248149CF2DE43DADBC1FDD260E2/", title = "Route Music 3" },
  { url = "http://cloud-3.steamusercontent.com/ugc/1023948871898694456/A95CDF7833368368BFB8EDCDB6E77E19785F3B7F/", title = "Route Music 4" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713830665/51AFCA6A1D2F74287F7065D153AE4893CFE65EE4/", title = "Gen V Route 10" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713833558/A53A7FA0DDCE1D5B076B323E61F603370D958414/", title = "Gen VIII Route 209" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713839101/D00A83FF04F6E8E7EC93A284D1264B3A88618721/", title = "Gen VIII Route 201" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713842461/880B9A4E1D19545259DC3B3A27EE29D8EADB0047/", title = "Gen III Route 101" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738072713845152/8C7AF47689CE1827BF64C68D710A231B4A943F33/", title = "Gen VIII Route 216" },
}

teamRocketPlaylist =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/2465233915448769574/09A09106156072F227DB6D44211395F1545DFB9C/", title = "Team Rocket Battle Music" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351494466/E735E7793EFD0FB37790D2B6E394FAB5DBBE9419/", title = "Rocket Powered Disaster 20" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351495962/FCA4C8DFB2639C2F56347C3B5968881ACF22066B/", title = "Rocket Powered Disaster" }
}

battlePlaylist =
{
  { url = "http://cloud-3.steamusercontent.com/ugc/1023949407635181294/DF75C7F7429A20B290E9C39CA1A391F5217CB3BB/", title = "Gym Battle Music 1" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351469017/83C3A3A8906183F09ED5F3FBED856E3DE94BF847/", title = "A Formidable Opponent Appears"},
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351472196/9F8A243CFFDF2783A35AF2B8E34CDDAF90BCE76C/", title = "Gym Battle Music - Track 14"},
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351474956/24853183DAFC85171508106801F146DAFF5FD9A7/", title = "Gym Battle Music - Scramble" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351479148/191BEBD2158D686534CD2CFC3D75B10E88FB2994/", title = "Gym Battle Music - Absolute Death" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351481972/9CFAC33E67467F93004DEAA08084922D5BBEEE7A/", title = "Gym Battle Music - Kanto" },
  { url = "http://cloud-3.steamusercontent.com/ugc/2469738708351490133/C15770511BBAEE88551E1C332FCD8A26A4F543EB/", title = "Gym Battle Music - Johto" }
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  DATA
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

customPokemonData =
{
  { name = "Pikachu", level = 1, types = { "Electric" }, moves = { "Electroweb", "Leer" }, guids = { "77331c" } }
}

-- Add pokemon here that are always included regardless of gens configured at the start of the game.
boardPokemonData = 
{
  { name = "Red Gyarados",level = 5, types = { "Water" }, moves = { "Dragon Rage", "Waterfall" },  guids = { "390ee2" }, evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "bc99f5" } } } },  -- Gen II only.
  { name = "Sudowoodo",   level = 3, types = { "Rock" },  moves = { "Rock Throw", "Mimic" },       guids = { "315879" } },                                                                                                    -- Gen II only.
}

gen1PokemonData =
{
  -- Gen 1 1-50
  { name = "Bulbasaur",   level = 1, types = { "Grass", "Poison" },    moves = { "Vine Whip", "Tackle" },          guids = { "d79fc7" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "8d43e0" } } } },
  { name = "Ivysaur",     level = 3, types = { "Grass", "Poison" },    moves = { "Poison Powder", "Razor Leaf" },  guids = { "60bde3", "8d43e0" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "85a0be", "6e6869" } } } },
  { name = "Venusaur",    level = 5, types = { "Grass", "Poison" },    moves = { "Double-Edge", "Solar Beam" },    guids = { "e69464", "85a0be", "6e6869" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "c941db", "305e33" } }, { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "0fdf45", "55e05e" } } } },
  { name = "Charmander",  level = 1, types = { "Fire" },               moves = { "Ember", "Scratch" },             guids = { "28e8ab" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "7c5381" } } } },
  { name = "Charmeleon",  level = 3, types = { "Fire" },               moves = { "Flamethrower", "Slash" },        guids = { "e40822", "7c5381" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "6a3112", "8b9dab" } } } },
  { name = "Charizard",   level = 5, types = { "Fire", "Flying" },     moves = { "Fire Spin", "Wing Attack" },     guids = { "1c82ed", "6a3112", "8b9dab" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "79685a", "f0024f" } },
                                                                                                                                                                        { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "1344e7", "64108c" } },
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "9cb6b5", "c4abad" } } } },
  { name = "Squirtle",    level = 1, types = { "Water" },              moves = { "Bubble", "Tackle" },             guids = { "88717f" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "e89741" } } } },
  { name = "Wartortle",   level = 3, types = { "Water" },              moves = { "Water Gun", "Bite" },            guids = { "cb8d39", "e89741" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "1783ad", "427b16" } } } },
  { name = "Blastoise",   level = 5, types = { "Water" },              moves = { "Hydro Pump", "Skull Bash" },     guids = { "80eaa8", "1783ad", "427b16" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "b28b0e", "0845e3" } }, { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "308530", "b981cd" } } } },
  { name = "Caterpie",    level = 1, types = { "Bug" },                moves = { "String Shot" },                  guids = { "1b2082" },                    evoData = { { cost = 1, ball = PINK, gen = 1, guids = { "358aff" } } } },
  { name = "Metapod",     level = 2, types = { "Bug" },                moves = { "Harden", "Tackle" },             guids = { "7d6dcc", "358aff" },          evoData = { { cost = 1, ball = GREEN, gen = 1, guids = { "25d791", "d36522" } } } },
  { name = "Butterfree",  level = 3, types = { "Bug", "Flying" },      moves = { "Psybeam", "Gust" },              guids = { "3cb9ed", "25d791", "d36522" },evoData = { { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "614df5", "47362b" } } } },
  { name = "Weedle",      level = 1, types = { "Bug", "Poison" },      moves = { "String Shot" },                  guids = { "4dd71c" },                    evoData = { { cost = 1, ball = PINK, gen = 1, guids = { "91bded" } } } },
  { name = "Kakuna",      level = 2, types = { "Bug", "Poison" },      moves = { "Poison Sting", "Harden" },       guids = { "daa46b", "91bded" },          evoData = { { cost = 1, ball = GREEN, gen = 1, guids = { "73c602", "61f84a" } } } },
  { name = "Beedrill",    level = 3, types = { "Bug", "Poison" },      moves = { "Twineedle", "Rage" },            guids = { "f8894f", "73c602", "61f84a" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "d4066d", "f8819a" } } }  },
  { name = "Pidgey",      level = 1, types = { "Flying", "Normal" },   moves = { "Sand Attack", "Gust" },          guids = { "ffa899" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "35b436" } } } },
  { name = "Pidgeotto",   level = 3, types = { "Flying", "Normal" },   moves = { "Quick Attack", "Whirlwind" },    guids = { "7d5ef0", "35b436" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "45e30a", "9f1834" } } } },
  { name = "Pidgeot",     level = 5, types = { "Flying", "Normal" },   moves = { "Mirror Move", "Wing Attack" },   guids = { "1d36ba", "45e30a", "9f1834" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "9844cb", "9be58b" } } } },
  { name = "Rattata",     level = 1, types = { "Normal" },             moves = { "Tail Whip", "Tackle" },          guids = { "e2226d" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "1533cd" } } } },
  { name = "Raticate",    level = 3, types = { "Normal" },             moves = { "Hyper Fang", "Super Fang" },     guids = { "50866f", "1533cd" } },
  { name = "Spearow",     level = 1, types = { "Flying", "Normal" },   moves = { "Leer", "Peck" },                 guids = { "b2ebc5" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "7598db" } } } },
  { name = "Fearow",      level = 3, types = { "Flying", "Normal" },   moves = { "Mirror Move", "Drill Peck" },    guids = { "5b5a42", "7598db" } },
  { name = "Ekans",       level = 1, types = { "Poison" },             moves = { "Wrap", "Leer" },                 guids = { "a04efa" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "297aec" } } } },
  { name = "Arbok",       level = 3, types = { "Poison" },             moves = { "Acid", "Bite" },                 guids = { "4d4660", "297aec" } },
  { name = "Pikachu",     level = 1, types = { "Electric" },           moves = { "Thunder Shock", "Growl" },       guids = { "a17986", "e5c82a" },          evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "654bd9", "3541ed" } }, 
                                                                                                                                                                        { cost = 2, ball = BLUE, gen = 1, guids = { "1e53ce", "ef1a51" } }, 
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "e932e9", "558a12" } } } },
  { name = "Raichu",      level = 3, types = { "Electric" },           moves = { "Thunderbolt", "Slam" },          guids = { "ffd6fb", "654bd9", "3541ed" } },
  { name = "Sandshrew",   level = 1, types = { "Ground" },             moves = { "Sand Attack", "Scratch" },       guids = { "6a3193" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "f4408c" } } } },
  { name = "Sandslash",   level = 3, types = { "Ground" },             moves = { "Swift", "Dig" },                 guids = { "53db8f", "f4408c" } },
  { name = "Nidoran",     level = 1, types = { "Poison" },             moves = { "Growl", "Scratch" },             guids = { "a89779" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "1809dc" } } } },
  { name = "Nidorina",    level = 3, types = { "Poison" },             moves = { "Poison Sting", "Bite" },         guids = { "ea4a3c", "1809dc" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "965607", "4e6a63" } } } },
  { name = "Nidoqueen",   level = 5, types = { "Poison", "Ground" },   moves = { "Superpower", "Body Slam" },      guids = { "95b3f2", "965607", "4e6a63" } },
  { name = "Nidoran",     level = 1, types = { "Poison" },             moves = { "Leer", "Tackle" },               guids = { "593d68" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "ed4f88" } } } },
  { name = "Nidorino",    level = 3, types = { "Poison" },             moves = { "Poison Sting", "Horn Attack" },  guids = { "2978c9", "ed4f88" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "faca75", "1ede33" } } } },
  { name = "Nidoking",    level = 5, types = { "Poison", "Ground" },   moves = { "Megahorn", "Thrash" },           guids = { "7c6422", "faca75", "1ede33" } },
  { name = "Clefairy",    level = 2, types = { "Fairy" },              moves = { "Double Slap", "Sing" },          guids = { "ed88e4", "04404a" },          evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "a4ce76", "b56e5c" } } } },
  { name = "Clefable",    level = 3, types = { "Fairy" },              moves = { "Disarming Voice", "Metronome" }, guids = { "b31265", "a4ce76", "b56e5c" } },
  { name = "Vulpix",      level = 2, types = { "Fire" },               moves = { "Quick Attack", "Ember" },        guids = { "11e2aa" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "ea4691" } } } },
  { name = "Ninetales",   level = 5, types = { "Fire" },               moves = { "Flamethrower", "Fire Spin" },    guids = { "7cfe42", "ea4691" } },
  { name = "Jigglypuff",  level = 1, types = { "Normal" },             moves = { "Sing", "Pound" },                guids = { "8d3afd", "81f395" },          evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "e72190", "247fe0" } } } },
  { name = "Wigglytuff",  level = 4, types = { "Normal" },             moves = { "Play Rough", "Body Slam" },      guids = { "e4e003", "e72190", "247fe0" } },
  { name = "Zubat",       level = 1, types = { "Poison", "Flying" },   moves = { "Leech Life", "Screech" },        guids = { "e36eed" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "975f18" } } } },
  { name = "Golbat",      level = 3, types = { "Poison", "Flying" },   moves = { "Supersonic", "Bite" },           guids = { "77b2b2", "975f18" },          evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "79419e", "1d7367" } } } },
  { name = "Oddish",      level = 2, types = { "Grass", "Poison" },    moves = { "Poison Powder", "Absorb" },      guids = { "f5c9ab" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "3e7844" } } } },
  { name = "Gloom",       level = 3, types = { "Grass", "Poison" },    moves = { "Stun Spore", "Acid" },           guids = { "22f1f2", "3e7844" },          evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "529150", "19dbd1" } }, { cost = 1, ball = YELLOW, gen = 2, guids = { "fd44a1", "14e4ad" } } } },
  { name = "Vileplume",   level = 4, types = { "Grass", "Poison" },    moves = { "Sludge Bomb", "Solar Beam" },    guids = { "a65fdf", "529150", "19dbd1" } },
  { name = "Paras",       level = 2, types = { "Bug", "Grass" },       moves = { "Stun Spore", "Scratch" },        guids = { "f3604e" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "7bae4e" } } } },
  { name = "Parasect",    level = 3, types = { "Bug", "Grass" },       moves = { "Spore", "Slash" },               guids = { "021746", "7bae4e" } },
  { name = "Venonat",     level = 3, types = { "Bug", "Poison" },      moves = { "Stun Spore", "Confusion" },      guids = { "c85b55" },                    evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "25e898" } } } },
  { name = "Venomoth",    level = 4, types = { "Bug", "Poison" },      moves = { "Sleep Powder", "Leech Life" },   guids = { "2c7de6", "25e898" } },
  -- Gen 1 51-99
  { name = "Diglett",     level = 2, types = { "Ground" },             moves = { "Scratch", "Dig" },               guids = { "b79f00" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "3f6942" } } } },
  { name = "Dugtrio",     level = 4, types = { "Ground" },             moves = { "Earthquake", "Slash" },          guids = { "cfcb95", "3f6942" } },
  { name = "Meowth",      level = 2, types = { "Normal" },             moves = { "Pay Day", "Bite" },              guids = { "312c52" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "98722a" } }, { cost = "GMax", ball = MEGA, gen = 1, guids = { "48e2c5" } } } },
  { name = "Persian",     level = 4, types = { "Normal" },             moves = { "Fury Swipes", "Slash" },         guids = { "d56c1a", "98722a" } },
  { name = "Psyduck",     level = 2, types = { "Water" },              moves = { "Fury Swipes", "Disable" },       guids = { "eeee17" },                    evoData = { { cost = 3, ball = RED, gen = 1, guids = { "4696b8" } } } },
  { name = "Golduck",     level = 5, types = { "Water" },              moves = { "Confusion", "Hydro Pump" },      guids = { "5b9964", "4696b8" } },
  { name = "Mankey",      level = 2, types = { "Fighting" },           moves = { "Low Kick", "Scratch" },          guids = { "c8da5c" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "8b1126" } } } },
  { name = "Primeape",    level = 4, types = { "Fighting" },           moves = { "Seismic Toss", "Thrash" },       guids = { "a237dd", "8b1126" },          evoData = { { cost = 1, ball = RED, gen = 9, guids = { "b68eb7", "6b4dfa" } } } },
  { name = "Growlithe",   level = 2, types = { "Fire" },               moves = { "Ember", "Roar" },                guids = { "7c2b34" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "43d4c1" } } } },
  { name = "Arcanine",    level = 5, types = { "Fire" },               moves = { "Flamethrower", "Bite" },         guids = { "e52b25", "43d4c1" } },
  { name = "Poliwag",     level = 2, types = { "Water" },              moves = { "Hypnosis", "Bubble" },           guids = { "ecd6a3" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "10f79d" } } } },
  { name = "Poliwhirl",   level = 4, types = { "Water" },              moves = { "Amnesia", "Water Gun" },         guids = { "fd5498", "10f79d" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "b75a29", "50bf9d" } }, { cost = 2, ball = RED, gen = 2, guids = { "9a1b0b", "b21ff9" } } } },
  { name = "Poliwrath",   level = 6, types = { "Water", "Fighting" },  moves = { "Body Slam", "Hydro Pump" },      guids = { "133f27", "b75a29", "50bf9d" } },
  { name = "Abra",        level = 2, types = { "Psychic" },            moves = { "Teleport" },                     guids = { "4986cd" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "345d18" } } } },
  { name = "Kadabra",     level = 3, types = { "Psychic" },            moves = { "Confusion", "Disable" },         guids = { "da1937", "345d18" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "fa44b9", "74c0b4" } } } },
  { name = "Alakazam",    level = 5, types = { "Psychic" },            moves = { "Psychic", "Reflect" },           guids = { "7117a7", "fa44b9", "74c0b4" },evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "9eade5", "8132c3" } } } },
  { name = "Machop",      level = 2, types = { "Fighting" },           moves = { "Low Kick" },                     guids = { "646972" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "0821c2" } } } },
  { name = "Machoke",     level = 4, types = { "Fighting" },           moves = { "Karate Chop", "Leer" },          guids = { "797adf", "0821c2" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "ff6a7f", "518720" } } } },
  { name = "Machamp",     level = 6, types = { "Fighting" },           moves = { "Submission", "Seismic Toss" },   guids = { "b5109b", "ff6a7f", "518720" },evoData = { { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "8d22d5", "1bc1d8" } } } },
  { name = "Bellsprout",  level = 2, types = { "Grass", "Poison" },    moves = { "Vine Whip", "Wrap" },            guids = { "a3cef8" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "4e1d04" } } } },
  { name = "Weepinbell",  level = 3, types = { "Grass", "Poison" },    moves = { "Sleep Powder", "Acid" },         guids = { "77bc48", "4e1d04" },          evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "1b329c", "e31246" } } } },
  { name = "Victreebell", level = 5, types = { "Grass", "Poison" },    moves = { "Razor Leaf", "Slam" },           guids = { "a380e7", "1b329c", "e31246" } },
  { name = "Tentacool",   level = 1, types = { "Water", "Poison" },    moves = { "Poison Sting", "Wrap" },         guids = { "7701e4" },                    evoData = { { cost = 3, ball = BLUE, gen = 1, guids = { "71015b" } } } },
  { name = "Tentacruel",  level = 4, types = { "Water", "Poison" },    moves = { "Hydro Pump", "Acid" },           guids = { "4afcb3", "71015b" } },
  { name = "Geodude",     level = 1, types = { "Rock", "Ground" },     moves = { "Defense Curl", "Rock Throw" },   guids = { "57f1ed" },                    evoData = { { cost = 3, ball = BLUE, gen = 1, guids = { "f54a1b" } } } },
  { name = "Graveler",    level = 4, types = { "Rock", "Ground" },     moves = { "Self-Destruct", "Rollout" },     guids = { "fbe7bb", "f54a1b" },          evoData = { { cost = 2, ball = RED, gen = 1, guids = { "4cbb8a", "0a8182" } } } },
  { name = "Golem",       level = 6, types = { "Rock", "Ground" },     moves = { "Explosion", "Earthquake" },      guids = { "904780", "4cbb8a", "0a8182" } },
  { name = "Ponyta",      level = 4, types = { "Fire" },               moves = { "Take Down", "Ember" },           guids = { "67fd81" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "b92f63" } } } },
  { name = "Rapidash",    level = 6, types = { "Fire" },               moves = { "Stomp", "Fire Spin" },           guids = { "f651d6", "b92f63" } },
  { name = "Slowpoke",    level = 2, types = { "Water", "Psychic" },   moves = { "Confusion", "Disable" },         guids = { "fb1925" },                    evoData = { { cost = 3, ball = RED, gen = 1, guids = { "4b8280" } }, { cost = 3, ball = RED, gen = 2, guids = { "83160e" } } } },
  { name = "Slowbro",     level = 5, types = { "Water", "Psychic" },   moves = { "Water Gun", "Psychic" },         guids = { "adce28", "4b8280" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "6060e8", "083e93" } } }  },
  { name = "Magnemite",   level = 3, types = { "Electric", "Steel" },  moves = { "Thunder Shock", "Tackle" },      guids = { "23a41e" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "7a8fae" } } } },
  { name = "Magneton",    level = 4, types = { "Electric", "Steel" },  moves = { "Thunderbolt", "Swift" },         guids = { "0e43ae", "7a8fae" },          evoData = { { cost = 2, ball = RED, gen = 4, guids = { "dedadf", "618210" } } } },
  { name = "Farfetch'd",  level = 3, types = { "Flying", "Normal" },   moves = { "Swords Dance", "Peck" },         guids = { "489e66" } },
  { name = "Doduo",       level = 3, types = { "Flying", "Normal" },   moves = { "Fury Attack", "Peck" },          guids = { "9e2524" },                    evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "ee2d7d" } } } },
  { name = "Dodrio",      level = 4, types = { "Flying", "Normal" },   moves = { "Tri Attack", "Drill Peck" },     guids = { "bdd1d3", "ee2d7d" } },
  { name = "Seel",        level = 4, types = { "Water" },              moves = { "Aurora Beam", "Take Down" },     guids = { "e71d19" },                    evoData = { { cost = 1, ball = RED, gen = 1, guids = { "8621ed" } } } },
  { name = "Dewgong",     level = 5, types = { "Water", "Ice" },       moves = { "Headbutt", "Ice Beam" },         guids = { "46abb5", "8621ed" } },
  { name = "Grimer",      level = 4, types = { "Poison" },             moves = { "Poison Gas", "Pound" },          guids = { "b0bb78" },                    evoData = { { cost = 1, ball = RED, gen = 1, guids = { "e86ddd" } } } },
  { name = "Muk",         level = 5, types = { "Poison" },             moves = { "Acid Armor", "Sludge" },         guids = { "78a11c", "e86ddd" } },
  { name = "Shellder",    level = 2, types = { "Water" },              moves = { "Clamp", "Protect" },             guids = { "b7a634" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "24e258" } } } },
  { name = "Cloyster",    level = 4, types = { "Water", "Ice" },       moves = { "Aurora Beam", "Water Pulse" },   guids = { "fb7658", "24e258" } },
  { name = "Gastly",      level = 3, types = { "Ghost", "Poison" },    moves = { "Confuse Ray" },                  guids = { "36f853" },                    evoData = { { cost = 1, ball = BLUE, gen = 1, guids = { "f1eac8" } } } },
  { name = "Haunter",     level = 4, types = { "Ghost", "Poison" },    moves = { "Hypnosis", "Lick" },             guids = { "0f5b22", "f1eac8" },          evoData = { { cost = 1, ball = RED, gen = 1, guids = { "7d5d39", "ad0856" } } } },
  { name = "Gengar",      level = 5, types = { "Ghost", "Poison" },    moves = { "Sludge Bomb", "Night Shade" },   guids = { "fe0809", "7d5d39", "ad0856" },evoData = { { cost = "GMax", ball = MEGA, gen = 1, guids = { "774eaa", "1b8bc7" } } } },
  { name = "Onix",        level = 2, types = { "Rock", "Ground" },     moves = { "Rock Throw", "Screech" },        guids = { "575fcf" },                    evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "9248b4" } } } },
  { name = "Drowzee",     level = 2, types = { "Psychic" },            moves = { "Confusion", "Disable" },         guids = { "5bda37" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "56108c" } } } },
  { name = "Hypno",       level = 4, types = { "Psychic" },            moves = { "Headbutt", "Psychic" },          guids = { "08ee2c", "56108c" } },
  { name = "Krabby",      level = 2, types = { "Water" },              moves = { "Vise Grip", "Bubble" },          guids = { "54a03e" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "aa3008" } } } },
  { name = "Kingler",     level = 4, types = { "Water" },              moves = { "Crabhammer", "Guillotine" },     guids = { "f18035", "aa3008" },          evoData = { { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "1fa11f", "9edb28" } } } },
  -- Gen 1 100-151
  { name = "Voltorb",     level = 2, types = { "Electric" },           moves = { "Self-Destruct", "Screech" },     guids = { "7963a6" },                    evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "fd080d" } } } },
  { name = "Electrode",   level = 4, types = { "Electric" },           moves = { "Explosion", "Rollout" },         guids = { "d292b7", "fd080d" } },
  { name = "Exeggcute",   level = 3, types = { "Grass", "Psychic" },   moves = { "Hypnosis", "Barrage" },          guids = { "c271ca" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "a29b99" } }, { cost = 2, ball = RED, gen = 5, guids = { "2b8a77" } } } },
  { name = "Exeggutor",   level = 5, types = { "Grass", "Psychic" },   moves = { "Solar Beam", "Egg Bomb" },       guids = { "61be01", "a29b99" } },
  { name = "Cubone",      level = 3, types = { "Ground" },             moves = { "Bone Club", "Rage" },            guids = { "9bb943" },                    evoData = { { cost = 1, ball = YELLOW, gen = 1, guids = { "921715" } }, { cost = 1, ball = YELLOW, gen = 7, guids = { "04850a" } } } },
  { name = "Marowak",     level = 4, types = { "Ground" },             moves = { "Bonemerang", "Thrash" },         guids = { "f416a8", "921715" } },
  { name = "Hitmonlee",   level = 4, types = { "Fighting" },           moves = { "Double Kick", "Mega Kick" },     guids = { "1e6425", "10087d" } },
  { name = "Hitmonchan",  level = 4, types = { "Fighting" },           moves = { "Mega Punch", "Counter" },        guids = { "ffe3b0", "d55591" } },
  { name = "Lickitung",   level = 4, types = { "Normal" },             moves = { "Lick", "Slam" },                 guids = { "6abe93" },                    evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "5d1069" } } } },
  { name = "Koffing",     level = 3, types = { "Poison" },             moves = { "Smog", "Tackle" },               guids = { "902c83" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "923b8f" } }, { cost = 2, ball = RED, gen = 8, guids = { "dccfa4" } } } },
  { name = "Weezing",     level = 5, types = { "Poison" },             moves = { "Self-Destruct", "Sludge" },      guids = { "934454", "923b8f" } },
  { name = "Rhyhorn",     level = 4, types = { "Ground", "Rock" },     moves = { "Fury Attack", "Horn Attack" },   guids = { "b40a42" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "6922c6" } } } },
  { name = "Rhydon",      level = 6, types = { "Ground", "Rock" },     moves = { "Horn Drill", "Earthquake" },     guids = { "2cb778", "6922c6" },          evoData = { { cost = 1, ball = RED, gen = 4, guids = { "1665fe", "f2b985" } } } },
  { name = "Chansey",     level = 4, types = { "Normal" },             moves = { "Double Slap", "Sing" },          guids = { "0f0dcb", "ee10ff" },          evoData = { { cost = 1, ball = RED, gen = 2, guids = { "5b9024", "774d72" } } } },
  { name = "Tangela",     level = 3, types = { "Grass" },              moves = { "Vine Whip", "Bind" },            guids = { "1ca74c" },                    evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "5965cd" } } } },
  { name = "Kangaskhan",  level = 4, types = { "Normal" },             moves = { "Dizzy Punch", "Bite" },          guids = { "cf2b95" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "0eb8c8" } } } },
  { name = "Horsea",      level = 2, types = { "Water" },              moves = { "Bubble", "Leer" },               guids = { "17d28f" },                    evoData = { { cost = 3, ball = RED, gen = 1, guids = { "a87dc7" } } } },
  { name = "Seadra",      level = 5, types = { "Water" },              moves = { "Smokescreen", "Bubble Beam" },   guids = { "f5b456", "a87dc7" },          evoData = { { cost = 1, ball = RED, gen = 2, guids = { "0b677f", "3b17f1" } } } },
  { name = "Goldeen",     level = 2, types = { "Water" },              moves = { "Horn Attack", "Peck" },          guids = { "7ba0cd" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "4d1c92" } } } },
  { name = "Seaking",     level = 5, types = { "Water" },              moves = { "Fury Attack", "Waterfall" },     guids = { "0fbe89", "4d1c92" } },
  { name = "Staryu",      level = 2, types = { "Water" },              moves = { "Water Gun", "Tackle" },          guids = { "887830" },                    evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "e03570" } } } },
  { name = "Starmie",     level = 5, types = { "Water", "Psychic" },   moves = { "Hydro Pump", "Swift" },          guids = { "4f6664", "e03570" } },
  { name = "Mr. Mime",    level = 3, types = { "Psychic" },            moves = { "Confusion", "Barrier" },         guids = { "5c3184", "8315de" } },
  { name = "Scyther",     level = 4, types = { "Bug", "Flying" },      moves = { "Fury Cutter", "Slash" },         guids = { "36242b" },                    evoData = { { cost = 1, ball = RED, gen = 2, guids = { "22e6a3" } }, { cost = 1, ball = RED, gen = 8, guids = { "18d390" } } } },
  { name = "Jynx",        level = 4, types = { "Ice", "Psychic" },     moves = { "Lovely Kiss", "Ice Punch" },     guids = { "7fad23", "4bc360" } },
  { name = "Electabuzz",  level = 4, types = { "Electric" },           moves = { "Thunder Punch", "Screech" },     guids = { "00e028", "749909" },          evoData = { { cost = 2, ball = RED, gen = 4, guids = { "11f593", "896d6e" } } } },
  { name = "Magmar",      level = 4, types = { "Fire" },               moves = { "Fire Punch", "Smog" },           guids = { "e92ee6", "a0aed6" },          evoData = { { cost = 2, ball = RED, gen = 4, guids = { "bc96fe", "ebafae" } } } },
  { name = "Pinsir",      level = 4, types = { "Bug" },                moves = { "X-Scissor", "Vise Grip" },       guids = { "141f37" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "202a18" } } } },
  { name = "Tauros",      level = 4, types = { "Normal" },             moves = { "Take Down", "Swagger" },         guids = { "904903" } },
  { name = "Magikarp",    level = 1, types = { "Water" },              moves = { "Splash" },                       guids = { "f877ca" },                    evoData = { { cost = 2, ball = GREEN, gen = 1, guids = { "985830" } } } },
  { name = "Gyarados",    level = 3, types = { "Water", "Flying" },    moves = { "Dragon Rage", "Bite" },          guids = { "d14d19", "985830" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "f45bf6", "4d5c16" } } }  }, 
  { name = "Lapras",      level = 3, types = { "Water", "Ice" },       moves = { "Body Slam", "Ice Beam" },        guids = { "a465e9" },                    evoData = { { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "f23aef" } } }  },
  { name = "Ditto",       level = 4, types = { "Normal" },             moves = { "Transform" },                    guids = { "c2023e" } },
  { name = "Eevee",       level = 3, types = { "Normal" },             moves = { "Quick Attack", "Bite" },         guids = { "690870" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "98756d" } }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 1, guids = { "090cce" } }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 1, guids = { "901417" } }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 2, guids = { "63caca" } }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 2, guids = { "5daac2" } }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 4, guids = { "25ef7b" } }, 
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 4, guids = { "549166" } },
                                                                                                                                                                        { cost = 2, ball = YELLOW, gen = 6, guids = { "7ea880" } },
                                                                                                                                                                        { cost = "GMax", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "6041c6" } } } },
  { name = "Vaporeon",    level = 5, types = { "Water" },              moves = { "Aurora Beam", "Hydro Pump" },    guids = { "dc74f4", "98756d" } },
  { name = "Jolteon",     level = 5, types = { "Electric" },           moves = { "Pin Missile", "Thunder" },       guids = { "7309b7", "090cce" } },
  { name = "Flareon",     level = 5, types = { "Fire" },               moves = { "Fire Blast", "Smog" },           guids = { "2eadbb", "901417" } },
  { name = "Porygon",     level = 2, types = { "Normal" },             moves = { "Conversion", "Sharpen" },        guids = { "f4d087" },                    evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "145660" } } } },
  { name = "Omanyte",     level = 4, types = { "Rock", "Water" },      moves = { "Spike Cannon", "Water Gun" },    guids = { "7c9350" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "4bad46" } } } },
  { name = "Omastar",     level = 6, types = { "Rock", "Water" },      moves = { "Hydro Pump", "Horn Attack" },    guids = { "fcdf06", "4bad46" } },
  { name = "Kabuto",      level = 4, types = { "Rock", "Water" },      moves = { "Harden", "Absorb" },             guids = { "adad5d" },                    evoData = { { cost = 2, ball = RED, gen = 1, guids = { "b99ba9" } } } },
  { name = "Kabutops",    level = 6, types = { "Rock", "Water" },      moves = { "Hydro Pump", "Slash" },          guids = { "2fbb99", "b99ba9" } },
  { name = "Aerodactyl",  level = 4, types = { "Rock", "Flying" },     moves = { "Hyper Beam", "Wing Attack" },    guids = { "b69470" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "5ffdbe" } } }  },
  { name = "Snorlax",     level = 4, types = { "Normal" },             moves = { "Body Slam", "Yawn" },            guids = { "81f09a", "a017f9" },          evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "318baa", "cc9678" } } } },
  { name = "Articuno",    level = 7, types = { "Ice", "Flying" },      moves = { "Mirror Coat", "Blizzard" },      guids = { "0e47e0" } },
  { name = "Zapdos",      level = 7, types = { "Electric", "Flying" }, moves = { "Thunder", "Drill Peck" },        guids = { "810844" } },
  { name = "Moltres",     level = 7, types = { "Fire", "Flying" },     moves = { "Sky Attack", "Flamethrower" },   guids = { "cf5cee" } },
  { name = "Dratini",     level = 2, types = { "Dragon" },             moves = { "Wrap", "Leer" },                 guids = { "7a8c75" },                    evoData = { { cost = 2, ball = YELLOW, gen = 1, guids = { "3add33" } } } },
  { name = "Dragonair",   level = 4, types = { "Dragon" },             moves = { "Thunder Wave", "Slam" },         guids = { "7189e9", "3add33" },          evoData = { { cost = 3, ball = RED, gen = 1, guids = { "bd4406", "1b136e" } } } },
  { name = "Dragonite",   level = 7, types = { "Dragon", "Flying" },   moves = { "Dragon Rage", "Hyper Beam" },    guids = { "907860", "bd4406", "1b136e" } },
  { name = "Mewtwo",      level = 7, types = { "Psychic" },            moves = { "Shadow Ball", "Future Sight" },  guids = { "d78d06" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "bf8dc5" } }, { cost = "Mega", ball = MEGA, gen = 1, ballGuid = "140fbd", guids = { "a4bdc6" } } } },
  { name = "Mew",         level = 7, types = { "Psychic" },            moves = { "Ancient Power", "Psychic" },     guids = { "d68dfc" } },

  -- Mega evolutions.
  { name = "Mega Blastoise",    level = 6,    types = { "Water" },     moves = { "Flash Cannon", "Scald" },         guids = { "b28b0e", "0845e3" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "80eaa8", "1783ad", "427b16" } } } },
  { name = "GMax Blastoise",    level = 5,    types = { "Water" },     moves = { "Cannonade", "Strike" },           guids = { "308530", "b981cd" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "80eaa8", "1783ad", "427b16" } } } },
  { name = "Mega Venusaur",     level = 6,    types = { "Grass" },     moves = { "Sludge Bomb", "Petal Dance" },    guids = { "c941db", "305e33" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "e69464", "85a0be", "6e6869" } } } },
  { name = "GMax Venusaur",     level = 5,    types = { "Grass" },     moves = { "Vine Lash", "Strike" },           guids = { "0fdf45", "55e05e" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "e69464", "85a0be", "6e6869" } } } },
  { name = "Mega Charizard X",  level = 6,    types = { "Fire" },      moves = { "Dragon Claw", "Inferno" },        guids = { "79685a", "f0024f" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "1c82ed", "6a3112", "8b9dab" } } } },
  { name = "Mega Charizard Y",  level = 6,    types = { "Fire" },      moves = { "Air Slash", "Inferno" },          guids = { "1344e7", "64108c" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "1c82ed", "6a3112", "8b9dab" } } } },
  { name = "GMax Charizard",    level = 6,    types = { "Fire" },      moves = { "Wildfire", "Airstream" },         guids = { "9cb6b5", "c4abad" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "1c82ed", "6a3112", "8b9dab" } } } },
  { name = "Mega Alakazam",     level = 6,    types = { "Psychic" },   moves = { "Dazzling Gleam", "Future Sight" },guids = { "9eade5", "8132c3" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "7117a7", "fa44b9", "74c0b4" } } } },
  { name = "GMax Pikachu",      level = 1,    types = { "Electric" },  moves = { "Volt Crash", "Guard" },           guids = { "e932e9", "558a12" },         evoData = { { cost = 0, ball = PINK, gen = 1, ballGuid = "140fbd", guids = { "a17986", "e5c82a" } } } },
  { name = "GMax Butterfree",   level = 3,    types = { "Bug" },       moves = { "Befuddle", "Airstream" },         guids = { "614df5", "47362b" },         evoData = { { cost = 0, ball = GREEN, gen = 1, ballGuid = "140fbd", guids = { "3cb9ed", "25d791", "d36522" } } } },
  { name = "GMax Machamp",      level = 6,    types = { "Fighting" },  moves = { "Chi Strike", "Strike" },          guids = { "8d22d5", "1bc1d8" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "b5109b", "ff6a7f", "518720" } } } },
  { name = "GMax Meowth",       level = 2,    types = { "Normal" },    moves = { "Gold Rush", "Darkness"},          guids = { "48e2c5" },                   evoData = { { cost = 0, ball = PINK, gen = 1, ballGuid = "140fbd", guids = { "312c52" } } } },
  { name = "Mega Pidgeot",      level = 6,    types = { "Flying" },    moves = { "Steel Wing", "Hurricane"},        guids = { "9844cb", "9be58b" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "1d36ba", "45e30a", "9f1834" } } } },
  { name = "Mega Beedrill",     level = 4,    types = { "Bug" },       moves = { "Poison Jab", "X-Scissor"},        guids = { "d4066d", "f8819a" },         evoData = { { cost = 0, ball = GREEN, gen = 1, ballGuid = "140fbd", guids = { "f8894f", "73c602", "61f84a" } } } },
  { name = "GMax Gengar",       level = 5,    types = { "Ghost" },     moves = { "Terror", "Ooze" },                guids = { "774eaa", "1b8bc7" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "fe0809", "7d5d39", "ad0856" } } } },
  { name = "Mega Slowbro",      level = 6,    types = { "Water" },     moves = { "Zen Headbutt", "Blizzard" },      guids = { "6060e8", "083e93" },         evoData = { { cost = 0, ball = RED, gen = 1, ballGuid = "140fbd", guids = { "adce28", "4b8280" } } } },
  { name = "GMax Kingler",      level = 4,    types = { "Water" },     moves = { "Foam Burst", "Guard" },           guids = { "1fa11f", "9edb28" },         evoData = { { cost = 0, ball = YELLOW, gen = 1, ballGuid = "140fbd", guids = { "f18035", "aa3008" } } } },
  { name = "Mega Pinsir",       level = 5,    types = { "Bug" },       moves = { "Struggle Bug", "Seismic Toss" },  guids = { "202a18" },                   evoData = { { cost = 0, ball = YELLOW, gen = 1, ballGuid = "140fbd", guids = { "141f37" } } } },
  { name = "Mega Kangaskhan",   level = 5,    types = { "Normal" },    moves = { "Hyper Beam", "Focus Blast" },     guids = { "0eb8c8" },                   evoData = { { cost = 0, ball = YELLOW, gen = 1, ballGuid = "140fbd", guids = { "cf2b95" } } } },
  { name = "GMax Lapras",       level = 3,    types = { "Water" },     moves = { "Resonance", "Strike" },           guids = { "f23aef" },                   evoData = { { cost = 0, ball = BLUE, gen = 1, ballGuid = "140fbd", guids = { "a465e9" } } } },
  { name = "GMax Eevee",        level = 3,    types = { "Normal" },    moves = { "Darkness", "Cuddle" },            guids = { "6041c6" },                   evoData = { { cost = 0, ball = GREEN, gen = 1, ballGuid = "140fbd", guids = { "690870" } } } },
  { name = "Mega Aerodactyl",   level = 5,    types = { "Rock" },      moves = { "Ancient Power", "Iron Head" },    guids = { "5ffdbe" },                   evoData = { { cost = 0, ball = YELLOW, gen = 1, ballGuid = "140fbd", guids = { "b69470" } } } },
  { name = "GMax Snorlax",      level = 4,    types = { "Normal" },    moves = { "Replenish", "Strike" },           guids = { "318baa", "cc9678" },         evoData = { { cost = 0, ball = BLUE, gen = 1, ballGuid = "140fbd", guids = { "81f09a", "a017f9" } } } },
  { name = "Mega Gyarados",     level = 4,    types = { "Rock" },      moves = { "Water Pulse", "Crunch" },         guids = { "f45bf6", "4d5c16" },         evoData = { { cost = 0, ball = GREEN, gen = 1, ballGuid = "140fbd", guids = { "d14d19", "985830" } } } },
  { name = "Mega Mewtwo X",     level = 7,    types = { "Psychic" },   moves = { "Aura Sphere", "Psystrike" },      guids = { "bf8dc5" },                   evoData = { { cost = 0, ball = LEGENDARY, gen = 1, ballGuid = "140fbd", guids = { "d78d06" } } } },
  { name = "Mega Mewtwo Y",     level = 7,    types = { "Psychic" },   moves = { "Psycho Cut", "Me First" },        guids = { "a4bdc6" },                   evoData = { { cost = 0, ball = LEGENDARY, gen = 1, ballGuid = "140fbd", guids = { "d78d06" } } } }
} 

gen2PokemonData =
{
  -- Gen 2 152-200
  { name = "Chikorita",  level = 1, types = { "Grass" },             moves = { "Bullet Seed", "Growl" },          guids = { "cbe3c6" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "7ca3d7" } } } },
  { name = "Bayleef",    level = 3, types = { "Grass" },             moves = { "Razor Leaf", "Reflect" },         guids = { "e64a46", "7ca3d7" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "595e82", "1d0c75" } } } },
  { name = "Meganium",   level = 5, types = { "Grass" },             moves = { "Body Slam", "Solar Beam" },       guids = { "97ddd4", "595e82", "1d0c75" } },
  { name = "Cyndaquil",  level = 1, types = { "Fire" },              moves = { "Smokescreen", "Ember" },          guids = { "8b91c9" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "4fe850" } } } },
  { name = "Quilava",    level = 3, types = { "Fire" },              moves = { "Flame Wheel", "Quick Attack" },   guids = { "ec0bac", "4fe850" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "444d49", "aef275" } }, { cost = 2, ball = RED, gen = 8, guids = { "e8349c", "c86580" } } } },
  { name = "Typhlosion", level = 5, types = { "Fire" },              moves = { "Flamethrower", "Swift" },         guids = { "7ce124", "444d49", "aef275" }, evolveGen = 2 },
  { name = "Totodile",   level = 1, types = { "Water" },             moves = { "Growl", "Bite" },                 guids = { "9f245a" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "1915a6" } } } },
  { name = "Croconaw",   level = 3, types = { "Water" },             moves = { "Water Gun", "Rage" },             guids = { "0f1ac8", "1915a6" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "d723a2", "4c2d4e" } } } },
  { name = "Feraligatr", level = 5, types = { "Water" },             moves = { "Waterfall", "Slash" },            guids = { "b382a4", "d723a2", "4c2d4e" } },
  { name = "Sentret",    level = 1, types = { "Normal" },            moves = { "Defense Curl", "Scratch" },       guids = { "dc2eea" },                     evoData = { { cost = 1, ball = GREEN, gen = 2, guids = { "db025b" } } } },
  { name = "Furret",     level = 2, types = { "Normal" },            moves = { "Fury Swipes", "Slam" },           guids = { "bddff6", "db025b" } },
  { name = "Hoothoot",   level = 1, types = { "Flying", "Normal" },  moves = { "Growl", "Peck" },                 guids = { "2cd22d" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "57ec65" } } } },
  { name = "Noctowl",    level = 3, types = { "Flying", "Normal" },  moves = { "Take Down", "Reflect" },          guids = { "89f5ff", "57ec65" } },
  { name = "Ledyba",     level = 1, types = { "Bug", "Flying" },     moves = { "Comet Punch", "Tackle" },         guids = { "83168b" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "0b2791" } } } },
  { name = "Ledian",     level = 3, types = { "Bug", "Flying" },     moves = { "Reflect", "Swift" },              guids = { "3d93ed", "0b2791" } },
  { name = "Spinarak",   level = 1, types = { "Bug", "Poison" },     moves = { "Poison Sting", "Constrict" },     guids = { "4a74ab" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "f8e383" } } } },
  { name = "Ariados",    level = 3, types = { "Bug", "Poison" },     moves = { "Night Shade", "Leech Life" },     guids = { "6027c1", "f8e383" } },
  { name = "Crobat",     level = 5, types = { "Poison", "Flying" },  moves = { "Confuse Ray", "Wing Attack" },    guids = { "c8cb11", "79419e", "1d7367" } },
  { name = "Chinchou",   level = 3, types = { "Water", "Electric" }, moves = { "Thunder Wave", "Bubble" },        guids = { "5cd23a" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "3bb655" } } } },
  { name = "Lanturn",    level = 4, types = { "Water", "Electric" }, moves = { "Hydro Pump", "Spark" },           guids = { "ca2f7d", "3bb655" } },
  { name = "Pichu",      level = 0, types = { "Electric" },          moves = { "Tail Whip" },                     guids = { "7a0478" },                     evoData = { { cost = 1, ball = PINK, gen = 2, guids = { "e5c82a" } } } },
  { name = "Cleffa",     level = 0, types = { "Fairy" },             moves = { "Sweet Kiss" },                    guids = { "5f28fe" },                     evoData = { { cost = 2, ball = PINK, gen = 2, guids = { "04404a" } } } },
  { name = "Igglybuff",  level = 0, types = { "Normal" },            moves = { "Defense Curl" },                  guids = { "c288dc" },                     evoData = { { cost = 1, ball = PINK, gen = 2, guids = { "81f395" } } } },
  { name = "Togepi",     level = 0, types = { "Fairy" },             moves = { "Charm" },                         guids = { "b85f3c" },                     evoData = { { cost = 2, ball = PINK, gen = 2, guids = { "abaff2" } } } },
  { name = "Togetic",    level = 2, types = { "Fairy", "Flying" },   moves = { "Safeguard", "Fairy Wind" },       guids = { "f8ed52", "abaff2" },           evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "020ecc", "3786d0" } } } },
  { name = "Natu",       level = 3, types = { "Psychic", "Flying" }, moves = { "Leer", "Peck" },                  guids = { "d743cd" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "a31065" } } } },
  { name = "Xatu",       level = 4, types = { "Psychic", "Flying" }, moves = { "Future Sight", "Confuse Ray" },   guids = { "c056ff", "a31065" } },
  { name = "Mareep",     level = 1, types = { "Electric" },          moves = { "Growl", "Tackle" },               guids = { "64aa14" },                     evoData = { { cost = 1, ball = GREEN, gen = 2, guids = { "6e25fb" } } } },
  { name = "Flaaffy",    level = 2, types = { "Electric" },          moves = { "Thunder Shock", "Light Screen" }, guids = { "65023c", "6e25fb" },           evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "433542", "089edd" } } } },
  { name = "Ampharos",   level = 4, types = { "Electric" },          moves = { "Thunder Wave", "Thunder" },       guids = { "57b26e", "433542", "089edd" }, evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "f282f0", "16d003" } } } },
  { name = "Bellossom",  level = 4, types = { "Grass" },             moves = { "Sleep Powder", "Solar Beam" },    guids = { "eda382", "14e4ad", "fd44a1" } },
  { name = "Marill",     level = 2, types = { "Water" },             moves = { "Defense Curl", "Water Gun" },     guids = { "d42c6f", "e76d9a" },           evoData = { { cost = 1, ball = BLUE, gen = 2, guids = { "47a0c6", "1ad3a2" } } } },
  { name = "Azumarill",  level = 3, types = { "Water" },             moves = { "Waterfall", "Rollout" },          guids = { "972ac4", "47a0c6", "1ad3a2" } },
  { name = "Sudowoodo",  level = 3, types = { "Rock" },              moves = { "Rock Throw", "Mimic" },           guids = { "539dea", "eeca81" } },
  { name = "Politoed",   level = 6, types = { "Water" },             moves = { "Hydro Pump", "Swagger" },         guids = { "67f2a8", "9a1b0b", "b21ff9" } },
  { name = "Hoppip",     level = 1, types = { "Grass", "Flying" },   moves = { "Tail Whip", "Tackle" },           guids = { "485f54" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "996e19" } } } },
  { name = "Skiploom",   level = 3, types = { "Grass", "Flying" },   moves = { "Poison Powder", "Stun Spore" },   guids = { "e1c8ca", "996e19" },           evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "18d441", "66e564" } } } },
  { name = "Jumpluff",   level = 4, types = { "Grass", "Flying" },   moves = { "Sleep Powder", "Mega Drain" },    guids = { "766518", "18d441", "66e564" } },
  { name = "Aipom",      level = 2, types = { "Normal" },            moves = { "Sand Attack", "Scratch" },        guids = { "7da245" },                     evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "06f1a9" } } } },
  { name = "Sunkern",    level = 2, types = { "Grass" },             moves = { "Absorb", "Pound" },               guids = { "2a0f37" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "da3544" } } } },
  { name = "Sunflora",   level = 4, types = { "Grass" },             moves = { "Petal Dance", "Razor Leaf" },     guids = { "f43c37", "da3544" } },
  { name = "Yanma",      level = 2, types = { "Bug", "Flying" },     moves = { "Quick Attack", "Hypnosis" },      guids = { "df3c90" },                     evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "e093cb" } } } },
  { name = "Wooper",     level = 1, types = { "Water", "Ground" },   moves = { "Water Gun", "Tail Whip" },        guids = { "3403ab" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "5281dd" } } } },
  { name = "Quagsire",   level = 3, types = { "Water", "Ground" },   moves = { "Earthquake", "Slam" },            guids = { "1813f8", "5281dd" } },
  { name = "Espeon",     level = 5, types = { "Psychic" },           moves = { "Psybeam", "Swift" },              guids = { "6fdb1c", "5daac2" } },
  { name = "Umbreon",    level = 5, types = { "Dark" },              moves = { "Confuse Ray", "Feint Attack" },   guids = { "a074fb", "63caca" } },
  { name = "Murkrow",    level = 3, types = { "Dark", "Flying" },    moves = { "Feint Attack", "Peck" },          guids = { "d39237" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "4f1558" } } } },
  { name = "Slowking",   level = 5, types = { "Water", "Psychic" },  moves = { "Headbutt", "Psychic" },           guids = { "f0d007", "83160e" } },
  { name = "Misdreavus", level = 4, types = { "Ghost" },             moves = { "Confuse Ray", "Psywave" },        guids = { "86b019" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "496256" } } } },
  -- Gen 2 201-251
  { name = "Unown",      level = 1, types = { "Psychic" },           moves = { "Hidden Power" },                  guids = { "0dc6f9" } },
  { name = "Wobbuffet",  level = 2, types = { "Psychic" },           moves = { "Safeguard", "Counter" },          guids = { "5dd7a5", "0bbbae" } },
  { name = "Girafarig",  level = 2, types = { "Normal", "Psychic" }, moves = { "Confusion", "Tackle" },           guids = { "1fc55d" },                     evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "f18198" } } } },
  { name = "Pineco",     level = 2, types = { "Bug" },               moves = { "Protect", "Tackle" },             guids = { "0d263c" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "7b0bfe" } } } },
  { name = "Forretress", level = 4, types = { "Bug", "Steel" },      moves = { "Double-Edge", "Spikes" },         guids = { "669297", "7b0bfe" } },
  { name = "Dunsparce",  level = 1, types = { "Normal" },            moves = { "Rage", "Glare" },                 guids = { "e86d8a" },                     evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "9c40ab" } } } },
  { name = "Gligar",     level = 4, types = { "Ground", "Flying" },  moves = { "Feint Attack", "Quick Attack" },  guids = { "f15436" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "96a4fa" } } } },
  { name = "Steelix",    level = 4, types = { "Steel", "Ground" },   moves = { "Iron Tail", "Crunch" },           guids = { "93482a", "9248b4" },           evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "8b5001", "86038a" } } } },
  { name = "Snubbull",   level = 2, types = { "Fairy" },             moves = { "Charm", "Rage" },                 guids = { "d85741" },                     evoData = { { cost = 1, ball = BLUE, gen = 2, guids = { "5351ec" } } } },
  { name = "Granbull",   level = 3, types = { "Fairy" },             moves = { "Bite", "Lick" },                  guids = { "13fcb1", "5351ec" } },
  { name = "Qwilfish",   level = 4, types = { "Water", "Poison" },   moves = { "Poison Sting", "Water Gun" },     guids = { "d28384" } },
  { name = "Scizor",     level = 5, types = { "Steel", "Bug" },      moves = { "Metal Claw", "Wing Attack" },     guids = { "7e05b1", "22e6a3" },           evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "ae958f", "1bb3d8" } } } },
  { name = "Shuckle",    level = 2, types = { "Bug", "Rock" },       moves = { "Withdraw", "Wrap" },              guids = { "3d91d1" } },
  { name = "Heracross",  level = 4, types = { "Bug", "Fighting" },   moves = { "Horn Attack", "Counter" },        guids = { "6f8ffe" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "926476" } } } },
  { name = "Sneasel",    level = 3, types = { "Dark", "Ice" },       moves = { "Feint Attack", "Quick Attack" },  guids = { "c13dc3" },                     evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "9b517e" } } } },
  { name = "Teddiursa",  level = 3, types = { "Normal" },            moves = { "Fury Swipes", "Lick" },           guids = { "e9f2b7" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "415c99" } } } },
  { name = "Ursaring",   level = 4, types = { "Normal" },            moves = { "Feint Attack", "Thrash" },        guids = { "e48590", "415c99" },           evoData = { { cost = 2, ball = RED, gen = 8, guids = { "7684c6", "2c6eaa" } }, { cost = 2, ball = RED, gen = 8, guids = { "0af179", "d9574b" } } } },
  { name = "Slugma",     level = 4, types = { "Fire" },              moves = { "Ember", "Smog" },                 guids = { "9c822d" },                     evoData = { { cost = 1, ball = RED, gen = 2, guids = { "b1cc91" } } } },
  { name = "Magcargo",   level = 5, types = { "Fire", "Rock" },      moves = { "Flamethrower", "Rock Slide" },    guids = { "3cadf7", "b1cc91" } },
  { name = "Swinub",     level = 3, types = { "Ice", "Ground" },     moves = { "Powder Snow", "Tackle" },         guids = { "cbd281" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "e3f6d9" } } } },
  { name = "Piloswine",  level = 5, types = { "Ice", "Ground" },     moves = { "Take Down", "Blizzard" },         guids = { "79cc3d", "e3f6d9" },           evoData = { { cost = 1, ball = RED, gen = 4, guids = { "bac5e2", "3e9a5e" } } } },
  { name = "Corsola",    level = 3, types = { "Water", "Rock" },     moves = { "Ancient Power", "Waterfall" },    guids = { "180047" } },
  { name = "Remoraid",   level = 3, types = { "Water" },             moves = { "Psybeam", "Water Gun" },          guids = { "c6633d" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "93e4e2" } } } },
  { name = "Octillery",  level = 4, types = { "Water" },             moves = { "Octazooka", "Ice Beam" },         guids = { "ae520a", "93e4e2" } },
  { name = "Delibird",   level = 3, types = { "Ice", "Flying" },     moves = { "Present" },                       guids = { "6588c5" } },
  { name = "Mantine",    level = 3, types = { "Water", "Flying" },   moves = { "Bubble Beam", "Wing Attack" },    guids = { "1142f0", "6fd093" } },
  { name = "Skarmory",   level = 4, types = { "Steel", "Flying" },   moves = { "Steel Wing", "Swift" },           guids = { "cfa0f1" } },
  { name = "Houndour",   level = 2, types = { "Dark", "Fire" },      moves = { "Ember", "Bite" },                 guids = { "0e8e22" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "cf82ee" } } } },
  { name = "Houndoom",   level = 4, types = { "Dark", "Fire" },      moves = { "Flamethrower", "Crunch" },        guids = { "5ef848", "cf82ee" },           evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "b27904", "41f460" } } } },
  { name = "Kingdra",    level = 6, types = { "Dragon", "Water" },   moves = { "Hydro Pump", "Twister" },         guids = { "bc99c5", "0b677f", "3b17f1" } },
  { name = "Phanpy",     level = 3, types = { "Ground" },            moves = { "Take Down", "Rollout" },          guids = { "7c1ad0" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "980292" } } } },
  { name = "Donphan",    level = 4, types = { "Ground" },            moves = { "Horn Attack", "Earthquake" },     guids = { "dcdc1d", "980292" } },
  { name = "Porygon2",   level = 4, types = { "Normal" },            moves = { "Tri Attack", "Conversion2" },     guids = { "b7c99b", "145660" },           evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "89624f", "ccdbee" } } } },
  { name = "Stantler",   level = 2, types = { "Normal" },            moves = { "Hypnosis", "Tackle" },            guids = { "3ba296" },                     evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "163267" } } } },
  { name = "Smeargle",   level = 3, types = { "Normal" },            moves = { "Sketch", "Sketch" },              guids = { "5496a6" } },
  { name = "Tyrogue",    level = 1, types = { "Fighting" },          moves = { "Tackle" },                        guids = { "b896b9" },                     evoData = { { cost = 3, ball = BLUE, gen = 1, guids = { "d55591" } }, 
                                                                                                                                                                        { cost = 3, ball = BLUE, gen = 1, guids = { "10087d" } }, 
                                                                                                                                                                        { cost = 3, ball = BLUE, gen = 2, guids = { "b53d14" } } } },
  { name = "Hitmontop",  level = 4, types = { "Fighting" },          moves = { "Triple Kick", "Quick Attack" },   guids = { "1aeec6", "b53d14" } },
  { name = "Smoochum",   level = 1, types = { "Ice", "Psychic" },    moves = { "Pound", "Lick" },                 guids = { "961d64" },                     evoData = { { cost = 3, ball = YELLOW, gen = 2, guids = { "4bc360" } } } },
  { name = "Elekid",     level = 1, types = { "Electric" },          moves = { "Quick Attack", "Leer" },          guids = { "b6056a" },                     evoData = { { cost = 3, ball = YELLOW, gen = 2, guids = { "749909" } } } },
  { name = "Magby",      level = 1, types = { "Fire" },              moves = { "Smokescreen", "Smog" },           guids = { "a47ff8" },                     evoData = { { cost = 3, ball = YELLOW, gen = 2, guids = { "a0aed6" } } } },
  { name = "Miltank",    level = 2, types = { "Normal" },            moves = { "Heal Bell", "Tackle" },           guids = { "8d2189" } },
  { name = "Blissey",    level = 5, types = { "Normal" },            moves = { "Light Screen", "Egg Bomb" },       guids = { "27e857", "5b9024", "774d72" } },
  { name = "Raikou",     level = 7, types = { "Electric" },          moves = { "Crunch", "Spark" },               guids = { "07ea8b" } },
  { name = "Entei",      level = 7, types = { "Fire" },              moves = { "Fire Blast", "Bite" },            guids = { "dbfb71" } },
  { name = "Suicune",    level = 7, types = { "Water" },             moves = { "Aurora Beam", "Hydro Pump" },     guids = { "ab44f1" } },
  { name = "Larvitar",   level = 2, types = { "Rock", "Ground" },    moves = { "Bite", "Leer" },                  guids = { "625880" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "aa8662" } } } },
  { name = "Pupitar",    level = 4, types = { "Rock", "Ground" },    moves = { "Earthquake", "Screech" },         guids = { "159d4d", "aa8662" },           evoData = { { cost = 3, ball = RED, gen = 2, guids = { "7195d5", "5764be" } } } },
  { name = "Tyranitar",  level = 7, types = { "Rock", "Dark" },      moves = { "Rock Slide", "Crunch" },          guids = { "d2d545", "7195d5", "5764be" }, evoData = { { cost = "Mega", ball = MEGA, gen = 2, ballGuid = "140fbd", guids = { "bb5cd0", "0cd52e" } } } },
  { name = "Lugia",      level = 7, types = { "Psychic", "Flying" }, moves = { "Future Sight", "Aeroblast" },     guids = { "5e4745" } },
  { name = "Ho-oh",      level = 7, types = { "Fire", "Flying" },    moves = { "Ancient Power", "Sacred Fire" },  guids = { "22569b" } },
  { name = "Celebi",     level = 7, types = { "Psychic", "Grass" },  moves = { "Solar Beam", "Psychic" },         guids = { "4d10a7" } },

  -- Mega evolutions.
  { name = "Mega Ampharos",     level = 5,    types = { "Electric" },   moves = { "Charge Beam", "Dragon Pulse" },guids = { "f282f0", "16d003" },            evoData = { { cost = 0, ball = YELLOW, gen = 2, ballGuid = "140fbd", guids = { "57b26e", "433542", "089edd" } } } },
  { name = "Mega Red Gyarados", level = 6,    types = { "Water" },      moves = { "Water Pulse", "Crunch" },      guids = { "bc99f5" },                      evoData = { { cost = 0, ball = YELLOW, gen = 2, ballGuid = "140fbd", guids = { "390ee2" } } } },     -- Thechnically gen II only.
  { name = "Mega Steelix",      level = 5,    types = { "Steel" },      moves = { "Earthquake", "Rock Slide" },   guids = { "8b5001", "86038a" },            evoData = { { cost = 0, ball = BLUE, gen = 2, ballGuid = "140fbd", guids = { "93482a", "9248b4" } } } },
  { name = "Mega Scizor",       level = 6,    types = { "Bug" },        moves = { "Night Slash", "X-Scissor" },   guids = { "ae958f", "1bb3d8" },            evoData = { { cost = 0, ball = RED, gen = 2, ballGuid = "140fbd", guids = { "7e05b1", "22e6a3" } } } },
  { name = "Mega Heracross",    level = 5,    types = { "Bug" },        moves = { "Close Combat", "Megahorn" },   guids = { "926476" },                      evoData = { { cost = 0, ball = BLUE, gen = 2, ballGuid = "140fbd", guids = { "6f8ffe" } } } },
  { name = "Mega Houndoom",     level = 5,    types = { "Dark" },       moves = { "Dark Pulse", "Inferno" },      guids = { "b27904", "41f460" },            evoData = { { cost = 0, ball = YELLOW, gen = 2, ballGuid = "140fbd", guids = { "5ef848", "cf82ee" } } } },
  { name = "Mega Tyranitar",    level = 7,    types = { "Rock" },       moves = { "Stone Edge", "Earthquake" },   guids = { "bb5cd0", "0cd52e" },            evoData = { { cost = 0, ball = RED, gen = 2, ballGuid = "140fbd", guids = { "d2d545", "7195d5", "5764be" } } } },
}

gen3PokemonData =
{
  -- Gen 3 252-300
  { name = "Treecko",    level = 1, types = { "Grass" },    moves = { "Quick Attack", "Absorb" },             guids = { "cd2a1e" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "71f6d0" } } } },
  { name = "Grovyle",    level = 3, types = { "Grass" },    moves = { "Leaf Blade", "Slam" },                 guids = { "fc07df", "71f6d0" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "6acdb2", "8d967c" } } } },
  { name = "Sceptile",   level = 5, types = { "Grass" },    moves = { "Solar Beam", "Iron Tail" },            guids = { "01d5b8", "6acdb2", "8d967c" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "3921c1", "3563ba" } } } },
  { name = "Torchic",    level = 1, types = { "Fire" },     moves = { "Ember", "Growl" },                     guids = { "dfac41" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "0d3fc1" } } } },
  { name = "Combusken",  level = 3, types = { "Fire" },     moves = { "Double Kick", "Blaze Kick" },          guids = { "af5888", "0d3fc1" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "6b6eaa", "e4fcc7" } } } },
  { name = "Blaziken",   level = 5, types = { "Fire" },     moves = { "Sky Uppercut", "Overheat" },           guids = { "b3e3d0", "6b6eaa", "e4fcc7" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "7b81ef", "641ef5" } } } },
  { name = "Mudkip",     level = 1, types = { "Water" },    moves = { "Mud-Slap", "Water Gun" },              guids = { "18d937" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "80e724" } } } },
  { name = "Marshtomp",  level = 3, types = { "Water" },    moves = { "Muddy Water", "Take Down" },           guids = { "9d8a4b", "80e724" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "0f2fe4", "93c652" } } } },
  { name = "Swampert",   level = 5, types = { "Water" },    moves = { "Hydro Pump", "Earthquake" },           guids = { "46c207", "0f2fe4", "93c652" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "f5dc2f", "045bc8" } } } },
  { name = "Poochyena",  level = 1, types = { "Dark" },     moves = { "Howl", "Tackle" },                     guids = { "484c8e" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "ad5677" } } } },
  { name = "Mightyena",  level = 3, types = { "Dark" },     moves = { "Take Down", "Crunch" },                guids = { "d14a45", "ad5677" } },
  { name = "Zigzagoon",  level = 1, types = { "Normal" },   moves = { "Sand Attack", "Tackle" },              guids = { "8effad" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "fea2c0" } } } },
  { name = "Linoone",    level = 3, types = { "Normal" },   moves = { "Fury Swipes", "Slash" },               guids = { "49547c", "fea2c0" } },
  { name = "Wurmple",    level = 1, types = { "Bug" },      moves = { "String Shot" },                        guids = { "3b1e3a" },                     evoData = { { cost = 1, ball = PINK, gen = 3, guids = { "3756cf" } }, { cost = 1, ball = PINK, gen = 3, guids = { "b2567d" } } } },
  { name = "Silcoon",    level = 2, types = { "Bug" },      moves = { "Harden", "Tackle" },                   guids = { "814073", "3756cf" },           evoData = { { cost = 1, ball = GREEN, gen = 3, guids = { "64e59c", "4a79ea" } } } },
  { name = "Beautifly",  level = 3, types = { "Bug" },      moves = { "Silver Wind", "Mega Drain" },          guids = { "f16171", "64e59c", "4a79ea" } },
  { name = "Cascoon",    level = 2, types = { "Bug" },      moves = { "Poison Sting", "Harden" },             guids = { "2e69ca", "b2567d" },           evoData = { { cost = 1, ball = GREEN, gen = 3, guids = { "bf6b7d", "2ee4fc" } } } },
  { name = "Dustox",     level = 3, types = { "Bug" },      moves = { "Silver Wind", "Light Screen" },        guids = { "f63e23", "bf6b7d", "2ee4fc" } },
  { name = "Lotad",      level = 1, types = { "Water" },    moves = { "Astonish", "Absorb" },                 guids = { "497b82" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "92c70d" } } } },
  { name = "Lombre",     level = 3, types = { "Water" },    moves = { "Fury Swipes", "Water Gun" },           guids = { "3081f1", "92c70d" },           evoData = { { cost = 1, ball = BLUE, gen = 3, guids = { "043d72", "6c7ae8" } } } },
  { name = "Ludicolo",   level = 4, types = { "Water" },    moves = { "Nature Power", "Razor Leaf" },         guids = { "8f090f", "043d72", "6c7ae8" } },
  { name = "Seedot",     level = 1, types = { "Grass" },    moves = { "Quick Attack", "Growth" },             guids = { "b3dcac" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "9e2cc8" } } } },
  { name = "Nuzleaf",    level = 3, types = { "Grass" },    moves = { "Extrasensory", "Fake Out" },           guids = { "489f1b", "9e2cc8" },           evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "f02406", "288090" } } } },
  { name = "Shiftry",    level = 5, types = { "Grass" },    moves = { "Nature Power", "Feint Attack" },       guids = { "eb4137", "f02406", "288090" } },
  -- Gen 3 276-300
  { name = "Taillow",    level = 2, types = { "Flying" },   moves = { "Growl", "Peck" },                      guids = { "93cbde" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "3e7919" } } } },
  { name = "Swellow",    level = 4, types = { "Flying" },   moves = { "Quick Attack", "Aerial Ace" },         guids = { "fd1fd2", "3e7919" } },
  { name = "Wingull",    level = 1, types = { "Water" },    moves = { "Water Gun", "Mist" },                  guids = { "018621" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "b53aec" } } } },
  { name = "Pelipper",   level = 3, types = { "Water" },    moves = { "Water Pulse", "Wing Attack" },         guids = { "3fd851", "b53aec" } },
  { name = "Ralts",      level = 1, types = { "Psychic" },  moves = { "Confusion" },                          guids = { "92ca7a" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "61a3fe" } } } },
  { name = "Kirlia",     level = 3, types = { "Psychic" },  moves = { "Will-O-Wisp", "Psychic" },             guids = { "260dd4", "61a3fe" },           evoData = { { cost = 2, ball = RED, gen = 4, guids = { "491632", "2956c7" } }, { cost = 2, ball = RED, gen = 3, guids = { "a58279", "9ef381" } } } },
  { name = "Gardevoir",  level = 5, types = { "Psychic" },  moves = { "Shock Wave", "Future Sight" },         guids = { "fe8f9a", "a58279", "9ef381" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "13d6a2", "7f7d21" } } } },
  { name = "Surskit",    level = 1, types = { "Bug" },      moves = { "Bubble" },                             guids = { "f47f95" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "899d71" } } } },
  { name = "Masquerain", level = 3, types = { "Bug" },      moves = { "Silver Wind", "Bubble Beam" },         guids = { "6f6a4b", "899d71" } },
  { name = "Shroomish",  level = 1, types = { "Grass" },    moves = { "Stun Spore", "Tackle" },               guids = { "afce65" },                     evoData = { { cost = 2, ball = GREEN, gen = 3, guids = { "b2b675" } } } },
  { name = "Breloom",    level = 3, types = { "Grass" },    moves = { "Dynamic Punch", "Mega Drain" },        guids = { "54f6b2", "b2b675" } },
  { name = "Slakoth",    level = 2, types = { "Normal" },   moves = { "Scratch" },                            guids = { "0e7e5b" },                     evoData = { { cost = 1, ball = BLUE, gen = 3, guids = { "bb497c" } } } },
  { name = "Vigoroth",   level = 3, types = { "Normal" },   moves = { "Counter", "Slash" },                   guids = { "167d17", "bb497c" },           evoData = { { cost = 3, ball = RED, gen = 3, guids = { "9e0b51", "eed73b" } } } },
  { name = "Slaking",    level = 6, types = { "Normal" },   moves = { "Feint Attack", "Covet" },              guids = { "beea0e", "9e0b51", "eed73b" } },
  { name = "Nincada",    level = 2, types = { "Bug" },      moves = { "Fury Swipes", "Mud-Slap" },            guids = { "6a52b9" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "2f18cb" } }, { cost = 2, ball = BLUE, gen = 3, guids = { "b9a6c3" } } } },
  { name = "Ninjask",    level = 4, types = { "Bug" },      moves = { "Swords Dance", "Leech Life" },         guids = { "5fca25", "2f18cb" } },
  { name = "Shedinja",   level = 4, types = { "Bug" },      moves = { "Shadow Ball", "Protect" },             guids = { "1a8813", "b9a6c3" } },
  { name = "Whismur",    level = 2, types = { "Normal" },   moves = { "Astonish", "Pound" },                  guids = { "86e898" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "9b89d3" } } } },
  { name = "Loudred",    level = 4, types = { "Normal" },   moves = { "Hyper Voice", "Screech" },             guids = { "c874a8", "9b89d3" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "f2324f", "5b1de6" } } } },
  { name = "Exploud",    level = 6, types = { "Normal" },   moves = { "Extrasensory", "Echoed Voice" },       guids = { "bebdb9", "f2324f", "5b1de6" } },
  { name = "Makuhita",   level = 2, types = { "Fighting" }, moves = { "Arm Thrust", "Tackle" },               guids = { "52f60d" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "9266af" } } } },
  { name = "Hariyama",   level = 4, types = { "Fighting" }, moves = { "Smelling Salts", "Vital Throw" },      guids = { "840d39", "9266af" } },
  { name = "Azurill",    level = 0, types = { "Normal" },   moves = { "Bubble" },                             guids = { "4132b8" },                     evoData = { { cost = 2, ball = GREEN, gen = 2, guids = { "e76d9a" } } } },
  { name = "Nosepass",   level = 3, types = { "Rock" },     moves = { "Thunder Wave", "Rock Throw" },         guids = { "d3a1d5" },                     evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "261bac" } } } },
  { name = "Skitty",     level = 2, types = { "Normal" },   moves = { "Double Slap", "Attract" },             guids = { "2ded89" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "9cca58" } } } },
  -- Gen 3 301-325
  { name = "Delcatty",   level = 4, types = { "Normal" },   moves = { "Double-Edge", "Feint Attack" },        guids = { "5498b5", "9cca58" } },
  { name = "Sableye",    level = 4, types = { "Dark" },     moves = { "Astonish", "Knock Off" },              guids = { "d0ddb7" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "ad6245" } } } },
  { name = "Mawile",     level = 4, types = { "Steel" },    moves = { "Iron Defense", "Crunch" },             guids = { "825f3c" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "901321" } } } },
  { name = "Aron",       level = 2, types = { "Steel" },    moves = { "Headbutt", "Mud-Slap" },               guids = { "2bdf79" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "1ad335" } } } },
  { name = "Lairon",     level = 4, types = { "Steel" },    moves = { "Metal Claw", "Rock Throw" },           guids = { "fc819f", "1ad335" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "19c95d", "037e57" } } } },
  { name = "Aggron",     level = 6, types = { "Steel" },    moves = { "Earthquake", "Iron Tail" },            guids = { "a5daad", "19c95d", "037e57" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "8f5016", "b94e60" } } } },
  { name = "Meditite",   level = 2, types = { "Fighting" }, moves = { "Hidden Power", "Detect" },             guids = { "8cae23" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "925a8f" } } } },
  { name = "Medicham",   level = 4, types = { "Fighting" }, moves = { "Confusion", "Brick Break" },           guids = { "1b2da9", "925a8f" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "19680e", "97834f" } } } },
  { name = "Electrike",  level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Quick Attack" },       guids = { "e37270" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "24b582" } } } },
  { name = "Manectric",  level = 4, types = { "Electric" }, moves = { "Thunder", "Bite" },                    guids = { "66eddf", "24b582" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "a96290", "70bf71" } } } },
  { name = "Plusle",     level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Spark" },              guids = { "78d266" } },
  { name = "Minun",      level = 2, types = { "Electric" }, moves = { "Quick Attack", "Spark" },              guids = { "37efd6" } },
  { name = "Volbeat",    level = 2, types = { "Bug" },      moves = { "Double-Edge", "Signal Beam" },         guids = { "b1d72d" } },
  { name = "Illumise",   level = 2, types = { "Bug" },      moves = { "Silver Wind", "Covet" },               guids = { "d3520a" } },
  { name = "Roselia",    level = 3, types = { "Grass" },    moves = { "Magical Leaf", "Body Slam" },          guids = { "6c4ab2", "7e165f" },           evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "4aa1de", "46f8dc" } } } },
  { name = "Gulpin",     level = 2, types = { "Poison" },   moves = { "Poison Gas", "Pound" },                guids = { "c08fc1" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "aac35d" } } } },
  { name = "Swalot",     level = 4, types = { "Poison" },   moves = { "Sludge Bomb", "Body Slam" },           guids = { "2a3068", "aac35d" } },
  { name = "Carvanha",   level = 2, types = { "Water" },    moves = { "Rage", "Bite" },                       guids = { "1f850b" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "7d206a" } } } },
  { name = "Sharpedo",   level = 4, types = { "Water" },    moves = { "Waterfall", "Crunch" },                guids = { "852350", "7d206a" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "3127db", "b7e979" } } } },
  { name = "Wailmer",    level = 3, types = { "Water" },    moves = { "Whirlpool", "Rollout" },               guids = { "bf7581" },                     evoData = { { cost = 2, ball = RED, gen = 3, guids = { "58fe14" } } } },
  { name = "Wailord",    level = 5, types = { "Water" },    moves = { "Body Slam", "Water Spout" },           guids = { "b1528a", "58fe14" } },
  { name = "Numel",      level = 2, types = { "Fire" },     moves = { "Take Down", "Ember" },                 guids = { "dda685" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "4bfb16" } } } },
  { name = "Camerupt",   level = 4, types = { "Fire" },     moves = { "Eruption", "Fissure" },                guids = { "2bbebf", "4bfb16" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "bc021e", "01cfea" } } } },
  { name = "Turkoal",    level = 3, types = { "Fire" },     moves = { "Flamethrower", "Iron Defense" },       guids = { "61c078" } },
  { name = "Spoink",     level = 2, types = { "Psychic" },  moves = { "Confuse Ray", "Magic Coat" },          guids = { "93357d" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "b51484" } } } },
  -- Gen 3 326-350
  { name = "Grumpig",    level = 4, types = { "Psychic" },  moves = { "Psywave", "Bounce" },                  guids = { "23135a", "b51484" } },
  { name = "Spinda",     level = 3, types = { "Normal" },   moves = { "Teeter Dance", "Thrash" },             guids = { "35a124" } },
  { name = "Trapich",    level = 2, types = { "Ground" },   moves = { "Sand Attack", "Bite" },                guids = { "4c47d2" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "17e4c4" } } } },
  { name = "Vibrava",    level = 4, types = { "Ground" },   moves = { "Crunch", "Dig" },                      guids = { "df1c5c", "17e4c4" },           evoData = { { cost = 2, ball = RED, gen = 3, guids = { "7bb147", "5974bb" } } } },
  { name = "Flygon",     level = 6, types = { "Ground" },   moves = { "Dragon Breath", "Sand Tomb" },         guids = { "7574b6", "7bb147", "5974bb" } },
  { name = "Cacnea",     level = 2, types = { "Grass" },    moves = { "Pin Missile", "Absorb" },              guids = { "62770e" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "16b950" } } } },
  { name = "Cactune",    level = 4, types = { "Grass" },    moves = { "Needle Arm", "Spikes" },               guids = { "f8b287", "16b950" } },
  { name = "Swablu",     level = 2, types = { "Flying" },   moves = { "Sing", "Peck" },                       guids = { "6b6c4b" },                     evoData = { { cost = 3, ball = RED, gen = 3, guids = { "d2b5c5" } } } },
  { name = "Altaria",    level = 5, types = { "Dragon" },   moves = { "Sky Attack", "Dragon Breath" },        guids = { "10ef80", "d2b5c5" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "de28d4", "bfe185" } } } },
  { name = "Zangoose",   level = 3, types = { "Normal" },   moves = { "Crush Claw", "False Swipe" },          guids = { "5b9f59" } },
  { name = "Seviper",    level = 3, types = { "Poison" },   moves = { "Poison Tail", "Glare" },               guids = { "b7456d" } },
  { name = "Lunatone",   level = 4, types = { "Rock" },     moves = { "Rock Throw", "Psychic" },              guids = { "79e4f0" } },
  { name = "Solrock",    level = 4, types = { "Rock" },     moves = { "Solar Beam", "Rock Slide" },           guids = { "563547" } },
  { name = "Barboach",   level = 3, types = { "Water" },    moves = { "Mud-Slap", "Water Gun" },              guids = { "3bd71b" },                     evoData = { { cost = 1, ball = YELLOW, gen = 3, guids = { "acc732" } } } },
  { name = "Whiscash",   level = 4, types = { "Water" },    moves = { "Future Sight", "Earthquake" },         guids = { "f40ebb", "acc732" } },
  { name = "Corpish",    level = 2, types = { "Water" },    moves = { "Bubble", "Leer" },                     guids = { "b159a5" },                     evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "193126" } } } },
  { name = "Crawdaunt",  level = 4, types = { "Water" },    moves = { "Crabhammer", "Knock Off" },            guids = { "cb83d3", "193126" } },
  { name = "Baltoy",     level = 2, types = { "Ground" },   moves = { "Ancient Power", "Rapid Spin" },        guids = { "9d4ab4" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "cadeb5" } } } },
  { name = "Claydol",    level = 4, types = { "Ground" },   moves = { "Hyper Beam", "Psybeam" },              guids = { "406223", "cadeb5" } },
  { name = "Lileep",     level = 2, types = { "Rock" },     moves = { "Confuse Ray", "Acid" },                guids = { "c92a11" },                     evoData = { { cost = 3, ball = RED, gen = 3, guids = { "87d1f8" } } } },
  { name = "Cradily",    level = 5, types = { "Rock" },     moves = { "Ancient Power", "Amnesia" },           guids = { "6d9326", "87d1f8" } },
  { name = "Anorith",    level = 2, types = { "Rock" },     moves = { "Rock Blast", "Water Gun" },            guids = { "8ac1a7" },                     evoData = { { cost = 3, ball = RED, gen = 3, guids = { "388697" } } } },
  { name = "Armaldo",    level = 5, types = { "Rock" },     moves = { "Ancient Power", "Fury Cutter" },       guids = { "7438a0", "388697" } },
  { name = "Feebas",     level = 3, types = { "Water" },    moves = { "Confuse Ray", "Tackle" },              guids = { "4e5c37" },                     evoData = { { cost = 2, ball = RED, gen = 3, guids = { "51191e" } } } },
  { name = "Milotic",    level = 5, types = { "Water" },    moves = { "Water Pulse", "Mirror Coat" },         guids = { "8933c3", "51191e" } },
  -- Gen 3 351-375
  { name = "Castform",   level = 3, types = { "Normal" },   moves = { "Future Sight", "Body Slam" },          guids = { "95eabc" } },
  { name = "Castform",   level = 3, types = { "Water" },    moves = { "Shock Wave", "Weather Ball Water" },   guids = { "4d93ae" } },
  { name = "Castform",   level = 3, types = { "Ice" },      moves = { "Shadow Ball", "Weather Ball Ice" },    guids = { "0a700e" } },
  { name = "Castform",   level = 3, types = { "Fire" },     moves = { "Solar Beam", "Weather Ball Fire" },    guids = { "1c9e4b" } },
  { name = "Kecleon",    level = 3, types = { "Normal" },   moves = { "Slash", "Thief" },                     guids = { "964da3" } },
  { name = "Shuppet",    level = 3, types = { "Ghost" },    moves = { "Will-O-Wisp", "Feint Attack" },        guids = { "7db1af" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "8da560" } } } },
  { name = "Banette",    level = 5, types = { "Ghost" },    moves = { "Shadow Ball", "Dark Pulse" },          guids = { "8845d6", "8da560" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "ff844c", "e69f55" } } } },
  { name = "Duskull",    level = 3, types = { "Ghost" },    moves = { "Confuse Ray", "Astonish" },            guids = { "937014" },                     evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "6ad885" } } } },
  { name = "Dusclops",   level = 5, types = { "Ghost" },    moves = { "Shadow Punch", "Future Sight" },       guids = { "d12d2a", "6ad885" },           evoData = { { cost = 1, ball = RED, gen = 4, guids = { "59c3d9", "0a1b22" } } } },
  { name = "Tropius",    level = 4, types = { "Grass" },    moves = { "Magical Leaf", "Gust" },               guids = { "bc8bd9" } },
  { name = "Chimecho",   level = 4, types = { "Psychic" },  moves = { "Psychic", "Heal Bell" },               guids = { "a3b83f", "a78de8" } },
  { name = "Absol",      level = 4, types = { "Dark" },     moves = { "Slash", "Bite" },                      guids = { "ae6097" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "bec9aa" } } } },
  { name = "Wynaut",     level = 1, types = { "Psychic" },  moves = { "Mirror Coat" },                        guids = { "00fb6f" },                     evoData = { { cost = 1, ball = GREEN, gen = 2, guids = { "0bbbae" } } } },
  { name = "Snorunt",    level = 3, types = { "Ice" },      moves = { "Powder Snow", "Bite" },                guids = { "ea6e1a" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "c7849b" } }, { cost = 2, ball = YELLOW, gen = 4, guids = { "f5d09d" } } } },
  { name = "Glalie",     level = 5, types = { "Ice" },      moves = { "Headbutt", "Ice Beam" },               guids = { "dda975", "c7849b" },           evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "863de0", "e7322f" } } } },
  { name = "Spheal",     level = 3, types = { "Ice" },      moves = { "Powder Snow", "Rollout" },             guids = { "2bdc76" },                     evoData = { { cost = 1, ball = YELLOW, gen = 2, guids = { "c38813" } } } },
  { name = "Sealleo",    level = 4, types = { "Ice" },      moves = { "Aurora Beam", "Water Gun" },           guids = { "3bb7d0", "c38813" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "3e2333", "cd24a1" } } } },
  { name = "Walrein",    level = 6, types = { "Ice" },      moves = { "Body Slam", "Blizzard" },              guids = { "426535", "3e2333", "cd24a1" } },
  { name = "Clamperl",   level = 3, types = { "Water" },    moves = { "Iron Defense", "Clamp" },              guids = { "e5e8a2" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "abf53c" } }, { cost = 2, ball = YELLOW, gen = 2, guids = { "f9ff3b" } } } },
  { name = "Huntail",    level = 5, types = { "Water" },    moves = { "Water Pulse", "Crunch" },              guids = { "c1decf", "abf53c" } },
  { name = "Gorebyss",   level = 5, types = { "Water" },    moves = { "Water Pulse", "Psychic" },             guids = { "3f3ac3", "f9ff3b" } },
  { name = "Relicanth",  level = 4, types = { "Water" },    moves = { "Ancient Power", "Waterfall" },         guids = { "4f27e5" } },
  { name = "Luvdisc",    level = 3, types = { "Water" },    moves = { "Sweet Kiss", "Water Gun" },            guids = { "ccfa1c" } },
  { name = "Bagon",      level = 3, types = { "Dragon" },   moves = { "Rage", "Bite" },                       guids = { "b2c277" },                     evoData = { { cost = 2, ball = YELLOW, gen = 2, guids = { "69d8be" } } } },
  { name = "Shelgon",    level = 5, types = { "Dragon" },   moves = { "Headbutt", "Crunch" },                 guids = { "bc895a", "69d8be" },           evoData = { { cost = 2, ball = RED, gen = 2, guids = { "5bca28", "c6ee70" } } } },
  { name = "Salamence",  level = 7, types = { "Dragon" },   moves = { "Dragon Claw", "Fly" },                 guids = { "17dd50", "5bca28", "c6ee70" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "896101", "d2f176" } } } },
  { name = "Beldum",     level = 2, types = { "Steel" },    moves = { "Take Down" },                          guids = { "ddca67" },                     evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "3292b4" } } } },
  { name = "Metang",     level = 4, types = { "Steel" },    moves = { "Metal Claw", "Confusion" },            guids = { "61c017", "3292b4" },           evoData = { { cost = 3, ball = RED, gen = 2, guids = { "566a44", "a7b544" } } } },
  -- Gen 3 376-386
  { name = "Metagross",  level = 7, types = { "Steel" },    moves = { "Meteor Mash", "Psychic" },             guids = { "b13068", "566a44", "a7b544" }, evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "e7382b", "90b29c" } } } },
  { name = "Regirock",   level = 7, types = { "Rock" },     moves = { "Ancient Power", "Superpower" },        guids = { "f0f700" } },
  { name = "Regice",     level = 7, types = { "Ice" },      moves = { "Zap Cannon", "Ice Beam" },             guids = { "3cc4aa" } },
  { name = "Registeel",  level = 7, types = { "Steel" },    moves = { "Flash Cannon", "Hyper Beam" },         guids = { "c73d22" } },
  { name = "Latias",     level = 7, types = { "Dragon" },   moves = { "Dragon Breath", "Mist Ball" },         guids = { "605532" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "5c8c7e" } } } },
  { name = "Latios",     level = 7, types = { "Dragon" },   moves = { "Dragon Breath", "Luster Purge" },      guids = { "2ef165" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "75de4c" } } } },
  { name = "Kyogre",     level = 7, types = { "Water" },    moves = { "Water Spout", "Ice Beam" },            guids = { "2fd702" },                     evoData = { { cost = "Blue Orb", ball = LEGENDARY, gen = 3, guids = { "b31acd" } } } },
  { name = "Primal Kyogre", level = 7, types = { "Water" }, moves = { "Ancient Power", "Origin Pulse" },      guids = { "b31acd" } },
  { name = "Groudon",    level = 7, types = { "Ground" },   moves = { "Earthquake", "Fire Blast" },           guids = { "ef5ee2" },                     evoData = { { cost = "Red Orb", ball = LEGENDARY, gen = 3, guids = { "0d318f" } } } },
  { name = "Primal Groudon", level = 7, types = { "Fire" }, moves = { "Precipise Blades", "Lava Plume" },     guids = { "0d318f" } },
  { name = "Rayquaza",   level = 7, types = { "Dragon" },   moves = { "Extreme Speed", "Dragon Claw" },       guids = { "3ae691" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 3, ballGuid = "140fbd", guids = { "45f389" } } } },
  { name = "Jirachi",    level = 7, types = { "Steel" },    moves = { "Doom Desire", "Psychic" },             guids = { "48d5bf" } },
  { name = "Droxys",     level = 7, types = { "Psychic" },  moves = { "Psycho Boost", "Night Shade" },        guids = { "f4e2fe" } },

  -- Mega evolutions.
  { name = "Mega Sceptile",     level = 6,    types = { "Grass" },   moves = { "Dual Chop", "Leaf Storm" },   guids = { "3921c1", "3563ba" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "01d5b8", "6acdb2", "8d967c" } } } },
  { name = "Mega Blaziken",     level = 6,    types = { "Fire" },    moves = { "Brave Bird", "Flare Blitz" }, guids = { "7b81ef", "641ef5" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "b3e3d0", "6b6eaa", "e4fcc7" } } } },
  { name = "Mega Swampert",     level = 6,    types = { "Water" },   moves = { "Focus Blast", "Scald" },      guids = { "f5dc2f", "045bc8" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "46c207", "0f2fe4", "93c652" } } } },
  { name = "Mega Gardevoir",    level = 6,    types = { "Psychic" }, moves = { "Magical Leaf", "Moonblast" }, guids = { "13d6a2", "7f7d21" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "fe8f9a", "a58279", "9ef381" } } } },
  { name = "Mega Sableye",      level = 5,    types = { "Dark" },    moves = { "Shadow Claw", "Dreameater" }, guids = { "ad6245" },                evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "d0ddb7" } } } },
  { name = "Mega Mawile",       level = 5,    types = { "Steel" },   moves = { "Play Rough", "Iron Head" },   guids = { "901321" },                evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "825f3c" } } } },
  { name = "Mega Aggron",       level = 7,    types = { "Steel" },   moves = { "Iron Head", "Sone Edge" },    guids = { "8f5016", "b94e60" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "a5daad", "19c95d", "037e57" } } } },
  { name = "Mega Medicham",     level = 5,    types = { "Fighting" },moves = { "Zen Headbutt", "Ice Punch" }, guids = { "19680e", "97834f" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "1b2da9", "925a8f" } } } },
  { name = "Mega Manectric",    level = 5,    types = { "Electric" },moves = { "Thunder Fang", "Hyper Beam" },guids = { "a96290", "70bf71" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "66eddf", "24b582" } } } },
  { name = "Mega Sharpedo",     level = 5,    types = { "Water" },   moves = { "Night Slash", "Scald" },      guids = { "3127db", "b7e979" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "852350", "7d206a" } } } },
  { name = "Mega Camerupt",     level = 5,    types = { "Fire" },    moves = { "Lava Plume", "Stone Edge" },  guids = { "bc021e", "01cfea" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "2bbebf", "4bfb16" } } } },
  { name = "Mega Altaria",      level = 6,    types = { "Dragon" },  moves = { "Moonblast", "Hurricane" },    guids = { "de28d4", "bfe185" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "10ef80", "d2b5c5" } } } },
  { name = "Mega Banette",      level = 6,    types = { "Ghost" },   moves = { "Dazzling Gleam", "Night Shade" },guids = { "ff844c", "e69f55" },   evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "8845d6", "8da560" } } } },
  { name = "Mega Absol",        level = 5,    types = { "Dark" },    moves = { "Night Slash", "Ice Beam" },   guids = { "bec9aa" },                evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "ae6097" } } } },
  { name = "Mega Glalie",       level = 6,    types = { "Ice" },     moves = { "Ice Fang", "Crunch" },        guids = { "863de0", "e7322f" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "dda975", "c7849b" } } } },
  { name = "Mega Metagross",    level = 7,    types = { "Steel" },   moves = { "Flash Cannon", "Hammer Arm" },guids = { "e7382b", "90b29c" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "b13068", "566a44", "a7b544" } } } },
  { name = "Mega Latios",       level = 7,    types = { "Dragon" },  moves = { "Dragon Claw", "Aerial Ace" }, guids = { "75de4c" },                evoData = { { cost = 0, ball = LEGENDARY, gen = 3, ballGuid = "140fbd", guids = { "2ef165" } } } },
  { name = "Mega Latias",       level = 7,    types = { "Dragon" },  moves = { "Dragon Pulse", "Aerial Ace" }, guids = { "5c8c7e" },               evoData = { { cost = 0, ball = LEGENDARY, gen = 3, ballGuid = "140fbd", guids = { "605532" } } } },
  { name = "Mega Rayquaza",     level = 7,    types = { "Dragon" },  moves = { "Dragon Ascent", "Dragon Pulse" },guids = { "45f389" },             evoData = { { cost = 0, ball = LEGENDARY, gen = 3, ballGuid = "140fbd", guids = { "3ae691" } } } },
  { name = "Mega Salamence",    level = 7,    types = { "Dragon" },  moves = { "Dragon Ascent", "Dragon Pulse" },guids = { "896101", "d2f176" },   evoData = { { cost = 0, ball = LEGENDARY, gen = 3, ballGuid = "140fbd", guids = { "17dd50", "5bca28", "c6ee70" } } } },
}

gen4PokemonData =
{
  -- Gen 4 387-400
  { name = "Turtwig",    level = 1, types = { "Grass" },    moves = { "Withdraw", "Tackle" },            guids = { "cacd94" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "ff1b43" } } } },
  { name = "Grotle",     level = 3, types = { "Grass" },    moves = { "Razor Leaf", "Bite" },            guids = { "20d958", "ff1b43" },                    evoData = { { cost = 2, ball = RED, gen = 4, guids = { "cfebcb", "3f2eaa" } } } },
  { name = "Torterra",   level = 5, types = { "Grass" },    moves = { "Leaf Storm", "Earthquake" },      guids = { "902030", "cfebcb", "3f2eaa" } },
  { name = "Chimchar",   level = 1, types = { "Fire" },     moves = { "Ember", "Taunt" },          guids = { "cd904d" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "8cd8f7" } } } },
  { name = "Monferno",   level = 3, types = { "Fire" },     moves = { "Flame Wheel", "Mach Punch" },     guids = { "2ba1c0", "8cd8f7" },                    evoData = { { cost = 2, ball = RED, gen = 4, guids = { "aa0bb2", "38ad9f" } } } },
  { name = "Infernape",  level = 5, types = { "Fire" },     moves = { "Close Combat", "Flare Blitz" },   guids = { "6c7166", "aa0bb2", "38ad9f" } },
  { name = "Piplup",     level = 1, types = { "Water" },    moves = { "Growl", "Peck" },                 guids = { "ad1a53" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "707fe1" } } } },
  { name = "PrinPlup",   level = 3, types = { "Water" },    moves = { "Bubble Beam", "Metal Claw" },     guids = { "7a3199", "707fe1" },                    evoData = { { cost = 2, ball = RED, gen = 4, guids = { "0e9d7b", "fe588c" } } } },
  { name = "Empoleon",   level = 5, types = { "Water" },    moves = { "Hydro Pump", "Drill Peck" },      guids = { "3cdce6", "0e9d7b", "fe588c" } },
  { name = "Starly",     level = 1, types = { "Flying" },   moves = { "Quick Attack", "Growl" },         guids = { "d5a011" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "4bb90a" } } } },
  { name = "Staravia",   level = 3, types = { "Flying" },   moves = { "Wing Attack", "Whirlwind" },      guids = { "54063f", "4bb90a" },                    evoData = { { cost = 2, ball = RED, gen = 4, guids = { "799437", "7ab20e" } } } },
  { name = "Staraptor",  level = 5, types = { "Flying" },   moves = { "Close Combat", "Brave Bird" },    guids = { "efc2ec", "799437", "7ab20e" } },
  { name = "Bidoof",     level = 1, types = { "Normal" },   moves = { "Defense Curl", "Rollout" },       guids = { "8d27fd" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "29158c" } } } },
  { name = "Bibarel",    level = 3, types = { "Normal" },   moves = { "Hyper Fang", "Water Gun" },       guids = { "56a0e9", "29158c" } },
  -- Gen 4 401-425
  { name = "Kricketot",  level = 1, types = { "Bug" },      moves = { "Growl" },                         guids = { "f48a32" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "9adb49" } } } },
  { name = "Kricketune", level = 3, types = { "Bug" },      moves = { "Night Slash", "Bug Buzz" },       guids = { "8351a3", "9adb49" } },
  { name = "Shinx",      level = 1, types = { "Electric" }, moves = { "Tackle", "Roar" },                guids = { "1215b7" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "fee2be" } } } },
  { name = "Luxio",      level = 3, types = { "Electric" }, moves = { "Discharge", "Bite" },             guids = { "bfac8d", "fee2be" },                    evoData = { { cost = 1, ball = YELLOW, gen = 4, guids = { "d7fc60", "782359" } } } },
  { name = "Luxray",     level = 4, types = { "Electric" }, moves = { "Thunder Fang", "Crunch" },        guids = { "dbd6ac", "d7fc60", "782359" } },
  { name = "Budew",      level = 1, types = { "Grass" },    moves = { "Stun Spore", "Absorb" },          guids = { "235bf8" },                              evoData = { { cost = 2, ball = BLUE, gen = 3, guids = { "7e165f" } } } },
  { name = "Roserade",   level = 5, types = { "Grass" },    moves = { "Sludge Bomb", "Leaf Storm" },     guids = { "dbf33b", "4aa1de", "46f8dc" } },
  { name = "Cranidos",   level = 2, types = { "Rock" },     moves = { "Assurance", "Headbutt" },         guids = { "e230a3" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "9bc735" } } } },
  { name = "Rampardos",  level = 4, types = { "Rock" },     moves = { "Zen Headbutt", "Head Smash" },    guids = { "fa103e", "9bc735" } },
  { name = "Shieldon",   level = 2, types = { "Rock" },     moves = { "Metal Sound", "Taunt" },          guids = { "f7d63e" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "c13d61" } } } },
  { name = "Bastiodon",  level = 4, types = { "Rock" },     moves = { "Ancient Power", "Iron Head" },    guids = { "904ec7", "c13d61" } },
  { name = "Burmy",      level = 1, types = { "Bug" },      moves = { "Hidden Power" },                  guids = { "5d3c35" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "679480", "0cf537", "bdc120" } }, { cost = 2, ball = GREEN, gen = 4, guids = { "50757b" } } } }, -- Sandy
  { name = "Burmy",      level = 1, types = { "Bug" },      moves = { "Hidden Power" },                  guids = { "398f3a" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "679480", "0cf537", "bdc120" } }, { cost = 2, ball = GREEN, gen = 4, guids = { "b53138" } } } }, -- Plant
  { name = "Burmy",      level = 1, types = { "Bug" },      moves = { "Hidden Power" },                  guids = { "ebd97a" },                              evoData = { { cost = 2, ball = GREEN, gen = 4, guids = { "679480", "0cf537", "bdc120" } }, { cost = 2, ball = GREEN, gen = 4, guids = { "2ed231" } } } }, -- Trash
  { name = "Mothim",     level = 3, types = { "Bug" },      moves = { "Silver Wind", "Air Slash" },      guids = { "f97f24", "679480", "0cf537", "bdc120" } },
  { name = "Wormadam",   level = 3, types = { "Ground" },   moves = { "Bug Bite", "Psychic" },           guids = { "1f8c4d", "50757b" } },                                                                                                                                                                            -- Sandy
  { name = "Wormadam",   level = 3, types = { "Grass" },    moves = { "Razor Leaf", "Bug Bite" },        guids = { "ae14d4", "b53138" } },                                                                                                                                                                            -- Plant
  { name = "Wormadam",   level = 3, types = { "Steel" },    moves = { "Mirror Shot", "Bug Bite" },       guids = { "9bfe68", "2ed231" } },                                                                                                                                                                            -- Trash
  { name = "Combee",     level = 2, types = { "Bug" },      moves = { "Gust" },                          guids = { "1e577e" },                              evoData = { { cost = 1, ball = BLUE, gen = 4, guids = { "caab8e" } } } },
  { name = "Vespiquen",  level = 3, types = { "Bug" },      moves = { "Attack Order", "Power Gem" },     guids = { "13494d", "caab8e" } },
  { name = "Pachirisu",  level = 2, types = { "Electric" }, moves = { "Spark", "Swift" },                guids = { "bc8f33" } },
  { name = "Buizel",     level = 2, types = { "Water" },    moves = { "Sonic Boom", "Aqua Jet" },        guids = { "445666" },                              evoData = { { cost = 1, ball = GREEN, gen = 4, guids = { "4e2c8a" } } } },
  { name = "Floatzel",   level = 3, types = { "Water" },    moves = { "Razor Wind", "Whirlpool" },       guids = { "d3a821", "4e2c8a" } },
  { name = "Cherubi",    level = 2, types = { "Grass" },    moves = { "Growth", "Tackle" },              guids = { "d8ddcb" },                              evoData = { { cost = 1, ball = GREEN, gen = 4, guids = { "c2a7bd" } } } },
  { name = "Cherrim",    level = 3, types = { "Grass" },    moves = { "Take Down", "Solar Beam" },       guids = { "72c4b8", "c2a7bd" } },
  { name = "Shellos",    level = 2, types = { "Water" },    moves = { "Trump Card", "Counter" },         guids = { "aa6021" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "9cf8af" } } } },
  { name = "Shellos",    level = 2, types = { "Water" },    moves = { "Mirror Coat", "Mud-Slap" },       guids = { "45b543" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "ad747a" } } } },
  { name = "Gastrodon",  level = 4, types = { "Water" },    moves = { "Mud Bomb", "Body Slam" },         guids = { "8d67bb", "9cf8af" } },
  { name = "Gastrodon",  level = 4, types = { "Water" },    moves = { "Muddy Water", "Hidden Power" },   guids = { "dc4e3a", "ad747a" } },
  { name = "Ambipom",    level = 4, types = { "Normal" },   moves = { "Double Hit", "Nasty Plot" },      guids = { "892365", "06f1a9" } },
  { name = "Drifloon",   level = 2, types = { "Ghost" },    moves = { "Astonish", "Gust" },              guids = { "04345a" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "f87c2e" } } } },
  -- Gen 4 426-450
  { name = "Drifblim",   level = 4, types = { "Ghost" },    moves = { "Ominous Wind", "Explosion" },     guids = { "36bed9", "f87c2e" } },
  { name = "Buneary",    level = 2, types = { "Normal" },   moves = { "Quick Attack", "Jump Kick" },     guids = { "73996a" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "1d4012" } } } },
  { name = "Lopunny",    level = 4, types = { "Normal" },   moves = { "Dizzy Punch", "Bounce" },         guids = { "ca0de0", "1d4012" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 4, ballGuid = "140fbd", guids = { "782df2", "c8a630" } } } },
  { name = "Mismagius",  level = 5, types = { "Ghost" },    moves = { "Shadow Sneak", "Power Gem" },     guids = { "f0ec65", "496256" } },
  { name = "Honchkrow",  level = 4, types = { "Dark" },     moves = { "Wing Attack", "Dark Pulse" },     guids = { "a76d5e", "4f1558" } },
  { name = "Glameow",    level = 2, types = { "Normal" },   moves = { "Fury Swipes", "Charm" },          guids = { "c31fe7" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "468535" } } } },
  { name = "Purugly",    level = 4, types = { "Normal" },   moves = { "Sucker Punch", "Slash" },         guids = { "739efa", "468535" } },
  { name = "Chingling",  level = 2, types = { "Psychic" },  moves = { "Confusion", "Wrap" },             guids = { "3c321b" },                              evoData = { { cost = 2, ball = YELLOW, gen = 3, guids = { "a78de8" } } } },
  { name = "Stunky",     level = 2, types = { "Poison" },   moves = { "Poison Gas", "Scratch" },         guids = { "350900" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "ce1be6" } } } },
  { name = "Skuntank",   level = 4, types = { "Poison" },   moves = { "Flamethrower", "Night Slash" },   guids = { "b80e55", "ce1be6" } },
  { name = "Bronzor",    level = 2, types = { "Steel" },    moves = { "Confuse Ray", "Confusion" },      guids = { "76ab01" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "793185" } } } },
  { name = "Bronzong",   level = 4, types = { "Steel" },    moves = { "Extrasensory", "Iron Head" },     guids = { "c70883", "793185" } },
  { name = "Bonsly",     level = 1, types = { "Rock" },     moves = { "Fake Tears" },                    guids = { "992ede" },                              evoData = { { cost = 2, ball = GREEN, gen = 2, guids = { "eeca81" } } } },
  { name = "Mime Jr.",   level = 1, types = { "Psychic" },  moves = { "Double Slap" },                   guids = { "6a4ef5" },                              evoData = { { cost = 2, ball = GREEN, gen = 1, guids = { "8315de" } }, { cost = 2, ball = GREEN, gen = 8, guids = { "8cfe98" } } } },
  { name = "Happiny",    level = 1, types = { "Normal" },   moves = { "Pound" },                         guids = { "f6fbf5" },                              evoData = { { cost = 3, ball = YELLOW, gen = 1, guids = { "ee10ff" } } } },
  { name = "Chatot",     level = 3, types = { "Flying" },   moves = { "Hyper Voice", "Chatter" },        guids = { "85be31" } },
  { name = "Spiritomb",  level = 3, types = { "Ghost" },    moves = { "Shadow Sneak", "Dark Pulse" },    guids = { "3ade63" } },
  { name = "Gible",      level = 2, types = { "Dragon" },   moves = { "Sand Attack", "Tackle" },         guids = { "190d89" },                              evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "9b47dd" } } } },
  { name = "Gabite",     level = 4, types = { "Dragon" },   moves = { "Dragon Rage", "Take Down" },      guids = { "75db3d", "9b47dd" },                    evoData = { { cost = 3, ball = RED, gen = 4, guids = { "998146", "935739" } } } },
  { name = "Garchomp",   level = 7, types = { "Dragon" },   moves = { "Dragon Rush", "Slash" },          guids = { "16aa2c", "998146", "935739" },          evoData = { { cost = "Mega", ball = MEGA, gen = 4, ballGuid = "140fbd", guids = { "c45879", "e044da" } } } },
  { name = "Munchlax",   level = 2, types = { "Normal" },   moves = { "Tackle", "Lick" },                guids = { "ca2ab3" },                              evoData = { { cost = 2, ball = BLUE, gen = 1, guids = { "a017f9" } } } },
  { name = "Riolu",      level = 2, types = { "Fighting" }, moves = { "Quick Attack", "Counter" },       guids = { "7bef81" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "153e4f" } } } },
  { name = "Lucario",    level = 4, types = { "Fighting" }, moves = { "Dragon Pulse", "Force Palm" },    guids = { "cd3901", "153e4f" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 4, ballGuid = "140fbd", guids = { "c203c6", "95d4d4" } } } },
  { name = "Hippopotas", level = 2, types = { "Ground" },   moves = { "Sand Attack", "Take Down" },      guids = { "48588f" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "5f7329" } } } },
  { name = "Hippowdon",  level = 4, types = { "Ground" },   moves = { "Earthquake", "Crunch" },          guids = { "073c65", "5f7329" } },
  -- Gen 4 451-475
  { name = "Skorupi",    level = 2, types = { "Poison" },   moves = { "Poison Fang", "Pin Missile" },    guids = { "12a4d7" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "2cdfe7" } } } },
  { name = "Drapion",    level = 4, types = { "Poison" },   moves = { "Cross Poison", "Crunch" },        guids = { "7faa88", "2cdfe7" } },
  { name = "Croagunk",   level = 2, types = { "Poison" },   moves = { "Mud-Slap", "Pursuit" },           guids = { "8a87c5" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "edeba6" } } } },
  { name = "Toxicroak",  level = 4, types = { "Poison" },   moves = { "Poison Jab", "Revenge" },         guids = { "2f6517", "edeba6" } },
  { name = "Carnivine",  level = 3, types = { "Grass" },    moves = { "Power Whip", "Feint Attack" },    guids = { "6ae25c" } },
  { name = "Finneon",    level = 2, types = { "Water" },    moves = { "Water Gun", "Attract" },          guids = { "4e7881" },                              evoData = { { cost = 2, ball = YELLOW, gen = 4, guids = { "eff442" } } } },
  { name = "Lumineon",   level = 4, types = { "Water" },    moves = { "Water Pulse", "U-Turn" },         guids = { "5e8443", "eff442" } },
  { name = "Mantyke",    level = 1, types = { "Water" },    moves = { "Supersonic", "Bubble" },          guids = { "ea3133" },                              evoData = { { cost = 2, ball = BLUE, gen = 2, guids = { "6fd093" } } } },
  { name = "Snover",     level = 4, types = { "Ice" },      moves = { "Powder Snow", "Razor Leaf" },     guids = { "770f5b" },                              evoData = { { cost = 2, ball = RED, gen = 4, guids = { "985066" } } } },
  { name = "Abomasnow",  level = 6, types = { "Ice" },      moves = { "Wood Hammer", "Ice Punch" },      guids = { "fc423f", "985066" },                    evoData = { { cost = "Mega", ball = MEGA, gen = 4, ballGuid = "140fbd", guids = { "c0f0bc", "72076f" } } } },
  { name = "Weavile",    level = 4, types = { "Dark" },     moves = { "Dark Pulse", "Icy Wind" },        guids = { "57a02c", "9b517e" } },
  { name = "Magnezone",  level = 6, types = { "Electric" }, moves = { "Zap Cannon", "Mirror Shot" },     guids = { "c53a51", "dedadf", "618210" } },
  { name = "Lickilicky", level = 5, types = { "Normal" },   moves = { "Power Whip", "Me First" },        guids = { "dc8977", "5d1069" } },
  { name = "Rhyperior",  level = 7, types = { "Rock" },     moves = { "Rock Wrecker", "Megahorn" },      guids = { "ee964b", "1665fe", "f2b985" } },
  { name = "Tangrowth",  level = 4, types = { "Grass" },    moves = { "Ancient Power", "Power Whip" },   guids = { "c5ddd7", "5965cd" } },
  { name = "Electivire", level = 6, types = { "Electric" }, moves = { "Giga Impact", "Thunder" },        guids = { "6787dc", "11f593", "896d6e" } },
  { name = "Magmortar",  level = 6, types = { "Fire" },     moves = { "Lava Plume", "Hyper Beam" },      guids = { "f7000a", "bc96fe", "ebafae" } },
  { name = "Togekiss",   level = 4, types = { "Fairy" },    moves = { "Aura Sphere", "Air Slash" },      guids = { "d9bab2", "020ecc", "3786d0" } },
  { name = "Yanmega",    level = 4, types = { "Bug" },      moves = { "Night Slash", "Air Slash" },      guids = { "040022", "e093cb" } },
  { name = "Leafeon",    level = 5, types = { "Grass" },    moves = { "Leaf Blade", "Fury Cutter" },     guids = { "e6b356", "25ef7b" } },
  { name = "Glaceon",    level = 5, types = { "Ice" },      moves = { "Aqua Tail", "Ice Fang" },         guids = { "d990cc", "549166" } },
  { name = "Gliscor",    level = 5, types = { "Ground" },   moves = { "Poison Jab", "X-Scissor" },       guids = { "9344ba", "96a4fa" } },
  { name = "Mamoswine",  level = 6, types = { "Ice" },      moves = { "Earthquake", "Blizzard" },        guids = { "ae18c1", "bac5e2", "3e9a5e" } },
  { name = "Porygon-Z",  level = 5, types = { "Normal" },   moves = { "Zap Cannon", "Hyper Beam" },      guids = { "8b5275", "89624f", "ccdbee" } },
  { name = "Gallade",    level = 5, types = { "Psychic" },  moves = { "Close Combat", "Psycho Cut" },    guids = { "e00be3", "491632", "2956c7" },          evoData = { { cost = "Mega", ball = MEGA, gen = 4, ballGuid = "140fbd", guids = { "762e3d", "f77da3" } } } },
  -- Gen 4 476-493
  { name = "Probopass",  level = 5, types = { "Rock" },     moves = { "Magnet Bomb", "Stone Edge" },     guids = { "c36f28", "261bac" } },
  { name = "Dusknoir",   level = 6, types = { "Ghost" },    moves = { "Shadow Punch", "Seismic Toss" },  guids = { "40e69b", "59c3d9", "0a1b22" } },
  { name = "Frosslass",  level = 5, types = { "Ice" },      moves = { "Ominous Wind", "Ice Fang" },      guids = { "44d36b", "f5d09d" } },
  { name = "Rotom",      level = 3, types = { "Electric" }, moves = { "Ominous Wind", "Thunder Shock" }, guids = { "631643" } },
  { name = "Rotom",      level = 3, types = { "Electric" }, moves = { "Ominous Wind", "Leaf Storm" },    guids = { "9c2b53" } },
  { name = "Rotom",      level = 3, types = { "Electric" }, moves = { "Ominous Wind", "Overheat" },      guids = { "119ba7" } },
  { name = "Rotom",      level = 3, types = { "Electric" }, moves = { "Ominous Wind", "Hydro Pump" },    guids = { "e60f49" } },
  { name = "Rotom",      level = 3, types = { "Electric" }, moves = { "Ominous Wind", "Air Slash" },     guids = { "2fc387" } },
  { name = "Rotom",      level = 3, types = { "Electric" }, moves = { "Ominous Wind", "Blizzard" },      guids = { "313204" } },
  { name = "Uxie",       level = 7, types = { "Psychic" },  moves = { "Thunder Punch", "Psychic" },      guids = { "7161bc" } },
  { name = "Mesprit",    level = 7, types = { "Psychic" },  moves = { "Extrasensory", "Fire Punch" },    guids = { "206d05" } },
  { name = "Azelf",      level = 7, types = { "Psychic" },  moves = { "Zen Headbutt", "Ice Punch" },     guids = { "51e346" } },
  { name = "Dialga",     level = 7, types = { "Steel" },    moves = { "Flash Cannon", "Roar of Time" },  guids = { "99da0e" } },
  { name = "Palkia",     level = 7, types = { "Water" },    moves = { "Spacial Rend", "Aqua Tail" },     guids = { "99bbae" } },
  { name = "Heatran",    level = 7, types = { "Fire" },     moves = { "Magma Storm", "Earth Power" },    guids = { "d6bd2b" } },
  { name = "Regigigas",  level = 7, types = { "Normal" },   moves = { "Dizzy Punch", "Revenge" },        guids = { "04ae8e" } },
  { name = "Giratina",   level = 7, types = { "Dragon" },    moves = { "Shadow Claw", "Dragon Claw" },   guids = { "e1ea2d" } },
  { name = "Cresselia",  level = 7, types = { "Psychic" },  moves = { "Aurora Beam", "Psycho Cut" },     guids = { "d22af4" } },
  { name = "Phione",     level = 5, types = { "Water" },    moves = { "Acid Armor", "Dive" },            guids = { "3379b4" } },
  { name = "Manaphy",    level = 7, types = { "Water" },    moves = { "Water Pulse", "Tail Glow" },      guids = { "4eb57f" } },
  { name = "Darkrai",    level = 7, types = { "Dark" },     moves = { "Dream Eater", "Dark Pulse" },     guids = { "dd87aa" } },
  { name = "Shaymin",    level = 7, types = { "Flying" },    moves = { "Magical Leaf", "Air Slash" },    guids = { "215c3b" } },
  { name = "Arceus",     level = 7, types = { "Normal" },   moves = { "Earth Power", "Judgement" },      guids = { "fbb914" } },

  -- Mega evolutions.
  { name = "Mega Lopunny",     level = 5,    types = { "Normal" },moves = { "High Jump Kick", "Mega Kick" }, guids = { "782df2", "c8a630" },      evoData = { { cost = 0, ball = BLUE, gen = 3, ballGuid = "140fbd", guids = { "ca0de0", "1d4012" } } } },
  { name = "Mega Garchomp",    level = 7,    types = { "Dragon" },moves = { "Dragon Claw", "Stone Edge" },   guids = { "c45879", "e044da" },      evoData = { { cost = 0, ball = RED, gen = 3, ballGuid = "140fbd", guids = { "16aa2c", "998146", "935739" } } } },
  { name = "Mega Lucario",     level = 5,    types = { "Fighting" },moves = { "Dragon Claw", "Stone Edge" }, guids = { "c203c6", "95d4d4" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "cd3901", "153e4f" } } } },
  { name = "Mega Abomasnow",   level = 7,    types = { "Grass" }, moves = { "Focus Blast", "Blizzard" },     guids = { "c0f0bc", "72076f" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "fc423f", "985066" } } } },
  { name = "Mega Gallade",     level = 6,    types = { "Psychic" }, moves = { "Focus Blast", "Night Slash" },guids = { "762e3d", "f77da3" },      evoData = { { cost = 0, ball = YELLOW, gen = 3, ballGuid = "140fbd", guids = { "e00be3", "491632", "2956c7" } } } },
}

gen5PokemonData =
{
  -- Gen 5 494-526
  { name = "Victini",         level = 7, types = { "Psychic" },  moves = { "Zen Headbutt", "Searing Shot" },   guids = { "49fa0d" }, },
  { name = "Snivy",           level = 1, types = { "Grass" },    moves = { "Vine Whip", "Tackle" },            guids = { "bd4952" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "98096d" } } } },
  { name = "Servine",         level = 3, types = { "Grass" },    moves = { "Leaf Tornado", "Wrap" },           guids = { "e2e93d", "98096d" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "1934f3", "66a00d" } } } },
  { name = "Serperior",       level = 5, types = { "Grass" },    moves = { "Leaf Storm", "Coil" },             guids = { "1934f3", "2dc582", "66a00d" }, },
  { name = "Tepig",           level = 1, types = { "Fire" },     moves = { "Ember", "Tackle" },                guids = { "b8c770" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "14b2e7", } } } },
  { name = "Pignite",         level = 3, types = { "Fire" },     moves = { "Arm Thrust", "Flame Charge" },     guids = { "14b2e7", "d214c9" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "666751", "5d555c" } } } },
  { name = "Emboar",          level = 5, types = { "Fire" },     moves = { "Hammer Arm", "Flare Blitz" },      guids = { "e51210", "666751", "5d555c" }, },
  { name = "Oshawott",        level = 1, types = { "Water" },    moves = { "Water Gun", "Tackle" },            guids = { "4c80d6" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "1eef77" } } } },
  { name = "Dewott",          level = 3, types = { "Water" },    moves = { "Fury Cutter", "Aqua Jet" },        guids = { "89e6b6", "1eef77" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "d8975e", "49d4d0" } }, { cost = 2, ball = RED, gen = 8, guids = { "769c18", "c7dc10" } } } },
  { name = "Samurott",        level = 5, types = { "Water" },    moves = { "Razor Shell", "Aerial Ace" },      guids = { "8d6f8e", "d8975e", "49d4d0" }, },
  { name = "Patrat",          level = 1, types = { "Normal" },   moves = { "Bite", "Leer" },                   guids = { "8c09ef" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "fd2a3f" } } } },
  { name = "Watchog",         level = 3, types = { "Normal" },   moves = { "Hyper Fang", "Detect" },           guids = { "509c3b", "fd2a3f" } },
  { name = "Lillipup",        level = 1, types = { "Normal" },   moves = { "Odor Sleuth", "Tackle" },          guids = { "d5ebdb" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "408da5" } } } },
  { name = "Herdier",         level = 3, types = { "Normal" },   moves = { "Take Down", "Bite" },              guids = { "a02c78", "408da5" },           evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "4e8f54", "52057b" } } } },
  { name = "Stoutland",       level = 5, types = { "Normal" },   moves = { "Giga Impact", "Crunch" },          guids = { "cb77e7", "4e8f54", "52057b" } },
  { name = "Purrloin",        level = 1, types = { "Dark" },     moves = { "Fury Swipes", "Assurance" },       guids = { "c28158" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "5a5d10" } } } },
  { name = "Liepard",         level = 3, types = { "Dark" },     moves = { "Hone Claws", "Slash" },            guids = { "3f7259", "5a5d10" } },
  { name = "Pansage",         level = 2, types = { "Grass" },    moves = { "Fury Swipes", "Vine Whip" },       guids = { "eec2b1" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "23924b" } } } },
  { name = "Simisage",        level = 3, types = { "Grass" },    moves = { "Seed Bomb", "Bite" },              guids = { "a6b59b", "23924b" } },
  { name = "Pansear",         level = 2, types = { "Fire" },     moves = { "Fury Swipes", "Flame Charge" },    guids = { "2597b5" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "404ff7" } } } },
  { name = "Simisear",        level = 3, types = { "Fire" },     moves = { "Flame Burst", "Bite" },            guids = { "265b2a", "404ff7" } },
  { name = "Panpour",         level = 2, types = { "Water" },    moves = { "Fury Swipes", "Water Gun" },       guids = { "3da3a1" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "a0d19e" } } } },
  { name = "Simipour",        level = 3, types = { "Water" },    moves = { "Scald", "Bite" },                  guids = { "c8641e", "a0d19e" }, },
  { name = "Munna",           level = 2, types = { "Psychic" },  moves = { "Psywave", "Yawn" },                guids = { "3c0505" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "198c08" } } } },
  { name = "Musharna",        level = 3, types = { "Psychic" },  moves = { "Hypnosis", "Psybeam" },            guids = { "91179d", "198c08" }, },
  { name = "Pidove",          level = 1, types = { "Flying" },   moves = { "Growl", "Gust" },                  guids = { "723bbc" },                     evoData = { { cost = 2, ball = GREEN, gen = 5, guids = { "fa3490" } } } },
  { name = "Tranquil",        level = 3, types = { "Flying" },   moves = { "Feather Dance", "Razor Wind" },    guids = { "3d420b", "fa3490" },           evoData = { { cost = 1, ball = YELLOW, gen = 5, guids = { "c37df9", "3bbd1b" } } } },
  { name = "Unfezant",        level = 4, types = { "Flying" },   moves = { "Air Slash", "Facade" },            guids = { "f71153", "c37df9", "3bbd1b" }, },
  { name = "Blitzle",         level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Flame Charge" },   guids = { "c3f811" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "a00b30" } } } },
  { name = "Zebstrika",       level = 4, types = { "Electric" }, moves = { "Wild Charge", "Stomp" },           guids = { "718d9a", "a00b30" }, },
  { name = "Roggenrola",      level = 2, types = { "Rock" },     moves = { "Sand Attack", "Headbutt" },        guids = { "f96286" },                     evoData = { { cost = 2, ball = GREEN, gen = 5, guids = { "fb2577" } } } },
  { name = "Boldore",         level = 4, types = { "Rock" },     moves = { "Rock Blast", "Iron Defense" },     guids = { "28e251", "fb2577" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "826c9d", "f3f8a9" } } } },
  { name = "Gigalith",        level = 6, types = { "Rock" },     moves = { "Sandstorm", "Rock Slide" },        guids = { "6c7072", "826c9d", "f3f8a9" }, },
  -- Gen 5 527-550
  { name = "Woobat",          level = 1, types = { "Psychic" },  moves = { "Confusion", "Odor Sleuth" },       guids = { "6264c2" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "8f6353" } } } },
  { name = "Swoobat",         level = 3, types = { "Psychic" },  moves = { "Heart Stamp", "Gust" },            guids = { "a3b9cf", "8f6353" } },
  { name = "Drilbur",         level = 2, types = { "Ground" },   moves = { "Fury Swipes", "Mud-Slap" },        guids = { "b7fbbf" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "777dd0" } } } },
  { name = "Excadril",        level = 4, types = { "Ground" },   moves = { "Metal Claw", "Dig" },              guids = { "8ce447", "777dd0" }, },
  { name = "Audino",          level = 4, types = { "Normal" },   moves = { "Take Down", "Attract" },           guids = { "b81637" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 5, ballGuid = "140fbd", guids = { "0c7909" } } } },
  { name = "Timburr",         level = 2, types = { "Fighting" }, moves = { "Low Kick", "Leer" },               guids = { "89aae4" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "e8de1c" } } } },
  { name = "Gurdurr",         level = 4, types = { "Fighting" }, moves = { "Dynamic Punch", "Chip Away" },     guids = { "84d209", "e8de1c" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "2c58d6", "36840e" } } } },
  { name = "Conkeldurr",      level = 6, types = { "Fighting" }, moves = { "Hammer Arm", "Stone Edge" },       guids = { "29c9eb", "2c58d6", "36840e" } },
  { name = "Tympole",         level = 2, types = { "Water" },    moves = { "Supersonic", "Bubble" },           guids = { "348d4f" },                     evoData = { { cost = 2, ball = BLUE, gen = 4, guids = { "18532d" } } } },
  { name = "Palpitoad",       level = 4, types = { "Water" },    moves = { "Echoed Voice", "Bubble Beam" },    guids = { "fd66e4", "18532d" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "a738c3", "373635" } } } },
  { name = "Seismitoad",      level = 5, types = { "Water" },    moves = { "Muddy Water", "Mud Shot " },       guids = { "578f18", "a738c3", "373635" } },
  { name = "Throh",           level = 4, types = { "Fighting" }, moves = { "Bulk Up", "Seismic Toss" },        guids = { "72fcf5" }, },
  { name = "Sawk",            level = 4, types = { "Fighting" }, moves = { "Bulk Up", "Counter" },             guids = { "15a56f" }, },
  { name = "Sewaddle",        level = 1, types = { "Bug" },      moves = { "String Shot", "Tackle" },          guids = { "1e8149" },                     evoData = { { cost = 1, ball = GREEN, gen = 5, guids = { "013008" } } } },
  { name = "Swadloon",        level = 2, types = { "Bug" },      moves = { "Struggle Bug", "Protect" },        guids = { "434424", "013008" },           evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "fe4a27", "7e7b85" } } } },
  { name = "Leavanny",        level = 4, types = { "Bug" },      moves = { "Leaf Blade", "X-Scissor" },        guids = { "e12b22", "fe4a27", "7e7b85" } },
  { name = "Venipede",        level = 2, types = { "Bug" },      moves = { "Poison Sting", "Defense Curl" },   guids = { "98f18f" },                     evoData = { { cost = 1, ball = BLUE, gen = 5, guids = { "703d36" } } } },
  { name = "Whirlipede",      level = 3, types = { "Bug" },      moves = { "Rollout", "Protect" },             guids = { "562f04", "703d36" },           evoData = { { cost = 1, ball = YELLOW, gen = 5, guids = { "c997bd", "ae213b" } } } }, -- Trash
  { name = "Scolipede",       level = 4, types = { "Bug" },      moves = { "Poison Tail", "Steamroller" },     guids = { "111f3c", "c997bd", "ae213b" } },
  { name = "Cottonee",        level = 2, types = { "Grass" },    moves = { "Stun Spore", "Growth" },           guids = { "e12ddb" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "4f1ca9" } } } },
  { name = "Whimsicott",      level = 4, types = { "Grass" },    moves = { "Moonblast", "Gust" },              guids = { "5a123d", "4f1ca9" } },
  { name = "Petilil",         level = 2, types = { "Grass" },    moves = { "Growth", "Absorb" },               guids = { "2ecb05" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "693b62" } }, { cost = 2, ball = BLUE, gen = 5, guids = { "13e980" } } } },
  { name = "Lilligant",       level = 4, types = { "Grass" },    moves = { "Teeter Dance", "Mega Drain" },     guids = { "28e67a", "693b62" } },
  { name = "Basculin (Blue)", level = 2, types = { "Water" },    moves = { "Aqua Jet", "Chip Away" },          guids = { "5ee961" }, },
  { name = "Basculin (Red)",  level = 2, types = { "Water" },    moves = { "Aqua Jet", "Bite" },               guids = { "8e451c" }, },
  -- Gen 5 551-576
  { name = "Sandile",         level = 2, types = { "Ground" },   moves = { "Sand Attack", "Bite" },            guids = { "0ec450" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "89573c" } } } },
  { name = "Krokorok",        level = 4, types = { "Ground" },   moves = { "Sandstorm", "Assurance" },         guids = { "9857a1", "89573c" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "5d317d", "abaa08" } } } },
  { name = "Krookodile",      level = 6, types = { "Ground" },   moves = { "Earthquake", "Foul Play" },        guids = { "ab0970", "5d317d", "abaa08" }, },
  { name = "Darumaka",        level = 3, types = { "Fire" },     moves = { "Fire Fang", "Rollout" },           guids = { "fd08bc" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "1c3955", "7c085e" } } } },
  { name = "Darmanitan",      level = 5, types = { "Fire" },     moves = { "Fire Punch", "Superpower" },       guids = { "b20147", "1c3955" } }, -- Red
  { name = "Darmanitan",      level = 5, types = { "Fire" },     moves = { "Zen Headbutt", "Fire Punch" },     guids = { "66e45d", "7c085e" } }, -- Blue
  { name = "Maractus",        level = 3, types = { "Grass" },    moves = { "Needle Arm", "Peck" },             guids = { "b2f6e7" } },
  { name = "Dwebble",         level = 2, types = { "Bug" },      moves = { "Rock Blast", "Fury Cutter" },      guids = { "68671d" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "eb163e" } } } },
  { name = "Crustle",         level = 4, types = { "Bug" },      moves = { "Rock Slide", "X-Scissor" },        guids = { "459bcf", "eb163e" } },
  { name = "Scraggy",         level = 3, types = { "Dark" },     moves = { "Headbutt", "Low Kick" },           guids = { "aaaf84" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "d2d70d" } } } },
  { name = "Scrafty",         level = 5, types = { "Dark" },     moves = { "High Jump Kick", "Payback" },      guids = { "ef3715", "d2d70d" } },
  { name = "Sigilyph",        level = 5, types = { "Psychic" },  moves = { "Psybeam", "Mirror Move" },         guids = { "53ef88" }, },
  { name = "Yamask",          level = 3, types = { "Ghost" },    moves = { "Will-O-Wisp", "Astonish" },        guids = { "ae058d" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "dfb551" } } } },
  { name = "Cofagrigus",      level = 5, types = { "Ghost" },    moves = { "Ominous Wind", "Curse" },          guids = { "bff908", "dfb551" }, },
  { name = "Tirtouga",        level = 4, types = { "Water" },    moves = { "Shell Smash", "Water Gun" },       guids = { "69a6f1" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "ff9d76" } } } },
  { name = "Carracosta",      level = 6, types = { "Water" },    moves = { "Ancient Power", "Aqua Tail" },     guids = { "b12500", "ff9d76" } },
  { name = "Archen",          level = 4, types = { "Rock" },     moves = { "Quick Attack", "Dragon Claw" },    guids = { "dfadef" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "d1e259" } } } },
  { name = "Archeops",        level = 6, types = { "Rock" },     moves = { "Ancient Power", "Wing Attack" },   guids = { "bfc3cb", "d1e259" } },
  { name = "Trubbish",        level = 3, types = { "Poison" },   moves = { "Clear Smog", "Pound" },            guids = { "c0ee99" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "427e7e" } } } },
  { name = "Garbodor",        level = 5, types = { "Poison" },   moves = { "Explosion", "Sludge" },            guids = { "5e6faf", "427e7e" },           evoData = { { cost = "GMax", ball = MEGA, gen = 5, ballGuid = "140fbd", guids = { "43b26e", "a13dc7" } } } },
  { name = "Zorua",           level = 3, types = { "Dark" },     moves = { "Fury Swipes", "Fake Tears" },      guids = { "852f7a" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "99e127" } } } },
  { name = "Zorark",          level = 5, types = { "Dark" },     moves = { "Shadow Claw", "Night Daze" },      guids = { "9ea40d", "99e127" } },
  { name = "Minccino",        level = 3, types = { "Normal" },   moves = { "Baby-Doll Eyes", "Echoed Voice" }, guids = { "4619bc" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "fd401d" } } } },
  { name = "Cinccino",        level = 4, types = { "Normal" },   moves = { "Swift", "Sing" },                  guids = { "cc407b", "fd401d" }, },         -- TODO: Cinccino Token shows level 3, presumambly should be level 4 instead
  { name = "Gothita",         level = 2, types = { "Psychic" },  moves = { "Confusion", "Pound" },             guids = { "2c8314" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "3c3dd3" } } } },
  { name = "Gothorita",       level = 4, types = { "Psychic" },  moves = { "Psybeam", "Charm" },               guids = { "1a4be0", "3c3dd3" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "b7fdb2", "193950" } } } },
  { name = "Gothitelle",      level = 6, types = { "Psychic" },  moves = { "Future Sight", "Fake Tears" },     guids = { "95e45e", "b7fdb2", "193950" }, },
  -- Gen 5 577-601
  { name = "Solosis",         level = 2, types = { "Psychic" },  moves = { "Rollout", "Charm" },               guids = { "4ffe17" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "428bdd" } } } },
  { name = "Duosion",         level = 4, types = { "Psychic" },  moves = { "Hidden Power", "Light Screen" },   guids = { "6251de", "428bdd" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "783bd2", "e40ad5" } } } },
  { name = "Reuniclus",       level = 6, types = { "Psychic" },  moves = { "Dizzy Punch", "Psychic" },         guids = { "fd8189", "783bd2", "e40ad5" }, },
  { name = "Ducklett",        level = 2, types = { "Water" },    moves = { "Feather Dance", "Water Gun" },     guids = { "194e14" },                     evoData = { { cost = 3, ball = YELLOW, gen = 5, guids = { "e43f99" } } } },
  { name = "Swanna",          level = 5, types = { "Water" },    moves = { "Water Pulse", "Air Slash" },       guids = { "955306", "e43f99" }, },
  { name = "Vanillite",       level = 2, types = { "Ice" },      moves = { "Icicle Spear", "Astonish" },       guids = { "746959" },                     evoData = { { cost = 2, ball = BLUE, gen = 5, guids = { "67e645" } } } },
  { name = "Vanillish",       level = 4, types = { "Ice" },      moves = { "Mirror Shot", "Icy Wind" },        guids = { "a2fe81", "67e645" },           evoData = { { cost = 2, ball = RED, gen = 4, guids = { "642461", "98f88f" } } } },
  { name = "Vanilluxe",       level = 6, types = { "Ice" },      moves = { "Mirror Coat", "Blizzard" },        guids = { "c69af0", "642461", "98f88f" } },
  { name = "Deerling",        level = 2, types = { "Normal" },   moves = { "Camouflage", "Tackle" },           guids = { "7fe6be" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "2a61be" } } } }, -- Spring
  { name = "Sawsbuck",        level = 4, types = { "Normal" },   moves = { "Take Down", "Nature Power" },      guids = { "02874b", "2a61be" }, },                                                                                    -- Spring
  { name = "Deerling",        level = 2, types = { "Normal" },   moves = { "Camouflage", "Tackle" },           guids = { "9ce73b" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "1f9d13" } } } }, -- Fall
  { name = "Sawsbuck",        level = 4, types = { "Normal" },   moves = { "Take Down", "Nature Power" },      guids = { "494757", "1f9d13" }, },                                                                                    -- Fall
  { name = "Deerling",        level = 2, types = { "Normal" },   moves = { "Camouflage", "Tackle" },           guids = { "de2c41" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "426c52" } } } }, -- Summer
  { name = "Sawsbuck",        level = 4, types = { "Normal" },   moves = { "Take Down", "Nature Power" },      guids = { "a1bde0", "426c52" }, },                                                                                    -- Summer
  { name = "Deerling",        level = 2, types = { "Normal" },   moves = { "Camouflage", "Tackle" },           guids = { "90a5b6" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "4ef3be" } } } }, -- Winter
  { name = "Sawsbuck",        level = 4, types = { "Normal" },   moves = { "Take Down", "Nature Power" },      guids = { "853bba", "4ef3be" }, },                                                                                    -- Winter
  { name = "Emolga",          level = 3, types = { "Electric" }, moves = { "Quick Attack", "Spark" },          guids = { "21c0e7" } },
  { name = "Karrablast",      level = 3, types = { "Bug" },      moves = { "Fury Cutter", "Peck" },            guids = { "a987fe" },                     evoData = { { cost = 1, ball = YELLOW, gen = 5, guids = { "2fbc4e" } } } },
  { name = "Escavalier",      level = 4, types = { "Bug" },      moves = { "Iron Head", "Bug Buzz" },          guids = { "79dfaa", "2fbc4e" }, },
  { name = "Foongus",         level = 3, types = { "Grass" },    moves = { "Astonish", "Absorb" },             guids = { "ee2a78" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "13d1d6" } } } },
  { name = "Amoongus",        level = 5, types = { "Grass" },    moves = { "Clear Smog", "Mega Drain" },       guids = { "b61f79", "13d1d6" } },
  { name = "Frillish",        level = 4, types = { "Water" },    moves = { "Bubble Beam", "Absorb" },          guids = { "a28f5d" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "8ac9cc" } } } }, -- Blue
  { name = "Jellicent",       level = 6, types = { "Water" },    moves = { "Ominous Wind", "Water Pulse" },    guids = { "15c302", "8ac9cc" } },                                                                                  -- Blue
  { name = "Frillish",        level = 4, types = { "Water" },    moves = { "Bubble Beam", "Absorb" },          guids = { "60ba9e" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "8fd291" } } } }, -- Pink
  { name = "Jellicent",       level = 6, types = { "Water" },    moves = { "Ominous Wind", "Water Pulse" },    guids = { "598d9a", "8fd291" } },                                                                                  -- Pink
  { name = "Alomomola",       level = 3, types = { "Water" },    moves = { "Safeguard", "Brine" },             guids = { "9c2e47" } },
  { name = "Joltik",          level = 2, types = { "Bug" },      moves = { "Fury Cutter", "Absorb" },          guids = { "c4adc9" },                     evoData = { { cost = 3, ball = YELLOW, gen = 5, guids = { "4f2f10" } } } },
  { name = "Galvantula",      level = 5, types = { "Bug" },      moves = { "Electroweb", "Bug Bite" },         guids = { "1e7df7", "4f2f10" } },
  { name = "Ferroseed",       level = 3, types = { "Grass" },    moves = { "Pin Missile", "Mirror Shot" },     guids = { "4801d8" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "d1ce01" } } } },
  { name = "Ferrothorn",      level = 5, types = { "Grass" },    moves = { "Iron Defense", "Power Whip" },     guids = { "1419cf", "d1ce01" } },
  { name = "Klink",           level = 3, types = { "Steel" },    moves = { "Thunder Shock", "Vise Grip" },     guids = { "4ee23b" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "17a2ae" } } } },
  { name = "Klang",           level = 5, types = { "Steel" },    moves = { "Mirror Shot", "Screech" },         guids = { "00b5c3", "17a2ae" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "c5a2bf", "47e417" } } } },
  { name = "Klinklang",       level = 6, types = { "Steel" },    moves = { "Gear Grind", "Discharge" },        guids = { "5108f3", "c5a2bf", "47e417" } },
  -- Gen 5 602-637
  { name = "Tynamo",          level = 3, types = { "Electric" }, moves = { "Thunder Wave", "Tackle" },         guids = { "033989" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "8cec3c" } } } },
  { name = "Eelektrik",       level = 5, types = { "Electric" }, moves = { "Charge Beam", "Acid" },            guids = { "170118", "8cec3c" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "74b8ad", "1e9b7b" } } } },
  { name = "Eelektross",      level = 6, types = { "Electric" }, moves = { "Discharge", "Crunch" },            guids = { "340824", "74b8ad", "1e9b7b" } },
  { name = "Elgyem",          level = 3, types = { "Psychic" },  moves = { "Headbutt", "Psybeam" },            guids = { "f5a0a7" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "9c471b" } } } },
  { name = "Beheeyem",        level = 5, types = { "Psychic" },  moves = { "Zen Headbutt", "Hidden Power" },   guids = { "aa886c", "9c471b" } },
  { name = "Litwick",         level = 3, types = { "Ghost" },    moves = { "Will-O-Wisp", "Astonish" },        guids = { "32bd77" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "c3de22" } } } },
  { name = "Lampent",         level = 5, types = { "Ghost" },    moves = { "Fire Spin", "Curse" },             guids = { "7135eb", "c3de22" },           evoData = { { cost = 1, ball = RED, gen = 5, guids = { "5a029a", "1d0a91" } } } },
  { name = "Chandelure",      level = 6, types = { "Ghost" },    moves = { "Shadow Ball", "Flame Burst" },     guids = { "a1dddd", "5a029a", "1d0a91" } },
  { name = "Axew",            level = 2, types = { "Dragon" },   moves = { "Assurance", "Scratch" },           guids = { "b44616" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "989343" } } } },
  { name = "Fraxure",         level = 4, types = { "Dragon" },   moves = { "Swords Dance", "Dragon Claw" },    guids = { "983f37", "989343" },           evoData = { { cost = 3, ball = RED, gen = 5, guids = { "c776ab", "bf4902" } } } },
  { name = "Haxorus",         level = 7, types = { "Dragon" },   moves = { "Dual Chop", "Giga Impact" },       guids = { "913d4a", "c776ab", "bf4902" } },
  { name = "Cubchoo",         level = 3, types = { "Ice" },      moves = { "Powder Snow", "Charm" },           guids = { "0d7df1" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "7ef288" } } } },
  { name = "Beartic",         level = 5, types = { "Ice" },      moves = { "Icicle Crash", "Thrash" },         guids = { "c83c3a", "7ef288" } },
  { name = "Cryogonal",       level = 4, types = { "Ice" },      moves = { "Sheer Cold", "Light Screen" },     guids = { "68294a" } },
  { name = "Shelmet",         level = 3, types = { "Bug" },      moves = { "Acid Armor", "Mega Drain" },       guids = { "898892" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "f95e65" } } } },
  { name = "Accelgor",        level = 4, types = { "Bug" },      moves = { "Me First", "U-Turn" },             guids = { "41989c", "f95e65" } },
  { name = "Stunfisk",        level = 3, types = { "Ground" },   moves = { "Thunder Shock", "Mud-Slap" },      guids = { "2db3e2" } },
  { name = "Mienfoo",         level = 4, types = { "Fighting" }, moves = { "Force Palm", "Calm Mind" },        guids = { "ff78e9" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "3e2f17" } } } },
  { name = "Mienshao",        level = 6, types = { "Fighting" }, moves = { "High Jump Kick", "Bounce" },       guids = { "ad66a7", "3e2f17" } },
  { name = "Druddigon",       level = 5, types = { "Dragon" },   moves = { "Dragon Claw", "Night Slash" },     guids = { "0dc4b0" } },
  { name = "Golett",          level = 3, types = { "Ground" },   moves = { "Dynamic Punch", "Iron Defense" },  guids = { "181a0d" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "3cbe89" } } } },
  { name = "Golurk",          level = 5, types = { "Ground" },   moves = { "Shadow Punch", "Earthquake" },     guids = { "209c3f", "3cbe89" } },
  { name = "Pawniard",        level = 3, types = { "Dark" },     moves = { "Metal Claw", "Slash" },            guids = { "259499" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "cd8ee8" } } } },
  { name = "Bisharp",         level = 5, types = { "Dark" },     moves = { "Iron Head", "Night Slash" },       guids = { "bf65c0", "cd8ee8" },           evoData = { { cost = 1, ball = RED, gen = 9, guids = { "d49464", "8625f7" } } } },
  { name = "Bouffalant",      level = 4, types = { "Normal" },   moves = { "Head Charge", "Megahorn" },        guids = { "91e1a4" } },
  { name = "Rufflet",         level = 3, types = { "Flying" },   moves = { "Hone Claws", "Peck" },             guids = { "f52196" },                     evoData = { { cost = 3, ball = RED, gen = 5, guids = { "f1a656" } }, { cost = 3, ball = RED, gen = 8, guids = { "aaa239" } } } },
  { name = "Braviary",        level = 6, types = { "Flying" },   moves = { "Crush Claw", "Aerial Ace" },       guids = { "8def45", "f1a656" } },
  { name = "Vullaby",         level = 3, types = { "Dark" },     moves = { "Fury Attack", "Nasty Plot" },      guids = { "8c8d4a" },                     evoData = { { cost = 3, ball = RED, gen = 5, guids = { "d9a365" } } } },
  { name = "Mandibuzz",       level = 6, types = { "Dark" },     moves = { "Bone Rush", "Air Slash" },         guids = { "21182a", "d9a365" } },
  { name = "Heatmor",         level = 4, types = { "Fire" },     moves = { "Incinerate", "Odor Sleuth" },      guids = { "cd2a36" } },
  { name = "Durant",          level = 4, types = { "Bug" },      moves = { "Metal Sound", "Bug Bite" },        guids = { "96b5d6" } },
  { name = "Deino",           level = 3, types = { "Dark" },     moves = { "Assurance", "Headbutt" },          guids = { "6e0580" },                     evoData = { { cost = 2, ball = YELLOW, gen = 5, guids = { "cc9679" } } } },
  { name = "Zweilous",        level = 5, types = { "Dark" },     moves = { "Dragon Pulse", "Bite" },           guids = { "751bca", "cc9679" },           evoData = { { cost = 2, ball = RED, gen = 5, guids = { "573535", "6edcb7" } } } },
  { name = "Hydreigon",       level = 7, types = { "Dark" },     moves = { "Outrage", "Crunch" },              guids = { "d1c597", "573535", "6edcb7" } },
  { name = "Larvesta",        level = 4, types = { "Bug" },      moves = { "Leech Life", "Ember" },            guids = { "ec4a46" },                     evoData = { { cost = 2, ball = RED, gen = 5, guids = { "b9c1a0" } } } },
  { name = "Volcarona",       level = 7, types = { "Bug" },      moves = { "Fiery Dance", "Hurricane" },       guids = { "ad5421", "b9c1a0" } },
  -- Gen 5 638-649
  { name = "Cobalion",        level = 7, types = { "Steel" },    moves = { "Sacred Sword", "Iron Head" },      guids = { "55fe44" } },
  { name = "Terrakion",       level = 7, types = { "Rock" },     moves = { "Sacred Sword", "Rock Slide" },     guids = { "21e3a7" } },
  { name = "Virizion",        level = 7, types = { "Grass" },    moves = { "Sacred Sword", "Leaf Blade" },     guids = { "97db25" } },
  { name = "Tornadus",        level = 7, types = { "Flying" },   moves = { "Bleakwind Storm", "Thrash" },      guids = { "d1658f" } },
  { name = "Tornadus",        level = 7, types = { "Flying" },   moves = { "Bleakwind Storm", "Focus Blast" }, guids = { "916000" } },
  { name = "Thundurus",       level = 7, types = { "Electric" }, moves = { "Wildbolt Storm", "Fly" },          guids = { "723ca9" } },
  { name = "Thundurus",       level = 7, types = { "Electric" }, moves = { "Wildbolt Storm", "Focus Blast" },  guids = { "a2c518" } },
  { name = "Reshiram",        level = 7, types = { "Dragon" },   moves = { "Blue Flare", "Dragon Pulse" },     guids = { "5b8987" },                     evoData = { { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, guids = { "d5117a", "28742a" } } } },
  { name = "Zekrom",          level = 7, types = { "Dragon" },   moves = { "Bolt Strike", "Dragon Claw" },     guids = { "879958" },                     evoData = { { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, guids = { "d20352", "6be4f3" } } } },
  { name = "Landorus",        level = 7, types = { "Ground" },   moves = { "Sandsear Storm", "Focus Blast" },  guids = { "ee0f97" } },
  { name = "Landorus",        level = 7, types = { "Ground" },   moves = { "Sandsear Storm", "Stone Edge" },   guids = { "596a60" } },
  { name = "Kyurem",          level = 7, types = { "Dragon" },   moves = { "Dragon Breath", "Glaciate" },      guids = { "3a2734" },                     evoData = { { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, guids = { "d20352", "6be4f3" } }, { cost = "DNA Splicers", ball = LEGENDARY, gen = 5, guids = { "d5117a", "28742a" } } } },
  { name = "Kyurem",          level = 7, types = { "Dragon" },   moves = { "Fusion Bolt", "Ice Beam" },        guids = { "d20352", "6be4f3" } }, -- Black Kyurem
  { name = "Kyurem",          level = 7, types = { "Dragon" },   moves = { "Fusion Flare", "Ice Beam" },       guids = { "d5117a", "28742a" } }, -- White Kyurem
  { name = "Keldeo",          level = 7, types = { "Water" },    moves = { "Sacred Sword", "Aqua Tail" },      guids = { "d825d0" } },
  { name = "Keldeo",          level = 7, types = { "Water" },    moves = { "Sacred Sword", "Hydro Pump" },     guids = { "e0356d" } },
  { name = "Meloetta",        level = 7, types = { "Normal" },   moves = { "Relic Song", "Psychic" },          guids = { "893ae6" } },
  { name = "Meloetta",        level = 7, types = { "Normal" },   moves = { "Close Combat", "Relic Song" },     guids = { "430037" } },
  { name = "Genesect",        level = 7, types = { "Bug" },      moves = { "Signal Beam", "Techno Blast" },    guids = { "a0f8a1" } },

  -- Mega evolutions.
  { name = "Mega Audino",     level = 5,    types = { "Fairy" }, moves = { "Disarming Voice", "Double-Edge" },  guids = { "0c7909" },                      evoData = { { cost = 0, ball = BLUE, gen = 5, ballGuid = "140fbd", guids = { "b81637" } } } },
  { name = "GMax Garbodor",   level = 5,    types = { "Poison" },moves = { "Malador", "Strike" },               guids = { "43b26e", "a13dc7" },            evoData = { { cost = 0, ball = YELLOW, gen = 5, ballGuid = "140fbd", guids = { "5e6faf", "427e7e" } } } },
}

gen6PokemonData =
{
  -- Gen 6 650-678
  { name = "Chespin",     level = 1, types = { "Grass" },    moves = { "Growl", "Vine Whip" },               guids = { "68e630" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "742ae2" } } } },
  { name = "Quilladin",   level = 3, types = { "Grass" },    moves = { "Pin Missile", "Needle Arm" },        guids = { "001c72", "742ae2" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "4b2bfb", "b1fb69" } } } },
  { name = "Chesnaught",  level = 5, types = { "Grass" },    moves = { "Spiky Shield", "Hammer Arm" },       guids = { "9377c5", "4b2bfb", "b1fb69" }, },
  { name = "Fennekin",    level = 1, types = { "Fire" },     moves = { "Ember", "Howl" },                    guids = { "311f76" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "2b10a5" } } } },
  { name = "Braixen",     level = 3, types = { "Fire" },     moves = { "Fire Spin", "Light Screen" },        guids = { "c5d7f0", "2b10a5" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "9d0714", "ab189f" } } } },
  { name = "Delphox",     level = 5, types = { "Fire" },     moves = { "Mystical Fire", "Psyshock" },        guids = { "cab045", "9d0714", "ab189f" }, },
  { name = "Froakie",     level = 1, types = { "Water" },    moves = { "Quick Attack", "Bubble" },           guids = { "2e6ec8" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "d74138" } } } },
  { name = "Frogadier",   level = 3, types = { "Water" },    moves = { "Water Pulse", "Bounce" },            guids = { "2ac3d0", "d74138" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "5dbd84", "3bf77c" } } } },
  { name = "Greninja",    level = 5, types = { "Water" },    moves = { "Water Shuriken", "Night Slash" },    guids = { "6e82bc", "5dbd84", "3bf77c" }, },
  { name = "Bunnelby",    level = 1, types = { "Normal" },   moves = { "Double Slap", "Leer" },              guids = { "dd60c8" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "fa6708" } } } },
  { name = "Diggersby",   level = 3, types = { "Normal" },   moves = { "Super Fang", "Dig" },                guids = { "f7395c", "fa6708" } },
  { name = "Fletchling",  level = 1, types = { "Flying" },   moves = { "Growl", "Peck" },                    guids = { "10f8ac" },                     evoData = { { cost = 2, ball = BLUE, gen = 6, guids = { "d4e15c" } } } },
  { name = "Fletchinder", level = 3, types = { "Fire" },     moves = { "Razor Wind", "Ember" },              guids = { "780fa6", "d4e15c" },           evoData = { { cost = 2, ball = RED, gen = 6, guids = { "562fca", "b7ce61" } } } },
  { name = "Talonflame",  level = 5, types = { "Fire" },     moves = { "Steel Wing", "Flare Blitz" },        guids = { "2b826a", "562fca", "b7ce61" } },
  { name = "Scatterbug",  level = 1, types = { "Bug" },      moves = { "String Shot", "Tackle" },            guids = { "2fc6c4" },                     evoData = { { cost = 1, ball = PINK, gen = 6, guids = { "88a3f1" } } } },
  { name = "Spewpa",      level = 2, types = { "Bug" },      moves = { "Protect", "Harden" },                guids = { "7bcb6b", "88a3f1" },           evoData = { { cost = 1, ball = GREEN, gen = 6, guids = { "d4e7b2", "a619c3" } } } },
  { name = "Vivillon",    level = 3, types = { "Bug" },      moves = { "Quiver Dance", "Gust" },             guids = { "68cecb", "d4e7b2", "a619c3" } },
  { name = "Litleo",      level = 2, types = { "Fire" },     moves = { "Noble Roar", "Ember" },              guids = { "8e2e3f" },                     evoData = { { cost = 3, ball = YELLOW, gen = 6, guids = { "318002" } } } },
  { name = "Pyroar",      level = 5, types = { "Fire" },     moves = { "Echoed Voice", "Incinerate" },       guids = { "eefb5c", "318002" } },
  { name = "Flabebe",     level = 1, types = { "Fairy" },    moves = { "Fairy Wind", "Tackle" },             guids = { "de8ea6" },                     evoData = { { cost = 2, ball = GREEN, gen = 6, guids = { "342092" } } } },
  { name = "Floette",     level = 3, types = { "Fairy" },    moves = { "Misty Terrain", "Magical Leaf" },    guids = { "ed9c70", "342092" },           evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "f389c7", "b23f51" } } } },
  { name = "Florges",     level = 4, types = { "Fairy" },    moves = { "Petal Dance", "Moonblast" },         guids = { "cd9f20", "f389c7", "b23f51" }, },
  { name = "Skiddo",      level = 2, types = { "Grass" },    moves = { "Take Down", "Vine Whip" },           guids = { "0d26ba" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "982e96" } } } },
  { name = "Gogoat",      level = 4, types = { "Grass" },    moves = { "Aerial Ace", "Horn Leech" },         guids = { "b1e400", "982e96" }, },
  { name = "Pancham",     level = 2, types = { "Fighting" }, moves = { "Arm Thrust", "Work Up" },            guids = { "bf3855" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "cf6845" } } } },
  { name = "Pangoro",     level = 4, types = { "Fighting" }, moves = { "Circle Throw", "Night Slash" },      guids = { "068e59", "cf6845" } },
  { name = "Furfrou",     level = 3, types = { "Normal" },   moves = { "Retaliate", "Charm" },               guids = { "e7d9dd" }, },
  { name = "Espurr",      level = 2, types = { "Psychic" },  moves = { "Disarming Voice", "Confusion" },     guids = { "53beaa" },                     evoData = { { cost = 1, ball = GREEN, gen = 6, guids = { "bb2e78" } }, { cost = 1, ball = GREEN, gen = 6, guids = { "8e85d5" } } } },
  { name = "Meowstic",    level = 3, types = { "Psychic" },  moves = { "Charm", "Psybeam" },                 guids = { "15d501", "8e85d5", } }, -- Female
  { name = "Meowstic",    level = 3, types = { "Psychic" },  moves = { "Sucker Punch", "Psybeam" },          guids = { "519e39", "bb2e78" } },  -- Male
  -- Gen 6 679-700
  { name = "Honedge",     level = 3, types = { "Steel" },    moves = { "Swords Dance", "Fury Cutter" },      guids = { "fdfef9" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "889a70" } } } },
  { name = "Doublade",    level = 5, types = { "Steel" },    moves = { "Shadow Sneak", "Slash" },            guids = { "7456e9", "889a70" },           evoData = { { cost = 1, ball = RED, gen = 6, guids = { "a22c4a", "cc32a1" } }, { cost = 1, ball = RED, gen = 6, guids = { "52ba90", "f7ff82" } } } },
  { name = "Aegislash",   level = 6, types = { "Steel" },    moves = { "Sacred Sword", "Iron Head" },        guids = { "94735b", "52ba90", "f7ff82" }, },  -- Sword Version
  { name = "Aegislash",   level = 6, types = { "Steel" },    moves = { "Sacred Sword", "King's Shield" },    guids = { "adf3ec", "a22c4a", "cc32a1" }, },  -- Shield Version
  { name = "Spritzee",    level = 3, types = { "Fairy" },    moves = { "Fairy Wind", "Attract" },            guids = { "ee6a18" },                     evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "b0e63a" } } } },
  { name = "Aromatisse",  level = 4, types = { "Fairy" },    moves = { "Moonblast", "Heal Pulse" },          guids = { "ee7504", "b0e63a" }, },
  { name = "Swirlix",     level = 3, types = { "Fairy" },    moves = { "Play Nice", "Fairy Wind" },          guids = { "bfc548" },                     evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "45a974" } } } },
  { name = "Slurpuff",    level = 4, types = { "Fairy" },    moves = { "Cotton Guard", "Play Rough" },       guids = { "5fecfe", "45a974" } },
  { name = "Inkay",       level = 2, types = { "Dark" },     moves = { "Hypnosis", "Peck" },                 guids = { "c8dc46" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "0dca90" } } } },
  { name = "Malamar",     level = 4, types = { "Dark" },     moves = { "Superpower", "Foul Play" },          guids = { "8bd2d5", "0dca90" } },
  { name = "Binacle",     level = 3, types = { "Rock" },     moves = { "Shell Smash", "Clamp" },             guids = { "2c77cd" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "3ed28a" } } } },
  { name = "Barbaracle",  level = 4, types = { "Rock" },     moves = { "Razor Shell", "Cross Chop" },        guids = { "e9dd78", "c6fcdc" }, },
  { name = "Skrelp",      level = 3, types = { "Poison" },   moves = { "Poison Tail", "Water Gun" },         guids = { "183099" },                     evoData = { { cost = 3, ball = RED, gen = 6, guids = { "661d8b" } } } },
  { name = "Dragalge",    level = 6, types = { "Poison" },   moves = { "Dragon Pulse", "Hydro Pump" },       guids = { "3a948e", "661d8b" } },
  { name = "Clauncher",   level = 3, types = { "Water" },    moves = { "Aqua Jet", "Vise Grip" },            guids = { "913807" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "63a317" } } } },
  { name = "Clawitzer",   level = 5, types = { "Water" },    moves = { "Dark Pulse", "Crabhammer" },         guids = { "b296af", "63a317" } },
  { name = "Helioptile",  level = 3, types = { "Electric" }, moves = { "Thunder Shock", "Quick Attack" },    guids = { "8f08fa" },                     evoData = { { cost = 1, ball = BLUE, gen = 6, guids = { "50ff69" } } } },
  { name = "Heliolisk",   level = 4, types = { "Electric" }, moves = { "Razor Wind", "Volt Switch" },        guids = { "817046", "50ff69" } },
  { name = "Tyrunt",      level = 4, types = { "Rock" },     moves = { "Stomp", "Bite" },                    guids = { "fdb796" },                     evoData = { { cost = 2, ball = RED, gen = 6, guids = { "fc4eb1" } } } },
  { name = "Tyrantrum",   level = 6, types = { "Rock" },     moves = { "Head Smash", "Dragon Claw" },        guids = { "784474", "fc4eb1" } },
  { name = "Amaura",      level = 4, types = { "Rock" },     moves = { "Take Down", "Icy Wind" },            guids = { "43451f" },                     evoData = { { cost = 2, ball = RED, gen = 6, guids = { "bba475" } } } },
  { name = "Aurorus",     level = 6, types = { "Rock" },     moves = { "Aurora Beam", "Ancient Power" },     guids = { "4170ac", "bba475" } },
  { name = "Sylveon",     level = 5, types = { "Fairy" },    moves = { "Moonblast", "Swift" },               guids = { "8de192", "7ea880" } },
  -- Gen 6 701-721
  { name = "Hawlucha",    level = 3, types = { "Fighting" }, moves = { "Hone Claws", "Flying Press" },       guids = { "ecc5ed" } },
  { name = "Dedenne",     level = 2, types = { "Electric" }, moves = { "Charm", "Nuzzle" },                  guids = { "251e0f" } },
  { name = "Carbink",     level = 3, types = { "Rock" },     moves = { "Stealth Rock", "Sharpen" },          guids = { "bd24b2" } },
  { name = "Goomy",       level = 2, types = { "Dragon" },   moves = { "Absorb", "Bubble" },                 guids = { "525dda" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "2a9ba9" } } } },
  { name = "Sliggoo",     level = 4, types = { "Dragon" },   moves = { "Mwuddy Water", "Dragon Pulse" },      guids = { "86de80", "2a9ba9" },          evoData = { { cost = 3, ball = RED, gen = 6, guids = { "84a03d", "980868" } } } },
  { name = "Goodra",      level = 7, types = { "Dragon" },   moves = { "Power Whip", "Outrage" },            guids = { "4010f0", "84a03d", "980868" } },
  { name = "Klefki",      level = 3, types = { "Steel" },    moves = { "Metal Sound", "Fairy Wind" },        guids = { "72532e" } },
  { name = "Phantump",    level = 3, types = { "Ghost" },    moves = { "Feint Attack", "Curse" },            guids = { "c97328" },                     evoData = { { cost = 1, ball = YELLOW, gen = 6, guids = { "e3f03d" } } } },
  { name = "Trevenant",   level = 4, types = { "Ghost" },    moves = { "Wood Hammer", "Phantom Force" },     guids = { "eea302", "e3f03d" } },
  { name = "Pumpkaboo",   level = 3, types = { "Ghost" },    moves = { "Bullet Seed", "Astonish" },          guids = { "a2221a" },                     evoData = { { cost = 1, ball = YELLOW, gen = 6, guids = { "607cf8" } } } },
  { name = "Gourgeist",   level = 4, types = { "Ghost" },    moves = { "Seed Bomb", "Explosion" },           guids = { "0bae76", "607cf8" } },
  { name = "Bergmite",    level = 3, types = { "Ice" },      moves = { "Icy Wind", "Harden" },               guids = { "cc9804" },                     evoData = { { cost = 2, ball = RED, gen = 6, guids = { "9c5313" } }, { cost = 2, ball = RED, gen = 8, guids = { "2edcdb" } } } },
  { name = "Avalugg",     level = 5, types = { "Ice" },      moves = { "Skull Bash", "Avalanche" },          guids = { "3b9191", "9c5313" } },
  { name = "Noibat",      level = 3, types = { "Flying" },   moves = { "Razor Wind", "Bite" },               guids = { "eaed3f" },                     evoData = { { cost = 3, ball = RED, gen = 6, guids = { "350e64" } } } },
  { name = "Noivern",     level = 6, types = { "Flying" },   moves = { "Dragon Pulse", "Air Slash" },        guids = { "e5a265", "350e64" } },
  { name = "Xerneas",     level = 7, types = { "Fairy" },    moves = { "Moonblast", "Megahorn" },            guids = { "ef3078" } },
  { name = "Yveltal",     level = 7, types = { "Dark" },     moves = { "Dark Pulse", "Oblivion Wing" },      guids = { "341630" } },
  { name = "10% Zygarde", level = 7, types = { "Dragon" },   moves = { "Land's Wrath", "Glare" },            guids = { "84fad7" },                     evoData = { { cost = "Zygarde Cube", ball = LEGENDARY, gen = 6, guids = { "eae5f7" } } } }, -- 10%
  { name = "50% Zygarde", level = 7, types = { "Dragon" },   moves = { "Dragon Breath", "Earthquake" },      guids = { "eae5f7" },                     evoData = { { cost = "Zygarde Cube", ball = LEGENDARY, gen = 6, guids = { "ea5e61" } } } }, -- 50%
  { name = "Complete Zygarde", level = 8, types = { "Dragon" }, moves = { "Extreme Speed", "Outrage" },      guids = { "ea5e61" } },                                                                                                               -- Complete
  { name = "Diancie",     level = 7, types = { "Rock" },     moves = { "Diamond Storm", "Light Screen" },    guids = { "dfd970" },                     evoData = { { cost = "Mega", ball = MEGA, gen = 5, ballGuid = "140fbd", guids = { "9addeb" } } } },
  { name = "Hoopa",       level = 7, types = { "Psychic" },  moves = { "Hyperspace Hole", "Phantom Force" }, guids = { "2dc848" },                     evoData = { { cost = "Prison Bottle", ball = LEGENDARY, gen = 6, guids = { "59d7f4" } } } },
  { name = "Hoopa",       level = 7, types = { "Psychic" },  moves = { "Hyperspace Fury", "Psychic" },       guids = { "59d7f4" } },
  { name = "Volcanion",   level = 7, types = { "Fire" },     moves = { "Steam Eruption", "Incinerate" },     guids = { "b4f0b0" } },

  -- Mega evolutions.
  { name = "Mega Diancie",level = 7, types = { "Rock" },     moves = { "Moonblast", "Stone Edge" },          guids = { "9addeb" },                     evoData = { { cost = 0, ball = LEGENDARY, gen = 5, ballGuid = "140fbd", guids = { "dfd970" } } } },
}

gen7PokemonData =
{
  -- Gen 7 722-750
  { name = "Rowlet",       level = 1, types = { "Grass" },    moves = { "Leafage", "Growl" },                  guids = { "df9287" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "1c84d5" } } } },
  { name = "Dartrix",      level = 3, types = { "Grass" },    moves = { "Razor Leaf", "Peck" },                guids = { "71d957", "1c84d5" },           evoData = { { cost = 2, ball = RED, gen = 7, guids = { "2416c8", "9bef15" } }, { cost = 2, ball = RED, gen = 8, guids = { "cf7b80", "5ada77" } } } },
  { name = "Decidueye",    level = 5, types = { "Grass" },    moves = { "Spirit Shackle", "Leaf Blade" },      guids = { "d50f86", "2416c8", "9bef15" }, },
  { name = "Litten",       level = 1, types = { "Fire" },     moves = { "Ember", "Growl" },                    guids = { "03a2c1" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "1ae631" } } } },
  { name = "Torracat",     level = 3, types = { "Fire" },     moves = { "Fury Swipes", "Fire Fang" },          guids = { "4d7ec6", "1ae631" },           evoData = { { cost = 2, ball = RED, gen = 7, guids = { "38e353", "45ba93" } } } },
  { name = "Incineroar",   level = 5, types = { "Fire" },     moves = { "Flare Blitz", "Darkest Lariat" },     guids = { "3f1566", "38e353", "45ba93" }, },
  { name = "Popplio",      level = 1, types = { "Water" },    moves = { "Water Gun", "Growl" },                guids = { "9364c2" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "454874" } } } },
  { name = "Brionne",      level = 3, types = { "Water" },    moves = { "Icy Wind", "Aqua Jet" },              guids = { "d3529d", "454874" },           evoData = { { cost = 2, ball = RED, gen = 7, guids = { "d62cf2", "4026a1" } } } },
  { name = "Primarina",    level = 5, types = { "Water" },    moves = { "Moonblast", "Sparkling Aria" },       guids = { "de4d6a", "d62cf2", "4026a1" }, },
  { name = "Pikipek",      level = 1, types = { "Flying" },   moves = { "Growl", "Peck" },                     guids = { "441f65" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "5e7eae" } } } },
  { name = "Trumbeak",     level = 3, types = { "Flying" },   moves = { "Rock Blast", "Echoed Voice" },        guids = { "c5f660", "5e7eae" },           evoData = { { cost = 1, ball = YELLOW, gen = 7, guids = { "8f7253", "4fda79" } } } },
  { name = "Toucannon",    level = 4, types = { "Flying" },   moves = { "Beak Blast", "Hyper Voice" },         guids = { "a9acd3", "8f7253", "4fda79" } },
  { name = "Yungoos",      level = 1, types = { "Normal" },   moves = { "Sand Attack", "Tackle" },             guids = { "195460" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "fa17b3" } } } },
  { name = "Gumshoos",     level = 3, types = { "Normal" },   moves = { "Super Fang", "Crunch" },              guids = { "28ee0f", "fa17b3" } },
  { name = "Grubbin",      level = 1, types = { "Bug" },      moves = { "Vise Grip", "String Shot" },          guids = { "505be7" },                     evoData = { { cost = 2, ball = GREEN, gen = 7, guids = { "545c8d" } } } },
  { name = "Charjabug",    level = 3, types = { "Bug" },      moves = { "Mud-Slap", "Bug Bite" },              guids = { "918808", "545c8d" },           evoData = { { cost = 1, ball = YELLOW, gen = 7, guids = { "be9f22", "59664c" } } } },
  { name = "Vikavolt",     level = 4, types = { "Bug" },      moves = { "Zap Cannon", "X-Scissor" },           guids = { "8ee928", "be9f22", "59664c" } },
  { name = "Crabrawler",   level = 3, types = { "Fighting" }, moves = { "Rock Smash", "Crabhammer" },          guids = { "ff2869" },                     evoData = { { cost = 1, ball = YELLOW, gen = 7, guids = { "7021bf" } } } },
  { name = "Crabominable", level = 4, types = { "Fighting" }, moves = { "Dynamic Punch", "Ice Hammer" },       guids = { "1689aa", "7021bf" } },
  { name = "Oricorio",     level = 3, types = { "Fire" },     moves = { "Feather Dance", "Rev. Dance Fire" },  guids = { "bafd29" } },
  { name = "Oricorio",     level = 3, types = { "Psychic" },  moves = { "Feather Dance", "Rev. Dance Psychic" }, guids = { "9f5d17" } },
  { name = "Oricorio",     level = 3, types = { "Electric" }, moves = { "Feather Dance", "Rev. Dance Electric" }, guids = { "f22afb" } },
  { name = "Oricorio",     level = 3, types = { "Ghost" },    moves = { "Feather Dance", "Rev. Dance Ghost" }, guids = { "a16f96" } },
  { name = "Cutiefly",     level = 1, types = { "Bug" },      moves = { "Fairy Wind", "Absorb" },              guids = { "ffc7e4" },                     evoData = { { cost = 2, ball = GREEN, gen = 7, guids = { "aa05a4" } } } },
  { name = "Ribombee",     level = 3, types = { "Bug" },      moves = { "Dazzling Gleam", "Pollen Puff" },     guids = { "aa05a4", "97144c" } },
  { name = "Rockruff",     level = 2, types = { "Rock" },     moves = { "Howl", "Bite" },                      guids = { "e4bb33" },                     evoData = { { cost = 2, ball = YELLOW, gen = 6, guids = { "802af7", "5411a7", "ff8dda" } } } },
  { name = "Lycanroc",     level = 4, types = { "Rock" },     moves = { "Crush Claw", "Accelerock" },          guids = { "34164a", "802af7" }, }, -- Orange
  { name = "Lycanroc",     level = 4, types = { "Rock" },     moves = { "Sucker Punch", "Accelerock" },        guids = { "9ecf49", "5411a7" }, }, -- Brown
  { name = "Lycanroc",     level = 4, types = { "Rock" },     moves = { "Rock Slide", "Counter" },             guids = { "9af49a", "ff8dda" }, }, -- Red
  { name = "Wishiwashi",   level = 4, types = { "Water" },    moves = { "Beat Up", "Brine" },                  guids = { "acfcee" } },
  { name = "Mareanie",     level = 3, types = { "Poison" },   moves = { "Wide Guard", "Toxic Spikes" },        guids = { "45598a" },                     evoData = { { cost = 2, ball = RED, gen = 7, guids = { "bd3b27" } } } },
  { name = "Toxapex",      level = 5, types = { "Poison" },   moves = { "Bane. Bunker", "Poison Jab" },        guids = { "e0c877", "bd3b27" } },
  { name = "Mudbray",      level = 2, types = { "Ground" },   moves = { "Double Kick", "Mud-Slap" },           guids = { "482345" },                     evoData = { { cost = 2, ball = RED, gen = 7, guids = { "c06039" } } } },
  { name = "Mudsdale",     level = 4, types = { "Ground" },   moves = { "H. Horsepower", "Stomp" },            guids = { "d66f99", "c06039" } },

  -- Gen 7 751-775
  { name = "Dewpider",     level = 1, types = { "Water" },    moves = { "Infestation", "Bubble" },             guids = { "7e97f0" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "ff2e27" } } } },
  { name = "Araquanid",    level = 3, types = { "Water" },    moves = { "Bubble Beam", "Lunge" },              guids = { "7fe018", "ff2e27" } },
  { name = "Fomantis",     level = 2, types = { "Grass" },    moves = { "Growth", "Leafage" },                 guids = { "e2dcdc" },                     evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "09b260" } } } },
  { name = "Lurantis",     level = 4, types = { "Grass" },    moves = { "Petal Blizzard", "Slash" },           guids = { "d98b01", "09b260" }, },
  { name = "Morelull",     level = 1, types = { "Grass" },    moves = { "Astonish", "Absorb" },                guids = { "b8f494" },                     evoData = { { cost = 2, ball = GREEN, gen = 7, guids = { "e803ee" } } } },
  { name = "Shiinotic",    level = 3, types = { "Grass" },    moves = { "Sleep Powder", "Moonblast" },         guids = { "24d418", "e803ee" }, },
  { name = "Salandit",     level = 2, types = { "Poison" },   moves = { "Ember", "Smog" },                     guids = { "433a74" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "f517cd" } } } },
  { name = "Salazzle",     level = 4, types = { "Poison" },   moves = { "Venom Drench", "Flame Burst" },       guids = { "73d1a4", "f517cd" } },
  { name = "Stufful",      level = 2, types = { "Normal" },   moves = { "Baby-Doll Eyes", "Tackle" },          guids = { "6e26ce" },                     evoData = { { cost = 1, ball = BLUE, gen = 7, guids = { "91caa3" } } } },
  { name = "Bewear",       level = 3, types = { "Normal" },   moves = { "Take Down", "Hammer Arm" },           guids = { "c3a8f1", "91caa3" } },
  { name = "Bounsweet",    level = 2, types = { "Grass" },    moves = { "Rapid Spin", "Play Nice" },           guids = { "a96b34" },                     evoData = { { cost = 1, ball = GREEN, gen = 7, guids = { "d564cd" } } } },
  { name = "Steenee",      level = 3, types = { "Grass" },    moves = { "Double Slap", "Magical Leaf" },       guids = { "e5f221", "d564cd" },           evoData = { { cost = 1, ball = BLUE, gen = 7, guids = { "e8a54a", "9d1fcf" } } } },
  { name = "Tsareena",     level = 4, types = { "Grass" },    moves = { "Trop Kick", "Stomp" },                guids = { "376bc7", "e8a54a", "9d1fcf" } },
  { name = "Comfey",       level = 3, types = { "Fairy" },    moves = { "Petal Dance", "Wrap" },               guids = { "c3291e" } },
  { name = "Oranguru",     level = 4, types = { "Normal" },   moves = { "Zen Headbutt", "Foul Play" },         guids = { "82400d" } },
  { name = "Passimian",    level = 4, types = { "Fighting" }, moves = { "Close Combat", "Thrash" },            guids = { "73f4a7" } },
  { name = "Wimpod",       level = 2, types = { "Bug" },      moves = { "Struggle Bug" },                      guids = { "ce812c" },                     evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "0042df" } } } },
  { name = "Golisopod",    level = 4, types = { "Bug" },      moves = { "First Impression", "Razor Shell" },   guids = { "3b9008", "0042df" } },
  { name = "Sandygast",    level = 4, types = { "Ghost" },    moves = { "Sand Tomb", "Sandstorm" },            guids = { "cc4a08" },                     evoData = { { cost = 2, ball = RED, gen = 7, guids = { "263266" } } } },
  { name = "Palossand",    level = 6, types = { "Ghost" },    moves = { "Earth Power", "Iron Defense" },       guids = { "58aab6", "263266" } },
  { name = "Pyukumuku",    level = 3, types = { "Water" },    moves = { "Safeguard", "Toxic" },                guids = { "6e7540" } },
  { name = "Type: Null",   level = 4, types = { "Normal" },   moves = { "Crush Claw", "Aerial Ace" },          guids = { "814ff2" },                     evoData = { { cost = 2, ball = RED, gen = 7, guids = { "7a7849" } } } },
  { name = "Silvally",     level = 6, types = { "Normal" },   moves = { "Multi-Attack", "Tri Attack" },        guids = { "458263", "7a7849" } },
  { name = "Minior",       level = 4, types = { "Rock" },     moves = { "Cosmic Power", "Swift" },             guids = { "6d5742" } }, -- Pink
  { name = "Minior",       level = 4, types = { "Rock" },     moves = { "Shell Smash", "Power Gem" },          guids = { "6c5dae" } }, -- Brown
  { name = "Komala",       level = 6, types = { "Normal" },   moves = { "Wood Hammer", "Yawn" },               guids = { "248d7f" } },

  -- Gen 7 776-809
  { name = "Turtonator",   level = 5, types = { "Fire" },     moves = { "Dragon Pulse", "Overheat" },          guids = { "7497e6" } },
  { name = "Togedemaru",   level = 3, types = { "Electric" }, moves = { "Zing Zap", "Rollout" },               guids = { "1778b2" } },
  { name = "Mimikyu",      level = 4, types = { "Ghost" },    moves = { "Play Rough", "Mimic" },               guids = { "ba3859" } },
  { name = "Bruxish",      level = 4, types = { "Water" },    moves = { "Psychic Fangs", "Crush" },            guids = { "9d31bb" } },
  { name = "Drampa",       level = 5, types = { "Dragon" },   moves = { "Dragon Rage", "Hyper Voice" },        guids = { "c2e75e" } },
  { name = "Dhelmise",     level = 5, types = { "Ghost" },    moves = { "Power Whip", "Anchor Shot" },         guids = { "2e8c2e" } },
  { name = "Jangmo-o",     level = 2, types = { "Dragon" },   moves = { "Headbutt", "Screech" },               guids = { "9c4545" },                     evoData = { { cost = 2, ball = YELLOW, gen = 7, guids = { "20c6cc" } } } },
  { name = "Hakamo-o",     level = 4, types = { "Dragon" },   moves = { "Dragon Dance", "Sky Uppercut" },      guids = { "3671cc", "20c6cc" },           evoData = { { cost = 3, ball = RED, gen = 7, guids = { "6377a7", "79e0d1" } } } },
  { name = "Kommo-o",      level = 7, types = { "Dragon" },   moves = { "Clanging Scales", "Close Combat" },   guids = { "51cc27", "6377a7", "79e0d1" } },
  { name = "Tapu Koko",    level = 7, types = { "Electric" }, moves = { "Nature's Madness", "Spark" },         guids = { "c5bd66" } },
  { name = "Tapu Lele",    level = 7, types = { "Psychic" },  moves = { "Nature's Madness", "Psybeam" },       guids = { "c2d946" } },
  { name = "Tapu Bulu",    level = 7, types = { "Grass" },    moves = { "Nature's Madness", "Horn Leech" },    guids = { "d099d1" } },
  { name = "Tapu Fini",    level = 7, types = { "Water" },    moves = { "Nature's Madness", "Water Pulse" },   guids = { "573f6c" } },
  { name = "Cosmog",       level = 2, types = { "Psychic" },  moves = { "Teleport", "Splash" },                guids = { "4067b4" },                     evoData = { { cost = 3, ball = YELLOW, gen = 7, guids = { "dd8d38" } } } },
  { name = "Cosmoem",      level = 5, types = { "Psychic" },  moves = { "Cosmic Power", "Teleport" },          guids = { "2d4e82", "dd8d38" },           evoData = { { cost = 2, ball = LEGENDARY, gen = 7, guids = { "2c0206" } }, { cost = 2, ball = LEGENDARY, gen = 7, guids = { "5228d9" } } } },
  { name = "Solgaleo",     level = 7, types = { "Psychic" },  moves = { "Zen Headbutt", "Sunsteel Strike" },   guids = { "2337ba", "5228d9" },           evoData = { { cost = "N-Solarizer", ball = LEGENDARY, gen = 7, guids = { "d63d82" } } } },
  { name = "Lunala",       level = 7, types = { "Psychic" },  moves = { "Moongeist Beam", "Dream Eater" },     guids = { "d118b4", "2c0206" },           evoData = { { cost = "N-Lunarizer", ball = LEGENDARY, gen = 7, guids = { "b01111" } } } },
  { name = "Nihilego",     level = 7, types = { "Rock" },     moves = { "Head Smash", "Venoshock" },           guids = { "e53d16" } },
  { name = "Buzzwole",     level = 7, types = { "Bug" },      moves = { "Dynamic Punch", "Lunge" },            guids = { "b97547" } },
  { name = "Pheromosa",    level = 7, types = { "Bug" },      moves = { "High Jump Kick", "Silver Wind" },     guids = { "6b596f" } },
  { name = "Xurkitree",    level = 7, types = { "Electric" }, moves = { "Zap Cannon", "Power Whip" },          guids = { "c291b1" } },
  { name = "Celesteela",   level = 7, types = { "Steel" },    moves = { "Iron Head", "Air Slash" },            guids = { "6b8a57" } },
  { name = "Kartana",      level = 7, types = { "Grass" },    moves = { "Sacred Sword", "Leaf Blade" },        guids = { "94790b" } },
  { name = "Guzzlord",     level = 7, types = { "Dark" },     moves = { "Dragon Rush", "Crunch" },             guids = { "ed1c1b" } },
  { name = "Necrozma",     level = 7, types = { "Psychic" },  moves = { "Photon Geyser", "Night Slash" },      guids = { "ec14da" },                     evoData = { { cost = "N-Solarizer", ball = LEGENDARY, gen = 7, guids = { "6366eb" } },   -- Dusk Mane
                                                                                                                                                                     { cost = "N-Lunarizer", ball = LEGENDARY, gen = 7, guids = { "1bdda7" } },   -- Dawn Wings
                                                                                                                                                                     { cost = "Ultranecrozium Z", ball = LEGENDARY, gen = 7, guids = { "370a4c" } } } },
  { name = "Dusk Mane Necrozma",level = 7, types = { "Psychic" },  moves = { "Sunsteel Strike", "Prism. Laser" },guids = { "c65377", "d63d82", "6366eb" } },  -- Dusk Mane
  { name = "Dawn Wings Necrozma",level = 7, types = { "Psychic" },  moves = { "Moongeist Beam", "Prism. Laser" },guids = { "2f92e5", "b01111", "1bdda7" } },  -- Dawn Wings
  { name = "Ultra Necrozma",level = 7, types = { "Psychic" },  moves = { "Moongeist Beam", "Sunsteel Strike" },guids = { "370a4c" } },      
  { name = "Magearna",     level = 7, types = { "Steel" },    moves = { "Flash Cannon", "Fleur Cannon" },      guids = { "0ac3f1" } },
  { name = "Poipole",      level = 5, types = { "Poison" },   moves = { "Fury Attack", "Toxic" },              guids = { "6cadb0" },                     evoData = { { cost = 2, ball = LEGENDARY, gen = 7, guids = { "c42a20" } } } },
  { name = "Naganadel",    level = 7, types = { "Poison" },   moves = { "Poison Jab", "Dragon Pulse" },        guids = { "4d5ae0", "c42a20" } },
  { name = "Stakataka",    level = 7, types = { "Rock" },     moves = { "Rock Blast", "Iron Defense" },        guids = { "1446e4" } },
  { name = "Blacephalon",  level = 7, types = { "Fire" },     moves = { "Shadow Ball", "Mind Blown" },         guids = { "38816d" } },
  { name = "Zerora",       level = 7, types = { "Electric" }, moves = { "Hone Claws", "Plasma Fists" },        guids = { "3bc718" } },
  { name = "Meltan",       level = 5, types = { "Steel" },    moves = { "Flash Cannon", "Acid Armor" },        guids = { "abc2d5" } ,                    evoData = { { cost = 2, ball = LEGENDARY, gen = 7, guids = { "aec8ec" } } } },
  { name = "Melmetal",     level = 7, types = { "Steel" },    moves = { "Dbl. Iron Bash", "Hyper Beam" },      guids = { "f35bd5", "aec8ec" },           evoData = { { cost = "GMax", ball = MEGA, gen = 7, ballGuid = "140fbd", guids = { "89bba5", "00eaca" } } } },

  -- Gen 7 Alolan
  { name = "Alolan Rattata",      level = 1, types = { "Dark" },     moves = { "Tail Whip", "Pursuit" },              guids = { "8dc2dc" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "673f0e" } } } },
  { name = "Alolan Raticate",     level = 3, types = { "Dark" },     moves = { "Super Fang", "Crunch" },              guids = { "924294", "673f0e" } },
  { name = "Alolan Raichu",       level = 3, types = { "Electric" }, moves = { "Thunder Shock", "Psychic" },          guids = { "65a373", "1e53ce", "ef1a51" } },
  { name = "Alolan Sandshrew",    level = 1, types = { "Ice" },      moves = { "Powder Snow", "Defense Curl" },       guids = { "e51fcd" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "be4022" } } } },
  { name = "Alolan Sandslash",    level = 3, types = { "Ice" },      moves = { "Metal Claw", "Icicle Crash" },        guids = { "2f3bf2", "be4022" } },
  { name = "Alolan Vulpix",       level = 2, types = { "Ice" },      moves = { "Powder Snow", "Confuse Ray" },        guids = { "edcd10" },                     evoData = { { cost = 3, ball = YELLOW, gen = 7, guids = { "e0f9e1" } } } },
  { name = "Alolan Ninetails",    level = 5, types = { "Ice" },      moves = { "Aurora Beam", "Extrasensory" },       guids = { "950de0", "e0f9e1" } },
  { name = "Alolan Diglett",      level = 2, types = { "Ground" },   moves = { "Metal Claw", "Sand Attack" },         guids = { "a70b67" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "b91f7c" } } } },
  { name = "Alolan Dugtrio",      level = 4, types = { "Ground" },   moves = { "Iron Head", "Dig" },                  guids = { "f4d5cc", "b91f7c" } },
  { name = "Alolan Meowth",       level = 2, types = { "Dark" },     moves = { "Growl", "Bite" },                     guids = { "8df15f" },                     evoData = { { cost = 2, ball = BLUE, gen = 7, guids = { "ccd8e9" } } } },
  { name = "Alolan Persian",      level = 4, types = { "Dark" },     moves = { "Feint Attack", "Screech" },           guids = { "3986bc", "ccd8e9" } },
  { name = "Alolan Geodude",      level = 1, types = { "Rock" },     moves = { "Rock Throw", "Charge" },              guids = { "c5d66d" },                     evoData = { { cost = 3, ball = BLUE, gen = 7, guids = { "01562b" } } } },
  { name = "Alolan Graveler",     level = 4, types = { "Rock" },     moves = { "Thunder Punch", "Self-Destruct" },    guids = { "38fa09", "01562b" },           evoData = { { cost = 2, ball = RED, gen = 7, guids = { "b21424", "7702b6" } } } },
  { name = "Alolan Golem",        level = 6, types = { "Rock" },     moves = { "Stone Edge", "Spark" },               guids = { "6e7cf6", "b21424", "7702b6" } },
  { name = "Alolan Grimer",       level = 4, types = { "Poison" },   moves = { "Disable", "Bite" },                   guids = { "c9ea3a" },                     evoData = { { cost = 1, ball = RED, gen = 7, guids = { "d5d023" } } } },
  { name = "Alolan Muk",          level = 5, types = { "Poison" },   moves = { "Poison Fang", "Crunch" },             guids = { "20e759", "d5d023" } },
  { name = "Alolan Exeggutor",    level = 5, types = { "Grass" },    moves = { "Dragon Hammer", "Seed Bomb" },        guids = { "2b8a77" } },
  { name = "Alolan Marowak",      level = 5, types = { "Fire" },     moves = { "Shadow Bone", "Bone Club" },          guids = { "04850a" } },

  -- Mega evolutions.
  { name = "GMax Melmetal",       level = 7, types = { "Steel" },    moves = { "Meltdown", "Strike" },                guids = { "89bba5", "00eaca" },                     evoData = { { cost = 0, ball = LEGENDARY, gen = 5, ballGuid = "140fbd", guids = { "f35bd5", "aec8ec" } } } },
}

gen8PokemonData =
{
  -- Gen 8 810-834
  { name = "Grookey",       level = 1, types = { "Grass" }, moves = { "Branch Poke", "Growl" },    guids = { "4c56ac" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "b22689" } } } },
  { name = "Thwackey",      level = 3, types = { "Grass" }, moves = { "Double Hit", "Razor Leaf" },   guids = { "ad204e", "b22689" },     evoData = { { cost = 2, ball = RED, gen = 8, guids = { "2eba49", "f9d565" } } } },
  { name = "Rillaboom",     level = 5, types = { "Grass" }, moves = { "Drum Beating", "Boomburst" },     guids = { "d4a518", "2eba49", "f9d565" },            evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "d98c1f", "712942" } } } },
  { name = "Scorbunny",     level = 1, types = { "Fire" }, moves = { "Ember", "Growl" },         guids = { "d5c9cd" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "5cef8f" } } } },
  { name = "Raboot",        level = 3, types = { "Fire" }, moves = { "Double Kick", "Flame Charge" }, guids = { "a179de", "5cef8f" },   evoData = { { cost = 2, ball = RED, gen = 8, guids = { "e52d3f", "77f114" } } } },
  { name = "Cinderace",     level = 5, types = { "Fire" }, moves = { "Pyro Ball", "Bounce" }, guids = { "68e885", "e52d3f", "77f114" },                       evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "0ae3eb", "35db21" } } } },
  { name = "Sobble",        level = 1, types = { "Water" }, moves = { "Water Gun", "Growl" },    guids = { "732820" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "767be0" } } } },
  { name = "Drizzile",      level = 3, types = { "Water" }, moves = { "Water Pulse", "Tearful Look" }, guids = { "1ff7e7", "767be0" },    evoData = { { cost = 2, ball = RED, gen = 8, guids = { "caa8d1", "70e2dd" } } } },
  { name = "Inteleon",      level = 5, types = { "Water" }, moves = { "Snipe Shot", "U-Turn" }, guids = { "a87b0f", "caa8d1", "70e2dd" },                     evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "834995", "e4f6e7" } } } },
  { name = "Skwovet",       level = 1, types = { "Normal" }, moves = { "Tail Whip", "Bite" },          guids = { "0092fc" },               evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "0f5cf9" } } } },
  { name = "Greedent",      level = 3, types = { "Normal" }, moves = { "Stuff Cheeks", "Covet" },  guids = { "7d0ad9", "0f5cf9" } },
  { name = "Rookidee",      level = 1, types = { "Flying" }, moves = { "Fury Attack", "Peck" }, guids = { "6d058d"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "aac3a7" } } } },
  { name = "Corvisquire",   level = 3, types = { "Flying" }, moves = { "Hone Claws", "Drill Peck" },     guids = { "817152", "aac3a7" },     evoData = { { cost = 3, ball = RED, gen = 8, guids = { "29b1df", "39c41f"} } } },
  { name = "Corviknight",   level = 6, types = { "Flying" }, moves = { "Brave Bird", "Steel Wing" }, guids = { "d80b24", "29b1df", "39c41f" },                evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "ea919f", "1c820c" } } } },
  { name = "Blipbug",       level = 1, types = { "Bug" }, moves = { "Struggle Bug"}, guids = { "e534da" },              evoData = { { cost = 1, ball = PINK, gen = 8, guids = { "fa8ba4" } } } },
  { name = "Dottler",       level = 2, types = { "Bug" }, moves = { "Confusion", "Reflect" },     guids = { "a228d5", "fa8ba4" },    evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "6e7247", "eb4403" } } }},
  { name = "Orbeetle",      level = 4, types = { "Bug" }, moves = { "Bug Buzz", "Psychic" }, guids = { "4150f3", "6e7247", "eb4403" },                        evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "27ad44", "aee305" } } } },
  { name = "Nickit",        level = 1, types = { "Dark" }, moves = { "Quick Attack", "Thief" },      guids = { "7e6383"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "cf334e" } } } },
  { name = "Thievul",       level = 3, types = { "Dark" }, moves = { "Tail Slap", "Snarl" }, guids = { "37a9d1", "cf334e" } },
  { name = "Gossifleur",    level = 2, types = { "Grass" }, moves = { "Rapid Spin", "Leafage" },     guids = { "bbf00f" }, evoData = { { cost = 1, ball = GREEN, gen = 8, guids = { "f8b45c" } } }  }, 
  { name = "Eldegoss",      level = 3, types = { "Grass" }, moves = { "Cotton Guard", "Hyper Voice" },     guids = { "4f25ee", "f8b45c" }  },
  { name = "Wooloo",        level = 1, types = { "Normal" }, moves = { "Double Kick", "Defense Curl" },     guids = { "f627d1" }, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "17bfff" } } }  }, 
  { name = "Dubwool",       level = 3, types = { "Normal" }, moves = { "Cotton Guard", "Headbutt" },     guids = { "9bc17c", "17bfff" }  },
  { name = "Chewtle",       level = 1, types = { "Water" }, moves = { "Water Gun", "Protect" },  guids = { "9ea87e" }, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "bf22b0" } } }},
  { name = "Drednaw",       level = 3, types = { "Water" }, moves = { "Razor Shell", "Jaw Lock" },         guids = { "620b5e", "bf22b0" },                    evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "8054c2", "5cb470" } } } },

  -- Gen 8 835-858
  { name = "Yamper",        level = 1, types = { "Electric" }, moves = { "Nuzzle", "Roar" }, guids = { "71d863" }, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "d10387"} } } },
  { name = "Boltund",       level = 3, types = { "Electric" }, moves = { "Wild Charge", "Bite" },   guids = { "fa69eb", "d10387"}  }, 
  { name = "Rolycoly",      level = 1, types = { "Rock" }, moves = { "Rock Polish", "Rapid Spin" },   guids = { "152d0a"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "19ffab"} } } }, 
  { name = "Carkol",        level = 3, types = { "Rock" }, moves = { "Rock Blast", "Flame Charge" },   guids = { "7e1e68", "19ffab"}, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "678720", "5eecb1"} } }  }, -- 
  { name = "Coalossal",     level = 5, types = { "Rock" }, moves = { "Ancient Power", "Incinerate" }, guids = { "6ac20e", "678720", "5eecb1" },                evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "423aca", "6407e4" } } } },
  { name = "Applin",        level = 2, types = { "Grass" }, moves = { "Astonish", "Withdraw" },  guids = { "5d39a1" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "508cc7" } }, { cost = 2, ball = YELLOW, gen = 8, guids = { "3a326b" } }, { cost = 2, ball = YELLOW, gen = 9, guids = { "951a30" } } }},
  { name = "Flapple",       level = 4, types = { "Grass" }, moves = { "Grav Apple", "Dragon Pulse" }, guids = { "beb575", "508cc7" },                    evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "c4ec8a", "975b3c"} } } },
  { name = "Appletun",      level = 4, types = { "Grass" }, moves = { "Apple Acid", "Dragon Pulse" },  guids = { "a26f34", "3a326b" },                   evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "945af3", "31aacc" } } } },
  { name = "Silicobra",     level = 3, types = { "Ground" }, moves = { "Sandstorm", "Wrap" }, guids = { "2f1d01" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "3e0da6"} } } },
  { name = "Sandaconda",    level = 5, types = { "Ground" }, moves = { "Sand Tomb", "Coil" }, guids = { "c91baf", "3e0da6" },                            evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "2e2482", "3ab61a" } } } },
  { name = "Cramorant",     level = 4, types = { "Flying" }, moves = { "Spit Up", "Dive" },  guids = { "55ee12"} }, 
  { name = "Arrokuda",      level = 2, types = { "Water" }, moves = { "Fury Attack", "Aqua Jet" }, guids = { "642dca"}, evoData = { { cost = 1, ball = GREEN, gen = 8, guids = { "e1ccdd" } } }    },
  { name = "Barraskewda",   level = 3, types = { "Water" }, moves = { "Double-Edge", "Liquidation" },     guids = { "1e3235", "e1ccdd" }, }, 
  { name = "Toxel",         level = 2, types = { "Electric" }, moves = { "Tearful Look", "Nuzzle" },  guids = { "21446c" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "bea82d" } }, { cost = 2, ball = YELLOW, gen = 8, guids = { "a7277f" } }  } },
  { name = "Toxtricity",    level = 4, types = { "Electric" }, moves = { "Boomburst", "Overdrive" },    guids = { "0c6876", "bea82d" },                            evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "1644af", "f8615c" } } } }, -- Amped Form
  { name = "Toxtricity",    level = 4, types = { "Electric" }, moves = { "Poison Jab", "Overdrive" },    guids = { "67ec92", "a7277f" },                           evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "8c4dd2", "e01e0a" } } } }, -- Low Key Form
  { name = "Sizzlipede",    level = 2, types = { "Fire" }, moves = { "Wrap", "Ember" }, guids = { "d3aefa"}, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "bf95c2" } } } },
  { name = "Centiskorch",   level = 4, types = { "Fire" }, moves = { "Flame Wheel", "Bug Bite" },   guids = { "5b2923", "bf95c2" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "457776", "f8726f" } } } },
  { name = "Clobbopus",     level = 3, types = { "Fighting" }, moves = { "Rock Smash", "Taunt" }, guids = { "5ddd8c" }, evoData = { { cost = 1, ball = BLUE, gen = 8, guids = { "4725cb" } } }  },
  { name = "Grapploct",     level = 4, types = { "Fighting" }, moves = { "Octazooka", "Octolock" }, guids = { "d20c3d", "4725cb"} },
  { name = "Sinistea",      level = 3, types = { "Ghost" }, moves = { "Astonish", "Mega Drain" }, guids = { "db3703"}, evoData = { { cost = 1, ball = BLUE, gen = 8, guids = { "584ee3" } } } },
  { name = "Polteageist",   level = 4, types = { "Ghost" }, moves = { "Curse", "Protect" },  guids = { "9b2f6e", "584ee3" } },
  { name = "Hatenna",       level = 2, types = { "Psychic" }, moves = { "Confusion", "Play Nice" },    guids = { "c0efd5"}, evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "fc0b6e" } } }    },
  { name = "Hattrem",       level = 4, types = { "Psychic" }, moves = { "Disarming Voice", "Brutal Swing" },  guids = { "c29b93", "fc0b6e"}, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "9cfe10", "42db1f" } } } },
  { name = "Hatterene",     level = 6, types = { "Psychic" }, moves = { "Dazzling Gleam", "Psybeam" },  guids = { "e711fc", "9cfe10", "42db1f" },                   evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "0fab1b", "73ef1b" } } } },

  -- Gen 8 859-884
  { name = "Impidimp",      level = 3, types = { "Dark" }, moves = { "Assurance", "Swagger"}, guids = { "955f8e" },            evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "09d5df" } } } },
  { name = "Morgrem",       level = 5, types = { "Dark" }, moves = { "Sucker Punch", "Play Rough" },       guids = { "372fdf", "09d5df" }, evoData = { { cost = 1, ball = RED, gen = 8, guids = { "09fbc4", "1d1bc9" } } } },
  { name = "Grimmsnarl",    level = 6, types = { "Dark" }, moves = { "Spirit Break", "Foul Play" }, guids = { "9a62bf", "09fbc4", "1d1bc9" },                       evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "671823", "325e58" } } } },
  { name = "Obstagoon",     level = 5, types = { "Dark" }, moves = { "Night Slash", "Counter" },   guids = { "355878", "f9576c", "18880a" }  },
  { name = "Perrserker",    level = 4, types = { "Steel" }, moves = { "Iron Head", "Swagger" },      guids = { "352cd9", "33995d"} },
  { name = "Cursola",       level = 5, types = { "Ghost" }, moves = { "Night Shade", "Mirror Coat" },       guids = { "05fc5b", "ac68fa" } },
  { name = "Sirfetch'd",    level = 5, types = { "Fighting" }, moves = { "Knock Off", "Brick Break" }, guids = { "d7a5ef", "166853"} }, 
  { name = "Mr. Rime",      level = 5, types = { "Ice" }, moves = { "Ice Punch", "Psybeam" }, guids = { "f05e97", "f5e748", "2de3e8"} },
  { name = "Runerigus",     level = 5, types = { "Ground" }, moves = { "Earthquake", "Curse" }, guids = { "78c895", "b8d9ee"} },
  { name = "Milcery",       level = 6, types = { "Fairy" }, moves = { "Sweet Kiss", "Tackle" }, guids = { "d07981"}, evoData = { { cost = 1, ball = BLUE, gen = 8, guids = { "f57bd3" } } } },
  { name = "Alcremie",      level = 3, types = { "Fairy" }, moves = { "Dazzling Gleam", "Decorate" }, guids = { "71833d", "f57bd3" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "3c5cba", "0b4ee1" } } } },
  { name = "Falinks",       level = 4, types = { "Fighting" }, moves = { "First Impression", "No Retreat" }, guids = { "8bb381" } },
  { name = "Pincurchin",    level = 3, types = { "Electric" }, moves = { "Toxic Spikes", "Zing Zap" }, guids = { "4657b0" } },
  { name = "Snom",          level = 2, types = { "Ice" }, moves = { "Powder Snow", "Struggle Bug" }, guids = { "b1d7df" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "8b539d" } } } },
  { name = "Frosmoth",      level = 4, types = { "Ice" }, moves = { "Quiver Dance", "Icy Wind" }, guids = { "613ae8", "8b539d" } },
  { name = "Stonjourner",   level = 4, types = { "Rock" }, moves = { "Wide Guard", "Mega Kick" }, guids = { "ad7026"} },
  { name = "Eiscue",        level = 3, types = { "Ice" }, moves = { "Headbutt", "Hail" }, guids = { "7367d0" } }, -- Ice Block Head
  { name = "Eiscue",        level = 3, types = { "Ice" }, moves = { "Amnesia", "Mist" }, guids = { "7da34a" } },  -- Sad Slime Head
  { name = "Indeedee",      level = 3, types = { "Psychic" }, moves = { "Disarming Voice", "Psychic" }, guids = { "d23303"  } },
  { name = "Morpeko",       level = 3, types = { "Electric" }, moves = { "Aura Wheel Electric", "Thrash" }, guids = { "d7c95a" }, evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "364510" } } } }, -- Yellow Happy :)
  { name = "Morpeko",       level = 3, types = { "Dark" }, moves = { "Aura Wheel Dark", "Thrash" }, guids = { "364510" }, evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "d7c95a" } } } },         -- Purple Angry :(
  { name = "Morpeko",       level = 3, types = { "Dark" }, moves = { "Aura Wheel Dark", "Thrash" }, guids = { "ccf33f" }, evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd",guids = { "49450f" } } } },          -- Purple Angry :(
  { name = "Morpeko",       level = 3, types = { "Electric" }, moves = { "Aura Wheel Electric", "Thrash" }, guids = { "49450f" }, evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "ccf33f" } } } }, -- Yellow Happy :)
  { name = "Cufant",        level = 3, types = { "Steel" }, moves = { "Rock Smash", "Iron Defense" }, guids = { "e94da5" }, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "bb0dab" } } } },
  { name = "Copperajah",    level = 5, types = { "Steel" }, moves = { "H. Horsepower", "Iron Head" }, guids = { "772688", "bb0dab" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "ad2c75", "1e68f7" } } } },
  { name = "Dracozolt",     level = 4, types = { "Electric" }, moves = { "Ancient Power", "Discharge" }, guids = { "8c8145" } },                   
  { name = "Arctozolt",     level = 4, types = { "Electric" }, moves = { "Ancient Power", "Freeze-Dry" }, guids = { "21422d"} }, 
  { name = "Dracovish",     level = 4, types = { "Water" }, moves = { "Dragon Rush", "Ancient Power" }, guids = { "79900c"} }, 
  { name = "Arctovish",     level = 4, types = { "Water" }, moves = { "Ancient Power", "Liquidation" }, guids = { "d8d24a"} },
  { name = "Duraludon",     level = 5, types = { "Steel" }, moves = { "Metal Claw", "Dragon Claw" }, guids = { "19c226" }, evoData = { { cost = 1, ball = RED, gen = 9, guids = { "3a6873" } }, { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "e17508", "ff891b" } } }  }, 
  { name = "Dreepy",        level = 2, types = { "Dragon" }, moves = { "Infestation", "Astonish" }, guids = { "947a92" }, evoData = { { cost = 3, ball = YELLOW, gen = 8, guids = { "b9b3ac" } } }  }, 
  { name = "Drakloak",      level = 5, types = { "Dragon" }, moves = { "Double Hit", "Dragon Pulse" }, guids = { "0dd987", "b9b3ac" }, evoData = { { cost = 2, ball = RED, gen = 8, guids = { "0fafd7", "89c1a8" } } } }, 
  { name = "Dragapult",     level = 7, types = { "Dragon" }, moves = { "Dragon Darts", "Phantom Force" }, guids = { "ccc405", "0fafd7", "89c1a8" } },
  { name = "Zacian",        level = 7, types = { "Fairy" }, moves = { "Sacred Sword", "Moonblast" }, guids = { "e97b5b" }, evoData = { { cost = "Rusted Sword", ball = LEGENDARY, gen = 8, guids = { "c3ff51"} } } },
  { name = "Zacian",        level = 8, types = { "Fairy" }, moves = { "Behemoth Blade", "Play Rough" }, guids = { "c3ff51" } },     -- C. Sword
  { name = "Zamazenta",     level = 7, types = { "Fighting" }, moves = { "Iron Defense", "Revenge" }, guids = { "925e6b" }, evoData = { { cost = "Rusted Shield", ball = LEGENDARY, gen = 8, guids = { "51a0ef"} } }},
  { name = "Zamazenta",     level = 8, types = { "Fighting" }, moves = { "Behemoth Bash", "Close Combat" }, guids = { "51a0ef" } }, -- C. Shield
  { name = "Eternatus",     level = 7, types = { "Poison" }, moves = { "Cross Poison", "D-max Cannon" }, guids = { "c0d41b" },                                evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "e78955" } } } },
  { name = "Kubufu",        level = 5, types = { "Fighting" }, moves = { "Headbutt", "Counter" }, guids = { "312af1" }, evoData = { { cost = "Scroll of Waters", ball = LEGENDARY, gen = 8, guids = { "ab896e"} }, { cost = "Scroll of Darkness", ball = LEGENDARY, gen = 8, guids = { "015ff0"} } } },
  { name = "Urshifu",       level = 7, types = { "Fighting" }, moves = { "Surging Strikes", "Brick Break" }, guids = { "ab896e" },   evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "bf033c" } } } }, -- Rapid Strike
  { name = "Urshifu",       level = 7, types = { "Fighting" }, moves = { "Wicked Blow", "Brick Break" }, guids = { "015ff0" },       evoData = { { cost = "GMax", ball = MEGA, gen = 8, ballGuid = "140fbd", guids = { "dd3373" } } } }, -- Single Strike
  { name = "Zarude",        level = 7, types = { "Dark" }, moves = { "Jungle Healing", "Brutal Swing" }, guids = { "651f81" } }, 
  { name = "Regieleki",     level = 7, types = { "Electric" }, moves = { "Thunder Cage", "Hyper Beam" }, guids = { "45a74f"} },
  { name = "Regidrago",     level = 7, types = { "Dragon" }, moves = { "Dragon Energy", "Thrash" }, guids = { "2ec2b8" } }, 
  { name = "Glastrier",     level = 7, types = { "Ice" }, moves = { "Icicle Crash", "Iron Defense" }, guids = { "05139e" }, evoData = { { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, guids = { "5e40a8", "004eaf" } } } }, 
  { name = "Spectrier",     level = 7, types = { "Ghost" }, moves = { "Shadow Ball", "Thrash" }, guids = { "3b4d86" }, evoData = { { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, guids = { "86748a", "3b7a04" } } } }, 
  { name = "Calyrex",       level = 7, types = { "Psychic" }, moves = { "Energy Ball", "Psychic" }, guids = { "c91740"}, evoData = { { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, guids = { "86748a", "3b7a04" } }, { cost = "Reigns of Unity", ball = LEGENDARY, gen = 8, guids = { "5e40a8", "004eaf" } } } }, 
  { name = "Calyrex",       level = 8, types = { "Psychic" }, moves = { "Astral Barrage", "Psychic" }, guids = { "86748a", "3b7a04" } }, -- Shadow Rider
  { name = "Calyrex",       level = 8, types = { "Psychic" }, moves = { "Glacial Lance", "Psychic" }, guids = { "5e40a8", "004eaf" } },  -- Ice Rider
  { name = "Wyrdeer",       level = 4, types = { "Normal" }, moves = { "Psyshield Bash", "Double-Edge" }, guids = { "dabd21", "163267" } },
  { name = "Kleavor",       level = 5, types = { "Bug" }, moves = { "Stone Axe", "X-Scissor" }, guids = { "deef29", "18d390" }  },
  { name = "Ursaluna",      level = 6, types = { "Ground" }, moves = { "Headlong Rush", "Play Rough" }, guids = { "b3110d", "7684c6", "2c6eaa" } },
  { name = "Bloodmoon Ursaluna", level = 6, types = { "Ground" }, moves = { "Blood Moon", "Moonlight" }, guids = { "05e0a2", "0af179", "d9574b" } },
  { name = "Basculegion",   level = 4, types = { "Water" }, moves = { "Wave Crash", "Phantom Force" }, guids = { "e2e65c", "357bf0" } },
  { name = "Sneasler",      level = 5, types = { "Fighting" }, moves = { "Close Combat", "Slash" }, guids = { "20e684", "8b5f40" } },
  { name = "Overqwil",      level = 5, types = { "Dark" }, moves = { "Dark Pulse", "Poison Jab" }, guids = { "c891fc", "a4fb02" } },
  { name = "Enamorus",      level = 7, types = { "Fairy" }, moves = { "Spring. Storm", "Superpower" }, guids = { "3ba79b" } }, -- Non-Turtle Version
  { name = "Enamorus",      level = 7, types = { "Fairy" }, moves = { "Spring. Storm", "Outrage" }, guids = { "52580d" } },    -- Turtle Version
  
  -- GenVIII Hisuian, Galarian
  { name = "Galarian Zigzagoon",level = 1, types = { "Dark" },  moves = { "Pin Missile", "Leer" },         guids = { "2eae89"},            evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "513b01"} } } },
  { name = "Galarian Linoone", level = 3, types = { "Dark" },   moves = { "Take Down", "Lick" },           guids = { "967c36", "513b01" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "18880a", "f9576c"} } } }, 
  { name = "Galarian Meowth",  level = 2, types = { "Steel" },  moves = { "Fury Swipes", "Metal Claw" },   guids = { "9df32b" },           evoData = { { cost = 2, ball = BLUE, gen = 8, guids = { "33995d"} } } },
  { name = "Galarian Corsola", level = 3, types = { "Ghost" },  moves = { "Ancient Power", "Astonish" },   guids = { "eb13ff" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "ac68fa"} } }  },
  { name = "Galarian Farfetch'd",level = 3, types = { "Fighting" }, moves = { "Sand Attack", "Slam" },     guids = { "2a641b" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "166853"} } } },
  { name = "Galarian Mr. Mime",level = 3, types = { "Ice" },    moves = { "Ice Shard", "Encore" },         guids = { "ad9b7a", "8cfe98" }, evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "f5e748", "2de3e8"} } }  },
  { name = "Galarian Yamask",  level = 3, types = { "Ground" }, moves = { "Brutal Swing", "Astonish" },    guids = { "fb6107" },           evoData = { { cost = 2, ball = RED, gen = 8, guids = { "b8d9ee"} } } }, 
  { name = "Hisuian Basculin", level = 2, types = { "Water" },  moves = { "Aqua Jet", "Crunch" },          guids = { "039880" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "357bf0"} } } },
  { name = "Hisuian Sneasel",  level = 3, types = { "Fighting" },moves = { "Swords Dance", "Poison Jab" }, guids = { "fd17a9" },           evoData = { { cost = 2, ball = YELLOW, gen = 8, guids = { "8b5f40"} } } },
  { name = "Hisuian Qwilfish", level = 4, types = { "Dark" },   moves = { "Pin Missile", "Spikes" },       guids = { "d2929c" },           evoData = { { cost = 1, ball = YELLOW, gen = 8, guids = { "a4fb02"} } } },
  { name = "Hisuian Growlithe",level = 2, types = { "Fire" },   moves = { "Rock Slide", "Swift" },         guids = { "0c6d18" },           evoData = { { cost = 3, ball = YELLOW, gen = 8, guids = { "2ab034"} } } }, 
  { name = "Hisuian Arcanine", level = 5, types = { "Fire" },   moves = { "Flare Blitz", "Crunch" },       guids = { "943d83", "2ab034" } },
  { name = "Galarian Ponyta",  level = 4, types = { "Psychic" },moves = { "Take Down", "Confusion" },      guids = { "918a64" },           evoData = { { cost = 2, ball = RED , gen = 8, guids = { "de6ae0"} } } }, 
  { name = "Galarian Rapidash",level = 6, types = { "Psychic" },moves = { "Dazzling Gleam", "Psybeam" },   guids = { "33cf1f", "de6ae0" } },
  { name = "Galarian Slowpoke",level = 2, types = { "Psychic" },moves = { "Confusion", "Acid" },           guids = { "c5b427" },           evoData = { { cost = 3, ball = RED , gen = 8, guids = { "1b1569"} }, { cost = 3, ball = RED , gen = 8, guids = { "e01e53"} } } }, 
  { name = "Galarian Slowbro", level = 5, types = { "Poison" }, moves = { "Shell Side Arm", "Water Arm" }, guids = { "8bb5c6", "1b1569" } },
  { name = "Galarian Slowking",level = 5, types = { "Poison" }, moves = { "Power Gem", "Eerie Spell" },    guids = { "d817c2", "e01e53" } },
  { name = "Hisuian Voltorb",  level = 2, types = { "Electric" }, moves = { "Thunder Wave", "Energy Ball" }, guids = { "1de2a1" },         evoData = { { cost = 2, ball = BLUE , gen = 8, guids = { "31ab95"} } } }, 
  { name = "Hisuian Electrode",level = 4, types = { "Electric" }, moves = { "Thunder Shock", "Chloroblast" }, guids = { "af44ee", "31ab95" } },
  { name = "Galarian Weezing", level = 5, types = { "Poison" }, moves = { "Strange Steam", "Sludge" },     guids = { "8864bd", "dccfa4" } },
  { name = "Galarian Articuno",level = 7, types = { "Psychic" },moves = { "Freezing Glare", "Hurricane" }, guids = { "df62df" } },
  { name = "Galarian Zapdos",  level = 7, types = { "Fighting" },moves = { "Close Combat", "Drill Peck" }, guids = { "43f2c8" } },
  { name = "Galarian Moltres", level = 7, types = { "Dark" },   moves = { "Sky Attack", "Fiery Wrath" },   guids = { "f194d1" } },
  { name = "Hisuian Typhlosion", level = 5, types = { "Fire" }, moves = { "Flamethrower", "Shadow Ball" }, guids = { "4ece6d", "e8349c", "c86580" } },
  { name = "Hisuian Samurott", level = 5, types = { "Water" },  moves = { "Ceaseless Edge", "Razor Shell" }, guids = { "1e7846", "769c18", "c7dc10" } },
  { name = "Hisuian Lilligant",level = 5, types = { "Grass" },  moves = { "Rock Smash", "Leaf Blade" },   guids = { "a1d8b8", "13e980" } },
  { name = "Galarian Darumaka",level = 3, types = { "Ice" },    moves = { "Ice Fang", "Rollout" },        guids = { "d2942a" },            evoData = { { cost = 2, ball = YELLOW , gen = 8, guids = { "d37822"} }, { cost = 2, ball = YELLOW , gen = 8, guids = { "382428"} } }  }, 
  { name = "Galarian Darmanitan",level = 5, types = { "Ice" },  moves = { "Ice Punch", "Superpower" },    guids = { "c14bd8", "d37822" } }, -- Ice/Fighting
  { name = "Galarian Darmanitan",level = 5, types = { "Ice" },  moves = { "Ice Punch", "Fire Punch" },    guids = { "f87608", "382428" } }, -- Ice/Fire
  { name = "Hisuian Zorua",    level = 3, types = { "Normal" }, moves = { "Shadow Sneak", "Nasty Plot" }, guids = { "b25340" },            evoData = { { cost = 2, ball = YELLOW , gen = 8, guids = { "f46ea3"} } }  }, 
  { name = "Hisuian Zorark",   level = 5, types = { "Normal" }, moves = { "Bitter Malice", "Foul Play" }, guids = { "b02e47", "f46ea3" } },
  { name = "Galarian Stunfisk",level = 3, types = { "Ground" }, moves = { "Metal Claw", "Mud Shot" },     guids = { "d1fcec" } },
  { name = "Hisuian Braviary", level = 6, types = { "Psychic" },moves = { "Esper Wing", "Brave Bird" },   guids = { "29010a", "aaa239" } },
  { name = "Hisuian Sliggoo",  level = 4, types = { "Steel" },  moves = { "Dragon Pulse", "Acid Armor" }, guids = { "105e3c", "3ed28a" },  evoData = { { cost = 3, ball = RED , gen = 8, guids = { "3d0228", "c49cfb"} } } },
  { name = "Hisuian Goodra",   level = 7, types = { "Steel" },  moves = { "Iron Head", "Hydro Pump" },    guids = { "81bf31", "3d0228", "c49cfb" } }, 
  { name = "Hisuian Avalugg",  level = 5, types = { "Ice" },    moves = { "Rock Slide", "Ice Shard" },    guids = { "06528c", "2edcdb" } },
  { name = "Hisuian Decidueye",level = 5, types = { "Grass" },  moves = { "Triple Arrows", "Leaf Storm" },guids = { "655289", "cf7b80", "5ada77" } },

  -- Mega evolutions.
  { name = "GMax Rillaboom",       level = 5, types = { "Grass" },    moves = { "Drum Solo", "Strike" },                guids = { "d98c1f", "712942" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "d4a518", "2eba49", "f9d565" } } } },
  { name = "GMax Cinderace",       level = 5, types = { "Fire" },     moves = { "Fireball", "Airstream" },              guids = { "0ae3eb", "35db21" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "68e885", "e52d3f", "77f114" } } } },
  { name = "GMax Inteleon",        level = 5, types = { "Water" },    moves = { "Hydro Snipe", "Flutterby" },           guids = { "834995", "e4f6e7" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "a87b0f", "caa8d1", "70e2dd" } } } },
  { name = "GMax Corviknight",     level = 6, types = { "Flying" },   moves = { "Wind Rage", "Steelspike" },            guids = { "ea919f", "1c820c" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "d80b24", "29b1df", "39c41f" } } } },
  { name = "GMax Orbeetle",        level = 4, types = { "Bug" },      moves = { "Gravitas", "Flutterby" },              guids = { "27ad44", "aee305" },       evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "4150f3", "6e7247", "eb4403" } } } },
  { name = "GMax Drednaw",         level = 3, types = { "Water" },    moves = { "Stonesurge", "Darkness" },             guids = { "8054c2", "5cb470" },       evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "620b5e", "bf22b0" } } } },
  { name = "GMax Coalossal",       level = 5, types = { "Rock" },     moves = { "Volcalith", "Flare" },                 guids = { "423aca", "6407e4" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "6ac20e", "678720", "5eecb1" } } } },
  { name = "GMax Flapple",         level = 4, types = { "Grass" },    moves = { "Tartness", "Wyrmwind" },               guids = { "c4ec8a", "975b3c" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "beb575", "508cc7" } } } },
  { name = "GMax Appletun",        level = 4, types = { "Grass" },    moves = { "Sweetness", "Wyrmwind" },              guids = { "945af3", "31aacc" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "a26f34", "3a326b" } } } },
  { name = "GMax Sandaconda",      level = 5, types = { "Rock" },     moves = { "Sandblast", "Guard" },                 guids = { "2e2482", "3ab61a" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "c91baf", "3e0da6" } } } },
  { name = "GMax Toxtricity",      level = 4, types = { "Electric" }, moves = { "Stun Shock", "Ooze" },                 guids = { "1644af", "f8615c" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "0c6876", "bea82d" } } } },
  { name = "GMax Toxtricity",      level = 4, types = { "Electric" }, moves = { "Stun Shock", "Ooze" },                 guids = { "8c4dd2", "e01e0a" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "67ec92", "a7277f" } } } },
  { name = "GMax Centiskorch",     level = 4, types = { "Fire" },     moves = { "Centiferno", "Flutterby" },            guids = { "457776", "f8726f" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "5b2923", "bf95c2" } } } },
  { name = "GMax Hatterene",       level = 6, types = { "Psychic" },  moves = { "Mindstorm", "Smite" },                 guids = { "0fab1b", "73ef1b" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "e711fc", "9cfe10", "42db1f" } } } },
  { name = "GMax Grimmsnarl",      level = 6, types = { "Dark" },     moves = { "Snooze", "Starfall" },                 guids = { "671823", "325e58" },       evoData = { { cost = 0, ball = RED, gen = 8, ballGuid = "140fbd", guids = { "9a62bf", "09fbc4", "1d1bc9" } } } },
  { name = "GMax Alcremie",        level = 3, types = { "Fairy" },    moves = { "Finale", "Guard" },                    guids = { "3c5cba", "0b4ee1" },       evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "71833d", "f57bd3" } } } },
  { name = "GMax Copperajah",      level = 5, types = { "Steel" },    moves = { "Steelsurge", "Quake" },                guids = { "ad2c75", "1e68f7" },       evoData = { { cost = 0, ball = BLUE, gen = 8, ballGuid = "140fbd", guids = { "772688", "bb0dab" } } } },
  { name = "GMax Duraludon",       level = 5, types = { "Steel" },    moves = { "Wyrmwind", "Depletion" },              guids = { "e17508", "ff891b" },       evoData = { { cost = 0, ball = YELLOW, gen = 8, ballGuid = "140fbd", guids = { "19c226" } } } },
  { name = "GMax Eternatus",       level = 7, types = { "Poison" },   moves = { "Eternabeam", "Ooze" },                 guids = { "e78955" },                 evoData = { { cost = 0, ball = LEGENDARY, gen = 8, ballGuid = "140fbd", guids = { "c0d41b" } } } },
  { name = "GMax R.S. Urshifu",    level = 7, types = { "Fighting" }, moves = { "Rapid Flow", "Knuckle" },              guids = { "bf033c" },                 evoData = { { cost = 0, ball = LEGENDARY, gen = 8, ballGuid = "140fbd", guids = { "ab896e" } } } },
  { name = "GMax R.S. Urshifu",    level = 7, types = { "Fighting" }, moves = { "One Blow", "Knuckle" },                guids = { "dd3373" },                 evoData = { { cost = 0, ball = LEGENDARY, gen = 8, ballGuid = "140fbd", guids = { "015ff0" } } } },
}

gen9PokemonData =
{
  -- Gen 9 906-925
  { name = "Sprigatito",    level = 1, types = { "Grass" }, moves = { "Tail Whip", "Leafage" },    guids = { "49980a" },               evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "d04b95" } } } },
  { name = "Floragato",     level = 3, types = { "Grass" }, moves = { "Hone Claws", "Seed Bomb" },   guids = { "195a4d", "d04b95" },     evoData = { { cost = 2, ball = RED, gen = 9, guids = { "2b0cec", "603216" } } } },
  { name = "Meowscarada",   level = 5, types = { "Grass" }, moves = { "Flower Trick", "Knock Off" },     guids = { "7b87eb", "2b0cec", "603216" }, },
  { name = "Fuecoco",       level = 1, types = { "Fire" }, moves = { "Ember", "Leer" },         guids = { "53ad3b" },               evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "2a93fc" } } } },
  { name = "Crocalor",      level = 3, types = { "Fire" }, moves = { "Incinerate", "Bite" }, guids = { "f49cc4", "2a93fc" },   evoData = { { cost = 2, ball = RED, gen = 9, guids = { "0528b7", "91d3a3" } } } },
  { name = "Skeledirge",    level = 5, types = { "Fire" }, moves = { "Shadow Ball", "Torch Song" }, guids = { "6b9ddf", "0528b7", "91d3a3" }, },
  { name = "Quaxly",        level = 1, types = { "Water" }, moves = { "Water Gun", "Growl" },    guids = { "4a2233" },               evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "76b74f" } } } },
  { name = "Quaxwell",      level = 3, types = { "Water" }, moves = { "Feather Dance", "Aqua Jet" }, guids = { "dc2818", "76b74f" },    evoData = { { cost = 2, ball = RED, gen = 9, guids = { "517d88", "7bf3d4" } } } },
  { name = "Quaquaval",     level = 5, types = { "Water" }, moves = { "Aqua Step", "Counter" }, guids = { "07d04b", "517d88", "7bf3d4" }, },
  { name = "Lechonk",       level = 1, types = { "Normal" }, moves = { "Tackle", "Tail Whip" }, guids = { "fa7a0e" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "731928" } }, { cost = 2, ball = BLUE, gen = 9, guids = { "9bc692" } } } },
  { name = "Oinkologne",    level = 3, types = { "Normal" }, moves = { "Headbutt", "Yawn" },  guids = { "286c12", "731928" } },
  { name = "Oinkologne",    level = 3, types = { "Normal" }, moves = { "Take Down", "Work Up" }, guids = { "4a7427", "9bc692" } },
  { name = "Tarontula",     level = 1, types = { "Bug" }, moves = { "String Shot", "Tackle" },     guids = { "990287" },     evoData = { { cost = 2, ball = GREEN, gen = 9, guids = { "c3494f" } } } },
  { name = "Spidops",       level = 3, types = { "Bug" }, moves = { "Circle Throw", "Silk Trap" }, guids = { "df9262", "c3494f" } },
  { name = "Nymble",        level = 1, types = { "Bug" }, moves = { "Double Kick", "Leer" }, guids = { "6bf5d7" },              evoData = { { cost = 2, ball = GREEN, gen = 9, guids = { "a8959f" } } } },
  { name = "Lokix",         level = 3, types = { "Bug" }, moves = { "First Impression", "Assurance" },     guids = { "2f2f62", "a8959f" } },
  { name = "Pawmi",         level = 1, types = { "Electric" }, moves = { "Nuzzle", "Growl" }, guids = { "6126de" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "27ce58" } } }            },
  { name = "Pawmo",         level = 3, types = { "Electric" }, moves = { "Arm Thrust", "Spark" },      guids = { "63603f", "27ce58" }, evoData = { { cost = 1, ball = YELLOW, gen = 9, guids = { "d01611", "508f9a" } } } },
  { name = "Pawmot",        level = 4, types = { "Electric" }, moves = { "Revival Blessing", "Discharge" }, guids = { "b34f73", "d01611", "508f9a" } },
  { name = "Tandemaus",     level = 2, types = { "Normal" }, moves = { "Baby-Doll Eyes", "Super Fang" },     guids = { "4400f3" }, evoData = { { cost = 1, ball = GREEN, gen = 9, guids = { "d8928e" } } }  }, 
  { name = "Maushold",      level = 3, types = { "Normal" }, moves = { "Pop. Bomb", "Beat Up" },     guids = { "eb502b", "d8928e" }  },

  -- Gen 9 926-949
  { name = "Fidough",       level = 1, types = { "Fairy" }, moves = { "Baby-Doll Eyes", "Covet" }, guids = { "4e8b42" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "acaf9b" } } } },
  { name = "Dachsbun",      level = 3, types = { "Fairy" }, moves = { "Play Rough", "Crunch" },   guids = { "90d0bb", "acaf9b" }  }, 
  { name = "Smoliv",        level = 2, types = { "Grass" }, moves = { "Growth", "Absorb" },   guids = { "478ad3" }, evoData = { { cost = 1, ball = GREEN, gen = 9, guids = { "70af04" } } } }, 
  { name = "Dolliv",        level = 3, types = { "Grass" }, moves = { "Seed Bomb", "Tackle" },   guids = { "c00c7c", "70af04" }, evoData = { { cost = 2, ball = YELLOW, gen = 9, guids = { "46e56c", "8bf8dd" } } }  },
  { name = "Arboliva",      level = 5, types = { "Grass" }, moves = { "Grassy Terrain", "Terrain Pulse" }, guids = { "31acf0", "46e56c", "8bf8dd" } },
  { name = "Squawkabilly",  level = 3, types = { "Flying" }, moves = { "Mimic", "Fly" },  guids = { "1968bc" } },
  { name = "Nacli",         level = 2, types = { "Rock" }, moves = { "Rock Throw", "Harden" }, guids = { "3b9f04" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "0d54a8" } } } },
  { name = "Naclstack",     level = 4, types = { "Rock" }, moves = { "Salt Cure", "Mud Shot" },  guids = { "69cf19", "0d54a8" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "1c0e4e", "7c6d2b" } } }},
  { name = "Garganacl",     level = 6, types = { "Rock" }, moves = { "Hammer Arm", "Stone Edge" }, guids = { "9aaabb", "1c0e4e", "7c6d2b" } },
  { name = "Charcadet",     level = 3, types = { "Fire" }, moves = { "Flame Charge", "Astonish" }, guids = { "0f63f8" },  evoData = { { cost = 1, ball = YELLOW, gen = 9, guids = { "7a4b5f" } }, { cost = 1, ball = YELLOW, gen = 9, guids = { "3fc935" } } } },
  { name = "Armarouge",     level = 4, types = { "Fire" }, moves = { "Lava Plume", "Psyshock" },  guids = { "72da86", "7a4b5f" } }, 
  { name = "Ceruledge",     level = 4, types = { "Fire" }, moves = { "Shadow Claw", "Fire Spin" }, guids = { "9d5def", "3fc935" } }, 
  { name = "Tadbulb",       level = 2, types = { "Electric" }, moves = { "Thunder Shock", "Mud-Slap" },     guids = { "fc24d2" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "7dbae8" } } } }, 
  { name = "Bellibolt",     level = 3, types = { "Electric" }, moves = { "Sucker Punch", "Discharge" },  guids = { "d11554", "7dbae8" } }, 
  { name = "Wattrel",       level = 2, types = { "Electric" }, moves = { "Growl", "Peck" },    guids = { "388592" },  evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "a10303" } } }},
  { name = "Kilowattrel",   level = 4, types = { "Electric" }, moves = { "Dual Wingbeat", "Spark" },    guids = { "81d760", "a10303" },  },
  { name = "Maschiff",      level = 2, types = { "Dark" }, moves = { "Bite", "Roar" }, guids = { "8cb576" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "41dfa5" } } } },
  { name = "Mabosstiff",    level = 4, types = { "Dark" }, moves = { "Double-Edge", "Jaw Lock" },   guids = { "3e9b8c", "41dfa5" } }, 
  { name = "Shroodle",      level = 2, types = { "Poison" }, moves = { "Fury Swipes", "Acid Spray" }, guids = { "bd638c" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "74dde9" } } }  },
  { name = "Grafaiai",      level = 3, types = { "Poison" }, moves = { "Poison Jab", "Slash" }, guids = { "32bf28", "74dde9" } },
  { name = "Bramblin",      level = 3, types = { "Grass" }, moves = { "Bullet Seed", "Rollout" }, guids = { "845718" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "6160d0" } } } }, 
  { name = "Brambleghast",  level = 4, types = { "Grass" }, moves = { "Phantom Force", "Mega Drain" },  guids = { "651132", "6160d0" } }, 
  { name = "Toedscool",     level = 2, types = { "Ground" }, moves = { "Absorb", "Wrap" },    guids = { "81b348" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "fdc646" } } }    },
  { name = "Toedscruel",    level = 4, types = { "Ground" }, moves = { "Power Whip", "Mud Shot" },  guids = { "73fe95", "fdc646" } },

  -- Gen 9 950-975
  { name = "Klawf",         level = 4, types = { "Rock" }, moves = { "Rock Slide", "X-Scissor" }, guids = { "3478a3" } },
  { name = "Capsakid",      level = 3, types = { "Grass" }, moves = { "Headbutt", "Leafage" },       guids = { "136e8c" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "feb4ee" } } } }, 
  { name = "Scovillain",    level = 4, types = { "Grass" }, moves = { "Flamethrower", "Spicy Extract" }, guids = { "89e811", "feb4ee" } },
  { name = "Rellor",        level = 3, types = { "Bug" }, moves = { "Struggle Bug", "Rollout" },   guids = { "e30571" }, evoData = { { cost = 1, ball = BLUE, gen = 9, guids = { "ba0ca7" } } }  },
  { name = "Rabsca",        level = 4, types = { "Bug" }, moves = { "Bug Buzz", "Psychic" },      guids = { "2de0bb", "ba0ca7" } },
  { name = "Flittle",       level = 3, types = { "Psychic" }, moves = { "Confusion", "Peck" },       guids = { "ee1263" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "ba6a6d" } } } },
  { name = "Espathra",      level = 5, types = { "Psychic" }, moves = { "Feather Dance", "Lumina Crash" }, guids = { "857c58", "ba6a6d" } }, 
  { name = "Tinkatink",     level = 2, types = { "Fairy" }, moves = { "Astonish", "Fairy Wind" }, guids = { "c3d19f" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "e71fa5" } } } }, 
  { name = "Tinkatuff",     level = 4, types = { "Fairy" }, moves = { "Flash Cannon", "Brutal Swing" }, guids = { "e7f434", "e71fa5" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "746894", "b76ffe" } } } },
  { name = "Tinkaton",      level = 6, types = { "Fairy" }, moves = { "Gigaton Hammer", "Play Rough" }, guids = { "1dd00a", "746894", "b76ffe" } }, 
  { name = "Wiglett",       level = 2, types = { "Water" }, moves = { "Mud-Slap", "Aqua Jet" }, guids = { "525157" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "f7f56d" } } } },
  { name = "Wugtrio",       level = 4, types = { "Water" }, moves = { "Sucker Punch", "Triple Dive" }, guids = { "a82b90", "f7f56d" } },
  { name = "Bombirdier",    level = 4, types = { "Flying" }, moves = { "Dual Wingbeat", "Knock Off" }, guids = { "ed2e7c" } },
  { name = "Finizen",       level = 5, types = { "Water" }, moves = { "Double Hit", "Aqua Jet" }, guids = { "0873a6" }, evoData = { { cost = 1, ball = RED, gen = 9, guids = { "ffb871" } }, { cost = 1, ball = RED, gen = 9, guids = { "e40792" } } } },
  { name = "Palafin",       level = 6, types = { "Water" }, moves = { "Close Combat", "Jet Punch" }, guids = { "b40995", "e40792" } },
  { name = "Palafin",       level = 6, types = { "Water" }, moves = { "Zen Headbutt", "Flip Turn" }, guids = { "fd6f39", "ffb871" } },
  { name = "Varoom",        level = 3, types = { "Steel" }, moves = { "Screech", "Smog" }, guids = { "039292" }, evoData = { { cost = 2, ball = RED, gen = 9, guids = { "f620af" } } } }, 
  { name = "Revavroom",     level = 5, types = { "Steel" }, moves = { "Spin Out", "Sludge" }, guids = { "fd6f39", "f620af" } }, 
  { name = "Cyclizar",      level = 4, types = { "Dragon" }, moves = { "Dragon Rush", "Quick Attack" }, guids = { "7282b5"  } },
  { name = "Orthworm",      level = 3, types = { "Steel" }, moves = { "Earthquake", "Iron Tail" }, guids = { "9b54aa" } }, 
  { name = "Glimmet",       level = 2, types = { "Rock" }, moves = { "Toxic Spikes", "Rock Throw" }, guids = { "731ab7" }, evoData = { { cost = 2, ball = YELLOW, gen = 9, guids = { "58f282" } } } },
  { name = "Glimmora",      level = 4, types = { "Rock" }, moves = { "Ancient Power", "Mortal Spin" }, guids = { "137bbd", "58f282" } },
  { name = "Greavard",      level = 2, types = { "Ghost" }, moves = { "Growl", "Lick" }, guids = { "f0f80b" }, evoData = { { cost = 2, ball = BLUE, gen = 9, guids = { "54b1df" } } } },
  { name = "Houndstone",    level = 4, types = { "Ghost" }, moves = { "Last Respects", "Dig" }, guids = { "b7d0d5", "54b1df" } },                   
  { name = "Flamigo",       level = 3, types = { "Flying" }, moves = { "Double Kick", "Air Slash" }, guids = { "29bdc6" } }, 
  { name = "Cetoddle",      level = 3, types = { "Ice" }, moves = { "Echoed Voice", "Ice Shard" }, guids = { "cc2b2f" }, evoData = { { cost = 1, ball = YELLOW, gen = 9, guids = { "3a0f0c" } } } }, 
  { name = "Cetitan",       level = 4, types = { "Ice" }, moves = { "Double-Edge", "Ice Spinner" }, guids = { "22914e", "3a0f0c" } },
  
  --Gen 9 976-1000
  { name = "Veluza",        level = 3, types = { "Water" }, moves = { "Psychic Fangs", "Fillet Away" }, guids = { "f19255" } }, 
  { name = "Dondozo",       level = 4, types = { "Water" }, moves = { "Wave Crash", "Order Up" }, guids = { "1703be" }  }, 
  { name = "Tatsugiri",     level = 3, types = { "Dragon" }, moves = { "Water Pulse", "Dragon Pulse" }, guids = { "799368" } },    -- Water
  { name = "Tatsugiri",     level = 3, types = { "Dragon" }, moves = { "Mirror Coat", "Dragon Pulse" }, guids = { "6e1311" } },    -- Psychic
  { name = "Tatsugiri",     level = 3, types = { "Dragon" }, moves = { "Nasty Plot", "Dragon Pulse" }, guids = { "a3ec4b" } },     -- Dark
  { name = "Annihilape",    level = 5, types = { "Fighting" }, moves = { "Cross Chop", "Rage Fist" }, guids = { "87727d", "b68eb7", "6b4dfa" } },
  { name = "Clodsire",      level = 3, types = { "Poison" }, moves = { "Poison Tail", "Mud Shot" }, guids = { "11f231", "9299e4" }},
  { name = "Farigiraf",     level = 3, types = { "Normal" }, moves = { "Twin Beam", "Stomp" }, guids = { "ec3c21", "f18198" } }, 
  { name = "Dudunsparce",   level = 3, types = { "Normal" }, moves = { "Drill Run", "Hyper Drill" }, guids = { "f840fc", "9c40ab" }  },
  { name = "Kingambit",     level = 6, types = { "Dark" }, moves = { "Kowtow Cleave", "Iron Head" }, guids = { "97afd6", "d49464", "8625f7" } },
  { name = "Great Tusk",    level = 5, types = { "Ground" }, moves = { "Brick Break", "Bulldoze" }, guids = { "00e061" } },
  { name = "Scream Tail",   level = 3, types = { "Fairy" }, moves = { "Play Rough", "Psychic Fangs" }, guids = { "d2d1fc" } }, 
  { name = "Brute Bonnet",  level = 4, types = { "Grass" }, moves = { "Sucker Punch", "Mega Drain" }, guids = { "d97f22" } }, 
  { name = "Flutter Mane",  level = 4, types = { "Ghost" }, moves = { "Phantom Force", "Moonblast" }, guids = { "60305f" } },
  { name = "Slither Wing",  level = 6, types = { "Bug" }, moves = { "Superpower", "Bug Bite" }, guids = { "163a86" } }, 
  { name = "Sandy Shocks",  level = 4, types = { "Electric" }, moves = { "Earth Power", "Discharge" }, guids = { "c61a67" } }, 
  { name = "Iron Treads",   level = 5, types = { "Ground" }, moves = { "Iron Head", "Earthquake" }, guids = { "2bba66" } }, 
  { name = "Iron Bundle",   level = 3, types = { "Ice" }, moves = { "Freeze-Dry", "Flip Turn" }, guids = { "90d798" } },
  { name = "Iron Hands",    level = 4, types = { "Fighting" }, moves = { "Thunder Punch", "Arm Thrust" }, guids = { "7b45a3" } }, 
  { name = "Iron Jugulis",  level = 7, types = { "Dark" }, moves = { "Dark Pulse", "Air Slash" }, guids = { "ff30bd" } },
  { name = "Iron Moth",     level = 6, types = { "Fire" }, moves = { "Sludge Wave", "Overheat" }, guids = { "68bff5" } }, 
  { name = "Iron Thorns",   level = 7, types = { "Rock" }, moves = { "Thunder Fang", "Stone Edge" }, guids = { "38c0c7" }  }, 
  { name = "Frigibax",      level = 2, types = { "Dragon" }, moves = { "Icy Wind", "Leer" }, guids = { "3f40d1" }, evoData = { { cost = 2, ball = YELLOW, gen = 9, guids = { "907d41" } } } }, 
  { name = "Arctibax",      level = 4, types = { "Dragon" }, moves = { "Dragon Claw", "Bite" }, guids = { "33a8b3", "907d41" }, evoData = { { cost = 3, ball = RED, gen = 9, guids = { "1dad71", "805f61" } } } }, 
  { name = "Baxcalibur",    level = 7, types = { "Dragon" }, moves = { "Icicle Crash", "Glaive Rush" }, guids = { "1d7ffe", "1dad71", "805f61" } },
  { name = "Gimmighoul",    level = 3, types = { "Ghost" }, moves = { "Astonish", "Tackle" }, guids = { "c63945" }, evoData = { { cost = 3, ball = RED, gen = 9, guids = { "fa534f" } } } },
  { name = "Gholdengo",     level = 6, types = { "Steel" }, moves = { "Shadow Ball", "Make It Rain" }, guids = { "38ac21", "fa534f" } },

  --Gen 9 1001-1025
  { name = "Wo-Chien",      level = 7, types = { "Grass" }, moves = { "Leaf Storm", "Ruination" }, guids = { "f9f24e" }  },
  { name = "Chien-Pao",     level = 7, types = { "Ice" }, moves = { "Icicle Crash", "Ruination" }, guids = { "a4d468" } }, 
  { name = "Ting-Lu",       level = 7, types = { "Ground" }, moves = { "Earth Power", "Ruination" }, guids = { "c37f93" } },
  { name = "Chi-Yu",        level = 7, types = { "Fire" }, moves = { "Lava Plume", "Ruination" }, guids = { "b9c9fd" }  },
  { name = "Roaring Moon",  level = 7, types = { "Dragon" }, moves = { "Night Slash", "Dragon Claw" }, guids = { "eac784" } },
  { name = "Iron Valiant",  level = 5, types = { "Fairy" }, moves = { "Close Combat", "Spirit Break" }, guids = { "d1f07b" } },
  { name = "Koraidon",      level = 7, types = { "Ground" }, moves = { "Collision Course", "Outrage" }, guids = { "a7a93a" } }, 
  { name = "Miraidon",      level = 7, types = { "Electric" }, moves = { "Electro Drift", "Outrage" }, guids = { "c00d7b" } },
  { name = "Walking Wake",  level = 7, types = { "Water" }, moves = { "Dragon Breath", "Hydro Pump" }, guids = { "f1495e" } },
  { name = "Iron Leaves",   level = 7, types = { "Grass" }, moves = { "Solar Blade", "Psyblade" }, guids = { "6519a8" } },
  { name = "Dipplin",       level = 4, types = { "Grass" }, moves = { "Infestation", "Dragon Tail" }, guids = { "2990ba", "951a30" }, evoData = { { cost = 1, ball = RED, gen = 9, guids = { "7b9062", "e5ee39" } } } }, 
  { name = "Hydrapple",     level = 5, types = { "Grass" }, moves = { "Fickle Beam", "Syrup Bomb" }, guids = { "dcee5f", "7b9062", "e5ee39" } },
  { name = "Poltchageist",  level = 3, types = { "Grass" }, moves = { "Astonish", "Absorb" }, guids = { "147af7" }, evoData = { { cost = 1, ball = BLUE , gen = 9, guids = { "fae06f" } } } }, 
  { name = "Sinistcha",     level = 4, types = { "Grass" }, moves = { "Matcha Gotcha", "Hex" }, guids = { "9df0d7", "fae06f" } },
  { name = "Okidogi",       level = 7, types = { "Fighting" }, moves = { "Force Palm", "Poison Jab" }, guids = { "e4b697" } }, 
  { name = "Munkidori",     level = 7, types = { "Psychic" }, moves = { "Sludge Wave", "Future Sight" }, guids = { "db6cf9" } },
  { name = "Fezandipiti",   level = 7, types = { "Fairy" }, moves = { "Cross Poison", "Moonblast" }, guids = { "855095" } },
  { name = "Ogerpon",       level = 7, types = { "Grass" }, moves = { "Ivy Cudgel Grass", "Counter" }, guids = { "a92e73" } },   -- Grass
  { name = "Ogerpon",       level = 7, types = { "Rock" }, moves = { "Ivy Cudgel Rock", "Counter" }, guids = { "210bcc" } },     -- Rock
  { name = "Ogerpon",       level = 7, types = { "Fire" }, moves = { "Ivy Cudgel Fire", "Counter" }, guids = { "480b42" } },     -- Fire
  { name = "Ogerpon",       level = 7, types = { "Water" }, moves = { "Ivy Cudgel Water", "Counter" }, guids = { "ce1aac" } },   -- Water
  { name = "Archaludon",    level = 6, types = { "Steel" }, moves = { "Electro Shot", "Breaking Swipe" }, guids = { "3d2744", "3a6873" } },
  { name = "Gouging Fire",  level = 7, types = { "Fire" }, moves = { "Raging Fury", "Dragon Claw" }, guids = { "ae5249" } },
  { name = "Raging Bolt",   level = 7, types = { "Electric" }, moves = { "Dragon Hammer", "Thunderclap" }, guids = { "d32bf4" } }, 
  { name = "Iron Boulder",  level = 7, types = { "Rock" }, moves = { "Mighty Cleave", "Psycho Cut" }, guids = { "fa15fd" } }, 
  { name = "Iron Crown",    level = 7, types = { "Steel" }, moves = { "Tachyon Cutter", "Future Sight" }, guids = { "fae0a8" } },
  { name = "Terapagos",     level = 7, types = { "Normal" }, moves = { "Tera Starstorm", "Protect" }, guids = { "686877" } }, 
  { name = "Pecharunt",     level = 7, types = { "Poison" }, moves = { "Malignant Chain", "Shadow Ball" }, guids = { "114b25" } }, 
  { name = "Tauros",        level = 4, types = { "Fighting" }, moves = { "Double-Edge", "Raging Bull Fighting" }, guids = { "16d4a9" } },   -- Fighting
  { name = "Tauros",        level = 4, types = { "Water" }, moves = { "Double Kick", "Raging Bull Water" }, guids = { "e464b6" }  },        -- Water
  { name = "Tauros",        level = 4, types = { "Fire" }, moves = { "Double Kick", "Raging Bull Fire" }, guids = { "723f82" } },           -- Fire
  { name = "Wooper",        level = 1, types = { "Poison" }, moves = { "Toxic Spikes", "Slam" }, guids = { "d95619" }, evoData = { { cost = 2, ball = BLUE , gen = 9, guids = { "9299e4" } } } }
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
    {name="Silk Trap",      power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="Protect"}} },
    {name="Silver Wind",    power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Steamroller",    power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="String Shot",    power=0,      type="Bug",       dice=6, STAB=false  },
    {name="Struggle Bug",   power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Tail Glow",      power=0,      type="Bug",       dice=4, STAB=true,  effects={{name="AttackUp2", target="Self"}} },
    {name="Twineedle",      power=1,      type="Bug",       dice=4, STAB=true,  effects={{name="Poison", target="Enemy", chance=5},{name="ExtraDice", target="Self"}} },
    {name="U-Turn",         power=2,      type="Bug",       dice=6, STAB=true,  effects={{name="Switch", target="Self"}} },
    {name="X-Scissor",      power=2,      type="Bug",       dice=6, STAB=true   },
    {name="Befuddle",       power=3,      type="Bug",       dice=6, STAB=true,  effects={{"Custom"}} },
    {name="Flutterby",      power=2,      type="Bug",       dice=6, STAB=true,  effects={{"Custom"}} },
    

    -- Dark
    {name="Assurance",      power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Aura Wheel Dark",power=4,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Beat Up",        power="Enemy",type="Dark",      dice=6, STAB=false },
    {name="Bite",           power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Brutal Swing",   power=2,      type="Dark",      dice=6, STAB=false },
    {name="Ceaseless Edge", power=3,      type="Dark",      dice=8, STAB=false },
    {name="Crunch",         power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Darkest Lariat", power=3,      type="Dark",      dice=6, STAB=true  },
    {name="Dark Pulse",     power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Embargo",        power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Fake Tears",     power=0,      type="Dark",      dice=6, STAB=false, effects={{name="AttackUp2", target="Self"}} },
    {name="Feint Attack",   power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Fiery Wrath",    power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
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
    {name="Snarl",          power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Sucker Punch",   power=2,      type="Dark",      dice=6, STAB=true,  effects={{name="Priority", target="Self"}}},
    {name="Ruination",      power="Enemy",type="Dark",      dice=6, STAB=true },
    {name="Taunt",          power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Thief",          power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Torment",        power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Wicked Blow",    power=3,      type="Dark",      dice=8, STAB=true   },
    {name="Wicked Torque",  power=3,      type="Dark",      dice=8, STAB=true,  effects={{name="Sleep", target="Enemy", chance=6}} },
    {name="Throat Chop",    power=3,      type="Dark",      dice=6, STAB=true },
    {name="Darkness",       power=3,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"} } },
    {name="Snooze",         power=3,      type="Dark",      dice=8, STAB=false, effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="One Blow",       power=4,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"} } },
    {name="Night Daze",     power=3,      type="Dark",      dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}}},
    {name="Snatch",         power=0,      type="Dark",      dice=6, STAB=false, effects={{name="Custom"} } },

    -- Dragon
    {name="D-max Cannon",   power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Dragon Claw",    power=3,      type="Dragon",    dice=6, STAB=true   },
    {name="Dragon Dance",   power=0,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackUp2", target="Self"}} },
    {name="Dragon Darts",   power=2,      type="Dragon",    dice=4, STAB=true,  effects={{name="ExtraDice", target="Self"}} },
    {name="Dragon Breath",  power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Dragon Energy",  power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Dragon Hammer",  power=3,      type="Dragon",    dice=6, STAB=true   },
    {name="Dragon Pulse",   power=2,      type="Dragon",    dice=6, STAB=true   },
    {name="Dragon Rage",    power=4,      type="Dragon",    dice=4, STAB=true,  effects={{name="Neutral", target="Self"}} },
    {name="Dragon Rush",    power=2,      type="Dragon",    dice=4, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Dragon Tail",    power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="Switch", target="Enemy"}} },
    {name="Dual Chop",      power=1,      type="Dragon",    dice=4, STAB=true,  effects={{name="ExtraDice", target="Self"}} },
    {name="Clanging Scales",power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Fickle Beam",    power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Glaive Rush",    power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Order Up",       power=2,      type="Dragon",    dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Outrage",        power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="Confuse", target="Self", chance=5}} },
    {name="Roar of Time",   power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="Recharge", target="Self"}} },
    {name="Spacial Rend",   power=3,      type="Dragon",    dice=8, STAB=true   },
    {name="Twister",        power=1,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Breaking Swipe", power=3,      type="Dragon",    dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy"}} },
    {name="Dragon Ascent",  power=4,      type="Dragon",    dice=6, STAB=false, effects={{name="AttackDown", target="Self"}} },
    {name="Wyrmwind",       power=4,      type="Dragon",    dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Eternabeam",     power=5,      type="Dragon",    dice=6, STAB=false, effects={{name="Recharge", target="Self"}} },

    -- Electric
    {name="Aura Wheel Electric",power=4,  type="Electric",  dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Bolt Strike",    power=5,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Charge",         power=0,      type="Electric",  dice=6, STAB=false, effects={{name="AttackUp", target="Self", chance=3}} },
    {name="Charge Beam",    power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"} } },
    {name="Discharge",      power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Electroweb",     power=2,      type="Electric",  dice=6, STAB=true},
    {name="Electro Ball",   power="Self", type="Electric",  dice=6, STAB=false},
    {name="Electro Drift",  power=3,      type="Electric",  dice=6, STAB=false},
    {name="Electro Shot",   power=3,      type="Electric",  dice=6, STAB=false, effects={{name="AttackUp", target="Self"},{name="Recharge", target="Self"}}},
    {name="Fusion Bolt",    power=2,      type="Electric",  dice=6, STAB=false, effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Nuzzle",         power=1,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy"}}},
    {name="Overdrive",      power=3,      type="Electric",  dice=6, STAB=true},
    {name="Plasma Fists",   power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Rev. Dance Electric",power=3,  type="Electric",  dice=6, STAB=true},
    {name="Shock Wave",     power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Spark",          power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Thunderbolt",    power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Thunderclap",    power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Priority", target="Self"} }},
    {name="Thunder",        power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Thunder Cage",   power=3,      type="Electric",  dice=4, STAB=false, effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Thunder Fang",   power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Thunder Shock",  power=1,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Thunder Punch",  power=2,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=6}} },
    {name="Thunder Wave",   power=0,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy"}} },
    {name="Volt Swtich",    power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Switch", target="Self"}} },
    {name="Wild Charge",    power=3,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Wildbolt Storm", power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Zap Cannon",     power=3,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy", chance=4}} },
    {name="Zing Zap",       power=3,      type="Electric",  dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Volt Tackle",    power=4,      type="Electric",  dice=6, STAB=false, effects={{name="KO", target="Self", chance=5}} },
    {name="Volt Crash",     power=3,      type="Electric",  dice=6, STAB=false, effects={{name="Paralyse", target="Enemy"}} },
    {name="Stun Shock",     power=4,      type="Electric",  dice=6, STAB=true,  effects={{name="Custom"}}},
    
    -- Fairy
    {name="Baby-Doll Eyes", power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown", target="Enemy"}} },
    {name="Dazzling Gleam", power=2,      type="Fairy",     dice=6, STAB=true },
    {name="Decorate",       power=0,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackUp2", target="Self"}} },
    {name="Disarming Voice",power=1,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Charm",          power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown2", target="Enemy"}} },
    {name="Fairy Wind",     power=2,      type="Fairy",     dice=6, STAB=true},
    {name="Fleur Cannon",   power=4,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}}},
    {name="Misty Terrain",  power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Nature's Madness",power="Enemy",type="Fairy",    dice=6, STAB=false },
    {name="Magical Torque", power=3,      type="Fairy",     dice=6, STAB=false, effects={{name="Confuse", target="Enemy", chance=5}} },
    {name="Moonblast",      power=3,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Moonlight",      power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Protect", target="Self"},{name="Custom"}} },
    {name="Play Rough",     power=3,      type="Fairy",     dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Spirit Break",   power=3,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown", target="Enemy"}} },
    {name="Spring. Storm",  power=3,      type="Fairy",     dice=6, STAB=false, effects={{name="AttackDown", target="Enemy", chance=6},{name="AttackUp", target="Self", chance=6}} },
    {name="Strange Steam",  power=3,      type="Fairy",     dice=6, STAB=false, effects={{name="Confuse", target="Enemy", chanc=6}} },
    {name="Sweet Kiss",     power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Confuse", target="Enemy", chance=2}} },
    {name="Draining Kiss",  power=2,      type="Fairy",     dice=6, STAB=false},
    {name="Heal Pulse",     power=0,      type="Fairy",     dice=6, STAB=false, effects={{name="Custom"}, {name="Recharge", target="Self"}} },
    {name="Smite",          power=3,      type="Fairy",     dice=6, STAB=false, effects={{name="Confuse", target="Enemy"}} },
    {name="Starfall",       power=4,      type="Fairy",     dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Finale",         power=4,      type="Fairy",     dice=6, STAB=false},
    
    -- Fighting
    {name="Aura Sphere",    power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Arm Thrust",     power=1,      type="Fighting",  dice=4, STAB=true,  effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Bulk Up",        power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="AttackDown", target="Enemy"},{name="AttackUp", target="Self"}} },
    {name="Brick Break",    power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Body Press",     power=2,      type="Fighting",  dice=6, STAB=true },
    {name="Circle Throw",   power=3,      type="Fighting",  dice=6, STAB=false, effects={{name="Switch", target="Enemy"}} },
    {name="Counter",        power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Close Combat",   power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackDown", target="Self"}} },
    {name="Collision Course",power=3,     type="Fighting",  dice=8, STAB=true},
    {name="Combat Torque",  power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Cross Chop",     power=2,      type="Fighting",  dice=8, STAB=true},
    {name="Detect",         power=0,      type="Fighting",  dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Double Kick",    power=1,      type="Fighting",  dice=4, STAB=true,  effects={{name="ExtraDice", target="Self"}} },
    {name="Drain Punch",    power=3,      type="Fighting",  dice=4, STAB=true},
    {name="Dynamic Punch",  power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="Confuse", target="Enemy", chance=4}} },
    {name="Flying Press",   power=3,      type="Flying",    dice=6, STAB=true,  effects={{name="Custom"}}},
    {name="Focus Blast",    power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Focus Punch",    power=3,      type="Fighting",  dice=6, STAB=true},
    {name="Force Palm",     power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Hammer Arm",     power=3,      type="Fighting",  dice=6, STAB=true},
    {name="High Jump Kick", power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=6}} },
    {name="Jump Kick",      power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=6}} },
    {name="Karate Chop",    power=1,      type="Fighting",  dice=8, STAB=true},
    {name="Low Kick",       power=1,      type="Fighting",  dice=4, STAB=true},
    {name="Mach Punch",     power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Priority", target="Self"}} },
    {name="No Retreat",     power=0,      type="Fighting",  dice=6, STAB=true,  effects={{name="Priority", target="Self"}, {name="AttackUp2", target="Self"}} },
    {name="Octolock",       power=0,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"},{name="AttackUp2", target="Self"}} },
    {name="Power-Up Punch", power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self"}} },
    {name="Raging Bull Fighting",power=3, type="Fighting",  dice=6, STAB=false},
    {name="Revenge",        power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Rock Smash",     power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Sacred Sword",   power=3,      type="Fighting",  dice=6, STAB=false, effects={{name="Custom"}} },
    {name="Secret Sword",   power=3,      type="Fighting",  dice=6, STAB=false},
    {name="Seismic Toss",   power="Self", type="Fighting",  dice=6, STAB=false},
    {name="Sky Uppercut",   power=3,      type="Fighting",  dice=6, STAB=true},
    {name="Storm Throw",    power=3,      type="Fighting",  dice=8, STAB=true},
    {name="Submission",     power=2,      type="Fighting",  dice=6, STAB=true,  effects={{name="KO", target="Self", chance=6}} },
    {name="Superpower",     power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Triple Arrows",  power=2,      type="Fighting",  dice=8, STAB=false, effects={{name="AttackUp", target="Self"}} },
    {name="Triple Kick",    power=1,      type="Fighting",  dice=4, STAB=false, effects={{name="ExtraDice", target="Self", chance=2},{name="ExtraDice", target="Self", chance=2}} },
    {name="Vital Throw",    power=2,      type="Fighting",  dice=6, STAB=true},
    {name="Wake-up Slap",   power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Rolling Kick",   power=3,      type="Fighting",  dice=6, STAB=true,  effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Wind Rage",      power=4,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    {name="Knuckle",        power=4,      type="Fighting",  dice=6, STAB=true,  effects={{name="Custom"}} },
    

    -- Fire
    {name="Blaze Kick",     power=3,      type="Fire",    dice=8, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Blazing Torque", power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Blue Flare",     power=4,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Ember",          power=1,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Eruption",       power=4,      type="Fire",    dice=6, STAB=true},
    {name="Fiery Dance",    power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=4}} },
    {name="Fire Fang",      power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Fire Blast",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Fire Lash",      power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Fire Punch",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Fire Spin",      power=1,      type="Fire",    dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Flame Wheel",    power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Flame Burst",    power=3,      type="Fire",    dice=6, STAB=true},
    {name="Flame Charge",   power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Priority", target="Self"}}},
    {name="Flamethrower",   power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Flare Blitz",    power=4,      type="Fire",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6},{name="Burn", target="Enemy", chance=6}} },
    {name="Fusion Flare",   power=2,      type="Fire",    dice=6, STAB=false,   effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Heat Crash",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom", chance=4}} },
    {name="Incinerate",     power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Inferno",        power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=4}} },
    {name="Ivy Cudgel Fire",power=4,      type="Fire",    dice=8, STAB=true},
    {name="Lava Plume",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Magma Storm",    power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Mind Blown",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Mystical Fire",  power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackDown"}} },
    {name="Overheat",       power=4,      type="Fire",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Pyro Ball",      power=4,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=6}} },
    {name="Raging Bull Fire",power=3,     type="Fire",    dice=6, STAB=false},
    {name="Raging Fury",    power=4,      type="Fire",    dice=6, STAB=true,    effects={{name="Confuse", target="Self", chance=5}} },
    {name="Rev. Dance Fire",power=3,      type="Fire",    dice=6, STAB=true},
    {name="Sacred Fire",    power=2,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=4}} },
    {name="Searing Shot",   power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Torch Song",     power=3,      type="Fire",    dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Weather Ball Fire",power=3,    type="Fire",    dice=6, STAB=true},
    {name="Will-O-Wisp",    power=0,      type="Fire",    dice=6, STAB=false,   effects={{name="Burn", target="Enemy", chance=2}} },
    {name="Wildfire",       power=3,      type="Fire",    dice=6, STAB=false,   effects={{name="ExtraDice", target="self"}} },
    {name="Fireball",       power=5,      type="Fire",    dice=6, STAB=false},
    {name="Flare",          power=4,      type="Fire",    dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Centiferno",     power=3,      type="Fire",    dice=4, STAB=false,   effects={{name="ExtraDice", target="Self", chance=4}} },

    -- Flying
    {name="Aerial Ace",     power=3,      type="Flying",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Air Cutter",     power=2,      type="Flying",  dice=8, STAB=true},
    {name="Air Slash",      power=3,      type="Flying",  dice=8, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Aeroblast",      power=3,      type="Flying",  dice=8, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Beak Blast",     power=4,      type="Flying",  dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=4}} },
    {name="Bleakwind Storm",power=4,      type="Flying",  dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=5}} },
    {name="Bounce",         power=2,      type="Flying",  dice=6, STAB=true,    effects={{name="Paralyse", target="Enemy", chance=5}}},
    {name="Brave Bird",     power=4,      type="Flying",  dice=6, STAB=true,    effects={{name="KO", target="Self"}} },
    {name="Chatter",        power=2,      type="Flying",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Drill Peck",     power=3,      type="Flying",  dice=6, STAB=true},
    {name="Dual Wingbeat",  power=3,      type="Flying",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self"}} },
    {name="Gust",           power=1,      type="Flying",  dice=6, STAB=true},
    {name="Fly",            power=3,      type="Flying",  dice=6, STAB=true},
    {name="Feather Dance",  power=0,      type="Flying",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Hurricane",      power=4,      type="Flying",  dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=5}} },
    {name="Mirror Move",    power=0,      type="Flying",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Oblivion Wing",  power=3,      type="Flying",  dice=6, STAB=false},
    {name="Peck",           power=1,      type="Flying",  dice=6, STAB=true},
    {name="Sky Attack",     power=1,      type="Flying",  dice=8, STAB=true,    effects={{name="Recharge", target="Self"},{name="AttackDown", target="Enemy", chance=5}} },
    {name="Sunny Day",      power=0,      type="Flying",  dice=8, STAB=true,    effects={{name="Custom"}} },
    {name="Wing Attack",    power=2,      type="Flying",  dice=6, STAB=true},
    {name="Airstream",      power=4,      type="Flying",  dice=6, STAB=false,   effects={{name="Custom"}} },

    -- Ghost
    {name="Astral Barrage", power=4,      type="Ghost",   dice=6, STAB=false},
    {name="Astonish",       power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Bitter Malice",  power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=5}} },
    {name="Confuse Ray",    power=0,      type="Ghost",   dice=6, STAB=false,   effects={{name="Confuse", target="Enemy"}} },
    {name="Curse",          power=0,      type="Ghost",   dice=6, STAB=false,   effects={{name="KO", target="Self", chance=4},{name="Curse", target="Enemy"}} },
    {name="Hex",            power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Last Respects",  power=0,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Lick",           power=1,      type="Ghost",   dice=6, STAB=true,    effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Moongeist Beam", power=3,      type="Ghost",   dice=6, STAB=false},
    {name="Night Shade",    power="Self", type="Ghost",   dice=6, STAB=false},
    {name="Ominous Wind",   power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Phantom Force",  power=3,      type="Ghost",   dice=6, STAB=true},
    {name="Rage Fist",      power=2,      type="Ghost",   dice=6, STAB=true,  effects={{name="AttackUp", target="Self", condition="Power"}} },
    {name="Rev. Dance Ghost",power=3,     type="Ghost",   dice=6, STAB=true},
    {name="Shadow Ball",    power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}}},
    {name="Shadow Bone",    power=2,      type="Ghost",   dice=6, STAB=true},
    {name="Shadow Claw",    power=2,      type="Ghost",   dice=8, STAB=true},
    {name="Shadow Force",   power=4,      type="Ghost",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Shadow Punch",   power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Shadow Sneak",   power=2,      type="Ghost",   dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Spectral Thief", power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Spirit Shackle", power=3,      type="Ghost",   dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Terror",         power=4,      type="Ghost",   dice=6, STAB=false,   effects={{name="Custom"}}},

    -- Grass
    {name="Absorb",         power=1,      type="Grass",   dice=6, STAB=true},
    {name="Apple Acid",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Aromatherapy",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Branch Poke",    power=2,      type="Grass",   dice=6, STAB=true},
    {name="Bullet Seed",    power=1,      type="Grass",   dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Chloroblast",    power=4,      type="Grass",   dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Cotton Guard",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Cotton Spore",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Drum Beating",   power=3,      type="Grass",   dice=6, STAB=true},
    {name="Energy Ball",    power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Flower Trick",   power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Giga Drain",     power=3,      type="Grass",   dice=6, STAB=true},
    {name="Grass Knot",     power=2,      type="Grass",   dice=6, STAB=true},
    {name="Grass Whistle",  power=2,      type="Grass",   dice=6, STAB=true},
    {name="Grassy Terrain", power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="Custom"}}},
    {name="Grav Apple",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Horn Leech",     power=4,      type="Grass",   dice=6, STAB=true},
    {name="Ivy Cudgel Grass",power=4,     type="Grass",   dice=8, STAB=true},
    {name="Jungle Healing", power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Custom"},{name="Protect", target="Self"}}},
    {name="Leafage",        power=2,      type="Grass",   dice=8, STAB=true},
    {name="Leaf Blade",     power=3,      type="Grass",   dice=8, STAB=true},
    {name="Leaf Storm",     power=4,      type="Grass",   dice=4, STAB=true,    effects={{name="AttackDown", target="Self"}} },
    {name="Leaf Tornado",   power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}}},
    {name="Magical Leaf",   power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Matcha Gotcha",  power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Mega Drain",     power=2,      type="Grass",   dice=6, STAB=true},
    {name="Needle Arm",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Petal Blizzard", power=3,      type="Grass",   dice=6, STAB=true},
    {name="Petal Dance",    power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Confuse", target="Self", chance=5}} },
    {name="Power Whip",     power=3,      type="Grass",   dice=6, STAB=true},
    {name="Razor Leaf",     power=2,      type="Grass",   dice=8, STAB=true},
    {name="Seed Bomb",      power=3,      type="Grass",   dice=6, STAB=true},
    {name="Seed Flare",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp2", target="Self", chance=4}} },
    {name="Sleep Powder",   power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=3}} },
    {name="Solar Beam",     power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Solar Blade",    power=4,      type="Grass",   dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Spicy Extract",  power=0,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp2", target="Self"}} },
    {name="Spiky Shield",   power=1,      type="Grass",   dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Spore",          power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Sleep", target="Enemy"}} },
    {name="Stun Spore",     power=0,      type="Grass",   dice=6, STAB=false,   effects={{name="Paralyse", target="Enemy", chance=3}} },
    {name="Syrup Bomb",     power=3,      type="Grass",   dice=6, STAB=true},
    {name="Trailblaze",     power=2,      type="Grass",   dice=6, STAB=true,    effects={{name="Priority", target="Self"}}},
    {name="Trop Kick",      power=3,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}}},
    {name="Vine Whip",      power=1,      type="Grass",   dice=6, STAB=true},
    {name="Wood Hammer",    power=4,      type="Grass",   dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Vine Lash",      power=3,      type="Grass",   dice=6, STAB=false,   effects={{name="ExtraDice", target="Self"}} },
    {name="Drum Solo",      power=5,      type="Grass",   dice=6, STAB=true},
    {name="Tartness",       power=4,      type="Grass",   dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Sweetness",      power=4,      type="Grass",   dice=6, STAB=true,    effects={{name="Custom"}} },

    -- Ground
    {name="Bone Club",      power=2,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Bone Rush",      power=1,      type="Ground",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Bonemerang",     power=2,      type="Ground",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self"}} },
    {name="Bulldoze",       power=3,      type="Ground",  dice=6, STAB=true},
    {name="Dig",            power=2,      type="Ground",  dice=6, STAB=true},
    {name="Drill Run",      power=3,      type="Ground",  dice=8, STAB=true},
    {name="Earth Power",    power=3,      type="Ground",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Earthquake",     power=2,      type="Ground",  dice=6, STAB=true},
    {name="Fissure",        power=0,      type="Ground",  dice=6, STAB=false,   effects={{name="KO", chance=5, target="Enemy"}} },
    {name="H. Horsepower",  power=3,      type="Ground",  dice=6, STAB=true},
    {name="Headlong Rush",  power=3,      type="Ground",  dice=6, STAB=false,   effects={{name="AttackDown", target="Self"}} },
    {name="Land's Wrath",   power=3,      type="Ground",  dice=6, STAB=false},
    {name="Magnitude",      power=2,      type="Ground",  dice=6, STAB=false,   effects={{name="D4Dice", target="Self", chance=3},{name="ExtraDice", target="Self", chance="6"}}},
    {name="Mud Bomb",       power=3,      type="Ground",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Mud Shot",       power=2,      type="Ground",  dice=6, STAB=false},
    {name="Mud-Slap",       power=1,      type="Ground",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Sand Attack",    power=0,      type="Ground",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Sand Tomb",      power=1,      type="Ground",  dice=6, STAB=false,   effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Sandsear Storm", power=3,      type="Ground",  dice=6, STAB=false,   effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Spikes",         power=0,      type="Ground",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Precipise Blades",power=4,     type="Ground",  dice=6, STAB=false},
    {name="Quake",          power=3,      type="Ground",  dice=6, STAB=false,   effects={{name="Custom"}} },

    -- Ice
    {name="Aurora Beam",    power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Avalanche",      power=3,      type="Ice",     dice=6, STAB=true},
    {name="Blizzard",       power=3,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Freeze-Dry",     power=3,      type="Ice",     dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Glacial Lance",  power=4,      type="Ice",     dice=6, STAB=true},
    {name="Glaciate",       power=3,      type="Ice",     dice=6, STAB=true},
    {name="Hail",           power=0,      type="Ice",     dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Ice Beam",       power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Ice Fang",       power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6},{name="AttackDown", target="Enemy", chance=6}} },
    {name="Ice Hammer",     power=3,      type="Ice",     dice=6, STAB=true},
    {name="Ice Punch",      power=3,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Ice Shard",      power=2,      type="Ice",     dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Ice Spinner",    power=3,      type="Ice",     dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Icicle Crash",   power=3,      type="Ice",     dice=4, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Icicle Spear",   power=1,      type="Ice",     dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Icy Wind",       power=2,      type="Ice",     dice=6, STAB=true},
    {name="Mist",           power=0,      type="Ice",     dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Powder Snow",    power=1,      type="Ice",     dice=6, STAB=true,    effects={{name="Freeze", target="Enemy", chance=6}} },
    {name="Sheer Cold",     power=0,      type="Ice",     dice=6, STAB=true,    effects={{name="KO", target="Enemy", chance=5}} },
    {name="Weather Ball Ice",power=3,     type="Ice",     dice=6, STAB=true},
    {name="Resonance",      power=3,      type="Ice",     dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },

    -- Normal
    {name="Attract",        power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy"}} },
    {name="Barrage",        power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Body Slam",      power=2,      type="Normal",  dice=6, STAB=false,   effects={{name="Paralyse", target="Enemy", chance=5}} },
    {name="Bind",           power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Blood Moon",     power=4,      type="Normal",  dice=6, STAB=false},
    {name="Boomburst",      power=4,      type="Normal",  dice=6, STAB=false},
    {name="Camouflage",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Chip Away",      power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Comet Punch",    power=1,      type="Normal",  dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Constrict",      power=1,      type="Normal",  dice=6, STAB=false},
    {name="Conversion",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Conversion2",    power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Covet",          power=3,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Crush Claw",     power=3,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp", target="Self", chance=4}} },
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
    {name="Facade",         power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Fake Out",       power=1,      type="Normal",  dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}} },
    {name="False Swipe",    power=2,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Fillet Away",    power="Enemy",type="Normal",  dice=6, STAB=true },
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
    {name="Hidden Power",   power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Horn Attack",    power=2,      type="Normal",  dice=6, STAB=true},
    {name="Horn Drill",     power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="KO", target="Enemy", chance=5}} },
    {name="Howl",           power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Hyper Beam",     power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Hyper Drill",    power=3,      type="Normal",  dice=6, STAB=true },
    {name="Hyper Fang",     power=2,      type="Normal",  dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Hyper Voice",    power=2,      type="Normal",  dice=6, STAB=false},
    {name="Judgement",      power=3,      type="Normal",  dice=6, STAB=true,    effects={{name="Custom"}} },
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
    {name="Smelling Salts", power=0,      type="Normal",  dice=6, STAB=false,   effects={{name="Custom"}} },
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

    -- Poison
    {name="Acid",           power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Acid Armor",     power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Acid Spray",     power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="AttackDown2", target="Enemy"}} },
    {name="Bane. Bunker",   power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Custom"},{name="Poison", target="Enemy", chance=4}} },
    {name="Clear Smog",     power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Cross Poison",   power=3,      type="Poison",  dice=6, STAB=true},
    {name="Coil",           power=0,      type="Poison",  dice=6, STAB=true,    effects={{name="AttackUp", target="Self"},{name="AttackDown", target="Enemy"}} },
    {name="Malignant Chain",power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=4}} },
    {name="Mortal Spin",    power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Custom"},{name="Poison", target="Enemy"}} },
    {name="Noxious Torque", power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Poison Fang",    power=2,      type="Poison",  dice=8, STAB=true,    effects={{name="Poison", target="Enemy", chance=4}} },
    {name="Poison Gas",     power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Poison", target="Enemy", chance=2}} },
    {name="Poison Jab",     power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Poison Powder",  power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Poison", target="Enemy", chance=3}} },
    {name="Poison Sting",   power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Poison Tail",    power=2,      type="Poison",  dice=8, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },
    {name="Shell Side Arm", power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },
    {name="Smog",           power=1,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=4}} },
    {name="Sludge",         power=2,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Sludge Bomb",    power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=5}} },
    {name="Sludge Wave",    power=3,      type="Poison",  dice=6, STAB=true,    effects={{name="Poison", target="Enemy", chance=6}} },
    {name="Toxic",          power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Poison", target="Enemy", chance=2}} },
    {name="Toxic Spikes",   power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Venom Drench",   power=0,      type="Poison",  dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Venoshock",      power=3,      type="Poison",  dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Ooze",           power=4,      type="Poison",  dice=6, STAB=false,   effects={{name="Custom"}} },

    -- Psychic
    {name="Agility",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Amnesia",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Barrier",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Calm Mind",      power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackUp2", target="Self"}} },
    {name="Confusion",      power=1,      type="Psychic", dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Cosmic Power",   power=0,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown2", target="Enemy"}} },
    {name="Dream Eater",    power="Sleep",type="Psychic", dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="Eerie Spell",    power=3,      type="Psychic", dice=6, STAB=false    },
    {name="Esper Wing",     power=3,      type="Psychic", dice=8, STAB=true     },
    {name="Extrasensory",   power=2,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Freezing Glare", power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="Frozen", target="Enemy", chance=6}} },
    {name="Future Sight",   power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="Recharge", target="Self"}} },
    {name="Healing Wish",   power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"},{name="KO", target="Self"}} },
    {name="Heart Stamp",    power=3,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Hyperspace Hole",power=3,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Hypnosis",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Sleep", target="Enemy", chance=4}} },
    {name="Imprison",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Light Screen",   power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Lumina Crash",   power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackUp", target="Self"}} },
    {name="Luster Purge",   power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}} },
    {name="Magic Coat",     power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Meditate",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackUp", target="Self"}} },
    {name="Mirror Coat",    power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Mist Ball",      power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}} },
    {name="Photon Geyser",  power=3,      type="Psychic", dice=6, STAB=false    },
    {name="Prism. Laser",   power=3,      type="Psychic", dice=6, STAB=false    },
    {name="Psybeam",        power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="Confuse", target="Enemy", chance=4}} },
    {name="Psyblade",       power=3,      type="Psychic", dice=6, STAB=false    },
    {name="Psywave",        power="Self", type="Psychic", dice=6, STAB=false    },
    {name="Psychic",        power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Psychic Fangs",  power=3,      type="Psychic", dice=6, STAB=true },
    {name="Psycho Boost",   power=4,      type="Psychic", dice=6, STAB=true     },
    {name="Psycho Cut",     power=3,      type="Psychic", dice=8, STAB=true     },
    {name="Psyshield Bash", power=3,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy"}}     },
    {name="Psyshock",       power=3,      type="Psychic", dice=6, STAB=true     },
    {name="Reflect",        power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="AttackDown2", target="Enemy"}} },
    {name="Rev. Dance Psychic",power=3,   type="Psychic", dice=6, STAB=true},
    {name="Telekinesis",    power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Custom"}} },
    {name="Teleport",       power=0,      type="Psychic", dice=6, STAB=false,   effects={{name="Switch", target="Self"}} },
    {name="Twin Beam",      power=2,      type="Psychic", dice=4, STAB=false,   effects={{name="ExtraDice", target="Self"}} },
    {name="Zen Headbutt",   power=2,      type="Psychic", dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Psystrike",      power=3,      type="Psychic", dice=6, STAB=true},
    {name="Gravitas",       power=4,      type="Psychic", dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Mindstorm",      power=4,      type="Psychic", dice=6, STAB=true,    effects={{name="Custom"}} },

    -- Rock
    {name="Accelerock",     power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Ancient Power",  power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=6},{name="AttackUp", target="Self", chance=6}} },
    {name="Diamond Storm",  power=3,      type="Rock",    dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=4}} },
    {name="Head Smash",     power=3,      type="Rock",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Ivy Cudgel Rock",power=4,      type="Rock",    dice=8, STAB=true},
    {name="Mighty Cleave",  power=2,      type="Rock",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Power Gem",      power=2,      type="Rock",    dice=6, STAB=true},
    {name="Rock Polish",    power=0,      type="Rock",    dice=6, STAB=true,    effects={{name="Priority", target="Self"}} },
    {name="Rock Slide",     power=3,      type="Rock",    dice=6, STAB=true,    effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Rock Throw",     power=1,      type="Rock",    dice=6, STAB=true},
    {name="Rollout",        power=1,      type="Rock",    dice=6, STAB=true,    effects={{name="Custom"}} },
    {name="Rock Blast",     power=1,      type="Rock",    dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}}},
    {name="Rock Tomb",      power=3,      type="Rock",    dice=6, STAB=true},
    {name="Rock Wrecker",   power=4,      type="Rock",    dice=6, STAB=true,    effects={{name="KO", target="Self", chance=6}} },
    {name="Salt Cure",      power=0,      type="Rock",    dice=8, STAB=false,   effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Sandstorm",      power=0,      type="Rock",    dice=8, STAB=false,   effects={{name="Custom"}} },
    {name="Stealth Rock",   power=0,      type="Rock",    dice=6, STAB=false,   effects={{name="Custom"}}},
    {name="Stone Axe",      power=3,      type="Rock",    dice=8, STAB=true},
    {name="Stone Edge",     power=3,      type="Rock",    dice=8, STAB=true},
    {name="Tera Blast",     power=3,      type="Rock",    dice=6, STAB=true},
    {name="Wide Guard",     power=0,      type="Rock",    dice=8, STAB=true,    effects={{"Protect", target="Self" }} },
    {name="Volcalith",      power=4,      type="Rock",    dice=6, STAB=false,   effects={{name="Custom"}}},
    {name="Sandblast",      power=3,      type="Rock",    dice=4, STAB=true,    effects={{name="ExtraDice", target="Self", chance=4}}},
    
    -- Steel
    {name="Anchor Shot",    power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Autotomize",     power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackUp2", target="Self"}} },
    {name="Behemoth Bash",  power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Behemoth Blade", power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Doom Desire",    power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="Recharge", target="Self"}} },
    {name="Dbl. Iron Bash", power=2,      type="Steel",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self", chance=5}} },
    {name="Flash Cannon",   power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Gear Grind",     power=2,      type="Steel",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Gigaton Hammer", power=2,      type="Steel",  dice=4, STAB=true},
    {name="Gyro Ball",      power="Self", type="Steel",  dice=6, STAB=false},
    {name="Heavy Slam",     power=3,      type="Steel",  dice=6, STAB=true },
    {name="Iron Defense",   power=0,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown2", target="Enemy"}} },
    {name="Iron Head",      power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Iron Tail",      power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=5}} },
    {name="King's Shield",  power=0,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Magnet Bomb",    power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self"}} },
    {name="Make It Rain",   power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Self"}, {name="Custom"}} },
    {name="Metal Burst",    power=0,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Metal Claw",     power=1,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Metal Mash",     power=1,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=6}} },
    {name="Metal Sound",    power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackUp2", target="Self"}} },
    {name="Meteor Mash",    power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self", chance=5}} },
    {name="Mirror Shot",    power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Shift Gear",     power=0,      type="Steel",  dice=6, STAB=false,    effects={{name="AttackUp2", target="Self", chance=6}} },
    {name="Spin Out",       power=3,      type="Steel",  dice=6, STAB=true },
    {name="Steel Wing",     power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=6}} },
    {name="Sunsteel Strike",power=3,      type="Steel",  dice=6, STAB=true },
    {name="Smart Strike",   power=2,      type="Steel",  dice=6, STAB=true,     effects={{name="AttackUp", target="Self"}} },
    {name="Tachyon Cutter", power=2,      type="Steel",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Steelspike",     power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Steelsurge",     power=4,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },
    {name="Depletion",      power=3,      type="Steel",  dice=6, STAB=true,     effects={{name="Custom"}} },

    -- Water
    {name="Aqua Jet",       power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Priority", target="Self"}} },
    {name="Aqua Step",      power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Priority", target="Self"}} },
    {name="Aqua Tail",      power=2,      type="Water",  dice=6, STAB=true},
    {name="Brine",          power=3,      type="Water",  dice=6, STAB=true},
    {name="Bubble",         power=1,      type="Water",  dice=6, STAB=true},
    {name="Bubble Beam",    power=2,      type="Water",  dice=6, STAB=true},
    {name="Clamp",          power=1,      type="Water",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self", chance=4}} },
    {name="Crabhammer",     power=3,      type="Water",  dice=8, STAB=true},
    {name="Dive",           power=3,      type="Water",  dice=6, STAB=true},
    {name="Flip Turn",      power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Switch", target="Self"}}},
    {name="Hydro Pump",     power=3,      type="Water",  dice=6, STAB=true},
    {name="Ivy Cudgel Water",power=3,     type="Water",  dice=8, STAB=true},
    {name="Jet Punch",      power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Priority"}}},
    {name="Liquidation",    power=3,      type="Water",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Muddy Water",    power=3,      type="Water",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Octazooka",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="AttackUp", target="Enemy", chance=4}} },
    {name="Raging Bull Water",power=3,    type="Water",  dice=6, STAB=false},
    {name="Rain Dance",     power=3,      type="Water",  dice=6, STAB=false,    effects={{name="Custom"}} },
    {name="Razor Shell",    power=3,      type="Water",  dice=8, STAB=true},
    {name="Scald",          power=3,      type="Water",  dice=6, STAB=true,     effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Snipe Shot",     power=3,      type="Water",  dice=8, STAB=true},
    {name="Sparkling Aria", power=3,      type="Water",  dice=6, STAB=true},
    {name='Steam Eruption', power=4,      type="Water",  dice=6, STAB=true,     effects={{name="Burn", target="Enemy", chance=5}} },
    {name="Surf",           power=2,      type="Water",  dice=6, STAB=true},
    {name="Surging Strikes",power=3,      type="Water",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}}},
    {name="Triple Dive",    power=2,      type="Water",  dice=4, STAB=true,     effects={{name="ExtraDice", target="Self"}}},
    {name="Water Gun",      power=1,      type="Water",  dice=6, STAB=true},
    {name="Water Pulse",    power=2,      type="Water",  dice=6, STAB=true,     effects={{name="Confuse", target="Enemy", chance=6}} },
    {name="Water Shuriken", power=2,      type="Water",  dice=4, STAB=true,     effects={{name="Priority", target="Self"},{name="AttackUp", target="Self", chance=4}}},
    {name="Water Spout",    power=4,      type="Water",  dice=6, STAB=true},
    {name="Wave Crash",     power=4,      type="Water",  dice=6, STAB=true,     effects={{name="KO", target="Self", chance=6}} },
    {name="Waterfall",      power=2,      type="Water",  dice=6, STAB=true,     effects={{name="AttackDown", target="Enemy", chance=5}} },
    {name="Whirlpool",      power=1,      type="Water",  dice=6, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Withdraw",       power=0,      type="Water",  dice=6, STAB=false,    effects={{name="AttackDown", target="Enemy"}} },
    {name="Weather Ball Water",power=3,   type="Water",  dice=6, STAB=true},
    {name="Origin Pulse",   power=4,      type="Water",  dice=6, STAB=true},
    {name="Cannonade",      power=3,      type="Water",  dice=6, STAB=true,     effects={{name="ExtraDice", target="Self"}} },
    {name="Foam Burst",     power=4,      type="Water",  dice=6, STAB=true,     effects={{name="Priority", target="Self"}} },
    {name="Hydro Snipe",    power=5,      type="Water",  dice=6, STAB=true},
    {name="Stonesurge",     power=4,      type="Water",  dice=6, STAB=false,    effects={{name="Custom"}} },
    {name="Rapid Flow",     power=4,      type="Water",  dice=6, STAB=false,    effects={{name="Custom"}} },
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
      { name = "Weezing", level = 5,  types = { "Poison" },            moves = { "Smokescreen", "Sludge", "Self-Destruct" } },
      { name = "Arbok",   level = 6,  types = { "Poison" },            moves = { "Screech", "Acid", "Bite" } } 
    }
  },
  -- GenII Team Rocket
  {
    guid = "81131f",
    trainerName = "Team Rocket",
    gen = 2,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Kangaskhan", level = 5, types = { "Normal" },           moves = { "Comet Punch", "Rage", "Sucker Punch" } },
      { name = "Nidoqueen",  level = 6, types = { "Poison", "Ground" }, moves = { "Poison Fang", "Body Slam", "Bite" } }
    }
  },
  -- GenIII Team Rocket
  {
    guid = "d91038",
    trainerName = "Team Rocket",
    gen = 3,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Camerupt",   level = 5, types = { "Fire", "Ground" },     moves = { "Fissure", "Ember", "Earthquake" } },
      { name = "Sharpedo",   level = 6, types = { "Water", "Dark" },      moves = { "Swagger", "Aqua Jet", "Crunch" } }
    }
  },
  -- GenIV Team Rocket
  {
    guid = "25a357",
    trainerName = "Team Galactic",
    gen = 4,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Crobat",     level = 5, types = { "Poison", "Flying" },   moves = { "Poison Fang", "Air Cutter", "Bite" } },
      { name = "Honchkrow",  level = 6, types = { "Dark", "Flying" },     moves = { "Night Shade", "Drill Peck", "Feint Attack" } }
    }
  },
  -- GenV Team Rocket
  {
    guid = "c6bb6e",
    trainerName = "Team Plasma",
    gen = 5,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Zoroark",    level = 5, types = { "Dark" },               moves = { "Fury Swipes", "Hone Claws", "Feint Attack" } },
      { name = "Hydreigon",  level = 6, types = { "Dark", "Dragon" },     moves = { "Tri Attack", "Assurance", "Dragon Breath" } }
    }
  },
  -- GenVI Team Rocket
  {
    guid = "edb9ad",
    trainerName = "Team Flare",
    gen = 6,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Liepard",    level = 5, types = { "Dark" },               moves = { "Fury Swipes", "Hone Claws", "Play Rough" } },
      { name = "Pyroar",     level = 6, types = { "Fire", "Normal" },     moves = { "Noble Roar", "Crunch", "Flamethrower" } }
    }
  },
  -- GenVII Team Rocket
  {
    guid = "85a301",
    trainerName = "Team Rocket",
    gen = 7,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Golisopod",  level = 5, types = { "Bug", "Water" },       moves = { "Swords Dance", "Razor Shell", "First Impression" } },
      { name = "Bewear",     level = 6, types = { "Normal", "Fighting" }, moves = { "Take Down", "Payback", "Hammer Arm" } }
    }
  },
  -- GenVIII Team Rocket
  {
    guid = "a5c540",
    trainerName = "Team Yell",
    gen = 8,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Linoone",    level = 5, types = { "Dark", "Normal" },     moves = { "Night Slash", "Sucker Punch", "Tail Slap" } },
      { name = "Thievul",    level = 6, types = { "Dark" },               moves = { "Slash", "Hone Claws", "Pin Missile" } }
    }
  },
  -- GenIX Team Rocket
  {
    guid = "5bf887",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Dachsbun",   level = 5, types = { "Fairy" },              moves = { "Crunch", "Mud-Slap", "Play Rough" } },
      { name = "Revavroom",  level = 6, types = { "Fairy" },              moves = { "Spin Out", "Confuse Ray", "Magical Torque" } }
    }
  },
  {
    guid = "d32942",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Torkoal",    level = 5, types = { "Fire" },               moves = { "Iron Defense", "Clear Smog", "Flame Wheel" } },
      { name = "Revavroom",  level = 6, types = { "Fire" },               moves = { "Swift", "Screech", "Blazing Torque" } }
    }
  },
  {
    guid = "7e5fa6",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Pawniard",   level = 5, types = { "Dark", "Steel" },      moves = { "Aerial Ace", "Metal Claw", "Fury Cutter" } },
      { name = "Revavroom",  level = 6, types = { "Dark" },               moves = { "Swift", "Metal Sound", "Wicked Torque" } }
    }
  },
  {
    guid = "148183",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Annihilape", level = 5, types = { "Fighting", "Ghost" },  moves = { "Rage Fist", "Fire Punch", "Ice Punch" } },
      { name = "Revavroom",  level = 6, types = { "Fighting" },           moves = { "Spin Out", "H. Horsepower", "Combat Torque" } }
    }
  },
  {
    guid = "908116",
    trainerName = "Team Star",
    gen = 9,
    gymTier = 11,   -- Signifies Team Rocket
    pokemon = {
      { name = "Skuntank",   level = 5, types = { "Poison", "Dark" },     moves = { "Sucker Punch", "Venoshock", "Fury Swipes" } },
      { name = "Revavroom",  level = 6, types = { "Poison" },             moves = { "Spin Out", "Flame Charge", "Noxious Torque" } }
    }
  },

  -- Gen I
  -- Gym Leaders
  {
    guid = "5ad999",
    trainerName = "Brock",
    pokemon = {
      { name = "Geodude", level = 1, types = { "Rock", "Ground" }, moves = { "Defense Curl", "Tackle", "Rock Throw" } },
      { name = "Onix",    level = 2, types = { "Rock", "Ground" }, moves = { "Screech", "Bind", "Rock Throw" } } }
  },
  {
    guid = "7e7d23",
    trainerName = "Misty",
    pokemon = {
      { name = "Staryu",  level = 3, types = { "Water" }, moves = { "Harden", "Water Gun", "Rapid Spin" } },
      { name = "Starmie", level = 3, types = { "Water" }, moves = { "Tackle", "Water Pulse", "Rapid Spin" } } }
  },
  {
    guid = "e87599",
    trainerName = "Lt. Surge",
    pokemon = {
      { name = "Voltorb", level = 3, types = { "Electric" }, moves = { "Screech", "Sonic Boom", "Shock Wave" } },
      { name = "Raichu",  level = 4, types = { "Electric" }, moves = { "Quick Attack", "Mega Kick", "Shock Wave" } } }
  },
  {
    guid = "e251b8",
    trainerName = "Erika",
    pokemon = {
      { name = "Tangela",   level = 4, types = { "Grass" },           moves = { "Poison Powder", "Giga Drain", "Vine Whip" } },
      { name = "Vileplume", level = 4, types = { "Grass", "Poison" }, moves = { "Acid", "Sleep Powder", "Petal Dance" } } }
  },
  {
    guid = "10246c",
    trainerName = "Koga",
    pokemon = {
      { name = "Muk",     level = 5, types = { "Poison" }, moves = { "Toxic", "Moonblast", "Sludge" } },
      { name = "Weezing", level = 6, types = { "Poison" }, moves = { "Protect", "Self-Destruct", "Sludge" } } }
  },
  {
    guid = "26c22d",
    trainerName = "Sabrina",
    pokemon = {
      { name = "Mr. Mime", level = 5, types = { "Psychic" }, moves = { "Barrier", "Psybeam", "Double Slap" } },
      { name = "Alakazam", level = 6, types = { "Psychic" }, moves = { "Reflect", "Psybeam", "Night Shade" } } }
  },
  {
    guid = "cca8ed",
    trainerName = "Blaine",
    pokemon = {
      { name = "Rapidash", level = 7, types = { "Fire" }, moves = { "Bounce", "Stomp", "Fire Spin" } },
      { name = "Arcanine", level = 7, types = { "Fire" }, moves = { "Crunch", "Outrage", "Flare Blitz" } } }
  },
  {
    guid = "7cda88",
    trainerName = "Giovanni",
    pokemon = {
      { name = "Dugtrio",  level = 7, types = { "Ground" }, moves = { "Sucker Punch", "Slash", "Dig" } },
      { name = "Nidoking", level = 7, types = { "Poison" }, moves = { "Poison Jab", "Megahorn", "Earthquake" } } }
  },

  -- Elite Four + Champion
  {
    guid = "bd572f",
    trainerName = "Lorelei",
    pokemon = {
      { name = "Cloyster", level = 8, types = { "Water", "Ice" }, moves = { "Protect", "Hydro Pump", "Aurora Beam" } },
      { name = "Lapras",   level = 9, types = { "Water", "Ice" }, moves = { "Body Slam", "Hydro Pump", "Blizzard" } } }
  },
  {
    guid = "ec4724",
    trainerName = "Bruno",
    pokemon = {
      { name = "Hitmonlee", level = 8, types = { "Fighting" }, moves = { "Mega Kick", "Rolling Kick", "High Jump Kick" } },
      { name = "Machamp",   level = 9, types = { "Fighting" }, moves = { "Earthquake", "Cross Chop", "Submission" } } }
  },
  {
    guid = "0a1c4c",
    trainerName = "Agatha",
    pokemon = {
      { name = "Arbok",  level = 8, types = { "Poison" }, moves = { "Glare", "Crunch", "Sludge Bomb" } },
      { name = "Gengar", level = 9, types = { "Ghost" },  moves = { "Confuse Ray", "Dream Eater", "Night Shade" } } }
  },
  {
    guid = "9e7552",
    trainerName = "Lance",
    pokemon = {
      { name = "Gyarados",  level = 8, types = { "Water", "Flying" },  moves = { "Hyper Beam", "Dragon Rage", "Hydro Pump" } },
      { name = "Dragonite", level = 9, types = { "Dragon", "Flying" }, moves = { "Hyper Beam", "Dragon Rage", "Blizzard" } } }
  },

  {
    guid = "5686a8",
    trainerName = "Gary",
    pokemon = {
      { name = "Arcanine", level = 9,  types = { "Fire", "Dark" }, moves = { "Crunch", "Extreme Speed", "Flamethrower" } },
      { name = "Venusaur", level = 10, types = { "Grass" },        moves = { "Growth", "Razor Leaf", "Solar Beam" } } }
  },
  {
    guid = "f0b286",
    trainerName = "Gary",
    pokemon = {
      { name = "Pidgeot",   level = 9,  types = { "Flying", "Normal" }, moves = { "Feather Dance", "Mirror Move", "Sky Attack" } },
      { name = "Blastoise", level = 10, types = { "Water" },            moves = { "Flash Cannon", "Blizzard", "Hydro Pump" } } }
  },
  {
    guid = "874b94",
    trainerName = "Gary",
    pokemon = {
      { name = "Alakazam",  level = 9,  types = { "Psychic" },        moves = { "Reflect", "Shadow Ball", "Future Sight" } },
      { name = "Charizard", level = 10, types = { "Fire", "Flying" }, moves = { "Slash", "Aerial Ace", "Fire Blast" } } }
  },

  -- Gen II
  -- Gym Leaders
  {
    guid = "d9713f",
    trainerName = "Falkner",
    pokemon = {
      { name = "Pidgey",    level = 2, types = { "Flying", "Normal" }, moves = { "Sand Attack", "Tackle", "Peck" } },
      { name = "Pidgeotto", level = 2, types = { "Flying", "Normal" }, moves = { "Mud-Slap", "Tackle", "Gust" } } }
  },
  {
    guid = "78fe04",
    trainerName = "Bugsy",
    pokemon = {
      { name = "Kakuna",  level = 3, types = { "Bug" },           moves = { "String Shot", "Harden", "Poison Sting" } },
      { name = "Scyther", level = 3, types = { "Bug", "Flying" }, moves = { "Fury Cutter", "Quick Attack", "Wing Attack" } } }
  },
  {
    guid = "932ee1",
    trainerName = "Whitney",
    pokemon = {
      { name = "Clefairy", level = 3, types = { "Fairy" },  moves = { "Mimic", "Metronome", "Moonblast" } },
      { name = "Miltank",  level = 4, types = { "Normal" }, moves = { "Rollout", "Stomp", "Play Rough" } } }
  },
  {
    guid = "6c22b9",
    trainerName = "Morty",
    pokemon = {
      { name = "Haunter", level = 4, types = { "Ghost" }, moves = { "Mimic", "Hypnosis", "Night Shade" } },
      { name = "Gengar",  level = 4, types = { "Ghost" }, moves = { "Sucker Punch", "Dream Eater", "Shadow Ball" } } }
  },
  {
    guid = "1297c5",
    trainerName = "Chuck",
    pokemon = {
      { name = "Primeape",  level = 5, types = { "Fighting" },          moves = { "Rage", "Rock Slide", "Karate Chop" } },
      { name = "Poliwrath", level = 6, types = { "Water", "Fighting" }, moves = { "Hypnosis", "Surf", "Dynamic Punch" } } }
  },
  {
    guid = "9d44d1",
    trainerName = "Jasmine",
    pokemon = {
      { name = "Magnemite", level = 5, types = { "Electric", "Steel" }, moves = { "Thunder Wave", "Sonic Boom", "Thunderbolt" } },
      { name = "Steelix",   level = 6, types = { "Steel", "Ground" },   moves = { "Earthquake", "Screech", "Iron Tail" } } }
  },
  {
    guid = "a713db",
    trainerName = "Pryce",
    pokemon = {
      { name = "Dewgong",   level = 7, types = { "Water", "Ice" },  moves = { "Headbutt", "Icy Wind", "Aurora Beam" } },
      { name = "Piloswine", level = 7, types = { "Ice", "Ground" }, moves = { "Mud Bomb", "Ice Fang", "Blizzard" } } }
  },
  {
    guid = "9846bd",
    trainerName = "Clair",
    pokemon = {
      { name = "Dragonair", level = 7, types = { "Dragon" },          moves = { "Surf", "Fire Blast", "Dragon Breath" } },
      { name = "Kingdra",   level = 7, types = { "Water", "Dragon" }, moves = { "Surf", "Hyper Beam", "Dragon Breath" } } }
  },

  -- Elite Four + champion
  {
    guid = "746880",
    trainerName = "Will",
    pokemon = {
      { name = "Jynx", level = 8, types = { "Ice", "Psychic" },    moves = { "Lovely Kiss", "Ice Punch", "Psychic" } },
      { name = "Xatu", level = 9, types = { "Psychic", "Flying" }, moves = { "Confuse Ray", "Aerial Ace", "Psychic" } } }
  },
  {
    guid = "9447fd",
    trainerName = "Koga",
    pokemon = {
      { name = "Forretress", level = 8, types = { "Bug", "Steel" },     moves = { "Spikes", "Swift", "Explosion" } },
      { name = "Crobat",     level = 9, types = { "Poison", "Flying" }, moves = { "Poison Fang", "Bite", "Wing Attack" } } }
  },
  {
    guid = "d99872",
    trainerName = "Bruno",
    pokemon = {
      { name = "Hitmontop", level = 8, types = { "Fighting" }, moves = { "Triple Kick", "Detect", "Counter" } },
      { name = "Machamp",   level = 9, types = { "Fighting" }, moves = { "Rock Slide", "Vital Throw", "Cross Chop" } } }
  },
  {
    guid = "d55f10",
    trainerName = "Karen",
    pokemon = {
      { name = "Umbreon",  level = 8, types = { "Dark" },         moves = { "Confuse Ray", "Payback", "Feint Attack" } },
      { name = "Houndoom", level = 9, types = { "Dark", "Fire" }, moves = { "Flamethrower", "Pursuit", "Crunch" } } }
  },

  {
    guid = "6601cb",
    trainerName = "Red",
    pokemon = {
      { name = "Pikachu", level = 9,  types = { "Electric" }, moves = { "Iron Tail", "Thunderbolt", "Volt Tackle" } },
      { name = "Snorlax", level = 10, types = { "Normal" },   moves = { "Crunch", "Blizzard", "Giga Impact" } } }
  },
  {
    guid = "4cddc6",
    trainerName = "Lance",
    pokemon = {
      { name = "Charizard",  level = 9,  types = { "Fire", "Flying" }, moves = { "Slash", "Wing Attack", "Flamethrower" } },
      { name = "Aerodactyl", level = 10, types = { "Rock", "Flying" }, moves = { "Hyper Beam", "Wing Attack", "Ancient Power" } } }
  },
  {
    guid = "6178d5",
    trainerName = "Lance",
    pokemon = {
      { name = "Gyarados",  level = 9,  types = { "Water" },  moves = { "Hyper Beam", "Surf", "Dragon Rage" } },
      { name = "Dragonite", level = 10, types = { "Dragon" }, moves = { "Hyper Beam", "Blizzard", "Thunder" } } }
  },

  -- Gen III
  -- Gym Leaders
  {
    guid = "a12ffa",
    trainerName = "Roxanne",
    pokemon = {
      { name = "Geodude",  level = 2, types = { "Rock" }, moves = { "Defense Curl", "Tackle", "Rock Throw" } },
      { name = "Nosepass", level = 2, types = { "Rock" }, moves = { "Rock Tomb", "Tackle", "Rock Throw" } } }
  },
  {
    guid = "300c55",
    trainerName = "Brawly",
    pokemon = {
      { name = "Machop",   level = 3, types = { "Fighting" }, moves = { "Bulk Up", "Seismic Toss", "Low Kick" } },
      { name = "Makuhita", level = 3, types = { "Fighting" }, moves = { "Sand Attack", "Arm Thrust", "Knock Off" } } }
  },
  {
    guid = "fc6195",
    trainerName = "Wattson",
    pokemon = {
      { name = "Voltorb",   level = 3, types = { "Electric" }, moves = { "Sonic Boom", "Spark", "Self-Destruct" } },
      { name = "Manectric", level = 4, types = { "Electric" }, moves = { "Quick Attack", "Shock Wave", "Thunder Wave" } } }
  },
  {
    guid = "7fab48",
    trainerName = "Flannery",
    pokemon = {
      { name = "Slugma",  level = 4, types = { "Fire" }, moves = { "Light Screen", "Rock Slide", "Flamethrower" } },
      { name = "Torkoal", level = 4, types = { "Fire" }, moves = { "Protect", "Body Slam", "Overheat" } } }
  },
  {
    guid = "1e64be",
    trainerName = "Norman",
    pokemon = {
      { name = "Vigoroth", level = 5, types = { "Normal" }, moves = { "Feint Attack", "Slash", "Facade" } },
      { name = "Slaking",  level = 6, types = { "Normal" }, moves = { "Feint Attack", "Focus Punch", "Facade" } } }
  },
  {
    guid = "7fd11d",
    trainerName = "Winona",
    pokemon = {
      { name = "Pelipper", level = 5, types = { "Water" },  moves = { "Supersonic", "Water Pulse", "Aerial Ace" } },
      { name = "Altaria",  level = 6, types = { "Dragon" }, moves = { "Earthquake", "Dragon Breath", "Aerial Ace" } } }
  },
  {
    guid = "f07fbc",
    trainerName = "Tate & Liza",
    pokemon = {
      { name = "Lunatone", level = 7, types = { "Rock" }, moves = { "Light Screen", "Moonblast", "Rock Slide" } },
      { name = "Solrock",  level = 7, types = { "Rock" }, moves = { "Psychic", "Solar Beam", "Flare Blitz" } } }
  },
  {
    guid = "02fd5e",
    trainerName = "Wallace",
    pokemon = {
      { name = "Whiscash", level = 7, types = { "Water" }, moves = { "Amnesia", "Earthquake", "Water Pulse" } },
      { name = "Milotic",  level = 7, types = { "Water" }, moves = { "Dragon Tail", "Blizzard", "Water Pulse" } } }
  },

  -- Elite Four
  {
    guid = "c20862",
    trainerName = "Phoebe",
    pokemon = {
      { name = "Sableye",  level = 8, types = { "Dark" },  moves = { "Psychic", "Shadow Ball", "Feint Attack" } },
      { name = "Dusclops", level = 9, types = { "Ghost" }, moves = { "Future Sight", "Shadow Ball", "Ice Beam" } } }
  },
  {
    guid = "e7052f",
    trainerName = "Drake",
    pokemon = {
      { name = "Flygon",    level = 8, types = { "Ground" }, moves = { "Fly", "Dig", "Dragon Breath" } },
      { name = "Salamence", level = 9, types = { "Dragon" }, moves = { "Fly", "Flamethrower", "Dragon Claw" } } }
  },
  {
    guid = "0d0d9f",
    trainerName = "Glacia",
    pokemon = {
      { name = "Glalie",  level = 8, types = { "Ice" }, moves = { "Light Screen", "Crunch", "Ice Beam" } },
      { name = "Walrein", level = 9, types = { "Ice" }, moves = { "Sheer Cold", "Surf", "Blizzard" } } }
  },
  {
    guid = "1d1aa1",
    trainerName = "Sidney",
    pokemon = {
      { name = "Sharpedo", level = 8, types = { "Water" }, moves = { "Slash", "Surf", "Crunch" } },
      { name = "Absol",    level = 9, types = { "Dark" },  moves = { "Psycho Cut", "Aerial Ace", "Night Slash" } } }
  },
  -- Champion
  {
    guid = "857b59",
    trainerName = "Steven",
    pokemon = {
      { name = "Claydol", level = 9,  types = { "Ground" }, moves = { "Earthquake", "Ancient Power", "Extrasensory" } },
      { name = "Aggron",  level = 10, types = { "Steel" },  moves = { "Thunder", "Stone Edge", "Iron Tail" } } }
  },
  {
    guid = "9b5e32",
    trainerName = "Steven",
    pokemon = {
      { name = "Skarmory", level = 9,  types = { "Steel" }, moves = { "Spikes", "Aerial Ace", "Steel Wing" } },
      { name = "Armaldo",  level = 10, types = { "Rock" },  moves = { "Slash", "X-Scissor", "Ancient Power" } } }
  },
  {
    guid = "f7b21f",
    trainerName = "Steven",
    pokemon = {
      { name = "Cradily",   level = 9,  types = { "Rock" },  moves = { "Sludge Bomb", "Giga Drain", "Ancient Power" } },
      { name = "Metagross", level = 10, types = { "Steel" }, moves = { "Psychic", "Meteor Mash", "Giga Impact" } } }
  },

  -- Gen IV
  -- Gym Leaders
  {
    guid = "837e35",
    trainerName = "Roark",
    pokemon = {
      { name = "Onix",     level = 2, types = { "Rock" }, moves = { "Screech", "Stealth Rock", "Rock Throw" } },
      { name = "Cranidos", level = 2, types = { "Rock" }, moves = { "Screech", "Pursuit", "Headbutt" } } }
  },
  {
    guid = "e2826d",
    trainerName = "Gardenia",
    pokemon = {
      { name = "Cherubi",  level = 3, types = { "Grass" }, moves = { "Safeguard", "Dazzling Gleam", "Grass Knot" } },
      { name = "Roserade", level = 3, types = { "Grass" }, moves = { "Stun Spore", "Poison Sting", "Magical Leaf" } } }
  },
  {
    guid = "5b3c49",
    trainerName = "Maylene",
    pokemon = {
      { name = "Meditite", level = 3, types = { "Fighting" }, moves = { "Meditate", "Confusion", "Drain Punch" } },
      { name = "Lucario",  level = 4, types = { "Fighting" }, moves = { "Metal Claw", "Bone Rush", "Force Palm" } } }
  },
  {
    guid = "2c12d2",
    trainerName = "Crasher Wake",
    pokemon = {
      { name = "Quagsire", level = 4, types = { "Water" }, moves = { "Rock Tomb", "Mud Bomb", "Water Pulse" } },
      { name = "Floatzel", level = 4, types = { "Water" }, moves = { "Swift", "Ice Fang", "Aqua Jet" } } }
  },
  {
    guid = "a6e3cb",
    trainerName = "Fantina",
    pokemon = {
      { name = "Duskull",   level = 5, types = { "Ghost" }, moves = { "Will-O-Wisp", "Shadow Sneak", "Future Sight" } },
      { name = "Mismagius", level = 6, types = { "Ghost" }, moves = { "Magical Leaf", "Shadow Ball", "Psybeam" } } }
  },
  {
    guid = "25c52f",
    trainerName = "Byron",
    pokemon = {
      { name = "Steelix",   level = 5, types = { "Steel" }, moves = { "Ice Fang", "Earthquake", "Flash Cannon" } },
      { name = "Bastiodon", level = 6, types = { "Rock" },  moves = { "Iron Defense", "Stone Edge", "Metal Burst" } } }
  },
  {
    guid = "3069f3",
    trainerName = "Candice",
    pokemon = {
      { name = "Abomasnow", level = 7, types = { "Grass" }, moves = { "Avalanche", "Focus Blast", "Wood Hammer" } },
      { name = "Frosslass", level = 7, types = { "Ice" },   moves = { "Blizzard", "Psychic", "Shadow Ball" } } }
  },
  {
    guid = "f14c62",
    trainerName = "Volkner",
    pokemon = {
      { name = "Luxray",     level = 7, types = { "Electric" }, moves = { "Ice Fang", "Fire Fang", "Thunder Fang" } },
      { name = "Electivire", level = 7, types = { "Electric" }, moves = { "Cross Chop", "Giga Impact", "Thunder Punch" } } }
  },

  -- Elite Four
  {
    guid = "9244aa",
    trainerName = "Lucian",
    pokemon = {
      { name = "Bronzong", level = 8, types = { "Steel" },   moves = { "Earthquake", "Gyro Ball", "Psychic" } },
      { name = "Gallade",  level = 9, types = { "Psychic" }, moves = { "Leaf Blade", "Drain Punch", "Psycho Cut" } } }
  },
  {
    guid = "547ba3",
    trainerName = "Flint",
    pokemon = {
      { name = "Infernape", level = 8, types = { "Fire" }, moves = { "Mach Punch", "Thunder Punch", "Flare Blitz" } },
      { name = "Magmortar", level = 9, types = { "Fire" }, moves = { "Solar Beam", "Thunderbolt", "Flamethrower" } } }
  },
  {
    guid = "38ec9f",
    trainerName = "Bertha",
    pokemon = {
      { name = "Hippowdon", level = 8, types = { "Ground" }, moves = { "Ice Fang", "Earthquake", "Stone Edge" } },
      { name = "Rhyperior", level = 9, types = { "Ground" }, moves = { "Megahorn", "Earthquake", "Rock Wrecker" } } }
  },
  {
    guid = "af0b4e",
    trainerName = "Aaron",
    pokemon = {
      { name = "Heracross", level = 8, types = { "Bug" },    moves = { "Close Combat", "Night Slash", "Megahorn" } },
      { name = "Drapion",   level = 9, types = { "Poison" }, moves = { "Aerial Ace", "Cross Poison", "X-Scissor" } } }
  },
  -- Champion
  {
    guid = "2648b8",
    trainerName = "Cynthia",
    pokemon = {
      { name = "Togekiss", level = 9,  types = { "Fairy" },    moves = { "Aura Sphere", "Dazzling Gleam", "Air Slash" } },
      { name = "Lucario",  level = 10, types = { "Fighting" }, moves = { "Stone Edge", "Aura Sphere", "Flash Cannon" } } }
  },
  {
    guid = "d10e0c",
    trainerName = "Cynthia",
    pokemon = {
      { name = "Roserade", level = 9,  types = { "Grass" }, moves = { "Extrasensory", "Energy Ball", "Sludge Bomb" } },
      { name = "Milotic",  level = 10, types = { "Water" }, moves = { "Mirror Coat", "Surf", "Ice Beam" } } }
  },
  {
    guid = "25281e",
    trainerName = "Cynthia",
    pokemon = {
      { name = "Spiritomb", level = 9,  types = { "Ghost" },  moves = { "Silver Wind", "Shadow Ball", "Dark Pulse" } },
      { name = "Garchomp",  level = 10, types = { "Dragon" }, moves = { "Earthquake", "Dragon Rush", "Giga Impact" } } }
  },

  -- Gen V
  -- Gym Leaders
  {
    guid = "4ad822",
    trainerName = "Cheren",
    pokemon = {
      { name = "Patrat",   level = 2, types = { "Normal" }, moves = { "Work Up", "Tackle", "Bite" } },
      { name = "Lillipup", level = 2, types = { "Normal" }, moves = { "Work Up", "Quick Attack", "Bite" } } }
  },
  {
    guid = "f01b5f",
    trainerName = "Roxie",
    pokemon = {
      { name = "Koffing",    level = 3, types = { "Poison" }, moves = { "Smog", "Tackle", "Assurance" } },
      { name = "Whirlipede", level = 3, types = { "Bug" },    moves = { "Venoshock", "Protect", "Pursuit" } } }
  },
  {
    guid = "d5fe45",
    trainerName = "Burgh",
    pokemon = {
      { name = "Dwebble",  level = 3, types = { "Bug" }, moves = { "Sand Attack", "Struggle Bug", "Feint Attack" } },
      { name = "Leavanny", level = 4, types = { "Bug" }, moves = { "Grass Whistle", "Struggle Bug", "Razor Leaf" } } }
  },
  {
    guid = "098cee",
    trainerName = "Elesa",
    pokemon = {
      { name = "Emolga",    level = 4, types = { "Electric" }, moves = { "Thunder Wave", "Pursuit", "Spark" } },
      { name = "Zebstrika", level = 4, types = { "Electric" }, moves = { "Take Down", "Pursuit", "Shock Wave" } } }
  },
  {
    guid = "de22b0",
    trainerName = "Clay",
    pokemon = {
      { name = "Krokorok",  level = 5, types = { "Ground" }, moves = { "Swagger", "Sand Tomb", "Crunch" } },
      { name = "Excadrill", level = 6, types = { "Ground" }, moves = { "Slash", "Bulldoze", "Metal Claw" } } }
  },
  {
    guid = "22f826",
    trainerName = "Skyla",
    pokemon = {
      { name = "Swoobat", level = 5, types = { "Psychic" }, moves = { "Amnesia", "Assurance", "Heart Stamp" } },
      { name = "Swanna",  level = 6, types = { "Water" },   moves = { "Feather Dance", "Bubble Beam", "Air Slash" } } }
  },
  {
    guid = "9414b7",
    trainerName = "Drayden",
    pokemon = {
      { name = "Druddigon", level = 7, types = { "Dragon" }, moves = { "Crunch", "Slash", "Revenge" } },
      { name = "Haxorus",   level = 7, types = { "Dragon" }, moves = { "Night Slash", "Slash", "Dragon Tail" } } }
  },
  {
    guid = "052a06",
    trainerName = "Marlon",
    pokemon = {
      { name = "Carracosta", level = 7, types = { "Water" }, moves = { "Shell Smash", "Rock Slide", "Scald" } },
      { name = "Jellicent",  level = 7, types = { "Water" }, moves = { "Ominous Wind", "Brine", "Scald" } } }
  },

  -- Elite Four
  {
    guid = "254e2b",
    trainerName = "Shauntal",
    pokemon = {
      { name = "Golurk",     level = 8, types = { "Ground" }, moves = { "Brick Break", "Shadow Punch", "Earthquake" } },
      { name = "Chandelure", level = 9, types = { "Ghost" },  moves = { "Psychic", "Shadow Ball", "Fire Blast" } } }
  },
  {
    guid = "9bec87",
    trainerName = "Marshal",
    pokemon = {
      { name = "Mienshao",   level = 8, types = { "Fighting" }, moves = { "Rock Slide", "Bounce", "High Jump Kick" } },
      { name = "Conkeldurr", level = 9, types = { "Fighting" }, moves = { "Stone Edge", "Hammer Arm", "Close Combat" } } }
  },
  {
    guid = "1aa293",
    trainerName = "Grimsley",
    pokemon = {
      { name = "Scrafty", level = 8, types = { "Dark" }, moves = { "Poison Jab", "Brick Break", "Crunch" } },
      { name = "Bisharp", level = 9, types = { "Dark" }, moves = { "Metal Claw", "Aerial Ace", "Night Slash" } } }
  },
  {
    guid = "d181f2",
    trainerName = "Caitlin",
    pokemon = {
      { name = "Sigilyph",   level = 8, types = { "Psychic" }, moves = { "Ice Beam", "Air Slash", "Psychic" } },
      { name = "Gothitelle", level = 9, types = { "Psychic" }, moves = { "Thunderbolt", "Shadow Ball", "Psychic" } } }
  },
  -- Champion
  {
    guid = "c17cfd",
    trainerName = "Iris",
    pokemon = {
      { name = "Hydreigon", level = 9,  types = { "Dark" },   moves = { "Flamethrower", "Focus Blast", "Dragon Pulse" } },
      { name = "Druddigon", level = 10, types = { "Dragon" }, moves = { "Thunder Punch", "Focus Blast", "Dragon Tail" } } }
  },
  {
    guid = "9d2a12",
    trainerName = "Iris",
    pokemon = {
      { name = "Archeops", level = 9,  types = { "Rock" },   moves = { "Dragon Claw", "Stone Edge", "Air Slash" } },
      { name = "Haxorus",  level = 10, types = { "Dragon" }, moves = { "Dual Chop", "Slash", "Outrage" } } }
  },
  {
    guid = "346c48",
    trainerName = "Alder",
    pokemon = {
      { name = "Bouffalant", level = 9,  types = { "Normal" }, moves = { "Stone Edge", "Megahorn", "Head Charge" } },
      { name = "Volcarona",  level = 10, types = { "Bug" },    moves = { "Overheat", "Bug Buzz", "Hyper Beam" } } }
  },

  -- Gen VI
  -- Gym Leaders
  {
    guid = "c49242",
    trainerName = "Viola",
    pokemon = {
      { name = "Surskit", level = 2, types = { "Bug" }, moves = { "Quick Attack", "Bubble", "Infestation" } },
      { name = "Vivillon", level = 2, types = { "Bug" }, moves = { "Harden", "Gust", "Infestation" } } }
  },
  {
    guid = "c3ba0b",
    trainerName = "Grant",
    pokemon = {
      { name = "Amaura", level = 3, types = { "Rock" }, moves = { "Thunder Wave", "Take Down", "Rock Tomb" } },
      { name = "Tyrunt", level = 3, types = { "Rock" }, moves = { "Bite", "Stomp", "Rock Tomb" } } }
  },
  {
    guid = "75edd9",
    trainerName = "Korrina",
    pokemon = {
        { name = "Hawlucha", level = 3, types = { "Fighting" }, moves = { "Hone Claws", "Wing Attack", "Flying Press" } },
        { name = "Lucario", level = 4, types = { "Fighting" }, moves = { "Metal Sound", "Bone Rush", "Power-Up Punch" } } }
  },
  {
    guid = "ba6bd1",
    trainerName = "Ramos",
    pokemon = {
      { name = "Weepinbell", level = 4, types = { "Grass" }, moves = { "Poison Powder", "Acid", "Grass Knot" } },
      { name = "Gogoat", level = 4, types = { "Grass" }, moves = { "Bulldoze", "Take Down", "Razor Leaf" } } }
  },
  {
    guid = "170341",
    trainerName = "Clemont",
    pokemon = {
      { name = "Magneton", level = 5, types = { "Electric" }, moves = { "Tri Attack", "Mirror Shot", "Thunderbolt" } },
      { name = "Heliolisk", level = 6, types = { "Electric" }, moves = { "Dark Pulse", "Focus Blast", "Thunderbolt" } } }
  },
  {
    guid = "ecfb59",
    trainerName = "Valerie",
    pokemon = {
      { name = "Mawile", level = 5, types = { "Steel" }, moves = { "Iron Defense", "Crunch", "Play Rough" } },
      { name = "Sylveon", level = 6, types = { "Fairy" }, moves = { "Charm", "Swift", "Dazzling Gleam" } } }
  },
  {
    guid = "3e6766",
    trainerName = "Olympia",
    pokemon = {
      { name = "Slowking", level = 7, types = { "Water" }, moves = { "Calm Mind", "Power Gem", "Psychic" } },
      { name = "Meowstic", level = 7, types = { "Psychic" }, moves = { "Calm Mind", "Shadow Ball", "Psychic" } } }
  },
  {
    guid = "f47073",
    trainerName = "Wulfric",
    pokemon = {
      { name = "Cryogonal",level = 7, types = { "Ice" }, moves = { "Confuse Ray", "Flash Cannon", "Ice Beam" } },
      { name = "Avalugg",  level = 7, types = { "Ice" }, moves = { "Crunch", "Iron Defense", "Avalanche" } } }
  },

  -- Elite Four
  {
    guid = "970078",
    trainerName = "Wikstrom",
    pokemon = {
      { name = "Klefki", level = 8, types = { "Steel" }, moves = { "Spikes", "Dazzling Gleam", "Flash Cannon" } },
      { name = "Aegislash", level = 9, types = { "Steel" }, moves = { "Shadow Claw", "Sacred Sword", "Iron Head" } } }
  },
  {
    guid = "dfa5a5",
    trainerName = "Siebold",
    pokemon = {
      { name = "Clawitzer",  level = 8, types = { "Water" }, moves = { "Dark Pulse", "Aura Sphere", "Water Pulse" } },
      { name = "Barbaracle", level = 9, types = { "Rock" }, moves = { "Stone Edge", "Cross Chop", "Razor Shell" } } }
  },
  {
    guid = "3c4256",
    trainerName = "Drasna",
    pokemon = {
      { name = "Dragalge", level = 8, types = { "Poison" }, moves = { "Surf", "Sludge Bomb", "Dragon Pulse" } },
      { name = "Noivern", level = 9, types = { "Flying" }, moves = { "Super Fang", "Air Slash", "Dragon Pulse" } } }
  },
  {
    guid = "c4d767",
    trainerName = "Malva",
    pokemon = {
      { name = "Pyroar", level = 8, types = { "Fire" }, moves = { "Noble Roar", "Wild Charge", "Flamethrower" } },
      { name = "Talonflame",  level = 9, types = { "Fire" }, moves = { "Steel Wing", "Brave Bird", "Flare Blitz" } } }
  },
  -- Champion
  {
    guid = "a20a02",
    trainerName = "Diantha",
    pokemon = {
      { name = "Goodra", level = 9, types = { "Dragon" }, moves = { "Muddy Water", "Fire Blast", "Dragon Pulse" } },
      { name = "Gardevoir", level = 10, types = { "Psychic" }, moves = { "Shadow Ball", "Psychic", "Moonblast" } } }
  },
  {
    guid = "4e871f",
    trainerName = "Diantha",
    pokemon = {
      { name = "Gourgeist", level = 9, types = { "Ghost" }, moves = { "Shadow Sneak", "Phantom Force", "Seed Bomb" } },
      { name = "Aurorus", level = 10, types = { "Rock" }, moves = { "Reflect", "Thunder", "Blizzard" } } }
  },
  {
    guid = "e9ea83",
    trainerName = "Diantha",
    pokemon = {
      { name = "Hawlucha", level = 9, types = { "Fighting" }, moves = { "Swords Dance", "Poison Jab", "Flying Press" } },
      { name = "Tyrantrum", level = 10, types = { "Rock" }, moves = { "Crunch", "Dragon Claw", "Head Smash" } } }
  },

  -- Gen VII
  -- Gym Leaders
  {
    guid = "9d2d79",
    trainerName = "Totem",
    gen = 7,
    gymTier = 1,
    pokemon = {
      { name = "Yungoos", level = 2, types = { "Normal" }, moves = { "Super Fang", "Sand Attack", "Bite" } },
      { name = "Gumshoos", level = 2, types = { "Normal" }, moves = { "Hyper Fang", "Sand Attack", "Bite" } } }
  },
  {
    guid = "18bfc2",
    trainerName = "Totem",
    gen = 7,
    gymTier = 1,
    pokemon = {
      { name = "Rattata", level = 2, types = { "Dark" }, moves = { "Tail Whip", "Tackle", "Bite" } },
      { name = "Raticate", level = 2, types = { "Dark" }, moves = { "Tail Whip", "Quick Attack", "Bite" } } }
  },
  {
    guid = "bc4cea",
    trainerName = "Hala",
    gen = 7,
    gymTier = 2,
    pokemon = {
        { name = "Makuhita", level = 3, types = { "Fighting" }, moves = { "Fake Out", "Sand Attack", "Arm Thrust" } },
        { name = "Crabrawler", level = 3, types = { "Fighting" }, moves = { "Leer", "Pursuit", "Power-Up Punch" } } }
  },
  {
    guid = "f67255",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Salazzle", level = 3, types = { "Poison" }, moves = { "Poison Fang", "Ember", "Nasty Plot" } },
      { name = "Marowak", level = 4, types = { "Fire" }, moves = { "Bonemerang", "Flame Wheel", "Shadow Bone" } } }
  },
  {
    guid = "2abaeb",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Comfey", level = 3, types = { "Fairy" }, moves = { "Growth", "Grass Knot", "Draining Kiss" } },
      { name = "Lurantis", level = 4, types = { "Grass" }, moves = { "X-Scissor", "Leaf Blade", "Night Slash" } } }
  },
  {
    guid = "dd267b",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Salandit", level = 3, types = { "Poison" }, moves = { "Smog", "Ember", "Dragon Pulse" } },
      { name = "Salazzle", level = 4, types = { "Poison" }, moves = { "Smog", "Flamethrower", "Swagger" } } }
  },
  {
    guid = "913644",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Masquerain", level = 3, types = { "Bug" }, moves = { "Bug Buzz", "Ominous Wind", "Gust" } },
      { name = "Araquanid", level = 4, types = { "Water" }, moves = { "Infestation", "Crunch", "Bubble Beam" } } }
  },
  {
    guid = "b09f56",
    trainerName = "Totem",
    gen = 7,
    gymTier = 3,
    pokemon = {
      { name = "Alomomola", level = 3, types = { "Water" }, moves = { "Protect", "Double Slap", "Brine" } },
      { name = "Wishiwashi", level = 4, types = { "Water" }, moves = { "Take Down", "Feint Attack", "Brine" } } }
  },
  {
    guid = "294927",
    trainerName = "Olivia",
    gen = 7,
    gymTier = 4,
    pokemon = {
      { name = "Boldore", level = 4, types = { "Rock" }, moves = { "Mud-Slap", "Headbutt", "Rock Blast" } },
      { name = "Lycanroc", level = 4, types = { "Rock" }, moves = { "Bite", "Rock Throw", "Stone Edge" } } }
  },
  {
    guid = "59c455",
    trainerName = "Totem",
    gen = 7,
    gymTier = 5,
    pokemon = {
      { name = "Banette", level = 5, types = { "Ghost" }, moves = { "Will-O-Wisp", "Sucker Punch", "Phantom Force" } },
      { name = "Mimikyu", level = 6, types = { "Ghost" }, moves = { "Charm", "Wood Hammer", "Shadow Claw" } } }
  },
  {
    guid = "890b4e",
    trainerName = "Totem",
    gen = 7,
    gymTier = 5,
    pokemon = {
      { name = "Dedenne", level = 5, types = { "Electric" }, moves = { "Charm", "Charge Beam", "Play Rough" } },
      { name = "Togedemaru", level = 6, types = { "Electric" }, moves = { "Rollout", "Charge Beam", "Zing Zap" } } }
  },
  {
    guid = "922673",
    trainerName = "Totem",
    gen = 7,
    gymTier = 5,
    pokemon = {
      { name = "Charjabug", level = 5, types = { "Bug" }, moves = { "Iron Defense", "Bug Bite", "Spark" } },
      { name = "Vikavolt", level = 6, types = { "Bug" }, moves = { "Air Slash", "Bug Buzz", "Thunderbolt" } } }
  },
  {
    guid = "75f2f1",
    trainerName = "Nanu",
    gen = 7,
    gymTier = 6,
    pokemon = {
      { name = "Krokorok", level = 5, types = { "Ground" }, moves = { "Swagger", "Earthquake", "Crunch" } },
      { name = "Persian", level = 6, types = { "Dark" }, moves = { "Slash", "Power Gem", "Dark Pulse" } } }
  },
  {
    guid = "d0c8e0",
    trainerName = "Totem",
    gen = 7,
    gymTier = 7,
    pokemon = {
      { name = "Hakammo-o", level = 7, types = { "Dragon" }, moves = { "Noble Roar", "Dragon Claw", "Sky Uppercut" } },
      { name = "Kommo-o", level = 7, types = { "Dragon" }, moves = { "Noble Roar", "Dragon Tail", "Close Combat" } } }
  },
  {
    guid = "b74bcc",
    trainerName = "Totem",
    gen = 7,
    gymTier = 7,
    pokemon = {
      { name = "Blissy", level = 7, types = { "Normal" }, moves = { "Light Screen", "Egg Bomb", "Double-Edge" } },
      { name = "Ribombee", level = 7, types = { "Bug" }, moves = { "Struggle Bug", "Dazzling Gleam", "Silver Wind" } } }
  },
  {
    guid = "8baab3",
    trainerName = "Hapu",
    gen = 7,
    gymTier = 8,
    pokemon = {
      { name = "Flygon", level = 7, types = { "Ground" }, moves = { "Dragon Breath", "Rock Slide", "Earth Power" } },
      { name = "Mudsdale", level = 7, types = { "Ground" }, moves = { "Counter", "Heavy Slam", "Earthquake" } } }
   },
  
  -- Elite Four
  {
    guid = "7c12f8",
    trainerName = "Olivia",
    pokemon = {
      { name = "Probopass", level = 8, types = { "Rock" }, moves = { "Power Gem", "Thunder Wave", "Earth Power" } },
      { name = "Lycanroc", level = 9, types = { "Rock" }, moves = { "Stone Edge", "Counter", "Rock Climb" } } }
  },
  {
    guid = "c34329",
    trainerName = "Molayne",
    pokemon = {
      { name = "Metagross",  level = 8, types = { "Steel" }, moves = { "Hammer Arm", "Meteor Mash", "Zen Headbutt" } },
      { name = "Dugtrio", level = 9, types = { "Ground" }, moves = { "Stone Edge", "Iron Head", "Earthquake" } } }
  },
  {
    guid = "504061",
    trainerName = "Kahili",
    pokemon = {
      { name = "Oricorio", level = 8, types = { "Fire" }, moves = { "Teeter Dance", "Air Slash", "Rev. Dance Fire" } },
      { name = "Toucannon", level = 9, types = { "Flying" }, moves = { "Hyper Voice", "Aerial Ace", "Flash Cannon" } } }
  },
  {
    guid = "b9bd0e",
    trainerName = "Acerola",
    pokemon = {
      { name = "Dhelmise", level = 8, types = { "Ghost" }, moves = { "Slam", "Energy Ball", "Shadow Ball" } },
      { name = "Palossand",  level = 9, types = { "Ghost" }, moves = { "Iron Defense", "Earth Power", "Shadow Ball" } } }
  },
  -- Champion
  {
    guid = "94f594",
    trainerName = "Kukui",
    pokemon = {
      { name = "Ninetales", level = 9, types = { "Ice" }, moves = { "Dazzling Gleam", "Ice Shard", "Blizzard" } },
      { name = "Primarina", level = 10, types = { "Water" }, moves = { "Captivate", "Sparkling Aria", "Moonblast" } } }
  },
  {
    guid = "7faa66",
    trainerName = "Kukui",
    pokemon = {
      { name = "Lycanroc", level = 9, types = { "Rock" }, moves = { "Crunch", "Accelerock", "Stone Edge" } },
      { name = "Incineroar", level = 10, types = { "Fire" }, moves = { "Darkest Lariat", "Cross Chop", "Flare Blitz" } } }
  },
  {
    guid = "12326f",
    trainerName = "Hau",
    pokemon = {
      { name = "Raichu", level = 9, types = { "Electric" }, moves = { "Thunderbolt", "Psychic", "Focus Blast" } },
      { name = "Decidueye", level = 10, types = { "Grass" }, moves = { "Nasty Plot", "Spirit Shackle", "Leaf Blade" } } }
  },

  -- Gen VIII
  -- Gym Leaders
  {
    guid = "182d74",
    trainerName = "Milo",
    gen = 8,
    gymTier = 1,
    pokemon = {
      { name = "Gossifleur", level = 2, types = { "Grass" }, moves = { "Tackle", "Rapid Spin", "Magical Leaf" } },
      { name = "Eldegoss", level = 2, types = { "Grass" }, moves = { "Tackle", "Leafage", "Magical Leaf" } } }
  },
  {
    guid = "c087f9",
    trainerName = "Nessa",
    gen = 8,
    gymTier = 2,
    pokemon = {
      { name = "Arrokuda", level = 3, types = { "Water" }, moves = { "Fury Attack", "Bite", "Aqua Jet" } },
      { name = "Drednaw", level = 3, types = { "Water" }, moves = { "Headbutt", "Bite", "Razor Shell" } } }
  },
  {
    guid = "08b1a8",
    trainerName = "Kabu",
    gen = 8,
    gymTier = 3,
    pokemon = {
      { name = "Arcanine", level = 3, types = { "Fire" }, moves = { "Will-O-Wisp", "Bite", "Flame Wheel" } },
      { name = "Centiskorch", level = 4, types = { "Fire" }, moves = { "Coil", "Bug Bite", "Flame Wheel" } } }
  },
  {
    guid = "4f251c",
    trainerName = "Bea",
    gen = 8,
    gymTier = 4,
    pokemon = {
        { name = "Sirfetch'd", level = 4, types = { "Fighting" }, moves = { "Detect", "Brutal Swing", "Revenge" } },
        { name = "Machamp", level = 4, types = { "Fighting" }, moves = { "Strength", "Knock Off", "Revenge" } } }
  },
  {
    guid = "cad1a8",
    trainerName = "Allister",
    gen = 8,
    gymTier = 4,
    pokemon = {
        { name = "Cursola", level = 4, types = { "Ghost" }, moves = { "Curse", "Ancient Power", "Hex" } },
        { name = "Gengar", level = 4, types = { "Ghost" }, moves = { "Hypnosis", "Venoshock", "Hex" } } }
  },
  {
    guid = "7749a1",
    trainerName = "Opal",
    gen = 8,
    gymTier = 5,
    pokemon = {
      { name = "Weezing", level = 5, types = { "Poison" }, moves = { "Fairy Wind", "Sludge", "Strange Steam" } },
      { name = "Alcremie", level = 5, types = { "Fairy" }, moves = { "Sweet Kiss", "Acid Armor", "Draining Kiss" } } }
  },
  {
    guid = "3ec0f8",
    trainerName = "Melony",
    gen = 8,
    gymTier = 6,
    pokemon = {
      { name = "Darmanitan", level = 5, types = { "Ice" }, moves = { "Icicle Crash", "Fire Fang", "Headbutt" } },
      { name = "Lapras", level = 6, types = { "Water" }, moves = { "Ice Beam", "Surf", "Sing" } } }
  },
  {
    guid = "889940",
    trainerName = "Gordie",
    gen = 8,
    gymTier = 6,
    pokemon = {
      { name = "Stonjourner", level = 5, types = { "Rock" }, moves = { "Stealth Rock", "Body Slam", "Rock Tomb" } },
      { name = "Coalossal", level = 5, types = { "Rock" }, moves = { "Rock Blast", "Heat Crash", "Rock Tomb" } } }
  },
  {
    guid = "519731",
    trainerName = "Piers",
    gen = 8,
    gymTier = 7,
    pokemon = {
      { name = "Skuntank", level = 7, types = { "Poison" }, moves = { "Screech", "Sucker Punch", "Snarl" } },
      { name = "Obstagoon", level = 7, types = { "Dark" }, moves = { "Counter", "Shadow Claw", "Throat Chop" } } }
  },
  {
    guid = "1752ad",
    trainerName = "Raihan",
    gen = 8,
    gymTier = 8,
    pokemon = {
      { name = "Sandaconda", level = 7, types = { "Ground" }, moves = { "Protect", "Fire Fang", "Earth Power" } },
      { name = "Duraludon", level = 7, types = { "Steel" }, moves = { "Stone Edge", "Iron Head", "Breaking Swipe" } } }
  },

  -- Elite Four
  {
    guid = "5c28d7",
    trainerName = "Hop",
    pokemon = {
      { name = "Corviknight", level = 8, types = { "Flying" }, moves = { "Light Screen", "Steel Wing", "Drill Peck" } },
      { name = "Zacian", level = 9, types = { "Fairy" }, moves = { "Swords Dance", "Behemoth Bash", "Play Rough" } } }
  },
  {
    guid = "cb76dc",
    trainerName = "Marnie",
    pokemon = {
      { name = "Morpeko",  level = 8, types = { "Electric" }, moves = { "Seed Bomb", "Bite", "Aura Wheel Electric" } },
      { name = "Grimmsnarl", level = 9, types = { "Dark" }, moves = { "Spirit Break", "Darkest Lariat", "Play Rough" } } }
  },
  {
    guid = "6af720",
    trainerName = "Hop",
    pokemon = {
      { name = "Dubwool", level = 8, types = { "Normal" }, moves = { "Zen Headbutt", "Headbutt", "Double-Edge" } },
      { name = "Zamazenta", level = 9, types = { "Fighting" }, moves = { "Iron Defense", "Behemoth Bash", "Close Combat" } } }
  },
  {
    guid = "7ed3ee",
    trainerName = "Bede",
    pokemon = {
      { name = "Rapidash", level = 8, types = { "Psychic" }, moves = { "Smart Strike", "Zen Headbutt", "Dazzling Gleam" } },
      { name = "Hatterene",  level = 9, types = { "Psychic" }, moves = { "Dark Pulse", "Psychic", "Dazzling Gleam" } } }
  },
  -- Champion
  {
    guid = "cf8621",
    trainerName = "Leon",
    pokemon = {
      { name = "Cinderace", level = 9, types = { "Fire" }, moves = { "Bounce", "Flame Charge", "Pyro Ball" } },
      { name = "Aegislash", level = 10, types = { "Steel" }, moves = { "Sacred Sword", "Shadow Ball", "Flash Cannon" } } }
  },
  {
    guid = "cbea60",
    trainerName = "Leon",
    pokemon = {
      { name = "Rillaboom", level = 9, types = { "Grass" }, moves = { "Knock Off", "Razor Leaf", "Drum Beating" } },
      { name = "Dragapult", level = 10, types = { "Dragon" }, moves = { "Dragon Darts", "Shadow Ball", "Dragon Breath" } } }
  },
  {
    guid = "f0b4c9",
    trainerName = "Leon",
    pokemon = {
      { name = "Inteleon", level = 9, types = { "Water" }, moves = { "Tearful Look", "Liquidation", "Snipe Shot" } },
      { name = "Charizard", level = 10, types = { "Fire" }, moves = { "Ancient Power", "Air Slash", "Fire Blast" } } }
  },

  -- Gen IX
  -- Gym Leaders
  {
    guid = "45dc59",
    trainerName = "Katy",
    pokemon = {
      { name = "Tarountula",level = 2, types = { "Bug"}, moves = { "Tackle", "Assurance", "Bug Bite" } },
      { name = "Teddiursa", level = 2, types = { "Bug" }, moves = { "Scratch", "Fury Swipes", "Fury Cutter" } } }
  },
  {
    guid = "ad920b",
    trainerName = "Brassius",
    pokemon = {
      { name = "Smoliv",  level = 3, types = { "Grass"},           moves = { "Tackle", "Growth", "Razor Leaf" } },
      { name = "Sudowoodo", level = 3, types = { "Grass" }, moves = { "Counter", "Rock Throw", "Trailblaze" } } }
  },
  {
    guid = "7875a3",
    trainerName = "Iono",
    pokemon = {
      { name = "Bellibolt", level = 3, types = { "Electric" },  moves = { "Water Gun", "Mud-Slap", "Spark" } },
      { name = "Mismagius",  level = 4, types = { "Electric" }, moves = { "Confuse Ray", "Hex", "Spark" } } }
  },
  {
    guid = "68208c",
    trainerName = "Kofu",
    pokemon = {
      { name = "Wugtrio", level = 4, types = { "Water" }, moves = { "Headbutt", "Mud-Slap", "Water Pulse" } },
      { name = "Crabominable",  level = 4, types = { "Water" }, moves = { "Slam", "Rock Smash", "Crabhammer" } } }
  },
  {
    guid = "51d9fc",
    trainerName = "Larry",
    pokemon = {
      { name = "Dudunsparce",  level = 5, types = { "Normal" },          moves = { "Glare", "Drill Run", "Hyper Drill" } },
      { name = "Staraptor", level = 6, types = { "Normal" }, moves = { "Close Combat", "Aerial Ace", "Facade" } } }
  },
  {
    guid = "e99877",
    trainerName = "Ryme",
    pokemon = {
      { name = "Houndstone", level = 5, types = { "Ghost" }, moves = { "Play Rough", "Crunch", "Phantom Force" } },
      { name = "Ghost",   level = 6, types = { "Ghost" },   moves = { "Hyper Voice", "Discharge", "Hex" } } }
  },
  {
    guid = "8a4bc5",
    trainerName = "Tulip",
    pokemon = {
      { name = "Farigiraf",   level = 7, types = { "Normal" },  moves = { "Stomp", "Zen Headbutt", "Crunch" } },
      { name = "Florges", level = 7, types = { "Psychic" }, moves = { "Moonblast", "Psychic", "Petal Blizzard" } } }
  },
  {
    guid = "808b43",
    trainerName = "Grusha",
    pokemon = {
      { name = "Cetitan", level = 7, types = { "Ice" },          moves = { "Double-Edge", "Liquidation", "Ice Shard" } },
      { name = "Altaria",   level = 7, types = { "Ice" }, moves = { "Dragon Pulse", "Hurricane", "Ice Beam" } } }
  },

  -- Elite Four + champion
  {
    guid = "47ed30",
    trainerName = "Larry",
    pokemon = {
      { name = "Tropius", level = 8, types = { "Grass" },    moves = { "Dragon Pulse", "Solar Beam", "Air Slash" } },
      { name = "Flamigo", level = 9, types = { "Flying" }, moves = { "Liquidation", "Close Combat", "Brave Bird" } } }
  },
  {
    guid = "7b612c",
    trainerName = "Hassel",
    pokemon = {
      { name = "Flapple",     level = 8, types = { "Grass" }, moves = { "Seed Bomb", "Dragon Rush", "Aerial Ace" } },
      { name = "Braxcalibur", level = 9, types = { "Dragon" },     moves = { "Brick Break", "Glaive Rush", "Icicle Crash" } } }
  },
  {
    guid = "e625ec",
    trainerName = "Rika",
    pokemon = {
      { name = "Camerupt", level = 8, types = { "Fire" }, moves = { "Flash Cannon", "Earth Power", "Fire Blast" } },
      { name = "Clodsire",   level = 9, types = { "Ground" }, moves = { "Protect", "Earthquake", "Poison Jab" } } }
  },
  {
    guid = "49c164",
    trainerName = "Poppy",
    pokemon = {
      { name = "Corviknight",  level = 8, types = { "Flying" },         moves = { "Body Press", "Iron Head", "Brave Bird" } },
      { name = "Tinkaton", level = 9, types = { "Steel"}, moves = { "Play Rough", "Gigaton Hammer", "Stone Edge" } } }
  },
  {
    guid = "d2e704",
    trainerName = "Geeta",
    pokemon = {
      { name = "Avalugg", level = 9,  types = { "Ice" }, moves = { "Earthquake", "Crunch", "Avalanche" } },
      { name = "Veluza", level = 10, types = { "Water" },   moves = { "Psycho Cut", "Liquidation", "Ice Fang" } } }
  },
  {
    guid = "971eca",
    trainerName = "Geeta",
    pokemon = {
      { name = "Gogoat",  level = 9,  types = { "Grass" }, moves = { "Zen Headbutt", "Bulk Up", "Horn Leech" } },
      { name = "Kingambit", level = 10, types = { "Dark" }, moves = { "Stone Edge", "Kowtow Cleave", "Iron Head" } } }
  },
  {
    guid = "275bc9",
    trainerName = "Geeta",
    pokemon = {
      { name = "Espathra",  level = 9,  types = { "Psychic" },  moves = { "Lumina Crash", "Dazzling Gleam", "Feather Dance" } },
      { name = "Glimmora", level = 10, types = { "Rock" }, moves = { "Tera Blast", "Sludge Wave", "Earth Power" } } }
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
  { guid = "359a56", move = "Aerial Ace" },  
  { guid = "5b8981", move = "Attract" },
  { guid = "a04888", move = "Blizzard" },
  { guid = "67cf83", move = "Body Slam" },
  { guid = "4cae29", move = "Brick Break" },
  { guid = "1d4d83", move = "Bubble Beam" },
  { guid = "625682", move = "Bullet Seed" },
  { guid = "a1d00f", move = "Bulk Up" },
  { guid = "c0dd30", move = "Calm Mind" },
  { guid = "2f2184", move = "Counter" },
  { guid = "6a0215", move = "Detect" },
  { guid = "923a11", move = "Dig" },
  { guid = "375a97", move = "Double-Edge" },
  { guid = "b40de0", move = "Double Team" },
  { guid = "ebda3e", move = "Dragon Breath" },
  { guid = "c51f03", move = "Dragon Claw" },
  { guid = "7fc16e", move = "Dragon Rage" },
  { guid = "5884d5", move = "Dream Eater" },
  { guid = "589820", move = "Earthquake" },
  { guid = "979837", move = "Egg Bomb" },
  { guid = "d367c3", move = "Explosion" },
  { guid = "a37980", move = "Facade" },
  { guid = "b01bc8", move = "Fissure" },
  { guid = "5f1dfa", move = "Fire Blast" },
  { guid = "799228", move = "Fire Punch" },
  { guid = "0f9ebe", move = "Flamethrower" },
  { guid = "763873", move = "Focus Punch" },
  { guid = "e8b6dd", move = "Giga Drain" },
  { guid = "8bf926", move = "Headbutt" },
  { guid = "a6457a", move = "Hidden Power" },
  { guid = "f52e5b", move = "Horn Drill" },
  { guid = "e6f314", move = "Hyper Beam" },
  { guid = "632af0", move = "Ice Beam" },
  { guid = "b80e18", move = "Ice Punch" },
  { guid = "2f1c01", move = "Icy Wind" },
  { guid = "b54b26", move = "Iron Tail" },
  { guid = "0c0649", move = "Light Screen" },
  { guid = "171be0", move = "Mega Drain" },
  { guid = "8cafd6", move = "Mega Kick" },
  { guid = "6da38d", move = "Mega Punch" },
  { guid = "034664", move = "Metronome" },
  { guid = "28d66f", move = "Mimic" },
  { guid = "171693", move = "Mud-Slap" },
  { guid = "69a698", move = "Overheat" },
  { guid = "cd5ec1", move = "Pay Day" },
  { guid = "60cdbe", move = "Protect" },
  { guid = "ee0804", move = "Psychic" },
  { guid = "daa9df", move = "Psywave" },
  { guid = "a293ff", move = "Rage" },
  { guid = "ddadad", move = "Razor Wind" },
  { guid = "42d14b", move = "Reflect" },
  { guid = "a1c9d5", move = "Roar" },
  { guid = "79d996", move = "Rock Slide" },
  { guid = "f8df98", move = "Rock Tomb" },
  { guid = "4c7f77", move = "Safeguard" },
  { guid = "89e169", move = "Secret Power" },
  { guid = "b80fe2", move = "Seismic Toss" },
  { guid = "be622c", move = "Self-Destruct" },
  { guid = "4e39c9", move = "Shock Wave" },
  { guid = "2f2fe7", move = "Shadow Ball" },
  { guid = "c68f39", move = "Skull Bash" },
  { guid = "2722b5", move = "Sky Attack" },
  { guid = "6452f8", move = "Sludge Bomb" },
  { guid = "435fa1", move = "Snatch" },
  { guid = "789ef1", move = "Snore" },
  { guid = "3d1471", move = "Solar Beam" },
  { guid = "fd548b", move = "Steel Wing" },
  { guid = "957e05", move = "Submission" },
  { guid = "1a1cf7", move = "Swift" },
  { guid = "350919", move = "Swords Dance" },
  { guid = "d6b5f1", move = "Take Down" },
  { guid = "e3d82f", move = "Taunt" },
  { guid = "18e489", move = "Teleport" },
  { guid = "999325", move = "Thief" },
  { guid = "89a0fa", move = "Thunder" },
  { guid = "dfb8f7", move = "Thunderbolt" },
  { guid = "e66c72", move = "Thunder Punch" },
  { guid = "f50cf9", move = "Thunder Wave" },
  { guid = "287692", move = "Torment" },
  { guid = "5afe6d", move = "Toxic" },
  { guid = "bf5f6e", move = "Tri Attack" },
  { guid = "51d612", move = "Water Gun" },
  { guid = "1d4fed", move = "Water Pulse" },
  { guid = "a3034c", move = "Whirlwind" },
  { guid = "0a6b86", move = "Zap Cannon" },
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
  local data
  for i = 1, #selectedGens do
    --printToAll("TEMP | serching Gen " .. i .. " for GUID: " .. params.guid)
    if selectedGens[i] then
      data = getPokemonData(genData[i], params.guid)
      if data != nil then
        return data
      end
    end
  end
  if customGen then
    --print("Searching custom data for GUID")
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
  print("No Pokémon Data Found for GUID: " .. params.guid)
end

function GetAnyPokemonDataByGUID(params)
  for i = 1, #selectedGens do
    local data = getPokemonData(genData[i], params.guid)
    if data != nil then
      return data
    end
  end
  print("No Pokémon Name Found for GUID: " .. params.guid)
end

function GetPokemonDataByName(params)
  local data
  for i = 1, #selectedGens do
    if selectedGens[i] then
      --print("Searching Gen " .. i .. " data for GUID")
      data = getPokemonDataName(genData[i], params.name)
      if data != nil then
        return data
      end
    end
  end
  if customGen then
    --print("Searching custom data for Name")
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
  print("No Pokémon Data Found")
end

function getPokemonData(pokemonList, guid)
  for i = 1, #pokemonList do
    local data = pokemonList[i]
    local guids = data.guids
    for j = 1, #guids do
      if guids[j] == guid then
        --print("Found Pokémon Data")
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
      --print("Found Pokémon Data")
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
    local guid = data.guid
    if guid == params.guid then
      return data
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

function GetTmDataByGUID(params)
  for i = 1, #tmData do
    local data = tmData[i]
    local guid = data.guid
    if guid == params then
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
-- gym data without  the genn and gymTier attributes the return table will just be an empty {}.
function FilterGymDataOnTier(gen, tier)
  if gymData == nil then return {} end

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
-- gen argument:
--    gyms  : 1-8
--    elite4: 9
--    rival : 10
--    TR    : 11
function RandomGymGuidOfTier(params)
  if gymData == nil then return 0 end

  local new_list = FilterGymDataOnTier(params.gen, params.tier)
  if #new_list > 0 then
    return new_list[math.random(#new_list)].guid
  end

  local gymStringTable =
  {
    [0] = params.tier,
    [1] = params.tier,
    [2] = params.tier,
    [3] = params.tier,
    [4] = params.tier,
    [5] = params.tier,
    [6] = params.tier,
    [7] = params.tier,
    [8] = params.tier,
    [9] = "Elite 4",
    [10] = "Rival",
    [11] = "Team Rocket",
  }


  local gymString = gymStringTable[params.tier]
  printToAll("Failed to find gym leader options for gen " .. tostring(params.gen) .. ", tier " .. tostring(gymString))
  return 0
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  SETUP
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function start(player, value, id)
  MusicPlayer.setPlaylist(playlist)
end

function ShowSettingsPopup()
  UI.show('Settings')
end

function closeSettings(player, value, id)
  UI.hide('Settings')
end

function onLoad(saved_data)
  if saved_data ~= "" then
    local loaded_data = JSON.decode(saved_data)
    selectedGens = loaded_data.selectedGens
    customGen = loaded_data.customGen
    print("Save Data loaded!")
  end

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
end

function onSave()
  saved_data = JSON.encode({ selectedGens = selectedGens, customGen = customGen })
  return saved_data
end

function beginSetup(player, value, id)
  UI.hide('Settings')
  local params = {
    selectedGens = selectedGens,
    customGen = customGen,
    leadersGen = leadersGen,
    randomStarters = randomStarters
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
end

-- String to boolean lookup dict.
-- TODO: what if this lookup fails?
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
  hasEnoughPokemon = numPokemon >= 150
end

function randomStartersToggle()
  randomStarters = not randomStarters
end

function battleScriptingToggle()
  battleScripting = not battleScripting
end

function gen1LeadersSet(player, isOn)
  setLeaders(1, isOn)
end

function gen2LeadersSet(player, isOn)
  setLeaders(2, isOn)
end

function gen3LeadersSet(player, isOn)
  setLeaders(3, isOn)
end

function gen4LeadersSet(player, isOn)
  setLeaders(4, isOn)
end

function gen5LeadersSet(player, isOn)
  setLeaders(5, isOn)
end

function gen6LeadersSet(player, isOn)
  setLeaders(6, isOn)
end

function gen7LeadersSet(player, isOn)
  setLeaders(7, isOn)
end

function gen8LeadersSet(player, isOn)
  setLeaders(8, isOn)
end

function gen9LeadersSet(player, isOn)
  setLeaders(9, isOn)
end

function customLeadersSet(player, isOn)
  setLeaders(0, isOn)
end

function randomLeadersSet(player, isOn)
  setLeaders(-1, isOn)
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

function setLeaders(gen, isOn)
  if isOn == "True" then isOn = true end
  if isOn != true then return end
  leadersGen = gen

  if leadersGen == 0 then
    local starterPokeball = getObjectFromGUID("ec1e4b")
    customAndTooFewLeaders = not starterPokeball.call("hasEnoughCustomLeaders")
  else
    customAndTooFewLeaders = false
  end

  checkBeginState()
end

function checkBeginState()
  UI.setAttribute("beginBtn", "interactable", hasEnoughPokemon and customAndTooFewLeaders == false)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  MUSIC
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function PlayRouteMusic()
  local song = playlist[currentTrack]
  MusicPlayer.setCurrentAudioclip({ url = song.url, title = song.title })
  MusicPlayer.repeat_track = false
  MusicPlayer.playlistIndex = currentTrack - 1
  MusicPlayer.play()
end

function PlayOpeningMusic()
  currentTrack = MusicPlayer.playlistIndex + 1
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
  currentTrack = MusicPlayer.playlistIndex + 1
  parameters =
  {
    url = "http://cloud-3.steamusercontent.com/ugc/1023948871898692339/1921C30F85D84D3DA42FB922B89E8C3EDBA0035F/",
    title = "Battle Music"
  }
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlayGymBattleMusic()
  currentTrack = MusicPlayer.playlistIndex + 1
  parameters = battlePlaylist[math.random(#battlePlaylist)]
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlayFinalBattleMusic()
  currentTrack = MusicPlayer.playlistIndex + 1
  parameters =
  {
    url = "http://cloud-3.steamusercontent.com/ugc/1023948871898724461/766C5BF1EB28C474D2366F8223F98C5F083770D0/",
    title = "Elite 4 Battle Music"
  }
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

function PlayCynthiaRivalMusic()
  currentTrack = MusicPlayer.playlistIndex + 1
  parameters =
  {
    url = "http://cloud-3.steamusercontent.com/ugc/2465233915448687664/638298CFD4041533322CB8E537B98923EAA776EE/",
    title = "Cynthia Battle Music"
  }
  MusicPlayer.setCurrentAudioclip(parameters)
  MusicPlayer.repeat_track = true
end

function PlaySilphCoBattleMusic()
  currentTrack = MusicPlayer.playlistIndex + 1
  parameters = teamRocketPlaylist[math.random(#teamRocketPlaylist)]
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