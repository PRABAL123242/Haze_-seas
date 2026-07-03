-- पुराने मेन्यू को साफ़ करना (मोबाइल सेफ)
pcall(function()
    if game.CoreGui:FindFirstChild("HazeSeasSmartScrollGUI") then 
        game.CoreGui.HazeSeasSmartScrollGUI:Destroy() 
    end
end)

-- ग्लोबल सेटिंग्स
_G.TargetNPC = ""
_G.AutoFarm = false
_G.AutoChest = false
_G.UniversalFastAttack = true
_G.RunSpeed = 60 

_G.Skill_Z = true
_G.Skill_X = true
_G.Skill_C = true
_G.Skill_V = true
_G.Skill_B = false

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- यूनिवर्सल सेफ ट्विन फंक्शन
local function safeTween(cf)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local dist = (root.Position - cf.Position).Magnitude
        local tween = TweenService:Create(root, TweenInfo.new(dist/150, Enum.EasingStyle.Linear), {CFrame = cf})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- ==================== UI री-डिजाइन (मोबाइल क्रैश फिक्स) ====================
local SG = Instance.new("ScreenGui")
SG.Name = "HazeSeasSmartScrollGUI"
SG.ResetOnSpawn = false
SG.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = SG

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 100, 60)
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(1, 0, 1, 0)
TL.Position = UDim2.new(0, 10, 0, 0)
TL.Text = "HAZE SEAS UNIVERSAL HUB [ALL WEAPONS]"
TL.TextColor3 = Color3.fromRGB(255, 255, 255)
TL.BackgroundTransparency = 1
TL.TextSize = 13
TL.Font = Enum.Font.SourceSansBold
TL.Parent = TopBar

-- CLOSE / OPEN BUTTON
local ToggleGuiBtn = Instance.new("TextButton")
ToggleGuiBtn.Size = UDim2.new(0, 60, 0, 25)
ToggleGuiBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleGuiBtn.Text = "CLOSE"
ToggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 60)
ToggleGuiBtn.Font = Enum.Font.SourceSansBold
ToggleGuiBtn.Parent = SG

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = ToggleGuiBtn

ToggleGuiBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleGuiBtn.Text = MainFrame.Visible and "CLOSE" or "OPEN"
end)

-- साइडबार और पेजेस
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 2)
TabList.Parent = Sidebar

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -110, 1, -40)
Pages.Position = UDim2.new(0, 105, 0, 35)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local function createPage()
    local pg = Instance.new("ScrollingFrame")
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.ScrollBarThickness = 4
    pg.Parent = Pages
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 4)
    list.Parent = pg
    return pg
end

local Page1 = createPage()
local Page2 = createPage()
Page1.Visible = true

local function addTab(name, pageTarget)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = Sidebar
    
    btn.MouseButton1Click:Connect(function()
        Page1.Visible = false; Page2.Visible = false; pageTarget.Visible = true
    end)
end

addTab("📜 MAIN FARM", Page1)
addTab("✨ AUTO SKILLS", Page2)

local function addToggle(text, var, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 30)
    b.Text = text .. (_G[var] and ": ON" or ": OFF")
    b.BackgroundColor3 = _G[var] and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(35, 35, 40)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = b
    
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.Text = text .. (_G[var] and ": ON" or ": OFF")
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(35, 35, 40)
    end)
end

-- PAGE 1 CONTENT
local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1, 0, 0, 20)
SelectedLabel.Text = "Target: None"
SelectedLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Font = Enum.Font.SourceSansBold
SelectedLabel.Parent = Page1

local SF = Instance.new("ScrollingFrame")
SF.Size = UDim2.new(1, 0, 0, 60)
SF.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SF.Parent = Page1

local SFList = Instance.new("UIListLayout")
SFList.Parent = SF

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(1, 0, 0, 30)
ScanBtn.Text = "🔄 SCAN NPCs"
ScanBtn.BackgroundColor3 = Color3.fromRGB(35, 60, 130)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.SourceSansBold
ScanBtn.Parent = Page1

local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(1, 0, 0, 35)
FarmBtn.Text = "START UNIVERSAL FARM"
FarmBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.Font = Enum.Font.SourceSansBold
FarmBtn.Parent = Page1

