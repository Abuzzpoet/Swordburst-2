-- for me: loadfile('Scriptz/sb2 script.lua')()

if not game:IsLoaded() then game.Loaded:Wait() end

if syn then -- synapse
    syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()")
    
elseif queue_on_teleport then -- krnl
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()") 
    
else
    warn"failed to find execute on teleport function"
end

local Players = game:GetService("Players")
local Rs = game:GetService("ReplicatedStorage")

local place_id = game.PlaceId

local floor_data = require(Rs.Database.Locations)

local floor_ids = {}
for i, v in next, floor_data.floors do -- probably remove this
    for i2, v2 in next, v do
        if i2 == "PlaceId" then
           floor_ids[i] = v2
        end
    end
end

local plr = Players.LocalPlayer
getgenv().char = plr.Character or plr.CharacterAdded:Wait()
getgenv().hrp = char:WaitForChild("HumanoidRootPart")
getgenv().humanoid = char:WaitForChild("Humanoid")

getgenv().settings = {
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed,
    speed = false,
    InfSprint = false,
    AttackPlayers = false,
    Animation = getrenv()._G.CalculateCombatStyle
}

plr.CharacterAdded:Connect(function(new)
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end)

function recursive_find_module()
    for _, v in next, getnilinstances() do
        if v.Name == "MainModule" then
            return v
        end
    end 

    wait(.5)
    
    return recursive_find_module()
end

getgenv().game_module = recursive_find_module()

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local window = lib:MakeWindow({
    Name = "SB2 Script",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = false
})

do
    local farm_tab = window:MakeTab({
        Name = "Farm",
        Icon = "",
        PremiumOnly = false
    })

    local range = Instance.new("Part", workspace)
    range.Size = Vector3.new(25, 25, 25)
    range.CanCollide = false
    range.Transparency = 1

    game.RunService.RenderStepped:Connect(function()
        range.CFrame = char:GetPivot()
    end)

    local combat = require(game_module.Services.Combat)
    local hashed = getupvalues(combat.Init)[2]
    local Event = Rs.Event

    local ka
    getgenv().player_is_touching = nil
    farm_tab:AddToggle({
        Name = "Kill Aura (Improved)", -- now attacks multiple enemies at the same time
        Default = false,
        Callback = function(bool)
            settings.KA = bool

            local attacking = {} -- to overwrite attacking table when toggled off
            if bool then
                ka = range.Touched:Connect(function(touching)
                    player_is_touching = nil
                    
                    if settings.AttackPlayers then
                        for _, v in next, Players:GetChildren() do
                            if v ~= plr and v.Character then
                                if v.Character:FindFirstChild("HumanoidRootPart") == touching then
                                    player_is_touching = true
                                            
                                    break
                                end
                            end
                        end
                    end
                    
                    if player_is_touching or touching:FindFirstAncestor("Mobs") and touching.Name == "HumanoidRootPart" then
                        local enemy = touching.Parent
                        
                        if not table.find(attacking, enemy) then -- the touched event will spam - to prevent multiple attacking loops on the same mob
                            table.insert(attacking, enemy)
                            
                            while true do 
                                local i = table.find(attacking, enemy) -- update the position of the element enemy constantly
                                
                                local _, err = pcall(function()
                                    if enemy.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
                                end)

                                if err or enemy:FindFirstChild("Immortal") or (hrp.Position - touching.Position).Magnitude > settings.KA_Range then
                                    table.remove(attacking, i) -- if an enemy walks away but is still alive or it's dead or immortal
                                    
                                    break 
                                end
                                
                                Event:FireServer("Combat", hashed, {"Attack", nil, "1", enemy}) -- nil = skill (i think)
                                
                                wait(.3) 
                            end
                        end
                    end
                end)

            elseif ka then
                ka:Disconnect()
            end
        end
    })

    farm_tab:AddToggle({
        Name = "Attack Players",
        Default = false,
        Callback = function(bool)
            settings.AttackPlayers = bool
            player_is_touching = nil
        end
    })
    
    farm_tab:AddSlider({
        Name = "Kill Aura Range",
        Min = 0,
        Max = 25,
        Default = 20,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Range",
        Callback = function(v)
            settings.KA_Range = v
        end
    })
end

