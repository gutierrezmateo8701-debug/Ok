--[[
    Rayfield UI Library - Edición RGB + Custom ColorPicker & Pure Text Loading
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local function _0xS(_b)
    local _s = ""
    for _i = 1, #_b do _s = _s .. string.char(_b[_i]) end
    return _s
end

local _0xT = {
    Bg = Color3.fromRGB(18, 18, 20),
    Sb = Color3.fromRGB(13, 13, 15),
    El = Color3.fromRGB(25, 25, 28),
    Br = Color3.fromRGB(40, 40, 45),
    Tx = Color3.fromRGB(240, 240, 240),
    St = Color3.fromRGB(140, 140, 150)
}

local Rayfield = { Flags = {} }

-- Sistema Global RGB
local RGB_Objects = {}
RunService.Heartbeat:Connect(function()
    local hue = (tick() % 3) / 3
    local color = Color3.fromHSV(hue, 0.9, 1)
    for obj, prop in pairs(RGB_Objects) do
        if obj and obj.Parent then
            obj[prop] = color
        else
            RGB_Objects[obj] = nil
        end
    end
end)

local ParentGui = (gethui and gethui()) or (syn and syn.protect_gui and CoreGui) or Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Rayfield_RGB_Engine"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

-- Botón "UI" Flotante (Negro con Borde RGB)
local UIBtn = Instance.new("TextButton")
UIBtn.Name = "ToggleUI_RGB"
UIBtn.Size = UDim2.new(0, 42, 0, 42)
UIBtn.Position = UDim2.new(0, 10, 0.5, -21)
UIBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Negro Sólido
UIBtn.Text = "UI"
UIBtn.Font = Enum.Font.GothamBold
UIBtn.TextSize = 14
UIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UIBtn.ZIndex = 9999
UIBtn.Parent = ScreenGui

Instance.new("UICorner", UIBtn).CornerRadius = UDim.new(0, 8)
local UIBStroke = Instance.new("UIStroke", UIBtn)
UIBStroke.Thickness = 2
RGB_Objects[UIBStroke] = "Color" -- Borde RGB

-- Contenedor de Notificaciones
local NotifyHolder = Instance.new("Frame", ScreenGui)
NotifyHolder.Size = UDim2.new(0, 240, 1, -20)
NotifyHolder.Position = UDim2.new(1, -250, 0, 10)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 1000

local NotifyLayout = Instance.new("UIListLayout", NotifyHolder)
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 6)

local function Tween(obj, info, prop)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), prop)
    t:Play()
    return t
end

