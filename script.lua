if syn then
    syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()") 
end

if executed then return warn'executing twice crashes' end

getgenv().executed = true

local Players = game:GetService("Players")
local Rs = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
getgenv().char = plr.Character or plr.CharacterAdded:Wait()
getgenv().hrp = char:WaitForChild("HumanoidRootPart")
getgenv().humanoid = char:WaitForChild("Humanoid")

getgenv().settings = {
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed
}

plr.CharacterAdded:Connect(function(new)
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = settings.WalkSpeed
end)

local script
for _, v in next, getnilinstances() do
    if v.Name == "MainModule" then
        script = v
        
        break
    end
end

function GetClosestMob()
    local closest_magnitude = math.huge
    local closest_mob
    
    local mobs = workspace.Mobs
    for _, v in next, mobs:GetChildren() do
        if v.Entity.Health.Value <= 0 then continue end -- dont attack already dead mobs

        local magnitude = (v:GetPivot().Position - hrp.Position).Magnitude
        
        if magnitude < closest_magnitude then
            closest_magnitude = magnitude
            closest_mob = v
        end
    end 
    
    if closest_magnitude <= settings.KA_Range then
        return closest_mob
    end
    
    return nil
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()

local gui = lib.new("SB2 Script")

do
    local page1 = gui:addPage("Farm")
    
    local section1 = page1:addSection("Combat")
    
    section1:addToggle("KillAura", false, function(bool)
        settings.KA = bool
    end)
    
    section1:addSlider("KillAura Range", 20, 0, 25, function(v)
        settings.KA_Range = v
    end)
    
    local combat = require(script.Services.Combat)
    local hashed = getupvalues(combat.Init)[2]
    local Event = Rs.Event
    
    coroutine.wrap(function()
        while true do wait(.3) -- don't edit this, attempting to atk faster breaks
            if settings.KA then
                local mob = GetClosestMob()
    
                if mob and not mob:FindFirstChild("Immortal") then
                    Event:FireServer("Combat", hashed, {"Attack", nil, "1", mob})
                end
            end
        end
    end)()
end

do
    local page2 = gui:addPage("Teleports")
    
    local section2 = page2:addSection("Locations")
    
    for _, v in next, workspace:GetChildren() do
        if v.Name == "TeleportSystem" then
            for _, v2 in next, v:GetChildren() do
                section2:addButton("probably boss room", function()
                    firetouchinterest(hrp, v2, 0)
    
                    wait(.5)
                    
                    firetouchinterest(hrp, v2, 1)
                end)
            end
        end
    end
end

do
    local page3 = gui:addPage("Misc")
    
    local section3 = page3:addSection("Character")
    
    section3:addSlider("WalkSpeed", humanoid.WalkSpeed, 0, 50, function(v)
        settings.WalkSpeed = v
        humanoid.WalkSpeed = v
    end)
end