do 
    local teleports_tab = window:MakeTab({
        Name = "Teleports",
        Icon = "",
        PremiumOnly = false
    })
    local no_tp = {542351431, 582198062}

    for _, v in next, workspace:GetChildren() do
        if table.find(no_tp, place_id) then
            lib:MakeNotification({
                Name = "Can't TP",
                Content = "Can't TP. Teleport Not Supported On This Floor (f1 or f7)", --[[
                    these 2 floors have a lower streaming radius, (meaning parts dont spawn until u approach them) and it's not an editable property
                    
                    (https://developer.roblox.com/en-us/api-reference/property/Workspace/StreamingMinRadius)
                    ]]
                Image = "",
                Time = 10
            }) 

            break
        end

        if v.Name == "TeleportSystem" then
            for _, v2 in next, v:GetChildren() do
                teleports_tab:AddButton({
                    Name = "probably boss room", 
                    Callback = function() -- eventually make these show proper names (tower door seems possible)
                        firetouchinterest(hrp, v2, 0)
        
                        wait(.5)
                        
                        firetouchinterest(hrp, v2, 1)
                    end
                })
            end
        end
    end
end

do
    local Character_tab = window:MakeTab({
        Name = "Character",
        Icon = "",
        PremiumOnly = false
    })

    local animations = Rs.Database.Animations
    local profiles = Rs.Profiles
    local animSettings = profiles[plr.Name].AnimSettings

    local ANIMATIONS = {}
    for _, v in next, animations:GetChildren() do
        if v.Name ~= "Misc" and v.Name ~= "Spear" and v.Name ~= "Daggers" and v.Name ~= "Dagger" and v.Name ~= "SwordShield" then
            table.insert(ANIMATIONS, v.Name)
            
            if not animSettings:FindFirstChild(v.Name) then
                local string_value = Instance.new("StringValue", animSettings)
                
                string_value.Name = v.Name
                string_value.Value = ""
            end
        end
    end 

    Character_tab:AddDropdown({
        Name = "Weapon Animations (Breaks Skills For Now)", -- should probably just load my own animation tracks and stop theirs
        Default = getrenv()._G.CalculateCombatStyle(),
        Options = ANIMATIONS,
        Callback = function(animation)
            settings.Animation = animation
        end
    })

    local combat = require(game_module.Services.Combat)
    
    hookfunction(combat.CalculateCombatStyle, function()
        return settings.Animation  -- the game uses this function for both animations & skills so it breaks skills
    end)

    local invisibility
    Character_tab:AddToggle({
        Name = "Invisibility (Client Sided Character)", 
        Default = false, 
        Callback = function(bool)
            if bool then
                local old_root = char:FindFirstChild("Root", true)
                local new_root = old_root:Clone()

                new_root.Parent = old_root.Parent
                old_root:Destroy()

                invisibility = plr.CharacterAdded:Connect(function(new)
                    local old_root = new:WaitForChild("LowerTorso"):WaitForChild("Root")
                    local new_root = old_root:Clone()

                    new_root.Parent = old_root.Parent
                    old_root:Destroy()
                end)

            elseif invisibility then
                invisibility:Disconnect()
            end
        end
    })

    local Event = Rs.Event
    local infSprint; infSprint = hookmetamethod(game, "__namecall", function(self, ...)
        local ncm = getnamecallmethod()
        local args = {...}
        
        if settings.InfSprint then
            if self == Event and ncm == "FireServer" then
                if args[1] == "Actions" then
                    if args[2][2] == "Step" then
                        return -- void // no return check detection (if remote:FireServer() then print'detected' end)
                    end
                end
            end
        end

        return infSprint(self, ...)
    end)

    Character_tab:AddToggle({
        Name = "Infinite Sprint",
        Default = false,
        Callback = function(bool)
            settings.InfSprint = bool
        end
    })

    local oldWS = humanoid.WalkSpeed
    local index_WS; index_WS = hookmetamethod(game, "__index", function(self, i)
        if settings.speed then
            if self == humanoid and i == "WalkSpeed" then
                return oldWS
            end
        end
        
        return index_WS(self, i) 
    end)
    
    local newindex_WS; newindex_WS = hookmetamethod(game, "__newindex", function(self, i, v)
        if settings.speed then 
            if self == humanoid and i == "WalkSpeed" then
                v = settings.WalkSpeed
            end
        end
        
        return newindex_WS(self, i, v)
    end)

    Character_tab:AddToggle({
        Name = "WalkSpeed Toggle",
        Default = false,
        Callback = function(bool)
            settings.speed = bool
            
            if bool then
                humanoid.WalkSpeed = settings.WalkSpeed 
            else
                humanoid.WalkSpeed = oldWS
            end
        end
    })

    Character_tab:AddSlider({
        Name = "WalkSpeed",
        Min = 0,
        Max = 50,
        Default = oldWS,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(speed)
            settings.WalkSpeed = speed

            if settings.speed then
                humanoid.WalkSpeed = speed
            end
        end
    })
end

do 
    local Misc_tab = window:MakeTab({
        Name = "Misc",
        Icon = "",
        PremiumOnly = false
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
    
    local orion = game.CoreGui.Orion
    Misc_tab:AddBind({
        Name = "GUI Keybind",
        Default = Enum.KeyCode.RightShift,
        Hold = false,
        Callback = function()
            orion.Enabled = not orion.Enabled
        end
    })  
end

do
    local credits = window:MakeTab({
        Name = "Credits",
        Icon = "",
        PremiumOnly = false
    })

    credits:AddParagraph("Credits", "Made by avg#1496")

    if setclipboard then
        credits:AddButton({
            Name = "Copy Discord To Clipboard", -- why did i even add this
            Callback = function()
                setclipboard("avg#1496") 
            end
        })
    end
end

lib:Init()
