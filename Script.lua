-- =================================================================
-- SCRIPT.LUA - MATEOSCRIPTS HUB (RAYFIELD STYLE)
-- Repositorio: gutierrezmateo8701-debug/Ok
-- =================================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Eliminar ejecuciones previas para evitar duplicados
if CoreGui:FindFirstChild("RayfieldCustom_UI") then
    CoreGui.RayfieldCustom_UI:Destroy()
end

local Rayfield = {}

-- Función auxiliar para añadir bordes redondeados
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim2.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Función auxiliar para arrastrar la ventana
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- CREAR VENTANA PRINCIPAL (CreateWindow)
function Rayfield:CreateWindow(options)
    options = options or {}
    local WindowName = options.Name or "Rayfield Hub"
    local ToggleKey = options.ToggleUIKeybind or "K"

    -- Contenedor de la interfaz
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayfieldCustom_UI"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Marco Principal (MainFrame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 10)

    -- Barra Superior (Topbar)
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 38)
    Topbar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    AddCorner(Topbar, 10)
    MakeDraggable(Topbar, MainFrame)

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Contenedor de Botones de Control (Minimizar / Cerrar)
    local ControlContainer = Instance.new("Frame")
    ControlContainer.Size = UDim2.new(0, 70, 1, 0)
    ControlContainer.Position = UDim2.new(1, -75, 0, 0)
    ControlContainer.BackgroundTransparency = 1
    ControlContainer.Parent = Topbar

    local UIListControls = Instance.new("UIListLayout")
    UIListControls.FillDirection = Enum.FillDirection.Horizontal
    UIListControls.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListControls.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListControls.Padding = UDim.new(0, 6)
    UIListControls.Parent = ControlContainer

    -- Botón Minimizar (-)
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 16
    MinimizeBtn.Parent = ControlContainer
    AddCorner(MinimizeBtn, 6)

    -- Botón Cerrar/Eliminar GUI (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = ControlContainer
    AddCorner(CloseBtn, 6)

    -- Barra Lateral de Pestañas (Sidebar)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, -46)
    Sidebar.Position = UDim2.new(0, 8, 0, 42)
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    AddCorner(Sidebar, 8)

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = Sidebar

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 6)
    TabPadding.PaddingLeft = UDim.new(0, 6)
    TabPadding.PaddingRight = UDim.new(0, 6)
    TabPadding.Parent = Sidebar

    -- Contenedor de Páginas
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -154, 1, -46)
    ContentContainer.Position = UDim2.new(0, 146, 0, 42)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    -- Lógica de Minimizar
    local IsMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 520, 0, 38)
            }):Play()
            Sidebar.Visible = false
            ContentContainer.Visible = false
            MinimizeBtn.Text = "+"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 520, 0, 350)
            }):Play()
            task.delay(0.15, function()
                Sidebar.Visible = true
                ContentContainer.Visible = true
            end)
            MinimizeBtn.Text = "-"
        end
    end)

    -- Lógica de Eliminar GUI
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Ocultar o mostrar con la tecla asignada
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode[ToggleKey] then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local WindowObj = {
        Tabs = {}
    }

    function Rayfield:Destroy()
        ScreenGui:Destroy()
    end

    -- CREAR PESTAÑA (CreateTab)
    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        AddCorner(TabBtn, 6)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)
        TabPage.Visible = false
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.Parent = TabPage

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        local TabObj = {}

        local function SelectTab()
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
                t.Button.TextColor3 = Color3.fromRGB(160, 160, 170)
            end
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)
        if #WindowObj.Tabs == 0 then SelectTab() end
        table.insert(WindowObj.Tabs, {Button = TabBtn, Page = TabPage})

        -- CREAR SECCIÓN
        function TabObj:CreateSection(sectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, -6, 0, 20)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = string.upper(sectionName)
            SectionLabel.TextColor3 = Color3.fromRGB(120, 120, 135)
            SectionLabel.TextSize = 10
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = TabPage
        end

        -- CREAR ETIQUETA (Label)
        function TabObj:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -6, 0, 24)
            Label.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
            Label.Text = "  " .. text
            Label.TextColor3 = Color3.fromRGB(200, 200, 210)
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabPage
            AddCorner(Label, 4)

            return {
                Set = function(_, newText)
                    Label.Text = "  " .. newText
                end
            }
        end

        -- CREAR PÁRRAFO (Paragraph)
        function TabObj:CreateParagraph(options)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 48)
            Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -12, 0, 18)
            Title.Position = UDim2.new(0, 8, 0, 4)
            Title.BackgroundTransparency = 1
            Title.Text = options.Title or ""
            Title.TextColor3 = Color3.fromRGB(240, 240, 240)
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 11
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Frame

            local Content = Instance.new("TextLabel")
            Content.Size = UDim2.new(1, -12, 0, 20)
            Content.Position = UDim2.new(0, 8, 0, 22)
            Content.BackgroundTransparency = 1
            Content.Text = options.Content or ""
            Content.TextColor3 = Color3.fromRGB(160, 160, 175)
            Content.Font = Enum.Font.Gotham
            Content.TextSize = 10
            Content.TextXAlignment = Enum.TextXAlignment.Left
            Content.Parent = Frame

            return {
                Set = function(_, newOpts)
                    if newOpts.Title then Title.Text = newOpts.Title end
                    if newOpts.Content then Content.Text = newOpts.Content end
                end
            }
        end

        -- CREAR DIVISOR (Divider)
        function TabObj:CreateDivider()
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, -6, 0, 1)
            Divider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            Divider.BorderSizePixel = 0
            Divider.Parent = TabPage
        end

        -- CREAR BOTÓN (Button)
        function TabObj:CreateButton(options)
            options = options or {}
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -6, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Btn.Text = options.Name or "Botón"
            Btn.TextColor3 = Color3.fromRGB(220, 220, 230)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Btn.Parent = TabPage
            AddCorner(Btn, 6)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)}):Play()
                task.delay(0.1, function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 46)}):Play()
                end)
                if options.Callback then options.Callback() end
            end)
        end

        -- CREAR TOGGLE (Toggle)
        function TabObj:CreateToggle(options)
            options = options or {}
            local State = options.CurrentValue or false

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 30)
            Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name or "Toggle"
            Label.TextColor3 = Color3.fromRGB(220, 220, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 34, 0, 16)
            Switch.Position = UDim2.new(1, -40, 0.5, -8)
            Switch.BackgroundColor3 = State and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
            Switch.Text = ""
            Switch.Parent = Frame
            AddCorner(Switch, 8)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 12, 0, 12)
            Circle.Position = State and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = Switch
            AddCorner(Circle, 8)

            local function SetState(val)
                State = val
                local targetPos = State and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                local targetColor = State and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
                TweenService:Create(Circle, TweenInfo.new(0.12), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
                if options.Callback then options.Callback(State) end
            end

            Switch.MouseButton1Click:Connect(function()
                SetState(not State)
            end)

            return { Set = SetState }
        end

        -- CREAR SLIDER (Slider)
        function TabObj:CreateSlider(options)
            options = options or {}
            local Min = options.Range and options.Range[1] or 0
            local Max = options.Range and options.Range[2] or 100
            local Value = options.CurrentValue or Min
            local Suffix = options.Suffix or ""

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 0, 18)
            Label.Position = UDim2.new(0, 8, 0, 2)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name or "Slider"
            Label.TextColor3 = Color3.fromRGB(220, 220, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 50, 0, 18)
            ValLabel.Position = UDim2.new(1, -55, 0, 2)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(Value) .. Suffix
            ValLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
            ValLabel.Font = Enum.Font.Gotham
            ValLabel.TextSize = 11
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Frame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -16, 0, 5)
            Track.Position = UDim2.new(0, 8, 0, 25)
            Track.BackgroundColor3 = Color3.fromRGB(60, 60, 72)
            Track.Text = ""
            Track.Parent = Frame
            AddCorner(Track, 4)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
            Fill.Parent = Track
            AddCorner(Fill, 4)

            local dragging = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + (Max - Min) * pos)
                ValLabel.Text = tostring(Value) .. Suffix
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                if options.Callback then options.Callback(Value) end
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)

            return {
                Set = function(_, newVal)
                    Value = math.clamp(newVal, Min, Max)
                    local pos = (Value - Min) / (Max - Min)
                    ValLabel.Text = tostring(Value) .. Suffix
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    if options.Callback then options.Callback(Value) end
                end
            }
        end

        -- CREAR INPUT (Input)
        function TabObj:CreateInput(options)
            options = options or {}
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 32)
            Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name or "Input"
            Label.TextColor3 = Color3.fromRGB(220, 220, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0.45, 0, 0, 22)
            TextBox.Position = UDim2.new(0.52, 0, 0.5, -11)
            TextBox.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            TextBox.PlaceholderText = options.PlaceholderText or "Escribir..."
            TextBox.Text = options.CurrentValue or ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 11
            TextBox.Parent = Frame
            AddCorner(TextBox, 4)

            TextBox.FocusLost:Connect(function()
                if options.Callback then options.Callback(TextBox.Text) end
            end)

            return {
                Set = function(_, txt)
                    TextBox.Text = txt
                    if options.Callback then options.Callback(txt) end
                end
            }
        end

        -- CREAR DROPDOWN (Dropdown)
        function TabObj:CreateDropdown(options)
            options = options or {}
            local Opts = options.Options or {}
            local Selected = options.CurrentOption and options.CurrentOption[1] or (Opts[1] or "Ninguno")

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 32)
            Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Frame.ClipsDescendants = true
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Header = Instance.new("TextButton")
            Header.Size = UDim2.new(1, 0, 0, 32)
            Header.BackgroundTransparency = 1
            Header.Text = ""
            Header.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 0, 32)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name or "Dropdown"
            Label.TextColor3 = Color3.fromRGB(220, 220, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Header

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0.45, -10, 0, 32)
            ValLabel.Position = UDim2.new(0.5, 0, 0, 0)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = Selected
            ValLabel.TextColor3 = Color3.fromRGB(0, 140, 255)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 11
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = Header

            local open = false
            Header.MouseButton1Click:Connect(function()
                open = not open
                local targetH = open and (36 + (#Opts * 24)) or 32
                TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, targetH)}):Play()
            end)

            for i, opt in ipairs(Opts) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, -12, 0, 22)
                OptBtn.Position = UDim2.new(0, 6, 0, 32 + ((i - 1) * 24))
                OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                OptBtn.Text = opt
                OptBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 10
                OptBtn.Parent = Frame
                AddCorner(OptBtn, 4)

                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    ValLabel.Text = Selected
                    open = false
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 32)}):Play()
                    if options.Callback then options.Callback({Selected}) end
                end)
            end
        end

        -- CREAR COLORPICKER
        function TabObj:CreateColorPicker(options)
            options = options or {}
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 32)
            Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name or "Color Picker"
            Label.TextColor3 = Color3.fromRGB(220, 220, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local Preview = Instance.new("Frame")
            Preview.Size = UDim2.new(0, 24, 0, 18)
            Preview.Position = UDim2.new(1, -32, 0.5, -9)
            Preview.BackgroundColor3 = options.Color or Color3.fromRGB(255, 255, 255)
            Preview.Parent = Frame
            AddCorner(Preview, 4)
        end

        -- CREAR KEYBIND
        function TabObj:CreateKeybind(options)
            options = options or {}
            local CurrentKey = options.CurrentKeybind or "E"

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 32)
            Frame.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
            Frame.Parent = TabPage
            AddCorner(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name or "Keybind"
            Label.TextColor3 = Color3.fromRGB(220, 220, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Size = UDim2.new(0, 40, 0, 20)
            KeyBtn.Position = UDim2.new(1, -48, 0.5, -10)
            KeyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            KeyBtn.Text = CurrentKey
            KeyBtn.TextColor3 = Color3.fromRGB(0, 140, 255)
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 10
            KeyBtn.Parent = Frame
            AddCorner(KeyBtn, 4)

            local listening = false
            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentKey = input.KeyCode.Name
                    KeyBtn.Text = CurrentKey
                    listening = false
                    if options.Callback then options.Callback(CurrentKey) end
                end
            end)
        end

        return TabObj
    end

    return WindowObj
end

-- SISTEMA DE NOTIFICACIONES (Rayfield:Notify)
function Rayfield:Notify(options)
    options = options or {}
    local CoreGuiRef = CoreGui:FindFirstChild("RayfieldCustom_UI") or LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("RayfieldCustom_UI")
    if not CoreGuiRef then return end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 220, 0, 50)
    Frame.Position = UDim2.new(1, 10, 1, -60)
    Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    Frame.Parent = CoreGuiRef
    AddCorner(Frame, 6)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 0, 20)
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.BackgroundTransparency = 1
    Title.Text = options.Title or "Notificación"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -10, 0, 20)
    Content.Position = UDim2.new(0, 8, 0, 24)
    Content.BackgroundTransparency = 1
    Content.Text = options.Content or ""
    Content.TextColor3 = Color3.fromRGB(180, 180, 190)
    Content.Font = Enum.Font.Gotham
    Content.TextSize = 11
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.Parent = Frame

    TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -230, 1, -60)}):Play()
    task.delay(options.Duration or 3, function()
        TweenService:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 1, -60)}):Play()
        task.wait(0.3)
        Frame:Destroy()
    end)
