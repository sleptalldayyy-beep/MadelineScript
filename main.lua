-- loader.lua
-- host at: https://raw.githubusercontent.com/YOUR_NAME/YOUR_REPO/main/loader.lua

local VALID_KEYS = {
    ["MADELINE-FREE-001"] = true,
    ["MADELINE-PRO-001"]  = true,
    ["MADELINE-TEST-001"] = true,
}

local SCRIPT_URL = "https://raw.githubusercontent.com/YOUR_NAME/YOUR_REPO/main/main.lua"

local Players    = game:GetService("Players")
local TweenSvc   = game:GetService("TweenService")
local CoreGui    = game:GetService("CoreGui")
local LP         = Players.LocalPlayer

local function showPrompt()
    pcall(function() CoreGui:FindFirstChild("MAD_Key"):Destroy() end)

    local sg = Instance.new("ScreenGui")
    sg.Name = "MAD_Key" sg.ResetOnSpawn = false sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LP.PlayerGui end

    local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
    blur.Size = 20

    local overlay = Instance.new("Frame", sg)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0

    local card = Instance.new("Frame", sg)
    card.Size = UDim2.new(0,360,0,235)
    card.Position = UDim2.new(0.5,-180,0.5,-117)
    card.BackgroundColor3 = Color3.fromRGB(13,13,22)
    card.BorderSizePixel = 0
    card.Active = true
    card.Draggable = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)
    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(100,90,230)
    cs.Thickness = 1.2

    local logoBox = Instance.new("Frame", card)
    logoBox.Size = UDim2.new(0,38,0,38)
    logoBox.Position = UDim2.new(0,14,0,14)
    logoBox.BackgroundColor3 = Color3.fromRGB(100,90,230)
    logoBox.BorderSizePixel = 0
    Instance.new("UICorner", logoBox).CornerRadius = UDim.new(0,8)
    local ll = Instance.new("TextLabel", logoBox)
    ll.Size = UDim2.new(1,0,1,0)
    ll.BackgroundTransparency = 1
    ll.Text = "M"
    ll.TextColor3 = Color3.fromRGB(255,255,255)
    ll.Font = Enum.Font.GothamBold
    ll.TextSize = 20

    local title = Instance.new("TextLabel", card)
    title.Text = "Madeline"
    title.Size = UDim2.new(1,-70,0,22)
    title.Position = UDim2.new(0,60,0,16)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(230,230,245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", card)
    sub.Text = "Enter your access key"
    sub.Size = UDim2.new(1,-70,0,16)
    sub.Position = UDim2.new(0,60,0,38)
    sub.BackgroundTransparency = 1
    sub.TextColor3 = Color3.fromRGB(90,90,120)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", card)
    box.Size = UDim2.new(1,-28,0,40)
    box.Position = UDim2.new(0,14,0,80)
    box.BackgroundColor3 = Color3.fromRGB(20,20,32)
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = "MADELINE-XXXX-XXXX"
    box.PlaceholderColor3 = Color3.fromRGB(70,70,100)
    box.TextColor3 = Color3.fromRGB(230,230,245)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 14
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,7)
    local bstroke = Instance.new("UIStroke", box)
    bstroke.Color = Color3.fromRGB(50,50,80)
    bstroke.Thickness = 1
    box.Focused:Connect(function() bstroke.Color = Color3.fromRGB(100,90,230) end)
    box.FocusLost:Connect(function() bstroke.Color = Color3.fromRGB(50,50,80) end)

    local status = Instance.new("TextLabel", card)
    status.Text = ""
    status.Size = UDim2.new(1,-28,0,18)
    status.Position = UDim2.new(0,14,0,128)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(220,60,60)
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1,-28,0,40)
    btn.Position = UDim2.new(0,14,0,154)
    btn.BackgroundColor3 = Color3.fromRGB(100,90,230)
    btn.BorderSizePixel = 0
    btn.Text = "Unlock"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)

    local event  = Instance.new("BindableEvent")
    local result = nil

    local function tryKey(k)
        k = k:gsub("%s", "")
        if k == "" then
            status.Text = "✕  Enter a key first"
            status.TextColor3 = Color3.fromRGB(220,60,60)
            return
        end

        if VALID_KEYS[k] then
            status.Text = "✓  Key accepted"
            status.TextColor3 = Color3.fromRGB(50,220,100)
            btn.BackgroundColor3 = Color3.fromRGB(40,160,80)
            result = k
            task.wait(0.5)
            event:Fire()
        else
            status.Text = "✕  Invalid key"
            status.TextColor3 = Color3.fromRGB(220,60,60)
            btn.BackgroundColor3 = Color3.fromRGB(100,90,230)
            for _ = 1, 3 do
                TweenSvc:Create(card, TweenInfo.new(0.04), {Position = UDim2.new(0.5,-176,0.5,-117)}):Play()
                task.wait(0.04)
                TweenSvc:Create(card, TweenInfo.new(0.04), {Position = UDim2.new(0.5,-184,0.5,-117)}):Play()
                task.wait(0.04)
            end
            TweenSvc:Create(card, TweenInfo.new(0.04), {Position = UDim2.new(0.5,-180,0.5,-117)}):Play()
        end
    end

    btn.MouseButton1Click:Connect(function() tryKey(box.Text) end)
    btn.TouchTap:Connect(function() tryKey(box.Text) end)
    box.FocusLost:Connect(function(enter) if enter then tryKey(box.Text) end end)

    event.Event:Wait()
    blur:Destroy()
    sg:Destroy()
    return result
end

-- ── entry ──
local inputKey = ""
if script_key and script_key ~= "KEY HERE" and script_key ~= "" then
    inputKey = script_key
else
    inputKey = showPrompt()
end

if not VALID_KEYS[inputKey] then
    warn("[Madeline] Key rejected.")
    return
end

local ok, err = pcall(function()
    loadstring(game:HttpGet(SCRIPT_URL))()
end)
if not ok then
    warn("[Madeline] Failed to load: " .. tostring(err))
end
