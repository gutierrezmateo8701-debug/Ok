--[[
    M4teoUI v2
    Original Roblox UI Library
    Executor-oriented
    API estilo Rayfield, implementación propia

    Características:
    • Window
    • Tabs
    • Sections
    • Labels
    • Paragraphs
    • Buttons
    • Toggles
    • Sliders
    • Dropdowns
    • Inputs
    • Keybinds
    • ColorPicker
    • Notifications
    • Themes
    • Flags
    • Options
    • Minimize
    • Destroy
    • Search
    • Drag
    • Animations
    • Mobile support
    • Config encode/decode
]]

local M4teoUI = {}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

--// Storage
M4teoUI.Flags = {}
M4teoUI.Options = {}
M4teoUI.Themes = {}
M4teoUI.Windows = {}
M4teoUI.Connections = {}

--//========================================================
--// Utility
--//========================================================

local function Safe(callback, ...)
    if typeof(callback) ~= "function" then
        return
    end

    local args = table.pack(...)

    task.spawn(function()
        pcall(function()
            callback(table.unpack(args, 1, args.n))
        end)
    end)
end

local function Connect(signal, callback, storage)
    local connection = signal:Connect(callback)

    storage = storage or M4teoUI.Connections

    table.insert(storage, connection)

    return connection
end

local function DisconnectAll(storage)
    for _, connection in ipairs(storage or {}) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(storage or {})
end

local function Create(class, properties, parent)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        pcall(function()
            object[property] = value
        end)
    end

    if parent then
        object.Parent = parent
    end

    return object
end

local function Corner(object, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, object)
end

local function Stroke(object, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Color3.new(1, 1, 1),
        Thickness = thickness or 1,
        Transparency = transparency or 0
    }, object)
end

local function Padding(object, left, right, top, bottom)
    return Create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0)
    }, object)
end

local function Tween(object, duration, properties, style, direction)
    if not object then
        return
    end

    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )

    local animation = TweenService:Create(object, info, properties)

    animation:Play()

    return animation
end

local function CopyTable(original)
    local copy = {}

    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = CopyTable(value)
        else
            copy[key] = value
        end
    end

    return copy
end

local function IsMobile()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
end

local function GetGuiParent()
    local success, result = pcall(function()
        if gethui then
            return gethui()
        end
    end)

    if success and result then
        return result
    end

    return CoreGui
end

--//========================================================
--// Themes
--//========================================================

local Themes = {

    Dark = {
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(22, 22, 27),
        Element = Color3.fromRGB(28, 28, 34),
        ElementHover = Color3.fromRGB(37, 37, 45),

        Accent = Color3.fromRGB(0, 170, 255),
        AccentDark = Color3.fromRGB(0, 120, 210),

        Text = Color3.fromRGB(245, 245, 248),
        Muted = Color3.fromRGB(155, 155, 165),

        Border = Color3.fromRGB(55, 55, 65),

        Success = Color3.fromRGB(70, 200, 120),
        Danger = Color3.fromRGB(220, 80, 90),
        Warning = Color3.fromRGB(235, 180, 70)
    },

    Purple = {
        Background = Color3.fromRGB(21, 18, 27),
        Sidebar = Color3.fromRGB(28, 22, 36),
        Element = Color3.fromRGB(38, 29, 49),
        ElementHover = Color3.fromRGB(51, 39, 65),

        Accent = Color3.fromRGB(170, 90, 255),
        AccentDark = Color3.fromRGB(120, 55, 220),

        Text = Color3.fromRGB(250, 245, 255),
        Muted = Color3.fromRGB(175, 160, 190),

        Border = Color3.fromRGB(75, 55, 95),

        Success = Color3.fromRGB(70, 200, 120),
        Danger = Color3.fromRGB(220, 80, 90),
        Warning = Color3.fromRGB(235, 180, 70)
    },

    Blue = {
        Background = Color3.fromRGB(15, 20, 30),
        Sidebar = Color3.fromRGB(18, 25, 38),
        Element = Color3.fromRGB(24, 33, 50),
        ElementHover = Color3.fromRGB(33, 44, 65),

        Accent = Color3.fromRGB(65, 150, 255),
        AccentDark = Color3.fromRGB(35, 105, 220),

        Text = Color3.fromRGB(245, 248, 255),
        Muted = Color3.fromRGB(155, 170, 190),

        Border = Color3.fromRGB(50, 75, 110),

        Success = Color3.fromRGB(70, 200, 120),
        Danger = Color3.fromRGB(220, 80, 90),
        Warning = Color3.fromRGB(235, 180, 70)
    },

    Red = {
        Background = Color3.fromRGB(25, 17, 19),
        Sidebar = Color3.fromRGB(34, 21, 24),
        Element = Color3.fromRGB(48, 27, 31),
        ElementHover = Color3.fromRGB(64, 35, 40),

        Accent = Color3.fromRGB(255, 75, 90),
        AccentDark = Color3.fromRGB(210, 45, 60),

        Text = Color3.fromRGB(255, 245, 246),
        Muted = Color3.fromRGB(190, 160, 165),

        Border = Color3.fromRGB(100, 55, 62),

        Success = Color3.fromRGB(70, 200, 120),
        Danger = Color3.fromRGB(255, 70, 80),
        Warning = Color3.fromRGB(235, 180, 70)
    }
}

