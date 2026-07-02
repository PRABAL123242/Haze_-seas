-- पुराने मेन्यू को साफ़ करना
if game.CoreGui:FindFirstChild("HazeSeasSmartScrollGUI") then 
    game.CoreGui.HazeSeasSmartScrollGUI:Destroy() 
end

_G.TargetNPC = ""
_G.WeaponName = "Electricity"
_G.AutoFarm = false

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local SG = Instance.new("ScreenGui", game.CoreGui)
SG.Name = "HazeSeasSmartScrollGUI"

local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 260, 0, 340)
F.Position = UDim2.new(0.1, 0, 0.2, 0)
F.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
F.Active = true
F.Draggable = true

local TL = Instance.new("TextLabel", F)
TL.Size = UDim2.new(1, 0, 0, 40)
TL.Text = "Haze Seas Smart Scanner"
TL.TextColor3 = Color3.fromRGB(255, 255, 255)
TL.BackgroundColor3 = Color3.fromRGB(30, 100, 60)
TL.TextSize = 15
TL.Font = Enum.Font.SourceSansBold

local ToggleGuiBtn = Instance.new("TextButton", SG)
ToggleGuiBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleGuiBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleGuiBtn.Text = "CLOSE"
ToggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleGuiBtn.Font = Enum.Font.SourceSansBold
ToggleGuiBtn.TextSize = 12
ToggleGuiBtn.Active = true
ToggleGuiBtn.Draggable = true

ToggleGuiBtn.MouseButton1Click:Connect(function()
    F.Visible = not F.Visible
    ToggleGuiBtn.Text = F.Visible and "CLOSE" or "OPEN"
    ToggleGuiBtn.BackgroundColor3 = F.Visible and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 100, 60)
end)

local SF = Instance.new("ScrollingFrame", F)
SF.Size = UDim2.new(1, -20, 0, 150)
SF.Position = UDim2.new(0, 10, 0, 50)
SF.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SF.ScrollBarThickness = 6

local UIList = Instance.new("UIListLayout", SF)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 2)

local SelectedLabel = Instance.new("TextLabel", F)
SelectedLabel.Size = UDim2.new(1, -20, 0, 25)
SelectedLabel.Position = UDim2.new(0, 10, 0, 210)
SelectedLabel.Text = "Please Select an NPC Below"
SelectedLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Font = Enum.Font.SourceSansBold
SelectedLabel.TextSize = 14

local ScanBtn = Instance.new("TextButton", F)
ScanBtn.Size = UDim2.new(1, -20, 0, 30)
ScanBtn.Position = UDim2.new(0, 10, 0, 240)
ScanBtn.Text = "🔄 SCAN NEARBY NPCs"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 150)
ScanBtn.Font = Enum.Font.SourceSansBold
ScanBtn.TextSize = 13

local btn = Instance.new("TextButton", F)
btn.Size = UDim2.new(1, -20, 0, 45)
btn.Position = UDim2.new(0, 10, 0, 280)
btn.Text = "START FRUIT FARM"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16

-- नंबरों को हटाकर साफ नाम फिल्टर करने का लाइव स्कैन फंक्शन
local function scanNPCs()
    for _, child in ipairs(SF:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local foundNPCs = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
            if not Players:GetPlayerFromCharacter(v) and not v.Name:lower():find("quest") then
                -- नाम के पीछे से नंबरों को गायब करने का लॉजिक (जैसे Corrupt Marine2516 बन जाएगा Corrupt Marine)
                local cleanName = v.Name:gsub("%d+$", "")
                
                if not foundNPCs[cleanName] and cleanName ~= "" then
                    foundNPCs[cleanName] = true
                    
                    local nBtn = Instance.new("TextButton", SF)
                    nBtn.Size = UDim2.new(1, 0, 0, 30)
                    nBtn.Text = cleanName
                    nBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                    nBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    nBtn.Font = Enum.Font.SourceSans
                    nBtn.TextSize = 14
                    
                    nBtn.MouseButton1Click:Connect(function()
                        _G.TargetNPC = cleanName:lower()
                        SelectedLabel.Text = "Selected Group: " .. cleanName
                        SelectedLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
                    end)
                end
            end
        end
    end
    SF.CanvasSize = UDim2.new(0, 0, 0, #SF:GetChildren() * 32)
end

ScanBtn.MouseButton1Click:Connect(scanNPCs)
scanNPCs()

btn.MouseButton1Click:Connect(function()
    if _G.TargetNPC == "" then 
        SelectedLabel.Text = "SELECT AN NPC FIRST!"
        return 
    end
    _G.AutoFarm = not _G.AutoFarm
    btn.Text = _G.AutoFarm and "STOP FARM" or "START FRUIT FARM"
    btn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(200, 50, 50)
end)

local function safeTween(cf)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and _G.AutoFarm then
        local dist = (root.Position - cf.Position).Magnitude
        local tween = TweenService:Create(root, TweenInfo.new(dist/85, Enum.EasingStyle.Linear), {CFrame = cf})
        tween:Play()
        tween.Completed:Wait()
    end
end

local function checkAndTakeQuest()
    local hasQuest = false
    pcall(function()
        if LocalPlayer.PlayerGui:FindFirstChild("QuestGui") and LocalPlayer.PlayerGui.QuestGui.Enabled then
            hasQuest = true
        end
    end)

    if not hasQuest and _G.TargetNPC ~= "" then
        for _, v in ipairs(workspace:GetDescendants()) do
            local vNameClean = v.Name:lower():gsub("%d+$", "")
            if v:IsA("Model") and (v.Name:lower():find("quest") or vNameClean:find(_G.TargetNPC)) and v:FindFirstChild("HumanoidRootPart") then
                if (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < 250 then
                    safeTween(v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    pcall(function()
                        -- गेम को साफ नाम भेजना ताकि सही क्वेस्ट मिले
                        local questTitle = _G.TargetNPC == "corrupt marine" and "Corrupt Marine" or v.Name
                        game:GetService("ReplicatedStorage").Remotes.QuestEvent:FireServer(questTitle, 1)
                    end)
                    task.wait(0.5)
                    break
                end
            end
        end
    end
end

local function fruitAttack()
    local char = LocalPlayer.Character
    if char and _G.AutoFarm then
        local tool = char:FindFirstChild(_G.WeaponName) or LocalPlayer.Backpack:FindFirstChild(_G.WeaponName)
        if tool then
            tool.Parent = char
            pcall(function()
                tool:Activate()
                game:GetService("ReplicatedStorage").Remotes.CombatEvent:FireServer("Attack", _G.WeaponName)
            end)
        end
    end
end

-- मुख्य स्मार्ट ग्रुप फार्मिंग लूप
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoFarm and _G.TargetNPC ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(checkAndTakeQuest)
            
            local target = nil
            local dist = math.huge
            
            -- मरीन ग्रुप को ट्रैक करना
            for _, v in ipairs(workspace:GetDescendants()) do
                local vNameClean = v.Name:lower():gsub("%d+$", "")
                if v:IsA("Model") and vNameClean:find(_G.TargetNPC) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        target = v
                        dist = d
                    end
                end
            end
            
            if target then
                local hum = target.Humanoid
                local root = target.HumanoidRootPart
                safeTween(root.CFrame * CFrame.new(0, 4, 0))
                
                while _G.AutoFarm and hum and hum.Health > 0 and root and target.Parent do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 4, 0)
                    end
                    fruitAttack()
                    task.wait(0.05)
                end
            end
        end
    end
end)
