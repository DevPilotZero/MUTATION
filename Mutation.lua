-- Grow a Garden Mutation GUI | Owner: DevX | Fixed for Blank UI
-- Mobile Friendly (Delta Safe)

-- Load Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Mutation Hub [Owner: DevX]", "DarkTheme")

local selectedPet = nil
local selectedMutation = nil
local petData = {"No Pets Found"} -- Default placeholder

-- Try to fetch pets
local function GetPets()
    local player = game.Players.LocalPlayer
    local petsFolder = player:FindFirstChild("Pets") or player:FindFirstChild("PlayerPets") or player:WaitForChild("Pets", 5)
    if petsFolder then
        petData = {}
        for _, pet in pairs(petsFolder:GetChildren()) do
            table.insert(petData, pet.Name)
        end
        if #petData == 0 then
            petData = {"No Pets Found"}
        end
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

-- GUI
local Tab = Window:NewTab("Mutations")
local Section = Tab:NewSection("Pet Mutation Controls")

-- Dropdowns
Section:NewDropdown("Select Pet", "Choose your pet", petData, function(v)
    selectedPet = v
end)

Section:NewDropdown("Select Mutation", "Choose mutation type", mutationTypes, function(v)
    selectedMutation = v
    Library:Notify("Passive: "..mutationData[v], 5)
end)

-- Apply Button
Section:NewButton("Apply Mutation", "Apply selected mutation", function()
    if selectedPet and selectedMutation then
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

-- Refresh Button
Section:NewButton("Refresh Pet List", "Reloads your pets", function()
    GetPets()
    Library:Notify("Pet list refreshed!", 3)
end)