M4teoUI.Themes = Themes
M4teoUI.Theme = CopyTable(Themes.Dark)

--//========================================================
--// GUI
--//========================================================

local Existing = GetGuiParent():FindFirstChild("M4teoUI")

if Existing then
    pcall(function()
        Existing:Destroy()
    end)
end

local ScreenGui = Create("ScreenGui", {
    Name = "M4teoUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, GetGuiParent())

M4teoUI.Gui = ScreenGui

--//========================================================
--// Theme API
--//========================================================

function M4teoUI:SetTheme(theme)
    if typeof(theme) == "string" then
        theme = self.Themes[theme]
    end

    if typeof(theme) ~= "table" then
        return
    end

    self.Theme = CopyTable(theme)

    for _, window in ipairs(self.Windows) do
        if window._ApplyTheme then
            Safe(window._ApplyTheme)
        end
    end
end

function M4teoUI:SetThemeByName(name)
    if self.Themes[name] then
        self:SetTheme(self.Themes[name])
    end
end

function M4teoUI:RegisterTheme(name, theme)
    if typeof(name) ~= "string" then
        return
    end

    if typeof(theme) ~= "table" then
        return
    end

    self.Themes[name] = CopyTable(theme)
end

function M4teoUI:GetThemes()
    local result = {}

    for name in pairs(self.Themes) do
        table.insert(result, name)
    end

    table.sort(result)

    return result
end

--//========================================================
--// Notification System
--//========================================================

local NotificationHolder

local function GetNotificationHolder()
    if NotificationHolder then
        return NotificationHolder
    end

    NotificationHolder = Create("Frame", {
        Name = "NotificationHolder",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.new(0, 330, 0, 400),
        ZIndex = 1000
    }, ScreenGui)

    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    }, NotificationHolder)

    return NotificationHolder
end

