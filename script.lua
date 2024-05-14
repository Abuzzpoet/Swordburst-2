-- loadfile('SB2 Script/SCRIPT.lua')()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/Abuzzpoet/Swordburst-2/main/script.lua'))()
if getgenv().SB2Script then
    return
end

getgenv().SB2Script = true

local wait = task.wait
while not game:IsLoaded()  do
    wait(1)
end

if game.GameId ~= 212154879 then
    return
end

local UserInputS = game:GetService("UserInputService")
local TweenS = game:GetService("TweenService")
local RunS = game:GetService("RunService")
local Rs = game:GetService("ReplicatedStorage")
local Database = Rs:WaitForChild("Database")
local Event = Rs:WaitForChild("Event")
local rf = Rs:WaitForChild("Function")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local screen = Instance.new("ScreenGui", CoreGui)
local function create_confirm(text)
    local popup = CoreGui.RobloxGui.PopupFrame
    local new = popup:Clone()

    local thread = coroutine.running()
    new.PopupAcceptButton.MouseButton1Click:Connect(function()
        new:Destroy()
        coroutine.resume(thread, true)
    end)

    new.PopupDeclineButton.MouseButton1Click:Connect(function()
        new:Destroy()
        coroutine.resume(thread, false)
    end)

    new.PopupText.TextSize = 20
    new.PopupText.Text = text
    new.Visible = true
    new.Parent = screen

    return coroutine.yield()
end

local placeid = game.PlaceId
local hasfilefunctions = isfolder and makefolder and writefile and readfile
if hasfilefunctions and not isfolder("SB2 Script") then
    makefolder("SB2 Script")
end

if not UserInputS.TouchEnabled then
    if hasfilefunctions and placeid ~= 540240728 and placeid ~= 566212942 then
        local MPS = game:GetService("MarketplaceService")
        local info = MPS:GetProductInfo(placeid)

        local LastFloorUpdates = "SB2 Script/LastFloorUpdates"
        if not isfolder(LastFloorUpdates) then
            makefolder(LastFloorUpdates)
        end

        local FloorUpdateFile = LastFloorUpdates .. tostring(placeid)
        if not isfile(FloorUpdateFile) then
            writefile(FloorUpdateFile, info.Updated)
        end
        
        local lastknownupdate = readfile(FloorUpdateFile)
        if info.Updated ~= lastknownupdate then
            writefile(FloorUpdateFile, info.Updated)
            if not create_confirm("update detected. use script at risk. t =" .. info.Updated .. "\n\tContinue?") then
                getgenv().SB2Script = false
                return
            end
        end
    end
end

local info = debug.info
local islclosure = islclosure or function(f)
    return info(f, "s") ~= "[C]"
end
local iscclosure = iscclosure or function(f)
    return info(f, "s") == "[C]"
end
local getnamecallmethod = getnamecallmethod
local getupvalue = getupvalue or debug.getupvalue
local setupvalue = setupvalue or debug.setupvalue
local getrawMT = getrawmetatable or debug.getmetatable
local setrawMT = setrawmetatable or debug.setmetatable
local setreadonly = setreadonly or makereadonly or makewritable
local firetouchinterest = firetouchinterest
local setclipboard = setclipboard or writeclipboard or write_clipboard
local getconnections = getconnections
local firesignal = firesignal or getconnections and function(signal, args)
    for _, v in getconnections(signal) do
        v:Fire(args)
    end
end
local request = syn and syn.request or fluxus and fluxus.request or request
local sethiddenproperty = sethiddenproperty or sethiddenprop or set_hidden_prop

local teleport_execute = queue_on_teleport or syn and syn.queue_on_teleport
if teleport_execute then
    teleport_execute("loadstring(game:HttpGet('https://raw.githubusercontent.com/Abuzzpoet/Swordburst-2/main/script.lua'))()")
end

local mobs_on_floor = {
    [540240728] = { -- arcadia -- floor 1
        "Dummy",
        "Statue",
        "Platemail",
        "Mega Present"
    },
    
    [737272595] = {}, -- battle arena floor 1
    [566212942] = {}, -- floor 6 helmfrith

    [542351431] = { -- floor 1
        "Frenzy Boar",
        "Wolf",
        "Hermit Crab",
        "Bear",
        "Ruin Knight",
        "Draconite",
        "Canyon Knight",
        "Ruin Kobold Knight",
        "Ruined Kobold Knight"
    },

    [548231754] = { -- floor 2
        "Leaf Beetle",
        "Leaf Ogre",
        "Leafray",
        "Pearl Keeper",
        "Bushback Tortoise",
        "Wasp",
        "Giant Ruins Hornet"
    },

    [555980327] = { -- floor 3
        "Snowgre",
        "Angry Snowman",
        "Icewhal",
        "Ice Elemental",
        "Snowhorse",
        "Ice Walker",
        
        "Icy Imp", -- WINTER EVENT
        "Evergreen Sentinel",
        "Crystalite",
        "Gemulite",
        "Holiday Android"
    },

    [572487908] = { -- floor 4
        "Wattlechin Crocodile",
        "Birchman",
        "Treehorse",
        "Treeray",
        "Boneling",
        "Bamboo Spiderling",
        "Bamboo Spider",
        "Dungeon Dweller",
        "Lion Protector",
    },

    [580239979] = { -- floor 5
        "Girdled Lizard",
        "Angry Cactus",
        "Desert Vulture",
        "Sand Scorpion",
        "Giant Centipede",
        "Green Patrolman",
        "Centaurian Defender",
        "Patrolman Elite",
    },

    [582198062] = { -- floor 7
        "Jelly Wisp",
        "Firefly",
        "Shroom Back Clam",
        "Gloom Shroom",
        "Horned Sailfin Iguana",
        "Blightmouth",
        "Snapper"
    },

    [548878321] = { -- floor 8
        "Giant Praying Mantis",
        "Petal Knight",
        "Leaf Rhino",
        "Sky Raven",
        "Wingless Hippogriff",
        "Forest Wanderer",
        "Dungeon Crusader"
    },

    [573267292] = { -- floor 9
        "Batting Eye",
        "Lingerer",
        "Fishrock Spider",
        "Reptasaurus",
        "Ent",
        "Undead Warrior",
        "Enraged Lingerer",
        "Undead Berserker"
    },

    [2659143505] = { -- floor 10
        "Winged Minion",
        "Clay Giant",
        "Wendigo",
        "Grunt",
        "Guard Hound",
        "Minion",
        "Shady Villager",
        "Undead Servant",
    },

    [5287433115] = { -- floor 11
        "Reaper",
        "Elite Reaper",
        "DJ Reaper",
        "Soul Eater",
        "Shadow Figure",
        "Meta Figure",
        "???????",
        "Rogue Android",
        "Command Falcon",
        "Armageddon Eagle",
        "Sentry",
        "Watcher",
        "Cybold",
        "Wa, the Curious",
    },

    [6144637080] = { -- FLOOR 12
        "Scav",
        "Radio Slug",
        "Elite Scav",
        "Crystal Lizard",
        "Failed Experiment",
        "Bat",
        "Blue Failed Experiment",
        "Orange Failed Experiment",
        "Newborn Abomination"
    },

    [13965775911] = {}, -- atheon's realm

    [11331145451] = { -- HALLOWEEN EVENT
        "Tremor",
        "Rotten Brute",
        "Cursed Giant",
        "Black Widow",
        "Dark Spirit",
        "Abyssal Spider",
        "Crumbling Gargoyle",
        "Decayed Warrior",
        "Vampiric Bat",
        "Big Fat Rat",
        "Count Dracula, Vlad Tepes",
        "Enraged Wendigo",
        "Headless Horseman"
    },

    [13051622258] = { -- EASTER EVENT
        "Easterian Knight",
        "Gemulite",
        "Crystalite",
        "Egg Mimic"
    },

    [15716179871] = { -- WINTER EVENT 2023
        "Frostgre",
        "Icy Imp",
        "Gemulite",
        "Crystalite",
        "Galcius Howler",
        "Icy Snowman",
        "Dark Frost Goblin"
    },

    [16810524216] = {
        "Eternal Blossom Knight",
        "Ancient Blossom Knight"
    }
}

local bosses_on_floor = {
    [540240728] = {}, -- arcadia -- floor 1
    [737272595] = {}, -- battle arena floor 1
    [566212942] = {}, -- floor 6 helmfrith

    [542351431] = { -- floor 1
        "Dire Wolf",
        "Rahjin the Thief King",
        "Ruined Kobold Lord"
    },

    [548231754] = { -- floor 2
        "Pearl Guardian",
        "Gorrock the Grove Protector",
        "Borik the BeeKeeper"
    },

    [555980327] = { -- floor 3
        "Qerach The Forgotten Golem",
        "Alpha Icewhal",
        "Ra'thae the Ice King",
        
        "Withered Wintula", -- WINTER EVENT
        "Jolrock the Snow Protecter"
    },

    [572487908] = { -- floor 4
        "Rotling",
        "Irath the Lion",
    },

    [580239979] = { -- floor 5
        "Fire Scorpion",
        "Sa'jun the Centurian Chieftain"
    },

    [582198062] = { -- floor 7
        "Frogazoid",
        "Smashroom the Mushroom Behemoth"
    },

    [548878321] = { -- floor 8
        "Hippogriff",
        "Formaug the Jungle Giant"
    },

    [573267292] = { -- floor 9
        "Gargoyle Reaper",
        "Polyserpant",
        "Mortis the Flaming Sear"
    },

    [2659143505] = { -- floor 10
        "Baal, The Tormentor",
        "Grim, The Overseer"
    },

    [5287433115] = { -- floor 11
        "Da, the Demeanor",
        "Ra, the Enlightener",
        "Ka, the Mischief",
        "Za, the Eldest",
        "Duality Reaper",
        "Saurus, the All-Seeing",
        "Neon Chest"
    },

    [6144637080] = { -- FLOOR 12
        "Suspended Unborn",
        "Limor The Devourer",
        "C-618 Uriotol, The Forgotten Hunter",
        "Radioactive Experiment",
        "Warlord"
    },

    [13965775911] = { -- Atheon's realm
        "Atheon"
    },

    [11331145451] = { -- halloween
        "Magnor, the Necromancer",
        "Bulswick, the Elkwood Behemoth",
        "Egnor, the Undead King",
        "Headless Horseman"
    },

    [13051622258] = { -- EASTER EVENT
        "Killer Bunny",
        "Alpha Killer Bunny"
    },
    
    [15716179871] = { -- WINTER EVENT 2023
        "Vyroth, The Frostflame",
        "Krampus",
        "Rat",
        "Ghost of the Present",
        "Kloff, Marauder of the Frost",
        "Ghost of the Past",
        "Ghost of the Future"
    },

    [16810524216] = {
        "Azeis, Spirit of the Eternal Blossom",
        "Tworz, The Ancient"
    }
}

