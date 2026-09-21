--// M4teoUI
--// Script.lua
--// Complete fixed version
--// Mobile Friendly / Scrollable / Rayfield-like API
--// No Loading Screen

local M4teoUI = {}

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

--==================================================
-- DATA
--==================================================

M4teoUI.Flags = {}
M4teoUI.Options = {}
M4teoUI.Windows = {}
M4teoUI.Themes = {}

--==================================================
-- DEFAULT THEME
--==================================================

M4teoUI.Theme = {
    Background = Color3.fromRGB(17, 17, 22),
    Sidebar = Color3.fromRGB(21, 21, 27),
    Element = Color3.fromRGB(29, 29, 37),
    ElementHover = Color3.fromRGB(38, 38, 48),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(165, 165, 175),
    Border = Color3.fromRGB(55, 55, 65),
    ToggleOff = Color3.fromRGB(25, 25, 32),
    ToggleOn = Color3.fromRGB(0, 170, 255)
}

M4teoUI.Themes.Dark = table.clone(M4teoUI.Theme)

M4teoUI.Themes.Purple = {
    Background = Color3.fromRGB(18, 16, 24),
    Sidebar = Color3.fromRGB(23, 20, 31),
    Element = Color3.fromRGB(32, 28, 42),
    ElementHover = Color3.fromRGB(43, 37, 55),
    Accent = Color3.fromRGB(160, 90, 255),
    Text = Color3.fromRGB(245, 242, 250),
    Muted = Color3.fromRGB(170, 165, 180),
    Border = Color3.fromRGB(65, 55, 78),
    ToggleOff = Color3.fromRGB(27, 24, 34),
    ToggleOn = Color3.fromRGB(160, 90, 255)
}

M4teoUI.Themes.Red = {
    Background = Color3.fromRGB(23, 16, 17),
    Sidebar = Color3.fromRGB(29, 19, 21),
    Element = Color3.fromRGB(40, 26, 29),
    ElementHover = Color3.fromRGB(53, 34, 38),
    Accent = Color3.fromRGB(255, 75, 85),
    Text = Color3.fromRGB(250, 242, 243),
    Muted = Color3.fromRGB(180, 165, 168),
    Border = Color3.fromRGB(78, 53, 57),
    ToggleOff = Color3.fromRGB(33, 23, 25),
    ToggleOn = Color3.fromRGB(255, 75, 85)
}

M4teoUI.Themes.Green = {
    Background = Color3.fromRGB(15, 21, 18),
    Sidebar = Color3.fromRGB(19, 27, 22),
    Element = Color3.fromRGB(25, 37, 29),
    ElementHover = Color3.fromRGB(34, 49, 39),
    Accent = Color3.fromRGB(60, 210, 125),
    Text = Color3.fromRGB(242, 250, 245),
    Muted = Color3.fromRGB(160, 180, 168),
    Border = Color3.fromRGB(50, 76, 60),
    ToggleOff = Color3.fromRGB(22, 31, 25),
    ToggleOn = Color3.fromRGB(60, 210, 125)
}

--==================================================
-- UTILITIES
--==================================================

local function Safe(fn, ...)
    if type(fn) ~= "function" then
        return
    end

    local args = {...}

    task.spawn(function()
        pcall(function()
            fn(table.unpack(args))
        end)
    end)
end

-- FIX: Connect was missing from the original source.
local function Connect(signal, callback)
    if not signal or type(callback) ~= "function" then
        return nil
    end

    local ok, connection = pcall(function()
        return signal:Connect(callback)
    end)

    if ok then
        return connection
    end

    return nil
end

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        pcall(function()
            object[property] = value
        end)
    end

    object.Parent = parent

    return object
end

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
    return corner
end

local function Stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or M4teoUI.Theme.Border
    s.Thickness = thickness or 1
    s.Parent = object
    return s
end

local function Padding(object, left, top, right, bottom)
    local p = Instance.new("UIPadding")

    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)

    p.Parent = object

    return p
end

