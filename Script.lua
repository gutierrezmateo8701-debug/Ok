--// M4teoUI
--// Librería propia estilo Rayfield
--// Script.lua

local M4teoUI = {}

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

--==================================================
-- SETTINGS
--==================================================

local Theme = {
    Background = Color3.fromRGB(18, 18, 23),
    Secondary = Color3.fromRGB(24, 24, 30),
    Element = Color3.fromRGB(31, 31, 39),
    Accent = Color3.fromRGB(115, 90, 255),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(165, 165, 175),
    Border = Color3.fromRGB(50, 50, 60)
}

local Connections = {}
local Destroyed = false
local Visible = true

--==================================================
-- UTILITY
--==================================================

local function Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

local function Create(class, properties, parent)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        pcall(function()
            object[property] = value
        end)
    end

    object.Parent = parent
    return object
end

local function Corner(object, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, object)
end

local function Stroke(object)
    Create("UIStroke", {
        Color = Theme.Border,
        Thickness = 1
    }, object)
end

local function Tween(object, duration, properties)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()
    return tween
end

local function Callback(functionToCall, ...)
    if type(functionToCall) ~= "function" then
        return
    end

    task.spawn(function(...)
        pcall(functionToCall, ...)
    end, ...)
end

--==================================================
-- REMOVE OLD GUI
--==================================================

pcall(function()
    local old = CoreGui:FindFirstChild("M4teoUI")

    if old then
        old:Destroy()
    end
end)

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Create("ScreenGui", {
    Name = "M4teoUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, CoreGui)

--==================================================
-- MAIN WINDOW
--==================================================

local Window = Create("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(540, 385),
    Position = UDim2.new(0.5, -270, 0.5, -192),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, ScreenGui)

Corner(Window, 12)
Stroke(Window)

--==================================================
-- TOPBAR
--==================================================

local Topbar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 55),
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0
}, Window)

Corner(Topbar, 12)

Create("Frame", {
    Size = UDim2.new(1, 0, 0, 15),
    Position = UDim2.new(0, 0, 1, -15),
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0
}, Topbar)

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -150, 0, 27),
    Position = UDim2.fromOffset(17, 6),
    BackgroundTransparency = 1,
    Text = "M4teoUI",
    TextColor3 = Theme.Text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Topbar)

local Subtitle = Create("TextLabel", {
    Size = UDim2.new(1, -150, 0, 18),
    Position = UDim2.fromOffset(18, 30),
    BackgroundTransparency = 1,
    Text = "Universal",
    TextColor3 = Theme.SubText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
}, Topbar)

--==================================================
-- MINIMIZE
--==================================================

local Minimize = Create("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -76, 0, 10),
    BackgroundColor3 = Theme.Element,
    Text = "—",
    TextColor3 = Theme.Text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Topbar)

Corner(Minimize, 8)

--==================================================
-- CLOSE
--==================================================

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -38, 0, 10),
    BackgroundColor3 = Theme.Element,
    Text = "×",
    TextColor3 = Theme.Text,
    TextSize = 20,
    Font = Enum.Font.Gotham,
    AutoButtonColor = false
}, Topbar)

Corner(Close, 8)

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 145, 1, -55),
    Position = UDim2.new(0, 0, 0, 55),
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0
}, Window)

local TabContainer = Create("ScrollingFrame", {
    Size = UDim2.new(1, -10, 1, -10),
    Position = UDim2.fromOffset(5, 5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Theme.Accent,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new()
}, Sidebar)

Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, TabContainer)

--==================================================
-- CONTENT
--==================================================

local Content = Create("Frame", {
    Size = UDim2.new(1, -145, 1, -55),
    Position = UDim2.new(0, 145, 0, 55),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0
}, Window)

local Pages = Create("Folder", {}, Content)

--==================================================
-- REOPEN BUTTON
--==================================================

local Reopen = Create("TextButton", {
    Size = UDim2.fromOffset(48, 48),
    Position = UDim2.new(0, 15, 0.5, -24),
    BackgroundColor3 = Theme.Secondary,
    Text = "M",
    TextColor3 = Theme.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 100
}, ScreenGui)

Corner(Reopen, 14)
Stroke(Reopen)

--==================================================
-- VISIBILITY
--==================================================

function M4teoUI:SetVisibility(state)

    if Destroyed then
        return
    end

    Visible = state == true

    if Visible then

        Reopen.Visible = false
        Window.Visible = true

        Window.Size = UDim2.fromOffset(510, 360)

        Tween(Window, 0.2, {
            Size = UDim2.fromOffset(540, 385)
        })

    else

        Tween(Window, 0.18, {
            Size = UDim2.fromOffset(510, 360)
        })

        task.delay(0.18, function()

            if not Visible and not Destroyed then

                Window.Visible = false
                Reopen.Visible = true

            end

        end)

    end