addToggle("💰 AUTO TWEEN CHEST", "AutoChest", Page1)
addToggle("⚡ 4X UNIVERSAL SPEED", "UniversalFastAttack", Page1)

-- PAGE 2 CONTENT
local SkillTitle = Instance.new("TextLabel")
SkillTitle.Size = UDim2.new(1, 0, 0, 20)
SkillTitle.Text = "--- SELECT SKILLS TO USE ---"
SkillTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
SkillTitle.BackgroundTransparency = 1
SkillTitle.Font = Enum.Font.SourceSansBold
SkillTitle.Parent = Page2

addToggle("Skill [Z]", "Skill_Z", Page2)
addToggle("Skill [X]", "Skill_X", Page2)
addToggle("Skill [C]", "Skill_C", Page2)
addToggle("Skill [V]", "Skill_V", Page2)
addToggle("Skill [B]", "Skill_B", Page2)

-- SCAN LOGIC
local function scanNPCs()
    for _, child in ipairs(SF:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    local found = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not v.Name:lower():find("quest") then
            local clean = v.Name:gsub("%d+$", "")
            if not found[clean] and clean ~= "" then
                found[clean] = true
                local nBtn = Instance.new("TextButton")
                nBtn.Size = UDim2.new(1, 0, 0, 25)
                nBtn.Text = clean
                nBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                nBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                nBtn.Font = Enum.Font.SourceSans
                nBtn.Parent = SF
                nBtn.MouseButton1Click:Connect(function()
                    _G.TargetNPC = clean:lower()
                    SelectedLabel.Text = "Target: " .. clean
                end)
            end
        end
    end
end
ScanBtn.MouseButton1Click:Connect(scanNPCs)
scanNPCs()

FarmBtn.MouseButton1Click:Connect(function()
    if _G.TargetNPC == "" then return end
    _G.AutoFarm = not _G.AutoFarm
    FarmBtn.Text = _G.AutoFarm and "STOP FARM" or "START UNIVERSAL FARM"
    FarmBtn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(200, 50, 50)
end)

-- ऑटो-डिटेक्ट हथियार अटैक लॉजिक
local function universalAttack()
    local char = LocalPlayer.Character
    if char and _G.AutoFarm then
        local tool = char:FindFirstChildWhichIsA("Tool") or LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
        if tool then
            tool.Parent = char
            pcall(function()
                tool:Activate()
                local rem = game:GetService("ReplicatedStorage").Remotes.CombatEvent
                rem:FireServer("Attack", tool.Name)
                if _G.UniversalFastAttack then
                    rem:FireServer("Attack", tool.Name)
                    rem:FireServer("Attack", tool.Name)
                    rem:FireServer("Attack", tool.Name)
                end
            end)
        end
    end
end

-- AUTO TWEEN CHEST
task.spawn(function()
    while true do
        task.wait(1.5)
        if _G.AutoChest and not _G.AutoFarm then
            pcall(function()
                for _, v in ipairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v.Name:lower():find("chest") and v:FindFirstChild("PrimaryPart") then
                        safeTween(v.PrimaryPart.CFrame * CFrame.new(0, 2, 0))
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
end)

-- AUTO SKILLS
task.spawn(function()
    local vim = game:GetService("VirtualInputManager")
    while true do
        task.wait(1.2)
        if _G.AutoFarm then
            pcall(function()
                local keyCheck = {Z = _G.Skill_Z, X = _G.Skill_X, C = _G.Skill_C, V = _G.Skill_V, B = _G.Skill_B}
                for key, isEnabled do
                    if isEnabled then
                        vim:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(false, key, false, game)
                    end
                end
            end)
        end
    end
end)

-- MAIN AUTOMATION LOOP
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm and _G.TargetNPC ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = nil
            local dist = math.huge
            for _, v in ipairs(workspace:GetChildren()) do
                local clean = v.Name:lower():gsub("%d+$", "")
                if v:IsA("Model") and clean == _G.TargetNPC and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if d < dist then target = v; dist = d end
                end
            end
            
            if target then
                local hum = target.Humanoid
                local root = target.HumanoidRootPart
                safeTween(root.CFrame * CFrame.new(0, 4, 0))
                
                while _G.AutoFarm and hum and hum.Health > 0 and root and target.Parent do
                    LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 4, 0)
                    universalAttack()
                    task.wait(0.02)
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.RunSpeed
    end
end)
