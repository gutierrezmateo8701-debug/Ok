--[[
    Rayfield UI Framework - Edición Compacta / Ofuscación Suave
--]]

local _0x1 = game:GetService("TweenService")
local _0x2 = game:GetService("UserInputService")
local _0x3 = game:GetService("CoreGui")
local _0x4 = game:GetService("Players")

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
    Ac = Color3.fromRGB(80, 70, 230),
    Tx = Color3.fromRGB(240, 240, 240),
    St = Color3.fromRGB(140, 140, 150)
}

local Rayfield = { Flags = {} }

local _0xP = (gethui and gethui()) or (syn and syn.protect_gui and _0x3) or _0x4.LocalPlayer:WaitForChild(_0xS({80,108,97,121,101,114,71,117,105}))

local _0xSG = Instance.new(_0xS({83,99,114,101,101,110,71,117,105}))
_0xSG.Name = _0xS({82,97,121,102,105,101,108,100,67,111,109,112,97,99,116})
_0xSG.ResetOnSpawn = false
_0xSG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_0xSG.Parent = _0xP

-- Botón Flotante "UI" a la Izquierda
local _0xUIBtn = Instance.new(_0xS({84,101,120,116,66,117,116,116,111,110}))
_0xUIBtn.Name = _0xS({84,111,103,103,108,101,85,73,66,116,110})
_0xUIBtn.Size = UDim2.new(0, 38, 0, 38)
_0xUIBtn.Position = UDim2.new(0, 8, 0.5, -19)
_0xUIBtn.BackgroundColor3 = _0xT.El
_0xUIBtn.Text = _0xS({85,73})
_0xUIBtn.Font = Enum.Font.GothamBold
_0xUIBtn.TextSize = 13
_0xUIBtn.TextColor3 = _0xT.Tx
_0xUIBtn.ZIndex = 999
_0xUIBtn.Parent = _0xSG

Instance.new(_0xS({85,73,67,111,114,110,101,114}), _0xUIBtn).CornerRadius = UDim.new(0, 8)
local _0xUIBStroke = Instance.new(_0xS({85,73,83,116,114,111,107,101}), _0xUIBtn)
_0xUIBStroke.Color = _0xT.Ac
_0xUIBStroke.Thickness = 1.5

-- Contenedor de Notificaciones
local _0xNH = Instance.new(_0xS({70,114,97,109,101}))
_0xNH.Size = UDim2.new(0, 240, 1, -20)
_0xNH.Position = UDim2.new(1, -250, 0, 10)
_0xNH.BackgroundTransparency = 1
_0xNH.ZIndex = 1000
_0xNH.Parent = _0xSG

local _0xNL = Instance.new(_0xS({85,73,76,105,115,116,76,97,121,111,117,116}), _0xNH)
_0xNL.SortOrder = Enum.SortOrder.LayoutOrder
_0xNL.VerticalAlignment = Enum.VerticalAlignment.Bottom
_0xNL.Padding = UDim.new(0, 6)

local function _0xTW(obj, info, prop)
    local t = _0x1:Create(obj, TweenInfo.new(unpack(info)), prop)
    t:Play()
    return t
end

local function _0xDR(gui, handle)
    local d, di, ds, sp
    handle = handle or gui
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true; ds = inp.Position; sp = gui.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then d = false end end)
        end
    end)
    handle.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement then di = inp end end)
    _0x2.InputChanged:Connect(function(inp)
        if inp == di and d then
            local delta = inp.Position - ds
            gui.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end
    end)
end