local spawn = task.spawn
spawn(function()
    local vim = game:GetService("VirtualInputManager")
    while true do
        vim:SendKeyEvent(true, Enum.KeyCode.Home, false, game)
        wait(1)
        vim:SendKeyEvent(false, Enum.KeyCode.Home, false, game)
        wait(60 * 15)
    end
end)

local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local Services
while true do
    for _, v in getloadedmodules() do
        if v.Name == "MainModule" then
            Services = v.Services
            break
        end
    end
    
    if Services then
    	break
    end

    wait(1)
end

local combat_module = require(Services.Combat)
local CalculateCombatStyle = combat_module.CalculateCombatStyle

local settings = { -- defaults
    Autofarm = false,
    Autofarm_Y_Offsets = {},
    Tween_Speed = 50,
    Farm_Only_Bosses = false,
    Boss_Priority = false,
    Prioritized_Boss = nil,
    Mob_Priority = false,
    Prioritized_Mob = nil,
    KA = false,
    KA_Range = 30,
    AutoEquip = false,
    InfSprint = false,
    InfJump = false,
    KA_Keybind = "K",
    AttackPlayers = false,
    MaxAutofarmDistance = 5000,
    excludedMobs = {},
    Height = 30,
    Autofarm_Idle_Min = 30,
    Autofarm_Idle_Max = 70,
    WebhookURL = "",
    Inline = false,
    NoClip = false,
    Whitelist = {},
    SpeedGlitchBind = "J",
    GuiBind = "Delete"
}

local doLoad = {
    Height = true,
    Autofarm_Idle_Min = true,
    Autofarm_Idle_Max = true,
    MaxAutofarmDistance = true,
    KA_Keybind = true,
    KA_Range = true,
    Autofarm_Y_Offsets = true,
    WebhookURL = true,
    Tween_Speed = true,
    excludedMobs = true,
    Whitelist = true,
    SpeedGlitchBind = true,
    GuiBind = true
}

local HttpS = game:GetService("HttpService")

local hasfilefunctions = isfolder and makefolder and writefile and readfile
if hasfilefunctions then
    local fileName = `SB2 Script/{plr.UserId} Settings.json`
    local function save_settings()
        writefile(fileName, HttpS:JSONEncode(settings))
    end

    if not isfile(fileName) then
        save_settings()
    end

    local saved_settings = HttpS:JSONDecode(readfile(fileName))
    for i, v in saved_settings do
        if doLoad[i] then
            settings[i] = v
        end
    end

    spawn(function()
        while true do
            save_settings()
            wait(5)
        end
    end)
end

local all_on_floor = {"Chests"}
for _, v in bosses_on_floor[placeid] do
    table.insert(all_on_floor, v)
end

for _, v in mobs_on_floor[placeid] do
    table.insert(all_on_floor, v)
end

local MobExclusion = settings.excludedMobs
local Autofarm_Y_Offsets = settings.Autofarm_Y_Offsets

local function WaitForDescendant(parent, descendant_name)
    local already = parent:FindFirstChild(descendant_name, true)
    if already then
        return already
    end

    local thread = coroutine.running()
    local con; con = parent.DescendantAdded:Connect(function(c)
        if c.Name == descendant_name then
            con:Disconnect()
            coroutine.resume(thread, c)
        end
    end)
    
    return coroutine.yield()
end

local function WaitForChildWhichIsA(parent, child_class)
    local already = parent:FindFirstChildWhichIsA(child_class)
    if already then
        return already
    end

    local thread = coroutine.running()
    local con; con = parent.ChildAdded:Connect(function(c)
        if c:IsA(child_class) then
            con:Disconnect()
            coroutine.resume(thread, c)
        end
    end)
    
    return coroutine.yield()
end

local match = string.match
local leveltext = WaitForDescendant(plr, "Level")
local level = tonumber(match(leveltext.Text, "%d+"))
leveltext:GetPropertyChangedSignal("Text"):Connect(function()
    level = tonumber(match(leveltext.Text, "%d+"))
end)

local parts = {}
local function setNoClipParts()
    table.clear(parts)

    for _, part in char:GetDescendants() do
        if part:IsA("BasePart") and part.CanCollide then
            table.insert(parts, part)
        end
    end

    wait(1)
end

setNoClipParts()

local tpingtohunter
local function noclip()
    if settings.Autofarm or settings.NoClip or tpingtohunter then
        for _, v in parts do
            v.CanCollide = false
        end
    end
end

RunS.Stepped:Connect(noclip)

local autoheal
local lastheal = 0

local playerHealth
local maxPlayerHealth
local Entity = char:WaitForChild("Entity")
local stamina = Entity:WaitForChild("Stamina")
local health = Entity:WaitForChild("Health")
local function Heal()
    local t = os.time()
    if level >= 50 and t - lastheal >= 25 and autoheal and playerHealth / maxPlayerHealth <= .7 and stamina.Value >= 40 then
        lastheal = t
        Event:FireServer("Skills", {"UseSkill", "Heal", {}})
    end
end

local function setUpPlayerHealthValues()
    playerHealth = health.Value
    maxPlayerHealth = health.MaxValue
    local currentHealthSignal = health:GetPropertyChangedSignal("Value"):Connect(function()
        playerHealth = health.Value
        Heal()
    end)

    local maxHealthSignal = health:GetPropertyChangedSignal("MaxValue"):Connect(function()
        maxPlayerHealth = health.MaxValue
    end)

    local humanoidDied; humanoidDied = humanoid.Died:Connect(function()
        humanoidDied:Disconnect()
        maxHealthSignal:Disconnect()
        currentHealthSignal:Disconnect()
    end)
end

local hasMaxStamina = stamina.Value >= stamina.MaxValue
local function setUpStaminaValues()
    hasMaxStamina = stamina.Value >= stamina.MaxValue
    local currentStaminaSignal = stamina:GetPropertyChangedSignal("Value"):Connect(function()
        hasMaxStamina = stamina.Value >= stamina.MaxValue
    end)

    local humanoidDied; humanoidDied = humanoid.Died:Connect(function()
        humanoidDied:Disconnect()
        currentStaminaSignal:Disconnect()
    end)
end
setUpPlayerHealthValues()
setUpStaminaValues()

local savedcframe
local function GetClosestPartFromVector(v3)
    local closest_magnitude = math.huge
    local closest_part
    for _, v in workspace:GetDescendants() do
        if v.Parent.Name == "TeleportSystem" and v.Name == "Part" then
            local distance = (v3 - v.Position).Magnitude
            if distance < closest_magnitude then
                closest_magnitude = distance
                closest_part = v
            end
        end
    end

    return closest_part
end

local function Tp(totouch)
    firetouchinterest(hrp, totouch, 0)
    wait(.1)
    firetouchinterest(hrp, totouch, 1)
end

local noslashtrails
local function RemoveTrail(hum)
    local con
    while not con do
        con = getconnections(hum.AnimationPlayed)[1]
        wait(1)
    end

    if noslashtrails then
        con:Disable()
    else
        con:Enable()
    end
end

local searchforclosesttpondeath
plr.CharacterAdded:Connect(function(new)
    tpingtohunter = false
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")

    Entity = char:WaitForChild("Entity")
    health = Entity:WaitForChild("Health")
    stamina = Entity:WaitForChild("Stamina")

    setUpPlayerHealthValues()
    setUpStaminaValues()
    setNoClipParts()

    stamina.Value = 100
    hasMaxStamina = true

    if savedcframe and searchforclosesttpondeath then
        wait(1)

        local savedpos = savedcframe.Position
        local totouch = GetClosestPartFromVector(savedpos)
        if totouch then
            Tp(totouch)

            wait(1)
            for i, v in totouch.Parent:GetChildren() do
                if v ~= totouch then
                    Tp(v)
                end
            end
        end
    end
    
    RemoveTrail(humanoid)
end)

local Actions = require(Services.Actions)

local startswing = Actions.StartSwing
local stopswing = Actions.StopSwing
--[[Actions.StartSwing = function()
    if settings.KA then
        return
    end

    return startswing()
end]]

local attackrequest = combat_module.AttackRequest
combat_module.AttackRequest = function(...)
    if settings.KA then
        return
    end

    return attackrequest(...)
end

local inventory_module = require(Services.UI.Inventory)

local hookmetamethod = hookmetamethod or function(t, metamethod, hook)
    local mt = getrawMT(t)
    setreadonly(mt, false)

    local oldfunc = mt[metamethod]
    mt[metamethod] = hook

    setreadonly(mt, true)
    return oldfunc
end

local Profiles = Rs:WaitForChild("Profiles")
local Profile = Profiles:WaitForChild(plr.Name)
local Inventory = Profile:WaitForChild("Inventory")

local mobs = workspace:WaitForChild("Mobs")

local function getMobHealth(mob)
    local entity = mob and mob:FindFirstChild("Entity")
    return entity and entity:FindFirstChild("Health")
end

local sprinting
local infspiritdash
local nc; nc = hookmetamethod(game, "__namecall", function(self, ...)
    local ncm = getnamecallmethod()
    local args = {...}

    if self == Event and ncm == "FireServer" then
        if args[1] == "Skills" and args[2][1] == "UseSkill" then
            if args[2][2] == "Spirit Dash" and infspiritdash then
                return
            end

        elseif args[1] == "Actions" and args[2][1] == "Sprint" then
            if args[2][2] == "Enabled" then
                sprinting = true
                
            elseif args[2][2] == "Disabled" then
                sprinting = false

            elseif settings.InfSprint and args[2][2] == "Step" then
                return
            end
        end

    elseif self == rf and ncm == "InvokeServer" then
        if not checkcaller() and args[1] == "Equipment" then
            if getupvalue(inventory_module.GetInventoryData, 2) ~= Profile then
                return
            end
        end
    end

    return nc(self, ...)
end)

