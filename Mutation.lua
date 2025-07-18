-- Grow A Garden | Mutation Hub V2
-- Designed by DevX | Fully Functional
-- Delta-Compatible GUI

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Mutation Hub [Design by DevX]", "BloodTheme")

-- Tabs
local MainTab = Window:NewTab("Main")
local Section = MainTab:NewSection("Mutation Controls")
local InfoSection = MainTab:NewSection("Mutation Info")

local selectedPet = nil
local selectedMutation = nil
local petData = {"Click Refresh!"}

-- Mutation Info Table
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
for name,_ in pairs(mutationData) do
    table.insert(mutationTypes, name)
end

-- Dropdowns (Dynamic)
local petDropdown = Section:NewDropdown("Select Pet", "Choose a pet", petData, function(value)
    selectedPet = value
end)

local mutationDropdown = Section:NewDropdown("Select Mutation", "Choose mutation type", mutationTypes, function(value)
    selectedMutation = value
    Library:Notify("Passive: "..mutationData[value], 5)
end)

-- Fetch Pets Function
local function GetPets()
    local newPets = {}
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
                    table.insert(newPets, pet.Name)
                end
            end
        end
    end

    if #newPets == 0 then
        newPets = {"No Pets Found"}
    end

    petData = newPets
    petDropdown:Refresh(petData)
end

-- Buttons
Section:NewButton("Refresh Pet List", "Reload pets", function()
    GetPets()
    Library:Notify("Pet list updated!", 3)
end)

Section:NewButton("Apply Mutation", "Apply mutation to pet", function()
    if selectedPet and selectedMutation then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("MutatePet")
        if remote then
            remote:FireServer(selectedPet, selectedMutation)
            Library:Notify("Applied "..selectedMutation.." to "..selectedPet, 4)
        else
            Library:Notify("RemoteEvent not found! Use RemoteSpy.", 4)
        end
    else
        Library:Notify("Please select a pet and mutation first!", 4)
    end
end)

-- Mutation Info Display
for name, desc in pairs(mutationData) do
    InfoSection:NewLabel(name.." → "..desc)
end