function Rayfield:Notify(cfg)
    cfg = cfg or {}
    local frm = Instance.new("Frame", _0xNH)
    frm.Size = UDim2.new(1, 0, 0, 50)
    frm.BackgroundColor3 = _0xT.El
    frm.BackgroundTransparency = 1
    Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 6)
    
    local stk = Instance.new("UIStroke", frm)
    stk.Color = _0xT.Br
    stk.Transparency = 1
    
    local tlbl = Instance.new("TextLabel", frm)
    tlbl.Text = cfg.Title or _0xS({78,111,116,105,102,121})
    tlbl.Font = Enum.Font.GothamBold; tlbl.TextSize = 12; tlbl.TextColor3 = _0xT.Tx
    tlbl.Position = UDim2.new(0, 10, 0, 6); tlbl.Size = UDim2.new(1, -20, 0, 14)
    tlbl.BackgroundTransparency = 1; tlbl.TextXAlignment = Enum.TextXAlignment.Left; tlbl.TextTransparency = 1

    local clbl = Instance.new("TextLabel", frm)
    clbl.Text = cfg.Content or ""
    clbl.Font = Enum.Font.Gotham; clbl.TextSize = 11; clbl.TextColor3 = _0xT.St
    clbl.Position = UDim2.new(0, 10, 0, 22); clbl.Size = UDim2.new(1, -20, 0, 22)
    clbl.BackgroundTransparency = 1; clbl.TextXAlignment = Enum.TextXAlignment.Left; clbl.TextTransparency = 1; clbl.TextWrapped = true

    _0xTW(frm, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0})
    _0xTW(stk, {0.2, Enum.EasingStyle.Quad}, {Transparency = 0})
    _0xTW(tlbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 0})
    _0xTW(clbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 0})

    task.delay(cfg.Duration or 4, function()
        local t = _0xTW(frm, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
        _0xTW(stk, {0.2, Enum.EasingStyle.Quad}, {Transparency = 1})
        _0xTW(tlbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        _0xTW(clbl, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        t.Completed:Connect(function() frm:Destroy() end)
    end)
end

function Rayfield:Destroy()
    _0xSG:Destroy()
end

function Rayfield:CreateWindow(cfg)
    cfg = cfg or {}
    local vis = true

    -- Ventana Chica (450x280)
    local MF = Instance.new("Frame", _0xSG)
    MF.Name = _0xS({77,97,105,110,70,114,97,109,101})
    MF.Size = UDim2.new(0, 450, 0, 280)
    MF.Position = UDim2.new(0.5, -225, 0.5, -140)
    MF.BackgroundColor3 = _0xT.Bg
    MF.BorderSizePixel = 0
    Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 8)
    
    local MStk = Instance.new("UIStroke", MF)
    MStk.Color = _0xT.Br

    -- Barra Superior
    local TB = Instance.new("Frame", MF)
    TB.Size = UDim2.new(1, 0, 0, 32)
    TB.BackgroundTransparency = 1
    _0xDR(MF, TB)

    local TL = Instance.new("TextLabel", TB)
    TL.Text = cfg.Name or _0xS({82,97,121,102,105,101,108,100,32,76,105,116,101})
    TL.Font = Enum.Font.GothamBold; TL.TextSize = 13; TL.TextColor3 = _0xT.Tx
    TL.Position = UDim2.new(0, 10, 0, 0); TL.Size = UDim2.new(1, -20, 1, 0)
    TL.BackgroundTransparency = 1; TL.TextXAlignment = Enum.TextXAlignment.Left

    -- Conexión Botón UI
    _0xUIBtn.MouseButton1Click:Connect(function()
        vis = not vis
        MF.Visible = vis
    end)

    -- Panel Lateral
    local SB = Instance.new("Frame", MF)
    SB.Size = UDim2.new(0, 120, 1, -38)
    SB.Position = UDim2.new(0, 5, 0, 33)
    SB.BackgroundColor3 = _0xT.Sb
    Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 6)

    local TC = Instance.new("ScrollingFrame", SB)
    TC.Size = UDim2.new(1, -6, 1, -6); TC.Position = UDim2.new(0, 3, 0, 3)
    TC.BackgroundTransparency = 1; TC.ScrollBarThickness = 0
    local TCL = Instance.new("UIListLayout", TC)
    TCL.SortOrder = Enum.SortOrder.LayoutOrder; TCL.Padding = UDim.new(0, 3)

    -- Panel de Páginas
    local PF = Instance.new("Frame", MF)
    PF.Size = UDim2.new(1, -138, 1, -40); PF.Position = UDim2.new(0, 132, 0, 35)
    PF.BackgroundTransparency = 1

    local Window = { Tabs = {} }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TC)
        TabBtn.Size = UDim2.new(1, 0, 0, 26)
        TabBtn.BackgroundColor3 = _0xT.El; TabBtn.BackgroundTransparency = 1
        TabBtn.Text = " " .. name; TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11; TabBtn.TextColor3 = _0xT.St; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("ScrollingFrame", PF)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1
        Page.Visible = false; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = _0xT.Br
        
        local PL = Instance.new("UIListLayout", Page)
        PL.SortOrder = Enum.SortOrder.LayoutOrder; PL.Padding = UDim.new(0, 4)
        PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 6)
        end)

        local TabObj = {}

        local function Select()
            for _, t in pairs(Window.Tabs) do
                _0xTW(t.Btn, {0.15, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1, TextColor3 = _0xT.St})
                t.Page.Visible = false
            end
            _0xTW(TabBtn, {0.15, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0, TextColor3 = _0xT.Tx})
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if #Window.Tabs == 0 then Select() end

        -- Componentes
        function TabObj:CreateSection(secName)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 18); f.BackgroundTransparency = 1
            local l = Instance.new("TextLabel", f)
            l.Text = string.upper(secName); l.Font = Enum.Font.GothamBold; l.TextSize = 9
            l.TextColor3 = _0xT.St; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabObj:CreateLabel(txt)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 22); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
            local l = Instance.new("TextLabel", f)
            l.Text = txt; l.Font = Enum.Font.Gotham; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Size = UDim2.new(1, -12, 1, 0); l.Position = UDim2.new(0, 6, 0, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabObj:CreateParagraph(pCfg)
            pCfg = pCfg or {}
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 42); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
            local t = Instance.new("TextLabel", f)
            t.Text = pCfg.Title or ""; t.Font = Enum.Font.GothamBold; t.TextSize = 10; t.TextColor3 = _0xT.Tx
            t.Position = UDim2.new(0, 6, 0, 4); t.Size = UDim2.new(1, -12, 0, 12); t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left
            local c = Instance.new("TextLabel", f)
            c.Text = pCfg.Content or ""; c.Font = Enum.Font.Gotham; c.TextSize = 9; c.TextColor3 = _0xT.St
            c.Position = UDim2.new(0, 6, 0, 18); c.Size = UDim2.new(1, -12, 0, 20); c.BackgroundTransparency = 1; c.TextXAlignment = Enum.TextXAlignment.Left; c.TextWrapped = true
        end

        function TabObj:CreateButton(bCfg)
            bCfg = bCfg or {}
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
            local btn = Instance.new("TextButton", f)
            btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = bCfg.Name or "Button"
            btn.Font = Enum.Font.GothamMedium; btn.TextSize = 10; btn.TextColor3 = _0xT.Tx
            btn.MouseButton1Down:Connect(function() _0xTW(f, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = _0xT.Ac}) end)
            btn.MouseButton1Up:Connect(function()
                _0xTW(f, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = _0xT.El})
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
            sw.BackgroundColor3 = st and _0xT.Ac or _0xT.Br
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
                _0xTW(sw, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = st and _0xT.Ac or _0xT.Br})
                _0xTW(kn, {0.15, Enum.EasingStyle.Quad}, {Position = st and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)})
                if tCfg.Callback then tCfg.Callback(st) end
            end

            btn.MouseButton1Click:Connect(function() Update(not st) end)
            if tCfg.Flag then Rayfield.Flags[tCfg.Flag] = st end
            return { Set = Update }
        end

        function TabObj:CreateSlider(sCfg)
            sCfg = sCfg or {}
            local min, max = sCfg.Range and sCfg.Range[1] or 0, sCfg.Range and sCfg.Range[2] or 100
            local val = sCfg.CurrentValue or min
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 36); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new("TextLabel", f)
            l.Text = sCfg.Name or "Slider"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 4); l.Size = UDim2.new(0.5, 0, 0, 12); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

            local vl = Instance.new("TextLabel", f)
            vl.Text = tostring(val); vl.Font = Enum.Font.GothamBold; vl.TextSize = 10; vl.TextColor3 = _0xT.St
            vl.Position = UDim2.new(0.5, 0, 0, 4); vl.Size = UDim2.new(0.5, -8, 0, 12); vl.BackgroundTransparency = 1; vl.TextXAlignment = Enum.TextXAlignment.Right

            local trk = Instance.new("Frame", f)
            trk.Size = UDim2.new(1, -16, 0, 4); trk.Position = UDim2.new(0, 8, 0, 22); trk.BackgroundColor3 = _0xT.Br
            Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

            local fill = Instance.new("Frame", trk)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = _0xT.Ac
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            local drag = false
            local function Upd(inp)
                local pos = math.clamp((inp.Position.X - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * pos)
                vl.Text = tostring(val)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                if sCfg.Flag then Rayfield.Flags[sCfg.Flag] = val end
                if sCfg.Callback then sCfg.Callback(val) end
            end

            trk.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; Upd(i) end end)
            _0x2.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
            _0x2.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then Upd(i) end end)
            if sCfg.Flag then Rayfield.Flags[sCfg.Flag] = val end
        end

        function TabObj:CreateDropdown(dCfg)
            dCfg = dCfg or {}
            local opts = dCfg.Options or {}
            local sel = dCfg.CurrentOption or opts[1] or ""
            local exp = false

            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El; f.ClipsDescendants = true
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new("TextLabel", f)
            l.Text = (dCfg.Name or "Dropdown") .. ": " .. tostring(sel)
            l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(1, -16, 0, 26); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", f)
            btn.Size = UDim2.new(1, 0, 0, 26); btn.BackgroundTransparency = 1; btn.Text = ""

            local cnt = Instance.new("Frame", f)
            cnt.Position = UDim2.new(0, 0, 0, 26); cnt.Size = UDim2.new(1, 0, 0, #opts * 20); cnt.BackgroundTransparency = 1
            Instance.new("UIListLayout", cnt)

            btn.MouseButton1Click:Connect(function()
                exp = not exp
                _0xTW(f, {0.15, Enum.EasingStyle.Quad}, {Size = exp and UDim2.new(1, -6, 0, 26 + (#opts * 20)) or UDim2.new(1, -6, 0, 26)})
            end)

            for _, o in ipairs(opts) do
                local ob = Instance.new("TextButton", cnt)
                ob.Size = UDim2.new(1, 0, 0, 20); ob.BackgroundTransparency = 1; ob.Text = "  " .. tostring(o)
                ob.Font = Enum.Font.Gotham; ob.TextSize = 9; ob.TextColor3 = _0xT.St; ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.MouseButton1Click:Connect(function()
                    sel = o; l.Text = (dCfg.Name or "Dropdown") .. ": " .. tostring(sel); exp = false
                    _0xTW(f, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -6, 0, 26)})
                    if dCfg.Flag then Rayfield.Flags[dCfg.Flag] = sel end
                    if dCfg.Callback then dCfg.Callback(sel) end
                end)
            end
            if dCfg.Flag then Rayfield.Flags[dCfg.Flag] = sel end
        end

        function TabObj:CreateInput(iCfg)
            iCfg = iCfg or {}
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new("TextLabel", f)
            l.Text = iCfg.Name or "Input"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.5, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

            local tb = Instance.new("TextBox", f)
            tb.Text = iCfg.PlaceholderText or "..."; tb.Font = Enum.Font.Gotham; tb.TextSize = 9; tb.TextColor3 = _0xT.St
            tb.Position = UDim2.new(0.5, 0, 0.15, 0); tb.Size = UDim2.new(0.5, -6, 0.7, 0); tb.BackgroundColor3 = _0xT.Br
            Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 3)

            tb.FocusLost:Connect(function(enter)
                if enter and iCfg.Callback then iCfg.Callback(tb.Text) end
            end)
        end

        function TabObj:CreateKeybind(kCfg)
            kCfg = kCfg or {}
            local key = kCfg.CurrentKeybind or "None"
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new("TextLabel", f)
            l.Text = kCfg.Name or "Keybind"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.6, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

            local kb = Instance.new("TextButton", f)
            kb.Text = key; kb.Font = Enum.Font.GothamBold; kb.TextSize = 9; kb.TextColor3 = _0xT.Tx
            kb.Position = UDim2.new(1, -64, 0.15, 0); kb.Size = UDim2.new(0, 58, 0.7, 0); kb.BackgroundColor3 = _0xT.Br
            Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 3)

            local listening = false
            kb.MouseButton1Click:Connect(function()
                listening = true; kb.Text = "..."
            end)

            _0x2.InputBegan:Connect(function(inp, gpe)
                if gpe then return end
                if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                    key = inp.KeyCode.Name; kb.Text = key; listening = false
                    if kCfg.Callback then kCfg.Callback(key) end
                elseif not listening and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode.Name == key then
                    if kCfg.Callback then kCfg.Callback(key) end
                end
            end)
        end

        function TabObj:CreateColorpicker(cCfg)
            cCfg = cCfg or {}
            local col = cCfg.Color or Color3.fromRGB(255, 255, 255)
            local f = Instance.new("Frame", Page)
            f.Size = UDim2.new(1, -6, 0, 26); f.BackgroundColor3 = _0xT.El
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new("TextLabel", f)
            l.Text = cCfg.Name or "Colorpicker"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10; l.TextColor3 = _0xT.Tx
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.7, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("Frame", f)
            box.Size = UDim2.new(0, 20, 0, 14); box.Position = UDim2.new(1, -28, 0.5, -7)
            box.BackgroundColor3 = col
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

            if cCfg.Flag then Rayfield.Flags[cCfg.Flag] = col end
        end

        TabObj.Btn = TabBtn
        TabObj.Page = Page
        table.insert(Window.Tabs, TabObj)
        return TabObj
    end

    return Window
end

return Rayfield