local lib
local editing = false
if not editing then
    lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/noobscripter38493/orion/main/orionnnn.lua"))()
else
    lib = loadfile("orion.lua")()
end

local orion = CoreGui:WaitForChild("Orion")

local window = lib:MakeWindow("SB2 | Abuzzpoet")

local rarities = {"Common", "Uncommon", "Rare", "Legendary", "Tribute"}
local names = {"Commons", "Uncommons", "Rares", "Legendaries", "Tributes"}

local othercharacters = {}
local function SetupCharacterListeners(v)
    othercharacters[v.Name] = v.Character
    v.CharacterAdded:Connect(function(new)
        spawn(RemoveTrail, new:WaitForChild("Humanoid"))
        othercharacters[v.Name] = new
    end)
end

for i, v in Players:GetChildren() do
    if v ~= plr then
        SetupCharacterListeners(v)
    end
end

Players.PlayerAdded:Connect(function(v)
    SetupCharacterListeners(v)
end)

Players.PlayerRemoving:Connect(function(v)
    othercharacters[v.Name] = nil
end)

spawn(function()
    while true do
        for i, v in othercharacters do
            if not settings.Autofarm then
                v.Parent = workspace
                continue
            end

            local theirhrp = v:FindFirstChild("HumanoidRootPart")
            if theirhrp and (hrp.Position - theirhrp.Position).Magnitude <= 10 then
                v.Parent = nil
            else
                v.Parent = workspace
            end
        end

        wait(1)
    end
end)

