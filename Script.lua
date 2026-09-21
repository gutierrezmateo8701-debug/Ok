--// M4teoUI
--// Script.lua
--// Compact / Mobile Friendly / Scrollable Tabs + Scrollable Content
--// Rayfield-like API
--// No Loading Screen

local M4teoUI = {}

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

--==================================================
-- DATA
--==================================================

M4teoUI.Flags = {}
M4teoUI.Options = {}
M4teoUI.Windows = {}
M4teoUI.Themes = {}

local Connections = {}

--==================================================
-- THEME
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

M4teoUI.Themes.Dark = {
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

local function Safe(callback, ...)
    if type(callback) ~= "function" then
        return
    end

    task.spawn(function(...)
        pcall(callback, ...)
    end, ...)
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

local function AddStroke(object, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or M4teoUI.Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = object
    return stroke
end

local function AddPadding(object, left, top, right, bottom)
    local padding = Instance.new("UIPadding")

    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)

    padding.Parent = object

    return padding
end

local function Tween(object, duration, properties)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.15,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()

    return tween
end

local function DisconnectAll(list)
    for _, connection in ipairs(list or {}) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(list or {})
end

local function GetGuiParent()
    if type(gethui) == "function" then
        local success, result = pcall(gethui)

        if success and result then
            return result
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

local function NormalizeColor(value)
    if typeof(value) == "Color3" then
        return value
    end

    return M4teoUI.Theme.Accent
end

--==================================================
-- DESTROY OLD GUI
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
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, GetGuiParent())

--==================================================
-- NOTIFICATIONS
--==================================================

