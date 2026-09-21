--[[
    M4teoUI | Script.lua
    Original Rayfield-like UI Library
    Compact / Mobile / Drag / Scroll / Themes

    API:
        Library:CreateWindow(...)
        Window:CreateTab(...)
        Tab:CreateSection(...)
        Tab:CreateLabel(...)
        Tab:CreateButton(...)
        Tab:CreateToggle(...)
        Tab:CreateSlider(...)
        Tab:CreateDropdown(...)
        Tab:CreateInput(...)
        Tab:CreateColorPicker(...)
        Tab:CreateKeybind(...)

    Public API is readable.
    Internal names intentionally compact.
]]

local _L = {}

--//==================================================
--// SERVICES
--//==================================================

local _P = game:GetService("Players")
local _T = game:GetService("TweenService")
local _U = game:GetService("UserInputService")
local _CG = game:GetService("CoreGui")

local _LP = _P.LocalPlayer

--//==================================================
--// STORAGE
--//==================================================

_L.Flags = {}
_L.Options = {}
_L.Windows = {}
_L.Themes = {}

--//==================================================
--// DEFAULT THEME
--//==================================================

_L.Theme = {
    Background = Color3.fromRGB(16, 16, 21),
    Sidebar = Color3.fromRGB(21, 21, 27),
    Element = Color3.fromRGB(28, 28, 36),
    ElementHover = Color3.fromRGB(38, 38, 48),

    Accent = Color3.fromRGB(0, 170, 255),

    Text = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(160, 160, 172),

    Border = Color3.fromRGB(55, 55, 67),

    ToggleOff = Color3.fromRGB(35, 35, 44),
    ToggleOn = Color3.fromRGB(0, 170, 255)
}

--//==================================================
--// THEMES
--//==================================================

_L.Themes.Dark = {
    Background = Color3.fromRGB(16, 16, 21),
    Sidebar = Color3.fromRGB(21, 21, 27),
    Element = Color3.fromRGB(28, 28, 36),
    ElementHover = Color3.fromRGB(38, 38, 48),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(160, 160, 172),
    Border = Color3.fromRGB(55, 55, 67),
    ToggleOff = Color3.fromRGB(35, 35, 44),
    ToggleOn = Color3.fromRGB(0, 170, 255)
}

_L.Themes.Purple = {
    Background = Color3.fromRGB(18, 16, 24),
    Sidebar = Color3.fromRGB(23, 20, 31),
    Element = Color3.fromRGB(32, 28, 42),
    ElementHover = Color3.fromRGB(43, 37, 55),
    Accent = Color3.fromRGB(160, 90, 255),
    Text = Color3.fromRGB(245, 242, 250),
    Muted = Color3.fromRGB(170, 165, 180),
    Border = Color3.fromRGB(65, 55, 78),
    ToggleOff = Color3.fromRGB(35, 30, 42),
    ToggleOn = Color3.fromRGB(160, 90, 255)
}

_L.Themes.Red = {
    Background = Color3.fromRGB(23, 16, 17),
    Sidebar = Color3.fromRGB(29, 19, 21),
    Element = Color3.fromRGB(40, 26, 29),
    ElementHover = Color3.fromRGB(53, 34, 38),
    Accent = Color3.fromRGB(255, 75, 85),
    Text = Color3.fromRGB(250, 242, 243),
    Muted = Color3.fromRGB(180, 165, 168),
    Border = Color3.fromRGB(78, 53, 57),
    ToggleOff = Color3.fromRGB(42, 29, 31),
    ToggleOn = Color3.fromRGB(255, 75, 85)
}

_L.Themes.Green = {
    Background = Color3.fromRGB(15, 21, 18),
    Sidebar = Color3.fromRGB(19, 27, 22),
    Element = Color3.fromRGB(25, 37, 29),
    ElementHover = Color3.fromRGB(34, 49, 39),
    Accent = Color3.fromRGB(60, 210, 125),
    Text = Color3.fromRGB(242, 250, 245),
    Muted = Color3.fromRGB(160, 180, 168),
    Border = Color3.fromRGB(50, 76, 60),
    ToggleOff = Color3.fromRGB(25, 35, 29),
    ToggleOn = Color3.fromRGB(60, 210, 125)
}