local split = string.split
do
    local farm_tab = window:MakeTab("Autofarm")
    local mobs_table = {}

    local function distanceCheck(enemy)
        local enemy_hrp = enemy:FindFirstChild("HumanoidRootPart")
        if not enemy_hrp then return end

        local distance = (hrp.Position - enemy_hrp.Position).Magnitude
        local maxdistance = settings.MaxAutofarmDistance
        return distance < maxdistance
    end

    local function isChest(mob_name)
        return match(mob_name, "Chest") and not match(mob_name, "Neon") and "Chests"
    end

    local function searchForMob(mobName)
        local closest_magnitude = math.huge
        local closest_mob

        for _, mob in mobs_table do
            local name = isChest(mob.Name)
            if MobExclusion[name or mob.Name] then
                continue
            end

            if mob.Name == mobName and distanceCheck(mob) then
                local mob_hrp = mob:FindFirstChild("HumanoidRootPart")
                if not mob_hrp then continue end

                local mob_health = getMobHealth(mob)
                if mob_health and mob_health.Value > 0 then
                    local magnitude = (mob_hrp.Position - hrp.Position).Magnitude
                    if magnitude < closest_magnitude then
                        closest_mob = mob
                        closest_magnitude = magnitude
                    end
                end
            end
        end

        return closest_mob
    end

    local function searchForAnyEnemy(a)
        local closest_magnitude = math.huge
        local closest_mob

        for _, mob in mobs_table do
            local name = isChest(mob.Name)
            if MobExclusion[name or mob.Name] then
                continue
            end

            if distanceCheck(mob) then
                local mob_hrp = mob:FindFirstChild("HumanoidRootPart")
                if not mob_hrp then
                    continue
                end

                local mob_health = getMobHealth(mob)
                if mob_health and mob_health.Value > 0 then
                    local magnitude = (mob_hrp.Position - hrp.Position).Magnitude
                    if magnitude < closest_magnitude then
                        closest_mob = mob
                        closest_magnitude = magnitude
                    end
                end
            end
        end

        if a and closest_mob then
            return closest_mob.HumanoidRootPart
        end

        return closest_mob
    end

    local function searchForBoss(bossName)
        local closest_magnitude = math.huge
        local closest_boss

        for _, boss in mobs_table do
            local name = isChest(boss.Name)
            if MobExclusion[name or boss.Name] then
                continue
            end

            if boss.Name == bossName and distanceCheck(boss) then
                local boss_hrp = boss:FindFirstChild("HumanoidRootPart")
                if not boss_hrp then continue end

                local boss_health = getMobHealth(boss)
                if boss_health and boss_health.Value > 0 then
                    local magnitude = (boss_hrp.Position - hrp.Position).Magnitude
                    if magnitude < closest_magnitude then
                        closest_boss = boss
                        closest_magnitude = magnitude
                    end
                end
            end
        end

        return closest_boss
    end

    local function searchForAnyBoss(bosses)
        local closest_magnitude = math.huge
        local closest_boss

        for _, boss in mobs_table do
            local name = isChest(boss.Name)
            if MobExclusion[name or boss.Name] then
                continue
            end

            for _, bossName in bosses do
                if boss.Name == bossName and distanceCheck(boss) then
                    local boss_hrp = boss:FindFirstChild("HumanoidRootPart")
                    if not boss_hrp then continue end

                    local boss_health = getMobHealth(boss)
                    if boss_health and boss_health.Value > 0 then
                        local magnitude = (boss_hrp.Position - hrp.Position).Magnitude
                        if magnitude < closest_magnitude then
                            closest_boss = boss
                            closest_magnitude = magnitude
                        end
                    end
                end
            end
        end

        return closest_boss
    end

    local tweens = {}

    local floatPart = Instance.new("Part")
    floatPart.Transparency = 1
    floatPart.Anchored = true
    floatPart.Size = Vector3.new(1, 1, 1)
    floatPart.CanCollide = false

    local shouldFloat = false
    RunS.RenderStepped:Connect(function()
        if shouldFloat then 
            return 
        end
        
        local height = settings.Height
        floatPart.CFrame = hrp.CFrame * CFrame.new(0, height, 0)
    end)
    
    floatPart.Parent = workspace

    local AtheonAttack = {
        n = nil, 
        t = os.time()
    }   

    local WarlordCircleDiameter = 30
    local AtheonMeteorDiameter = 35
    local AtheonNukeDiameter = 155
    local AtheonNukeRadius = 155/2 + 5
    local WarlordCircleAttackT = 0
    local SuspendedUnbornYCircle = 100
    local gettingmeteors
    local gettingcircles
    local suspendedcircles = {}
    workspace.ChildAdded:Connect(function(c)
        if c.Name == "Circle" then
            if c.Size.X == WarlordCircleDiameter then
                WarlordCircleAttackT = os.time()
            
            elseif c.Size.X == AtheonNukeDiameter then
                AtheonAttack.n = "Nuke"
                AtheonAttack.t = os.time()

            elseif c.Size.X == AtheonMeteorDiameter then
                if gettingmeteors then return end

                spawn(function()
                    gettingmeteors = true
                    AtheonAttack.n = "Meteors"
                    AtheonAttack.t = os.time()

                    wait(5)

                    AtheonAttack.n = nil
                    gettingmeteors = false
                end)

            elseif c.Size.Y == SuspendedUnbornYCircle then
                table.insert(suspendedcircles, c)
                if gettingcircles then 
                    table.insert(suspendedcircles, c)
                    return 
                end

                spawn(function()
                    gettingcircles = true

                    wait(6)

                    gettingcircles = false
                    table.clear(suspendedcircles)
                end)
            end

        elseif c.Name == "Box" then
            AtheonAttack.n = "LavaDash"
            AtheonAttack.t = os.time()
        end
    end)

    local function IsBossAttacking(mob_name)
        if mob_name == "Atheon" then
            local name = AtheonAttack.n 
            local t = AtheonAttack.t 
            if AtheonAttack.n == "Nuke" then
                return os.time() - t < 4

            elseif AtheonAttack.n == "LavaDash" then
                return os.time() - t < 5

            elseif AtheonAttack.n == "Meteors" then
                return gettingmeteors
            end
        end

        if mob_name == "Warlord" then
            return os.time() - WarlordCircleAttackT < 5.5
        end

        if mob_name == "Suspended Unborn" then
            return gettingcircles
        end
    end

    local cos = math.cos
    local sin = math.sin
    local rad = math.rad

    local function SafePoints(radius, b)
        local safepoints = {}
        for i = 1, 8 do
            local radians = rad(360/i)
            safepoints[i] = (radius + 3) * Vector2.new(cos(radians), sin(radians)) + Vector2.new(b.Position.X, b.Position.Z)
        end

        return safepoints
    end

    local function SafeArea(mob_name)
        if mob_name == "Warlord" then
            shouldFloat = true
            return floatPart
        end

        if mob_name == "Atheon" then
            local atheon = mobs.Atheon
            local atheon_hrp = atheon.HumanoidRootPart
            if AtheonAttack.n == "Nuke" then
                local safepoints = SafePoints(AtheonNukeRadius, atheon_hrp)
   
                local closestsafepoint
                local closestmag = math.huge
                for i, v in safepoints do
                    local pos = Vector2.new(hrp.Position.X, hrp.Position.Z)
                    local mag = (pos - v).Magnitude
                    if mag < closestmag then
                        closestmag = mag
                        closestsafepoint = v
                    end
                end

                return CFrame.new(closestsafepoint.X, hrp.Position.Y, closestsafepoint.Y)

            elseif AtheonAttack.n == "LavaDash" then
                return atheon_hrp.CFrame * CFrame.new(0, Autofarm_Y_Offsets["Atheon"], 10)

            elseif AtheonAttack.n == "Meteors" then
                return atheon_hrp.CFrame * CFrame.new(0, 50, 0)
            end
        end

        if mob_name == "Suspended Unborn" then
            local closestmag = 9e9
            local closestcircle
            for i, v in suspendedcircles do
                local mag = (v.Position - hrp.Position).Magnitude
                if mag < closestmag then
                    closestmag = mag
                    closestcircle = v
                end
            end

            local SafePointsNot = SafePoints(13, closestcircle)
            local safepoints = {}
            for i, v in SafePointsNot do
                for i2, v2 in suspendedcircles do
                    if v2 == closestcircle then
                        continue
                    end

                    local pos = Vector2.new(v2.Position.X, v2.Position.Z)
                    local mag = (pos - v).Magnitude
                    if mag >= 15 then
                        safepoints[i] = v
                    else
                        safepoints[i] = nil
                    end
                end
            end

            local closestmag = 9e9
            local closestsafe
            local pos = Vector2.new(hrp.Position.X, hrp.Position.Z)
            for i, v in safepoints do
                local mag = (v - pos).Magnitude
                if mag < closestmag then
                    closestmag = mag
                    closestsafe = v
                end
            end

            local suspendedunborn = mobs["Suspended Unborn"]
            local suspendedunbornhrp = suspendedunborn.HumanoidRootPart
            if (closestsafe - pos).Magnitude >= 15 then
                return suspendedunbornhrp
            end

            return CFrame.new(closestsafe.X, suspendedunbornhrp.Position.Y + Autofarm_Y_Offsets["Suspended Unborn"], closestsafe.Y)
        end
    end

    local tweeningtosavedcframe
    local function FindNextMob()
        if tweeningtosavedcframe and (hrp.Position - savedcframe.Position).Magnitude <= 10 then
            tweeningtosavedcframe = false
        end

        if savedcframe and (hrp.Position - savedcframe.Position).Magnitude > settings.MaxAutofarmDistance then
            tweeningtosavedcframe = true
            return savedcframe
        end

        local to
        if settings.Farm_Only_Bosses then
            to = searchForAnyBoss(bosses_on_floor[placeid])
            to = to and to:FindFirstChild("HumanoidRootPart")
            to = to or floatPart

            shouldFloat = to == floatPart

            if IsBossAttacking(to and to.Parent.Name) then
                return SafeArea(to.Parent.Name)
            end

            return to
        end

        local boss = settings.Prioritized_Boss
        if settings.Boss_Priority and boss then
            to = searchForBoss(boss)
        end

        local mob = settings.Prioritized_Mob
        if not to and settings.Mob_Priority and mob then
            to = searchForMob(mob)
        end

        if not to then
            to = searchForAnyEnemy()
        end

        if IsBossAttacking(to and to.Name) then
            return SafeArea(to.Name)
        end

        to = to and to:FindFirstChild("HumanoidRootPart") or floatPart
        if to == floatPart and savedcframe then
            to = savedcframe
        end

        shouldFloat = to == floatPart
        return to
    end

    local IsWaitingFromHealthFloat = false
    local function playerHealthChecks()
        local minPercentage = settings.Autofarm_Idle_Min / 100
        local maxPercentage = settings.Autofarm_Idle_Max / 100

        if not IsWaitingFromHealthFloat and playerHealth < minPercentage * maxPlayerHealth then
            IsWaitingFromHealthFloat = true
            shouldFloat = true
            return floatPart
        end

        if IsWaitingFromHealthFloat and playerHealth > maxPercentage * maxPlayerHealth then
            IsWaitingFromHealthFloat = false
        end

        if not IsWaitingFromHealthFloat then
            return FindNextMob()
        end

        shouldFloat = true
        return floatPart
    end

    local function TweenF()
        local to = playerHealthChecks()
        local distance = (hrp.Position - to.Position).Magnitude
        local seconds = distance / settings.Tween_Speed
        local y_offset = 0
        local cframe
        if typeof(to) ~= "CFrame" then
            y_offset = shouldFloat and 0 or Autofarm_Y_Offsets[to.Parent.Name]
            cframe = to.CFrame * CFrame.new(0, y_offset, 0)
        else
            if AtheonAttack.n == "Meteors" then
                local atheon_hrp = searchForAnyEnemy("GetHrp")
                if atheon_hrp and hrp.Position.Y - atheon_hrp.Position.Y >= 50 then
                    return
                end
            end

            cframe = to
        end

        local tween_info = TweenInfo.new(seconds, Enum.EasingStyle.Linear)
        local tween = TweenS:Create(hrp, tween_info, {CFrame = cframe})
        table.insert(tweens, tween)

        tween:Play()
    end

    RunS.RenderStepped:Connect(function()
        if settings.Autofarm or tpingtohunter then 
            hrp.Velocity = Vector3.zero 
        end
    end)

    mobs.ChildAdded:Connect(function(mob)
        mob:WaitForChild("HumanoidRootPart")
        mobs_table[mob] = mob
    end)

    mobs.ChildRemoved:Connect(function(mob)
        pcall(function()
            mobs_table[mob] = nil
        end)
    end)

    for _, mob in mobs:GetChildren() do
        spawn(function()
            mob:WaitForChild("HumanoidRootPart")
            mobs_table[mob] = mob
        end)
    end

    farm_tab:AddToggle({
        Name = "Autofarm",
        Default = false,
        Callback = function(bool)
            settings.Autofarm = bool

            if not bool then
                local tween = tweens[#tweens]
                if tween then
                    tween:Cancel()
                end

                table.clear(tweens)
                shouldFloat = false
            end

            while settings.Autofarm do
                if not tpingtohunter then
                    spawn(TweenF)
                end

                wait()
            end
        end
    })

    farm_tab:AddToggle({
        Name = "Farm Only Bosses",
        Default = false,
        Callback = function(bool)
            settings.Farm_Only_Bosses = bool
        end
    })

    farm_tab:AddToggle({
        Name = "Boss Priority",
        Default = false,
        Callback = function(bool)
            settings.Boss_Priority = bool
        end
    })

    farm_tab:AddDropdown({
        Name = "Prioritized Boss",
        Default = nil,
        Options = bosses_on_floor[placeid],
        Callback = function(boss)
            settings.Prioritized_Boss = boss
        end
    })

    farm_tab:AddToggle({
        Name = "Mob Priority",
        Default = false,
        Callback = function(bool)
            settings.Mob_Priority = bool
        end
    })

    farm_tab:AddDropdown({
        Name = "Prioritized Mob",
        Default = nil,
        Options = mobs_on_floor[placeid],
        Callback = function(mob)
            settings.Prioritized_Mob = mob
        end
    })

    farm_tab:AddToggle({
        Name = "Get Closest TP to saved position when die",
        Default = false,
        Callback = function(bool)
            searchforclosesttpondeath = bool
        end
    })

    farm_tab:AddButton({
        Name = "Save Position (tween here when no mobs or out of range)",
        Callback = function()
            savedcframe = hrp.CFrame
        end
    })

    if UserInputS.TouchEnabled then
        farm_tab:AddTextbox({
            Name = "MaxRadius (0-10000)",
            Default = tostring(settings.MaxAutofarmDistance),
            TextDisappear = false,
            Callback = function(n)
                n = tonumber(n)
                if n and n >= 0 and n <= 10000 then
                    settings.MaxAutofarmDistance = n
                end
            end
        })

        farm_tab:AddTextbox({
            Name = "Idle Float Height (30-100)",
            Default = tostring(settings.Height),
            TextDisappear = false,
            Callback = function(n)
                n = tonumber(n)
                if n and n >= 30 and n <= 100 then
                    settings.Height = n
                end
            end
        })

        farm_tab:AddTextbox({
            Name = "Idle Float when under % health (0-100)",
            Default = tostring(settings.Autofarm_Idle_Min),
            TextDisappear = false,
            Callback = function(n)
                n = tonumber(n)
                if n and n >= 0 and n <= 100 then
                    settings.Autofarm_Idle_Min = n
                end
            end
        })

        farm_tab:AddTextbox({
            Name = "Resume Farm when over % health (0-100)",
            Default = tostring(settings.Autofarm_Idle_Max),
            TextDisappear = false,
            Callback = function(n)
                n = tonumber(n)
                if n and n >= 0 and n <= 100 then
                    settings.Autofarm_Idle_Max = n
                end
            end
        })

        farm_tab:AddTextbox({
            Name = "Tween Speed (0-100)",
            Default = tostring(settings.Tween_Speed),
            TextDisappear = false,
            Callback = function(n)
                n = tonumber(n)
                if n and n >= 0 and n <= 100 then
                    settings.Tween_Speed = n
                end
            end
        })
    else
        farm_tab:AddSlider({
            Name = "Max Radius",
            Min = 0,
            Max = 10000,
            Default = settings.MaxAutofarmDistance,
            Color = Color3.new(255, 255, 255),
            Increment = 100,
            ValueName = "Studs",
            Callback = function(v)
                settings.MaxAutofarmDistance = v
            end 
        })

        farm_tab:AddSlider({
            Name = "Idle Float Height",
            Min = 30,
            Max = 100,
            Default = settings.Height,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "Studs",
            Callback = function(v)
                settings.Height = v
            end
        })

        farm_tab:AddSlider({
            Name = "Idle Float when under % health",
            Min = 0,
            Max = 100,
            Default = settings.Autofarm_Idle_Min,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "%",
            Callback = function(v)
                settings.Autofarm_Idle_Min = v
            end
        })

        farm_tab:AddSlider({
            Name = "Resume Farm when over % health",
            Min = 0,
            Max = 100,
            Default = settings.Autofarm_Idle_Max,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "%",
            Callback = function(v)
                settings.Autofarm_Idle_Max = v
            end
        })

        farm_tab:AddSlider({
            Name = "Tween Speed",
            Min = 0,
            Max = 100,
            Default = settings.Tween_Speed,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "Speed",
            Callback = function(v)
                settings.Tween_Speed = v
            end
        })
    end
end

local alwaysswinganimation
do
    local combat = window:MakeTab("Combat")

    local range = Instance.new("Part")
    range.Size = Vector3.new(50, 50, 50)
    range.CanCollide = false
    range.Transparency = 1

    RunS.RenderStepped:Connect(function()
        range.CFrame = char:GetPivot()
    end)

    range.Parent = workspace

    local remote_key = getupvalue(combat_module.Init, 2)

    local attacking = {}
    local pauseKillAura = false
    local function killaura_function(enemy, player)
        while true do
            local i = table.find(attacking, enemy)
            local success, shouldAttack = pcall(function()
                return enemy.Entity.Health.Value > 0
            end)

            if not success or not shouldAttack or not settings.KA then
                table.remove(attacking, i)
                break
            end

            local enemy_hrp = enemy:FindFirstChild("HumanoidRootPart")
            if not enemy_hrp or enemy:FindFirstChild("Immortal") or (hrp.Position - enemy_hrp.Position).Magnitude > settings.KA_Range then
                table.remove(attacking, i)
                break
            end

            if player and not settings.AttackPlayers then
                table.remove(attacking, i)
                break
            end

            if not pauseKillAura then
                Event:FireServer("Combat", remote_key, {"Attack", enemy, nil, "2"})
            end

            wait(.33)
        end
    end

    local oldActions = table.clone(Actions)
    local animations = oldActions.animations
    setmetatable(Actions, {
        __index = oldActions,
        __newindex = function(self, i, v)
            oldActions[i] = v

            if i == "animations" then
                animations = v
            end
        end
    })

    table.clear(Actions)
--[[
    local was
    spawn(function()
        while true do wait()
            if alwaysswinganimation then
                was = true
                spawn(startswing)

            elseif was then
                was = false
                stopswing()
            end

            if not settings.KA then
                continue
            end

            if #attacking > 0 then
                spawn(startswing)
            else
                stopswing()
            end
        end
    end)]]

    range.Touched:Connect(function(touching)
        if not settings.KA or touching.Parent == char or touching.Name ~= "HumanoidRootPart" then
            return
        end

        local enemy = touching.Parent
        if not table.find(attacking, enemy) then
            local mob = table.find(mobs_on_floor[placeid], enemy.Name)
            local boss = table.find(bosses_on_floor[placeid], enemy.Name)
            local chest = match(enemy.Name, "Chest")

            if mob or boss or chest then
                table.insert(attacking, enemy)
                killaura_function(enemy)

            elseif settings.AttackPlayers then
                table.insert(attacking, enemy)
                killaura_function(enemy, true)
            end
        end
    end)

    combat:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(bool)
            settings.KA = bool
        end,
        Keybind = true,
        DefaultKeybind = settings.KA_Keybind,
        BindSetCallback = function(key)
            settings.KA_Keybind = key
        end,
    })

    combat:AddToggle({
        Name = "Attack Players",
        Default = false,
        Callback = function(bool)
            settings.AttackPlayers = bool
        end
    })

    if UserInputS.TouchEnabled then
        combat:AddTextbox({
            Name = "Kill Aura Range (0-50)",
            Default = tostring(settings.KA_Range),
            TextDisappear = false,
            Callback = function(text)
                local n = tonumber(text)
                if n and n >= 0 and n <= 50 then
                    settings.KA_Range = n
                end
            end
        })
    else
        combat:AddSlider({
            Name = "Kill Aura Range",
            Min = 0,
            Max = 50,
            Default = settings.KA_Range,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "Range",
            Callback = function(v)
                settings.KA_Range = v
            end
        })
    end

    local skillsData = Database:WaitForChild("Skills")
    local skill_classes = {}
    for _, v in skillsData:GetChildren() do
        if v:FindFirstChild("Class") then
            skill_classes[v.Class.Value] = v.Name
        end
    end

    local style
    local hotkeys = Profile.Hotkeys
    local skills = Profile.Skills

    local skillauraing = {}
    range.Touched:Connect(function(touching)
        if skillauraing[touching] then
            return
        end

        skillauraing[touching] = true
        if settings.SkillAura and touching.Parent ~= char and touching.Name == "HumanoidRootPart" then
            local enemy = touching.Parent
            local mob = table.find(mobs_on_floor[placeid], enemy.Name)
            local boss = table.find(bosses_on_floor[placeid], enemy.Name)

            if not boss and not mob then
                return
            end

            local health2 = getMobHealth(enemy)
            if hasMaxStamina and health2 and health2.Value > 0 then
                style = CalculateCombatStyle(false)

                local skill = skill_classes[style]
                if skill then
                    pauseKillAura = true

                    wait(1)

                    for _ = 1, 10 do
                        if health2.Value > 0 and stamina.Value > 20 then
                            Event:FireServer("Skills", {"UseSkill", skill, {}})
                            Event:FireServer("Combat", remote_key, {"Attack", enemy, skill, "2"})
                            wait(.2)
                        end
                    end

                    wait(1)

                    pauseKillAura = false
                end
            end
        end

        skillauraing[touching] = nil
    end)

    combat:AddToggle({
        Name = "Skill Aura",
        Default = false,
        Callback = function(bool)
            if level < 22 then
                return lib:MakeNotification({
                    Name = "Your Level is Not High Enough",
                    Content = "Reach Level 22 Before Using Skill Aura",
                    Image = "",
                    Time = 5
                })
            end

            settings.SkillAura = bool
        end
    })

    local autoce
    combat:AddToggle({
        Name = "Auto Cursed Enhancement (6s cooldown after done)",
        Default = false,
        Callback = function(bool)
            autoce = bool
        end
    })

    combat:AddToggle({
        Name = "Auto Heal (25s cooldown)",
        Default = false,
        Callback = function(bool)
            autoheal = bool
            if bool then
                Heal()
            end
        end
    })

    local lastcd = 0
    range.Touched:Connect(function(touching)
        local enemy = touching.Parent
        local mob = table.find(mobs_on_floor[placeid], enemy.Name)
        local boss = table.find(bosses_on_floor[placeid], enemy.Name)

        if not boss and not mob then
            return
        end

        local t = os.time()
        if skills:FindFirstChild("Cursed Enhancement") and t - lastcd >= 16 and autoce and stamina.Value >= 30 then
            lastcd = t
            Event:FireServer("Skills", {"UseSkill", "Cursed Enhancement", {}})
        end
    end)
