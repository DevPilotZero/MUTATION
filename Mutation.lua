-- Grow A Garden Mutation Hub [Owner: DevX]
-- Styled version for Delta (Always Visible)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Mutation Hub [Owner: DevX]", "BloodTheme")

-- Create Tabs
local MainTab = Window:NewTab("Main")
local Section = MainTab:NewSection("Mutation Controls")
local InfoSection = MainTab:NewSection("Mutation Info")

-- Default Data
local selectedPet = "None"
local selectedMutation = "None"
local petData = {"No Pets Found"}

-- Mutation Data
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

-- Dropdowns
Section:NewDropdown("Select Pet", "Choose a pet", petData, function(v)
    selectedPet = v
end)

Section:NewDropdown("Select Mutation", "Choose mutation type", mutationTypes, function(v)
    selectedMutation = v
    Library:Notify("Passive: "..mutationData[v], 5)
end)

-- Buttons
Section:NewButton("Apply Mutation", "Applies selected mutation", function()
    if selectedPet ~= "None" and selectedMutation ~= "None" then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("MutatePet")
        if remote then
            remote:FireServer(selectedPet, selectedMutation)
            Library:Notify("Applied "..selectedMutation.." to "..selectedPet, 4)
        else
            Library:Notify("Remote not found! Use RemoteSpy.", 4)
        end
    else
        Library:Notify("Select a pet and mutation first!", 4)
    end
end)

Section:NewButton("Refresh Pet List", "Reload pets", function()
    local player = game.Players.LocalPlayer
    local petsFolder = player:FindFirstChild("Pets") or player:WaitForChild("Pets", 5)
    if petsFolder then
        petData = {}
        for _, pet in pairs(petsFolder:GetChildren()) do
            table.insert(petData, pet.Name)
        end
        Library:Notify("Pet list refreshed!", 3)
    else
        Library:Notify("No pets found!", 3)
    end
end)

-- Show Mutation Info
for name, passive in pairs(mutationData) do
    InfoSection:NewLabel(name.." → "..passive)
end
