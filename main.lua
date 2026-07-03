-- ====================================================================
--                      PD HUB - FULL SCRIPT WITH KEY SYSTEM
-- ====================================================================

-- पुराने GUI को साफ़ करना
pcall(function()
    if game.CoreGui:FindFirstChild("HazeSeasSmartScrollGUI") then game.CoreGui.HazeSeasSmartScrollGUI:Destroy() end
    if game.CoreGui:FindFirstChild("HazeSeasKeySystemGUI") then game.CoreGui.HazeSeasKeySystemGUI:Destroy() end
    if game.CoreGui:FindFirstChild("PDHubSimpleButtonGUI") then game.CoreGui.PDHubSimpleButtonGUI:Destroy() end
end)

-- 🔑 तुम्हारी कड़क की (Key) और नया LootsLabs लिंक यहाँ सेट कर दिया है
local CorrectKey = "Free_PDHUBkey@_@24hours" 
local LootsLabsLink = "https://loot-link.com/s?ZB40leqh"

-- सेविंग फाइल का नाम (प्लेयर के डिवाइस में सेव होगा)
local SaveFileName = "PDHub_KeySave.txt" 

-- फंक्शन: चेक करना कि क्या प्लेयर के पास पहले से 24 घंटे वाली वैलिड की है
local function HasValidKey()
    if isfile and readfile and isfile(SaveFileName) then
        local savedData = readfile(SaveFileName)
        local savedTime = tonumber(savedData)
        if savedTime then
            -- os.time() सेकंड्स में होता है। 24 घंटे = 86400 सेकंड्स
            if os.time() - savedTime < 86400 then
                return true -- 24 घंटे अभी पूरे नहीं हुए, की वैलिड है!
            end
        end
    end
    return false
end