end

local dismantle = {}
local rates = setmetatable({Burst = .06, Tribute = .05, Legendary = .05}, {
    __index = function(self, i)
        self[i] = .04
        return .04
    end
})

local ui_module = Services.UI
local dismantler_module = require(ui_module.Dismantle)
local GetItemData = inventory_module.GetItemData
local isEquipped = getfenv(GetItemData).isEquipped

local upgrade_amount = {
    Burst = 25,
    Legendary = 20,
    Tribute = 20,
    Rare = 15,
    Uncommon = 10,
    Common = 10
}

local function GetItemImage(ItemData)
    local image = ItemData.image
    if image then
        return image
    end

    local icon = ItemData.icon
    local response2 = request({
        Url = "https://www.roblox.com/library/" .. match(icon, "%d+"),
        Method = "GET"
    })

    local s = split(response2.Body, "https://tr.rbxcdn.com/")[2]
    local more = split(s, "'")
    local url = "https://tr.rbxcdn.com/" .. more[1]
    ItemData.image = url
    return url
end

local ItemDatas = {}
for _, v in Database:WaitForChild("Items"):GetChildren() do
    spawn(function()
        local ItemData = GetItemData(v)
        if ItemData.Type == "Weapon" or ItemData.Type == "Clothing" then
            local stats = ItemData.stats
            local base
            for _, v2 in stats do
                if v2[1] == "Damage" or v2[1] == "Defense" then
                    base = v2[2]
                    ItemData.base = base
                    break
                end
            end
            
            local rarity = ItemData.rarity
            local upgrades = upgrade_amount[rarity]
            ItemData.potential = math.floor(base + (base * rates[rarity] * upgrades))
        end

        ItemDatas[v.Name] = ItemData
    end)
end

local function getUpgrade(item)
    local upgrade = item:FindFirstChild("Upgrade")
    return upgrade and upgrade.Value or 0
end

do
    --[[
    formulas

    non legends: math.floor(base + (base * 0.04 * upgrade_count))
    legends: math.floor(base + (base * 0.05 * upgrade_count))

    ------

    local damage = 50612
    local base = 20245
    local upgrade = 25
    local rate = string.format("%.2f", (damage - base) / (base * upgrade))
    print(rate)
    ]]

    local farm_tab2 = window:MakeTab("Farm Tab util")

    local function AutoEquip()
        if not settings.AutoEquip then
            return
        end

        wait(1)

        local highest_damage = 0
        local highest_defense = 0
        local highest_weapon
        local highest_armor

        for _, item in Inventory:GetChildren() do
            local ItemData = ItemDatas[item.Name]

            local class = ItemData.Type
            if class ~= "Weapon" and class ~= "Clothing" then
                continue
            end

            if ItemData.level > level then
                continue
            end

            local base = ItemData.base
            local upgrades = getUpgrade(item)
            local rarity = ItemData.rarity
            local stat = math.floor(base + (base * rates[rarity] * upgrades))

            if class == "Weapon" then
                if stat > highest_damage then
                    highest_damage = stat
                    highest_weapon = item
                end

            elseif class == "Clothing" then
                if stat > highest_defense then
                    highest_defense = stat
                    highest_armor = item
                end
            end
        end

        if highest_weapon then
            rf:InvokeServer("Equipment", {"EquipWeapon", highest_weapon, "Right"})
        end

        if highest_armor then
            rf:InvokeServer("Equipment", {"Wear", highest_armor})
        end
    end

    Inventory.ChildAdded:Connect(AutoEquip)
    farm_tab2:AddToggle({
        Name = "Auto Equip Best Equipment",
        Default = false,
        Callback = function(bool)
            settings.AutoEquip = bool
            AutoEquip()
        end
    })

    local function AutoDismantle(item)
        wait(1)

        if item:FindFirstChild("Count") then
            return
        end

        if dismantle[ItemDatas[item.Name].rarity] then
            Event:FireServer("Equipment", {"Dismantle", {item}})
        end
    end

    local delete
    farm_tab2:AddToggle({
        Name = "Auto Delete Commons (common = useless)",
        Default = false,
        Callback = function(bool)
            delete = bool
        end
    })
    
    for i, v in names do
        farm_tab2:AddToggle({
            Name = "Auto Dismantle " .. v,
            Default = false,
            Callback = function(bool)
                local rarity = rarities[i]
                dismantle[rarity] = bool
            end
        })
    end

    Inventory.ChildAdded:Connect(AutoDismantle)
    Inventory.ChildAdded:Connect(function(v)
        if delete and ItemDatas[item.Name].rarity == "Common" then
            rf:InvokeServer("Equipment", {"Delete", v})
        end
    end)
end

do
    local farm_tab3 = window:MakeTab("Farm Exclusion")

    for _, mob_name in all_on_floor do
        farm_tab3:AddToggle({
            Name = mob_name,
            Default = MobExclusion[mob_name] == true,
            Callback = function(bool)
                MobExclusion[mob_name] = bool
            end
        })
    end
