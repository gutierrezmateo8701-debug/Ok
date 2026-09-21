--[[
    Rayfield UI Library - Recreación Modular en Luau
    Sintaxis 100% compatible con la API de Rayfield oficial.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Rayfield = {
    Flags = {},
    Theme = {
        Background = Color3.fromRGB(21, 21, 23),
        Sidebar = Color3.fromRGB(16, 16, 18),
        Element = Color3.fromRGB(28, 28, 32),
        ElementBorder = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(79, 70, 229),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(150, 150, 160)
    }
}

-- Detectar contenedor adecuado (CoreGui o PlayerGui)
local ParentGui
if gethui then
    ParentGui = gethui()
elseif syn and syn.protect_gui then
    ParentGui = CoreGui
else
    ParentGui = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RayfieldEngineUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

-- Sistema de Notificaciones Container
local NotifyHolder = Instance.new("Frame")
NotifyHolder.Name = "NotifyHolder"
NotifyHolder.Size = UDim2.new(0, 300, 1, -20)
NotifyHolder.Position = UDim2.new(1, -310, 0, 10)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 100
NotifyHolder.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.Parent = NotifyHolder

-- Funciones Auxiliares
local function Tween(object, info, properties)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(gui, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or gui

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Notificaciones
function Rayfield:Notify(Config)
    Config = Config or {}
    local Title = Config.Title or "Notificación"
    local Content = Config.Content or ""
    local Duration = Config.Duration or 5

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 65)
    Frame.BackgroundColor3 = Rayfield.Theme.Element
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = NotifyHolder

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Rayfield.Theme.ElementBorder
    Stroke.Thickness = 1
    Stroke.Transparency = 1

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Text = Title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextColor3 = Rayfield.Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Position = UDim2.new(0, 12, 0, 10)
    TitleLbl.Size = UDim2.new(1, -24, 0, 18)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.TextTransparency = 1
    TitleLbl.Parent = Frame

    local ContentLbl = Instance.new("TextLabel")
    ContentLbl.Text = Content
    ContentLbl.Font = Enum.Font.Gotham
    ContentLbl.TextSize = 12
    ContentLbl.TextColor3 = Rayfield.Theme.SubText
    ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
    ContentLbl.TextWrapped = true
    ContentLbl.Position = UDim2.new(0, 12, 0, 30)
    ContentLbl.Size = UDim2.new(1, -24, 0, 28)
    ContentLbl.BackgroundTransparency = 1
    ContentLbl.TextTransparency = 1
    ContentLbl.Parent = Frame

    Tween(Frame, {0.3, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0})
    Tween(Stroke, {0.3, Enum.EasingStyle.Quad}, {Transparency = 0})
    Tween(TitleLbl, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 0})
    Tween(ContentLbl, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 0})

    task.delay(Duration, function()
        local t = Tween(Frame, {0.3, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
        Tween(Stroke, {0.3, Enum.EasingStyle.Quad}, {Transparency = 1})
        Tween(TitleLbl, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        Tween(ContentLbl, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        t.Completed:Connect(function()
            Frame:Destroy()
        end)
    end)
end

-- Creación de Ventana Principal
function Rayfield:CreateWindow(Config)
    Config = Config or {}
    local WindowName = Config.Name or "Rayfield Interface"

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 620, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -310, 0.5, -190)
    MainFrame.BackgroundColor3 = Rayfield.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Rayfield.Theme.ElementBorder
    MainStroke.Thickness = 1

    -- Barra Superior
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    MakeDraggable(MainFrame, TopBar)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = WindowName
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Rayfield.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    -- Sidebar (Contenedor de pestañas)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = Rayfield.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SideCorner = Instance.new("UICorner", Sidebar)
    SideCorner.CornerRadius = UDim.new(0, 10)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Rayfield.Theme.ElementBorder
    TabContainer.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)

    -- Contenedor de Páginas
    local PagesFolder = Instance.new("Frame")
    PagesFolder.Name = "PagesFolder"
    PagesFolder.Size = UDim2.new(1, -170, 1, -55)
    PagesFolder.Position = UDim2.new(0, 165, 0, 50)
    PagesFolder.BackgroundTransparency = 1
    PagesFolder.Parent = MainFrame

    local Window = {
        Tabs = {},
        ActiveTab = nil
    }

    -- Método para crear Pestañas
    function Window:CreateTab(Name, Icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = Name .. "Tab"
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Rayfield.Theme.Element
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "   " .. Name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = Rayfield.Theme.SubText
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer

        local TabCorner = Instance.new("UICorner", TabBtn)
        TabCorner.CornerRadius = UDim.new(0, 6)

        -- Página de contenido
        local Page = Instance.new("ScrollingFrame")
        Page.Name = Name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Rayfield.Theme.ElementBorder
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = PagesFolder

        local PageList = Instance.new("UIListLayout", Page)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 6)

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)

        local TabObject = {}

        -- Selección de Pestaña
        local function SelectTab()
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {0.2, Enum.EasingStyle.Quad}, {
                    BackgroundTransparency = 1,
                    TextColor3 = Rayfield.Theme.SubText
                })
                t.Page.Visible = false
            end

            Tween(TabBtn, {0.2, Enum.EasingStyle.Quad}, {
                BackgroundTransparency = 0,
                TextColor3 = Rayfield.Theme.Text
            })
            Page.Visible = true
            Window.ActiveTab = TabObject
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        if #Window.Tabs == 0 then
            SelectTab()
        end

        -- Elementos de la Pestaña
        function TabObject:CreateSection(Name)
            local SecFrame = Instance.new("Frame")
            SecFrame.Size = UDim2.new(1, -10, 0, 24)
            SecFrame.BackgroundTransparency = 1
            SecFrame.Parent = Page

            local SecLabel = Instance.new("TextLabel")
            SecLabel.Text = string.upper(Name)
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 11
            SecLabel.TextColor3 = Rayfield.Theme.SubText
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Size = UDim2.new(1, 0, 1, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Parent = SecFrame
        end

        function TabObject:CreateButton(Config)
            Config = Config or {}
            local Name = Config.Name or "Button"
            local Callback = Config.Callback or function() end

            local BtnFrame = Instance.new("Frame")
            BtnFrame.Size = UDim2.new(1, -10, 0, 36)
            BtnFrame.BackgroundColor3 = Rayfield.Theme.Element
            BtnFrame.Parent = Page

            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", BtnFrame)
            Stroke.Color = Rayfield.Theme.ElementBorder

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = Name
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextColor3 = Rayfield.Theme.Text
            Btn.Parent = BtnFrame

            Btn.MouseButton1Down:Connect(function()
                Tween(BtnFrame, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Rayfield.Theme.Accent})
            end)

            Btn.MouseButton1Up:Connect(function()
                Tween(BtnFrame, {0.2, Enum.EasingStyle.Quad}, {BackgroundColor3 = Rayfield.Theme.Element})
                Callback()
            end)
        end

        function TabObject:CreateToggle(Config)
            Config = Config or {}
            local Name = Config.Name or "Toggle"
            local State = Config.CurrentValue or false
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Rayfield.Theme.Element
            Frame.Parent = Page

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", Frame)
            Stroke.Color = Rayfield.Theme.ElementBorder

            local Label = Instance.new("TextLabel")
            Label.Text = Name
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextColor3 = Rayfield.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 36, 0, 18)
            Switch.Position = UDim2.new(1, -48, 0.5, -9)
            Switch.BackgroundColor3 = State and Rayfield.Theme.Accent or Color3.fromRGB(40, 40, 45)
            Switch.Parent = Frame

            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Switch

            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local Clickable = Instance.new("TextButton")
            Clickable.Size = UDim2.new(1, 0, 1, 0)
            Clickable.BackgroundTransparency = 1
            Clickable.Text = ""
            Clickable.Parent = Frame

            local function SetState(NewState)
                State = NewState
                if Flag then Rayfield.Flags[Flag] = State end
                Tween(Switch, {0.2, Enum.EasingStyle.Quad}, {
                    BackgroundColor3 = State and Rayfield.Theme.Accent or Color3.fromRGB(40, 40, 45)
                })
                Tween(Knob, {0.2, Enum.EasingStyle.Quad}, {
                    Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                })
                Callback(State)
            end

            Clickable.MouseButton1Click:Connect(function()
                SetState(not State)
            end)

            if Flag then Rayfield.Flags[Flag] = State end

            return {
                Set = SetState
            }
        end

        function TabObject:CreateSlider(Config)
            Config = Config or {}
            local Name = Config.Name or "Slider"
            local Min = Config.Range and Config.Range[1] or 0
            local Max = Config.Range and Config.Range[2] or 100
            local Value = Config.CurrentValue or Min
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 50)
            Frame.BackgroundColor3 = Rayfield.Theme.Element
            Frame.Parent = Page

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", Frame)
            Stroke.Color = Rayfield.Theme.ElementBorder

            local Label = Instance.new("TextLabel")
            Label.Text = Name
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextColor3 = Rayfield.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Position = UDim2.new(0, 12, 0, 8)
            Label.Size = UDim2.new(0.5, 0, 0, 16)
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(Value)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 12
            ValueLabel.TextColor3 = Rayfield.Theme.SubText
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Position = UDim2.new(0.5, 0, 0, 8)
            ValueLabel.Size = UDim2.new(0.5, -12, 0, 16)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Parent = Frame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 0, 32)
            Track.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Track.Parent = Frame

            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Rayfield.Theme.Accent
            Fill.Parent = Track

            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Sliding = false

            local function Update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + (Max - Min) * pos)
                ValueLabel.Text = tostring(Value)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                if Flag then Rayfield.Flags[Flag] = Value end
                Callback(Value)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            if Flag then Rayfield.Flags[Flag] = Value end
        end

        function TabObject:CreateDropdown(Config)
            Config = Config or {}
            local Name = Config.Name or "Dropdown"
            local Options = Config.Options or {}
            local Selected = Config.CurrentOption or Options[1]
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Rayfield.Theme.Element
            Frame.ClipsDescendants = true
            Frame.Parent = Page

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", Frame)
            Stroke.Color = Rayfield.Theme.ElementBorder

            local Label = Instance.new("TextLabel")
            Label.Text = Name .. " - " .. tostring(Selected)
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextColor3 = Rayfield.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -24, 0, 38)
            Label.BackgroundTransparency = 1
            Label.Parent = Frame

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.Parent = Frame

            local Container = Instance.new("Frame")
            Container.Position = UDim2.new(0, 0, 0, 38)
            Container.Size = UDim2.new(1, 0, 0, #Options * 28)
            Container.BackgroundTransparency = 1
            Container.Parent = Frame

            local CLayout = Instance.new("UIListLayout", Container)

            local Expanded = false

            Btn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                Tween(Frame, {0.2, Enum.EasingStyle.Quad}, {
                    Size = Expanded and UDim2.new(1, -10, 0, 38 + (#Options * 28)) or UDim2.new(1, -10, 0, 38)
                })
            end)

            for _, opt in ipairs(Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 28)
                OptBtn.BackgroundTransparency = 1
                OptBtn.Text = "  " .. tostring(opt)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextColor3 = Rayfield.Theme.SubText
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Parent = Container

                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    Label.Text = Name .. " - " .. tostring(Selected)
                    Expanded = false
                    Tween(Frame, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -10, 0, 38)})
                    if Flag then Rayfield.Flags[Flag] = Selected end
                    Callback(Selected)
                end)
            end

            if Flag then Rayfield.Flags[Flag] = Selected end
        end

        TabObject.Button = TabBtn
        TabObject.Page = Page
        table.insert(Window.Tabs, TabObject)

        return TabObject
    end

    return Window
end

return Rayfield
