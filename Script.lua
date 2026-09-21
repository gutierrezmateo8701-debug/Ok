--[[
    MiLibrary
    Compact Roblox UI Library
    Version 1.0.0

    Single-file source distribution.

    API:
      Library:CreateWindow()
      Window:CreateTab()
      Tab:CreateSection()
      Tab:CreateButton()
      Tab:CreateToggle()
      Tab:CreateSlider()
      Tab:CreateDropdown()
      Tab:CreateMultiDropdown()
      Tab:CreateInput()
      Tab:CreateKeybind()
      Tab:CreateColorPicker()
      Tab:CreateLabel()
      Tab:CreateParagraph()
      Tab:CreateDivider()

      Library:Notify()
      Library:SetTheme()
      Library:SetVisibility()
      Library:Destroy()

    This is an original implementation with a Rayfield-like public API style.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

Library.Name = "MiLibrary"
Library.Version = "1.0.0"
Library.Visible = true
Library.Tabs = {}
Library.Flags = {}
Library.Elements = {}
Library.ThemeName = "Dark"

Library.Settings = {
    AnimationSpeed = 0.18,
    ClickSounds = true,
    MobileButton = true,
    Notifications = true,
}

Library.Themes = {
    Dark = {
        Background = Color3.fromRGB(17,17,21),
        Secondary = Color3.fromRGB(22,22,27),
        Element = Color3.fromRGB(28,28,34),
        Hover = Color3.fromRGB(36,36,44),
        Text = Color3.fromRGB(240,240,245),
        SubText = Color3.fromRGB(150,150,160),
        Accent = Color3.fromRGB(120,90,255),
        Border = Color3.fromRGB(43,43,51),
        Success = Color3.fromRGB(75,205,120),
        Warning = Color3.fromRGB(240,175,65),
        Error = Color3.fromRGB(235,75,85),
    },
    Light = {
        Background = Color3.fromRGB(240,240,245),
        Secondary = Color3.fromRGB(250,250,252),
        Element = Color3.fromRGB(230,230,236),
        Hover = Color3.fromRGB(220,220,228),
        Text = Color3.fromRGB(30,30,35),
        SubText = Color3.fromRGB(100,100,110),
        Accent = Color3.fromRGB(105,80,220),
        Border = Color3.fromRGB(205,205,215),
        Success = Color3.fromRGB(50,170,90),
        Warning = Color3.fromRGB(220,150,40),
        Error = Color3.fromRGB(210,60,70),
    },
    Ocean = {
        Background = Color3.fromRGB(13,20,28),
        Secondary = Color3.fromRGB(17,28,38),
        Element = Color3.fromRGB(23,38,50),
        Hover = Color3.fromRGB(30,49,63),
        Text = Color3.fromRGB(235,245,255),
        SubText = Color3.fromRGB(145,165,180),
        Accent = Color3.fromRGB(45,170,240),
        Border = Color3.fromRGB(35,58,72),
        Success = Color3.fromRGB(70,210,150),
        Warning = Color3.fromRGB(240,180,70),
        Error = Color3.fromRGB(235,80,90),
    },
    Purple = {
        Background = Color3.fromRGB(21,16,29),
        Secondary = Color3.fromRGB(29,21,39),
        Element = Color3.fromRGB(40,29,52),
        Hover = Color3.fromRGB(50,36,64),
        Text = Color3.fromRGB(245,240,250),
        SubText = Color3.fromRGB(170,155,180),
        Accent = Color3.fromRGB(175,95,255),
        Border = Color3.fromRGB(58,42,70),
        Success = Color3.fromRGB(90,210,135),
        Warning = Color3.fromRGB(240,180,70),
        Error = Color3.fromRGB(235,80,90),
    },
    Red = {
        Background = Color3.fromRGB(25,16,18),
        Secondary = Color3.fromRGB(34,21,24),
        Element = Color3.fromRGB(45,27,31),
        Hover = Color3.fromRGB(55,33,38),
        Text = Color3.fromRGB(250,240,242),
        SubText = Color3.fromRGB(180,155,160),
        Accent = Color3.fromRGB(235,70,90),
        Border = Color3.fromRGB(65,38,43),
        Success = Color3.fromRGB(80,200,120),
        Warning = Color3.fromRGB(240,180,70),
        Error = Color3.fromRGB(255,75,80),
    },
    Green = {
        Background = Color3.fromRGB(15,23,19),
        Secondary = Color3.fromRGB(19,31,25),
        Element = Color3.fromRGB(27,43,34),
        Hover = Color3.fromRGB(34,55,43),
        Text = Color3.fromRGB(238,248,241),
        SubText = Color3.fromRGB(150,175,158),
        Accent = Color3.fromRGB(70,205,120),
        Border = Color3.fromRGB(38,65,47),
        Success = Color3.fromRGB(80,215,125),
        Warning = Color3.fromRGB(240,180,70),
        Error = Color3.fromRGB(235,80,90),
    }
}

Library.Theme = Library.Themes.Dark

local function getGuiParent()
    local ok, gui = pcall(function()
        if gethui then
            return gethui()
        end
        return game:GetService("CoreGui")
    end)
    if ok and gui then return gui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function new(className, props)
    local obj = Instance.new(className)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function corner(obj, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = obj
    })
end

local function stroke(obj, color, transparency)
    return new("UIStroke", {
        Color = color or Library.Theme.Border,
        Transparency = transparency or 0,
        Thickness = 1,
        Parent = obj
    })
end

local function padding(obj, amount)
    return new("UIPadding", {
        PaddingTop = UDim.new(0, amount),
        PaddingBottom = UDim.new(0, amount),
        PaddingLeft = UDim.new(0, amount),
        PaddingRight = UDim.new(0, amount),
        Parent = obj
    })
end

local function tween(obj, time, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(time or Library.Settings.AnimationSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local function getFlag(flag, default)
    if flag then
        Library.Flags[flag] = default
    end
end

local function callback(fn, ...)
    if type(fn) == "function" then
        task.spawn(fn, ...)
    end
end

function Library:_click()
    if not self.Settings.ClickSounds or not self.ClickSound then return end
    local s = self.ClickSound:Clone()
    s.Parent = self.SoundFolder
    s:Play()
    task.delay(2, function()
        if s then s:Destroy() end
    end)
end

function Library:_applyTheme()
    if not self.Gui then return end
    local t = self.Theme

    if self.WindowFrame then
        self.WindowFrame.BackgroundColor3 = t.Background
        if self.WindowStroke then self.WindowStroke.Color = t.Border end
    end
    if self.Sidebar then self.Sidebar.BackgroundColor3 = t.Secondary end
    if self.Content then self.Content.BackgroundColor3 = t.Secondary end

    if self.TitleLabel then self.TitleLabel.TextColor3 = t.Text end
    if self.SubtitleLabel then self.SubtitleLabel.TextColor3 = t.SubText end

    for _, element in ipairs(self.Elements) do
        if element._theme then
            pcall(element._theme, t)
        end
    end
end

function Library:SetTheme(theme)
    if type(theme) == "string" and self.Themes[theme] then
        self.ThemeName = theme
        self.Theme = self.Themes[theme]
        self:_applyTheme()
        return self
    elseif type(theme) == "table" then
        self.ThemeName = "Custom"
        self.Theme = theme
        self:_applyTheme()
        return self
    end
    return self
end

function Library:SetVisibility(value)
    self.Visible = value ~= false
    if self.WindowFrame then
        self.WindowFrame.Visible = self.Visible
    end
    if self.MobileButton then
        self.MobileButton.Visible = not self.Visible and self.Settings.MobileButton
    end
end

function Library:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
    self.Gui = nil
    self.WindowFrame = nil
    self.Tabs = {}
    self.Elements = {}
end

function Library:Notify(config)
    if not self.Settings.Notifications or not self.Gui then return end
    config = config or {}

    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = tonumber(config.Duration) or 3

    local holder = new("Frame", {
        Size = UDim2.fromOffset(260, 70),
        Position = UDim2.new(1, 20, 1, -85),
        AnchorPoint = Vector2.new(1,1),
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0,
        Parent = self.NotificationHolder
    })
    corner(holder, 7)
    local st = stroke(holder, self.Theme.Border)

    local titleLabel = new("TextLabel", {
        Size = UDim2.new(1,-20,0,20),
        Position = UDim2.fromOffset(10,7),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder
    })

    local body = new("TextLabel", {
        Size = UDim2.new(1,-20,0,32),
        Position = UDim2.fromOffset(10,29),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = self.Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder
    })

    local bar = new("Frame", {
        Size = UDim2.new(1,0,0,2),
        Position = UDim2.new(0,0,1,-2),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Parent = holder
    })

    tween(holder, 0.25, {
        Position = UDim2.new(1,-12,1,-85)
    })

    tween(bar, duration, {
        Size = UDim2.new(0,0,0,2)
    })

    task.delay(duration, function()
        if holder and holder.Parent then
            tween(holder, 0.2, {
                Position = UDim2.new(1,20,1,-85)
            })
            task.wait(0.22)
            holder:Destroy()
        end
    end)
end

function Library:CreateWindow(config)
    config = config or {}

    if self.Gui then
        self:Destroy()
    end

    self.Tabs = {}
    self.Elements = {}

    local parent = getGuiParent()

    self.Gui = new("ScreenGui", {
        Name = "MiLibrary_" .. tostring(math.random(10000,99999)),
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = parent
    })

    self.SoundFolder = new("Folder", {
        Name = "Sounds",
        Parent = self.Gui
    })

    self.ClickSound = new("Sound", {
        SoundId = "rbxassetid://6895079853",
        Volume = 0.25,
        Parent = self.SoundFolder
    })

    self.WindowFrame = new("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(config.Size and config.Size.X or 520, config.Size and config.Size.Y or 335),
        Position = UDim2.new(0.5, -260, 0.5, -167),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        Parent = self.Gui
    })
    corner(self.WindowFrame, 9)
    self.WindowStroke = stroke(self.WindowFrame, self.Theme.Border)

    local header = new("Frame", {
        Size = UDim2.new(1,0,0,48),
        BackgroundTransparency = 1,
        Parent = self.WindowFrame
    })

    self.TitleLabel = new("TextLabel", {
        Size = UDim2.new(1,-105,0,22),
        Position = UDim2.fromOffset(14,7),
        BackgroundTransparency = 1,
        Text = config.Name or "MiLibrary",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    self.SubtitleLabel = new("TextLabel", {
        Size = UDim2.new(1,-105,0,16),
        Position = UDim2.fromOffset(14,28),
        BackgroundTransparency = 1,
        Text = config.Subtitle or ("v" .. self.Version),
        TextColor3 = self.Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local minimize = new("TextButton", {
        Size = UDim2.fromOffset(30,30),
        Position = UDim2.new(1,-68,0,9),
        BackgroundColor3 = self.Theme.Secondary,
        Text = "—",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        Parent = header
    })
    corner(minimize,6)

    local close = new("TextButton", {
        Size = UDim2.fromOffset(30,30),
        Position = UDim2.new(1,-34,0,9),
        BackgroundColor3 = self.Theme.Secondary,
        Text = "×",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        Parent = header
    })
    corner(close,6)

    local sidebar = new("Frame", {
        Size = UDim2.new(0,130,1,-58),
        Position = UDim2.fromOffset(8,52),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.WindowFrame
    })
    corner(sidebar,7)
    self.Sidebar = sidebar

    local tabList = new("ScrollingFrame", {
        Size = UDim2.new(1,-8,1,-8),
        Position = UDim2.fromOffset(4,4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })

    new("UIListLayout", {
        Padding = UDim.new(0,4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList
    })

    self.Content = new("Frame", {
        Size = UDim2.new(1,-148,1,-58),
        Position = UDim2.fromOffset(142,52),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.WindowFrame
    })
    corner(self.Content,7)

    self.NotificationHolder = new("Frame", {
        Size = UDim2.fromOffset(300,120),
        Position = UDim2.new(1,-10,1,-10),
        AnchorPoint = Vector2.new(1,1),
        BackgroundTransparency = 1,
        Parent = self.Gui
    })

    minimize.MouseButton1Click:Connect(function()
        self:_click()
        self:SetVisibility(not self.Visible)
    end)

    close.MouseButton1Click:Connect(function()
        self:_click()
        self:Destroy()
    end)

    local dragging = false
    local dragStart
    local startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.WindowFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        self.WindowFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end)

    if self.Settings.MobileButton then
        self.MobileButton = new("TextButton", {
            Size = UDim2.fromOffset(48,48),
            Position = UDim2.new(0,15,0.5,-24),
            BackgroundColor3 = self.Theme.Accent,
            Text = "UI",
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            Visible = false,
            AutoButtonColor = false,
            Parent = self.Gui
        })
        corner(self.MobileButton,14)

        self.MobileButton.MouseButton1Click:Connect(function()
            self:_click()
            self:SetVisibility(true)
        end)
    end

    local lib = self

    local windowObject = {}

    function windowObject:CreateTab(tabConfig)
        tabConfig = tabConfig or {}

        local Tab = {
            Name = tabConfig.Name or "Tab",
            Elements = {},
            Page = nil,
            Button = nil,
        }

        local button = new("TextButton", {
            Size = UDim2.new(1,-4,0,34),
            BackgroundColor3 = lib.Theme.Secondary,
            Text = "  " .. Tab.Name,
            TextColor3 = lib.Theme.SubText,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = tabList
        })
        corner(button,6)

        local page = new("ScrollingFrame", {
            Size = UDim2.new(1,-10,1,-10),
            Position = UDim2.fromOffset(5,5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = lib.Theme.Accent,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = lib.Content
        })
        padding(page,2)

        new("UIListLayout", {
            Padding = UDim.new(0,7),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })

        Tab.Page = page
        Tab.Button = button

        function Tab:Select()
            for _, other in ipairs(lib.Tabs) do
                other.Page.Visible = false
                tween(other.Button,0.12,{
                    BackgroundColor3 = lib.Theme.Secondary,
                    TextColor3 = lib.Theme.SubText
                })
            end

            page.Visible = true
            tween(button,0.12,{
                BackgroundColor3 = lib.Theme.Accent,
                TextColor3 = Color3.new(1,1,1)
            })
        end

        button.MouseButton1Click:Connect(function()
            lib:_click()
            Tab:Select()
        end)

        table.insert(lib.Tabs,Tab)

        if #lib.Tabs == 1 then
            Tab:Select()
        end

        function Tab:CreateSection(text)
            local label = new("TextLabel", {
                Size = UDim2.new(1,-4,0,24),
                BackgroundTransparency = 1,
                Text = string.upper(text or "SECTION"),
                TextColor3 = lib.Theme.SubText,
                Font = Enum.Font.GothamBold,
                TextSize = 9,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = page
            })
            return label
        end

        function Tab:CreateButton(cfg)
            cfg = cfg or {}
            local button = new("TextButton", {
                Size = UDim2.new(1,-4,0,38),
                BackgroundColor3 = lib.Theme.Element,
                Text = cfg.Name or "Button",
                TextColor3 = lib.Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                AutoButtonColor = false,
                Parent = page
            })
            corner(button,6)

            button.MouseEnter:Connect(function()
                tween(button,0.12,{BackgroundColor3=lib.Theme.Hover})
            end)
            button.MouseLeave:Connect(function()
                tween(button,0.12,{BackgroundColor3=lib.Theme.Element})
            end)
            button.MouseButton1Click:Connect(function()
                lib:_click()
                callback(cfg.Callback)
            end)

            table.insert(lib.Elements,{_theme=function(t)
                button.BackgroundColor3=t.Element
                button.TextColor3=t.Text
            end})

            return {
                Set = function(_,name)
                    button.Text = name
                end,
                Button = button
            }
        end

        function Tab:CreateToggle(cfg)
            cfg = cfg or {}
            local state = cfg.CurrentValue == true
            getFlag(cfg.Flag,state)

            local holder = new("Frame", {
                Size = UDim2.new(1,-4,0,42),
                BackgroundColor3 = lib.Theme.Element,
                Parent = page
            })
            corner(holder,6)

            local label = new("TextLabel", {
                Size = UDim2.new(1,-65,1,0),
                Position = UDim2.fromOffset(10,0),
                BackgroundTransparency = 1,
                Text = cfg.Name or "Toggle",
                TextColor3 = lib.Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })

            local switch = new("TextButton", {
                Size = UDim2.fromOffset(38,20),
                Position = UDim2.new(1,-48,0.5,-10),
                BackgroundColor3 = lib.Theme.Border,
                Text = "",
                AutoButtonColor = false,
                Parent = holder
            })
            corner(switch,10)

            local knob = new("Frame", {
                Size = UDim2.fromOffset(16,16),
                Position = UDim2.fromOffset(2,2),
                BackgroundColor3 = lib.Theme.Text,
                Parent = switch
            })
            corner(knob,10)

            local function update(value, fire)
                state = value == true
                if cfg.Flag then Library.Flags[cfg.Flag] = state end

                tween(switch,0.16,{
                    BackgroundColor3 = state and lib.Theme.Accent or lib.Theme.Border
                })
                tween(knob,0.16,{
                    Position = state and UDim2.new(1,-18,0,2) or UDim2.fromOffset(2,2)
                })

                if fire then callback(cfg.Callback,state) end
            end

            switch.MouseButton1Click:Connect(function()
                lib:_click()
                update(not state,true)
            end)

            update(state,false)

            local api = {}
            function api:Set(value) update(value,true) end
            function api:Get() return state end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
                switch.BackgroundColor3=state and t.Accent or t.Border
                knob.BackgroundColor3=t.Text
            end})

            return api
        end

        function Tab:CreateSlider(cfg)
            cfg = cfg or {}
            local range = cfg.Range or {cfg.Min or 0,cfg.Max or 100}
            local min,max = range[1],range[2]
            local increment = cfg.Increment or 1
            local value = math.clamp(cfg.CurrentValue or min,min,max)
            getFlag(cfg.Flag,value)

            local holder = new("Frame", {
                Size = UDim2.new(1,-4,0,55),
                BackgroundColor3 = lib.Theme.Element,
                Parent = page
            })
            corner(holder,6)

            local label = new("TextLabel", {
                Size = UDim2.new(1,-70,0,20),
                Position = UDim2.fromOffset(9,5),
                BackgroundTransparency = 1,
                Text = cfg.Name or "Slider",
                TextColor3 = lib.Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = holder
            })

            local valueLabel = new("TextLabel", {
                Size = UDim2.fromOffset(55,20),
                Position = UDim2.new(1,-63,0,5),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = lib.Theme.SubText,
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = holder
            })

            local bar = new("Frame", {
                Size = UDim2.new(1,-18,0,5),
                Position = UDim2.fromOffset(9,39),
                BackgroundColor3 = lib.Theme.Border,
                Parent = holder
            })
            corner(bar,5)

            local fill = new("Frame", {
                Size = UDim2.new(0,0,1,0),
                BackgroundColor3 = lib.Theme.Accent,
                Parent = bar
            })
            corner(fill,5)

            local hit = new("TextButton", {
                Size = UDim2.new(1,10,1,22),
                Position = UDim2.fromOffset(-5,-11),
                BackgroundTransparency = 1,
                Text = "",
                Parent = bar
            })

            local function setValue(v,fire)
                v = math.clamp(v,min,max)
                v = min + math.floor(((v-min)/increment)+0.5)*increment
                v = math.clamp(v,min,max)
                value = v
                if cfg.Flag then Library.Flags[cfg.Flag]=value end

                local percent = max == min and 0 or (value-min)/(max-min)
                fill.Size = UDim2.new(percent,0,1,0)
                valueLabel.Text = tostring(value)
                if fire then callback(cfg.Callback,value) end
            end

            local draggingSlider=false

            local function updateFromX(x, fire)
                local width = math.max(bar.AbsoluteSize.X, 1)
                local percent = math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
                setValue(min + (max - min) * percent, fire)
            end

            local function beginDrag(input)
                draggingSlider=true
                lib:_click()
                updateFromX(input.Position.X, true)
            end

            hit.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1
                or input.UserInputType==Enum.UserInputType.Touch then
                    beginDrag(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1
                or input.UserInputType==Enum.UserInputType.Touch then
                    draggingSlider=false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not draggingSlider then return end
                if input.UserInputType==Enum.UserInputType.MouseMovement
                or input.UserInputType==Enum.UserInputType.Touch then
                    updateFromX(input.Position.X, true)
                end
            end)

            setValue(value,false)

            local api={}
            function api:Set(v) setValue(v,true) end
            function api:Get() return value end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
                valueLabel.TextColor3=t.SubText
                bar.BackgroundColor3=t.Border
                fill.BackgroundColor3=t.Accent
            end})

            return api
        end

        function Tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local options = cfg.Options or {}
            local current = cfg.CurrentOption or options[1] or "None"
            getFlag(cfg.Flag,current)

            local holder = new("Frame", {
                Size = UDim2.new(1,-4,0,38),
                BackgroundColor3 = lib.Theme.Element,
                ClipsDescendants = true,
                Parent = page
            })
            corner(holder,6)

            local main = new("TextButton", {
                Size = UDim2.new(1,0,0,38),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = holder
            })

            local label = new("TextLabel", {
                Size = UDim2.new(0.5,-10,1,0),
                Position = UDim2.fromOffset(10,0),
                BackgroundTransparency = 1,
                Text = cfg.Name or "Dropdown",
                TextColor3 = lib.Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = main
            })

            local selected = new("TextLabel", {
                Size = UDim2.new(0.5,-20,1,0),
                Position = UDim2.new(0.5,0,0,0),
                BackgroundTransparency = 1,
                Text = tostring(current),
                TextColor3 = lib.Theme.SubText,
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = main
            })

            local list = new("Frame", {
                Size = UDim2.new(1,0,0,0),
                Position = UDim2.fromOffset(0,38),
                BackgroundTransparency = 1,
                Parent = holder
            })

            local layout = new("UIListLayout", {
                Padding = UDim.new(0,3),
                Parent = list
            })

            local open=false

            local function rebuild()
                for _,c in ipairs(list:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end

                for _,option in ipairs(options) do
                    local b=new("TextButton",{
                        Size=UDim2.new(1,-10,0,28),
                        BackgroundColor3=lib.Theme.Hover,
                        Text=tostring(option),
                        TextColor3=lib.Theme.Text,
                        Font=Enum.Font.Gotham,
                        TextSize=10,
                        AutoButtonColor=false,
                        Parent=list
                    })
                    corner(b,5)

                    b.MouseButton1Click:Connect(function()
                        current=option
                        selected.Text=tostring(option)
                        if cfg.Flag then Library.Flags[cfg.Flag]=current end
                        callback(cfg.Callback,current)
                        lib:_click()

                        open=false
                        holder.Size=UDim2.new(1,-4,0,38)
                    end)
                end
            end

            main.MouseButton1Click:Connect(function()
                lib:_click()
                open=not open
                rebuild()

                local count=#options
                local height=open and math.clamp(count*31+6,0,155) or 0
                holder.Size=UDim2.new(1,-4,0,38+height)
            end)

            local api={}
            function api:Set(v)
                for _,o in ipairs(options) do
                    if o==v then
                        current=v
                        selected.Text=tostring(v)
                        if cfg.Flag then Library.Flags[cfg.Flag]=v end
                        return
                    end
                end
            end
            function api:Refresh(newOptions)
                options=newOptions or {}
                if options[1] then
                    current=options[1]
                    selected.Text=tostring(current)
                    if cfg.Flag then Library.Flags[cfg.Flag]=current end
                end
            end
            function api:Get() return current end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
                selected.TextColor3=t.SubText
            end})

            return api
        end

        function Tab:CreateMultiDropdown(cfg)
            cfg = cfg or {}
            local options=cfg.Options or {}
            local selected={}
            local initial=cfg.CurrentOptions or {}

            for _,v in ipairs(initial) do selected[v]=true end
            if cfg.Flag then Library.Flags[cfg.Flag]=selected end

            local holder=new("Frame",{
                Size=UDim2.new(1,-4,0,38),
                BackgroundColor3=lib.Theme.Element,
                ClipsDescendants=true,
                Parent=page
            })
            corner(holder,6)

            local main=new("TextButton",{
                Size=UDim2.new(1,0,0,38),
                BackgroundTransparency=1,
                Text="",
                AutoButtonColor=false,
                Parent=holder
            })

            local label=new("TextLabel",{
                Size=UDim2.new(0.5,-10,1,0),
                Position=UDim2.fromOffset(10,0),
                BackgroundTransparency=1,
                Text=cfg.Name or "Multi Dropdown",
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.GothamMedium,
                TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=main
            })

            local valueLabel=new("TextLabel",{
                Size=UDim2.new(0.5,-20,1,0),
                Position=UDim2.new(0.5,0,0,0),
                BackgroundTransparency=1,
                Text="None",
                TextColor3=lib.Theme.SubText,
                Font=Enum.Font.Gotham,
                TextSize=10,
                TextXAlignment=Enum.TextXAlignment.Right,
                Parent=main
            })

            local list=new("Frame",{
                Size=UDim2.new(1,0,0,0),
                Position=UDim2.fromOffset(0,38),
                BackgroundTransparency=1,
                Parent=holder
            })

            local open=false

            local function updateText()
                local names={}
                for _,o in ipairs(options) do
                    if selected[o] then table.insert(names,tostring(o)) end
                end
                valueLabel.Text=#names>0 and table.concat(names,", ") or "None"
            end

            local function rebuild()
                for _,c in ipairs(list:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end

                for _,option in ipairs(options) do
                    local b=new("TextButton",{
                        Size=UDim2.new(1,-10,0,28),
                        BackgroundColor3=selected[option] and lib.Theme.Accent or lib.Theme.Hover,
                        Text=tostring(option),
                        TextColor3=Color3.new(1,1,1),
                        Font=Enum.Font.Gotham,
                        TextSize=10,
                        AutoButtonColor=false,
                        Parent=list
                    })
                    corner(b,5)

                    b.MouseButton1Click:Connect(function()
                        selected[option]=not selected[option]
                        if cfg.Flag then Library.Flags[cfg.Flag]=selected end
                        updateText()
                        rebuild()
                        callback(cfg.Callback,selected)
                        lib:_click()
                    end)
                end
            end

            main.MouseButton1Click:Connect(function()
                lib:_click()
                open=not open
                rebuild()
                holder.Size=UDim2.new(1,-4,0,38+(open and math.clamp(#options*31+6,0,155) or 0))
            end)

            updateText()

            local api={}
            function api:Set(values)
                selected={}
                for _,v in ipairs(values or {}) do selected[v]=true end
                if cfg.Flag then Library.Flags[cfg.Flag]=selected end
                updateText()
                rebuild()
            end
            function api:Get() return selected end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
                valueLabel.TextColor3=t.SubText
            end})

            return api
        end

        function Tab:CreateInput(cfg)
            cfg=cfg or {}

            local holder=new("Frame",{
                Size=UDim2.new(1,-4,0,55),
                BackgroundColor3=lib.Theme.Element,
                Parent=page
            })
            corner(holder,6)

            local label=new("TextLabel",{
                Size=UDim2.new(1,-18,0,18),
                Position=UDim2.fromOffset(9,5),
                BackgroundTransparency=1,
                Text=cfg.Name or "Input",
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.GothamMedium,
                TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=holder
            })

            local box=new("TextBox",{
                Size=UDim2.new(1,-18,0,25),
                Position=UDim2.fromOffset(9,27),
                BackgroundColor3=lib.Theme.Secondary,
                Text="",
                PlaceholderText=cfg.PlaceholderText or "",
                PlaceholderColor3=lib.Theme.SubText,
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.Gotham,
                TextSize=10,
                ClearTextOnFocus=false,
                Parent=holder
            })
            corner(box,5)

            box.FocusLost:Connect(function()
                if cfg.RemoveTextAfterFocusLost then
                    callback(cfg.Callback,box.Text)
                    box.Text=""
                else
                    callback(cfg.Callback,box.Text)
                end
            end)

            local api={}
            function api:Set(v) box.Text=tostring(v) end
            function api:Get() return box.Text end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
                box.BackgroundColor3=t.Secondary
                box.TextColor3=t.Text
                box.PlaceholderColor3=t.SubText
            end})

            return api
        end

        function Tab:CreateKeybind(cfg)
            cfg=cfg or {}
            local current=cfg.CurrentKeybind or cfg.CurrentKey or "Unknown"
            getFlag(cfg.Flag,current)

            local holder=new("Frame",{
                Size=UDim2.new(1,-4,0,42),
                BackgroundColor3=lib.Theme.Element,
                Parent=page
            })
            corner(holder,6)

            local label=new("TextLabel",{
                Size=UDim2.new(1,-90,1,0),
                Position=UDim2.fromOffset(10,0),
                BackgroundTransparency=1,
                Text=cfg.Name or "Keybind",
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.GothamMedium,
                TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=holder
            })

            local bind=new("TextButton",{
                Size=UDim2.fromOffset(70,25),
                Position=UDim2.new(1,-80,0.5,-12),
                BackgroundColor3=lib.Theme.Secondary,
                Text=tostring(current),
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.Gotham,
                TextSize=9,
                AutoButtonColor=false,
                Parent=holder
            })
            corner(bind,5)

            local listening=false

            bind.MouseButton1Click:Connect(function()
                listening=true
                bind.Text="Press key"
                lib:_click()
            end)

            UserInputService.InputBegan:Connect(function(input,processed)
                if listening then
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        current=input.KeyCode.Name
                        listening=false
                        bind.Text=current
                        if cfg.Flag then Library.Flags[cfg.Flag]=current end
                        callback(cfg.Callback,current)
                    end
                    return
                end

                if input.UserInputType==Enum.UserInputType.Keyboard
                and input.KeyCode.Name==current then
                    callback(cfg.Callback,current)
                end
            end)

            local api={}
            function api:Set(v)
                current=tostring(v)
                bind.Text=current
                if cfg.Flag then Library.Flags[cfg.Flag]=current end
            end
            function api:Get() return current end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
                bind.BackgroundColor3=t.Secondary
                bind.TextColor3=t.Text
            end})

            return api
        end

        function Tab:CreateColorPicker(cfg)
            cfg=cfg or {}
            local color=cfg.Color or Color3.fromRGB(120,90,255)
            getFlag(cfg.Flag,color)

            local holder=new("Frame",{
                Size=UDim2.new(1,-4,0,42),
                BackgroundColor3=lib.Theme.Element,
                Parent=page
            })
            corner(holder,6)

            local label=new("TextLabel",{
                Size=UDim2.new(1,-60,1,0),
                Position=UDim2.fromOffset(10,0),
                BackgroundTransparency=1,
                Text=cfg.Name or "Color",
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.GothamMedium,
                TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=holder
            })

            local preview=new("TextButton",{
                Size=UDim2.fromOffset(30,24),
                Position=UDim2.new(1,-40,0.5,-12),
                BackgroundColor3=color,
                Text="",
                AutoButtonColor=false,
                Parent=holder
            })
            corner(preview,6)

            preview.MouseButton1Click:Connect(function()
                lib:_click()
                local picker=new("Color3Value",{Value=color})
                local dialog=new("TextBox",{
                    Size=UDim2.fromOffset(210,38),
                    Position=UDim2.new(0.5,-105,0.5,-19),
                    BackgroundColor3=lib.Theme.Element,
                    Text="R,G,B (0-255)",
                    TextColor3=lib.Theme.Text,
                    Font=Enum.Font.Gotham,
                    TextSize=10,
                    ClearTextOnFocus=false,
                    Parent=lib.Gui
                })
                corner(dialog,6)
                dialog:CaptureFocus()

                dialog.FocusLost:Connect(function()
                    local r,g,b=dialog.Text:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
                    if r and g and b then
                        color=Color3.fromRGB(
                            math.clamp(tonumber(r),0,255),
                            math.clamp(tonumber(g),0,255),
                            math.clamp(tonumber(b),0,255)
                        )
                        preview.BackgroundColor3=color
                        if cfg.Flag then Library.Flags[cfg.Flag]=color end
                        callback(cfg.Callback,color)
                    end
                    picker:Destroy()
                    dialog:Destroy()
                end)
            end)

            local api={}
            function api:Set(v)
                if typeof(v)=="Color3" then
                    color=v
                    preview.BackgroundColor3=color
                    if cfg.Flag then Library.Flags[cfg.Flag]=color end
                    callback(cfg.Callback,color)
                end
            end
            function api:Get() return color end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                label.TextColor3=t.Text
            end})

            return api
        end

        function Tab:CreateLabel(text)
            local label=new("TextLabel",{
                Size=UDim2.new(1,-4,0,30),
                BackgroundTransparency=1,
                Text=tostring(text or ""),
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.Gotham,
                TextSize=11,
                TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=page
            })
            return {
                Set=function(_,v) label.Text=tostring(v) end,
                Label=label
            }
        end

        function Tab:CreateParagraph(cfg)
            cfg=cfg or {}

            local holder=new("Frame",{
                Size=UDim2.new(1,-4,0,64),
                BackgroundColor3=lib.Theme.Element,
                Parent=page
            })
            corner(holder,6)

            local title=new("TextLabel",{
                Size=UDim2.new(1,-18,0,20),
                Position=UDim2.fromOffset(9,6),
                BackgroundTransparency=1,
                Text=cfg.Title or "Paragraph",
                TextColor3=lib.Theme.Text,
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=holder
            })

            local content=new("TextLabel",{
                Size=UDim2.new(1,-18,0,32),
                Position=UDim2.fromOffset(9,27),
                BackgroundTransparency=1,
                Text=cfg.Content or "",
                TextColor3=lib.Theme.SubText,
                Font=Enum.Font.Gotham,
                TextSize=10,
                TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Left,
                Parent=holder
            })

            local api={}
            function api:Set(t,c)
                title.Text=tostring(t or "")
                content.Text=tostring(c or "")
            end

            table.insert(lib.Elements,{_theme=function(t)
                holder.BackgroundColor3=t.Element
                title.TextColor3=t.Text
                content.TextColor3=t.SubText
            end})

            return api
        end

        function Tab:CreateDivider()
            return new("Frame",{
                Size=UDim2.new(1,-4,0,1),
                BackgroundColor3=lib.Theme.Border,
                BorderSizePixel=0,
                Parent=page
            })
        end

        return Tab
    end

    local toggleKey=config.ToggleKey or Enum.KeyCode.RightShift

    UserInputService.InputBegan:Connect(function(input,processed)
        if processed then return end
        if input.KeyCode==toggleKey then
            self:SetVisibility(not self.Visible)
        end
    end)

    return windowObject
end

return Library
