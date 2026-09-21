-- [[ Rayfield UI Engine - Light Obfuscated ]]
local _D = function(b)
    local s = {}
    for i = 1, #b do table.insert(s, string.char(b[i])) end
    return table.concat(s)
end

local _0x1 = game:GetService(_D({84, 119, 101, 101, 110, 83, 101, 114, 118, 105, 99, 101}))
local _0x2 = game:GetService(_D({85, 115, 101, 114, 73, 110, 112, 117, 116, 83, 101, 114, 118, 105, 99, 101}))
local _0x3 = game:GetService(_D({82, 117, 110, 83, 101, 114, 118, 105, 99, 101}))
local _0x4 = game:GetService(_D({67, 111, 114, 101, 71, 117, 105}))
local _0x5 = game:GetService(_D({80, 108, 97, 121, 101, 114, 115}))

local Rayfield = { 
    Flags = {},
    Themes = {
        Default = { Bg = Color3.fromRGB(18, 18, 20), Sb = Color3.fromRGB(13, 13, 15), El = Color3.fromRGB(25, 25, 28), Br = Color3.fromRGB(40, 40, 45), Tx = Color3.fromRGB(240, 240, 240), St = Color3.fromRGB(140, 140, 150) },
        Ocean = { Bg = Color3.fromRGB(14, 22, 32), Sb = Color3.fromRGB(10, 15, 22), El = Color3.fromRGB(20, 32, 46), Br = Color3.fromRGB(35, 55, 80), Tx = Color3.fromRGB(235, 245, 255), St = Color3.fromRGB(120, 160, 190) },
        Cyberpunk = { Bg = Color3.fromRGB(22, 14, 28), Sb = Color3.fromRGB(15, 9, 20), El = Color3.fromRGB(34, 20, 44), Br = Color3.fromRGB(65, 32, 85), Tx = Color3.fromRGB(255, 230, 255), St = Color3.fromRGB(180, 120, 200) },
        Emerald = { Bg = Color3.fromRGB(14, 24, 18), Sb = Color3.fromRGB(9, 16, 12), El = Color3.fromRGB(20, 36, 28), Br = Color3.fromRGB(32, 60, 45), Tx = Color3.fromRGB(230, 255, 240), St = Color3.fromRGB(120, 180, 145) },
        Midnight = { Bg = Color3.fromRGB(8, 8, 12), Sb = Color3.fromRGB(5, 5, 8), El = Color3.fromRGB(14, 14, 20), Br = Color3.fromRGB(28, 28, 40), Tx = Color3.fromRGB(220, 220, 235), St = Color3.fromRGB(100, 100, 125) },
        Light = { Bg = Color3.fromRGB(240, 240, 245), Sb = Color3.fromRGB(220, 220, 228), El = Color3.fromRGB(255, 255, 255), Br = Color3.fromRGB(200, 200, 215), Tx = Color3.fromRGB(25, 25, 30), St = Color3.fromRGB(110, 110, 120) }
    }
}

local _0x6 = Rayfield.Themes.Default
local _0x7 = {}

local function _0x8(o, p, k)
    table.insert(_0x7, { Object = o, Property = p, Key = k })
    o[p] = _0x6[k]
end

function Rayfield:SetTheme(n)
    if Rayfield.Themes[n] then
        _0x6 = Rayfield.Themes[n]
        for _, item in ipairs(_0x7) do
            if item.Object and item.Object.Parent then
                _0x1:Create(item.Object, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    [item.Property] = _0x6[item.Key]
                }):Play()
            end
        end
    end
end

local _0x9 = {}
_0x3.Heartbeat:Connect(function()
    local h = (tick() % 3) / 3
    local c = Color3.fromHSV(h, 0.9, 1)
    for o, p in pairs(_0x9) do
        if o and o.Parent then o[p] = c else _0x9[o] = nil end
    end
end)

local _0xA = (gethui and gethui()) or (syn and syn.protect_gui and _0x4) or _0x5.LocalPlayer:WaitForChild(_D({80,108,97,121,101,114,71,117,105}))

