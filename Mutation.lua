-- Grow a Garden Mutation GUI | Owner: DevX
-- Made by ChatGPT for DevX

-- Load Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Mutation Hub [Owner: DevX]", "DarkTheme")

-- Variables
local selectedPet = nil
local selectedMutation = nil
local petData = {}

-- Function to Get Pets
local function GetPets()
    petData = {}
    local player = game.Players.LocalPlayer
    local petsFolder = player:FindFirstChild("Pets") or player:WaitForChild("Pets")
    for _, pet in pairs(petsFolder:GetChildren()) do
        table.insert(petData, pet.Name)
    end
end
GetPets()

-- Mutation List with Passives
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
for k,_ in pairs(mutationData) do
    table.insert(mutationTypes, k)
end

-- GUI Tab
local Tab = Window:NewTab("Mutations")
local Section = Tab:NewSection("Pet Mutation Controls")

-- Dropdown: Select Pet
Section:NewDropdown("Select Pet", "Choose your pet", petData, function(v)
    selectedPet = v
end)

-- Dropdown: Select Mutation
Section:NewDropdown("Select Mutation", "Choose mutation type", mutationTypes, function(v)
    selectedMutation = v
    Library:Notify("Passive: "..mutationData[v], 5)
end)

-- Apply Mutation Button
Section:NewButton("Apply Mutation", "Apply selected mutation", function()
    if selectedPet and selectedMutation then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("MutatePet") -- Replace if needed
        if remote then
            local args = {
                [1] = selectedPet,
                [2] = selectedMutation
            }
            remote:FireServer(unpack(args))
            Library:Notify("Applied "..selectedMutation.." to "..selectedPet, 4)
        else
            Library:Notify("RemoteEvent not found! Use RemoteSpy.", 4)
        end
    else
        Library:Notify("Please select a pet and mutation first!", 4)
    end
end)

-- Refresh Pet List Button
Section:NewButton("Refresh Pet List", "Updates your pet list", function()
    GetPets()
    Library:Notify("Pet list refreshed!", 3)
end)
