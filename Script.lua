-- ========================================================
-- LIBRERÍA DE INTERFAZ DE USUARIO (RAYFIELD-STYLE CUSTOM)
-- DESARROLLADO POR MATEO
-- ========================================================

local Rayfield = {}
Rayfield.Flags = {}
Rayfield.Themes = {
    Default = { Main = Color3.fromRGB(25, 25, 25), TopBar = Color3.fromRGB(35, 35, 35), Element = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(0, 170, 255) },
    Ocean = { Main = Color3.fromRGB(15, 25, 40), TopBar = Color3.fromRGB(20, 35, 55), Element = Color3.fromRGB(30, 50, 75), Text = Color3.fromRGB(240, 240, 255), Accent = Color3.fromRGB(0, 195, 255) },
    Cyberpunk = { Main = Color3.fromRGB(20, 15, 30), TopBar = Color3.fromRGB(30, 20, 45), Element = Color3.fromRGB(45, 30, 65), Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(255, 0, 128) },
    Emerald = { Main = Color3.fromRGB(15, 30, 20), TopBar = Color3.fromRGB(20, 45, 30), Element = Color3.fromRGB(30, 65, 45), Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(46, 204, 113) },
    Midnight = { Main = Color3.fromRGB(10, 10, 15), TopBar = Color3.fromRGB(18, 18, 25), Element = Color3.fromRGB(25, 25, 35), Text = Color3.fromRGB(220, 220, 220), Accent = Color3.fromRGB(140, 122, 230) },
    Light = { Main = Color3.fromRGB(235, 235, 235), TopBar = Color3.fromRGB(215, 215, 215), Element = Color3.fromRGB(190, 190, 190), Text = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(0, 122, 255) }
}

local CurrentTheme = Rayfield.Themes.Default
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Sistema de Notificaciones
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "RayfieldNotifications"
NotificationGui.Parent = CoreGui

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "Holder"
NotificationHolder.Parent = NotificationGui
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Position = UDim2.new(1, -280, 1, -30)
NotificationHolder.Size = UDim2.new(0, 260, 0, 0)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotificationHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

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
    NotifFrame.AutomaticSize = Enum.AutomaticSize.Y -- Ajuste automático de altura

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotifFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = CurrentTheme.Accent
    UIStroke.Thickness = 1.5
    UIStroke.Parent = NotifFrame

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = NotifFrame
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 12)
    UIPadding.PaddingRight = UDim.new(0, 12)

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = NotifFrame
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 4)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = TitleText
    TitleLabel.TextColor3 = CurrentTheme.Accent
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Parent = NotifFrame
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Size = UDim2.new(1, 0, 0, 0)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.Font = Enum.Font.SourceSans
    ContentLabel.Text = ContentText
    ContentLabel.TextColor3 = CurrentTheme.Text
    ContentLabel.TextSize = 14
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        task.wait(Duration)
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        for _, child in pairs(NotifFrame:GetChildren()) do
            if child:IsA("TextLabel") then
                TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end

function Rayfield:SetTheme(ThemeName)
    if Rayfield.Themes[ThemeName] then
        CurrentTheme = Rayfield.Themes[ThemeName]
        Rayfield:Notify({
            Title = "Tema Actualizado",
            Content = "Nuevo tema aplicado: " .. ThemeName,
            Duration = 2
        })
    end
end