local _0xB = Instance.new(_D({83,99,114,101,101,110,71,117,105}))
_0xB.Name = _D({82,97,121,102,105,101,108,100,95,69,110,103,105,110,101})
_0xB.ResetOnSpawn = false
_0xB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_0xB.Parent = _0xA

local _0xC = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}))
_0xC.Name = _D({84,111,103,103,108,101,85,73})
_0xC.Size = UDim2.new(0, 42, 0, 42)
_0xC.Position = UDim2.new(0, 10, 0.5, -21)
_0xC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
_0xC.Text = _D({85,73})
_0xC.Font = Enum.Font.GothamBold
_0xC.TextSize = 14
_0xC.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xC.ZIndex = 9999
_0xC.Visible = false
_0xC.Parent = _0xB

Instance.new(_D({85,73,67,111,114,110,101,114}), _0xC).CornerRadius = UDim.new(0, 8)
local _0xD = Instance.new(_D({85,73,83,116,114,111,107,101}), _0xC)
_0xD.Thickness = 2
_0x9[_0xD] = _D({67,111,108,111,114})

_0xC.MouseEnter:Connect(function()
    _0x1:Create(_0xC, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, 8, 0.5, -23)}):Play()
end)
_0xC.MouseLeave:Connect(function()
    _0x1:Create(_0xC, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 10, 0.5, -21)}):Play()
end)

local _0xE = Instance.new(_D({70,114,97,109,101}), _0xB)
_0xE.Size = UDim2.new(0, 240, 1, -20)
_0xE.Position = UDim2.new(1, -250, 0, 10)
_0xE.BackgroundTransparency = 1
_0xE.ZIndex = 1000

local _0xF = Instance.new(_D({85,73,76,105,115,116,76,97,121,111,117,116}), _0xE)
_0xF.SortOrder = Enum.SortOrder.LayoutOrder
_0xF.VerticalAlignment = Enum.VerticalAlignment.Bottom
_0xF.Padding = UDim.new(0, 6)

local function _0x10(obj, inf, prp)
    local t = _0x1:Create(obj, TweenInfo.new(unpack(inf)), prp)
    t:Play()
    return t
end

