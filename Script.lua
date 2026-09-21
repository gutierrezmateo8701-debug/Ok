-- ========================================================
-- LIBRERÍA DE INTERFAZ DE USUARIO (RAYFIELD-STYLE CUSTOM)
-- DESARROLLADO POR MATEO
-- ========================================================

local Rayfield = {}
Rayfield.Flags = {}
Rayfield.Themes = {
    Default = { Main = Color3.fromRGB(25, 25, 25), TopBar = Color3.fromRGB(35, 35, 35), Element = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(0, 170, 255), SecondaryText = Color3.fromRGB(180, 180, 180) },
    Ocean = { Main = Color3.fromRGB(15, 25, 40), TopBar = Color3.fromRGB(20, 35, 55), Element = Color3.fromRGB(30, 50, 75), Text = Color3.fromRGB(240, 240, 255), Accent = Color3.fromRGB(0, 195, 255), SecondaryText = Color3.fromRGB(160, 180, 210) },
    Cyberpunk = { Main = Color3.fromRGB(20, 15, 30), TopBar = Color3.fromRGB(30, 20, 45), Element = Color3.fromRGB(45, 30, 65), Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(255, 0, 128), SecondaryText = Color3.fromRGB(200, 160, 220) },
    Emerald = { Main = Color3.fromRGB(15, 30, 20), TopBar = Color3.fromRGB(20, 45, 30), Element = Color3.fromRGB(30, 65, 45), Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(46, 204, 113), SecondaryText = Color3.fromRGB(160, 210, 180) },
    Midnight = { Main = Color3.fromRGB(10, 10, 15), TopBar = Color3.fromRGB(18, 18, 25), Element = Color3.fromRGB(25, 25, 35), Text = Color3.fromRGB(220, 220, 220), Accent = Color3.fromRGB(140, 122, 230), SecondaryText = Color3.fromRGB(150, 150, 180) },
    Light = { Main = Color3.fromRGB(235, 235, 235), TopBar = Color3.fromRGB(215, 215, 215), Element = Color3.fromRGB(190, 190, 190), Text = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(0, 122, 255), SecondaryText = Color3.fromRGB(90, 90, 90) }
}

local CurrentTheme = Rayfield.Themes.Default
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Selección de contenedor (CoreGui o PlayerGui)
local TargetParent = CoreGui
if not pcall(function() local _ = CoreGui.Name end) then
    TargetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Limpiar instancias anteriores si se reejecuta
if TargetParent:FindFirstChild("RayfieldMainUI") then TargetParent.RayfieldMainUI:Destroy() end
if TargetParent:FindFirstChild("RayfieldNotifications") then TargetParent.RayfieldNotifications:Destroy() end

-- Sistema de Notificaciones
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "RayfieldNotifications"
NotificationGui.Parent = TargetParent
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "Holder"
NotificationHolder.Parent = NotificationGui
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Position = UDim2.new(1, -290, 1, -30)
NotificationHolder.Size = UDim2.new(0, 270, 0, 0)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotificationHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

function Rayfield:Notify(Config)
    local TitleText = Config.Title or "Notificación"
    local ContentText = Config.Content or ""
    local Duration = Config.Duration or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Parent = NotificationHolder
    NotifFrame.BackgroundColor3 = CurrentTheme.Main
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Size = UDim2.new(1, 0, 0, 0)
    NotifFrame.AutomaticSize = Enum.AutomaticSize.Y

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotifFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = CurrentTheme.Accent
    UIStroke.Thickness = 1.5
    UIStroke.Parent = NotifFrame

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = NotifFrame
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingLeft = UDim.new(0, 12)
    UIPadding.PaddingRight = UDim.new(0, 12)

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = NotifFrame
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = TitleText
    TitleLabel.TextColor3 = CurrentTheme.Accent
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Parent = NotifFrame
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Size = UDim2.new(1, 0, 0, 0)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.Font = Enum.Font.SourceSans
    ContentLabel.Text = ContentText
    ContentLabel.TextColor3 = CurrentTheme.Text
    ContentLabel.TextSize = 13
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        task.wait(Duration)
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        for _, child in pairs(NotifFrame:GetChildren()) do
            if child:IsA("TextLabel") then
                TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.35)
        NotifFrame:Destroy()
    end)
end