function M4teoUI:Notify(data)
    data = data or {}

    local holder = GetNotificationHolder()

    local notification = Create("Frame", {
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 320, 0, 78),
        BackgroundTransparency = 0.02,
        ZIndex = 1001
    }, holder)

    Corner(notification, 10)

    local notificationStroke = Stroke(
        notification,
        self.Theme.Border,
        1,
        0.1
    )

    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 9),
        Size = UDim2.new(1, -45, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = data.Title or "M4teoUI",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1002
    }, notification)

    local content = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 31),
        Size = UDim2.new(1, -28, 0, 37),
        Font = Enum.Font.Gotham,
        Text = data.Content or "",
        TextColor3 = self.Theme.Muted,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 1002
    }, notification)

    local close = Create("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 7),
        Size = UDim2.new(0, 24, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.Muted,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 1003
    }, notification)

    notification.Position = UDim2.new(1, 30, 0, 0)

    Tween(notification, 0.25, {
        Position = UDim2.new(0, 0, 0, 0)
    }, Enum.EasingStyle.Quart)

    local closed = false

    local function remove()
        if closed then
            return
        end

        closed = true

        Tween(notification, 0.18, {
            Position = UDim2.new(1, 30, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        task.delay(0.2, function()
            pcall(function()
                notification:Destroy()
            end)
        end)
    end

    Connect(close.MouseButton1Click, remove)

    task.delay(tonumber(data.Duration) or 3, remove)
end

--//========================================================
--// Window
--//========================================================

function M4teoUI:CreateWindow(config)

    config = config or {}

    local Window = {}

    Window._Connections = {}
    Window._Tabs = {}
    Window._Destroyed = false
    Window._Visible = true

    local mobile = IsMobile()

    local width = tonumber(config.Width)
        or (mobile and 390 or 560)

    local height = tonumber(config.Height)
        or (mobile and 470 or 400)

    --// Main
    local Main = Create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, width, 0, height),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, ScreenGui)

    Corner(Main, 12)

    local MainStroke = Stroke(
        Main,
        self.Theme.Border,
        1,
        0
    )

    --// Topbar
    local Topbar = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 58)
    }, Main)

    local Title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 7),
        Size = UDim2.new(1, -125, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = config.Name or "M4teoUI",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Topbar)

    local Subtitle = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 31),
        Size = UDim2.new(1, -125, 0, 18),
        Font = Enum.Font.Gotham,
        Text = config.Subtitle or "M4teoUI",
        TextColor3 = self.Theme.Muted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Topbar)

    --// Minimize
    local Minimize = Create("TextButton", {
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -72, 0, 14),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 15,
        AutoButtonColor = false
    }, Topbar)

    Corner(Minimize, 7)

    --// Close
    local Close = Create("TextButton", {
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -40, 0, 14),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        AutoButtonColor = false
    }, Topbar)

    Corner(Close, 7)

    --// Body
    local Body = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 58),
        Size = UDim2.new(1, -16, 1, -66)
    }, Main)

    --// Sidebar
    local Sidebar = Create("Frame", {
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 150, 1, 0)
    }, Body)

    Corner(Sidebar, 9)

    --// Search
    local Search = Create("TextBox", {
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 0, 30),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Search...",
        PlaceholderColor3 = self.Theme.Muted,
        Text = "",
        TextColor3 = self.Theme.Text,
        TextSize = 10,
        ClearTextOnFocus = false
    }, Sidebar)

    Corner(Search, 7)
    Padding(Search, 9, 9, 0, 0)

    --// Tab list
    local TabScroll = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 7, 0, 45),
        Size = UDim2.new(1, -14, 1, -52),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent
    }, Sidebar)

    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabScroll)

    --// Content
    local Content = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 158, 0, 0),
        Size = UDim2.new(1, -158, 1, 0)
    }, Body)

    --// Reopen button
    local Reopen = Create("TextButton", {
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 54, 0, 54),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "M",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        AutoButtonColor = false
    }, ScreenGui)

    Corner(Reopen, 14)

    --//====================================================
    --// Dragging
    --//====================================================

    local dragging = false
    local dragStart
    local startPosition

    Connect(Topbar.InputBegan, function(input)

        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end, Window._Connections)

    Connect(UserInputService.InputChanged, function(input)

        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end, Window._Connections)

    Connect(UserInputService.InputEnded, function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end, Window._Connections)

    --//====================================================
    --// Visibility
    --//====================================================

    local function SetVisible(state)

        if Window._Destroyed then
            return
        end

        Window._Visible = state

        if state then

            Reopen.Visible = false
            Main.Visible = true

            Main.Size = UDim2.new(0, 0, 0, 0)

            Tween(
                Main,
                0.25,
                {
                    Size = UDim2.new(0, width, 0, height)
                },
                Enum.EasingStyle.Back
            )

        else

            Tween(
                Main,
                0.2,
                {
                    Size = UDim2.new(0, 0, 0, 0)
                },
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            )

            task.delay(0.2, function()

                if Window._Destroyed then
                    return
                end

                Main.Visible = false
                Reopen.Visible = true

            end)
        end
    end

    Connect(
        Minimize.MouseButton1Click,
        function()
            SetVisible(false)
        end,
        Window._Connections
    )

    Connect(
        Reopen.MouseButton1Click,
        function()
            SetVisible(true)
        end,
        Window._Connections
    )

    Connect(
        Close.MouseButton1Click,
        function()
            Window:Destroy()
        end,
        Window._Connections
    )

    --//====================================================
    --// Window API
    --//====================================================

    function Window:SetVisibility(state)
        SetVisible(state ~= false)
    end

    function Window:IsVisible()
        return Window._Visible
    end

    function Window:Notify(data)
        M4teoUI:Notify(data)
    end

    function Window:SetTheme(theme)
        M4teoUI:SetTheme(theme)
    end

    function Window:Destroy()

        if Window._Destroyed then
            return
        end

        Window._Destroyed = true

        DisconnectAll(Window._Connections)

        for _, tab in ipairs(Window._Tabs) do
            if tab.Destroy then
                pcall(function()
                    tab:Destroy()
                end)
            end
        end

        pcall(function()
            Main:Destroy()
        end)

        pcall(function()
            Reopen:Destroy()
        end)

        for index, object in ipairs(M4teoUI.Windows) do
            if object == Window then
                table.remove(M4teoUI.Windows, index)
                break
            end
        end
    end

    --//====================================================
    --// Theme
    --//====================================================

    function Window:_ApplyTheme()

        Main.BackgroundColor3 = M4teoUI.Theme.Background
        MainStroke.Color = M4teoUI.Theme.Border

        Sidebar.BackgroundColor3 = M4teoUI.Theme.Sidebar

        Search.BackgroundColor3 = M4teoUI.Theme.Element
        Search.TextColor3 = M4teoUI.Theme.Text
        Search.PlaceholderColor3 = M4teoUI.Theme.Muted

        Title.TextColor3 = M4teoUI.Theme.Text
        Subtitle.TextColor3 = M4teoUI.Theme.Muted

        Minimize.BackgroundColor3 = M4teoUI.Theme.Element
        Close.BackgroundColor3 = M4teoUI.Theme.Element

        Reopen.BackgroundColor3 = M4teoUI.Theme.Accent

        for _, tab in ipairs(Window._Tabs) do
            if tab._ApplyTheme then
                Safe(tab._ApplyTheme)
            end
        end
    end

    --//====================================================
    --// Search
    --//====================================================

    Connect(Search:GetPropertyChangedSignal("Text"), function()

        local query = string.lower(Search.Text)

        for _, tab in ipairs(Window._Tabs) do

            local visible = query == ""
                or string.find(
                    string.lower(tab.Name),
                    query,
                    1,
                    true
                )

            tab.Button.Visible = visible
        end

    end, Window._Connections)

    --//====================================================
    --// CreateTab
    --//====================================================

    function Window:CreateTab(name, icon)

        local Tab = {}

        Tab.Name = name or ("Tab " .. tostring(#Window._Tabs + 1))
        Tab._Connections = {}
        Tab._Elements = {}

        local TabButton = Create("TextButton", {
            BackgroundColor3 = M4teoUI.Theme.Element,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 37),
            Font = Enum.Font.GothamSemibold,
            Text = (icon and tostring(icon) .. "  " or "") .. Tab.Name,
            TextColor3 = M4teoUI.Theme.Muted,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, TabScroll)

        Corner(TabButton, 7)
        Padding(TabButton, 11, 7, 0, 0)

        local Page = Create("ScrollingFrame", {
            Visible = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = M4teoUI.Theme.Accent
        }, Content)

        Padding(Page, 4, 5, 3, 3)

        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 7),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        Tab.Button = TabButton
        Tab.Page = Page
        Tab.Layout = Layout

        --// Select
        local function Select()

            for _, other in ipairs(Window._Tabs) do

                other._Selected = false
                other.Page.Visible = false

                Tween(
                    other.Button,
                    0.15,
                    {
                        BackgroundColor3 = M4teoUI.Theme.Element,
                        TextColor3 = M4teoUI.Theme.Muted
                    }
                )
            end

            Tab._Selected = true
            Page.Visible = true

            Tween(
                TabButton,
                0.15,
                {
                    BackgroundColor3 = M4teoUI.Theme.Accent,
                    TextColor3 = Color3.new(1, 1, 1)
                }
            )

            Window._ActiveTab = Tab
        end

        Connect(
            TabButton.MouseButton1Click,
            Select,
            Tab._Connections
        )

        table.insert(Window._Tabs, Tab)

        --==================================================
        -- Section
        --==================================================

        function Tab:CreateSection(text)

            local section = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -8, 0, 27),
                Font = Enum.Font.GothamBold,
                Text = text or "Section",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

            Padding(section, 5, 0, 0, 0)

            return section
        end

        --==================================================
        -- Label
        --==================================================

        function Tab:CreateLabel(text)

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 40)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(text or ""),
                TextColor3 = M4teoUI.Theme.Muted,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            }, frame)

            local Object = {}

            function Object:Set(value)
                label.Text = tostring(value)
            end

            function Object:Get()
                return label.Text
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            return Object
        end

        --==================================================
        -- Paragraph
        --==================================================

        function Tab:CreateParagraph(data)

            data = data or {}

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 75)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local title = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 7),
                Size = UDim2.new(1, -24, 0, 22),
                Font = Enum.Font.GothamBold,
                Text = data.Title or "Paragraph",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local content = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 29),
                Size = UDim2.new(1, -24, 0, 38),
                Font = Enum.Font.Gotham,
                Text = data.Content or "",
                TextColor3 = M4teoUI.Theme.Muted,
                TextSize = 11,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            }, frame)

            local Object = {}

            function Object:Set(value)
                content.Text = tostring(value)
            end

            function Object:SetTitle(value)
                title.Text = tostring(value)
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            return Object
        end

        --==================================================
        -- Button
        --==================================================

        function Tab:CreateButton(data)

            data = data or {}

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 45)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local button = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Button",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                AutoButtonColor = false
            }, frame)

            Connect(button.MouseEnter, function()
                Tween(frame, 0.12, {
                    BackgroundColor3 = M4teoUI.Theme.ElementHover
                })
            end, Tab._Connections)

            Connect(button.MouseLeave, function()
                Tween(frame, 0.12, {
                    BackgroundColor3 = M4teoUI.Theme.Element
                })
            end, Tab._Connections)

            Connect(button.MouseButton1Click, function()
                Tween(frame, 0.08, {
                    BackgroundColor3 = M4teoUI.Theme.Accent
                })

                task.delay(0.08, function()
                    if frame.Parent then
                        Tween(frame, 0.12, {
                            BackgroundColor3 = M4teoUI.Theme.Element
                        })
                    end
                end)

                Safe(data.Callback)
            end, Tab._Connections)

            local Object = {}

            function Object:SetText(value)
                button.Text = tostring(value)
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            return Object
        end

        --==================================================
        -- Toggle
        --==================================================

        function Tab:CreateToggle(data)

            data = data or {}

            local value = data.CurrentValue == true
            local flag = data.Flag or data.Name or ("Toggle" .. #Tab._Elements + 1)

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 48)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -75, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Toggle",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local switch = Create("TextButton", {
                BackgroundColor3 = value
                    and M4teoUI.Theme.Accent
                    or M4teoUI.Theme.Background,

                BorderSizePixel = 0,

                Position = UDim2.new(1, -53, 0.5, -11),
                Size = UDim2.new(0, 42, 0, 22),

                Text = "",
                AutoButtonColor = false
            }, frame)

            Corner(switch, 11)

            local knob = Create("Frame", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,

                Position = value
                    and UDim2.new(1, -20, 0.5, -8)
                    or UDim2.new(0, 4, 0.5, -8),

                Size = UDim2.new(0, 16, 0, 16)
            }, switch)

            Corner(knob, 8)

            local Object = {}

            local function SetValue(newValue, callback)

                value = newValue == true

                Tween(switch, 0.15, {
                    BackgroundColor3 = value
                        and M4teoUI.Theme.Accent
                        or M4teoUI.Theme.Background
                })

                Tween(knob, 0.15, {
                    Position = value
                        and UDim2.new(1, -20, 0.5, -8)
                        or UDim2.new(0, 4, 0.5, -8)
                })

                M4teoUI.Flags[flag] = value

                if callback ~= false then
                    Safe(data.Callback, value)
                end
            end

            Connect(
                switch.MouseButton1Click,
                function()
                    SetValue(not value)
                end,
                Tab._Connections
            )

            M4teoUI.Flags[flag] = value

            function Object:Set(newValue)
                SetValue(newValue)
            end

            function Object:Get()
                return value
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            M4teoUI.Options[flag] = Object

            return Object
        end

        --==================================================
        -- Slider
        --==================================================

        function Tab:CreateSlider(data)

            data = data or {}

            local range = data.Range or {0, 100}

            local minimum = tonumber(range[1]) or 0
            local maximum = tonumber(range[2]) or 100
            local increment = tonumber(data.Increment) or 1
            local value = tonumber(data.CurrentValue) or minimum

            local flag = data.Flag
                or data.Name
                or ("Slider" .. #Tab._Elements + 1)

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 62)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 5),
                Size = UDim2.new(0.65, 0, 0, 23),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Slider",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local valueLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.68, 0, 0, 5),
                Size = UDim2.new(0.28, 0, 0, 23),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(value),
                TextColor3 = M4teoUI.Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            }, frame)

            local bar = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 12, 0, 40),
                Size = UDim2.new(1, -24, 0, 7)
            }, frame)

            Corner(bar, 4)

            local fill = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 1, 0)
            }, bar)

            Corner(fill, 4)

            local draggingSlider = false

            local Object = {}

            local function Quantize(number)

                number = math.clamp(
                    number,
                    minimum,
                    maximum
                )

                if increment > 0 then

                    number =
                        math.floor(
                            ((number - minimum) / increment) + 0.5
                        )
                        * increment
                        + minimum

                end

                return math.clamp(
                    number,
                    minimum,
                    maximum
                )
            end

            local function SetValue(newValue, callback)

                value = Quantize(
                    tonumber(newValue) or minimum
                )

                local percent

                if maximum == minimum then
                    percent = 0
                else
                    percent =
                        (value - minimum)
                        / (maximum - minimum)
                end

                Tween(fill, 0.08, {
                    Size = UDim2.new(percent, 0, 1, 0)
                })

                valueLabel.Text = tostring(value)

                M4teoUI.Flags[flag] = value

                if callback ~= false then
                    Safe(data.Callback, value)
                end
            end

            local function UpdateFromPosition(x)

                local percent =
                    math.clamp(
                        (x - bar.AbsolutePosition.X)
                        / bar.AbsoluteSize.X,
                        0,
                        1
                    )

                local newValue =
                    minimum
                    + (maximum - minimum) * percent

                SetValue(newValue)
            end

            Connect(
                bar.InputBegan,
                function(input)

                    if input.UserInputType
                        == Enum.UserInputType.MouseButton1
                        or input.UserInputType
                        == Enum.UserInputType.Touch then

                        draggingSlider = true

                        UpdateFromPosition(
                            input.Position.X
                        )
                    end
                end,
                Tab._Connections
            )

            Connect(
                UserInputService.InputChanged,
                function(input)

                    if not draggingSlider then
                        return
                    end

                    if input.UserInputType
                        == Enum.UserInputType.MouseMovement
                        or input.UserInputType
                        == Enum.UserInputType.Touch then

                        UpdateFromPosition(
                            input.Position.X
                        )
                    end
                end,
                Tab._Connections
            )

            Connect(
                UserInputService.InputEnded,
                function(input)

                    if input.UserInputType
                        == Enum.UserInputType.MouseButton1
                        or input.UserInputType
                        == Enum.UserInputType.Touch then

                        draggingSlider = false
                    end
                end,
                Tab._Connections
            )

            SetValue(value, false)

            function Object:Set(newValue)
                SetValue(newValue)
            end

            function Object:Get()
                return value
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            M4teoUI.Options[flag] = Object

            return Object
        end

        --==================================================
        -- Dropdown
        --==================================================

        function Tab:CreateDropdown(data)

            data = data or {}

            local options = {}

            for _, option in ipairs(data.Options or {}) do
                table.insert(options, tostring(option))
            end

            local current =
                data.CurrentOption
                or options[1]
                or ""

            local flag =
                data.Flag
                or data.Name
                or ("Dropdown" .. #Tab._Elements + 1)

            local opened = false

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 44),
                ClipsDescendants = false
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local button = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = (data.Name or "Dropdown")
                    .. "    "
                    .. tostring(current),
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            }, frame)

            Padding(button, 12, 12, 0, 0)

            local list = Create("Frame", {
                Visible = false,
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 5),
                Size = UDim2.new(1, 0, 0, 40),
                ZIndex = 100,
                ClipsDescendants = true
            }, frame)

            Corner(list, 8)
            Stroke(list, M4teoUI.Theme.Border, 1)

            local scroll = Create("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(1, -10, 1, -10),
                ScrollBarThickness = 2,
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 101
            }, list)

            local layout = Create("UIListLayout", {
                Padding = UDim.new(0, 4)
            }, scroll)

            local Object = {}

            local function Rebuild()

                for _, child in ipairs(scroll:GetChildren()) do

                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(options) do

                    local optionButton = Create("TextButton", {
                        BackgroundColor3 = M4teoUI.Theme.Background,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = option,
                        TextColor3 = M4teoUI.Theme.Text,
                        TextSize = 11,
                        AutoButtonColor = false,
                        ZIndex = 102
                    }, scroll)

                    Corner(optionButton, 6)

                    Connect(
                        optionButton.MouseButton1Click,
                        function()

                            current = option

                            button.Text =
                                (data.Name or "Dropdown")
                                .. "    "
                                .. current

                            M4teoUI.Flags[flag] =
                                current

                            Safe(
                                data.Callback,
                                current
                            )

                            opened = false
                            list.Visible = false
                        end,
                        Tab._Connections
                    )
                end

                local height =
                    math.min(
                        180,
                        math.max(
                            40,
                            (#options * 34) + 10
                        )
                    )

                list.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        height
                    )
            end

            Rebuild()

            Connect(
                button.MouseButton1Click,
                function()

                    opened = not opened

                    list.Visible = opened
                end,
                Tab._Connections
            )

            M4teoUI.Flags[flag] = current

            function Object:Set(value)

                current = tostring(value)

                button.Text =
                    (data.Name or "Dropdown")
                    .. "    "
                    .. current

                M4teoUI.Flags[flag] =
                    current

                Safe(
                    data.Callback,
                    current
                )
            end

            function Object:Refresh(newOptions)

                options = {}

                for _, option in ipairs(newOptions or {}) do
                    table.insert(
                        options,
                        tostring(option)
                    )
                end

                current = options[1] or ""

                Rebuild()

                Object:Set(current)
            end

            function Object:Get()
                return current
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            M4teoUI.Options[flag] = Object

            return Object
        end

        --==================================================
        -- Input
        --==================================================

        function Tab:CreateInput(data)

            data = data or {}

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 48)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.40, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Input",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local box = Create("TextBox", {
                BackgroundColor3 = M4teoUI.Theme.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(0.42, 0, 0.5, -15),
                Size = UDim2.new(0.55, 0, 0, 30),
                Font = Enum.Font.Gotham,
                PlaceholderText =
                    data.PlaceholderText
                    or "Type here...",
                PlaceholderColor3 = M4teoUI.Theme.Muted,
                Text = data.CurrentValue or "",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 11,
                ClearTextOnFocus = false
            }, frame)

            Corner(box, 7)
            Padding(box, 8, 8, 0, 0)

            Connect(
                box.FocusLost,
                function(enterPressed)

                    Safe(
                        data.Callback,
                        box.Text,
                        enterPressed
                    )
                end,
                Tab._Connections
            )

            local Object = {}

            function Object:Set(value)
                box.Text = tostring(value)
            end

            function Object:Get()
                return box.Text
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            return Object
        end

        --==================================================
        -- Keybind
        --==================================================

        function Tab:CreateKeybind(data)

            data = data or {}

            local key = data.CurrentKeybind
                or Enum.KeyCode.RightShift

            if typeof(key) == "string"
                and Enum.KeyCode[key] then

                key = Enum.KeyCode[key]
            end

            local listening = false

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 48)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.55, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Keybind",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local keyButton = Create("TextButton", {
                BackgroundColor3 = M4teoUI.Theme.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -105, 0.5, -15),
                Size = UDim2.new(0, 93, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = key.Name,
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 10,
                AutoButtonColor = false
            }, frame)

            Corner(keyButton, 7)

            local Object = {}

            Connect(
                keyButton.MouseButton1Click,
                function()

                    listening = true

                    keyButton.Text =
                        "Press key..."
                end,
                Tab._Connections
            )

            Connect(
                UserInputService.InputBegan,
                function(input, processed)

                    if listening then

                        if input.UserInputType
                            == Enum.UserInputType.Keyboard then

                            key = input.KeyCode

                            listening = false

                            keyButton.Text =
                                key.Name

                            Safe(
                                data.Callback,
                                key
                            )
                        end

                        return
                    end

                    if processed then
                        return
                    end

                    if input.KeyCode == key then
                        Safe(
                            data.Callback,
                            key
                        )
                    end
                end,
                Tab._Connections
            )

            function Object:Set(newKey)

                if typeof(newKey) == "string"
                    and Enum.KeyCode[newKey] then

                    newKey = Enum.KeyCode[newKey]
                end

                if typeof(newKey) == "EnumItem" then

                    key = newKey

                    keyButton.Text =
                        key.Name
                end
            end

            function Object:Get()
                return key
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            return Object
        end

        --==================================================
        -- ColorPicker
        --==================================================

        function Tab:CreateColorPicker(data)

            data = data or {}

            local color =
                data.Color
                or Color3.fromRGB(
                    255,
                    255,
                    255
                )

            local frame = Create("Frame", {
                BackgroundColor3 = M4teoUI.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -8, 0, 48)
            }, Page)

            Corner(frame, 8)
            Stroke(frame, M4teoUI.Theme.Border, 1, 0.25)

            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Color",
                TextColor3 = M4teoUI.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)

            local preview = Create("TextButton", {
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -47, 0.5, -13),
                Size = UDim2.new(0, 34, 0, 26),
                Text = "",
                AutoButtonColor = false
            }, frame)

            Corner(preview, 7)

            local Object = {}

            -- Basic RGB editing API.
            -- A full popup can be attached later without changing this API.

            function Object:Set(newColor)

                if typeof(newColor) ~= "Color3" then
                    return
                end

                color = newColor

                preview.BackgroundColor3 =
                    newColor

                Safe(
                    data.Callback,
                    newColor
                )
            end

            function Object:Get()
                return color
            end

            function Object:Destroy()
                frame:Destroy()
            end

            Object._Frame = frame

            table.insert(Tab._Elements, Object)

            return Object
        end

        --==================================================
        -- Select first tab
        --==================================================

        if not Window._ActiveTab then
            Select()
        end

        return Tab
    end

    table.insert(
        self.Windows,
        Window
    )

    return Window