end

function M4teoUI:IsVisible()
    return Visible
end

--==================================================
-- DESTROY
--==================================================

function M4teoUI:Destroy()

    if Destroyed then
        return
    end

    Destroyed = true

    for _, connection in ipairs(Connections) do

        pcall(function()
            connection:Disconnect()
        end)

    end

    table.clear(Connections)

    ScreenGui:Destroy()

end

--==================================================
-- MINIMIZE / CLOSE
--==================================================

Connect(Minimize.MouseButton1Click, function()

    M4teoUI:SetVisibility(false)

end)

Connect(Reopen.MouseButton1Click, function()

    M4teoUI:SetVisibility(true)

end)

Connect(Close.MouseButton1Click, function()

    M4teoUI:Destroy()

end)

--==================================================
-- NOTIFICATIONS
--==================================================

function M4teoUI:Notify(data)

    data = data or {}

    local Notification = Create("Frame", {
        Size = UDim2.fromOffset(300, 75),
        Position = UDim2.new(1, 10, 1, -95),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ZIndex = 200
    }, ScreenGui)

    Corner(Notification, 10)
    Stroke(Notification)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.fromOffset(10, 7),
        BackgroundTransparency = 1,
        Text = tostring(data.Title or "Notification"),
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 201
    }, Notification)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.fromOffset(10, 32),
        BackgroundTransparency = 1,
        Text = tostring(data.Content or ""),
        TextColor3 = Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 201
    }, Notification)

    Tween(Notification, 0.2, {
        Position = UDim2.new(1, -320, 1, -95)
    })

    task.delay(tonumber(data.Duration) or 3, function()

        if Notification.Parent then

            Tween(Notification, 0.2, {
                Position = UDim2.new(1, 10, 1, -95)
            })

            task.delay(0.25, function()

                pcall(function()
                    Notification:Destroy()
                end)

            end)

        end

    end)

end

--==================================================
-- CREATE WINDOW
--==================================================