-- असली हब लोड करने का फंक्शन
local function LoadMainHub()
    -- अगर की-सिस्टम की स्क्रीन खुली है, तो उसे हटाओ
    if game.CoreGui:FindFirstChild("HazeSeasKeySystemGUI") then 
        game.CoreGui.HazeSeasKeySystemGUI:Destroy() 
    end
    
    -- डिवाइस में करंट टाइम सेव कर दो ताकि अगले 24 घंटे तक यह दोबारा की न मांगे
    if writefile then
        writefile(SaveFileName, tostring(os.time()))
    end

    -- ==================== यहाँ से तुम्हारा असली वर्किंग कोड शुरू ====================
    _G.TargetNPC = ""
    _G.AutoFarm = false
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

    local function safeTween(cf)
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local dist = (root.Position - cf.Position).Magnitude
            local tween = TweenService:Create(root, TweenInfo.new(dist/150, Enum.EasingStyle.Linear), {CFrame = cf})
            tween:Play()
            tween.Completed:Wait()
        end
    end

    local SG = Instance.new("ScreenGui")
    SG.Name = "HazeSeasSmartScrollGUI"
    SG.ResetOnSpawn = false
    SG.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 420, 0, 260)
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = SG

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
    TopBar.Parent = MainFrame

    local TL = Instance.new("TextLabel")
    TL.Size = UDim2.new(1, 0, 1, 0)
    TL.Position = UDim2.new(0, 10, 0, 0)
    TL.Text = "🦅 PD HUB - UNIVERSAL VERSION"
    TL.TextColor3 = Color3.fromRGB(255, 255, 255)
    TL.BackgroundTransparency = 1
    TL.TextSize = 13
    TL.Font = Enum.Font.SourceSansBold
    TL.Parent = TopBar

    -- सिंपल फ्लोटिंग बटन
    local ButtonSG = Instance.new("ScreenGui")
    ButtonSG.Name = "PDHubSimpleButtonGUI"
    ButtonSG.ResetOnSpawn = false
    ButtonSG.Parent = game.CoreGui

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 80, 0, 30)
    ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
    ToggleButton.Text = "PD HUB"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 14
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    ToggleButton.Parent = ButtonSG
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)

    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        ToggleButton.Text = MainFrame.Visible and "CLOSE" or "PD HUB"
        ToggleButton.BackgroundColor3 = MainFrame.Visible and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(140, 25, 25)
    end)

    -- बाकी सारा पेजेस और कोडिंग (Farming, Skills, etc.)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 100, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Sidebar.Parent = MainFrame
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 2)

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
        Instance.new("UIListLayout", pg).Padding = UDim.new(0, 4)
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
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        
        b.MouseButton1Click:Connect(function()
            _G[var] = not _G[var]
            b.Text = text .. (_G[var] and ": ON" or ": OFF")
            b.BackgroundColor3 = _G[var] and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(35, 35, 40)
        end)
    end

    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, 0, 0, 20)
    SelectedLabel.Text = "Target: None"
    SelectedLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Font = Enum.Font.SourceSansBold
    SelectedLabel.Parent = Page1

    local SF = Instance.new("ScrollingFrame")
    SF.Size = UDim2.new(1, 0, 0, 80)
    SF.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SF.Parent = Page1
    Instance.new("UIListLayout", SF)

    local ScanBtn = Instance.new("TextButton")
    ScanBtn.Size = UDim2.new(1, 0, 0, 30)
    ScanBtn.Text = "🔄 SCAN NPCs (SMART)"
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

    addToggle("⚡ 4X UNIVERSAL SPEED", "UniversalFastAttack", Page1)
    addToggle("Skill [Z]", "Skill_Z", Page2)
    addToggle("Skill [X]", "Skill_X", Page2)
    addToggle("Skill [C]", "Skill_C", Page2)
    addToggle("Skill [V]", "Skill_V", Page2)
    addToggle("Skill [B]", "Skill_B", Page2)

    local function scanNPCs()
        for _, child in ipairs(SF:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        local found = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Name ~= LocalPlayer.Name and not v.Name:lower():find("quest") and v.Humanoid.Health > 0 then
                    local clean = v.Name:gsub("%d+$", ""):gsub("Clone", "")
                    if not found[clean] and clean ~= "" and #clean > 2 then
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
    end
    ScanBtn.MouseButton1Click:Connect(scanNPCs)
    scanNPCs()

    FarmBtn.MouseButton1Click:Connect(function()
        if _G.TargetNPC == "" then return end
        _G.AutoFarm = not _G.AutoFarm
        FarmBtn.Text = _G.AutoFarm and "STOP FARM" or "START UNIVERSAL FARM"
        FarmBtn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(200, 50, 50)
    end)

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
                end)
            end
        end
    end

    task.spawn(function()
        while true do
            task.wait(0.1)
            if _G.AutoFarm and _G.TargetNPC ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local target = nil
                local dist = math.huge
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        local clean = v.Name:lower():gsub("%d+$", ""):gsub("clone", "")
                        if clean == _G.TargetNPC and v.Name ~= LocalPlayer.Name then
                            local d = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                            if d < dist then target = v; dist = d end
                        end
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
end

-- ==================== MAIN LOGIC RUN ====================
if HasValidKey() then
    -- अगर प्लेयर के पास पहले से 24 घंटे वाली वैलिड की (Saved Key) है, तो सीधे हब खोल दो!
    LoadMainHub()
    print("PD HUB: Welcome back! Valid key found.")
else
    -- अगर की (Key) एक्सपायर हो चुकी है या पहली बार है, तो की-सिस्टम UI दिखाओ
    local KeySG = Instance.new("ScreenGui")
    KeySG.Name = "HazeSeasKeySystemGUI"
    KeySG.ResetOnSpawn = false
    KeySG.Parent = game.CoreGui

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 180)
    KeyFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    KeyFrame.Active = true
    KeyFrame.Draggable = true
    KeyFrame.Parent = KeySG
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 35)
    KeyTitle.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
    KeyTitle.Text = "🔑 PD HUB KEY SYSTEM"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.SourceSansBold
    KeyTitle.TextSize = 14
    KeyTitle.Parent = KeyFrame
    Instance.new("UICorner", KeyTitle).CornerRadius = UDim.new(0, 8)

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 260, 0, 35)
    TextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TextBox.Text = ""
    TextBox.PlaceholderText = "Enter Key Here..."
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 14
    TextBox.Parent = KeyFrame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0, 120, 0, 30)
    GetKeyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 60, 130)
    GetKeyBtn.Text = "🔗 GET KEY"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Font = Enum.Font.SourceSansBold
    GetKeyBtn.Parent = KeyFrame
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)

    local CheckKeyBtn = Instance.new("TextButton")
    CheckKeyBtn.Size = UDim2.new(0, 120, 0, 30)
    CheckKeyBtn.Position = UDim2.new(0.53, 0, 0.6, 0)
    CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    CheckKeyBtn.Text = "CHECK KEY ✅"
    CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckKeyBtn.Font = Enum.Font.SourceSansBold
    CheckKeyBtn.Parent = KeyFrame
    Instance.new("UICorner", CheckKeyBtn).CornerRadius = UDim.new(0, 4)

    GetKeyBtn.MouseButton1Click:Connect(function()
        setclipboard(LootsLabsLink)
        GetKeyBtn.Text = "LINK COPIED! 📋"
        task.wait(2)
        GetKeyBtn.Text = "🔗 GET KEY"
    end)

    CheckKeyBtn.MouseButton1Click:Connect(function()
        if TextBox.Text == CorrectKey then
            CheckKeyBtn.Text = "CORRECT! 🎉"
            task.wait(1)
            LoadMainHub()
        else
            CheckKeyBtn.Text = "WRONG KEY! ❌"
            TextBox.Text = ""
            task.wait(1.5)
            CheckKeyBtn.Text = "CHECK KEY ✅"
        end
    end)
end