end

--//========================================================
--// Global Visibility
--//========================================================

function M4teoUI:SetVisibility(state)

    for _, window in ipairs(self.Windows) do

        if not window._Destroyed then
            window:SetVisibility(state)
        end
    end
end

function M4teoUI:IsVisible()

    for _, window in ipairs(self.Windows) do

        if not window._Destroyed then
            return window:IsVisible()
        end
    end

    return false
end

--//========================================================
--// Flags
--//========================================================

function M4teoUI:GetFlag(name)
    return self.Flags[name]
end

function M4teoUI:SetFlag(name, value)

    self.Flags[name] = value

    local option = self.Options[name]

    if option and option.Set then
        pcall(function()
            option:Set(value)
        end)
    end
end

function M4teoUI:ClearFlags()
    table.clear(self.Flags)
end

--//========================================================
--// Configuration
--//========================================================

function M4teoUI:Serialize()

    local result = {}

    for name, value in pairs(self.Flags) do

        if typeof(value) == "Color3" then

            result[name] = {
                Type = "Color3",
                R = value.R,
                G = value.G,
                B = value.B
            }

        elseif typeof(value) == "EnumItem" then

            result[name] = {
                Type = "Enum",
                Name = value.Name
            }

        elseif type(value) == "string"
            or type(value) == "number"
            or type(value) == "boolean" then

            result[name] = value
        end
    end

    return result