_L.Themes.Orange = {
    Background = Color3.fromRGB(23, 19, 15),
    Sidebar = Color3.fromRGB(30, 24, 19),
    Element = Color3.fromRGB(40, 32, 24),
    ElementHover = Color3.fromRGB(53, 42, 31),
    Accent = Color3.fromRGB(255, 145, 55),
    Text = Color3.fromRGB(250, 245, 240),
    Muted = Color3.fromRGB(180, 168, 155),
    Border = Color3.fromRGB(80, 63, 45),
    ToggleOff = Color3.fromRGB(42, 34, 27),
    ToggleOn = Color3.fromRGB(255, 145, 55)
}

--//==================================================
--// INTERNAL HELPERS
--//==================================================

local function _safe(f, ...)
    if type(f) ~= "function" then
        return
    end

    local a = {...}

    task.spawn(function()
        pcall(function()
            f(table.unpack(a))
        end)
    end)
end

local function _new(c, p, par)
    local o = Instance.new(c)

    for k, v in pairs(p or {}) do
        pcall(function()
            o[k] = v
        end)
    end

    o.Parent = par

    return o
end

local function _corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = o
    return c
end

local function _stroke(o, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or _L.Theme.Border
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.Parent = o
    return s
end

local function _pad(o, l, t, r, b)
    local p = Instance.new("UIPadding")

    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)

    p.Parent = o

    return p
end

local function _tween(o, d, props)
    if not o then
        return
    end

    local x = _T:Create(
        o,
        TweenInfo.new(
            d or 0.15,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    )

    x:Play()

    return x
end

local function _guiParent()
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)

        if ok and result then
            return result
        end
    end

    return _CG
end

local function _mobile()
    local cam = workspace.CurrentCamera

    if not cam then
        return false
    end

    return cam.ViewportSize.X <= 650
end

local function _rgb(v)
    if typeof(v) == "Color3" then
        return v
    end

    return _L.Theme.Accent
end

--//==================================================
--// OLD GUI CLEANUP
--//==================================================

pcall(function()
    local p = _guiParent()

    local old = p:FindFirstChild("M4teoUI")

    if old then
        old:Destroy()
    end
end)

--//==================================================
--// SCREEN GUI
--//==================================================

local _G = _new("ScreenGui", {
    Name = "M4teoUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
}, _guiParent())

--//==================================================
--// NOTIFICATION HOLDER
--//==================================================

local _NH = _new("Frame", {
    Name = "Notifications",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -10, 0, 10),
    Size = UDim2.fromOffset(285, 400),
    BackgroundTransparency = 1
}, _G)