end

do
    local AutofarmYOffsetTab = window:MakeTab("AF Y Offsets")

    for i, mob_name in all_on_floor do
        if not Autofarm_Y_Offsets[mob_name] then
            Autofarm_Y_Offsets[mob_name] = 15
        end

        if UserInputS.TouchEnabled then
            AutofarmYOffsetTab:AddTextbox({
                Name = mob_name .. " 0-50",
                Default = tostring(Autofarm_Y_Offsets[mob_name]),
                TextDisappear = false,
                Callback = function(text)
                    local a = tonumber(text)
                    if a and a >= 0 and a <= 50 then
                        Autofarm_Y_Offsets[mob_name] = a
                    end
                end
            })
        else
            AutofarmYOffsetTab:AddSlider({
                Name = mob_name,
                Min = 0,
                Max = 50,
                Default = Autofarm_Y_Offsets[mob_name],
                Color = Color3.new(255, 255, 255),
                Increment = 1,
                ValueName = "Y Offset",
                Callback = function(v)
                    Autofarm_Y_Offsets[mob_name] = v
                end
            })
        end
    end
end

do
    local equiphigher_tab = window:MakeTab("Item Level Req Bypass")
    equiphigher_tab:AddParagraph("Enabled by default. Equip items from inventory // made by wally")

    local CardinalClient = (function()
    	for i, v in next, getreg() do
    		if type(v) == "table" and rawget(v, 'Services') then
    			return v
    		end
    	end
    end)()
    
    local ReplicatedStorage = game:GetService('ReplicatedStorage')
    local ItemDatabase = ReplicatedStorage:WaitForChild('Database'):WaitForChild('Items')
    
    local PlrProfile = ReplicatedStorage:WaitForChild('Profiles'):WaitForChild(game.Players.LocalPlayer.Name)
    local PlrInventory = PlrProfile:WaitForChild('Inventory')
    
    local UI = CardinalClient.Services.UI;
    local UIScript = getfenv(UI.SafeInit).script
    
    local Inventory = require(UIScript.Inventory)
    local Util = CardinalClient.Services
    
    _G['HasRequiredLevel'] = _G['HasRequiredLevel'] or Inventory.HasRequiredLevel
    _G['GetOptions'] = _G['GetOptions'] or Inventory.GetOptions
    _G['ItemAction'] = _G['ItemAction'] or Inventory.itemAction
    
    _G['EquipStore'] = {}
    
    local function FindSuitableInventoryItem(Target)
    	for _, Item in next, PlrInventory:GetChildren() do
    		local DatabaseEntry = ItemDatabase[Item.Name]
    		if DatabaseEntry then
    			local ItemType = DatabaseEntry.Type.Value
    			if ItemType == Target.Type.Value then
    				return {
    					Name = Item.Name,
    					Value = _G['LastSelectedItem'].Value,
    				}
    			end
    		end
    	end
    end
    
    function Inventory.GetOptions(...)
    	local input = ...
    	if type(input) == 'table' then
    		_G['LastSelectedItem'] = input.item
    	end
    	return _G['GetOptions'](...)
    end
    
    function Inventory.HasRequiredLevel(...)
    	local item = ...;
    	if item then
    		local replacement = FindSuitableInventoryItem(item)
    		if replacement then
    			_G['EquipStore'][_G['LastSelectedItem']] = replacement
    			return true
    		end
    	end
    	return _G['HasRequiredLevel'](...)
    end
    
    function Inventory.itemAction(...)
    	local input, func = ...
    	if type(input) == 'table' and _G.EquipStore[input.item] then
    		input.item = _G['EquipStore'][input.item]
    	end
    	return _G['ItemAction'](...)
    end
end

do
    local autoflag_tab = window:MakeTab("Auto Flag")

    local autoflag
    autoflag_tab:AddToggle({
        Name = "Auto Flag",
        Default = false,
        Callback = function(bool)
            autoflag = bool
        end
    })

    local Whitelist = settings.Whitelist
    autoflag_tab:AddButton({
        Name = "Flag everyone not on whitelist",
        Callback = function(bool)
            for i, p in Players:GetChildren() do
                if p ~= plr and not Whitelist[p.Name] then
                    Event:FireServer("Moderator", "Report", p)
                end
            end
        end
    })

    local toggles = {}
    local function CreateAutoFlagToggle(p)
        toggles[p] = autoflag_tab:AddToggle({
            Name = `Whitelist {p.Name}`,
            Default = Whitelist[p.Name],
            Callback = function(bool)
                Whitelist[p.Name] = bool
            end
        })
    end

    for i, p in Players:GetChildren() do
        if p ~= plr then
            CreateAutoFlagToggle(p)
        end
    end

    Players.PlayerAdded:Connect(function(p)
        CreateAutoFlagToggle(p)
        if autoflag then
            Event:FireServer("Moderator", "Report", p)
        end
    end)

    Players.PlayerRemoving:Connect(function(p)
        toggles[p]:Remove()
    end)
end

