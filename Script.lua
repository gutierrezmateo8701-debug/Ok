local _0x1 = game:GetService("UserInputService")
local _0x2 = game:GetService("TweenService")
local _0x3 = game:GetService("CoreGui")
local _0x4 = game:GetService("Players")
local _0x5 = _0x4.LocalPlayer

local _0x6 = {}

local function _0x7(_0x8, _0x9)
    local _0x10 = Instance.new("UICorner")
    _0x10.CornerRadius = UDim2.new(0, _0x9 or 8)
    _0x10.Parent = _0x8
    return _0x10
end

local function _0x11(_0x12, _0x13)
    local _0x14, _0x15, _0x16, _0x17
    _0x12.InputBegan:Connect(function(_0x18)
        if _0x18.UserInputType == Enum.UserInputType.MouseButton1 or _0x18.UserInputType == Enum.UserInputType.Touch then
            _0x14 = true
            _0x16 = _0x18.Position
            _0x17 = _0x13.Position
            _0x18.Changed:Connect(function()
                if _0x18.UserInputState == Enum.UserInputState.End then _0x14 = false end
            end)
        end
    end)
    _0x12.InputChanged:Connect(function(_0x18)
        if _0x18.UserInputType == Enum.UserInputType.MouseMovement or _0x18.UserInputType == Enum.UserInputType.Touch then
            _0x15 = _0x18
        end
    end)
    _0x1.InputChanged:Connect(function(_0x18)
        if _0x18 == _0x15 and _0x14 then
            local _0x19 = _0x18.Position - _0x16
            _0x13.Position = UDim2.new(_0x17.X.Scale, _0x17.X.Offset + _0x19.X, _0x17.Y.Scale, _0x17.Y.Offset + _0x19.Y)
        end
    end)
end