local NotificationHolder = Create("Frame", {
    Name = "Notifications",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 12),
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
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0
    }, NotificationHolder)

    Corner(notification, 10)

    local stroke = AddStroke(
        notification,
        self.Theme.Border,
        1
    )

    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.fromOffset(6, 8),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    }, notification)

    Corner(bar, 3)

    Create("TextLabel", {
        Size = UDim2.new(1, -35, 0, 22),
        Position = UDim2.fromOffset(18, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, notification)

    Create("TextLabel", {
        Size = UDim2.new(1, -35, 0, 32),
        Position = UDim2.fromOffset(18, 31),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = self.Theme.Muted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, notification)

    notification.Position = UDim2.new(1, 40, 0, 0)

    Tween(notification, 0.25, {
        Position = UDim2.new(0, 0, 0, 0)
    })

    task.delay(duration, function()
        if notification and notification.Parent then
            Tween(notification, 0.2, {
                Position = UDim2.new(1, 40, 0, 0),
                BackgroundTransparency = 1
            })

            task.wait(0.22)

            if notification then
                notification:Destroy()
            end
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
            pcall(window.ApplyTheme)
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
        viewport.X * 0.82,
        330,
        430
    )

    local height = math.clamp(
        viewport.Y * 0.62,
        260,
        330
    )

    if viewport.X < 500 then
        width = math.min(
            width,
            viewport.X - 24
        )
    end

    if viewport.Y < 500 then
        height = math.min(
            height,
            viewport.Y - 80
        )
    end

    width = math.floor(width)
    height = math.floor(height)

    local Main = Create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(
            width,
            height
        ),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, ScreenGui)

    Corner(Main, 12)

    local MainStroke = AddStroke(
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

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 20),
        Position = UDim2.fromOffset(12, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Topbar)

    local Subtitle = Create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 15),
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
        AutoButtonColor = false
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
        AutoButtonColor = false
    }, Topbar)

    Corner(Close, 8)

    --==================================================
    -- SIDEBAR
    --==================================================

    local SidebarWidth = IsMobile() and 92 or 105

    local Sidebar = Create("Frame", {
        Size = UDim2.new(
            0,
            SidebarWidth,
            1,
            -46
        ),
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
    -- TAB SCROLL
    --==================================================

    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(
            1,
            -8,
            1,
            -47
        ),
        Position = UDim2.fromOffset(4, 44),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, Sidebar)

    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabContainer)

    AddPadding(
        TabContainer,
        2,
        2,
        2,
        5
    )

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
    -- PAGES
    --==================================================

    local Pages = {}
    local TabButtons = {}
    local SelectedTab = nil

    local function SelectTab(tabData)
        if not tabData then
            return
        end

        SelectedTab = tabData

        for _, data in ipairs(Pages) do
            local active = data == tabData

            data.Page.Visible = active

            if active then
                Tween(
                    data.Button,
                    0.15,
                    {
                        BackgroundColor3 = self.Theme.Accent
                    }
                )

                Tween(
                    data.ButtonText,
                    0.15,
                    {
                        TextColor3 = Color3.new(
                            1,
                            1,
                            1
                        )
                    }
                )
            else
                Tween(
                    data.Button,
                    0.15,
                    {
                        BackgroundColor3 = self.Theme.Element
                    }
                )

                Tween(
                    data.ButtonText,
                    0.15,
                    {
                        TextColor3 = self.Theme.Muted
                    }
                )
            end
        end
    end

    --==================================================
    -- DRAG
    --==================================================

    local dragging = false
    local dragStart
    local startPosition

    Connect(
        Topbar.InputBegan,
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                dragging = true
                dragStart = input.Position
                startPosition = Main.Position

                local changed

                changed = input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false

                            if changed then
                                changed:Disconnect()
                            end
                        end
                    end
                )
            end
        end
    )

    Connect(
        UserInputService.InputChanged,
        function(input)
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
        end
    )

    --==================================================
    -- MINIMIZE
    --==================================================

    local minimized = false

    local function SetMinimized(value)
        minimized = value

        if minimized then
            Tween(
                Main,
                0.2,
                {
                    Size = UDim2.fromOffset(
                        width,
                        46
                    )
                }
            )

            Sidebar.Visible = false
            Content.Visible = false

            Minimize.Text = "+"
        else
            Tween(
                Main,
                0.2,
                {
                    Size = UDim2.fromOffset(
                        width,
                        height
                    )
                }
            )

            task.delay(
                0.16,
                function()
                    if not minimized then
                        Sidebar.Visible = true
                        Content.Visible = true
                    end
                end
            )

            Minimize.Text = "—"
        end
    end

    Connect(
        Minimize.MouseButton1Click,
        function()
            SetMinimized(not minimized)
        end
    )

    --==================================================
    -- CLOSE
    --==================================================

    local destroyed = false

    Connect(
        Close.MouseButton1Click,
        function()
            if destroyed then
                return
            end

            destroyed = true

            Tween(
                Main,
                0.18,
                {
                    Size = UDim2.fromOffset(
                        width - 20,
                        0
                    )
                }
            )

            task.wait(0.2)

            if Main then
                Main:Destroy()
            end
        end
    )

    --==================================================
    -- WINDOW API
    --==================================================

    window.Main = Main
    window.Tabs = Pages
    window.ScreenGui = ScreenGui

    function window:SetVisibility(value)
        if Main then
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
        destroyed = true

        if Main then
            Main:Destroy()
        end
    end

    function window:CreateTab(name, icon)
        name = tostring(name or "Tab")

        local tabData = {}

        --==================================================
        -- TAB BUTTON
        --==================================================

        local TabButton = Create("TextButton", {
            Size = UDim2.new(
                1,
                -2,
                0,
                42
            ),
            BackgroundColor3 = self.Theme.Element,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false
        }, TabContainer)

        Corner(TabButton, 9)

        local TabText = Create("TextLabel", {
            Size = UDim2.new(
                1,
                -14,
                1,
                0
            ),
            Position = UDim2.fromOffset(7, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left
        }, TabButton)

        tabData.Button = TabButton
        tabData.ButtonText = TabText
        tabData.Name = name

        --==================================================
        -- PAGE
        --==================================================

        local Page = Create("ScrollingFrame", {
            Name = name .. "_Page",
            Size = UDim2.new(
                1,
                -10,
                1,
                -8
            ),
            Position = UDim2.fromOffset(5, 4),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(
                0,
                0,
                0,
                0
            ),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ClipsDescendants = true
        }, Content)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 3)
        PagePadding.PaddingBottom = UDim.new(0, 12)
        PagePadding.PaddingLeft = UDim.new(0, 2)
        PagePadding.PaddingRight = UDim.new(0, 6)
        PagePadding.Parent = Page

        local PageLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        tabData.Page = Page
        tabData.Layout = PageLayout

        table.insert(Pages, tabData)

        Connect(
            TabButton.MouseButton1Click,
            function()
                SelectTab(tabData)
            end
        )

        --==================================================
        -- TAB API
        --==================================================

        function tabData:CreateSection(text)
            local section = Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    27
                ),
                BackgroundTransparency = 1,
                Text = tostring(text or "Section"),
                TextColor3 = self.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

            return section
        end

        function tabData:CreateLabel(text)
            local label = Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    38
                ),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = tostring(text or ""),
                TextColor3 = self.Theme.Muted,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            }, Page)

            Corner(label, 9)

            AddPadding(
                label,
                12,
                0,
                10,
                0
            )

            return label
        end

        function tabData:CreateParagraph(config)
            config = config or {}

            local titleText = tostring(
                config.Title or "Paragraph"
            )

            local contentText = tostring(
                config.Content or ""
            )

            local holder = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    62
                ),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(holder, 9)

            Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -20,
                    0,
                    20
                ),
                Position = UDim2.fromOffset(10, 7),
                BackgroundTransparency = 1,
                Text = titleText,
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, holder)

            Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -20,
                    0,
                    29
                ),
                Position = UDim2.fromOffset(10, 28),
                BackgroundTransparency = 1,
                Text = contentText,
                TextColor3 = self.Theme.Muted,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            }, holder)

            return holder
        end

        function tabData:CreateButton(config)
            config = config or {}

            local button = Create("TextButton", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    46
                ),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = tostring(
                    config.Name or "Button"
                ),
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            }, Page)

            Corner(button, 9)

            local stroke = AddStroke(
                button,
                self.Theme.Border,
                1
            )

            Connect(
                button.MouseEnter,
                function()
                    Tween(
                        button,
                        0.12,
                        {
                            BackgroundColor3 =
                                self.Theme.ElementHover
                        }
                    )
                end
            )

            Connect(
                button.MouseLeave,
                function()
                    Tween(
                        button,
                        0.12,
                        {
                            BackgroundColor3 =
                                self.Theme.Element
                        }
                    )
                end
            )

            Connect(
                button.MouseButton1Click,
                function()
                    Safe(config.Callback)
                end
            )

            return button
        end

        function tabData:CreateToggle(config)
            config = config or {}

            local current = config.CurrentValue == true

            local holder = Create("TextButton", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    48
                ),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, Page)

            Corner(holder, 9)

            local label = Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -75,
                    1,
                    0
                ),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = tostring(
                    config.Name or "Toggle"
                ),
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, holder)

            local switch = Create("Frame", {
                Size = UDim2.fromOffset(58, 29),
                Position = UDim2.new(
                    1,
                    -68,
                    0.5,
                    -14
                ),
                BackgroundColor3 =
                    current
                    and self.Theme.ToggleOn
                    or self.Theme.ToggleOff,
                BorderSizePixel = 0
            }, holder)

            Corner(switch, 20)

            local knob = Create("Frame", {
                Size = UDim2.fromOffset(21, 21),
                Position = current
                    and UDim2.new(1, -25, 0.5, -10)
                    or UDim2.fromOffset(4, 4),
                BackgroundColor3 =
                    Color3.fromRGB(
                        250,
                        250,
                        250
                    ),
                BorderSizePixel = 0
            }, switch)

            Corner(knob, 20)

            local function Update(value)
                current = value == true

                Tween(
                    switch,
                    0.14,
                    {
                        BackgroundColor3 =
                            current
                            and self.Theme.ToggleOn
                            or self.Theme.ToggleOff
                    }
                )

                Tween(
                    knob,
                    0.14,
                    {
                        Position = current
                            and UDim2.new(
                                1,
                                -25,
                                0.5,
                                -10
                            )
                            or UDim2.fromOffset(
                                4,
                                4
                            )
                    }
                )

                if config.Flag then
                    M4teoUI.Flags[
                        config.Flag
                    ] = current
                end

                Safe(
                    config.Callback,
                    current
                )
            end

            Connect(
                holder.MouseButton1Click,
                function()
                    Update(not current)
                end
            )

            if config.Flag then
                M4teoUI.Flags[
                    config.Flag
                ] = current
            end

            local object = {}

            object.CurrentValue = current

            function object:Set(value)
                Update(value)
                object.CurrentValue = current
            end

            function object:Get()
                return current
            end

            M4teoUI.Options[
                config.Flag
                    or tostring(config.Name)
            ] = object

            return object
        end

        function tabData:CreateSlider(config)
            config = config or {}

            local range = config.Range or {0, 100}

            local minimum = tonumber(range[1]) or 0
            local maximum = tonumber(range[2]) or 100

            local increment =
                tonumber(config.Increment)
                or 1

            local current =
                tonumber(config.CurrentValue)
                or minimum

            current = math.clamp(
                current,
                minimum,
                maximum
            )

            local holder = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    68
                ),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(holder, 9)

            local label = Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -70,
                    0,
                    23
                ),
                Position = UDim2.fromOffset(12, 7),
                BackgroundTransparency = 1,
                Text = tostring(
                    config.Name or "Slider"
                ),
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, holder)

            local valueLabel = Create("TextLabel", {
                Size = UDim2.fromOffset(
                    55,
                    23
                ),
                Position = UDim2.new(
                    1,
                    -64,
                    0,
                    7
                ),
                BackgroundTransparency = 1,
                Text = tostring(current),
                TextColor3 = self.Theme.Accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right
            }, holder)

            local bar = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -24,
                    0,
                    7
                ),
                Position = UDim2.fromOffset(
                    12,
                    45
                ),
                BackgroundColor3 =
                    self.Theme.ToggleOff,
                BorderSizePixel = 0
            }, holder)

            Corner(bar, 10)

            local fill = Create("Frame", {
                Size = UDim2.new(
                    (
                        current - minimum
                    ) / (
                        maximum - minimum
                    ),
                    0,
                    1,
                    0
                ),
                BackgroundColor3 =
                    self.Theme.Accent,
                BorderSizePixel = 0
            }, bar)

            Corner(fill, 10)

            local draggingSlider = false

            local function RoundValue(value)
                local rounded =
                    math.floor(
                        (
                            value
                            - minimum
                        ) / increment
                        + 0.5
                    ) * increment
                    + minimum

                return math.clamp(
                    rounded,
                    minimum,
                    maximum
                )
            end

            local function SetValue(value)
                value = tonumber(value)

                if not value then
                    return
                end

                current = RoundValue(value)

                local percent =
                    (
                        current
                        - minimum
                    ) / (
                        maximum
                        - minimum
                    )

                Tween(
                    fill,
                    0.08,
                    {
                        Size = UDim2.new(
                            percent,
                            0,
                            1,
                            0
                        )
                    }
                )

                valueLabel.Text =
                    tostring(current)

                if config.Flag then
                    M4teoUI.Flags[
                        config.Flag
                    ] = current
                end

                Safe(
                    config.Callback,
                    current
                )
            end

            local function UpdateFromInput(input)
                local position =
                    input.Position.X

                local absolute =
                    bar.AbsolutePosition.X

                local size =
                    bar.AbsoluteSize.X

                local percent =
                    math.clamp(
                        (
                            position
                            - absolute
                        ) / size,
                        0,
                        1
                    )

                SetValue(
                    minimum
                    + (
                        maximum
                        - minimum
                    ) * percent
                )
            end

            Connect(
                bar.InputBegan,
                function(input)
                    if input.UserInputType
                        == Enum.UserInputType.MouseButton1
                        or input.UserInputType
                        == Enum.UserInputType.Touch then

                        draggingSlider = true
                        UpdateFromInput(input)
                    end
                end
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

                        UpdateFromInput(input)
                    end
                end
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
                end
            )

            if config.Flag then
                M4teoUI.Flags[
                    config.Flag
                ] = current
            end

            local object = {}

            object.CurrentValue = current

            function object:Set(value)
                SetValue(value)
                object.CurrentValue = current
            end

            function object:Get()
                return current
            end

            M4teoUI.Options[
                config.Flag
                    or tostring(config.Name)
            ] = object

            return object
        end

        function tabData:CreateDropdown(config)
            config = config or {}

            local options =
                config.Options
                or {}

            local current =
                config.CurrentOption

            if type(current) == "table" then
                current = current[1]
            end

            if current == nil
                and #options > 0 then

                current = options[1]
            end

            local holder = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    48
                ),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                ClipsDescendants = false
            }, Page)

            Corner(holder, 9)

            local button = Create("TextButton", {
                Size = UDim2.new(
                    1,
                    0,
                    0,
                    48
                ),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            }, holder)

            local label = Create("TextLabel", {
                Size = UDim2.new(
                    0.48,
                    0,
                    1,
                    0
                ),
                Position = UDim2.fromOffset(
                    12,
                    0
                ),
                BackgroundTransparency = 1,
                Text = tostring(
                    config.Name
                    or "Dropdown"
                ),
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                TextXAlignment =
                    Enum.TextXAlignment.Left
            }, button)

            local selected = Create("TextLabel", {
                Size = UDim2.new(
                    0.45,
                    -10,
                    1,
                    0
                ),
                Position = UDim2.new(
                    0.52,
                    0,
                    0,
                    0
                ),
                BackgroundTransparency = 1,
                Text = tostring(
                    current or "Select..."
                ),
                TextColor3 = self.Theme.Accent,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment =
                    Enum.TextXAlignment.Right
            }, button)

            local arrow = Create("TextLabel", {
                Size = UDim2.fromOffset(
                    15,
                    48
                ),
                Position = UDim2.new(
                    1,
                    -19,
                    0,
                    0
                ),
                BackgroundTransparency = 1,
                Text = "⌄",
                TextColor3 = self.Theme.Muted,
                TextSize = 13,
                Font = Enum.Font.GothamBold
            }, button)

            local List = Create("ScrollingFrame", {
                Name = "DropdownList",
                Size = UDim2.new(
                    1,
                    -8,
                    0,
                    110
                ),
                Position = UDim2.new(
                    0,
                    4,
                    1,
                    3
                ),
                BackgroundColor3 =
                    self.Theme.Sidebar,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 =
                    self.Theme.Accent,
                ScrollingDirection =
                    Enum.ScrollingDirection.Y,
                CanvasSize = UDim2.new(
                    0,
                    0,
                    0,
                    0
                ),
                AutomaticCanvasSize =
                    Enum.AutomaticSize.Y,
                Visible = false,
                ZIndex = 50
            }, holder)

            Corner(List, 8)
            AddStroke(
                List,
                self.Theme.Border,
                1
            )

            local listLayout = Create(
                "UIListLayout",
                {
                    Padding = UDim.new(0, 3),
                    SortOrder =
                        Enum.SortOrder.LayoutOrder
                },
                List
            )

            AddPadding(
                List,
                5,
                5,
                5,
                5
            )

            local opened = false
            local optionButtons = {}

            local function SetOption(value)
                current = value
                selected.Text =
                    tostring(value)

                if config.Flag then
                    M4teoUI.Flags[
                        config.Flag
                    ] = value
                end

                Safe(
                    config.Callback,
                    value
                )
            end

            local function Refresh(newOptions)
                for _, child in ipairs(
                    optionButtons
                ) do
                    if child then
                        child:Destroy()
                    end
                end

                table.clear(
                    optionButtons
                )

                options = newOptions
                    or options

                for index, option in ipairs(
                    options
                ) do

                    local optionButton =
                        Create(
                            "TextButton",
                            {
                                LayoutOrder = index,
                                Size = UDim2.new(
                                    1,
                                    0,
                                    0,
                                    29
                                ),
                                BackgroundColor3 =
                                    self.Theme.Element,
                                BorderSizePixel = 0,
                                Text = tostring(
                                    option
                                ),
                                TextColor3 =
                                    self.Theme.Text,
                                TextSize = 10,
                                Font =
                                    Enum.Font.Gotham,
                                AutoButtonColor =
                                    false,
                                ZIndex = 51
                            },
                            List
                        )

                    Corner(
                        optionButton,
                        6
                    )

                    Connect(
                        optionButton.MouseButton1Click,
                        function()
                            SetOption(
                                option
                            )

                            opened = false
                            List.Visible = false

                            holder.Size =
                                UDim2.new(
                                    1,
                                    -2,
                                    0,
                                    48
                                )
                        end
                    )

                    table.insert(
                        optionButtons,
                        optionButton
                    )
                end
            end

            Refresh(options)

            Connect(
                button.MouseButton1Click,
                function()
                    opened = not opened

                    List.Visible = opened

                    if opened then
                        holder.Size =
                            UDim2.new(
                                1,
                                -2,
                                0,
                                163
                            )
                    else
                        holder.Size =
                            UDim2.new(
                                1,
                                -2,
                                0,
                                48
                            )
                    end
                end
            )

            if config.Flag then
                M4teoUI.Flags[
                    config.Flag
                ] = current
            end

            local object = {}

            object.CurrentOption = current

            function object:Set(value)
                for _, option in ipairs(
                    options
                ) do
                    if tostring(option)
                        == tostring(value) then

                        SetOption(option)
                        object.CurrentOption =
                            option

                        return
                    end
                end
            end

            function object:Get()
                return current
            end

            function object:Refresh(
                newOptions
            )
                Refresh(newOptions)
            end

            M4teoUI.Options[
                config.Flag
                    or tostring(config.Name)
            ] = object

            return object
        end

        function tabData:CreateInput(config)
            config = config or {}

            local holder = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    48
                ),
                BackgroundColor3 =
                    self.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(holder, 9)

            local label = Create("TextLabel", {
                Size = UDim2.new(
                    0.4,
                    0,
                    1,
                    0
                ),
                Position = UDim2.fromOffset(
                    12,
                    0
                ),
                BackgroundTransparency = 1,
                Text = tostring(
                    config.Name
                    or "Input"
                ),
                TextColor3 =
                    self.Theme.Text,
                TextSize = 11,
                Font =
                    Enum.Font.GothamMedium,
                TextXAlignment =
                    Enum.TextXAlignment.Left
            }, holder)

            local input = Create("TextBox", {
                Size = UDim2.new(
                    0.52,
                    0,
                    0,
                    31
                ),
                Position = UDim2.new(
                    0.44,
                    0,
                    0.5,
                    -15
                ),
                BackgroundColor3 =
                    self.Theme.Sidebar,
                BorderSizePixel = 0,
                PlaceholderText =
                    tostring(
                        config.PlaceholderText
                        or "Type..."
                    ),
                PlaceholderColor3 =
                    self.Theme.Muted,
                Text = tostring(
                    config.CurrentValue
                    or ""
                ),
                TextColor3 =
                    self.Theme.Text,
                TextSize = 10,
                Font =
                    Enum.Font.Gotham,
                ClearTextOnFocus =
                    false
            }, holder)

            Corner(input, 7)

            AddPadding(
                input,
                9,
                0,
                9,
                0
            )

            local function Changed()
                if config.Flag then
                    M4teoUI.Flags[
                        config.Flag
                    ] = input.Text
                end

                Safe(
                    config.Callback,
                    input.Text
                )
            end

            Connect(
                input.FocusLost,
                function()
                    Changed()
                end
            )

            if config.Flag then
                M4teoUI.Flags[
                    config.Flag
                ] = input.Text
            end

            local object = {}

            function object:Set(value)
                input.Text =
                    tostring(value or "")
                Changed()
            end

            function object:Get()
                return input.Text
            end

            return object
        end

        function tabData:CreateKeybind(config)
            config = config or {}

            local currentKey =
                config.CurrentKeybind
                or config.CurrentKey
                or Enum.KeyCode.RightShift

            local holder = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    48
                ),
                BackgroundColor3 =
                    self.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(holder, 9)

            local label = Create("TextLabel", {
                Size = UDim2.new(
                    0.52,
                    0,
                    1,
                    0
                ),
                Position = UDim2.fromOffset(
                    12,
                    0
                ),
                BackgroundTransparency = 1,
                Text = tostring(
                    config.Name
                    or "Keybind"
                ),
                TextColor3 =
                    self.Theme.Text,
                TextSize = 11,
                Font =
                    Enum.Font.GothamMedium,
                TextXAlignment =
                    Enum.TextXAlignment.Left
            }, holder)

            local keyButton = Create("TextButton", {
                Size = UDim2.fromOffset(
                    82,
                    30
                ),
                Position = UDim2.new(
                    1,
                    -92,
                    0.5,
                    -15
                ),
                BackgroundColor3 =
                    self.Theme.Sidebar,
                BorderSizePixel = 0,
                Text = tostring(
                    currentKey.Name
                    or currentKey
                ),
                TextColor3 =
                    self.Theme.Text,
                TextSize = 10,
                Font =
                    Enum.Font.GothamBold,
                AutoButtonColor = false
            }, holder)

            Corner(keyButton, 7)

            local listening = false

            Connect(
                keyButton.MouseButton1Click,
                function()
                    listening = true

                    keyButton.Text =
                        "Press key..."
                end
            )

            Connect(
                UserInputService.InputBegan,
                function(input, processed)
                    if not listening then
                        return
                    end

                    if processed then
                        return
                    end

                    if input.UserInputType
                        ~= Enum.UserInputType.Keyboard then
                        return
                    end

                    currentKey =
                        input.KeyCode

                    listening = false

                    keyButton.Text =
                        currentKey.Name

                    if config.Flag then
                        M4teoUI.Flags[
                            config.Flag
                        ] = currentKey
                    end

                    Safe(
                        config.Callback,
                        currentKey
                    )
                end
            )

            if config.Flag then
                M4teoUI.Flags[
                    config.Flag
                ] = currentKey
            end

            local object = {}

            object.CurrentKeybind =
                currentKey

            function object:Set(key)
                if typeof(key)
                    == "EnumItem" then

                    currentKey = key

                    keyButton.Text =
                        key.Name

                    object.CurrentKeybind =
                        key

                    if config.Flag then
                        M4teoUI.Flags[
                            config.Flag
                        ] = key
                    end
                end
            end

            function object:Get()
                return currentKey
            end

            M4teoUI.Options[
                config.Flag
                    or tostring(config.Name)
            ] = object

            return object
        end

        function tabData:CreateColorPicker(config)
            config = config or {}

            local current =
                NormalizeColor(
                    config.Color
                    or config.CurrentColor
                )

            local holder = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    48
                ),
                BackgroundColor3 =
                    self.Theme.Element,
                BorderSizePixel = 0
            }, Page)

            Corner(holder, 9)

            local label = Create("TextLabel", {
                Size = UDim2.new(
                    1,
                    -75,
                    1,
                    0
                ),
                Position = UDim2.fromOffset(
                    12,
                    0
                ),
                BackgroundTransparency = 1,
                Text = tostring(
                    config.Name
                    or "Color Picker"
                ),
                TextColor3 =
                    self.Theme.Text,
                TextSize = 11,
                Font =
                    Enum.Font.GothamMedium,
                TextXAlignment =
                    Enum.TextXAlignment.Left
            }, holder)

            local preview = Create("TextButton", {
                Size = UDim2.fromOffset(
                    44,
                    28
                ),
                Position = UDim2.new(
                    1,
                    -55,
                    0.5,
                    -14
                ),
                BackgroundColor3 =
                    current,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, holder)

            Corner(preview, 7)

            local popup = Create("Frame", {
                Size = UDim2.new(
                    1,
                    -2,
                    0,
                    115
                ),
                Position = UDim2.new(
                    0,
                    1,
                    1,
                    4
                ),
                BackgroundColor3 =
                    self.Theme.Sidebar,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 60
            }, holder)

            Corner(popup, 8)
            AddStroke(
                popup,
                self.Theme.Border,
                1
            )

            local red = Create("TextBox", {
                Size = UDim2.new(
                    1,
                    -16,
                    0,
                    27
                ),
                Position = UDim2.fromOffset(
                    8,
                    8
                ),
                BackgroundColor3 =
                    self.Theme.Element,
                BorderSizePixel = 0,
                PlaceholderText = "R 0-255",
                Text = "",
                TextColor3 =
                    self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.Gotham
            }, popup)

            Corner(red, 6)

            local green = red:Clone()
            green.Position =
                UDim2.fromOffset(8, 42)
            green.PlaceholderText =
                "G 0-255"
            green.Text = ""
            green.Parent = popup

            local blue = red:Clone()
            blue.Position =
                UDim2.fromOffset(8, 76)
            blue.PlaceholderText =
                "B 0-255"
            blue.Text = ""
            blue.Parent = popup

            local function ApplyColor()
                local r = math.clamp(
                    tonumber(red.Text)
                        or math.floor(
                            current.R * 255
                        ),
                    0,
                    255
                )

                local g = math.clamp(
                    tonumber(green.Text)
                        or math.floor(
                            current.G * 255
                        ),
                    0,
                    255
                )

                local b = math.clamp(
                    tonumber(blue.Text)
                        or math.floor(
                            current.B * 255
                        ),
                    0,
                    255
                )

                current = Color3.fromRGB(
                    r,
                    g,
                    b
                )

                preview.BackgroundColor3 =
                    current

                if config.Flag then
                    M4teoUI.Flags[
                        config.Flag
                    ] = current
                end

                Safe(
                    config.Callback,
                    current
                )
            end

            Connect(
                preview.MouseButton1Click,
                function()
                    popup.Visible =
                        not popup.Visible

                    holder.Size =
                        popup.Visible
                        and UDim2.new(
                            1,
                            -2,
                            0,
                            167
                        )
                        or UDim2.new(
                            1,
                            -2,
                            0,
                            48
                        )
                end
            )

            Connect(
                red.FocusLost,
                ApplyColor
            )

            Connect(
                green.FocusLost,
                ApplyColor
            )

            Connect(
                blue.FocusLost,
                ApplyColor
            )

            local object = {}

            function object:Set(color)
                if typeof(color)
                    ~= "Color3" then
                    return
                end

                current = color
                preview.BackgroundColor3 =
                    color

                if config.Flag then
                    M4teoUI.Flags[
                        config.Flag
                    ] = color
                end

                Safe(
                    config.Callback,
                    color
                )
            end

            function object:Get()
                return current
            end

            if config.Flag then
                M4teoUI.Flags[
                    config.Flag
                ] = current
            end

            M4teoUI.Options[
                config.Flag
                    or tostring(config.Name)
            ] = object

            return object
        end

        return tabData
    end

    --==================================================
    -- SEARCH TABS
    --==================================================

    Connect(
        Search:GetPropertyChangedSignal("Text"),
        function()
            local query =
                string.lower(
                    Search.Text
                )

            for _, tab in ipairs(Pages) do
                if query == "" then
                    tab.Button.Visible = true
                else
                    tab.Button.Visible =
                        string.find(
                            string.lower(
                                tab.Name
                            ),
                            query,
                            1,
                            true
                        ) ~= nil
                end
            end
        end
    )

    --==================================================
    -- THEME UPDATE
    --==================================================

    function window.ApplyTheme()
        Main.BackgroundColor3 =
            self.Theme.Background

        MainStroke.Color =
            self.Theme.Border

        Topbar.BackgroundColor3 =
            self.Theme.Sidebar

        Sidebar.BackgroundColor3 =
            self.Theme.Sidebar

        Content.BackgroundColor3 =
            self.Theme.Background

        Search.BackgroundColor3 =
            self.Theme.Element

        Search.PlaceholderColor3 =
            self.Theme.Muted

        Title.TextColor3 =
            self.Theme.Text

        Subtitle.TextColor3 =
            self.Theme.Muted

        Minimize.BackgroundColor3 =
            self.Theme.Element

        Close.BackgroundColor3 =
            self.Theme.Element

        for _, tab in ipairs(Pages) do
            tab.ButtonText.TextColor3 =
                self.Theme.Muted

            if tab ~= SelectedTab then
                tab.Button.BackgroundColor3 =
                    self.Theme.Element
            else
                tab.Button.BackgroundColor3 =
                    self.Theme.Accent
                tab.ButtonText.TextColor3 =
                    Color3.new(1, 1, 1)
            end
        end
    end

    --==================================================
    -- FIRST TAB AUTO SELECT
    --==================================================

    function window:SelectTab(name)
        for _, tab in ipairs(Pages) do
            if tab.Name == name then
                SelectTab(tab)
                return
            end
        end
    end

    table.insert(
        M4teoUI.Windows,
        window
    )

    --==================================================
    -- OPEN ANIMATION
    --==================================================

    local finalSize =
        UDim2.fromOffset(
            width,
            height
        )

    Main.Size =
        UDim2.fromOffset(
            width - 25,
            height - 20
        )

    Main.BackgroundTransparency = 1

    Tween(
        Main,
        0.25,
        {
            Size = finalSize,
            BackgroundTransparency = 0
        }
    )

    --==================================================
    -- DEFAULT TAB
    --==================================================

    return window
end

--==================================================
-- COMPATIBILITY
--==================================================

function M4teoUI:Create(config)
    return self:CreateWindow(config)
end

--==================================================
-- GLOBAL VISIBILITY
--==================================================

function M4teoUI:SetVisibility(value)
    ScreenGui.Enabled = value
end

function M4teoUI:IsVisible()
    return ScreenGui.Enabled
end

function M4teoUI:Destroy()
    DisconnectAll(Connections)

    for _, window in ipairs(self.Windows) do
        pcall(function()
            window:Destroy()
        end)
    end

    table.clear(self.Windows)
    table.clear(self.Flags)
    table.clear(self.Options)

    if ScreenGui then
        ScreenGui:Destroy()
    end
end

--==================================================
-- RETURN
--==================================================

return M4teoUI