local function Tween(object, duration, properties)
    if not object then
        return
    end

    local ok, tween = pcall(function()
        return TweenService:Create(
            object,
            TweenInfo.new(
                duration or 0.15,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            properties
        )
    end)

    if ok and tween then
        tween:Play()
        return tween
    end
end

local function GetGuiParent()
    if type(gethui) == "function" then
        local ok, gui = pcall(gethui)

        if ok and gui then
            return gui
        end
    end

    return CoreGui
end

local function IsMobile()
    local camera = workspace.CurrentCamera

    if not camera then
        return false
    end

    return camera.ViewportSize.X < 650
end

local function ClampNumber(value, min, max)
    return math.clamp(
        tonumber(value) or min,
        min,
        max
    )
end

local function Round(value, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(value * mult + 0.5) / mult
end

--==================================================
-- REMOVE OLD GUI
--==================================================

pcall(function()
    local parent = GetGuiParent()
    local old = parent:FindFirstChild("M4teoUI")

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
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999999
}, GetGuiParent())

--==================================================
-- NOTIFICATIONS
--==================================================

local NotificationHolder = Create("Frame", {
    Name = "Notifications",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -10, 0, 10),
    Size = UDim2.fromOffset(280, 400),
    BackgroundTransparency = 1
}, ScreenGui)

Create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Top
}, NotificationHolder)

function M4teoUI:Notify(config)
    config = config or {}

    local title = tostring(config.Title or "M4teoUI")
    local content = tostring(config.Content or "")
    local duration = tonumber(config.Duration or 3) or 3

    local notification = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0
    }, NotificationHolder)

    Corner(notification, 10)
    Stroke(notification, self.Theme.Border, 1)

    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.fromOffset(6, 8),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    }, notification)

    Corner(bar, 3)

    Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 22),
        Position = UDim2.fromOffset(18, 7),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, notification)

    Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 32),
        Position = UDim2.fromOffset(18, 30),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = self.Theme.Muted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, notification)

    notification.Position = UDim2.new(1, 35, 0, 0)

    Tween(notification, 0.25, {
        Position = UDim2.new(0, 0, 0, 0)
    })

    task.delay(duration, function()
        if not notification or not notification.Parent then
            return
        end

        Tween(notification, 0.2, {
            Position = UDim2.new(1, 35, 0, 0)
        })

        task.wait(0.22)

        if notification then
            notification:Destroy()
        end
    end)
end

--==================================================
-- THEME API
--==================================================

function M4teoUI:RegisterTheme(name, theme)
    if type(name) ~= "string" or type(theme) ~= "table" then
        return
    end

    self.Themes[name] = theme
end

function M4teoUI:SetTheme(name)
    local theme = self.Themes[name]

    if not theme then
        return
    end

    for key, value in pairs(theme) do
        self.Theme[key] = value
    end

    for _, window in ipairs(self.Windows) do
        if window and window.ApplyTheme then
            pcall(function()
                window:ApplyTheme()
            end)
        end
    end
end

function M4teoUI:GetThemes()
    local result = {}

    for name in pairs(self.Themes) do
        table.insert(result, name)
    end

    table.sort(result)

    return result
end

--==================================================
-- CREATE WINDOW
--==================================================