function Rayfield:CreateWindow(Config)
    local WindowTitle = Config.Name or "Hub Principal"
    local AuthorSubtitle = Config.LoadingSubtitle or "by Mateo"
    local Theme = Config.Theme or "Default"
    CurrentTheme = Rayfield.Themes[Theme] or Rayfield.Themes.Default

    -- Sistema de Llaves Integrado
    if Config.KeySystem then
        local KeyValidated = false
        local ValidKeys = Config.KeySettings and Config.KeySettings.Key or {"Mateo123"}
        if type(ValidKeys) == "string" then ValidKeys = {ValidKeys} end

        local KeyGui = Instance.new("ScreenGui")
        KeyGui.Name = "RayfieldKeySystem"
        KeyGui.Parent = CoreGui

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
    MainGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MainGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.BackgroundColor3 = CurrentTheme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.BorderSizePixel = 0

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = WindowTitle .. "  |  " .. AuthorSubtitle
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 120, 1, -60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = MainFrame
    PageContainer.Position = UDim2.new(0, 140, 0, 50)
    PageContainer.Size = UDim2.new(1, -150, 1, -60)
    PageContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local FirstTab = true

    function WindowObj:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = CurrentTheme.Element
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = CurrentTheme.Text
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

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = PageFrame
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 8)

        FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, page in pairs(PageContainer:GetChildren()) do
                if page:IsA("ScrollingFrame") then page.Visible = false end
            end
            PageFrame.Visible = true
        end)

        local TabObj = {}

        function TabObj:CreateSection(SectionTitle)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Parent = PageFrame
            SecLabel.Size = UDim2.new(1, -10, 0, 20)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.SourceSansBold
            SecLabel.Text = "--- " .. SectionTitle .. " ---"
            SecLabel.TextColor3 = CurrentTheme.Accent
            SecLabel.TextSize = 14
        end

        function TabObj:CreateLabel(Text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Parent = PageFrame
            Lbl.Size = UDim2.new(1, -10, 0, 25)
            Lbl.BackgroundColor3 = CurrentTheme.Element
            Lbl.Font = Enum.Font.SourceSans
            Lbl.Text = "  " .. Text
            Lbl.TextColor3 = CurrentTheme.Text
            Lbl.TextSize = 14
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Lbl
        end

        function TabObj:CreateButton(Config)
            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, -10, 0, 32)
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

        function TabObj:CreateToggle(Config)
            local ToggleState = Config.CurrentValue or false
            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, -10, 0, 32)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = (Config.Name or "Toggle") .. ": " .. (ToggleState and "[ON]" or "[OFF]")
            Btn.TextColor3 = ToggleState and CurrentTheme.Accent or CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                Btn.Text = (Config.Name or "Toggle") .. ": " .. (ToggleState and "[ON]" or "[OFF]")
                Btn.TextColor3 = ToggleState and CurrentTheme.Accent or CurrentTheme.Text
                if Config.Callback then Config.Callback(ToggleState) end
            end)
        end

        function TabObj:CreateSlider(Config)
            local Value = Config.CurrentValue or Config.Range[1]
            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, -10, 0, 35)
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
                if Value > Config.Range[2] then Value = Config.Range[1] end
                Btn.Text = (Config.Name or "Slider") .. ": " .. tostring(Value)
                if Config.Callback then Config.Callback(Value) end
            end)
        end

        function TabObj:CreateColorpicker(Config)
            local Color = Config.Color or Color3.fromRGB(255, 255, 255)
            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, -10, 0, 32)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = (Config.Name or "Colorpicker")
            Btn.TextColor3 = Color
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                if Config.Callback then Config.Callback(Color) end
            end)
        end

        function TabObj:CreateDropdown(Config)
            local Options = Config.Options or {}
            local CurrentIndex = 1
            local Btn = Instance.new("TextButton")
            Btn.Parent = PageFrame
            Btn.Size = UDim2.new(1, -10, 0, 32)
            Btn.BackgroundColor3 = CurrentTheme.Element
            Btn.Font = Enum.Font.SourceSans
            Btn.Text = (Config.Name or "Dropdown") .. ": " .. tostring(Options[CurrentIndex] or "")
            Btn.TextColor3 = CurrentTheme.Text
            Btn.TextSize = 14

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                CurrentIndex = CurrentIndex + 1
                if CurrentIndex > #Options then CurrentIndex = 1 end
                local Selected = Options[CurrentIndex]
                Btn.Text = (Config.Name or "Dropdown") .. ": " .. tostring(Selected)
                if Config.Callback then Config.Callback(Selected) end
            end)
        end

        return TabObj
    end

    -- Tab predeterminado de Ajustes
    local SettingsTab = WindowObj:CreateTab("Ajustes")
    SettingsTab:CreateSection("Información del Script")
    SettingsTab:CreateLabel("Script: " .. WindowTitle)
    SettingsTab:CreateLabel("Creador: " .. AuthorSubtitle)
    SettingsTab:CreateLabel("Estado: Activo & Funcional")

    SettingsTab:CreateSection("Personalización")
    SettingsTab:CreateDropdown({
        Name = "Cambiar Tema",
        Options = {"Default", "Ocean", "Cyberpunk", "Emerald", "Midnight", "Light"},
        CurrentOption = Config.Theme or "Default",
        Callback = function(Option)
            Rayfield:SetTheme(Option)
        end
    })

    return WindowObj
end

return Rayfield
