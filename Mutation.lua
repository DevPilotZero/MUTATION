-- Grow A Garden Mutation GUI | Styled Version [Owner: DevX]
-- Mobile Friendly (Delta Safe)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Mutation Hub [Owner: DevX]", "BloodTheme")

-- Tab and Sections
local MainTab = Window:NewTab("Main")
local MutateSection = MainTab:NewSection("Mutation Controls")
local InfoSection = MainTab:NewSection("Mutation Info")

-- Default Data
local selectedPet = "No Pet Selected"
local selectedMutation = "No Mutation Selected"
local petData = {"No Pets Found"}

-- Preloaded Mutation Types
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

-- Functions
local function GetPets()
    petData = {}
    local player = game.Players.LocalPlayer
    local petsFolder = player:FindFirstChild("Pets") or player:WaitForChild("Pets", 5)
    if petsFolder then
        for _, pet in pairs(petsFolder:GetChildren()) do
            table.insert(petData, pet.Name)
        end
        if #petData == 0 then petData = {"No Pets Found"} end
    else
        petData = {"No Pets Found"}
    end
end

-- Dropdowns
MutateSection:NewDropdown("Select Pet", "Choose your pet", petData, function(v)
    selectedPet = v
end)

MutateSection:NewDropdown("Select Mutation", "Choose mutation", mutationTypes, function(v)
    selectedMutation = v
    Library:Notify("Passive: "..mutationData[v], 5)
end)

-- Buttons
MutateSection:NewButton("Apply Mutation", "Apply to selected pet", function()
    if selectedPet ~= "No Pet Selected" and selectedMutation ~= "No Mutation Selected" then
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

MutateSection:NewButton("Refresh Pets", "Reload pet list", function()
    GetPets()
    Library:Notify("Pet list refreshed!", 3)
end)

-- Show Mutation Info
for name, passive in pairs(mutationData) do
    InfoSection:NewLabel(name.." → "..passive)
end