end

-- =================================================================
-- IMPLEMENTACIÓN DE TU SCRIPT DE ROBLOX
-- =================================================================

local Window = Rayfield:CreateWindow({
    Name = "MateoScripts | Hub VIP",
    ToggleUIKeybind = "K"
})

Rayfield:Notify({
    Title = "Script Cargado",
    Content = "Iniciado correctamente desde GitHub.",
    Duration = 4
})

-- Pestaña Principal
local TabPrincipal = Window:CreateTab("Principal")
TabPrincipal:CreateSection("Estadísticas del Jugador")

TabPrincipal:CreateParagraph({
    Title = "Bienvenido MateoScripts",
    Content = "Presiona la tecla 'K' para ocultar/mostrar este menú."
})

local WalkspeedSlider = TabPrincipal:CreateSlider({
    Name = "Velocidad de Caminado",
    Range = {16, 250},
    CurrentValue = 16,
    Suffix = " studs",
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

local JumpPowerSlider = TabPrincipal:CreateSlider({
    Name = "Fuerza de Salto",
    Range = {50, 300},
    CurrentValue = 50,
    Suffix = " power",
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end
})

TabPrincipal:CreateButton({
    Name = "Restablecer Valores por Defecto",
    Callback = function()
        WalkspeedSlider:Set(16)
        JumpPowerSlider:Set(50)
    end
})

-- Pestaña Utilidades
local TabUtilidades = Window:CreateTab("Utilidades")
TabUtilidades:CreateSection("Automatizaciones")

TabUtilidades:CreateToggle({
    Name = "Modo Dios / Noclip Local",
    CurrentValue = false,
    Callback = function(state)
        print("Estado Noclip:", state)
    end
})

TabUtilidades:CreateInput({
    Name = "Teleport a Jugador",
    PlaceholderText = "Escribe nombre de usuario...",
    Callback = function(targetUser)
        print("Intentando teleport a:", targetUser)
    end
})

TabUtilidades:CreateDropdown({
    Name = "Seleccionar Zona VIP",
    Options = {"Lobby", "Zona de Combate", "Tienda", "Zona Segura"},
    CurrentOption = {"Lobby"},
    Callback = function(option)
        print("Zona seleccionada:", option[1])
    end
})

return Rayfield