end

function M4teoUI:EncodeConfig()

    local success, encoded =
        pcall(function()

            return HttpService:JSONEncode(
                self:Serialize()
            )
        end)

    if success then
        return encoded
    end

    return "{}"
end

function M4teoUI:LoadConfig(data)

    if typeof(data) ~= "table" then
        return
    end

    for name, value in pairs(data) do

        local option =
            self.Options[name]

        if option and option.Set then

            if typeof(value) == "table"
                and value.Type == "Color3" then

                option:Set(
                    Color3.new(
                        value.R or 1,
                        value.G or 1,
                        value.B or 1
                    )
                )

            else

                option:Set(value)

            end

        else

            self.Flags[name] = value
        end
    end
end

function M4teoUI:DecodeConfig(encoded)

    local success, data =
        pcall(function()

            return HttpService:JSONDecode(
                encoded
            )
        end)

    if success then
        self:LoadConfig(data)
    end
end

--//========================================================
--// Destroy
--//========================================================

function M4teoUI:Destroy()

    for index = #self.Windows, 1, -1 do

        local window =
            self.Windows[index]

        if window then
            pcall(function()
                window:Destroy()
            end)
        end
    end

    table.clear(self.Windows)

    DisconnectAll(
        self.Connections
    )

    pcall(function()
        ScreenGui:Destroy()
    end)
end

--//========================================================
--// Compatibility
--//========================================================

M4teoUI.Create = M4teoUI.CreateWindow

return M4teoUI