function Rayfield:CreateWindow(Config)
    local WindowTitle = Config.Name or "Hub Principal"
    local AuthorSubtitle = Config.LoadingSubtitle or "by Mateo"
    local ThemeName = Config.Theme or "Default"
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    CurrentTheme = Rayfield.Themes[ThemeName] or Rayfield.Themes.Default

    -- Sistema de Llaves
    if Config.KeySystem then
        local KeyValidated = false
        local ValidKeys = Config.KeySettings and Config.KeySettings.Key or {"Mateo123"}
        if type(ValidKeys) == "string" then ValidKeys = {ValidKeys} end

        local KeyGui = Instance.new("ScreenGui")
        KeyGui.Name = "RayfieldKeySystem"
        KeyGui.Parent = TargetParent

        local KeyFrame = Instance.new("Frame")
        KeyFrame.Parent = KeyGui
        KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        KeyFrame.Size = UDim2.new(0, 320, 0, 180)
        KeyFrame.BackgroundColor3 = CurrentTheme.Main
        KeyFrame.BorderSizePixel = 0

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 8)
        KeyCorner.Parent = KeyFrame

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Parent = KeyFrame
        KeyTitle.Position = UDim2.new(0, 15, 0, 15)
        KeyTitle.Size = UDim2.new(1, -30, 0, 20)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Font = Enum.Font.SourceSansBold
        KeyTitle.Text = Config.KeySettings and Config.KeySettings.Title or "Sistema de Verificación"
        KeyTitle.TextColor3 = CurrentTheme.Accent
        KeyTitle.TextSize = 18

        local KeyInput = Instance.new("TextBox")
        KeyInput.Parent = KeyFrame
        KeyInput.Position = UDim2.new(0, 20, 0, 55)
        KeyInput.Size = UDim2.new(1, -40, 0, 35)
        KeyInput.BackgroundColor3 = CurrentTheme.Element
        KeyInput.Font = Enum.Font.SourceSans
        KeyInput.PlaceholderText = "Ingresa tu clave aquí..."
        KeyInput.Text = ""
        KeyInput.TextColor3 = CurrentTheme.Text
        KeyInput.TextSize = 15

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = KeyInput

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Parent = KeyFrame
        SubmitBtn.Position = UDim2.new(0, 20, 0, 110)
        SubmitBtn.Size = UDim2.new(1, -40, 0, 35)
        SubmitBtn.BackgroundColor3 = CurrentTheme.Accent
        SubmitBtn.Font = Enum.Font.SourceSansBold
        SubmitBtn.Text = "Verificar Llave"
        SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitBtn.TextSize = 16

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = SubmitBtn

        SubmitBtn.MouseButton1Click:Connect(function()
            local InputText = KeyInput.Text
            for _, k in pairs(ValidKeys) do
                if InputText == k then
                    KeyValidated = true
                    break
                end
            end
            if KeyValidated then
                KeyGui:Destroy()
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "¡Llave Incorrecta!"
            end
        end)

        repeat task.wait() until KeyValidated
    end

    -- Ventana Principal
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "RayfieldMainUI"
    MainGui.Parent = TargetParent
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MainGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 520, 0, 360)
    MainFrame.BackgroundColor3 = CurrentTheme.Main
    MainFrame.BorderSizePixel = 0

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Sistema de Arrastre Suave (Dragging)
    local Dragging = false
    local DragInput, DragStart, StartPos

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.BorderSizePixel = 0

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar

    local TopBarFix = Instance.new("Frame")
    TopBarFix.Parent = TopBar
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.BackgroundColor3 = CurrentTheme.TopBar
    TopBarFix.BorderSizePixel = 0

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    -- Alternar visibilidad con tecla
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = WindowTitle .. "  |  " .. AuthorSubtitle
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Contenedor de Pestañas
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 130, 1, -60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)

    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = MainFrame
    PageContainer.Position = UDim2.new(0, 150, 0, 50)
    PageContainer.Size = UDim2.new(1, -160, 1, -60)
    PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local FirstTab = true
    local TabButtons = {}

    function WindowObj:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(1, -5, 0, 32)
        TabBtn.BackgroundColor3 = CurrentTheme.Element
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = FirstTab and CurrentTheme.Accent or CurrentTheme.SecondaryText
        TabBtn.TextSize = 14

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = TabBtn

        local PageFrame = Instance.new("ScrollingFrame")
        PageFrame.Name = TabName .. "Page"
        PageFrame.Parent = PageContainer
        PageFrame.Size = UDim2.new(1, 0, 1, 0)
        PageFrame.BackgroundTransparency = 1
        PageFrame.Visible = FirstTab
        PageFrame.ScrollBarThickness = 3
        PageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        PageFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = PageFrame
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 8)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = PageFrame
        PagePadding.PaddingRight = UDim.new(0, 8)

        table.insert(TabButtons, {Button = TabBtn, Page = PageFrame})
        FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(TabButtons) do
                t.Page.Visible = false
                t.Button.TextColor3 = CurrentTheme.SecondaryText
            end
            PageFrame.Visible = true
            TabBtn.TextColor3 = CurrentTheme.Accent
        end)

        local TabObj = {}

        -- Sección
        function TabObj:CreateSection(SectionTitle)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Parent = PageFrame
            SecLabel.Size = UDim2.new(1, 0, 0, 22)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.SourceSansBold
            SecLabel.Text = "--- " .. SectionTitle .. " ---"
            SecLabel.TextColor3 = CurrentTheme.Accent
            SecLabel.TextSize = 14
        end

        -- Texto (Label)
        function TabObj:CreateLabel(Text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Parent = PageFrame
            Lbl.Size = UDim2.new(1, 0, 0, 28)
            Lbl.BackgroundColor3 = CurrentTheme.Element
            Lbl.Font = Enum.Font.SourceSans
            Lbl.Text = "   " .. Text
            Lbl.TextColor3 = CurrentTheme.Text
            Lbl.TextSize = 14
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Lbl
        end

        -- Botón
        function TabObj:CreateButton(Config)
            local BtnName = Config.Name or "Botón"
            local Callback = Config.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSansBold
            Btn.Text = BtnName
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.Accent}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Element}):Play()
                Callback()
            end)
        end

        -- Toggle con soporte para Flags
        function TabObj:CreateToggle(Config)
            local ToggleName = Config.Name or "Toggle"
            local DefaultState = Config.CurrentValue or false
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            if Flag then Rayfield.Flags[Flag] = DefaultState end
            local ToggleState = DefaultState

            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = "   " .. ToggleName
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            local Indicator = Instance.new("Frame")
            Indicator.Parent = Btn
            Indicator.AnchorPoint = Vector2.new(1, 0.5)
            Indicator.Position = UDim2.new(1, -10, 0.5, 0)
            Indicator.Size = UDim2.new(0, 40, 0, 20)
            Indicator.BackgroundColor3 = ToggleState and CurrentTheme.Accent or Color3.fromRGB(60, 60, 60)

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator

            local Knob = Instance.new("Frame")
            Knob.Parent = Indicator
            Knob.AnchorPoint = Vector2.new(0, 0.5)
            Knob.Position = ToggleState and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = Knob

            Btn.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                if Flag then Rayfield.Flags[Flag] = ToggleState end

                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = ToggleState and CurrentTheme.Accent or Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = ToggleState and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()

                Callback(ToggleState)
            end)
        end

        -- Slider REAL con Arrastre del Ratón
        function TabObj:CreateSlider(Config)
            local SliderName = Config.Name or "Slider"
            local Min = Config.Range and Config.Range[1] or 0
            local Max = Config.Range and Config.Range[2] or 100
            local DefaultVal = Config.CurrentValue or Min
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            local CurrentValue = math.clamp(DefaultVal, Min, Max)
            if Flag then Rayfield.Flags[Flag] = CurrentValue end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = PageFrame
            SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            SliderFrame.BackgroundColor3 = CurrentTheme.Element

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = SliderFrame

            local Title = Instance.new("TextLabel")
            Title.Parent = SliderFrame
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -20, 0, 16)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.SourceSans
            Title.Text = SliderName .. ": " .. tostring(CurrentValue)
            Title.TextColor3 = CurrentTheme.Text
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame")
            Track.Parent = SliderFrame
            Track.Position = UDim2.new(0, 10, 0, 28)
            Track.Size = UDim2.new(1, -20, 0, 8)
            Track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Parent = Track
            Fill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Accent

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Sliding = false

            local function UpdateSlider(input)
                local MousePos = input.Position.X
                local TrackPos = Track.AbsolutePosition.X
                local TrackWidth = Track.AbsoluteSize.X

                local Percent = math.clamp((MousePos - TrackPos) / TrackWidth, 0, 1)
                CurrentValue = math.floor(Min + (Max - Min) * Percent)

                Fill.Size = UDim2.new(Percent, 0, 1, 0)
                Title.Text = SliderName .. ": " .. tostring(CurrentValue)

                if Flag then Rayfield.Flags[Flag] = CurrentValue end
                Callback(CurrentValue)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = true
                    UpdateSlider(input)
                end
            end)

            Track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
        end

        -- Dropdown Desplegable Real
        function TabObj:CreateDropdown(Config)
            local DropName = Config.Name or "Dropdown"
            local Options = Config.Options or {}
            local DefaultOpt = Config.CurrentOption or Options[1] or ""
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            local Selected = DefaultOpt
            if Flag then Rayfield.Flags[Flag] = Selected end
            local Expanded = false

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = PageFrame
            DropFrame.Size = UDim2.new(1, 0, 0, 36)
            DropFrame.BackgroundColor3 = CurrentTheme.Element
            DropFrame.ClipsDescendants = true

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropFrame

            local MainBtn = Instance.new("TextButton")
            MainBtn.Parent = DropFrame
            MainBtn.Size = UDim2.new(1, 0, 0, 36)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Font = Enum.Font.SourceSans
            MainBtn.Text = "   " .. DropName .. ": " .. tostring(Selected)
            MainBtn.TextColor3 = CurrentTheme.Text
            MainBtn.TextSize = 14
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("TextLabel")
            Arrow.Parent = MainBtn
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.Position = UDim2.new(1, -12, 0.5, 0)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.BackgroundTransparency = 1
            Arrow.Font = Enum.Font.SourceSansBold
            Arrow.Text = "▼"
            Arrow.TextColor3 = CurrentTheme.Accent
            Arrow.TextSize = 12

            local OptionHolder = Instance.new("Frame")
            OptionHolder.Parent = DropFrame
            OptionHolder.Position = UDim2.new(0, 5, 0, 40)
            OptionHolder.Size = UDim2.new(1, -10, 0, #Options * 28)
            OptionHolder.BackgroundTransparency = 1

            local HolderList = Instance.new("UIListLayout")
            HolderList.Parent = OptionHolder
            HolderList.SortOrder = Enum.SortOrder.LayoutOrder
            HolderList.Padding = UDim.new(0, 2)

            for _, opt in ipairs(Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Parent = OptionHolder
                OptBtn.Size = UDim2.new(1, 0, 0, 26)
                OptBtn.BackgroundColor3 = CurrentTheme.Main
                OptBtn.Font = Enum.Font.SourceSans
                OptBtn.Text = tostring(opt)
                OptBtn.TextColor3 = CurrentTheme.Text
                OptBtn.TextSize = 13

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 4)
                OptCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    MainBtn.Text = "   " .. DropName .. ": " .. tostring(Selected)
                    if Flag then Rayfield.Flags[Flag] = Selected end

                    Expanded = false
                    Arrow.Text = "▼"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()

                    Callback(Selected)
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                Arrow.Text = Expanded and "▲" or "▼"
                local TargetHeight = Expanded and (44 + #Options * 28) or 36
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
            end)
        end

        -- Campo de Texto (Input / TextBox)
        function TabObj:CreateInput(Config)
            local InputName = Config.Name or "Entrada"
            local Placeholder = Config.PlaceholderText or "Escribe aquí..."
            local Flag = Config.Flag
            local Callback = Config.Callback or function() end

            local InputFrame = Instance.new("Frame")
            InputFrame.Parent = PageFrame
            InputFrame.Size = UDim2.new(1, 0, 0, 40)
            InputFrame.BackgroundColor3 = CurrentTheme.Element

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = InputFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = InputFrame
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.SourceSans
            Label.Text = InputName
            Label.TextColor3 = CurrentTheme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = InputFrame
            TextBox.Position = UDim2.new(0.4, 0, 0.15, 0)
            TextBox.Size = UDim2.new(0.58, -10, 0.7, 0)
            TextBox.BackgroundColor3 = CurrentTheme.Main
            TextBox.Font = Enum.Font.SourceSans
            TextBox.PlaceholderText = Placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = CurrentTheme.Text
            TextBox.TextSize = 13

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = TextBox

            TextBox.FocusLost:Connect(function()
                local TextVal = TextBox.Text
                if Flag then Rayfield.Flags[Flag] = TextVal end
                Callback(TextVal)
            end)
        end

        return TabObj
    end

    return WindowObj
end

return Rayfield
