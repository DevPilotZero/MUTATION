-- Grow A Garden Mutation Hub V3 | Custom GUI | Designed by DevX
-- Delta Compatible | Functional & Modern

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MutationHub"
ScreenGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

-- Rounded Corners
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(50, 0, 70)
Header.Text = "✨ Grow A Garden | Mutation Hub ✨"
Header.Font = Enum.Font.GothamBold
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 20
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Credits Label
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Position = UDim2.new(0, 0, 1, -20)
Credit.BackgroundTransparency = 1
Credit.Text = "Designed by DevX"
Credit.Font = Enum.Font.Gotham
Credit.TextColor3 = Color3.fromRGB(170, 170, 170)
Credit.TextSize = 14
Credit.Parent = MainFrame

-- Mutation Controls
local PetDropdown = Instance.new("TextButton")
PetDropdown.Size = UDim2.new(0, 200, 0, 30)
PetDropdown.Position = UDim2.new(0, 20, 0, 60)
PetDropdown.Text = "Select Pet"
PetDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PetDropdown.Parent = MainFrame
Instance.new("UICorner", PetDropdown)

local MutationDropdown = Instance.new("TextButton")
MutationDropdown.Size = UDim2.new(0, 200, 0, 30)
MutationDropdown.Position = UDim2.new(0, 20, 0, 100)
MutationDropdown.Text = "Select Mutation"
MutationDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MutationDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
MutationDropdown.Parent = MainFrame
Instance.new("UICorner", MutationDropdown)

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0, 200, 0, 35)
ApplyBtn.Position = UDim2.new(0, 20, 0, 150)
ApplyBtn.Text = "Apply Mutation"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 18
ApplyBtn.Parent = MainFrame
Instance.new("UICorner", ApplyBtn)

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 200, 0, 30)
RefreshBtn.Position = UDim2.new(0, 20, 0, 195)
RefreshBtn.Text = "Refresh Pet List"
RefreshBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Parent = MainFrame
Instance.new("UICorner", RefreshBtn)

-- Scrollable Info for Mutations
local InfoFrame = Instance.new("ScrollingFrame")
InfoFrame.Size = UDim2.new(0, 240, 0, 200)
InfoFrame.Position = UDim2.new(1, -260, 0, 60)
InfoFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
InfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InfoFrame.ScrollBarThickness = 6
InfoFrame.Parent = MainFrame
Instance.new("UICorner", InfoFrame)

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

local yOffset = 0
for name, desc in pairs(mutationData) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 5, 0, yOffset)
    label.Text = name.." → "..desc
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.TextWrapped = true
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = InfoFrame
    yOffset = yOffset + 30
end

-- FUNCTIONALITY
local selectedPet = nil
local selectedMutation = nil
local petList = {"No Pets Found"}

local function GetPets()
    petList = {}
    local player = game.Players.LocalPlayer
    local paths = {
        player:FindFirstChild("Pets"),
        game.ReplicatedStorage:FindFirstChild("Pets"),
        game.ReplicatedStorage:FindFirstChild("PlayerPets"),
        player:FindFirstChild("PlayerData")
    }
    for _, folder in ipairs(paths) do
        if folder then
            for _, pet in pairs(folder:GetChildren()) do
                table.insert(petList, pet.Name)
            end
        end
    end
    if #petList == 0 then petList = {"No Pets Found"} end
end

-- Button Events
RefreshBtn.MouseButton1Click:Connect(function()
    GetPets()
    RefreshBtn.Text = "✅ Pet List Updated!"
    wait(1)
    RefreshBtn.Text = "Refresh Pet List"
end)

PetDropdown.MouseButton1Click:Connect(function()
    if #petList > 0 then
        PetDropdown.Text = "Pet: "..petList[1]
        selectedPet = petList[1]
    else
        PetDropdown.Text = "No Pets Found"
    end
end)

MutationDropdown.MouseButton1Click:Connect(function()
    selectedMutation = "Shiny" -- Default for now
    MutationDropdown.Text = "Mutation: Shiny"
end)

ApplyBtn.MouseButton1Click:Connect(function()
    if selectedPet and selectedMutation then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("MutatePet")
        if remote then
            remote:FireServer(selectedPet, selectedMutation)
            ApplyBtn.Text = "✅ Applied!"
            wait(1)
            ApplyBtn.Text = "Apply Mutation"
        else
            ApplyBtn.Text = "❌ Remote Not Found"
            wait(1)
            ApplyBtn.Text = "Apply Mutation"
        end
    else
        ApplyBtn.Text = "Select Pet & Mutation"
        wait(1)
        ApplyBtn.Text = "Apply Mutation"
    end
end)