do
    if firetouchinterest then
        local teleports_tab = window:MakeTab("Teleports")

        local function makehuntertp()
            local huntertweens = {}
            teleports_tab:AddToggle({
                Name = "Hunter",
                Default = false,
                Callback = function(bool)
                    tpingtohunter = bool
                    
                    if not bool then
                        local tween = huntertweens[#huntertweens]
                        if tween then
                            tween:Cancel()
                        end

                        table.clear(huntertweens)
                    end

                    while tpingtohunter do
                        local huntercframe = CFrame.new(1635, 330, 3742)
                        local seconds = (hrp.Position - huntercframe.Position).Magnitude / 80
                        local tween_info = TweenInfo.new(seconds, Enum.EasingStyle.Linear)
                        local huntertween = TweenS:Create(hrp, tween_info, {CFrame = huntercframe})
                        huntertweens[#huntertweens + 1] = huntertween
                        
                        huntertween:Play()
                        wait()
                    end
                end
            })
        end

        local function makespecialtpbutton(name, pos)
            spawn(function()
                plr:RequestStreamAroundAsync(pos, 3)
                wait(1)

                local totouch
                if name == "Atheon (changes servers)" then
                    totouch = workspace.AtheonPortal
                else
                    totouch = GetClosestPartFromVector(pos)
                end
                
                teleports_tab:AddButton({
                    Name = name,
                    Callback = function()
                        Tp(totouch)
                    end
                })
            end)
        end

        local function makeTPbutton(name, part)
            teleports_tab:AddButton({
                Name = name,
                Callback = function()
                    Tp(part)
                end
            })
        end

        local function loop_workspace(entrance, boss, miniboss, shop)
            local totouch1 = entrance and GetClosestPartFromVector(entrance)
            local totouch2 = boss and GetClosestPartFromVector(boss)
            local totouch3 = miniboss and GetClosestPartFromVector(miniboss)
            local totouch4 = shop and GetClosestPartFromVector(shop)
            if totouch1 then
                makeTPbutton("Dungeon Entrance", totouch1)
            end

            if totouch2 then
                makeTPbutton("Boss Room", totouch2)
            end

            if totouch3 then
                makeTPbutton("Mini Boss", totouch3)
            end

            if totouch4 then -- floor 10
                makeTPbutton("Shop", totouch4)
            end
        end

        if placeid == 542351431 then -- floor 1
            local dungeon_entrance = Vector3.new(-1181, 70, 308)
            local miniboss = Vector3.new(139, 225, -132)
            local boss = Vector3.new(-2942, -125, 336)
            loop_workspace(dungeon_entrance, boss, miniboss)
        
        elseif placeid == 548231754 then -- floor 2
            local dungeon_entrance = Vector3.new(-2185, 161, -2321)
            local boss = Vector3.new(-2943, 201, -9805)
            loop_workspace(dungeon_entrance, boss)

        elseif placeid == 555980327 then -- floor 3
            local dungeon_entrance = Vector3.new(1179, 6737, 1675)
            local boss = Vector3.new(448, 4279, -385)
            makespecialtpbutton("Boss Room", boss)
            loop_workspace(dungeon_entrance)

        elseif placeid == 572487908 then -- floor 4
            local dungeon_entrance = Vector3.new(-1946, 5169, -1415)
            local boss = Vector3.new(-2319, 2280, -515)
            loop_workspace(dungeon_entrance, boss)

        elseif placeid == 580239979 then -- floor 5
            local dungeon_entrance = Vector3.new(-1562, 4040, -868)
            local boss = Vector3.new(2189, 1308, -122)
            loop_workspace(dungeon_entrance, boss)

        elseif placeid == 582198062 then -- floor 7
            local dungeon_entrance = Vector3.new(1219, 1083, -274)
            local boss = Vector3.new(3347, 800, -804)
            makespecialtpbutton("Dungeon Entrance", dungeon_entrance)
            makespecialtpbutton("Boss", boss)
        
        elseif placeid == 548878321 then -- floor 8
            local dungeon_entrance = Vector3.new(-6679, 7801, 10006)
            local boss = Vector3.new(1848, 4110, 7723)
            local miniboss = Vector3.new(-808, 3174, -941)
            loop_workspace(dungeon_entrance, boss, miniboss)

        elseif placeid == 573267292 then -- floor 9
            local dungeon_entrance = Vector3.new(878, 3452, -11139)
            local boss = Vector3.new(12241, 461, -3656)
            local miniboss_gargoyle = Vector3.new(-256, 3077, -4605)
            local miniboss_poly = Vector3.new(1973, 2986, -4487)
            loop_workspace(dungeon_entrance, boss, miniboss_gargoyle)
            loop_workspace(nil, nil, miniboss_poly)
        
        elseif placeid == 2659143505 then -- floor 10
            local miniboss = Vector3.new(-895, 467, 6505)
            local boss = Vector3.new(45, 1003, 25432)
            local dungeon_entrance = Vector3.new(-606, 697, 9989)
            local shop = Vector3.new(-252, 504, 6163)
            loop_workspace(dungeon_entrance, boss, miniboss, shop)

        elseif placeid == 5287433115 then -- floor 11
            local DaRaKa = Vector3.new(4801, 1646, 2083)
            local Za = Vector3.new(4001, 421, -3794)
            local duality_reaper = Vector3.new(4763, 501, -4344)
            local neon_chest = Vector3.new(5204, 2294, 5778)
            local sauraus = Vector3.new(5333, 3230, 5589)
            makespecialtpbutton("Duality Reaper", duality_reaper)
            makespecialtpbutton("Da, Ra, Ka", DaRaKa)
            makespecialtpbutton("Za", Za)
            makespecialtpbutton("Neon Chest", neon_chest)
            makespecialtpbutton("Boss Room", sauraus)

        elseif placeid == 6144637080 then -- floor 12
            local Warlord = Vector3.new(-714, 143, 4961)
            local Atheon = Vector3.new(-2415, 129, 6344)
            local RadioactiveExperiment = Vector3.new(-2290, 242, 3090)
            local SuspendedUnborn = Vector3.new(-5325, 428, 3754)
            makespecialtpbutton("Atheon (changes servers)", Atheon)
            makespecialtpbutton("Warlord", Warlord)
            makespecialtpbutton("Radioactive Experiment", RadioactiveExperiment)
            makespecialtpbutton("Suspended Unborn", SuspendedUnborn)
            makehuntertp()
        
        elseif placeid == 11331145451 then -- halloween
            local a = Vector3.new(1679, 104, -349)
            loop_workspace(a)
        end
    end
end

local fps = getfpscap and getfpscap() or 60
do
    local Character_tab = window:MakeTab("Character")

    local animSettings = Profile:WaitForChild("AnimSettings")

    local Animations = {}
    local blacklisted = {"Dagger", "SwordShield", "Daggers", "Misc"}
    for _, v in Database:WaitForChild("Animations"):GetChildren() do
        if table.find(blacklisted, v.Name) then 
            continue 
        end

        table.insert(Animations, v.Name)
        if not animSettings:FindFirstChild(v.Name) then
            local string_value = Instance.new("StringValue")
            string_value.Name = v.Name
            string_value.Value = ""
            string_value.Parent = animSettings
        end
    end
    
    --[[
        Character_tab:AddDropdown({
            Name = "Weapon Animations",
            Default = CalculateCombatStyle(),
            Options = Animations,
            Callback = function(animation)
                settings.Weapon_Animation = animation
            end
        })
    ]]
    
    local OldCalculateCombatStyle = CalculateCombatStyle
    combat_module.CalculateCombatStyle = function(bool)
        if getfenv(2) == getfenv(1) and bool == nil then
            return settings.Weapon_Animation
        end

        if bool == false then
            return OldCalculateCombatStyle(bool)
        end

        return settings.Weapon_Animation
    end

    CalculateCombatStyle = combat_module.CalculateCombatStyle

    Character_tab:AddToggle({
        Name = "Always Swing Animation",
        Default = false,
        Callback = function(bool) 
            alwaysswinganimation = bool
        end
    })

    Character_tab:AddToggle({
        Name = "Infinite Jump",
        Default = false,
        Callback = function(bool)
            settings.InfJump = bool
        end
    })

    Character_tab:AddToggle({
        Name = "Spirit Dash not consume stamina",
        Default = false,
        Callback = function(bool)
            infspiritdash = bool
        end
    })

    local pressing
    UserInputS.InputBegan:Connect(function(key, processed)
        if processed or not settings.InfJump then
            return
        end

        if key.KeyCode == Enum.KeyCode.Space then
            pressing = true
            while pressing do
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    wait(1/10)
                end)
            end
        end
    end)

    UserInputS.InputEnded:Connect(function(key, processed)
        if processed or not settings.InfJump then
            return
        end

        if key.KeyCode == Enum.KeyCode.Space then
            pressing = false
        end
    end)

    Character_tab:AddToggle({
        Name = "No Clip",
        Default = false,
        Callback = function(bool)
            settings.NoClip = bool
        end
    })

    Character_tab:AddToggle({
        Name = "Infinite Sprint",
        Default = false,
        Callback = function(bool)
            settings.InfSprint = bool
        end
    })

    local skillhandlers = require(Services.Skills).skillHandlers
    local whirlspin = skillhandlers["Whirlwind Spin"]
    local Equip = Profile:WaitForChild("Equip")
    local function SpeedGlitch()
        local temp = alwaysswinganimation
        alwaysswinganimation = false

        local leftval = Equip.Left.Value
        local rightval = Equip.Right.Value

        local leftwep
        local rightwep
        local longswordleft
        local longswordright
        for i, v in Inventory:GetChildren() do
            local ItemData = ItemDatas[v.Name]
            if ItemData.classname == "Longsword" then
                if longswordleft then
                    longswordright = v
                else
                    longswordleft = v
                end
            end

            if v.Value == leftval then
                leftwep = v

            elseif v.Value == rightval then
                rightwep = v
            end
        end
        
        if longswordleft and longswordright then
            rf:InvokeServer("Equipment", {"EquipWeapon", longswordright, "Right"})
            rf:InvokeServer("Equipment", {"EquipWeapon", longswordleft, "Left"})
            wait(.5)
        end

        spawn(whirlspin)

        if rightwep then
            rf:InvokeServer("Equipment", {"EquipWeapon", rightwep, "Right"})
        end

        if leftwep then
            rf:InvokeServer("Equipment", {"EquipWeapon", leftwep, "Left"})
        end

        wait(.7)
    
        setfpscap(1)
        wait()
        setfpscap(fps)

        alwaysswinganimation = temp
    end

    Character_tab:AddButton({
        Name = "Speed Glitch",
        Callback = SpeedGlitch
    })

    local speedglitchbind = Character_tab:AddBind({
        Name = "Speed Glitch Keybind",
        Default = settings.SpeedGlitchBind,
        BindSetCallback = function(key)
            settings.SpeedGlitchBind = key
        end,
        Callback = SpeedGlitch
    })

    local walkspeed = humanoid.WalkSpeed
    if UserInputS.TouchEnabled then
        Character_tab:AddTextbox({
            Name = "WalkSpeed",
            Default = "20",
            TextDisappear = false,
            Callback = function(text)
                local n = tonumber(text)
                if n and n >= 0 and n <= 100 then
                    walkspeed = n 
                end
            end
        })
    else
        Character_tab:AddSlider({
            Name = "WalkSpeed",
            Min = 0,
            Max = 100,
            Default = walkspeed,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "Speed",
            Callback = function(speed)
                walkspeed = speed
            end
        })
    end

    spawn(function()
        while true do
            if not sprinting then
                humanoid.WalkSpeed = walkspeed
            end
    
            wait(.1)
        end
    end)
end

do
    local Smithing = window:MakeTab("Smithing")
    local function Dismantle_Rarity(rarity)
        local items = {}
        for _, item in Inventory:GetChildren() do
            if isEquipped(item) then
                continue
            end

            local ItemData = ItemDatas[item.Name]
            if ItemData.rarity == rarity then
                if not item:FindFirstChild("Count") then
                    table.insert(items, item)
                end
            end
        end

        if #items > 0 then
            Event:FireServer("Equipment", {"Dismantle", items})
        end
    end

    local crystalForge_module = require(ui_module.CrystalForge)
    Smithing:AddButton({
        Name = "Open Crystal Forge",
        Callback = crystalForge_module.Open 
    })

    local upgrade_module = require(ui_module.Upgrade)
    Smithing:AddButton({
        Name = "Open Upgrader",
        Callback = upgrade_module.Open
    })

    Smithing:AddButton({
        Name = "Open Dismantler",
        Callback = dismantler_module.Open
    })

    Smithing:AddButton({
        Name = "Delete All Commons",
        Callback = function()
            for _, item in Inventory:GetChildren() do
                if isEquipped(item) then
                    continue
                end

                if ItemDatas[item.Name].rarity == "Common" and not item:FindFirstChild("Count") then
                    rf:InvokeServer("Equipment", {"Delete", item})
                end
            end
        end
    })

    for i, v in names do
        Smithing:AddButton({
            Name = "Dismantle All " .. v,
            Callback = function()
                if create_confirm("Confirm Dismantle?") then
                    Dismantle_Rarity(rarities[i])
                end
            end
        })
    end
end

do
    local Stats = window:MakeTab("Session Stats")

    local time_label = Stats:AddLabel("Elapsed Time")
    spawn(function()
        local floor = math.floor
        while true do wait(1)
            local seconds = floor(time())
            local minutes = floor(seconds / 60)
            seconds = seconds - 60 * minutes

            local hours = floor(minutes / 60)
            minutes = minutes - 60 * hours

            local days = floor(hours / 24)
            hours = hours - 24 * days

            local o1 = days == 1 and "Day" or "Days"
            local o2 = hours == 1 and "Hour" or "Hours"
            local o3 = minutes == 1 and "Minute" or "Minutes"
            local o4 = seconds == 1 and "Second" or "Seconds"

            local displayed = `{days} {o1} | {hours} {o2} | {minutes} {o3} | {seconds} {o4}`
            time_label:Set("Time Elapsed: " .. displayed)
        end
    end)

    local ping_everyone
    if request then
        local ignored_rarities = {}
        local webhook_toggle
        Inventory.ChildAdded:Connect(function(c)
            if not webhook_toggle then
                return
            end

            local webhookURL = settings.WebhookURL

            local ItemData = ItemDatas[c.Name]
            local item_class = ItemData.Type
            if item_class ~= "Weapon" and item_class ~= "Clothing" then
                return
            end

            local item_rarity = ItemData.rarity
            if ignored_rarities[item_rarity] then
                return
            end

            local item_name = ItemData.name
            local item_image = GetItemImage(ItemData)

            local item_potential = tostring(ItemData.potential)
            local item_base = tostring(ItemData.base)
            local item_level = tostring(ItemData.level)
            local shouldInline = settings.Inline

            request({
                Url = webhookURL,
                Method = "POST",
                Body = HttpS:JSONEncode({
                    content = ping_everyone and "@everyone",
                    username = "i <3 swordburst 2",
                    embeds = {{
                        title = `{item_rarity} Rarity Item Drop ({item_name})`,
                        color = 16711680,
                        fields = {{
                            name = "Item Level",
                            value = item_level,
                            inline = shouldInline
                        }, {
                            name = "Item Class",
                            value = item_class,
                            inline = shouldInline
                        }, {
                            name = "Item Base",
                            value = item_base,
                            inline = shouldInline
                        }, {
                            name = "Item Potential",
                            value = item_potential,
                            inline = shouldInline
                        }},
                        image = {
                            url = item_image
                        }
                    }}
                }),
                Headers = {["Content-Type"] = "application/json"}
            })
        end)

        Stats:AddToggle({
            Name = "Webhook Toggle",
            Default = false,
            Callback = function(bool)
                webhook_toggle = bool
            end
        })
        
        local function WebhookErr(err)
            lib:MakeNotification({
                Name = err,
                Content = "Didn't set URL",
                Image = "",
                Time = 5
            })
        end

        Stats:AddTextbox({
            Name = "Item Drop Webhook URL",
            Default = settings.WebhookURL,
            TextDisappear = true,
            Callback = function(url)
                url = url:gsub(" ", "")
                if not url:find("https://discord.com/api/webhooks/") and not url:find("https://discordapp.com/api/webhooks/") then
                    return WebhookErr("Domain not Discord")
                end

                local response = request({
                    Url = url,
                    Method = "GET"
                })

                if response.Success then
                    lib:MakeNotification({
                        Name = "Successfully set webhook url",
                        Content = "",
                        Image = "",
                        Time = 5
                    })

                    settings.WebhookURL = url
                else
                    WebhookErr("Nonexistent Webhook URL")
                end
            end
        })

        Stats:AddToggle({
            Name = "Ping @everyone",
            Default = false,
            Callback = function(bool)
                ping_everyone = bool
            end
        })

        Stats:AddToggle({
            Name = "Inline Webhook Output (may look nicer)",
            Default = settings.Inline,
            Callback = function(bool)
                settings.Inline = bool
            end
        })

        for i, v in names do
            Stats:AddToggle({
                Name = "Webhook Ignore Rarity | " .. v,
                Default = false,
                Callback = function(bool)
                    local rarity = rarities[i]
                    ignored_rarities[rarity] = bool
                end
            })
        end
    end
end

do
    local FastTrade = window:MakeTab("Crystal Trade")
    
    local Amount = 0
    if UserInputS.TouchEnabled then
        FastTrade:AddTextbox({
            Name = "Change # of Upgrade Crystals added",
            Default = "",
            TextDisappear = false,
            Callback = function(n)
                Amount = tonumber(n)
            end
        })
    else
        FastTrade:AddSlider({
            Name = "Change # of Upgrade Crystals added",
            Min = 0,
            Max = 128,
            Default = 1,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "Crystals",
            Callback = function(v)
                Amount = v
            end
        })
    end

    for i, v in rarities do
        FastTrade:AddButton({
            Name = `Add {v} Upgrade Crystals`,
            Callback = function()
                local Item = Inventory:FindFirstChild(v .. " Upgrade Crystal")
                if Item and Item.Count.Value >= Amount then
                    for i = 1, Amount do
                        Event:FireServer("Trade", "TradeAddItem", {Item})
                        wait(.1)
                    end
                end
            end
        })
    end
end

do
    local Performance_tab = window:MakeTab("Perf Boosters")

    if not UserInputS.TouchEnabled then
        Performance_tab:AddSlider({
            Name = "FPS Cap",
            Min = 1,
            Max = 1000,
            Default = fps,
            Color = Color3.new(255, 255, 255),
            Increment = 1,
            ValueName = "FPS",
            Callback = function(v)
                fps = v
                setfpscap(v)
            end
        })
    end

    local screen = game.CoreGui.ScreenGui
    local frame = Instance.new("Frame")
    frame.Position = UDim2.fromOffset(0, -50)
    frame.Parent = screen
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local label = Instance.new("TextLabel")
    label.Text = "AFK"
    label.Parent = frame
    label.TextSize = 30
    label.TextColor3 = Color3.fromRGB(255, 0, 0)

    local cam = workspace.CurrentCamera
    local vp = cam.ViewportSize
    frame.Size = UDim2.fromOffset(vp.X, vp.Y + 50)
    label.Position = UDim2.fromOffset(vp.X/2, vp.Y/2)

    cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        vp = cam.ViewportSize
        frame.Size = UDim2.fromOffset(vp.X, vp.Y + 50)
        label.Position = UDim2.fromOffset(vp.X/2, vp.Y/2)
    end)

    local circle
    if Drawing then
        circle = Drawing.new("Circle")
        circle.Radius = 15
        circle.Filled = true
        circle.Color = Color3.fromRGB(255, 0, 0)
        circle.Visible = false
        game.UserInputService.InputChanged:Connect(function(input, processed)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = input.Position
                circle.Position = Vector2.new(pos.X, pos.Y + 40)
            end
        end)
    end

    Performance_tab:AddToggle({
        Name = "Disable 3d rendering",
        Default = false,
        Callback = function(bool)
            pcall(function()
                if circle then
                    circle.Visible = bool
                end
            end)

            RunS:Set3dRenderingEnabled(not bool)
            frame.Visible = bool
        end
    })

    local hiteffects = workspace:WaitForChild("HitEffects")
    Performance_tab:AddToggle({
        Name = "Remove Hit Effects",
        Default = false,
        Callback = function(bool)
            if bool then
                hiteffects.Parent = nil
            else
                hiteffects.Parent = workspace
            end
        end
    })

    local textureremove
    local function DeleteTextures(v)
        if not textureremove then return end

        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("PointLight") then
            v.Enabled = false

        elseif v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0

        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1

        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)

        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1

        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 0
        end
    end

    game.DescendantAdded:Connect(DeleteTextures)

    local Terrain = workspace.Terrain
    local Lighting = game.Lighting
    Performance_tab:AddButton({
        Name = 'FPS BOOSTER TEXTURE DELETER',
        Callback = function()
            if textureremove then
                return
            end

            textureremove = true

            sethiddenproperty(workspace.Terrain, "Decoration", false)
            
            for i, v in game:GetDescendants() do
                DeleteTextures(v)
            end

            while true do
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 0
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 0
                wait(1)
            end
        end
    })

    local graphics = require(Services.Graphics)
    local effects = getupvalue(graphics.DoEffect, 1)

    for i, v in effects do
        if i == "Slash Trail" then
            Performance_tab:AddToggle({
                Name = "No Slash Trails",
                Default = false,
                Callback = function(bool)
                    noslashtrails = bool

                    spawn(RemoveTrail, humanoid)
                    for i, v in othercharacters do
                        spawn(RemoveTrail, v:WaitForChild("Humanoid"))
                    end
                end
            })

            continue
        end

        local DisableEffect
        Performance_tab:AddToggle({
            Name = "Remove " .. i,
            Default = false,
            Callback = function(bool)
                DisableEffect = bool
            end
        })

        effects[i] = function(...)
            if DisableEffect then
                return
            end

            return v(...)
        end
    end

    local tomute = false
    local sound_names = {"SwordHit", "Unsheath", "SwordSlash"}
    local sounds = {}

    for _, v in workspace:GetDescendants() do
        if table.find(sound_names, v.Name) then
            sounds[v] = v
        end
    end

    local function muteswings(descendant)
        if table.find(sound_names, descendant.Name) then
            sounds[descendant] = descendant
            descendant.Volume = tomute and 0 or .3
        end
    end

    workspace.DescendantAdded:Connect(muteswings)
    workspace.DescendantRemoving:Connect(function(descendant)
        sounds[descendant] = nil
    end)

    Performance_tab:AddToggle({
        Name = "Mute Swing Sounds",
        Default = false,
        Callback = function(bool)
            tomute = bool
            for _, v in sounds do
                v.Volume = tomute and 0 or .3
            end
        end
    })