function _0x6:CreateWindow(_0x1A)
    _0x1A = _0x1A or {}
    local _0x1B = _0x1A.Name or "\82\97\121\102\105\101\108\100\32\77\105\110\105"
    local _0x1C = _0x1A.ToggleUIKeybind or "K"

    local _0x1D = Instance.new("ScreenGui")
    _0x1D.Name = "\82\97\121\102\105\101\108\100\95\80\114\111\116\101\99\116\101\100"
    _0x1D.ResetOnSpawn = false
    pcall(function() _0x1D.Parent = _0x3 end)
    if not _0x1D.Parent then _0x1D.Parent = _0x5:WaitForChild("PlayerGui") end

    local _0x1E = Instance.new("Frame")
    _0x1E.Name = "_0x1E"
    _0x1E.Size = UDim2.new(0, 520, 0, 350)
    _0x1E.Position = UDim2.new(0.5, -260, 0.5, -175)
    _0x1E.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    _0x1E.BorderSizePixel = 0
    _0x1E.ClipsDescendants = true
    _0x1E.Parent = _0x1D
    _0x7(_0x1E, 10)

    local _0x1F = Instance.new("Frame")
    _0x1F.Name = "_0x1F"
    _0x1F.Size = UDim2.new(1, 0, 0, 38)
    _0x1F.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    _0x1F.Parent = _0x1E
    _0x7(_0x1F, 10)
    _0x11(_0x1F, _0x1E)

    local _0x20 = Instance.new("TextLabel")
    _0x20.Size = UDim2.new(1, -90, 1, 0)
    _0x20.Position = UDim2.new(0, 12, 0, 0)
    _0x20.BackgroundTransparency = 1
    _0x20.Text = _0x1B
    _0x20.TextColor3 = Color3.fromRGB(240, 240, 240)
    _0x20.TextSize = 14
    _0x20.Font = Enum.Font.GothamBold
    _0x20.TextXAlignment = Enum.TextXAlignment.Left
    _0x20.Parent = _0x1F

    local _0x21 = Instance.new("Frame")
    _0x21.Size = UDim2.new(0, 70, 1, 0)
    _0x21.Position = UDim2.new(1, -75, 0, 0)
    _0x21.BackgroundTransparency = 1
    _0x21.Parent = _0x1F

    local _0x22 = Instance.new("UIListLayout")
    _0x22.FillDirection = Enum.FillDirection.Horizontal
    _0x22.HorizontalAlignment = Enum.HorizontalAlignment.Right
    _0x22.VerticalAlignment = Enum.VerticalAlignment.Center
    _0x22.Padding = UDim.new(0, 6)
    _0x22.Parent = _0x21

    local _0x23 = Instance.new("TextButton")
    _0x23.Size = UDim2.new(0, 26, 0, 26)
    _0x23.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    _0x23.Text = "-"
    _0x23.TextColor3 = Color3.fromRGB(200, 200, 200)
    _0x23.Font = Enum.Font.GothamBold
    _0x23.TextSize = 16
    _0x23.Parent = _0x21
    _0x7(_0x23, 6)

    local _0x24 = Instance.new("TextButton")
    _0x24.Size = UDim2.new(0, 26, 0, 26)
    _0x24.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    _0x24.Text = "\215"
    _0x24.TextColor3 = Color3.fromRGB(255, 255, 255)
    _0x24.Font = Enum.Font.GothamBold
    _0x24.TextSize = 18
    _0x24.Parent = _0x21
    _0x7(_0x24, 6)

    local _0x25 = Instance.new("Frame")
    _0x25.Size = UDim2.new(0, 130, 1, -46)
    _0x25.Position = UDim2.new(0, 8, 0, 42)
    _0x25.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    _0x25.Parent = _0x1E
    _0x7(_0x25, 8)

    local _0x26 = Instance.new("UIListLayout")
    _0x26.SortOrder = Enum.SortOrder.LayoutOrder
    _0x26.Padding = UDim.new(0, 4)
    _0x26.Parent = _0x25

    local _0x27 = Instance.new("UIPadding")
    _0x27.PaddingTop = UDim.new(0, 6)
    _0x27.PaddingLeft = UDim.new(0, 6)
    _0x27.PaddingRight = UDim.new(0, 6)
    _0x27.Parent = _0x25

    local _0x28 = Instance.new("Frame")
    _0x28.Size = UDim2.new(1, -154, 1, -46)
    _0x28.Position = UDim2.new(0, 146, 0, 42)
    _0x28.BackgroundTransparency = 1
    _0x28.Parent = _0x1E

    local _0x29 = false
    _0x23.MouseButton1Click:Connect(function()
        _0x29 = not _0x29
        if _0x29 then
            _0x2:Create(_0x1E, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 38)}):Play()
            _0x25.Visible = false
            _0x28.Visible = false
        else
            _0x2:Create(_0x1E, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 350)}):Play()
            task.delay(0.15, function()
                _0x25.Visible = true
                _0x28.Visible = true
            end)
        end
    end)

    _0x24.MouseButton1Click:Connect(function() _0x1D:Destroy() end)

    _0x1.InputBegan:Connect(function(_0x18, _0x2A)
        if not _0x2A and _0x18.KeyCode == Enum.KeyCode[_0x1C] then
            _0x1E.Visible = not _0x1E.Visible
        end
    end)

    function _0x6:Notify(_0x2B)
        local _0x2C = Instance.new("Frame")
        _0x2C.Size = UDim2.new(0, 220, 0, 50)
        _0x2C.Position = UDim2.new(1, 10, 1, -60)
        _0x2C.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        _0x2C.Parent = _0x1D
        _0x7(_0x2C, 6)

        local _0x2D = Instance.new("TextLabel")
        _0x2D.Size = UDim2.new(1, -10, 0, 20)
        _0x2D.Position = UDim2.new(0, 8, 0, 4)
        _0x2D.BackgroundTransparency = 1
        _0x2D.Text = _0x2B.Title or "Notificación"
        _0x2D.TextColor3 = Color3.fromRGB(255, 255, 255)
        _0x2D.Font = Enum.Font.GothamBold
        _0x2D.TextSize = 12
        _0x2D.TextXAlignment = Enum.TextXAlignment.Left
        _0x2D.Parent = _0x2C

        local _0x2E = Instance.new("TextLabel")
        _0x2E.Size = UDim2.new(1, -10, 0, 20)
        _0x2E.Position = UDim2.new(0, 8, 0, 24)
        _0x2E.BackgroundTransparency = 1
        _0x2E.Text = _0x2B.Content or ""
        _0x2E.TextColor3 = Color3.fromRGB(180, 180, 190)
        _0x2E.Font = Enum.Font.Gotham
        _0x2E.TextSize = 11
        _0x2E.TextXAlignment = Enum.TextXAlignment.Left
        _0x2E.Parent = _0x2C

        _0x2:Create(_0x2C, TweenInfo.new(0.3), {Position = UDim2.new(1, -230, 1, -60)}):Play()
        task.delay(_0x2B.Duration or 3, function()
            _0x2:Create(_0x2C, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 1, -60)}):Play()
            task.wait(0.3)
            _0x2C:Destroy()
        end)
    end

    local _0x2F = {Tabs = {}}

    function _0x2F:CreateTab(_0x30)
        local _0x31 = Instance.new("TextButton")
        _0x31.Size = UDim2.new(1, 0, 0, 30)
        _0x31.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        _0x31.Text = _0x30
        _0x31.TextColor3 = Color3.fromRGB(160, 160, 170)
        _0x31.Font = Enum.Font.GothamSemibold
        _0x31.TextSize = 12
        _0x31.Parent = _0x25
        _0x7(_0x31, 6)

        local _0x32 = Instance.new("ScrollingFrame")
        _0x32.Size = UDim2.new(1, 0, 1, 0)
        _0x32.BackgroundTransparency = 1
        _0x32.BorderSizePixel = 0
        _0x32.ScrollBarThickness = 3
        _0x32.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)
        _0x32.Visible = false
        _0x32.Parent = _0x28

        local _0x33 = Instance.new("UIListLayout")
        _0x33.SortOrder = Enum.SortOrder.LayoutOrder
        _0x33.Padding = UDim.new(0, 6)
        _0x33.Parent = _0x32

        _0x33:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            _0x32.CanvasSize = UDim2.new(0, 0, 0, _0x33.AbsoluteContentSize.Y + 10)
        end)

        local _0x34 = {}

        local function _0x35()
            for _, _0x36 in pairs(_0x2F.Tabs) do
                _0x36.Page.Visible = false
                _0x36.Button.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
                _0x36.Button.TextColor3 = Color3.fromRGB(160, 160, 170)
            end
            _0x32.Visible = true
            _0x31.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
            _0x31.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        _0x31.MouseButton1Click:Connect(_0x35)
        if #_0x2F.Tabs == 0 then _0x35() end
        table.insert(_0x2F.Tabs, {Button = _0x31, Page = _0x32})

        function _0x34:CreateSection(_0x37)
            local _0x38 = Instance.new("TextLabel")
            _0x38.Size = UDim2.new(1, -6, 0, 20)
            _0x38.BackgroundTransparency = 1
            _0x38.Text = string.upper(_0x37)
            _0x38.TextColor3 = Color3.fromRGB(120, 120, 135)
            _0x38.TextSize = 10
            _0x38.Font = Enum.Font.GothamBold
            _0x38.TextXAlignment = Enum.TextXAlignment.Left
            _0x38.Parent = _0x32
        end

        function _0x34:CreateLabel(_0x39)
            local _0x3A = Instance.new("TextLabel")
            _0x3A.Size = UDim2.new(1, -6, 0, 24)
            _0x3A.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
            _0x3A.Text = "  " .. _0x39
            _0x3A.TextColor3 = Color3.fromRGB(200, 200, 210)
            _0x3A.TextSize = 11
            _0x3A.Font = Enum.Font.Gotham
            _0x3A.TextXAlignment = Enum.TextXAlignment.Left
            _0x3A.Parent = _0x32
            _0x7(_0x3A, 4)
            return {
                Set = function(_, _0x3B) _0x3A.Text = "  " .. _0x3B end
            }
        end

        function _0x34:CreateParagraph(_0x3C)
            local _0x3D = Instance.new("Frame")
            _0x3D.Size = UDim2.new(1, -6, 0, 48)
            _0x3D.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
            _0x3D.Parent = _0x32
            _0x7(_0x3D, 6)

            local _0x3E = Instance.new("TextLabel")
            _0x3E.Size = UDim2.new(1, -12, 0, 18)
            _0x3E.Position = UDim2.new(0, 8, 0, 4)
            _0x3E.BackgroundTransparency = 1
            _0x3E.Text = _0x3C.Title or ""
            _0x3E.TextColor3 = Color3.fromRGB(240, 240, 240)
            _0x3E.Font = Enum.Font.GothamBold
            _0x3E.TextSize = 11
            _0x3E.TextXAlignment = Enum.TextXAlignment.Left
            _0x3E.Parent = _0x3D

            local _0x3F = Instance.new("TextLabel")
            _0x3F.Size = UDim2.new(1, -12, 0, 20)
            _0x3F.Position = UDim2.new(0, 8, 0, 22)
            _0x3F.BackgroundTransparency = 1
            _0x3F.Text = _0x3C.Content or ""
            _0x3F.TextColor3 = Color3.fromRGB(160, 160, 175)
            _0x3F.Font = Enum.Font.Gotham
            _0x3F.TextSize = 10
            _0x3F.TextXAlignment = Enum.TextXAlignment.Left
            _0x3F.Parent = _0x3D
        end

        function _0x34:CreateDivider()
            local _0x40 = Instance.new("Frame")
            _0x40.Size = UDim2.new(1, -6, 0, 1)
            _0x40.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            _0x40.BorderSizePixel = 0
            _0x40.Parent = _0x32
        end

        function _0x34:CreateButton(_0x41)
            local _0x42 = Instance.new("TextButton")
            _0x42.Size = UDim2.new(1, -6, 0, 30)
            _0x42.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x42.Text = _0x41.Name or "Botón"
            _0x42.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x42.Font = Enum.Font.Gotham
            _0x42.TextSize = 12
            _0x42.Parent = _0x32
            _0x7(_0x42, 6)

            _0x42.MouseButton1Click:Connect(function()
                _0x2:Create(_0x42, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)}):Play()
                task.delay(0.1, function()
                    _0x2:Create(_0x42, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 46)}):Play()
                end)
                if _0x41.Callback then _0x41.Callback() end
            end)
        end

        function _0x34:CreateToggle(_0x43)
            local _0x44 = _0x43.CurrentValue or false
            local _0x45 = Instance.new("Frame")
            _0x45.Size = UDim2.new(1, -6, 0, 30)
            _0x45.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x45.Parent = _0x32
            _0x7(_0x45, 6)

            local _0x46 = Instance.new("TextLabel")
            _0x46.Size = UDim2.new(1, -50, 1, 0)
            _0x46.Position = UDim2.new(0, 8, 0, 0)
            _0x46.BackgroundTransparency = 1
            _0x46.Text = _0x43.Name or "Toggle"
            _0x46.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x46.Font = Enum.Font.Gotham
            _0x46.TextSize = 12
            _0x46.TextXAlignment = Enum.TextXAlignment.Left
            _0x46.Parent = _0x45

            local _0x47 = Instance.new("TextButton")
            _0x47.Size = UDim2.new(0, 34, 0, 16)
            _0x47.Position = UDim2.new(1, -40, 0.5, -8)
            _0x47.BackgroundColor3 = _0x44 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
            _0x47.Text = ""
            _0x47.Parent = _0x45
            _0x7(_0x47, 8)

            local _0x48 = Instance.new("Frame")
            _0x48.Size = UDim2.new(0, 12, 0, 12)
            _0x48.Position = _0x44 and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            _0x48.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            _0x48.Parent = _0x47
            _0x7(_0x48, 8)

            _0x47.MouseButton1Click:Connect(function()
                _0x44 = not _0x44
                local _0x49 = _0x44 and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                local _0x4A = _0x44 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
                _0x2:Create(_0x48, TweenInfo.new(0.12), {Position = _0x49}):Play()
                _0x2:Create(_0x47, TweenInfo.new(0.12), {BackgroundColor3 = _0x4A}):Play()
                if _0x43.Callback then _0x43.Callback(_0x44) end
            end)
        end

        function _0x34:CreateSlider(_0x4B)
            local _0x4C = _0x4B.Range and _0x4B.Range[1] or 0
            local _0x4D = _0x4B.Range and _0x4B.Range[2] or 100
            local _0x4E = _0x4B.CurrentValue or _0x4C

            local _0x4F = Instance.new("Frame")
            _0x4F.Size = UDim2.new(1, -6, 0, 40)
            _0x4F.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x4F.Parent = _0x32
            _0x7(_0x4F, 6)

            local _0x50 = Instance.new("TextLabel")
            _0x50.Size = UDim2.new(1, -60, 0, 18)
            _0x50.Position = UDim2.new(0, 8, 0, 2)
            _0x50.BackgroundTransparency = 1
            _0x50.Text = _0x4B.Name or "Slider"
            _0x50.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x50.Font = Enum.Font.Gotham
            _0x50.TextSize = 11
            _0x50.TextXAlignment = Enum.TextXAlignment.Left
            _0x50.Parent = _0x4F

            local _0x51 = Instance.new("TextLabel")
            _0x51.Size = UDim2.new(0, 50, 0, 18)
            _0x51.Position = UDim2.new(1, -55, 0, 2)
            _0x51.BackgroundTransparency = 1
            _0x51.Text = tostring(_0x4E)
            _0x51.TextColor3 = Color3.fromRGB(160, 160, 170)
            _0x51.Font = Enum.Font.Gotham
            _0x51.TextSize = 11
            _0x51.TextXAlignment = Enum.TextXAlignment.Right
            _0x51.Parent = _0x4F

            local _0x52 = Instance.new("TextButton")
            _0x52.Size = UDim2.new(1, -16, 0, 5)
            _0x52.Position = UDim2.new(0, 8, 0, 25)
            _0x52.BackgroundColor3 = Color3.fromRGB(60, 60, 72)
            _0x52.Text = ""
            _0x52.Parent = _0x4F
            _0x7(_0x52, 4)

            local _0x53 = Instance.new("Frame")
            _0x53.Size = UDim2.new((_0x4E - _0x4C) / (_0x4D - _0x4C), 0, 1, 0)
            _0x53.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
            _0x53.Parent = _0x52
            _0x7(_0x53, 4)

            local _0x54 = false
            local function _0x55(_0x18)
                local _0x56 = math.clamp((_0x18.Position.X - _0x52.AbsolutePosition.X) / _0x52.AbsoluteSize.X, 0, 1)
                _0x4E = math.floor(_0x4C + (_0x4D - _0x4C) * _0x56)
                _0x51.Text = tostring(_0x4E)
                _0x53.Size = UDim2.new(_0x56, 0, 1, 0)
                if _0x4B.Callback then _0x4B.Callback(_0x4E) end
            end

            _0x52.InputBegan:Connect(function(_0x18)
                if _0x18.UserInputType == Enum.UserInputType.MouseButton1 or _0x18.UserInputType == Enum.UserInputType.Touch then
                    _0x54 = true
                    _0x55(_0x18)
                end
            end)
            _0x1.InputEnded:Connect(function(_0x18)
                if _0x18.UserInputType == Enum.UserInputType.MouseButton1 or _0x18.UserInputType == Enum.UserInputType.Touch then _0x54 = false end
            end)
            _0x1.InputChanged:Connect(function(_0x18)
                if _0x54 and (_0x18.UserInputType == Enum.UserInputType.MouseMovement or _0x18.UserInputType == Enum.UserInputType.Touch) then
                    _0x55(_0x18)
                end
            end)
        end

        function _0x34:CreateInput(_0x57)
            local _0x58 = Instance.new("Frame")
            _0x58.Size = UDim2.new(1, -6, 0, 32)
            _0x58.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x58.Parent = _0x32
            _0x7(_0x58, 6)

            local _0x59 = Instance.new("TextLabel")
            _0x59.Size = UDim2.new(0.5, 0, 1, 0)
            _0x59.Position = UDim2.new(0, 8, 0, 0)
            _0x59.BackgroundTransparency = 1
            _0x59.Text = _0x57.Name or "Input"
            _0x59.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x59.Font = Enum.Font.Gotham
            _0x59.TextSize = 11
            _0x59.TextXAlignment = Enum.TextXAlignment.Left
            _0x59.Parent = _0x58

            local _0x5A = Instance.new("TextBox")
            _0x5A.Size = UDim2.new(0.45, 0, 0, 22)
            _0x5A.Position = UDim2.new(0.52, 0, 0.5, -11)
            _0x5A.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            _0x5A.PlaceholderText = _0x57.PlaceholderText or "Escribir..."
            _0x5A.Text = _0x57.CurrentValue or ""
            _0x5A.TextColor3 = Color3.fromRGB(255, 255, 255)
            _0x5A.Font = Enum.Font.Gotham
            _0x5A.TextSize = 11
            _0x5A.Parent = _0x58
            _0x7(_0x5A, 4)

            _0x5A.FocusLost:Connect(function()
                if _0x57.Callback then _0x57.Callback(_0x5A.Text) end
            end)
        end

        function _0x34:CreateDropdown(_0x5B)
            local _0x5C = _0x5B.Options or {}
            local _0x5D = _0x5B.CurrentOption and _0x5B.CurrentOption[1] or (_0x5C[1] or "Ninguno")

            local _0x5E = Instance.new("Frame")
            _0x5E.Size = UDim2.new(1, -6, 0, 32)
            _0x5E.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x5E.ClipsDescendants = true
            _0x5E.Parent = _0x32
            _0x7(_0x5E, 6)

            local _0x5F = Instance.new("TextButton")
            _0x5F.Size = UDim2.new(1, 0, 0, 32)
            _0x5F.BackgroundTransparency = 1
            _0x5F.Text = ""
            _0x5F.Parent = _0x5E

            local _0x60 = Instance.new("TextLabel")
            _0x60.Size = UDim2.new(0.5, 0, 0, 32)
            _0x60.Position = UDim2.new(0, 8, 0, 0)
            _0x60.BackgroundTransparency = 1
            _0x60.Text = _0x5B.Name or "Dropdown"
            _0x60.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x60.Font = Enum.Font.Gotham
            _0x60.TextSize = 11
            _0x60.TextXAlignment = Enum.TextXAlignment.Left
            _0x60.Parent = _0x5F

            local _0x61 = Instance.new("TextLabel")
            _0x61.Size = UDim2.new(0.45, -10, 0, 32)
            _0x61.Position = UDim2.new(0.5, 0, 0, 0)
            _0x61.BackgroundTransparency = 1
            _0x61.Text = _0x5D
            _0x61.TextColor3 = Color3.fromRGB(0, 140, 255)
            _0x61.Font = Enum.Font.GothamBold
            _0x61.TextSize = 11
            _0x61.TextXAlignment = Enum.TextXAlignment.Right
            _0x61.Parent = _0x5F

            local _0x62 = false
            _0x5F.MouseButton1Click:Connect(function()
                _0x62 = not _0x62
                local _0x63 = _0x62 and (36 + (#_0x5C * 24)) or 32
                _0x2:Create(_0x5E, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, _0x63)}):Play()
            end)

            for _0x64, _0x65 in ipairs(_0x5C) do
                local _0x66 = Instance.new("TextButton")
                _0x66.Size = UDim2.new(1, -12, 0, 22)
                _0x66.Position = UDim2.new(0, 6, 0, 32 + ((_0x64 - 1) * 24))
                _0x66.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                _0x66.Text = _0x65
                _0x66.TextColor3 = Color3.fromRGB(180, 180, 190)
                _0x66.Font = Enum.Font.Gotham
                _0x66.TextSize = 10
                _0x66.Parent = _0x5E
                _0x7(_0x66, 4)

                _0x66.MouseButton1Click:Connect(function()
                    _0x5D = _0x65
                    _0x61.Text = _0x5D
                    _0x62 = false
                    _0x2:Create(_0x5E, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 32)}):Play()
                    if _0x5B.Callback then _0x5B.Callback({_0x5D}) end
                end)
            end
        end

        function _0x34:CreateColorPicker(_0x67)
            local _0x68 = Instance.new("Frame")
            _0x68.Size = UDim2.new(1, -6, 0, 32)
            _0x68.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x68.Parent = _0x32
            _0x7(_0x68, 6)

            local _0x69 = Instance.new("TextLabel")
            _0x69.Size = UDim2.new(0.7, 0, 1, 0)
            _0x69.Position = UDim2.new(0, 8, 0, 0)
            _0x69.BackgroundTransparency = 1
            _0x69.Text = _0x67.Name or "Color Picker"
            _0x69.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x69.Font = Enum.Font.Gotham
            _0x69.TextSize = 11
            _0x69.TextXAlignment = Enum.TextXAlignment.Left
            _0x69.Parent = _0x68

            local _0x6A = Instance.new("Frame")
            _0x6A.Size = UDim2.new(0, 24, 0, 18)
            _0x6A.Position = UDim2.new(1, -32, 0.5, -9)
            _0x6A.BackgroundColor3 = _0x67.Color or Color3.fromRGB(255, 255, 255)
            _0x6A.Parent = _0x68
            _0x7(_0x6A, 4)
        end

        function _0x34:CreateKeybind(_0x6B)
            local _0x6C = _0x6B.CurrentKeybind or "E"
            local _0x6D = Instance.new("Frame")
            _0x6D.Size = UDim2.new(1, -6, 0, 32)
            _0x6D.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            _0x6D.Parent = _0x32
            _0x7(_0x6D, 6)

            local _0x6E = Instance.new("TextLabel")
            _0x6E.Size = UDim2.new(0.6, 0, 1, 0)
            _0x6E.Position = UDim2.new(0, 8, 0, 0)
            _0x6E.BackgroundTransparency = 1
            _0x6E.Text = _0x6B.Name or "Keybind"
            _0x6E.TextColor3 = Color3.fromRGB(220, 220, 230)
            _0x6E.Font = Enum.Font.Gotham
            _0x6E.TextSize = 11
            _0x6E.TextXAlignment = Enum.TextXAlignment.Left
            _0x6E.Parent = _0x6D

            local _0x6F = Instance.new("TextButton")
            _0x6F.Size = UDim2.new(0, 40, 0, 20)
            _0x6F.Position = UDim2.new(1, -48, 0.5, -10)
            _0x6F.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            _0x6F.Text = _0x6C
            _0x6F.TextColor3 = Color3.fromRGB(0, 140, 255)
            _0x6F.Font = Enum.Font.GothamBold
            _0x6F.TextSize = 10
            _0x6F.Parent = _0x6D
            _0x7(_0x6F, 4)

            local _0x70 = false
            _0x6F.MouseButton1Click:Connect(function()
                _0x70 = true
                _0x6F.Text = "..."
            end)

            _0x1.InputBegan:Connect(function(_0x18, _0x2A)
                if _0x70 and not _0x2A and _0x18.UserInputType == Enum.UserInputType.Keyboard then
                    _0x6C = _0x18.KeyCode.Name
                    _0x6F.Text = _0x6C
                    _0x70 = false
                    if _0x6B.Callback then _0x6B.Callback(_0x6C) end
                end
            end)
        end

        return _0x34
    end

    return _0x2F
end

local RayfieldCustom = _0x6
