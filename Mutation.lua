-- Grow A Garden Mutation Hub [Owner: DevX]
-- Fully Working Version with Multi-Path Pet Detection
-- For Delta Exploit

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Mutation Hub [Owner: DevX]", "BloodTheme")

local MainTab = Window:NewTab("Main")
local Section = MainTab:NewSection("Mutation Controls")
local InfoSection = MainTab:NewSection("Mutation Info")

local selectedPet = "None"
local selectedMutation = "None"
local petData = {"No Pets Found"}

-- Mutation Info
local mutationData = {
    Shiny = "Boosts all stats slightly (+15%).",
    Inverted = "Flips visuals; minor stat change.",
    Frozen = "Adds freeze effect; slows enemies.",
    Windy = "Boosts speed/agility.",
    Golden = "Boosts value and luck (+30%).",
    Mega = "Massive stat boost; increases size.",
    Tiny = "Shrinks size; boosts speed & luck.",
    IronSkin = "Boosts defense and durability.",
    Radiant = "Balanced boost; glowing effect.",
    Rainbow = "Rare multi-stat boost.",
    Shocked = "Electric aura; boosts attack.",
    Ascended = "Ultimate boost (+100%); rare."
}

local mutationTypes = {}
for k,_ in pairs(mutationData) do table.insert(mutationTypes, k) end

-- Multi-Path Pet Fetch
local function GetPets()
    petData = {}
    local player = game.Players.LocalPlayer
    local possiblePaths = {
        player:FindFirstChild("Pets"),
        game.ReplicatedStorage:FindFirstChild("Pets"),
        game.ReplicatedStorage:FindFirstChild("PlayerPets"),
        player:FindFirstChild("PlayerData")
    }

    for _, folder in ipairs(possiblePaths) do
        if folder then
            for _, pet in pairs(folder:GetChildren()) do
                if pet:IsA("Folder") or pet:IsA("Model") or pet:IsA("StringValue") or pet:IsA("Instance") then
                    table.insert(petData, pet.Name)
                end
            end
        end
    end

    if #petData == 0 then
        petData = {"No Pets Found"}
    end
end

-- UI Components
Section:NewDropdown("Select Pet", "Choose a pet", petData, function(v)
    selectedPet = v
end)

Section:NewDropdown("Select Mutation", "Choose mutation type", mutationTypes, function(v)
    selectedMutation = v
    Library:Notify("Passive: "..mutationData[v], 5)
end)

Section:NewButton("Apply Mutation", "Applies selected mutation", function()
    if selectedPet ~= "None" and selectedMutation ~= "None" then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("MutatePet")
        if remote then
            remote:FireServer(selectedPet, selectedMutation)
            Library:Notify("Applied "..selectedMutation.." to "..selectedPet, 4)
        else
            Library:Notify("RemoteEvent not found! Use RemoteSpy.", 4)
        end
    else
        Library:Notify("Select a pet and mutation first!", 4)
    end
end)

Section:NewButton("Refresh Pet List", "Reload pets", function()
    GetPets()
    Library:Notify("Pet list refreshed!", 3)
end)

-- Display Mutation Info
for name, passive in pairs(mutationData) do
    InfoSection:NewLabel(name.." → "..passive)
end

-- Load initial pets
GetPets()