end

do
    local Misc_tab = window:MakeTab("Misc")

    local players_names = {}
    for _, v in Players:GetPlayers() do
        table.insert(players_names, v.Name)
    end

    local inventory_viewer = Misc_tab:AddDropdown({
        Name = "Inventory Viewer (Open Inventory)",
        Default = plr.Name,
        Options = players_names,
        Callback = function(player)
            setupvalue(inventory_module.GetInventoryData, 2, Profiles[player])
        end
    })

    local function update_inventoryViewer_list(player)
        local names = {}
        for _, v in Players:GetPlayers() do
            if not player or player.Name ~= v.Name then
                table.insert(names, v.Name)
            end
        end

        inventory_viewer:Refresh(names, true)
    end

    Players.PlayerAdded:Connect(function(player)
        while not Profiles:FindFirstChild(player.Name) do
            wait(1)
        end

        update_inventoryViewer_list()
    end)

    Players.PlayerRemoving:Connect(update_inventoryViewer_list)

    local playerui = plr.PlayerGui.CardinalUI.PlayerUI
    local scrollcontent = playerui.Chat.ScrollContent
    local alwayschatscroll
    local newidx; newidx = hookmetamethod(game, "__newindex", function(self, i, v)
        if self == scrollcontent and i == "ScrollingEnabled" and alwayschatscroll then
            v = true
        end
        
        return newidx(self, i, v)
    end)

    Misc_tab:AddToggle({
        Name = 'chat scroll while moving',
        Default = false,
        Callback = function(bool)
            alwayschatscroll = bool
        end
    })

    local autochatscroll
    scrollcontent.ChildAdded:Connect(function()
        wait(.1)

        if autochatscroll then
            scrollcontent.CanvasPosition = Vector2.new(0, scrollcontent.CanvasSize.Y.Offset - scrollcontent.AbsoluteSize.Y)
        end
    end)

    Misc_tab:AddToggle({
        Name = "Auto chat Scroll",
        Default = false,
        Callback = function(bool)
            autochatscroll = bool
        end
    })

    Misc_tab:AddToggle({
        Name = "Infinite Zoom Distance",
        Default = false,
        Callback = function(bool)
            if bool then
                plr.CameraMaxZoomDistance = math.huge
            else
                plr.CameraMaxZoomDistance = 15
            end
        end
    })

    Misc_tab:AddBind({
        Name = "GUI Keybind",
        Default = settings.GuiBind,
        Hold = false,
        Callback = function()
            orion.Enabled = not orion.Enabled
        end,
        BindSetCallback = function(key)
            settings.GuiBind = key
        end
    })
end

do
    local credits = window:MakeTab("Credits")

    credits:AddParagraph("Abuzzpoet")
end