function M4teoUI:CreateWindow(config)

    config = config or {}

    Title.Text =
        config.Name
        or config.LoadingTitle
        or "M4teoUI"

    Subtitle.Text =
        config.LoadingSubtitle
        or "Universal"

    local ToggleKey =
        config.ToggleUIKeybind
        or "RightShift"

    if typeof(ToggleKey) == "string" then
        ToggleKey =
            Enum.KeyCode[ToggleKey]
            or Enum.KeyCode.RightShift
    end

    Connect(UserInputService.InputBegan, function(input, processed)

        if processed then
            return
        end

        if input.KeyCode == ToggleKey then

            M4teoUI:SetVisibility(not Visible)

        end

    end)

    local WindowAPI = {}

    --==================================================
    -- CREATE TAB
    --==================================================

    function WindowAPI:CreateTab(tabName, icon)

        local Page = Create("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Visible = false
        }, Pages)

        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        }, Page)

        Create("UIListLayout", {
            Padding = UDim.new(0, 7),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, -10, 0, 38),
            BackgroundColor3 = Theme.Element,
            Text = tostring(tabName or "Tab"),
            TextColor3 = Theme.SubText,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false
        }, TabContainer)

        Corner(TabButton, 8)

        local function Activate()

            for _, page in ipairs(Pages:GetChildren()) do

                if page:IsA("ScrollingFrame") then
                    page.Visible = false
                end

            end

            for _, button in ipairs(TabContainer:GetChildren()) do

                if button:IsA("TextButton") then

                    button.BackgroundColor3 = Theme.Element
                    button.TextColor3 = Theme.SubText

                end

            end

            Page.Visible = true

            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text

        end

        Connect(TabButton.MouseButton1Click, Activate)

        if #Pages:GetChildren() == 1 then
            Activate()
        end

        local TabAPI = {}

        --==================================================
        -- SECTION
        --==================================================

        function TabAPI:CreateSection(text)

            return Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Text = tostring(text or "Section"),
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

        end

        --==================================================
        -- LABEL
        --==================================================

        function TabAPI:CreateLabel(text)

            return Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = tostring(text or ""),
                TextColor3 = Theme.SubText,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

        end

        --==================================================
        -- BUTTON
        --==================================================

        function TabAPI:CreateButton(data)

            data = data or {}

            local Button = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                Text = tostring(data.Name or "Button"),
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            }, Page)

            Corner(Button, 8)
            Stroke(Button)

            Connect(Button.MouseButton1Click, function()

                Tween(Button, 0.08, {
                    BackgroundColor3 = Theme.Accent
                })

                task.delay(0.1, function()

                    if Button.Parent then

                        Tween(Button, 0.1, {
                            BackgroundColor3 = Theme.Secondary
                        })

                    end

                end)

                Callback(data.Callback)

            end)

            return {

                Set = function(_, text)
                    Button.Text = tostring(text)
                end

            }

        end

        --==================================================
        -- TOGGLE
        --==================================================

        function TabAPI:CreateToggle(data)

            data = data or {}

            local State = data.CurrentValue == true

            local Holder = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0
            }, Page)

            Corner(Holder, 8)
            Stroke(Holder)

            Create("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = tostring(data.Name or "Toggle"),
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Holder)

            local Toggle = Create("TextButton", {
                Size = UDim2.fromOffset(40, 22),
                Position = UDim2.new(1, -52, 0.5, -11),
                BackgroundColor3 =
                    State and Theme.Accent or Theme.Element,
                Text = "",
                AutoButtonColor = false
            }, Holder)

            Corner(Toggle, 12)

            local Knob = Create("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position =
                    State
                    and UDim2.new(1, -19, 0.5, -8)
                    or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0
            }, Toggle)

            Corner(Knob, 8)

            local API = {}

            function API:Set(value)

                State = value == true

                Toggle.BackgroundColor3 =
                    State and Theme.Accent or Theme.Element

                Tween(Knob, 0.12, {
                    Position =
                        State
                        and UDim2.new(1, -19, 0.5, -8)
                        or UDim2.new(0, 3, 0.5, -8)
                })

                Callback(data.Callback, State)

            end

            Connect(Toggle.MouseButton1Click, function()

                API:Set(not State)

            end)

            return API

        end

        --==================================================
        -- SLIDER
        --==================================================

        function TabAPI:CreateSlider(data)

            data = data or {}

            local Range = data.Range or {0, 100}

            local Min = tonumber(Range[1]) or 0
            local Max = tonumber(Range[2]) or 100

            if Max <= Min then
                Max = Min + 1
            end

            local Value =
                math.clamp(
                    tonumber(data.CurrentValue) or Min,
                    Min,
                    Max
                )

            local Holder = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 58),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0
            }, Page)

            Corner(Holder, 8)
            Stroke(Holder)

            Create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 24),
                Position = UDim2.fromOffset(12, 5),
                BackgroundTransparency = 1,
                Text = tostring(data.Name or "Slider"),
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Holder)

            local ValueLabel = Create("TextLabel", {
                Size = UDim2.fromOffset(55, 24),
                Position = UDim2.new(1, -65, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(Value),
                TextColor3 = Theme.SubText,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right
            }, Holder)

            local Bar = Create("Frame", {
                Size = UDim2.new(1, -24, 0, 6),
                Position = UDim2.fromOffset(12, 39),
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0
            }, Holder)

            Corner(Bar, 4)

            local Fill = Create("Frame", {
                Size = UDim2.new(
                    (Value - Min) / (Max - Min),
                    0,
                    1,
                    0
                ),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0
            }, Bar)

            Corner(Fill, 4)

            local Dragging = false

            local function SetFromX(x)

                local Percent =
                    math.clamp(
                        (x - Bar.AbsolutePosition.X)
                        / Bar.AbsoluteSize.X,
                        0,
                        1
                    )

                Value =
                    Min
                    + (Max - Min) * Percent

                Value =
                    math.floor(Value * 100 + 0.5) / 100

                ValueLabel.Text = tostring(Value)

                Fill.Size =
                    UDim2.new(Percent, 0, 1, 0)

                Callback(data.Callback, Value)

            end

            Connect(Bar.InputBegan, function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                    Dragging = true

                    SetFromX(input.Position.X)

                end

            end)

            Connect(UserInputService.InputChanged, function(input)

                if Dragging
                and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then

                    SetFromX(input.Position.X)

                end

            end)

            Connect(UserInputService.InputEnded, function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                    Dragging = false

                end

            end)

            local API = {}

            function API:Set(value)

                Value =
                    math.clamp(
                        tonumber(value) or Min,
                        Min,
                        Max
                    )

                local Percent =
                    (Value - Min)
                    / (Max - Min)

                ValueLabel.Text = tostring(Value)

                Fill.Size =
                    UDim2.new(Percent, 0, 1, 0)

                Callback(data.Callback, Value)

            end

            return API

        end

        --==================================================
        -- DROPDOWN
        --==================================================

        function TabAPI:CreateDropdown(data)

            data = data or {}

            local Options = data.Options or {}

            local Selected =
                data.CurrentOption
                or Options[1]
                or "Select"

            local Holder = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 20
            }, Page)

            Corner(Holder, 8)
            Stroke(Holder)

            local Main = Create("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 21
            }, Holder)

            Create("TextLabel", {
                Size = UDim2.new(.5, 0, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = tostring(data.Name or "Dropdown"),
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 22
            }, Main)

            local SelectedLabel = Create("TextLabel", {
                Size = UDim2.new(.4, 0, 1, 0),
                Position = UDim2.new(.5, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(Selected),
                TextColor3 = Theme.SubText,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 22
            }, Main)

            local List = Create("ScrollingFrame", {
                Size = UDim2.new(1, 0, 0, 130),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 50,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Theme.Accent,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new()
            }, Holder)

            Corner(List, 8)
            Stroke(List)

            Create("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, List)

            local function Refresh()

                for _, child in ipairs(List:GetChildren()) do

                    if child:IsA("TextButton") then
                        child:Destroy()
                    end

                end

                for _, option in ipairs(Options) do

                    local OptionButton = Create("TextButton", {
                        Size = UDim2.new(1, -10, 0, 30),
                        BackgroundColor3 = Theme.Secondary,
                        Text = tostring(option),
                        TextColor3 = Theme.Text,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false,
                        ZIndex = 51
                    }, List)

                    Corner(OptionButton, 6)

                    OptionButton.MouseButton1Click:Connect(function()

                        Selected = option
                        SelectedLabel.Text = tostring(option)
                        List.Visible = false

                        Callback(data.Callback, option)

                    end)

                end

            end

            Refresh()

            Connect(Main.MouseButton1Click, function()

                List.Visible = not List.Visible

            end)

            local API = {}

            function API:Set(option)

                Selected = option
                SelectedLabel.Text = tostring(option)

                Callback(data.Callback, option)

            end

            function API:Refresh(options)

                Options = options or {}

                Refresh()

            end

            return API

        end

        --==================================================
        -- INPUT
        --==================================================

        function TabAPI:CreateInput(data)

            data = data or {}

            local Input = Create("TextBox", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                Text = tostring(data.CurrentValue or ""),
                PlaceholderText =
                    tostring(
                        data.PlaceholderText
                        or data.Name
                        or "Input"
                    ),
                PlaceholderColor3 = Theme.SubText,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false
            }, Page)

            Corner(Input, 8)
            Stroke(Input)

            Connect(Input.FocusLost, function()

                Callback(data.Callback, Input.Text)

            end)

            return {

                Set = function(_, value)

                    Input.Text = tostring(value)

                end

            }

        end

        --==================================================
        -- KEYBIND
        --==================================================

        function TabAPI:CreateKeybind(data)

            data = data or {}

            local Current =
                data.CurrentKeybind
                or data.CurrentKey
                or Enum.KeyCode.RightShift

            if typeof(Current) == "string" then
                Current =
                    Enum.KeyCode[Current]
                    or Enum.KeyCode.RightShift
            end

            local Button = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                Text =
                    tostring(data.Name or "Keybind")
                    .. " [" .. Current.Name .. "]",
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            }, Page)

            Corner(Button, 8)
            Stroke(Button)

            local Listening = false

            Connect(Button.MouseButton1Click, function()

                Listening = true

                Button.Text =
                    tostring(data.Name or "Keybind")
                    .. " [Press key]"

            end)

            Connect(UserInputService.InputBegan, function(input, processed)

                if processed then
                    return
                end

                if Listening
                and input.KeyCode ~= Enum.KeyCode.Unknown then

                    Listening = false

                    Current = input.KeyCode

                    Button.Text =
                        tostring(data.Name or "Keybind")
                        .. " [" .. Current.Name .. "]"

                    Callback(data.Callback, Current)

                elseif input.KeyCode == Current then

                    Callback(data.Callback, Current)

                end

            end)

            return {

                Set = function(_, key)

                    if typeof(key) == "string" then
                        key =
                            Enum.KeyCode[key]
                            or Current
                    end

                    Current = key

                    Button.Text =
                        tostring(data.Name or "Keybind")
                        .. " [" .. Current.Name .. "]"

                end

            }

        end

        return TabAPI

    end

    function WindowAPI:Destroy()

        M4teoUI:Destroy()

    end

    return WindowAPI

end

M4teoUI.Flags = {}
M4teoUI.Options = {}

return M4teoUI