local function _0x11(gui, hnd)
    local drg, inp, st, pos
    hnd = hnd or gui
    hnd.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drg = true; st = i.Position; pos = gui.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drg = false end end)
        end
    end)
    hnd.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then inp = i end
    end)
    _0x2.InputChanged:Connect(function(i)
        if i == inp and drg then
            local d = i.Position - st
            gui.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
end

function Rayfield:Notify(cfg)
    cfg = cfg or {}
    local f = Instance.new(_D({70,114,97,109,101}), _0xE)
    f.Size = UDim2.new(1, 0, 0, 48)
    f.BackgroundTransparency = 1
    _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
    Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 6)
    
    local s = Instance.new(_D({85,73,83,116,114,111,107,101}), f)
    s.Transparency = 1
    _0x8(s, _D({67,111,108,111,114}), "Br")
    
    local t = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f)
    t.Text = cfg.Title or _D({78,111,116,105,102,105,99,97,99,105,111,110})
    t.Font = Enum.Font.GothamBold; t.TextSize = 12
    t.Position = UDim2.new(0, 10, 0, 6); t.Size = UDim2.new(1, -20, 0, 14)
    t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left; t.TextTransparency = 1
    _0x8(t, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

    local c = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f)
    c.Text = cfg.Content or ""
    c.Font = Enum.Font.Gotham; c.TextSize = 11
    c.Position = UDim2.new(0, 10, 0, 22); c.Size = UDim2.new(1, -20, 0, 20)
    c.BackgroundTransparency = 1; c.TextXAlignment = Enum.TextXAlignment.Left; c.TextTransparency = 1; c.TextWrapped = true
    _0x8(c, _D({84,101,120,116,67,111,108,111,114,51}), "St")

    _0x10(f, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {BackgroundTransparency = 0})
    _0x10(s, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Transparency = 0})
    _0x10(t, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {TextTransparency = 0})
    _0x10(c, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {TextTransparency = 0})

    task.delay(cfg.Duration or 3, function()
        local tw = _0x10(f, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1})
        _0x10(s, {0.2, Enum.EasingStyle.Quad}, {Transparency = 1})
        _0x10(t, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        _0x10(c, {0.2, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        tw.Completed:Connect(function() f:Destroy() end)
    end)
end

function Rayfield:CreateWindow(cfg)
    cfg = cfg or {}
    local vis = true
    local tm = cfg.LoadingTime or 3

    if cfg.Theme and Rayfield.Themes[cfg.Theme] then _0x6 = Rayfield.Themes[cfg.Theme] end

    local M = Instance.new(_D({70,114,97,109,101}), _0xB)
    M.Name = _D({77,97,105,110,70,114,97,109,101})
    M.Size = UDim2.new(0, 460, 0, 290); M.Position = UDim2.new(0.5, -230, 0.5, -145)
    M.BorderSizePixel = 0; M.Visible = false
    _0x8(M, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Bg")
    Instance.new(_D({85,73,67,111,114,110,101,114}), M).CornerRadius = UDim.new(0, 8)
    
    local MS = Instance.new(_D({85,73,83,116,114,111,107,101}), M)
    _0x8(MS, _D({67,111,108,111,114}), "Br")

    local function Toggle(st)
        vis = st
        if vis then
            M.Visible = true; M.Size = UDim2.new(0, 420, 0, 260); M.Position = UDim2.new(0.5, -210, 0.5, -130)
            _0x10(M, {0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 460, 0, 290), Position = UDim2.new(0.5, -230, 0.5, -145)})
        else
            local tw = _0x10(M, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {Size = UDim2.new(0, 420, 0, 260), Position = UDim2.new(0.5, -210, 0.5, -130)})
            tw.Completed:Connect(function() if not vis then M.Visible = false end end)
        end
    end

    local LH = Instance.new(_D({70,114,97,109,101}), _0xB)
    LH.Size = UDim2.new(0, 300, 0, 60); LH.Position = UDim2.new(0.5, -150, 0.4, -30)
    LH.BackgroundTransparency = 1; LH.ZIndex = 10000

    local LT = Instance.new(_D({84,101,120,116,76,97,98,101,108}), LH)
    LT.Text = cfg.LoadingTitle or _D({76,111,97,100,105,110,103,46,46,46})
    LT.Font = Enum.Font.GothamBold; LT.TextSize = 26; LT.Size = UDim2.new(1, 0, 0, 30); LT.BackgroundTransparency = 1
    _0x9[LT] = _D({84,101,120,116,67,111,108,111,114,51})

    local LS = Instance.new(_D({84,101,120,116,76,97,98,101,108}), LH)
    LS.Text = cfg.LoadingSubtitle or ""
    LS.Font = Enum.Font.GothamMedium; LS.TextSize = 14; LS.Position = UDim2.new(0, 0, 0, 30); LS.Size = UDim2.new(1, 0, 0, 20); LS.BackgroundTransparency = 1
    _0x9[LS] = _D({84,101,120,116,67,111,108,111,114,51})

    task.spawn(function()
        task.wait(tm)
        _0x10(LT, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        _0x10(LS, {0.3, Enum.EasingStyle.Quad}, {TextTransparency = 1})
        task.wait(0.3)
        LH:Destroy()
        _0xC.Visible = true
        Toggle(true)
    end)

    local TB = Instance.new(_D({70,114,97,109,101}), M)
    TB.Size = UDim2.new(1, 0, 0, 32); TB.BackgroundTransparency = 1
    _0x11(M, TB)

    local TL = Instance.new(_D({84,101,120,116,76,97,98,101,108}), TB)
    TL.Text = cfg.Name or "Rayfield Interface"; TL.Font = Enum.Font.GothamBold; TL.TextSize = 13
    TL.Position = UDim2.new(0, 10, 0, 0); TL.Size = UDim2.new(1, -20, 1, 0); TL.BackgroundTransparency = 1; TL.TextXAlignment = Enum.TextXAlignment.Left
    _0x8(TL, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

    _0xC.MouseButton1Click:Connect(function() Toggle(not vis) end)

    local SB = Instance.new(_D({70,114,97,109,101}), M)
    SB.Size = UDim2.new(0, 120, 1, -38); SB.Position = UDim2.new(0, 5, 0, 33)
    _0x8(SB, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Sb")
    Instance.new(_D({85,73,67,111,114,110,101,114}), SB).CornerRadius = UDim.new(0, 6)

    local TC = Instance.new(_D({83,99,114,111,108,108,105,110,103,70,114,97,109,101}), SB)
    TC.Size = UDim2.new(1, -6, 1, -6); TC.Position = UDim2.new(0, 3, 0, 3); TC.BackgroundTransparency = 1; TC.ScrollBarThickness = 0
    local TList = Instance.new(_D({85,73,76,105,115,116,76,97,121,111,117,116}), TC)
    TList.SortOrder = Enum.SortOrder.LayoutOrder; TList.Padding = UDim.new(0, 3)

    local PF = Instance.new(_D({70,114,97,109,101}), M)
    PF.Size = UDim2.new(1, -138, 1, -40); PF.Position = UDim2.new(0, 132, 0, 35); PF.BackgroundTransparency = 1; PF.ClipsDescendants = true

    local Window = { Tabs = {} }

    function Window:CreateTab(name)
        local TabBtn = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), TC)
        TabBtn.Size = UDim2.new(1, 0, 0, 26); TabBtn.BackgroundTransparency = 1
        TabBtn.Text = " " .. name; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextSize = 11; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        _0x8(TabBtn, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
        _0x8(TabBtn, _D({84,101,120,116,67,111,108,111,114,51}), "St")
        Instance.new(_D({85,73,67,111,114,110,101,114}), TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new(_D({83,99,114,111,108,108,105,110,103,70,114,97,109,101}), PF)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
        _0x8(Page, _D({83,99,114,101,101,110,83,104,111,116,73,109,97,103,101,67,111,108,111,114,51}) or Page, "Br")
        
        local PList = Instance.new(_D({85,73,76,105,115,116,76,97,121,111,117,116}), Page)
        PList.SortOrder = Enum.SortOrder.LayoutOrder; PList.Padding = UDim.new(0, 4)
        PList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PList.AbsoluteContentSize.Y + 6)
        end)

        local TabObj = {}

        local function Select()
            for _, t in pairs(Window.Tabs) do
                _0x10(t.Btn, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 1, TextColor3 = _0x6.St})
                if t.Page.Visible then
                    local op = t.Page
                    _0x10(op, {0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {Position = UDim2.new(0, 10, 0, 0)})
                    task.delay(0.15, function() op.Visible = false; op.Position = UDim2.new(0, 0, 0, 0) end)
                end
            end

            _0x10(TabBtn, {0.2, Enum.EasingStyle.Quad}, {BackgroundTransparency = 0, TextColor3 = _0x6.Tx})
            task.delay(0.12, function()
                Page.Position = UDim2.new(0, -10, 0, 0); Page.Visible = true
                _0x10(Page, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})
            end)
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if #Window.Tabs == 0 then Select() end

        function TabObj:CreateSection(sn)
            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 18); f.BackgroundTransparency = 1
            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = string.upper(sn); l.Font = Enum.Font.GothamBold; l.TextSize = 9
            l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "St")
        end

        function TabObj:CreateLabel(txt)
            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 20); f.BackgroundTransparency = 1
            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = txt or ""; l.Font = Enum.Font.Gotham; l.TextSize = 10
            l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")
            return { Set = function(_, nt) l.Text = nt end }
        end

        function TabObj:CreateParagraph(pCfg)
            pCfg = pCfg or {}
            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 42)
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local t = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); t.Text = pCfg.Title or ""; t.Font = Enum.Font.GothamBold; t.TextSize = 10
            t.Position = UDim2.new(0, 8, 0, 4); t.Size = UDim2.new(1, -16, 0, 14); t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(t, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            local c = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); c.Text = pCfg.Content or ""; c.Font = Enum.Font.Gotham; c.TextSize = 9
            c.Position = UDim2.new(0, 8, 0, 18); c.Size = UDim2.new(1, -16, 0, 20); c.BackgroundTransparency = 1; c.TextXAlignment = Enum.TextXAlignment.Left; c.TextWrapped = true
            _0x8(c, _D({84,101,120,116,67,111,108,111,114,51}), "St")
            return { Set = function(_, nt, nc) if nt then t.Text = nt end if nc then c.Text = nc end end }
        end

        function TabObj:CreateButton(bCfg)
            bCfg = bCfg or {}
            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 26)
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)
            
            local btn = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = bCfg.Name or "Button"
            btn.Font = Enum.Font.GothamMedium; btn.TextSize = 10
            _0x8(btn, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            btn.MouseButton1Down:Connect(function() _0x10(f, {0.1, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -10, 0, 24)}) end)
            btn.MouseButton1Up:Connect(function()
                _0x10(f, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -6, 0, 26)})
                if bCfg.Callback then bCfg.Callback() end
            end)
        end

        function TabObj:CreateToggle(tCfg)
            tCfg = tCfg or {}
            local st = tCfg.CurrentValue or false
            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 26)
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = tCfg.Name or "Toggle"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.6, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")
            
            local sw = Instance.new(_D({70,114,97,109,101}), f); sw.Size = UDim2.new(0, 28, 0, 14); sw.Position = UDim2.new(1, -34, 0.5, -7)
            _0x8(sw, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Br")
            Instance.new(_D({85,73,67,111,114,110,101,114}), sw).CornerRadius = UDim.new(1, 0)

            local kn = Instance.new(_D({70,114,97,109,101}), sw); kn.Size = UDim2.new(0, 10, 0, 10); kn.Position = st and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
            kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new(_D({85,73,67,111,114,110,101,114}), kn).CornerRadius = UDim.new(1, 0)

            local btn = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""

            local function Update(val)
                st = val
                if tCfg.Flag then Rayfield.Flags[tCfg.Flag] = st end
                _0x10(sw, {0.2, Enum.EasingStyle.Quad}, {BackgroundColor3 = st and Color3.fromRGB(80, 70, 230) or _0x6.Br})
                _0x10(kn, {0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Position = st and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)})
                if tCfg.Callback then tCfg.Callback(st) end
            end

            btn.MouseButton1Click:Connect(function() Update(not st) end)
            if tCfg.Flag then Rayfield.Flags[tCfg.Flag] = st end
            return { Set = Update }
        end

        function TabObj:CreateSlider(sCfg)
            sCfg = sCfg or {}
            local min, max = (sCfg.Range and sCfg.Range[1]) or 0, (sCfg.Range and sCfg.Range[2]) or 100
            local val = math.clamp(sCfg.CurrentValue or min, min, max)

            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 36)
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = sCfg.Name or "Slider"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10
            l.Position = UDim2.new(0, 8, 0, 4); l.Size = UDim2.new(0.6, 0, 0, 14); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            local vl = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); vl.Text = tostring(val); vl.Font = Enum.Font.GothamBold; vl.TextSize = 10
            vl.Position = UDim2.new(1, -40, 0, 4); vl.Size = UDim2.new(0, 32, 0, 14); vl.BackgroundTransparency = 1; vl.TextXAlignment = Enum.TextXAlignment.Right
            _0x8(vl, _D({84,101,120,116,67,111,108,111,114,51}), "St")

            local bar = Instance.new(_D({70,114,97,109,101}), f); bar.Size = UDim2.new(1, -16, 0, 6); bar.Position = UDim2.new(0, 8, 0, 22)
            _0x8(bar, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Br")
            Instance.new(_D({85,73,67,111,114,110,101,114}), bar).CornerRadius = UDim.new(1, 0)

            local fill = Instance.new(_D({70,114,97,109,101}), bar)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(80, 70, 230)
            Instance.new(_D({85,73,67,111,114,110,101,114}), fill).CornerRadius = UDim.new(1, 0)

            local drg = false
            local function UpdateSlider(i)
                local rx = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * rx)
                _0x10(fill, {0.1, Enum.EasingStyle.Quad}, {Size = UDim2.new(rx, 0, 1, 0)})
                vl.Text = tostring(val)
                if sCfg.Flag then Rayfield.Flags[sCfg.Flag] = val end
                if sCfg.Callback then sCfg.Callback(val) end
            end

            local function IsV(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
            local function IsM(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

            f.InputBegan:Connect(function(i) if IsV(i) then drg = true; UpdateSlider(i) end end)
            _0x2.InputChanged:Connect(function(i) if drg and IsM(i) then UpdateSlider(i) end end)
            _0x2.InputEnded:Connect(function(i) if IsV(i) then drg = false end end)

            if sCfg.Flag then Rayfield.Flags[sCfg.Flag] = val end
            return { Set = function(_, nV) val = math.clamp(nV, min, max); fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0); vl.Text = tostring(val) end }
        end

        function TabObj:CreateDropdown(dCfg)
            dCfg = dCfg or {}
            local opts = dCfg.Options or {}
            local sel = dCfg.CurrentOption or opts[1] or "Ninguno"
            local exp = false

            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 28); f.ClipsDescendants = true
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = dCfg.Name or "Dropdown"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.5, 0, 0, 28); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            local sL = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); sL.Text = sel; sL.Font = Enum.Font.GothamBold; sL.TextSize = 10; sL.TextColor3 = Color3.fromRGB(80, 70, 230)
            sL.Position = UDim2.new(0.5, 0, 0, 0); sL.Size = UDim2.new(0.5, -10, 0, 28); sL.BackgroundTransparency = 1; sL.TextXAlignment = Enum.TextXAlignment.Right

            local tBtn = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), f); tBtn.Size = UDim2.new(1, 0, 0, 28); tBtn.BackgroundTransparency = 1; tBtn.Text = ""

            local cnt = Instance.new(_D({70,114,97,109,101}), f); cnt.Size = UDim2.new(1, -12, 0, #opts * 22); cnt.Position = UDim2.new(0, 6, 0, 30); cnt.BackgroundTransparency = 1
            local cL = Instance.new(_D({85,73,76,105,115,116,76,97,121,111,117,116}), cnt); cL.Padding = UDim.new(0, 2)

            for _, opt in ipairs(opts) do
                local ob = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), cnt); ob.Size = UDim2.new(1, 0, 0, 20); ob.Text = opt
                ob.Font = Enum.Font.Gotham; ob.TextSize = 9
                _0x8(ob, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Br")
                _0x8(ob, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")
                Instance.new(_D({85,73,67,111,114,110,101,114}), ob).CornerRadius = UDim.new(0, 3)

                ob.MouseButton1Click:Connect(function()
                    sel = opt; sL.Text = sel; exp = false
                    _0x10(f, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -6, 0, 28)})
                    if dCfg.Flag then Rayfield.Flags[dCfg.Flag] = sel end
                    if dCfg.Callback then dCfg.Callback(sel) end
                end)
            end

            tBtn.MouseButton1Click:Connect(function()
                exp = not exp
                _0x10(f, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Size = exp and UDim2.new(1, -6, 0, 34 + #opts * 22) or UDim2.new(1, -6, 0, 28)})
            end)

            if dCfg.Flag then Rayfield.Flags[dCfg.Flag] = sel end
        end

        function TabObj:CreateInput(iCfg)
            iCfg = iCfg or {}
            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 28)
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = iCfg.Name or "Input"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.5, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            local box = Instance.new(_D({84,101,120,116,66,111,120}), f)
            box.Size = UDim2.new(0.45, 0, 0, 20); box.Position = UDim2.new(0.52, 0, 0.5, -10)
            box.Text = ""; box.PlaceholderText = iCfg.PlaceholderText or "..."
            box.Font = Enum.Font.Gotham; box.TextSize = 9; box.ClearTextOnFocus = false
            _0x8(box, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Br")
            _0x8(box, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")
            Instance.new(_D({85,73,67,111,114,110,101,114}), box).CornerRadius = UDim.new(0, 3)

            box.FocusLost:Connect(function()
                if iCfg.Flag then Rayfield.Flags[iCfg.Flag] = box.Text end
                if iCfg.Callback then iCfg.Callback(box.Text) end
            end)
        end

        function TabObj:CreateKeybind(kCfg)
            kCfg = kCfg or {}
            local key = kCfg.CurrentKeybind or "E"
            local bnd = false

            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 28)
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = kCfg.Name or "Keybind"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.6, 0, 1, 0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            local btn = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), f)
            btn.Size = UDim2.new(0, 50, 0, 18); btn.Position = UDim2.new(1, -56, 0.5, -9)
            btn.Text = key; btn.Font = Enum.Font.GothamBold; btn.TextSize = 9
            _0x8(btn, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "Br")
            _0x8(btn, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")
            Instance.new(_D({85,73,67,111,114,110,101,114}), btn).CornerRadius = UDim.new(0, 3)

            btn.MouseButton1Click:Connect(function()
                bnd = true; btn.Text = "..."
                local c
                c = _0x2.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        key = i.KeyCode.Name; btn.Text = key; bnd = false
                        c:Disconnect()
                        if kCfg.Flag then Rayfield.Flags[kCfg.Flag] = key end
                    end
                end)
            end)

            _0x2.InputBegan:Connect(function(i, g)
                if not g and not bnd and i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode.Name == key then
                    if kCfg.Callback then kCfg.Callback(key) end
                end
            end)
        end

        function TabObj:CreateColorpicker(cCfg)
            cCfg = cCfg or {}
            local cur = cCfg.Color or Color3.fromRGB(255, 0, 0)
            local tmp = cur
            local exp = false

            local f = Instance.new(_D({70,114,97,109,101}), Page); f.Size = UDim2.new(1, -6, 0, 28); f.ClipsDescendants = true
            _0x8(f, _D({66,97,99,107,103,114,111,117,110,100,67,111,108,111,114,51}), "El")
            Instance.new(_D({85,73,67,111,114,110,101,114}), f).CornerRadius = UDim.new(0, 4)

            local l = Instance.new(_D({84,101,120,116,76,97,98,101,108}), f); l.Text = cCfg.Name or "Colorpicker"; l.Font = Enum.Font.GothamMedium; l.TextSize = 10
            l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.6, 0, 0, 28); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            _0x8(l, _D({84,101,120,116,67,111,108,111,114,51}), "Tx")

            local prv = Instance.new(_D({70,114,97,109,101}), f)
            prv.Size = UDim2.new(0, 24, 0, 14); prv.Position = UDim2.new(1, -32, 0, 7); prv.BackgroundColor3 = cur
            Instance.new(_D({85,73,67,111,114,110,101,114}), prv).CornerRadius = UDim.new(0, 3)

            local tBtn = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), f); tBtn.Size = UDim2.new(1, 0, 0, 28); tBtn.BackgroundTransparency = 1; tBtn.Text = ""

            local pCnt = Instance.new(_D({70,114,97,109,101}), f)
            pCnt.Size = UDim2.new(1, -16, 0, 122); pCnt.Position = UDim2.new(0, 8, 0, 32); pCnt.BackgroundTransparency = 1

            local plt = Instance.new(_D({70,114,97,109,101}), pCnt)
            plt.Size = UDim2.new(1, 0, 0, 90); plt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new(_D({85,73,67,111,114,110,101,114}), plt).CornerRadius = UDim.new(0, 4)

            local rG = Instance.new(_D({85,73,71,114,97,100,105,101,110,116}), plt)
            rG.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })

            local dO = Instance.new(_D({70,114,97,109,101}), plt)
            dO.Size = UDim2.new(1, 0, 1, 0); dO.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Instance.new(_D({85,73,67,111,114,110,101,114}), dO).CornerRadius = UDim.new(0, 4)

            local dG = Instance.new(_D({85,73,71,114,97,100,105,101,110,116}), dO)
            dG.Rotation = 90; dG.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })

            local knb = Instance.new(_D({70,114,97,109,101}), plt)
            knb.Size = UDim2.new(0, 14, 0, 14); knb.Position = UDim2.new(0.5, -7, 0.5, -7); knb.BackgroundColor3 = Color3.fromRGB(255, 255, 255); knb.ZIndex = 10
            Instance.new(_D({85,73,67,111,114,110,101,114}), knb).CornerRadius = UDim.new(1, 0)
            local ks = Instance.new(_D({85,73,83,116,114,111,107,101}), knb); ks.Color = Color3.fromRGB(0, 0, 0); ks.Thickness = 2

            local bF = Instance.new(_D({70,114,97,109,101}), pCnt); bF.Size = UDim2.new(1, 0, 0, 22); bF.Position = UDim2.new(0, 0, 0, 96); bF.BackgroundTransparency = 1

            local aB = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), bF)
            aB.Size = UDim2.new(0.48, 0, 1, 0); aB.BackgroundColor3 = Color3.fromRGB(45, 140, 60); aB.Text = "Aceptar"
            aB.Font = Enum.Font.GothamBold; aB.TextSize = 10; aB.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new(_D({85,73,67,111,114,110,101,114}), aB).CornerRadius = UDim.new(0, 4)

            local cB = Instance.new(_D({84,101,120,116,66,117,116,116,111,110}), bF)
            cB.Size = UDim2.new(0.48, 0, 1, 0); cB.Position = UDim2.new(0.52, 0, 0, 0); cB.BackgroundColor3 = Color3.fromRGB(160, 45, 45); cB.Text = "Cancelar"
            cB.Font = Enum.Font.GothamBold; cB.TextSize = 10; cB.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new(_D({85,73,67,111,114,110,101,114}), cB).CornerRadius = UDim.new(0, 4)

            local drg = false
            local function UpdColor(i)
                local rx = math.clamp((i.Position.X - plt.AbsolutePosition.X) / plt.AbsoluteSize.X, 0, 1)
                local ry = math.clamp((i.Position.Y - plt.AbsolutePosition.Y) / plt.AbsoluteSize.Y, 0, 1)
                knb.Position = UDim2.new(rx, -7, ry, -7)
                tmp = Color3.fromHSV(rx, 1, 1 - ry)
                prv.BackgroundColor3 = tmp
            end

            local function IsV(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
            local function IsM(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

            plt.InputBegan:Connect(function(i) if IsV(i) then drg = true; UpdColor(i) end end)
            _0x2.InputChanged:Connect(function(i) if drg and IsM(i) then UpdColor(i) end end)
            _0x2.InputEnded:Connect(function(i) if IsV(i) then drg = false end end)

            aB.MouseButton1Click:Connect(function()
                cur = tmp; prv.BackgroundColor3 = cur; exp = false
                _0x10(f, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -6, 0, 28)})
                if cCfg.Flag then Rayfield.Flags[cCfg.Flag] = cur end
                if cCfg.Callback then cCfg.Callback(cur) end
            end)

            cB.MouseButton1Click:Connect(function()
                tmp = cur; prv.BackgroundColor3 = cur; exp = false
                _0x10(f, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -6, 0, 28)})
            end)

            tBtn.MouseButton1Click:Connect(function()
                exp = not exp; if exp then tmp = cur end
                _0x10(f, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Size = exp and UDim2.new(1, -6, 0, 160) or UDim2.new(1, -6, 0, 28)})
            end)

            if cCfg.Flag then Rayfield.Flags[cCfg.Flag] = cur end
        end

        TabObj.Btn = TabBtn
        TabObj.Page = Page
        table.insert(Window.Tabs, TabObj)
        return TabObj
    end

    return Window
end

return Rayfield