function M4teoUI:CreateWindow(config)
    config = config or {}

    local window = {}

    local title = tostring(
        config.Name
        or config.Title
        or "M4teoUI"
    )

    local subtitle = tostring(
        config.Subtitle
        or config.LoadingSubtitle
        or "Universal"
    )

    local camera = workspace.CurrentCamera
    local viewport = camera
        and camera.ViewportSize
        or Vector2.new(800, 600)

    local width = math.clamp(
        math.floor(viewport.X * 0.82),
        330,
        430
    )

    local height = math.clamp(
        math.floor(viewport.Y * 0.62),
        260,
        330
    )

    if viewport.X < 500 then
        width = math.max(300, viewport.X - 24)
    end

    if viewport.Y < 500 then
        height = math.max(230, viewport.Y - 80)
    end

    --==================================================
    -- MAIN
    --==================================================

    local Main = Create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(width, height),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, ScreenGui)

    Corner(Main, 12)

    local MainStroke = Stroke(
        Main,
        self.Theme.Border,
        1
    )

    --==================================================
    -- TOPBAR
    --==================================================

    local Topbar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0
    }, Main)

    Corner(Topbar, 12)

    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0
    }, Topbar)

    Create("TextLabel", {
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.fromOffset(12, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Topbar)

    Create("TextLabel", {
        Size = UDim2.new(1, -100, 0, 15),
        Position = UDim2.fromOffset(13, 25),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = self.Theme.Muted,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Topbar)

    local Minimize = Create("TextButton", {
        Size = UDim2.fromOffset(29, 29),
        Position = UDim2.new(1, -64, 0, 8),
        BackgroundColor3 = self.Theme.Element,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 20
    }, Topbar)

    Corner(Minimize, 8)

    local Close = Create("TextButton", {
        Size = UDim2.fromOffset(29, 29),
        Position = UDim2.new(1, -32, 0, 8),
        BackgroundColor3 = self.Theme.Element,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 17,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        ZIndex = 20
    }, Topbar)

    Corner(Close, 8)

    --==================================================
    -- DRAG AREA
    --==================================================

    local DragArea = Create("TextButton", {
        Name = "DragArea",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10
    }, Topbar)

    local dragging = false
    local dragStart
    local startPosition
    local dragInput
    local dragConnection

    Connect(DragArea.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
        dragInput = input

        Connect(input.Changed, function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end)

    Connect(DragArea.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    dragConnection = Connect(
        UserInputService.InputChanged,
        function(input)
            if not dragging then
                return
            end

            if input ~= dragInput
                and input.UserInputType ~= Enum.UserInputType.Touch
                and input.UserInputType ~= Enum.UserInputType.MouseMovement then
                return
            end

            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    )

    --==================================================
    -- SIDEBAR
    --==================================================

    local SidebarWidth = IsMobile() and 92 or 105

    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, SidebarWidth, 1, -46),
        Position = UDim2.fromOffset(0, 46),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0
    }, Main)

    --==================================================
    -- SEARCH
    --==================================================

    local Search = Create("TextBox", {
        Size = UDim2.new(1, -12, 0, 31),
        Position = UDim2.fromOffset(6, 7),
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0,
        PlaceholderText = "Search...",
        PlaceholderColor3 = self.Theme.Muted,
        Text = "",
        TextColor3 = self.Theme.Text,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false
    }, Sidebar)

    Corner(Search, 8)

    --==================================================
    -- TAB CONTAINER
    --==================================================

    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(1, -8, 1, -47),
        Position = UDim2.fromOffset(4, 44),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, Sidebar)

    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabContainer)

    Padding(TabContainer, 2, 2, 2, 5)

    --==================================================
    -- CONTENT
    --==================================================

    local Content = Create("Frame", {
        Size = UDim2.new(
            1,
            -SidebarWidth,
            1,
            -46
        ),
        Position = UDim2.new(
            0,
            SidebarWidth,
            0,
            46
        ),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0
    }, Main)

    --==================================================
    -- DATA
    --==================================================

    local Pages = {}
    local SelectedTab
    local minimized = false
    local destroyed = false

    --==================================================
    -- SELECT TAB
    --==================================================

    local function SelectTab(tabData)
        if destroyed or not tabData then
            return
        end

        SelectedTab = tabData

        for _, data in ipairs(Pages) do
            local active = data == tabData

            data.Page.Visible = active

            if active then
                Tween(data.Button, 0.15, {
                    BackgroundColor3 = self.Theme.Accent
                })

                Tween(data.ButtonText, 0.15, {
                    TextColor3 = Color3.new(1, 1, 1)
                })
            else
                Tween(data.Button, 0.15, {
                    BackgroundColor3 = self.Theme.Element
                })

                Tween(data.ButtonText, 0.15, {
                    TextColor3 = self.Theme.Muted
                })
            end
        end
    end

    --==================================================
    -- MINIMIZE
    --==================================================

    local function SetMinimized(value)
        if destroyed then
            return
        end

        minimized = value

        if minimized then
            Tween(Main, 0.2, {
                Size = UDim2.fromOffset(width, 46)
            })

            Sidebar.Visible = false
            Content.Visible = false
            Minimize.Text = "+"
        else
            Tween(Main, 0.2, {
                Size = UDim2.fromOffset(width, height)
            })

            task.delay(0.17, function()
                if not minimized and not destroyed then
                    Sidebar.Visible = true
                    Content.Visible = true
                end
            end)

            Minimize.Text = "—"
        end
    end

    Connect(Minimize.Activated, function()
        SetMinimized(not minimized)
    end)

    --==================================================
    -- CLOSE
    --==================================================

    Connect(Close.Activated, function()
        if destroyed then
            return
        end

        destroyed = true

        Tween(Main, 0.18, {
            Size = UDim2.fromOffset(
                math.max(width - 20, 200),
                0
            )
        })

        task.wait(0.2)

        if Main then
            Main:Destroy()
        end
    end)

    --==================================================
    -- WINDOW API
    --==================================================

    window.Main = Main
    window.Tabs = Pages
    window.ScreenGui = ScreenGui

    function window:SetVisibility(value)
        if not destroyed and Main then
            Main.Visible = value
        end
    end

    function window:IsVisible()
        return Main and Main.Visible or false
    end

    function window:Minimize()
        SetMinimized(true)
    end

    function window:Restore()
        SetMinimized(false)
    end

    function window:Destroy()
        if destroyed then
            return
        end

        destroyed = true

        if Main then
            Main:Destroy()
        end
    end

    function window:SelectTab(name)
        for _, tab in ipairs(Pages) do
            if tab.Name == tostring(name) then
                SelectTab(tab)
                return
            end
        end
    end

    --==================================================
    -- CREATE TAB
    --==================================================

    function window:CreateTab(name, icon)
        name = tostring(name or "Tab")

        local tabData = {
            Name = name
        }

        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, -2, 0, 42),
            BackgroundColor3 = self.Theme.Element,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false
        }, TabContainer)

        Corner(TabButton, 9)

        local TabText = Create("TextLabel", {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.fromOffset(7, 0),
            BackgroundTransparency = 1,
            Text = (icon and tostring(icon) .. "  " or "") .. name,
            TextColor3 = self.Theme.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left
        }, TabButton)

        local Page = Create("ScrollingFrame", {
            Name = name .. "_Page",
            Size = UDim2.new(1, -10, 1, -8),
            Position = UDim2.fromOffset(5, 4),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        }, Content)

        Padding(Page, 3, 3, 7, 8)

        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 7),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        tabData.Button = TabButton
        tabData.ButtonText = TabText
        tabData.Page = Page
        tabData.Layout = Layout

        table.insert(Pages, tabData)

        Connect(TabButton.Activated, function()
            SelectTab(tabData)
        end)

        -- FIX: automatically select the first tab.
        if #Pages == 1 then
            SelectTab(tabData)
        end

        --==================================================
        -- SECTION
        --==================================================

        function tabData:CreateSection(text)
            local section = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Text = tostring(text or "Section"),
                TextColor3 = self.Theme and self.Theme.Text
                    or M4teoUI.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

            return section
        end

        --==================================================
        -- LABEL
        --==================================================

        function tabData:CreateLabel(text)
            local label = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Text = tostring(text or ""),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

            Corner(label, 8)
            Padding(label, 10, 0, 10, 0)

            return label
        end

        --==================================================
        -- PARAGRAPH
        --==================================================

        function tabData:CreateParagraph(config)
            config = config or {}

            local titleText = tostring(
                config.Title or "Paragraph"
            )

            local contentText = tostring(
                config.Content or ""
            )

            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 68),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(frame, 9)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.fromOffset(10, 7),
                BackgroundTransparency = 1,
                Text = titleText,
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 36),
                Position = UDim2.fromOffset(10, 28),
                BackgroundTransparency = 1,
                Text = contentText,
                TextColor3 = M4teoUI.Theme.Muted,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            }, frame)

            return frame
        end

        --==================================================
        -- BUTTON
        --==================================================

        function tabData:CreateButton(config)
            config = config or {}

            local button = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Text = tostring(config.Name or "Button"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            }, Page)

            Corner(button, 8)

            Connect(button.Activated, function()
                Tween(button, 0.08, {
                    BackgroundColor3 = M4teoUI.Theme.Accent
                })

                task.delay(0.1, function()
                    if button and button.Parent then
                        Tween(button, 0.12, {
                            BackgroundColor3 = M4teoUI.Theme.Element
                        })
                    end
                end)

                Safe(config.Callback)
            end)

            return button
        end

        --==================================================
        -- TOGGLE
        --==================================================

        function tabData:CreateToggle(config)
            config = config or {}

            local state = config.CurrentValue == true

            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(frame, 8)

            local button = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            }, frame)

            local label = Create("TextLabel", {
                Size = UDim2.new(1, -55, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(config.Name or "Toggle"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local switch = Create("Frame", {
                Size = UDim2.fromOffset(34, 18),
                Position = UDim2.new(1, -44, 0.5, -9),
                BackgroundColor3 = state
                    and M4teoUI.Theme.ToggleOn
                    or M4teoUI.Theme.ToggleOff,
                BorderSizePixel = 0
            }, frame)

            Corner(switch, 9)

            local knob = Create("Frame", {
                Size = UDim2.fromOffset(14, 14),
                Position = state
                    and UDim2.new(1, -16, 0, 2)
                    or UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0
            }, switch)

            Corner(knob, 7)

            local function SetValue(value, callback)
                state = value == true

                Tween(switch, 0.15, {
                    BackgroundColor3 = state
                        and M4teoUI.Theme.ToggleOn
                        or M4teoUI.Theme.ToggleOff
                })

                Tween(knob, 0.15, {
                    Position = state
                        and UDim2.new(1, -16, 0, 2)
                        or UDim2.fromOffset(2, 2)
                })

                if callback ~= false then
                    Safe(config.Callback, state)
                end

                if config.Flag then
                    M4teoUI.Flags[config.Flag] = state
                end
            end

            Connect(button.Activated, function()
                SetValue(not state)
            end)

            local object = {}

            function object:Set(value)
                SetValue(value)
            end

            function object:Get()
                return state
            end

            return object
        end

        --==================================================
        -- SLIDER
        --==================================================

        function tabData:CreateSlider(config)
            config = config or {}

            local min = tonumber(config.Range and config.Range[1])
                or tonumber(config.Min)
                or 0

            local max = tonumber(config.Range and config.Range[2])
                or tonumber(config.Max)
                or 100

            local current = tonumber(config.CurrentValue)
                or tonumber(config.Default)
                or min

            local increment = tonumber(config.Increment)
                or 1

            current = math.clamp(current, min, max)

            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(frame, 8)

            local label = Create("TextLabel", {
                Size = UDim2.new(1, -65, 0, 22),
                Position = UDim2.fromOffset(10, 5),
                BackgroundTransparency = 1,
                Text = tostring(config.Name or "Slider"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local valueLabel = Create("TextLabel", {
                Size = UDim2.fromOffset(55, 22),
                Position = UDim2.new(1, -62, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(current),
                TextColor3 = M4teoUI.Theme.Accent,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right
            }, frame)

            local bar = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.fromOffset(10, 38),
                BackgroundColor3 = M4teoUI.Theme.ToggleOff,
                BorderSizePixel = 0
            }, frame)

            Corner(bar, 3)

            local fill = Create("Frame", {
                Size = UDim2.new(
                    (current - min) / math.max(max - min, 1),
                    0,
                    1,
                    0
                ),
                BackgroundColor3 = M4teoUI.Theme.Accent,
                BorderSizePixel = 0
            }, bar)

            Corner(fill, 3)

            local draggingSlider = false

            local function SetValue(value, callback)
                value = math.clamp(value, min, max)

                if increment > 0 then
                    value = min
                        + math.floor(
                            ((value - min) / increment) + 0.5
                        ) * increment
                end

                value = math.clamp(value, min, max)
                current = value

                local percent =
                    (current - min)
                    / math.max(max - min, 1)

                Tween(fill, 0.08, {
                    Size = UDim2.new(percent, 0, 1, 0)
                })

                valueLabel.Text = tostring(
                    Round(current, 3)
                )

                if config.Flag then
                    M4teoUI.Flags[config.Flag] = current
                end

                if callback ~= false then
                    Safe(config.Callback, current)
                end
            end

            local function UpdateFromInput(input)
                local x = input.Position.X
                local start = bar.AbsolutePosition.X
                local size = bar.AbsoluteSize.X

                local percent = math.clamp(
                    (x - start) / math.max(size, 1),
                    0,
                    1
                )

                SetValue(
                    min + ((max - min) * percent)
                )
            end

            Connect(bar.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    draggingSlider = true
                    UpdateFromInput(input)
                end
            end)

            Connect(UserInputService.InputChanged, function(input)
                if not draggingSlider then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then

                    UpdateFromInput(input)
                end
            end)

            Connect(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    draggingSlider = false
                end
            end)

            local object = {}

            function object:Set(value)
                SetValue(value)
            end

            function object:Get()
                return current
            end

            return object
        end

        --==================================================
        -- DROPDOWN
        --==================================================

        function tabData:CreateDropdown(config)
            config = config or {}

            local values = config.Options
                or config.Values
                or {}

            local selected = config.CurrentOption
                or config.CurrentValue
                or config.Default

            if type(selected) == "table" then
                selected = selected[1]
            end

            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                ClipsDescendants = true
            }, Page)

            Corner(frame, 8)

            local header = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 5
            }, frame)

            local titleLabel = Create("TextLabel", {
                Size = UDim2.new(0.55, 0, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(config.Name or "Dropdown"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local selectedLabel = Create("TextLabel", {
                Size = UDim2.new(0.4, -10, 1, 0),
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(selected or "Select..."),
                TextColor3 = M4teoUI.Theme.Accent,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Right
            }, frame)

            local arrow = Create("TextLabel", {
                Size = UDim2.fromOffset(15, 20),
                Position = UDim2.new(1, -22, 0, 11),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = M4teoUI.Theme.Muted,
                TextSize = 8,
                Font = Enum.Font.GothamBold
            }, frame)

            local optionContainer = Create("ScrollingFrame", {
                Size = UDim2.new(1, -12, 0, 100),
                Position = UDim2.fromOffset(6, 46),
                BackgroundColor3 = M4teoUI.Theme.Background,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = M4teoUI.Theme.Accent,
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y
            }, frame)

            Corner(optionContainer, 7)

            Padding(optionContainer, 4, 4, 4, 4)

            local optionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, optionContainer)

            local opened = false

            local function RebuildOptions()
                for _, child in ipairs(optionContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(values) do
                    local optionText = tostring(option)

                    local button = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = M4teoUI.Theme.Element,
                        BorderSizePixel = 0,
                        Text = optionText,
                        TextColor3 = M4teoUI.Theme.Text,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false
                    }, optionContainer)

                    Corner(button, 6)

                    Connect(button.Activated, function()
                        selected = option
                        selectedLabel.Text = optionText

                        opened = false

                        Tween(frame, 0.15, {
                            Size = UDim2.new(1, 0, 0, 42)
                        })

                        arrow.Text = "▼"

                        if config.Flag then
                            M4teoUI.Flags[config.Flag] = option
                        end

                        Safe(config.Callback, option)
                    end)
                end
            end

            RebuildOptions()

            Connect(header.Activated, function()
                opened = not opened

                if opened then
                    local count = math.min(#values, 4)
                    local optionHeight = 31 * count + 8

                    Tween(frame, 0.18, {
                        Size = UDim2.new(
                            1,
                            0,
                            0,
                            42 + math.max(optionHeight, 38)
                        )
                    })

                    arrow.Text = "▲"
                else
                    Tween(frame, 0.18, {
                        Size = UDim2.new(1, 0, 0, 42)
                    })

                    arrow.Text = "▼"
                end
            end)

            local object = {}

            function object:Set(value)
                selected = value
                selectedLabel.Text = tostring(value)

                if config.Flag then
                    M4teoUI.Flags[config.Flag] = value
                end
            end

            function object:Refresh(newValues)
                values = newValues or {}
                RebuildOptions()
            end

            function object:Get()
                return selected
            end

            return object
        end

        --==================================================
        -- INPUT / TEXTBOX
        --==================================================

        function tabData:CreateInput(config)
            config = config or {}

            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 58),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(frame, 8)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.fromOffset(10, 4),
                BackgroundTransparency = 1,
                Text = tostring(config.Name or "Input"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local box = Create("TextBox", {
                Size = UDim2.new(1, -20, 0, 27),
                Position = UDim2.fromOffset(10, 27),
                BackgroundColor3 = M4teoUI.Theme.Background,
                BorderSizePixel = 0,
                PlaceholderText = tostring(
                    config.PlaceholderText
                    or config.Placeholder
                    or "Enter text..."
                ),
                PlaceholderColor3 = M4teoUI.Theme.Muted,
                Text = tostring(
                    config.CurrentValue
                    or config.Default
                    or ""
                ),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false
            }, frame)

            Corner(box, 6)

            Connect(box.FocusLost, function()
                local value = box.Text

                if config.Flag then
                    M4teoUI.Flags[config.Flag] = value
                end

                Safe(config.Callback, value)
            end)

            local object = {}

            function object:Set(value)
                box.Text = tostring(value or "")
            end

            function object:Get()
                return box.Text
            end

            return object
        end

        --==================================================
        -- KEYBIND
        --==================================================

        function tabData:CreateKeybind(config)
            config = config or {}

            local currentKey = config.CurrentKey
                or config.Default
                or Enum.KeyCode.RightShift

            if type(currentKey) == "string" then
                currentKey = Enum.KeyCode[currentKey]
                    or Enum.KeyCode.RightShift
            end

            local frame = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, Page)

            Corner(frame, 8)

            Create("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(config.Name or "Keybind"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local keyLabel = Create("TextLabel", {
                Size = UDim2.fromOffset(65, 28),
                Position = UDim2.new(1, -72, 0.5, -14),
                BackgroundColor3 = M4teoUI.Theme.Background,
                Text = currentKey.Name,
                TextColor3 = M4teoUI.Theme.Accent,
                TextSize = 9,
                Font = Enum.Font.GothamBold
            }, frame)

            Corner(keyLabel, 6)

            local listening = false

            Connect(frame.Activated, function()
                if listening then
                    return
                end

                listening = true
                keyLabel.Text = "..."

                local connection

                connection = UserInputService.InputBegan:Connect(
                    function(input, processed)
                        if processed then
                            return
                        end

                        if input.UserInputType
                            ~= Enum.UserInputType.Keyboard then
                            return
                        end

                        currentKey = input.KeyCode
                        keyLabel.Text = currentKey.Name
                        listening = false

                        if connection then
                            connection:Disconnect()
                        end
                    end
                )
            end)

            Connect(
                UserInputService.InputBegan,
                function(input, processed)
                    if processed or listening then
                        return
                    end

                    if input.KeyCode == currentKey then
                        Safe(config.Callback)
                    end
                end
            )

            local object = {}

            function object:Set(key)
                if type(key) == "string" then
                    key = Enum.KeyCode[key]
                end

                if key then
                    currentKey = key
                    keyLabel.Text = key.Name
                end
            end

            function object:Get()
                return currentKey
            end

            return object
        end

        --==================================================
        -- COLOR PICKER
        --==================================================

        function tabData:CreateColorPicker(config)
            config = config or {}

            local currentColor =
                typeof(config.Color) == "Color3"
                and config.Color
                or M4teoUI.Theme.Accent

            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(frame, 8)

            Create("TextLabel", {
                Size = UDim2.new(1, -55, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(config.Name or "Color"),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local preview = Create("TextButton", {
                Size = UDim2.fromOffset(32, 24),
                Position = UDim2.new(1, -42, 0.5, -12),
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, frame)

            Corner(preview, 7)

            local popup

            local function ClosePopup()
                if popup then
                    popup:Destroy()
                    popup = nil
                end
            end

            local function CreatePopup()
                ClosePopup()

                popup = Create("Frame", {
                    Size = UDim2.fromOffset(240, 175),
                    Position = UDim2.new(
                        0.5,
                        -120,
                        0.5,
                        -87
                    ),
                    BackgroundColor3 = M4teoUI.Theme.Background,
                    BorderSizePixel = 0,
                    ZIndex = 100
                }, ScreenGui)

                Corner(popup, 10)
                Stroke(popup, M4teoUI.Theme.Border, 1)

                Create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.fromOffset(10, 7),
                    BackgroundTransparency = 1,
                    Text = "Color Picker",
                    TextColor3 = M4teoUI.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 101
                }, popup)

                local r = Create("TextBox", {
                    Size = UDim2.fromOffset(60, 30),
                    Position = UDim2.fromOffset(12, 45),
                    BackgroundColor3 = M4teoUI.Theme.Element,
                    Text = tostring(
                        math.floor(currentColor.R * 255)
                    ),
                    TextColor3 = M4teoUI.Theme.Text,
                    PlaceholderText = "R",
                    TextSize = 10,
                    ZIndex = 101
                }, popup)

                local g = Create("TextBox", {
                    Size = UDim2.fromOffset(60, 30),
                    Position = UDim2.fromOffset(80, 45),
                    BackgroundColor3 = M4teoUI.Theme.Element,
                    Text = tostring(
                        math.floor(currentColor.G * 255)
                    ),
                    TextColor3 = M4teoUI.Theme.Text,
                    PlaceholderText = "G",
                    TextSize = 10,
                    ZIndex = 101
                }, popup)

                local b = Create("TextBox", {
                    Size = UDim2.fromOffset(60, 30),
                    Position = UDim2.fromOffset(148, 45),
                    BackgroundColor3 = M4teoUI.Theme.Element,
                    Text = tostring(
                        math.floor(currentColor.B * 255)
                    ),
                    TextColor3 = M4teoUI.Theme.Text,
                    PlaceholderText = "B",
                    TextSize = 10,
                    ZIndex = 101
                }, popup)

                Corner(r, 6)
                Corner(g, 6)
                Corner(b, 6)

                local previewBox = Create("Frame", {
                    Size = UDim2.fromOffset(60, 25),
                    Position = UDim2.fromOffset(90, 88),
                    BackgroundColor3 = currentColor,
                    BorderSizePixel = 0,
                    ZIndex = 101
                }, popup)

                Corner(previewBox, 6)

                local cancel = Create("TextButton", {
                    Size = UDim2.fromOffset(90, 32),
                    Position = UDim2.fromOffset(15, 130),
                    BackgroundColor3 = M4teoUI.Theme.Element,
                    Text = "Cancelar",
                    TextColor3 = M4teoUI.Theme.Text,
                    TextSize = 10,
                    ZIndex = 101
                }, popup)

                local accept = Create("TextButton", {
                    Size = UDim2.fromOffset(90, 32),
                    Position = UDim2.fromOffset(135, 130),
                    BackgroundColor3 = M4teoUI.Theme.Accent,
                    Text = "Aceptar",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 10,
                    ZIndex = 101
                }, popup)

                Corner(cancel, 6)
                Corner(accept, 6)

                local function UpdatePreview()
                    local rv = math.clamp(
                        tonumber(r.Text) or 0,
                        0,
                        255
                    )

                    local gv = math.clamp(
                        tonumber(g.Text) or 0,
                        0,
                        255
                    )

                    local bv = math.clamp(
                        tonumber(b.Text) or 0,
                        0,
                        255
                    )

                    previewBox.BackgroundColor3 =
                        Color3.fromRGB(rv, gv, bv)

                    return Color3.fromRGB(rv, gv, bv)
                end

                Connect(r:GetPropertyChangedSignal("Text"), UpdatePreview)
                Connect(g:GetPropertyChangedSignal("Text"), UpdatePreview)
                Connect(b:GetPropertyChangedSignal("Text"), UpdatePreview)

                Connect(cancel.Activated, function()
                    ClosePopup()
                end)

                Connect(accept.Activated, function()
                    currentColor = UpdatePreview()
                    preview.BackgroundColor3 = currentColor

                    if config.Flag then
                        M4teoUI.Flags[config.Flag] =
                            currentColor
                    end

                    Safe(config.Callback, currentColor)

                    ClosePopup()
                end)
            end

            Connect(preview.Activated, function()
                CreatePopup()
            end)

            local object = {}

            function object:Set(color)
                if typeof(color) ~= "Color3" then
                    return
                end

                currentColor = color
                preview.BackgroundColor3 = color
            end

            function object:Get()
                return currentColor
            end

            return object
        end

        return tabData
    end

    --==================================================
    -- THEME
    --==================================================

    function window:ApplyTheme()
        if destroyed then
            return
        end

        Main.BackgroundColor3 = self.Theme.Background
        MainStroke.Color = self.Theme.Border

        Topbar.BackgroundColor3 = self.Theme.Sidebar
        Sidebar.BackgroundColor3 = self.Theme.Sidebar
        Content.BackgroundColor3 = self.Theme.Background

        for _, tab in ipairs(Pages) do
            tab.Button.BackgroundColor3 =
                tab == SelectedTab
                and self.Theme.Accent
                or self.Theme.Element

            tab.ButtonText.TextColor3 =
                tab == SelectedTab
                and Color3.new(1, 1, 1)
                or self.Theme.Muted

            tab.Page.ScrollBarImageColor3 =
                self.Theme.Accent
        end
    end

    table.insert(self.Windows, window)

    --==================================================
    -- OPEN ANIMATION
    --==================================================

    Main.Size = UDim2.fromOffset(
        math.max(width - 25, 250),
        math.max(height - 25, 220)
    )

    Tween(Main, 0.25, {
        Size = UDim2.fromOffset(width, height)
    })

    return window
end

--==================================================
-- COMPATIBILITY
--==================================================

function M4teoUI:Create(config)
    return self:CreateWindow(config)
end

function M4teoUI:SetVisibility(value)
    ScreenGui.Enabled = value
end

function M4teoUI:IsVisible()
    return ScreenGui.Enabled
end

function M4teoUI:Destroy()
    pcall(function()
        ScreenGui:Destroy()
    end)
end

return M4teoUI
