-- ========================================================
-- LIBRERÍA RAYFIELD UI - DISEÑO ORIGINAL (MATEO)
-- ========================================================

local Rayfield = {}
Rayfield.Flags = {}

local CurrentTheme = {
    Main = Color3.fromRGB(18, 14, 28),
    TopBar = Color3.fromRGB(24, 18, 38),
    TabBtn = Color3.fromRGB(35, 26, 55),
    TabBtnSelected = Color3.fromRGB(50, 36, 80),
    Element = Color3.fromRGB(32, 24, 50),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 200),
    Accent = Color3.fromRGB(230, 40, 105)
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local TargetParent = CoreGui
if not pcall(function() local _ = CoreGui.Name end) then
    TargetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

if TargetParent:FindFirstChild("RayfieldMainUI") then TargetParent.RayfieldMainUI:Destroy() end
if TargetParent:FindFirstChild("RayfieldNotifications") then TargetParent.RayfieldNotifications:Destroy() end

-- Sistema de Notificaciones
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "RayfieldNotifications"
NotificationGui.Parent = TargetParent

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Parent = NotificationGui
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Position = UDim2.new(1, -280, 1, -30)
NotificationHolder.Size = UDim2.new(0, 260, 0, 0)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotificationHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

function Rayfield:Notify(Config)
    local NotifFrame = Instance.new("Frame")
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
    ListLayout.Padding = UDim.new(0, 3)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = Config.Title or "Notificación"
    TitleLabel.TextColor3 = CurrentTheme.Accent
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Parent = NotifFrame
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Size = UDim2.new(1, 0, 0, 0)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.Font = Enum.Font.SourceSans
    ContentLabel.Text = Config.Content or ""
    ContentLabel.TextColor3 = CurrentTheme.Text
    ContentLabel.TextSize = 13
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        task.wait(Config.Duration or 3)
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
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "RayfieldMainUI"
    MainGui.Parent = TargetParent

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MainGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 520, 0, 350)
    MainFrame.BackgroundColor3 = CurrentTheme.Main
    MainFrame.BorderSizePixel = 0

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Arrastre de Ventana
    local Dragging, DragInput, DragStart, StartPos
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.BorderSizePixel = 0

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
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

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = (Config.Name or "Mi Script de Roblox") .. "  |  " .. (Config.LoadingSubtitle or "by Mateo")
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Contenedor Lateral de Pestañas (con Botones Rectangulares)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = MainFrame
    TabContainer.Position = UDim2.new(0, 12, 0, 50)
    TabContainer.Size = UDim2.new(0, 130, 1, -62)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)

    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame
    PageContainer.Position = UDim2.new(0, 152, 0, 50)
    PageContainer.Size = UDim2.new(1, -164, 1, -62)
    PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local TabsList = {}
    local FirstTab = true

    function WindowObj:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = FirstTab and CurrentTheme.TabBtnSelected or CurrentTheme.TabBtn
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = CurrentTheme.Text
        TabBtn.TextSize = 14

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = TabBtn

        local PageFrame = Instance.new("ScrollingFrame")
        PageFrame.Parent = PageContainer
        PageFrame.Size = UDim2.new(1, 0, 1, 0)
        PageFrame.BackgroundTransparency = 1
        PageFrame.Visible = FirstTab
        PageFrame.ScrollBarThickness = 2
        PageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        PageFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = PageFrame
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 8)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = PageFrame
        PagePadding.PaddingRight = UDim.new(0, 6)

        table.insert(TabsList, {Button = TabBtn, Page = PageFrame})
        FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(TabsList) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = CurrentTheme.TabBtn
            end
            PageFrame.Visible = true
            TabBtn.BackgroundColor3 = CurrentTheme.TabBtnSelected
        end)

        local TabObj = {}

        -- Secciones
        function TabObj:CreateSection(SectionTitle)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Parent = PageFrame
            SecLabel.Size = UDim2.new(1, 0, 0, 24)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.SourceSansBold
            SecLabel.Text = "--- " .. SectionTitle .. " ---"
            SecLabel.TextColor3 = CurrentTheme.Accent
            SecLabel.TextSize = 14
        end

        -- Botones Grandes
        function TabObj:CreateButton(Config)
            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = Config.Name or "Botón"
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback() end
            end)
        end

        -- Toggle
        function TabObj:CreateToggle(Config)
            local ToggleState = Config.CurrentValue or false
            local Flag = Config.Flag
            if Flag then Rayfield.Flags[Flag] = ToggleState end

            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = (Config.Name or "Toggle") .. ": " .. (ToggleState and "[ON]" or "[OFF]")
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                if Flag then Rayfield.Flags[Flag] = ToggleState end
                Btn.Text = (Config.Name or "Toggle") .. ": " .. (ToggleState and "[ON]" or "[OFF]")
                if Config.Callback then Config.Callback(ToggleState) end
            end)
        end

        -- Slider
        function TabObj:CreateSlider(Config)
            local Min = Config.Range and Config.Range[1] or 0
            local Max = Config.Range and Config.Range[2] or 100
            local Value = Config.CurrentValue or Min
            local Flag = Config.Flag
            if Flag then Rayfield.Flags[Flag] = Value end

            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = (Config.Name or "Slider") .. ": " .. tostring(Value)
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                Value = Value + 10
                if Value > Max then Value = Min end
                if Flag then Rayfield.Flags[Flag] = Value end
                Btn.Text = (Config.Name or "Slider") .. ": " .. tostring(Value)
                if Config.Callback then Config.Callback(Value) end
            end)
        end

        -- Dropdown
        function TabObj:CreateDropdown(Config)
            local Options = Config.Options or {}
            local Index = 1
            local Selected = Options[Index] or ""
            local Flag = Config.Flag
            if Flag then Rayfield.Flags[Flag] = Selected end

            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = (Config.Name or "Dropdown") .. ": " .. tostring(Selected)
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                Index = Index + 1
                if Index > #Options then Index = 1 end
                Selected = Options[Index]
                if Flag then Rayfield.Flags[Flag] = Selected end
                Btn.Text = (Config.Name or "Dropdown") .. ": " .. tostring(Selected)
                if Config.Callback then Config.Callback(Selected) end
            end)
        end

        return TabObj
    end

    return WindowObj
end

return Rayfield
