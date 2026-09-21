
local _P = game:GetService("Players")
local _I = game:GetService("UserInputService")
local _T = game:GetService("TweenService")
local _R = game:GetService("RunService")

local _L = _P.LocalPlayer
local _G = _L and _L:FindFirstChildOfClass("PlayerGui")

local function _n(class, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    return o
end

local function _c(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = o
    return c
end

local function _s(o, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(1,1,1)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = o
    return s
end

local function _p(o, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0,l or 0)
    p.PaddingRight = UDim.new(0,r or 0)
    p.PaddingTop = UDim.new(0,t or 0)
    p.PaddingBottom = UDim.new(0,b or 0)
    p.Parent = o
    return p
end

local function _t(o, time, props, style, dir)
    local ok, tw = pcall(function()
        return _T:Create(o, TweenInfo.new(time or .2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    end)
    if ok and tw then tw:Play() end
    return tw
end

local _th = {
    Dark = {Background=Color3.fromRGB(13,13,16), Secondary=Color3.fromRGB(18,18,22), Element=Color3.fromRGB(24,24,29), Hover=Color3.fromRGB(31,31,38), Border=Color3.fromRGB(48,48,58), Text=Color3.fromRGB(245,245,248), SubText=Color3.fromRGB(155,155,168), Accent=Color3.fromRGB(130,90,255)},
    Light = {Background=Color3.fromRGB(245,245,248), Secondary=Color3.fromRGB(235,235,240), Element=Color3.fromRGB(255,255,255), Hover=Color3.fromRGB(225,225,232), Border=Color3.fromRGB(205,205,214), Text=Color3.fromRGB(25,25,30), SubText=Color3.fromRGB(100,100,110), Accent=Color3.fromRGB(105,75,220)},
    Ocean = {Background=Color3.fromRGB(8,16,23), Secondary=Color3.fromRGB(10,24,33), Element=Color3.fromRGB(14,31,43), Hover=Color3.fromRGB(19,43,57), Border=Color3.fromRGB(29,67,84), Text=Color3.fromRGB(235,250,255), SubText=Color3.fromRGB(135,175,188), Accent=Color3.fromRGB(35,175,255)},
    Purple = {Background=Color3.fromRGB(18,10,27), Secondary=Color3.fromRGB(25,14,37), Element=Color3.fromRGB(34,20,48), Hover=Color3.fromRGB(45,27,62), Border=Color3.fromRGB(73,43,96), Text=Color3.fromRGB(248,238,255), SubText=Color3.fromRGB(174,145,190), Accent=Color3.fromRGB(190,80,255)},
    Red = {Background=Color3.fromRGB(25,10,10), Secondary=Color3.fromRGB(34,13,13), Element=Color3.fromRGB(44,18,18), Hover=Color3.fromRGB(58,22,22), Border=Color3.fromRGB(91,38,38), Text=Color3.fromRGB(255,240,240), SubText=Color3.fromRGB(190,145,145), Accent=Color3.fromRGB(255,70,70)},
    Green = {Background=Color3.fromRGB(9,20,13), Secondary=Color3.fromRGB(12,28,18), Element=Color3.fromRGB(18,38,24), Hover=Color3.fromRGB(25,51,32), Border=Color3.fromRGB(38,79,49), Text=Color3.fromRGB(237,255,242), SubText=Color3.fromRGB(142,181,151), Accent=Color3.fromRGB(55,220,110)},
}

local function _rgb(t)
    local h = (os.clock()*0.16)%1
    return Color3.fromHSV(h, .95, 1)
end

local M4teoUI = {
    Flags = {},
    _th = _th,
    Theme = _th.Dark,
    ThemeName = "Dark",
    Windows = {},
}

function M4teoUI:Notify(cfg)
    for _,w in ipairs(self.Windows) do
        if w.Notify then return w:Notify(cfg) end
    end
end

function M4teoUI:SetTheme(name)
    if self._th[name] then
        self.ThemeName = name
        self.Theme = self._th[name]
        for _,w in ipairs(self.Windows) do w:SetTheme(name) end
    end
    return self
end

function M4teoUI:CreateWindow(cfg)
    cfg = cfg or {}
    local theme = self._th[cfg.Theme or self.ThemeName] or self.Theme
    local window = {
        Library = self,
        Theme = theme,
        ThemeName = cfg.Theme or self.ThemeName,
        Tabs = {},
        Elements = {},
        Flags = self.Flags,
        Visible = true,
        Settings = {
            Size = cfg.Size or UDim2.fromOffset(520, 340),
            MinSize = cfg.MinSize or Vector2.new(350, 230),
            Animation = cfg.Animation ~= false,
            Sound = cfg.Sound ~= false,
            _mb = (type(cfg.MobileButton) == "table" and cfg.MobileButton.Enabled ~= false) or cfg.MobileButton ~= false,
            MobileButtonConfig = type(cfg.MobileButton) == "table" and cfg.MobileButton or {},
            LimitMobileButton = type(cfg.MobileButton) == "table" and cfg.MobileButton.LimitToScreen ~= false or cfg.LimitToScreen ~= false,
        }
    }

    local old = game:GetService("CoreGui"):FindFirstChild("M4teoUI")
    if old then old:Destroy() end
    local gui = _n("ScreenGui", {Name="M4teoUI", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=game:GetService("CoreGui")})
    window.Gui = gui

    local main = _n("Frame", {
        Name="Window", Size=window.Settings.Size, Position=UDim2.new(.5,0,.5,0), AnchorPoint=Vector2.new(.5,.5),
        BackgroundColor3=theme.Background, BorderSizePixel=0, Parent=gui
    })
    _c(main,12)
    local mainStroke = _s(main, theme.Border, 1)
    window._wf = main
    window.WindowStroke = mainStroke

    local scale = _n("UIScale", {Scale=1, Parent=main})
    window.Scale = scale
    if window.Settings.Animation then
        scale.Scale = .92
        _t(scale,.3,{Scale=1},Enum.EasingStyle.Back)
    end

    local header = _n("Frame", {Size=UDim2.new(1,0,0,52), BackgroundTransparency=1, Parent=main})
    window.Header = header
    local title = _n("TextLabel", {Size=UDim2.new(1,-120,0,25),Position=UDim2.fromOffset(16,7),BackgroundTransparency=1,Text=cfg.Title or cfg.Name or "M4teoUI",TextColor3=theme.Text,Font=Enum.Font.GothamBold,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,Parent=header})
    local subtitle = _n("TextLabel", {Size=UDim2.new(1,-120,0,18),Position=UDim2.fromOffset(16,29),BackgroundTransparency=1,Text=cfg.Subtitle or cfg.Author or cfg.Subtitle or cfg.Author or "",TextColor3=theme.SubText,Font=Enum.Font.Gotham,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,Parent=header})
    window.TitleLabel, window.SubtitleLabel = title, subtitle

    local min = _n("TextButton", {Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-73,0,10),BackgroundColor3=theme.Element,Text="—",TextColor3=theme.Text,Font=Enum.Font.GothamBold,TextSize=15,AutoButtonColor=false,Parent=header})
    local close = _n("TextButton", {Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-38,0,10),BackgroundColor3=theme.Element,Text="×",TextColor3=theme.Text,Font=Enum.Font.GothamBold,TextSize=17,AutoButtonColor=false,Parent=header})
    _c(min,8); _c(close,8)
    window.MinButton, window.CloseButton = min, close

    local sidebar = _n("Frame", {Size=UDim2.new(0,125,1,-62),Position=UDim2.fromOffset(8,54),BackgroundColor3=theme.Secondary,BorderSizePixel=0,Parent=main})
    _c(sidebar,9)
    local tabs = _n("ScrollingFrame", {Size=UDim2.new(1,-8,1,-8),Position=UDim2.fromOffset(4,4),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=theme.Accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Parent=sidebar})
    _p(tabs,2,2,2,2)
    _n("UIListLayout", {Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,Parent=tabs})
    window._sb, window.TabList = sidebar, tabs

    local content = _n("Frame", {Size=UDim2.new(1,-145,1,-62),Position=UDim2.fromOffset(137,54),BackgroundColor3=theme.Secondary,BorderSizePixel=0,Parent=main})
    _c(content,9)
    window._ct = content

    local function clickSound()
        if not window.Settings.Sound then return end
        local s=_n("Sound",{SoundId="rbxassetid://6026984224",Volume=.12,Parent=gui})
        s:Play(); game:GetService("Debris"):AddItem(s,2)
    end
    window._click=clickSound

    local dragging=false
    local dragStart,startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=main.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    _I.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dragStart
            main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)

    function window:SetVisibility(v, animate)
        v = v ~= false
        self.Visible=v
        if v then
            main.Visible=true
            if animate and self.Settings.Animation then scale.Scale=.94; _t(scale,.22,{Scale=1},Enum.EasingStyle.Back) end
        else
            if animate and self.Settings.Animation then
                _t(scale,.18,{Scale=.94})
                task.delay(.18,function() if not self.Visible then main.Visible=false end end)
            else main.Visible=false end
        end
        if self._mb then self._mb.Visible=not v end
    end

    min.MouseButton1Click:Connect(function() clickSound(); window:SetVisibility(false,true) end)
    close.MouseButton1Click:Connect(function() clickSound(); window:Destroy() end)

    if window.Settings._mb then
        local mbSize = window.Settings.MobileButtonConfig.Size or cfg.MobileButtonSize or 44
        local mbText = window.Settings.MobileButtonConfig.Text or cfg.MobileButtonText or "UI"
        local mb=_n("TextButton",{Name="UI",Size=UDim2.fromOffset(mbSize,mbSize),Position=UDim2.new(0,18,.5,-22),BackgroundColor3=Color3.fromRGB(0,0,0),Text=mbText,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=false,Visible=false,Parent=gui})
        _c(mb,math.floor(mbSize/2)); local ms=_s(mb,theme.Accent,2)
        window._mb,window.MobileStroke=mb,ms
        mb.MouseButton1Click:Connect(function() clickSound(); window:SetVisibility(true,true) end)
        local constrained=true
        local mdrag=false; local ms0,mp0
        mb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then mdrag=true;ms0=i.Position;mp0=mb.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then mdrag=false end end)end end)
        _I.InputChanged:Connect(function(i)
            if not mdrag or not (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then return end
            local d=i.Position-ms0; local p=mp0
            local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
            local sz=mb.AbsoluteSize; local x=p.X.Offset+d.X; local y=p.Y.Offset+d.Y
            if constrained then x=math.clamp(x,0,math.max(0,vp.X-sz.X)); y=math.clamp(y,0,math.max(0,vp.Y-sz.Y)) end
            mb.Position=UDim2.fromOffset(x,y)
        end)
        if window.Settings.MobileButtonConfig.Position then mb.Position=window.Settings.MobileButtonConfig.Position elseif cfg.MobileButtonPosition then mb.Position=cfg.MobileButtonPosition end
        window._rgbConnection = _R.RenderStepped:Connect(function() if window._mb and window._mb.Parent then window.MobileStroke.Color = _rgb() end end)
    end

    function window:Notify(n)
        n=n or {}; local holder=self._nh
        if not holder then
            holder=_n("Frame",{Size=UDim2.fromOffset(290,150),Position=UDim2.new(1,-12,1,-12),AnchorPoint=Vector2.new(1,1),BackgroundTransparency=1,Parent=gui})
            _n("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=UDim.new(0,7),Parent=holder})
            self._nh=holder
        end
        local card=_n("Frame",{Size=UDim2.fromOffset(260,66),BackgroundColor3=self.Theme.Element,BorderSizePixel=0,Parent=holder})
        _c(card,8); _s(card,self.Theme.Border,1)
        _n("TextLabel",{Size=UDim2.new(1,-18,0,20),Position=UDim2.fromOffset(9,6),BackgroundTransparency=1,Text=n.Title or "Notification",TextColor3=self.Theme.Text,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
        _n("TextLabel",{Size=UDim2.new(1,-18,0,32),Position=UDim2.fromOffset(9,27),BackgroundTransparency=1,Text=n.Content or n.Text or "",TextColor3=self.Theme.SubText,Font=Enum.Font.Gotham,TextSize=9,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
        local bar=_n("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=self.Theme.Accent,BorderSizePixel=0,Parent=card})
        card.Position=UDim2.new(1,25,0,0); _t(card,.22,{Position=UDim2.new(0,0,0,0)})
        task.delay(tonumber(n.Duration) or 3,function() if card.Parent then _t(card,.2,{Position=UDim2.new(1,25,0,0)}); task.wait(.2); card:Destroy() end end)
    end

    function window:SetTheme(name)
        local t=self.Library._th[name] or name
        if type(t)~="table" then return self end
        self.Theme=t; self.ThemeName=name
        main.BackgroundColor3=t.Background; mainStroke.Color=t.Border; sidebar.BackgroundColor3=t.Secondary; content.BackgroundColor3=t.Secondary
        title.TextColor3=t.Text; subtitle.TextColor3=t.SubText
        min.BackgroundColor3=t.Element; close.BackgroundColor3=t.Element; min.TextColor3=t.Text; close.TextColor3=t.Text
        tabs.ScrollBarImageColor3=t.Accent
        if self.MobileStroke then self.MobileStroke.Color=t.Accent end
        for _,e in ipairs(self.Elements) do if e._theme then pcall(e._theme,t) end end
        for _,tab in ipairs(self.Tabs) do if tab._theme then pcall(tab._theme,t) end end
        return self
    end

    function window:Destroy()
        if self._rgbConnection then self._rgbConnection:Disconnect(); self._rgbConnection=nil end
        if self.Gui then self.Gui:Destroy() end
        for i,w in ipairs(self.Library.Windows) do if w==self then table.remove(self.Library.Windows,i) break end end
    end

    function window:Tab(cfg2)
        cfg2=cfg2 or {}
        local tab={Window=self,Title=cfg2.Title or cfg2.Name or "Tab",Icon=cfg2.Icon,Elements={},Page=nil,Button=nil}
        local b=_n("TextButton",{Size=UDim2.new(1,-4,0,34),BackgroundColor3=self.Theme.Secondary,Text=(tab.Icon and ("  ") or "  ")..tab.Title,TextColor3=self.Theme.SubText,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,Parent=tabs})
        _c(b,7)
        local page=_n("ScrollingFrame",{Size=UDim2.new(1,-10,1,-10),Position=UDim2.fromOffset(5,5),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=self.Theme.Accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=content})
        _p(page,2,4,2,2); _n("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder,Parent=page})
        tab.Page,tab.Button=page,b
        function tab:Select()
            for _,x in ipairs(self.Window.Tabs) do x.Page.Visible=false; x.Button.BackgroundColor3=self.Window.Theme.Secondary; x.Button.TextColor3=self.Window.Theme.SubText end
            page.Visible=true; b.BackgroundColor3=self.Window.Theme.Accent; b.TextColor3=Color3.new(1,1,1)
        end
        b.MouseButton1Click:Connect(function() clickSound(); tab:Select() end)
        table.insert(self.Tabs,tab)
        if #self.Tabs==1 then tab:Select() end

        local function holder(h, height)
            local f=_n("Frame",{Size=UDim2.new(1,-4,0,height),BackgroundColor3=self.Theme.Element,BorderSizePixel=0,Parent=page}); _c(f,7); return f
        end
        local function addTheme(obj,fn) table.insert(self.Elements,{_theme=fn}); return obj end

        function tab:Section(text)
            local l=_n("TextLabel",{Size=UDim2.new(1,-4,0,22),BackgroundTransparency=1,Text=string.upper(text or "SECTION"),TextColor3=self.Window.Theme.SubText,Font=Enum.Font.GothamBold,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,Parent=page}); return l
        end
        function tab:Paragraph(cfg3)
            cfg3=cfg3 or {}; local f=holder(1,58); _n("TextLabel",{Size=UDim2.new(1,-18,0,20),Position=UDim2.fromOffset(9,6),BackgroundTransparency=1,Text=cfg3.Title or "Paragraph",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamBold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); _n("TextLabel",{Size=UDim2.new(1,-18,0,30),Position=UDim2.fromOffset(9,26),BackgroundTransparency=1,Text=cfg3.Text or cfg3.Content or "",TextColor3=self.Window.Theme.SubText,Font=Enum.Font.Gotham,TextSize=9,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); return f
        end
        function tab:Button(cfg3)
            cfg3=cfg3 or {}; local f=holder(1,38); local b2=_n("TextButton",{Size=UDim2.new(1,-10,1,-8),Position=UDim2.fromOffset(5,4),BackgroundColor3=self.Window.Theme.Hover,Text=cfg3.Title or cfg3.Name or "Button",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,AutoButtonColor=false,Parent=f}); _c(b2,6); b2.MouseButton1Click:Connect(function() clickSound(); if cfg3.Callback then task.spawn(cfg3.Callback) end end); addTheme(f,function(t)f.BackgroundColor3=t.Element;b2.BackgroundColor3=t.Hover;b2.TextColor3=t.Text end); return {Set=function(_,v)b2.Text=tostring(v)end} end
        function tab:Toggle(cfg3)
            cfg3=cfg3 or {}; local state=cfg3.Value; if state==nil then state=cfg3.CurrentValue or false end; if cfg3.Flag then self.Window.Flags[cfg3.Flag]=state end
            local f=holder(1,40); _n("TextLabel",{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Toggle",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local sw=_n("TextButton",{Size=UDim2.fromOffset(42,22),Position=UDim2.new(1,-52,.5,-11),BackgroundColor3=state and self.Window.Theme.Accent or self.Window.Theme.Hover,Text="",AutoButtonColor=false,Parent=f}); _c(sw,11); local knob=_n("Frame",{Size=UDim2.fromOffset(16,16),Position=state and UDim2.new(1,-19,.5,-8) or UDim2.fromOffset(3,3),BackgroundColor3=Color3.new(1,1,1),Parent=sw}); _c(knob,8)
            local function set(v,fire) state=v and true or false; if cfg3.Flag then self.Window.Flags[cfg3.Flag]=state end; _t(sw,.15,{BackgroundColor3=state and self.Window.Theme.Accent or self.Window.Theme.Hover}); _t(knob,.15,{Position=state and UDim2.new(1,-19,.5,-8) or UDim2.fromOffset(3,3)}); if fire and cfg3.Callback then task.spawn(cfg3.Callback,state) end end
            sw.MouseButton1Click:Connect(function() clickSound(); set(not state,true) end); addTheme(f,function(t)f.BackgroundColor3=t.Element;sw.BackgroundColor3=state and t.Accent or t.Hover end); return {Set=function(_,v)set(v,true)end,Get=function()return state end} 
        end
        function tab:Slider(cfg3)
            cfg3=cfg3 or {}; local range=cfg3.Range or {cfg3.Min or 0,cfg3.Max or 100}; local min,max=tonumber(range[1]) or 0,tonumber(range[2]) or 100; local inc=tonumber(cfg3.Step or cfg3.Increment) or 1; local val=tonumber(cfg3.Value or cfg3.Default or cfg3.CurrentValue) or min; local f=holder(1,55); local label=_n("TextLabel",{Size=UDim2.new(1,-70,0,20),Position=UDim2.fromOffset(9,5),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Slider",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); local vl=_n("TextLabel",{Size=UDim2.fromOffset(60,20),Position=UDim2.new(1,-68,0,5),BackgroundTransparency=1,Text="",TextColor3=self.Window.Theme.SubText,Font=Enum.Font.Gotham,TextSize=9,TextXAlignment=Enum.TextXAlignment.Right,Parent=f}); local bar=_n("Frame",{Size=UDim2.new(1,-18,0,5),Position=UDim2.fromOffset(9,37),BackgroundColor3=self.Window.Theme.Border,Parent=f}); _c(bar,4); local fill=_n("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=self.Window.Theme.Accent,Parent=bar}); _c(fill,4); local hit=_n("TextButton",{Size=UDim2.new(1,12,1,25),Position=UDim2.fromOffset(-6,-10),BackgroundTransparency=1,Text="",Parent=bar})
            local function set(v,fire) v=math.clamp(v,min,max);v=min+math.floor(((v-min)/inc)+.5)*inc;val=v;local p=max==min and 0 or (v-min)/(max-min);fill.Size=UDim2.new(p,0,1,0);vl.Text=tostring(v);if cfg3.Flag then self.Window.Flags[cfg3.Flag]=v end;if fire and cfg3.Callback then task.spawn(cfg3.Callback,v) end end
            local drag=false; local function update(x,fire)local p=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1);set(min+(max-min)*p,fire)end
            hit.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;clickSound();update(i.Position.X,true)end end);_I.InputChanged:Connect(function(i)if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then update(i.Position.X,true)end end);_I.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end);set(val,false);addTheme(f,function(t)f.BackgroundColor3=t.Element;bar.BackgroundColor3=t.Border;fill.BackgroundColor3=t.Accent;label.TextColor3=t.Text;vl.TextColor3=t.SubText end);return {Set=function(_,v)set(v,true)end,Get=function()return val end}
        end
        function tab:Dropdown(cfg3)
            cfg3=cfg3 or {}; local opts=cfg3.Values or cfg3.Options or {}; local cur=cfg3.Value or cfg3.Default or cfg3.CurrentOption or opts[1]; local open=false; local f=holder(1,42); _n("TextLabel",{Size=UDim2.new(1,-130,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Dropdown",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); local pick=_n("TextButton",{Size=UDim2.fromOffset(112,28),Position=UDim2.new(1,-122,.5,-14),BackgroundColor3=self.Window.Theme.Secondary,Text=tostring(cur or "Select"),TextColor3=self.Window.Theme.Text,Font=Enum.Font.Gotham,TextSize=9,AutoButtonColor=false,Parent=f});_c(pick,6)
            local list=_n("ScrollingFrame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,3),BackgroundColor3=self.Window.Theme.Element,BorderSizePixel=0,Visible=false,ScrollBarThickness=2,ScrollBarImageColor3=self.Window.Theme.Accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=30,Parent=f});_c(list,6);_n("UIListLayout",{Padding=UDim.new(0,2),Parent=list});_p(list,4,4,4,4)
            local function choose(v)cur=v;pick.Text=tostring(v);if cfg3.Flag then self.Window.Flags[cfg3.Flag]=v end;if cfg3.Callback then task.spawn(cfg3.Callback,v)end;open=false;list.Visible=false;list.Size=UDim2.new(1,0,0,0)end
            for _,v in ipairs(opts)do local ob=_n("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=self.Window.Theme.Secondary,Text=tostring(v),TextColor3=self.Window.Theme.Text,Font=Enum.Font.Gotham,TextSize=9,AutoButtonColor=false,ZIndex=31,Parent=list});_c(ob,5);ob.MouseButton1Click:Connect(function()clickSound();choose(v)end)end
            pick.MouseButton1Click:Connect(function()clickSound();open=not open;list.Visible=open;list.Size=open and UDim2.new(1,0,0,math.min(155,math.max(32,#opts*30+8))) or UDim2.new(1,0,0,0)end)
            addTheme(f,function(t)f.BackgroundColor3=t.Element;pick.BackgroundColor3=t.Secondary;pick.TextColor3=t.Text;list.BackgroundColor3=t.Element;list.ScrollBarImageColor3=t.Accent end);return {Set=function(_,v)choose(v)end,Get=function()return cur end}
        end
        function tab:MultiDropdown(cfg3)
            cfg3=cfg3 or {}; local opts=cfg3.Options or cfg3.Items or cfg3.ValuesList or {}; local selected=cfg3.ValuesSelected or cfg3.CurrentOptions or cfg3.Value or {}; local f=holder(1,42);local title=_n("TextLabel",{Size=UDim2.new(1,-130,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Multi Dropdown",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f});local pick=_n("TextButton",{Size=UDim2.fromOffset(112,28),Position=UDim2.new(1,-122,.5,-14),BackgroundColor3=self.Window.Theme.Secondary,Text="0 selected",TextColor3=self.Window.Theme.Text,Font=Enum.Font.Gotham,TextSize=9,AutoButtonColor=false,Parent=f});_c(pick,6);local open=false;local list=_n("ScrollingFrame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,3),BackgroundColor3=self.Window.Theme.Element,BorderSizePixel=0,Visible=false,ScrollBarThickness=2,ScrollBarImageColor3=self.Window.Theme.Accent,AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=30,Parent=f});_c(list,6);_n("UIListLayout",{Padding=UDim.new(0,2),Parent=list});_p(list,4,4,4,4);local buttons={};local function refresh(fire)local n=0;for k,v in pairs(selected)do if v then n+=1 end end;pick.Text=n==0 and "0 selected" or tostring(n).." selected";if cfg3.Callback and fire then task.spawn(cfg3.Callback,selected)end end
            for _,v in ipairs(opts)do local ob=_n("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=self.Window.Theme.Secondary,Text=tostring(v),TextColor3=self.Window.Theme.Text,Font=Enum.Font.Gotham,TextSize=9,AutoButtonColor=false,ZIndex=31,Parent=list});_c(ob,5);buttons[v]=ob;ob.MouseButton1Click:Connect(function()selected[v]=not selected[v];ob.BackgroundColor3=selected[v] and self.Window.Theme.Accent or self.Window.Theme.Secondary;refresh(true)end)end;pick.MouseButton1Click:Connect(function()open=not open;list.Visible=open;list.Size=open and UDim2.new(1,0,0,math.min(155,#opts*30+8)) or UDim2.new(1,0,0,0)end);refresh(false);return {Set=function(_,v)selected=v or {};refresh(true)end,Get=function()return selected end}
        end
        function tab:Input(cfg3)
            cfg3=cfg3 or {};local f=holder(1,42);_n("TextLabel",{Size=UDim2.new(1,-140,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Input",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f});local box=_n("TextBox",{Size=UDim2.fromOffset(120,28),Position=UDim2.new(1,-130,.5,-14),BackgroundColor3=self.Window.Theme.Secondary,Text=cfg3.Value or cfg3.CurrentValue or "",PlaceholderText=cfg3.Placeholder or cfg3.PlaceholderText or "Type...",TextColor3=self.Window.Theme.Text,PlaceholderColor3=self.Window.Theme.SubText,Font=Enum.Font.Gotham,TextSize=9,ClearTextOnFocus=false,Parent=f});_c(box,6);box.FocusLost:Connect(function()if cfg3.Callback then task.spawn(cfg3.Callback,box.Text)end end);return {Set=function(_,v)box.Text=tostring(v)end,Get=function()return box.Text end}
        end
        function tab:Keybind(cfg3)
            cfg3=cfg3 or {};local f=holder(1,42);_n("TextLabel",{Size=UDim2.new(1,-100,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Keybind",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f});local key=cfg3.Key or cfg3.CurrentKeybind or cfg3.CurrentKey or "RightShift";local b=_n("TextButton",{Size=UDim2.fromOffset(82,26),Position=UDim2.new(1,-92,.5,-13),BackgroundColor3=self.Window.Theme.Secondary,Text=tostring(key),TextColor3=self.Window.Theme.Text,Font=Enum.Font.Gotham,TextSize=9,AutoButtonColor=false,Parent=f});_c(b,6);local listening=false;b.MouseButton1Click:Connect(function()listening=true;b.Text="Press key" end);_I.InputBegan:Connect(function(i,gp)if listening and i.UserInputType==Enum.UserInputType.Keyboard then key=i.KeyCode.Name;listening=false;b.Text=key;if cfg3.Flag then self.Window.Flags[cfg3.Flag]=key end;if cfg3.Callback then task.spawn(cfg3.Callback,key)end elseif not gp and i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode.Name==key then if cfg3.Callback then task.spawn(cfg3.Callback,key)end end end);return {Set=function(_,v)key=tostring(v);b.Text=key end,Get=function()return key end}
        end
        function tab:Colorpicker(cfg3)
            cfg3=cfg3 or {};local color=cfg3.Color or cfg3.Value or Color3.fromRGB(130,90,255);local f=holder(1,42);_n("TextLabel",{Size=UDim2.new(1,-65,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=cfg3.Title or cfg3.Name or "Color",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=f});local preview=_n("TextButton",{Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-36,.5,-13),BackgroundColor3=color,Text="",AutoButtonColor=false,Parent=f});_c(preview,13);_s(preview,Color3.new(1,1,1),1,.35)
            local overlay
            local function close()if overlay then overlay:Destroy();overlay=nil end end
            local function openPicker()if overlay then close();return end;clickSound();overlay=_n("Frame",{Size=UDim2.fromOffset(220,245),Position=UDim2.new(.5,-110,.5,-122),BackgroundColor3=self.Window.Theme.Element,BorderSizePixel=0,ZIndex=100,Parent=gui});_c(overlay,10);_s(overlay,self.Window.Theme.Border,1)
                _n("TextLabel",{Size=UDim2.new(1,-20,0,25),Position=UDim2.fromOffset(10,7),BackgroundTransparency=1,Text="Color Picker",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamBold,TextSize=11,ZIndex=101,Parent=overlay})
                local sv=_n("ImageButton",{Size=UDim2.fromOffset(190,120),Position=UDim2.fromOffset(15,38),BackgroundColor3=Color3.new(1,0,0),Image="rbxassetid://4155801252",AutoButtonColor=false,ZIndex=101,Parent=overlay});_c(sv,6)
                local hue=_n("ImageButton",{Size=UDim2.fromOffset(190,16),Position=UDim2.fromOffset(15,164),BackgroundColor3=Color3.new(1,1,1),Image="rbxassetid://3641079629",AutoButtonColor=false,ZIndex=101,Parent=overlay});_c(hue,5)
                local inp=_n("TextBox",{Size=UDim2.fromOffset(190,30),Position=UDim2.fromOffset(15,187),BackgroundColor3=self.Window.Theme.Secondary,Text=string.format("%d, %d, %d",math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)),TextColor3=self.Window.Theme.Text,Font=Enum.Font.Gotham,TextSize=9,ClearTextOnFocus=false,ZIndex=101,Parent=overlay});_c(inp,6)
                local ok=_n("TextButton",{Size=UDim2.fromOffset(88,25),Position=UDim2.fromOffset(15,220),BackgroundColor3=self.Window.Theme.Accent,Text="Aceptar",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=9,AutoButtonColor=false,ZIndex=101,Parent=overlay});_c(ok,6);local cancel=_n("TextButton",{Size=UDim2.fromOffset(88,25),Position=UDim2.fromOffset(117,220),BackgroundColor3=self.Window.Theme.Hover,Text="Cancelar",TextColor3=self.Window.Theme.Text,Font=Enum.Font.GothamBold,TextSize=9,AutoButtonColor=false,ZIndex=101,Parent=overlay});_c(cancel,6)
                local function apply(c)color=c;preview.BackgroundColor3=c;if cfg3.Flag then self.Window.Flags[cfg3.Flag]=c end;if cfg3.Callback then task.spawn(cfg3.Callback,c)end end
                local h,s,v=color:ToHSV();local function fromSV(x,y)local nx=math.clamp((x-sv.AbsolutePosition.X)/sv.AbsoluteSize.X,0,1);local ny=math.clamp((y-sv.AbsolutePosition.Y)/sv.AbsoluteSize.Y,0,1);apply(Color3.fromHSV(h,nx,1-ny));inp.Text=string.format("%d, %d, %d",math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255))end
                sv.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fromSV(i.Position.X,i.Position.Y)end end);hue.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then h=math.clamp((i.Position.X-hue.AbsolutePosition.X)/hue.AbsoluteSize.X,0,1);local _,ss,vv=color:ToHSV();apply(Color3.fromHSV(h,ss,vv))end end);ok.MouseButton1Click:Connect(function()local r,g,b=inp.Text:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$");if r then apply(Color3.fromRGB(math.clamp(tonumber(r),0,255),math.clamp(tonumber(g),0,255),math.clamp(tonumber(b),0,255)))end;close()end);cancel.MouseButton1Click:Connect(close)
            end
            preview.MouseButton1Click:Connect(openPicker);return {Set=function(_,v)if typeof(v)=="Color3" then color=v;preview.BackgroundColor3=v end end,Get=function()return color end}
        end
        tab.ColorPicker=tab.Colorpicker; tab.ColorPicker=tab.Colorpicker
        tab.CreateSection=tab.Section;tab.CreateParagraph=tab.Paragraph;tab.CreateButton=tab.Button;tab.CreateToggle=tab.Toggle;tab.CreateSlider=tab.Slider;tab.CreateDropdown=tab.Dropdown;tab.CreateMultiDropdown=tab.MultiDropdown;tab.CreateInput=tab.Input;tab.CreateKeybind=tab.Keybind;tab.CreateColorPicker=tab.Colorpicker
        return tab
    end

    window.CreateTab=window.Tab
    table.insert(self.Windows,window)
    return window
end

M4teoUI.Create = M4teoUI.CreateWindow
M4teoUI.CreateWindow = M4teoUI.CreateWindow

return M4teoUI