_new("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, _NH)

--//==================================================
--// NOTIFY
--//==================================================

function _L:Notify(c)
    c = c or {}

    local title = tostring(c.Title or "M4teoUI")
    local content = tostring(c.Content or "")
    local duration = tonumber(c.Duration or 3) or 3

    local n = _new("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = self.Theme.Element,
        BorderSizePixel = 0
    }, _NH)

    _corner(n, 10)
    _stroke(n, self.Theme.Border, 1)

    local bar = _new("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.fromOffset(6, 8),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    }, n)

    _corner(bar, 3)

    _new("TextLabel", {
        Size = UDim2.new(1, -28, 0, 20),
        Position = UDim2.fromOffset(17, 7),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, n)

    _new("TextLabel", {
        Size = UDim2.new(1, -28, 0, 32),
        Position = UDim2.fromOffset(17, 29),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = self.Theme.Muted,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, n)

    n.Position = UDim2.new(1, 30, 0, 0)

    _tween(n, 0.25, {
        Position = UDim2.new(0, 0, 0, 0)
    })

    task.delay(duration, function()
        if not n or not n.Parent then
            return
        end

        _tween(n, 0.2, {
            Position = UDim2.new(1, 30, 0, 0),
            BackgroundTransparency = 1
        })

        task.wait(0.22)

        if n then
            n:Destroy()
        end
    end)
end

--//==================================================
--// THEME API
--//==================================================

function _L:RegisterTheme(name, data)
    if type(name) ~= "string" then
        return
    end

    if type(data) ~= "table" then
        return
    end

    self.Themes[name] = data
end

function _L:GetThemes()
    local r = {}

    for n in pairs(self.Themes) do
        table.insert(r, n)
    end

    table.sort(r)

    return r
end

function _L:SetTheme(name)
    local th = self.Themes[name]

    if not th then
        return false
    end

    for k, v in pairs(th) do
        self.Theme[k] = v
    end

    for _, w in ipairs(self.Windows) do
        if w and w.ApplyTheme then
            pcall(w.ApplyTheme)
        end
    end

    return true
end

--//==================================================
--// CREATE WINDOW
--//==================================================

function _L:CreateWindow(c)
    c = c or {}

    local w = {}

    local title = tostring(
        c.Name
        or c.Title
        or "M4teoUI"
    )

    local subtitle = tostring(
        c.Subtitle
        or c.LoadingSubtitle
        or "Universal"
    )

    local cam = workspace.CurrentCamera

    local vp = cam
        and cam.ViewportSize
        or Vector2.new(800, 600)

    local ww = math.clamp(
        vp.X * 0.82,
        330,
        430
    )

    local wh = math.clamp(
        vp.Y * 0.62,
        260,
        330
    )

    if vp.X < 500 then
        ww = math.min(
            ww,
            math.max(300, vp.X - 20)
        )
    end

    if vp.Y < 500 then
        wh = math.min(
            wh,
            math.max(240, vp.Y - 70)
        )
    end

    ww = math.floor(ww)
    wh = math.floor(wh)

    --// WINDOW

    local main = _new("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(ww, wh),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, _G)

    _corner(main, 12)

    local mainStroke = _stroke(
        main,
        self.Theme.Border,
        1
    )

    --// OPTIONAL RGB BORDER

    local rgb = c.RGBBorder == true

    if rgb then
        task.spawn(function()
            local h = 0

            while main and main.Parent do
                h = (h + 0.006) % 1

                if mainStroke then
                    mainStroke.Color = Color3.fromHSV(h, 0.85, 1)
                end

                task.wait()
            end
        end)
    end

    --// TOPBAR

    local top = _new("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 5
    }, main)

    _corner(top, 12)

    _new("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 5
    }, top)

    --// DRAG AREA
    --// Dedicated area avoids buttons blocking drag.

    local dragArea = _new("TextButton", {
        Name = "DragArea",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Active = true,
        ZIndex = 6
    }, top)

    local ttl = _new("TextLabel", {
        Size = UDim2.new(1, -15, 0, 20),
        Position = UDim2.fromOffset(12, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, dragArea)

    local sub = _new("TextLabel", {
        Size = UDim2.new(1, -15, 0, 15),
        Position = UDim2.fromOffset(13, 25),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = self.Theme.Muted,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, dragArea)

    --// MINIMIZE

    local min = _new("TextButton", {
        Size = UDim2.fromOffset(29, 29),
        Position = UDim2.new(1, -64, 0, 8),
        BackgroundColor3 = self.Theme.Element,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Active = true,
        ZIndex = 20
    }, top)

    _corner(min, 8)

    --// CLOSE

    local cls = _new("TextButton", {
        Size = UDim2.fromOffset(29, 29),
        Position = UDim2.new(1, -32, 0, 8),
        BackgroundColor3 = self.Theme.Element,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 17,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Active = true,
        ZIndex = 20
    }, top)

    _corner(cls, 8)

    --//==================================================
    --// SIDEBAR
    --//==================================================

    local sw = _mobile() and 92 or 105

    local side = _new("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, sw, 1, -46),
        Position = UDim2.fromOffset(0, 46),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 4
    }, main)

    --// SEARCH

    local search = _new("TextBox", {
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
        ClearTextOnFocus = false,
        ZIndex = 6
    }, side)

    _corner(search, 8)

    --// TABS

    local tabScroll = _new("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(1, -8, 1, -47),
        Position = UDim2.fromOffset(4, 44),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 5
    }, side)

    _pad(tabScroll, 2, 2, 2, 5)

    local tabLayout = _new("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, tabScroll)

    --//==================================================
    --// CONTENT
    --//==================================================

    local content = _new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -sw, 1, -46),
        Position = UDim2.new(0, sw, 0, 46),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 3
    }, main)

    local pages = {}
    local selected = nil
    local destroyed = false
    local minimized = false

    --//==================================================
    --// SELECT TAB
    --//==================================================

    local function selectTab(td)
        if not td then
            return
        end

        selected = td

        for _, x in ipairs(pages) do
            local active = x == td

            x.Page.Visible = active

            if active then
                _tween(x.Button, 0.12, {
                    BackgroundColor3 = self.Theme.Accent
                })

                _tween(x.Label, 0.12, {
                    TextColor3 = Color3.new(1, 1, 1)
                })
            else
                _tween(x.Button, 0.12, {
                    BackgroundColor3 = self.Theme.Element
                })

                _tween(x.Label, 0.12, {
                    TextColor3 = self.Theme.Muted
                })
            end
        end
    end

    --//==================================================
    --// DRAG SYSTEM
    --//==================================================

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    dragArea.InputBegan:Connect(function(input)
        if destroyed then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input
        end
    end)

    _U.InputChanged:Connect(function(input)
        if destroyed or not dragging then
            return
        end

        if input == dragInput then
            local delta = input.Position - dragStart

            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    _U.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
            dragInput = nil
        end
    end)

    --//==================================================
    --// MINIMIZE
    --//==================================================

    local function setMin(v)
        if destroyed then
            return
        end

        minimized = v

        if minimized then
            side.Visible = false
            content.Visible = false

            _tween(main, 0.2, {
                Size = UDim2.fromOffset(ww, 46)
            })

            min.Text = "+"
        else
            _tween(main, 0.2, {
                Size = UDim2.fromOffset(ww, wh)
            })

            task.delay(0.18, function()
                if destroyed or minimized then
                    return
                end

                side.Visible = true
                content.Visible = true
            end)

            min.Text = "—"
        end
    end

    min.Activated:Connect(function()
        setMin(not minimized)
    end)

    --//==================================================
    --// CLOSE
    --//==================================================

    local function destroyWindow()
        if destroyed then
            return
        end

        destroyed = true

        _tween(main, 0.18, {
            Size = UDim2.fromOffset(
                math.max(250, ww - 20),
                0
            )
        })

        task.delay(0.2, function()
            if main then
                main:Destroy()
            end
        end)
    end

    cls.Activated:Connect(destroyWindow)

    --//==================================================
    --// WINDOW API
    --//==================================================

    w.Main = main
    w.ScreenGui = _G
    w.Tabs = pages

    function w:SetVisibility(v)
        if main and not destroyed then
            main.Visible = v == true
        end
    end

    function w:IsVisible()
        return main
            and main.Parent
            and main.Visible
            or false
    end

    function w:Minimize()
        setMin(true)
    end

    function w:Restore()
        setMin(false)
    end

    function w:Destroy()
        destroyWindow()
    end

    function w:SelectTab(name)
        for _, x in ipairs(pages) do
            if x.Name == tostring(name) then
                selectTab(x)
                return true
            end
        end

        return false
    end

    --//==================================================
    --// CREATE TAB
    --//==================================================

    function w:CreateTab(name, icon)
        name = tostring(name or "Tab")

        local td = {
            Name = name
        }

        --// TAB BUTTON

        local tb = _new("TextButton", {
            Size = UDim2.new(1, -2, 0, 40),
            BackgroundColor3 = self.Theme.Element,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Active = true,
            ZIndex = 7
        }, tabScroll)

        _corner(tb, 9)

        local tl = _new("TextLabel", {
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.fromOffset(7, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 8
        }, tb)

        td.Button = tb
        td.Label = tl

        --// PAGE

        local pg = _new("ScrollingFrame", {
            Name = name .. "_Page",
            Size = UDim2.new(1, -10, 1, -8),
            Position = UDim2.fromOffset(5, 4),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 5
        }, content)

        local layout = _new("UIListLayout", {
            Padding = UDim.new(0, 7),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, pg)

        _pad(pg, 4, 4, 7, 10)

        td.Page = pg
        td.Layout = layout

        table.insert(pages, td)

        tb.Activated:Connect(function()
            selectTab(td)
        end)

        --// FIRST TAB IS AUTOMATICALLY SELECTED

        if #pages == 1 then
            selectTab(td)
        end

        --//==================================================
        --// SECTION
        --//==================================================

        function td:CreateSection(text)
            local box = _new("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                BorderSizePixel = 0
            }, pg)

            _new("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = tostring(text or "Section"),
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, box)

            return box
        end

        --//==================================================
        --// LABEL
        --//==================================================

        function td:CreateLabel(text)
            local box = _new("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0
            }, pg)

            _corner(box, 8)
            _stroke(box, self.Theme.Border, 1)

            _new("TextLabel", {
                Size = UDim2.new(1, -18, 1, -8),
                Position = UDim2.fromOffset(9, 4),
                BackgroundTransparency = 1,
                Text = tostring(text or ""),
                TextColor3 = self.Theme.Muted,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            }, box)

            return box
        end

        --//==================================================
        --// BUTTON
        --//==================================================

        function td:CreateButton(c)
            c = c or {}

            local text = tostring(
                c.Name
                or c.Text
                or "Button"
            )

            local b = _new("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false,
                Active = true
            }, pg)

            _corner(b, 8)
            _stroke(b, self.Theme.Border, 1)

            b.MouseEnter:Connect(function()
                _tween(b, 0.12, {
                    BackgroundColor3 = self.Theme.ElementHover
                })
            end)

            b.MouseLeave:Connect(function()
                _tween(b, 0.12, {
                    BackgroundColor3 = self.Theme.Element
                })
            end)

            b.Activated:Connect(function()
                _safe(c.Callback)
            end)

            return {
                Instance = b
            }
        end

        --//==================================================
        --// TOGGLE
        --//==================================================

        function td:CreateToggle(c)
            c = c or {}

            local value = c.CurrentValue

            if value == nil then
                value = c.Default or false
            end

            value = value == true

            local row = _new("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Active = true
            }, pg)

            _corner(row, 8)
            _stroke(row, self.Theme.Border, 1)

            local lab = _new("TextLabel", {
                Size = UDim2.new(1, -62, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(c.Name or "Toggle"),
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, row)

            local swc = _new("Frame", {
                Size = UDim2.fromOffset(38, 20),
                Position = UDim2.new(1, -48, 0.5, -10),
                BackgroundColor3 = self.Theme.ToggleOff,
                BorderSizePixel = 0
            }, row)

            _corner(swc, 10)

            local dot = _new("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromOffset(2, 2),
                BackgroundColor3 = self.Theme.Muted,
                BorderSizePixel = 0
            }, swc)

            _corner(dot, 8)

            local obj = {}

            local function set(v, fire)
                value = v == true

                _tween(
                    swc,
                    0.14,
                    {
                        BackgroundColor3 =
                            value
                            and self.Theme.ToggleOn
                            or self.Theme.ToggleOff
                    }
                )

                _tween(
                    dot,
                    0.14,
                    {
                        Position =
                            value
                            and UDim2.fromOffset(20, 2)
                            or UDim2.fromOffset(2, 2),

                        BackgroundColor3 =
                            value
                            and Color3.new(1, 1, 1)
                            or self.Theme.Muted
                    }
                )

                if fire ~= false then
                    _safe(c.Callback, value)
                end
            end

            row.Activated:Connect(function()
                set(not value, true)
            end)

            set(value, false)

            function obj:Set(v)
                set(v, true)
            end

            function obj:Get()
                return value
            end

            return obj
        end

        --//==================================================
        --// SLIDER
        --//==================================================

        function td:CreateSlider(c)
            c = c or {}

            local mn = tonumber(c.Range and c.Range[1])
                or tonumber(c.Min)
                or 0

            local mx = tonumber(c.Range and c.Range[2])
                or tonumber(c.Max)
                or 100

            local inc = tonumber(c.Increment or c.Step)
                or 1

            if mx <= mn then
                mx = mn + 1
            end

            local val = tonumber(
                c.CurrentValue
                or c.Default
                or mn
            ) or mn

            local function snap(v)
                v = math.clamp(v, mn, mx)

                if inc > 0 then
                    v = mn + math.floor(
                        ((v - mn) / inc) + 0.5
                    ) * inc
                end

                return math.clamp(v, mn, mx)
            end

            val = snap(val)

            local row = _new("Frame", {
                Size = UDim2.new(1, 0, 0, 57),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0
            }, pg)

            _corner(row, 8)
            _stroke(row, self.Theme.Border, 1)

            local lab = _new("TextLabel", {
                Size = UDim2.new(1, -75, 0, 20),
                Position = UDim2.fromOffset(10, 5),
                BackgroundTransparency = 1,
                Text = tostring(c.Name or "Slider"),
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, row)

            local num = _new("TextLabel", {
                Size = UDim2.fromOffset(55, 20),
                Position = UDim2.new(1, -63, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = self.Theme.Muted,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right
            }, row)

            local track = _new("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.fromOffset(10, 37),
                BackgroundColor3 = self.Theme.ToggleOff,
                BorderSizePixel = 0
            }, row)

            _corner(track, 5)

            local fill = _new("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = self.Theme.Accent,
                BorderSizePixel = 0
            }, track)

            _corner(fill, 5)

            local hit = _new("TextButton", {
                Size = UDim2.new(1, 14, 1, 20),
                Position = UDim2.fromOffset(-7, -7),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Active = true
            }, track)

            local obj = {}
            local moving = false

            local function set(v, fire)
                val = snap(v)

                local pct = (val - mn) / (mx - mn)

                fill.Size = UDim2.new(
                    pct,
                    0,
                    1,
                    0
                )

                num.Text = tostring(val)

                if fire ~= false then
                    _safe(c.Callback, val)
                end
            end

            local function fromInput(x)
                local p = track.AbsolutePosition.X
                local s = track.AbsoluteSize.X

                if s <= 0 then
                    return
                end

                local pct = math.clamp(
                    (x - p) / s,
                    0,
                    1
                )

                set(
                    mn + ((mx - mn) * pct),
                    true
                )
            end

            hit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    moving = true
                    fromInput(input.Position.X)
                end
            end)

            _U.InputChanged:Connect(function(input)
                if not moving then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then

                    fromInput(input.Position.X)
                end
            end)

            _U.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    moving = false
                end
            end)

            set(val, false)

            function obj:Set(v)
                set(v, true)
            end

            function obj:Get()
                return val
            end

            return obj
        end

        --//==================================================
        --// DROPDOWN
        --//==================================================

        function td:CreateDropdown(c)
            c = c or {}

            local values = c.Options
                or c.Values
                or {}

            local current = c.CurrentOption
                or c.Default

            if type(current) == "table" then
                current = current[1]
            end

            local opened = false

            local holder = _new("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                BorderSizePixel = 0
            }, pg)

            local mainBtn = _new("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Active = true,
                ZIndex = 20
            }, holder)

            _corner(mainBtn, 8)
            _stroke(mainBtn, self.Theme.Border, 1)

            local titleLab = _new("TextLabel", {
                Size = UDim2.new(0.55, 0, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(c.Name or "Dropdown"),
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 21
            }, mainBtn)

            local valueLab = _new("TextLabel", {
                Size = UDim2.new(0.38, -10, 1, 0),
                Position = UDim2.new(0.57, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(current or "Select..."),
                TextColor3 = self.Theme.Muted,
                TextSize = 9,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 21
            }, mainBtn)

            local arrow = _new("TextLabel", {
                Size = UDim2.fromOffset(15, 20),
                Position = UDim2.new(1, -21, 0.5, -10),
                BackgroundTransparency = 1,
                Text = "⌄",
                TextColor3 = self.Theme.Muted,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                ZIndex = 21
            }, mainBtn)

            local list = _new("ScrollingFrame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 44),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = self.Theme.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Visible = false,
                ZIndex = 50
            }, holder)

            _corner(list, 8)
            _stroke(list, self.Theme.Border, 1)
            _pad(list, 4, 4, 4, 4)

            local ll = _new("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, list)

            local obj = {}

            local function clearOptions()
                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
            end

            local function addOption(v)
                local b = _new("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.Sidebar,
                    BorderSizePixel = 0,
                    Text = tostring(v),
                    TextColor3 = self.Theme.Text,
                    TextSize = 9,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    Active = true,
                    ZIndex = 51
                }, list)

                _corner(b, 6)

                b.Activated:Connect(function()
                    current = v
                    valueLab.Text = tostring(v)

                    opened = false
                    list.Visible = false
                    holder.Size = UDim2.new(1, 0, 0, 42)
                    arrow.Text = "⌄"

                    _safe(c.Callback, v)
                end)

                b.MouseEnter:Connect(function()
                    _tween(b, 0.1, {
                        BackgroundColor3 = self.Theme.ElementHover
                    })
                end)

                b.MouseLeave:Connect(function()
                    _tween(b, 0.1, {
                        BackgroundColor3 = self.Theme.Sidebar
                    })
                end)
            end

            local function rebuild()
                clearOptions()

                for _, v in ipairs(values) do
                    addOption(v)
                end
            end

            mainBtn.Activated:Connect(function()
                opened = not opened

                if opened then
                    list.Visible = true

                    local count = math.max(
                        1,
                        math.min(#values, 5)
                    )

                    local h = 4 + (count * 32) + ((count - 1) * 4) + 4

                    holder.Size = UDim2.new(
                        1,
                        0,
                        0,
                        42 + math.min(h, 180) + 4
                    )

                    list.Size = UDim2.new(
                        1,
                        0,
                        0,
                        math.min(h, 180)
                    )

                    arrow.Text = "⌃"
                else
                    list.Visible = false
                    holder.Size = UDim2.new(1, 0, 0, 42)
                    arrow.Text = "⌄"
                end
            end)

            rebuild()

            function obj:Set(v)
                current = v
                valueLab.Text = tostring(v)
                _safe(c.Callback, v)
            end

            function obj:Get()
                return current
            end

            function obj:Refresh(newValues)
                values = newValues or {}
                rebuild()
            end

            return obj
        end

        --//==================================================
        --// INPUT / TEXTBOX
        --//==================================================

        function td:CreateInput(c)
            c = c or {}

            local row = _new("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0
            }, pg)

            _corner(row, 8)
            _stroke(row, self.Theme.Border, 1)

            _new("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(c.Name or "Input"),
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, row)

            local box = _new("TextBox", {
                Size = UDim2.new(0.56, -5, 0, 30),
                Position = UDim2.new(0.42, 0, 0.5, -15),
                BackgroundColor3 = self.Theme.Sidebar,
                BorderSizePixel = 0,
                Text = tostring(c.Default or ""),
                PlaceholderText = tostring(c.PlaceholderText or "Enter text..."),
                PlaceholderColor3 = self.Theme.Muted,
                TextColor3 = self.Theme.Text,
                TextSize = 9,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false
            }, row)

            _corner(box, 7)

            box.FocusLost:Connect(function()
                _safe(c.Callback, box.Text)
            end)

            return {
                Instance = box,

                Set = function(_, v)
                    box.Text = tostring(v or "")
                    _safe(c.Callback, box.Text)
                end,

                Get = function()
                    return box.Text
                end
            }
        end

        --//==================================================
        --// COLOR PICKER
        --//==================================================

        function td:CreateColorPicker(c)
            c = c or {}

            local col = _rgb(
                c.Color
                or c.Default
                or self.Theme.Accent
            )

            local row = _new("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0
            }, pg)

            _corner(row, 8)
            _stroke(row, self.Theme.Border, 1)

            _new("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(c.Name or "Color"),
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, row)

            local sw = _new("TextButton", {
                Size = UDim2.fromOffset(36, 24),
                Position = UDim2.new(1, -46, 0.5, -12),
                BackgroundColor3 = col,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, row)

            _corner(sw, 7)

            local pop = _new("Frame", {
                Size = UDim2.fromOffset(170, 0),
                Position = UDim2.new(1, -170, 1, 5),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 100
            }, row)

            _corner(pop, 8)
            _stroke(pop, self.Theme.Border, 1)

            local presets = {
                Color3.fromRGB(255, 70, 70),
                Color3.fromRGB(255, 145, 55),
                Color3.fromRGB(255, 220, 60),
                Color3.fromRGB(60, 210, 125),
                Color3.fromRGB(60, 180, 255),
                Color3.fromRGB(90, 100, 255),
                Color3.fromRGB(180, 80, 255),
                Color3.fromRGB(255, 80, 190)
            }

            local grid = _new("UIGridLayout", {
                CellSize = UDim2.fromOffset(30, 30),
                CellPadding = UDim2.fromOffset(6, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, pop)

            _pad(pop, 10, 10, 10, 10)

            local obj = {}
            local open = false

            local function setColor(v, fire)
                col = _rgb(v)
                sw.BackgroundColor3 = col

                if fire ~= false then
                    _safe(c.Callback, col)
                end
            end

            for _, pc in ipairs(presets) do
                local b = _new("TextButton", {
                    BackgroundColor3 = pc,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 101
                }, pop)

                _corner(b, 7)

                b.Activated:Connect(function()
                    setColor(pc, true)

                    open = false
                    pop.Visible = false

                    _tween(pop, 0.12, {
                        Size = UDim2.fromOffset(170, 0)
                    })
                end)
            end

            sw.Activated:Connect(function()
                open = not open

                if open then
                    pop.Visible = true

                    _tween(pop, 0.15, {
                        Size = UDim2.fromOffset(170, 125)
                    })
                else
                    _tween(pop, 0.15, {
                        Size = UDim2.fromOffset(170, 0)
                    })

                    task.delay(0.16, function()
                        if not open then
                            pop.Visible = false
                        end
                    end)
                end
            end)

            function obj:Set(v)
                setColor(v, true)
            end

            function obj:Get()
                return col
            end

            return obj
        end

        --//==================================================
        --// KEYBIND
        --//==================================================

        function td:CreateKeybind(c)
            c = c or {}

            local key = c.CurrentKeybind
                or c.Default
                or Enum.KeyCode.RightShift

            if typeof(key) == "string" then
                key = Enum.KeyCode[key]
                    or Enum.KeyCode.RightShift
            end

            local waiting = false

            local row = _new("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = self.Theme.Element,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Active = true
            }, pg)

            _corner(row, 8)
            _stroke(row, self.Theme.Border, 1)

            _new("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = tostring(c.Name or "Keybind"),
                TextColor3 = self.Theme.Text,
                TextSize = 10,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, row)

            local kb = _new("TextLabel", {
                Size = UDim2.fromOffset(65, 28),
                Position = UDim2.new(1, -73, 0.5, -14),
                BackgroundColor3 = self.Theme.Sidebar,
                BorderSizePixel = 0,
                Text = key.Name,
                TextColor3 = self.Theme.Muted,
                TextSize = 9,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 3
            }, row)

            _corner(kb, 6)

            local obj = {}

            row.Activated:Connect(function()
                waiting = true
                kb.Text = "Press..."

                local conn

                conn = _U.InputBegan:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then
                        return
                    end

                    key = input.KeyCode
                    kb.Text = key.Name
                    waiting = false

                    if conn then
                        conn:Disconnect()
                    end

                    _safe(c.Callback, key)
                end)
            end)

            _U.InputBegan:Connect(function(input, processed)
                if processed or waiting then
                    return
                end

                if input.KeyCode == key then
                    _safe(c.Callback, key)
                end
            end)

            function obj:Set(v)
                if typeof(v) == "EnumItem" then
                    key = v
                elseif typeof(v) == "string" then
                    key = Enum.KeyCode[v]
                        or key
                end

                kb.Text = key.Name
            end

            function obj:Get()
                return key
            end

            return obj
        end

        return td
    end

    --//==================================================
    --// SEARCH
    --//==================================================

    search:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(search.Text or "")

        for _, x in ipairs(pages) do
            if q == "" then
                x.Button.Visible = true
            else
                x.Button.Visible =
                    string.find(
                        string.lower(x.Name),
                        q,
                        1,
                        true
                    ) ~= nil
            end
        end
    end)

    --//==================================================
    --// THEME UPDATE
    --//==================================================

    function w.ApplyTheme()
        if not main or not main.Parent then
            return
        end

        main.BackgroundColor3 = self.Theme.Background
        content.BackgroundColor3 = self.Theme.Background
        side.BackgroundColor3 = self.Theme.Sidebar
        top.BackgroundColor3 = self.Theme.Sidebar

        search.BackgroundColor3 = self.Theme.Element
        search.PlaceholderColor3 = self.Theme.Muted
        search.TextColor3 = self.Theme.Text

        min.BackgroundColor3 = self.Theme.Element
        cls.BackgroundColor3 = self.Theme.Element

        ttl.TextColor3 = self.Theme.Text
        sub.TextColor3 = self.Theme.Muted

        for _, x in ipairs(pages) do
            x.Button.BackgroundColor3 =
                x == selected
                and self.Theme.Accent
                or self.Theme.Element

            x.Label.TextColor3 =
                x == selected
                and Color3.new(1, 1, 1)
                or self.Theme.Muted

            x.Page.ScrollBarImageColor3 =
                self.Theme.Accent
        end

        tabScroll.ScrollBarImageColor3 =
            self.Theme.Accent
    end

    --//==================================================
    --// KEYBIND TOGGLE UI
    --//==================================================

    local toggleKey = c.ToggleUIKeybind

    if toggleKey then
        if typeof(toggleKey) == "string" then
            toggleKey =
                Enum.KeyCode[toggleKey]
                or Enum.KeyCode.RightShift
        end

        _U.InputBegan:Connect(function(input, processed)
            if processed or destroyed then
                return
            end

            if input.KeyCode == toggleKey then
                main.Visible = not main.Visible
            end
        end)
    end

    --//==================================================
    --// REGISTER
    --//==================================================

    table.insert(self.Windows, w)

    return w
end

--//==================================================
--// RETURN
--//==================================================

return _L
```1