local function MakeDraggable(gui, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or gui
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = inp.Position; startPos = gui.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement then dragInput = inp end end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Rayfield:Notify(cfg)
    cfg = cfg or {}
    local frm = Instance.new("Frame", NotifyHolder)
    frm.Size = UDim2.new(1, 0, 0, 48)
    frm.BackgroundColor3 = _0xT.El
    frm.BackgroundTransparency = 1
    Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 6)
    
    local stk = Instance.new("UIStroke", frm)
    stk.Color = _0xT.Br; stk.Transparency = 1
    
    local tlbl = Instance.new("TextLabel", frm)
    tlbl.Text = cfg.Title or "Notificación"
    tlbl.Font = Enum.Font.GothamBold; tlbl.TextSize = 12; tlbl.TextColor3 = _0xT.Tx
    tlbl.Position = UDim2.new(0, 10, 0, 6); tlbl.Size = UDim2.new(1, -20, 0, 14)
    tlbl.BackgroundTransparency = 1; tlbl.TextXAlignment = Enum.TextXAlignment.Left; tlbl.TextTransparency = 1

    local clbl = Instance.new("TextLabel", frm)
    clbl.Text = cfg.Content or ""
    clbl.Font = Enum.Font.Gotham; clbl.TextSize = 11; clbl.TextColor3 = _0xT.St
    clbl.Position = UDim2.new(0, 10, 0, 22); clbl.Size = UDim2.new(1, -20, 0, 20)
    clbl.BackgroundTransparency = 1; clbl.TextXAlignment = Enum.TextXAlignment.Left; clbl.TextTransparency = 1; clbl.TextWrapped = true

    Tween(frm, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0})
    Tween(stk, {0.2, Enum.EasingStyle.Quad}, {Transparency = 0})
    Tween(tlbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 0})
    Tween(clbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 0})

    task.delay(cfg.Duration or 3, function()
        local t = Tween(frm, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
        Tween(stk, {0.2, Enum.EasingStyle.Quad}, {Transparency = 1})
        Tween(tlbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        Tween(clbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        t.Completed:Connect(function() frm:Destroy() end)
    end)
end

function Rayfield:CreateWindow(cfg)
    cfg = cfg or {}
    local mainVisible = true

    -- EFECTO DE CARGA: Solo Texto RGB (Sin Pantallas / Sin Fondos)
    local loadTitleText = cfg.LoadingTitle or "Loading..."
    local loadSubtitleText = cfg.LoadingSubtitle or "de mateo"

    local LoadHolder = Instance.new("Frame", ScreenGui)
    LoadHolder.Size = UDim2.new(0, 300, 0, 60)
    LoadHolder.Position = UDim2.new(0.5, -150, 0.4, -30)
    LoadHolder.BackgroundTransparency = 1
    LoadHolder.ZIndex = 10000

    local LTitle = Instance.new("TextLabel", LoadHolder)
    LTitle.Text = loadTitleText
    LTitle.Font = Enum.Font.GothamBold
    LTitle.TextSize = 26
    LTitle.Size = UDim2.new(1, 0, 0, 30)
    LTitle.BackgroundTransparency = 1
    RGB_Objects[LTitle] = "TextColor3" -- Texto RGB

    local LSub = Instance.new("TextLabel", LoadHolder)
    LSub.Text = loadSubtitleText
    LSub.Font = Enum.Font.GothamMedium
    LSub.TextSize = 14
    LSub.Position = UDim2.new(0, 0, 0, 30)
    LSub.Size = UDim2.new(1, 0, 0, 20)
    LSub.BackgroundTransparency = 1
    RGB_Objects[LSub] = "TextColor3" -- Subtítulo RGB

    task.delay(2, function()
        Tween(LTitle, {0.4, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        Tween(LSub, {0.4, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        task.wait(0.4)
        LoadHolder:Destroy()
    end)

    -- Ventana Principal Chica
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 460, 0, 290)
    MainFrame.Position = UDim2.new(0.5, -230, 0.5, -145)
    MainFrame.BackgroundColor3 = _0xT.Bg
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = _0xT.Br

    -- Barra Superior
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundTransparency = 1
    MakeDraggable(MainFrame, TopBar)

    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Text = cfg.Name or "Rayfield Interface"
    TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.TextSize = 13; TitleLabel.TextColor3 = _0xT.Tx
    TitleLabel.Position = UDim2.new(0, 10, 0, 0); TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.BackgroundTransparency = 1; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    UIBtn.MouseButton1Click:Connect(function()
        mainVisible = not mainVisible
        MainFrame.Visible = mainVisible
    end)

    -- Panel Lateral
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 120, 1, -38)
    Sidebar.Position = UDim2.new(0, 5, 0, 33)
    Sidebar.BackgroundColor3 = _0xT.Sb
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, -6, 1, -6); TabContainer.Position = UDim2.new(0, 3, 0, 3)
    TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 3)

    -- Panel de Páginas
    local PagesFolder = Instance.new("Frame", MainFrame)
    PagesFolder.Size = UDim2.new(1, -138, 1, -40); PagesFolder.Position = UDim2.new(0, 132, 0, 35)
    PagesFolder.BackgroundTransparency = 1

    local Window = { Tabs = {} }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 26)
        TabBtn.BackgroundColor3 = _0xT.El; TabBtn.BackgroundTransparency = 1
        TabBtn.Text = " " .. name; TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11; TabBtn.TextColor3 = _0xT.St; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("ScrollingFrame", PagesFolder)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1
        Page.Visible = false; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = _0xT.Br
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder; PageList.Padding = UDim.new(0, 4)
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 6)
        end)

        local TabObj = {}

        local function Select()
            for _, t in pairs(Window.Tabs) do
                Tween(t.Btn, {0.15, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1, TextColor3 = _0xT.St})
                t.Page.Visible = false
            end
            Tween(TabBtn, {0.15, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0, TextColor3 = _0xT.Tx})
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if #Window.Tabs == 0 then Select() end

        -- Componentes Estándar
        function TabObj:CreateSection(secName)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 18); f.BackgroundTransparency = 1
            local l = Instance.new("TextLabel", f)
            l.Text = string.upper(secName); l.Font = Enum.Font.GothamBold; l.TextSize = 9
            l.TextColor3 = _0xT.St; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabObj:CreateButton(bCfg)
            bCfg = bCfg or {}
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
            local btn = Instance.new("TextButton", f)
            btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = bCfg.Name or "Button"
            btn.Font = Enum.Font.GothamMedium; btn.TextSize = 10; btn.TextColor3 = _0xT.Tx
            btn.MouseButton1Down:Connect(function() Tween(f, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Color3.fromRGB(60,60,70)}) end)
            btn.MouseButton1Up:Connect(function()
                Tween(f, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = _0xT.El})
                if bCfg.Callback then bCfg.Callback() end
            end)
        end

        function TabObj:CreateToggle(tCfg)
            tCfg = tCfg or {}
            local st = tCfg.CurrentValue or false
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
            local l = Instance.new("TextLabel", f)
            l.Text = tCfg.Name or "Toggle"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.6, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            
            local sw = Instance.new("Frame", f)
            sw.Size = UDim2.new(0, 28, 0, 14); sw.Position = UDim2.new(1, -34, 0.5, -7)
            sw.BackgroundColor3 = st and Color3.fromRGB(80, 70, 230) or _0xT.Br
            Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

            local kn = Instance.new("Frame", sw)
            kn.Size = UDim2.new(0, 10, 0, 10); kn.Position = st and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
            kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)

            local btn = Instance.new("TextButton", f)
            btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""

            local function Update(val)
                st = val
                if tCfg.Flag then Rayfield.Flags[tCfg.Flag] = st end
                Tween(sw, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = st and Color3.fromRGB(80, 70, 230) or _0xT.Br})
                Tween(kn, {0.15, Enum.EasingStyle.Quad}, {Position = st and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)})
                if tCfg.Callback then tCfg.Callback(st) end
            end

            btn.MouseButton1Click:Connect(function() Update(not st) end)
            if tCfg.Flag then Rayfield.Flags[tCfg.Flag] = st end
            return { Set = Update }
        end

        -- COLOR PICKER INTERACTIVO CON PALETA, CIRCULITO LIMITABLE Y PREVIEW
        function TabObj:CreateColorpicker(cCfg)
            cCfg = cCfg or {}
            local currentColor = cCfg.Color or Color3.fromRGB(255, 0, 0)
            local expanded = false

            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 28)
            f.BackgroundColor3 = _0xT.El
            f.ClipsDescendants = true
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new("TextLabel", f)
            l.Text = cCfg.Name or "Colorpicker"
            l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.6, 0, 0, 28); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

            -- Cuadro de Vista Previa (Preview)
            local Preview = Instance.new("Frame", f)
            Preview.Size = UDim2.new(0, 24, 0, 14)
            Preview.Position = UDim2.new(1, -32, 0, 7)
            Preview.BackgroundColor3 = currentColor
            Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 3)
            local PrevStroke = Instance.new("UIStroke", Preview)
            PrevStroke.Color = _0xT.Br

            local toggleBtn = Instance.new("TextButton", f)
            toggleBtn.Size = UDim2.new(1, 0, 0, 28)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""

            -- Canvas de Paleta
            local PickerContainer = Instance.new("Frame", f)
            PickerContainer.Size = UDim2.new(1, -16, 0, 95)
            PickerContainer.Position = UDim2.new(0, 8, 0, 32)
            PickerContainer.BackgroundTransparency = 1

            local Palette = Instance.new("ImageLabel", PickerContainer)
            Palette.Size = UDim2.new(1, 0, 1, 0)
            Palette.Image = "rbxassetid://6027284224" -- Textura HSV Standard
            Palette.BackgroundTransparency = 1
            Instance.new("UICorner", Palette).CornerRadius = UDim.new(0, 4)

            -- Circulito de Selección (Limitable)
            local Knob = Instance.new("Frame", Palette)
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.Position = UDim2.new(0.5, -6, 0.5, -6)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.ZIndex = 5
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            local KnobStroke = Instance.new("UIStroke", Knob)
            KnobStroke.Color = Color3.fromRGB(0, 0, 0)
            KnobStroke.Thickness = 1.5

            local dragging = false

            local function UpdateColorFromInput(input)
                -- Restricción/Límite estricto dentro de la paleta (0 a 1)
                local relX = math.clamp((input.Position.X - Palette.AbsolutePosition.X) / Palette.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - Palette.AbsolutePosition.Y) / Palette.AbsoluteSize.Y, 0, 1)

                -- Movimiento del circulito dentro de los bordes
                Knob.Position = UDim2.new(relX, -6, relY, -6)

                -- Cálculo de Color HSV
                currentColor = Color3.fromHSV(relX, 1 - relY, 1)
                Preview.BackgroundColor3 = currentColor

                if cCfg.Flag then Rayfield.Flags[cCfg.Flag] = currentColor end
                if cCfg.Callback then cCfg.Callback(currentColor) end
            end

            Palette.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateColorFromInput(inp)
                end
            end)

            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateColorFromInput(inp)
                end
            end)

            toggleBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                Tween(f, {0.2, Enum.EasingStyle.Quad}, {
                    Size = expanded and UDim2.new(1, -6, 0, 135) or UDim2.new(1, -6, 0, 28)
                })
            end)

            if cCfg.Flag then Rayfield.Flags[cCfg.Flag] = currentColor end
        end

        TabObj.Btn = TabBtn
        TabObj.Page = Page
        table.insert(Window.Tabs, TabObj)
        return TabObj
    end

    return Window
end

return Rayfield
