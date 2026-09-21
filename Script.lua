--// M4teoUI | Script.lua
--// Soft Obfuscation Edition

local _0xM = {}

local _0xS = game:GetService("TweenService")
local _0xU = game:GetService("UserInputService")
local _0xC = game:GetService("CoreGui")

local _0xT = {
    BG = Color3.fromRGB(35,35,35),
    TOP = Color3.fromRGB(42,42,42),
    TAB = Color3.fromRGB(39,39,39),
    EL = Color3.fromRGB(47,47,47),
    EH = Color3.fromRGB(55,55,55),
    TX = Color3.fromRGB(235,235,235),
    ST = Color3.fromRGB(165,165,165),
    AC = Color3.fromRGB(125,125,125),
    BD = Color3.fromRGB(62,62,62)
}

local _0xG
local _0xW
local _0xP
local _0xB
local _0xTabs = {}
local _0xCons = {}
local _0xVisible = true

local function _0xCnn(s,f)
    local c = s:Connect(f)
    table.insert(_0xCons,c)
    return c
end

local function _0xNew(c,p)
    local o = Instance.new(c)

    for k,v in pairs(p or {}) do
        o[k] = v
    end

    return o
end

local function _0xRound(o,r)
    local c = _0xNew("UICorner",{
        CornerRadius = UDim.new(0,r or 6)
    })
    c.Parent = o
    return c
end

local function _0xStroke(o,col,th)
    local s = _0xNew("UIStroke",{
        Color = col or _0xT.BD,
        Thickness = th or 1,
        Transparency = 0
    })
    s.Parent = o
    return s
end

local function _0xTween(o,t,p)
    return _0xS:Create(
        o,
        TweenInfo.new(
            t or .2,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        p
    )
end

local function _0xButtonEffect(btn,normal,hover)
    _0xCnn(btn.MouseEnter,function()
        _0xTween(btn,.15,{BackgroundColor3=hover}):Play()
    end)

    _0xCnn(btn.MouseLeave,function()
        _0xTween(btn,.15,{BackgroundColor3=normal}):Play()
    end)
end

local function _0xDrag(frame,handle)
    local dragging = false
    local dragStart
    local startPos

    _0xCnn(handle.InputBegan,function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    _0xCnn(_0xU.InputChanged,function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// Notification
function _0xM:Notify(data)
    if not _0xG then return end

    data = data or {}

    local title = data.Title or "M4teoUI"
    local text = data.Content or ""
    local duration = data.Duration or 3

    local n = _0xNew("Frame",{
        Parent = _0xG,
        Size = UDim2.new(0,250,0,68),
        Position = UDim2.new(1,-265,1,80),
        BackgroundColor3 = _0xT.EL,
        BorderSizePixel = 0
    })

    _0xRound(n,7)
    _0xStroke(n,_0xT.BD)

    _0xNew("TextLabel",{
        Parent=n,
        BackgroundTransparency=1,
        Position=UDim2.new(0,12,0,8),
        Size=UDim2.new(1,-24,0,20),
        Font=Enum.Font.GothamSemibold,
        Text=title,
        TextSize=14,
        TextColor3=_0xT.TX,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    _0xNew("TextLabel",{
        Parent=n,
        BackgroundTransparency=1,
        Position=UDim2.new(0,12,0,30),
        Size=UDim2.new(1,-24,0,28),
        Font=Enum.Font.Gotham,
        Text=text,
        TextSize=12,
        TextColor3=_0xT.ST,
        TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    _0xTween(n,.25,{
        Position=UDim2.new(1,-265,1,-85)
    }):Play()

    task.delay(duration,function()
        if n and n.Parent then
            local tw = _0xTween(n,.25,{
                Position=UDim2.new(1,-265,1,80)
            })

            tw:Play()
            tw.Completed:Wait()

            if n then
                n:Destroy()
            end
        end
    end)
end

function _0xM:SetVisibility(state)
    _0xVisible = state

    if _0xW then
        _0xW.Visible = state
    end
end

function _0xM:IsVisible()
    return _0xVisible
end

function _0xM:Destroy()
    for _,c in ipairs(_0xCons) do
        pcall(function()
            c:Disconnect()
        end)
    end

    table.clear(_0xCons)

    if _0xG then
        _0xG:Destroy()
        _0xG = nil
    end
end

function _0xM:CreateWindow(cfg)

    cfg = cfg or {}

    local name = cfg.Name or "M4teoUI"
    local subtitle = cfg.Subtitle or ""

    --// GUI
    _0xG = _0xNew("ScreenGui",{
        Name = "M4teoUI_" .. tostring(math.random(1000,9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    pcall(function()
        _0xG.Parent = _0xC
    end)

    if not _0xG.Parent then
        _0xG.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    --// Main window
    _0xW = _0xNew("Frame",{
        Parent = _0xG,
        Size = UDim2.new(0,500,0,330),
        Position = UDim2.new(.5,-250,.5,-165),
        BackgroundColor3 = _0xT.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })

    _0xRound(_0xW,8)
    _0xStroke(_0xW,_0xT.BD)

    --// Topbar
    local top = _0xNew("Frame",{
        Parent=_0xW,
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=_0xT.TOP,
        BorderSizePixel=0
    })

    _0xRound(top,8)

    local title = _0xNew("TextLabel",{
        Parent=top,
        BackgroundTransparency=1,
        Position=UDim2.new(0,14,0,5),
        Size=UDim2.new(1,-100,0,21),
        Font=Enum.Font.GothamSemibold,
        Text=name,
        TextSize=15,
        TextColor3=_0xT.TX,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    _0xNew("TextLabel",{
        Parent=top,
        BackgroundTransparency=1,
        Position=UDim2.new(0,14,0,26),
        Size=UDim2.new(1,-100,0,17),
        Font=Enum.Font.Gotham,
        Text=subtitle,
        TextSize=10,
        TextColor3=_0xT.ST,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    --// Minimize
    local min = _0xNew("TextButton",{
        Parent=top,
        BackgroundTransparency=1,
        Position=UDim2.new(1,-65,0,0),
        Size=UDim2.new(0,32,0,42),
        Font=Enum.Font.GothamBold,
        Text="—",
        TextSize=18,
        TextColor3=_0xT.TX,
        AutoButtonColor=false
    })

    --// Close
    local close = _0xNew("TextButton",{
        Parent=top,
        BackgroundTransparency=1,
        Position=UDim2.new(1,-34,0,0),
        Size=UDim2.new(0,32,0,42),
        Font=Enum.Font.Gotham,
        Text="×",
        TextSize=19,
        TextColor3=_0xT.TX,
        AutoButtonColor=false
    })

    _0xCnn(min.MouseButton1Click,function()
        _0xW.Visible=false
        _0xVisible=false
    end)

    _0xCnn(close.MouseButton1Click,function()
        _0xM:Destroy()
    end)

    _0xDrag(_0xW,top)

    --// Tab bar
    _0xB = _0xNew("ScrollingFrame",{
        Parent=_0xW,
        Position=UDim2.new(0,0,0,48),
        Size=UDim2.new(1,0,0,38),
        BackgroundColor3=_0xT.TAB,
        BorderSizePixel=0,
        ScrollBarThickness=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.X,
        ScrollingDirection=Enum.ScrollingDirection.X
    })

    local tabLayout = _0xNew("UIListLayout",{
        Parent=_0xB,
        FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,3),
        VerticalAlignment=Enum.VerticalAlignment.Center
    })

    _0xNew("UIPadding",{
        Parent=_0xB,
        PaddingLeft=UDim.new(0,8),
        PaddingRight=UDim.new(0,8)
    })

    --// Content
    _0xP = _0xNew("Frame",{
        Parent=_0xW,
        Position=UDim2.new(0,0,0,86),
        Size=UDim2.new(1,0,1,-86),
        BackgroundColor3=_0xT.BG,
        BorderSizePixel=0
    })

    local WindowAPI = {}

    function WindowAPI:CreateTab(tabName)

        local tabButton = _0xNew("TextButton",{
            Parent=_0xB,
            Size=UDim2.new(0,90,0,30),
            BackgroundColor3=_0xT.TAB,
            BorderSizePixel=0,
            Font=Enum.Font.GothamMedium,
            Text=tabName or "Tab",
            TextSize=12,
            TextColor3=_0xT.ST,
            AutoButtonColor=false
        })

        _0xRound(tabButton,5)

        local page = _0xNew("ScrollingFrame",{
            Parent=_0xP,
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ScrollBarThickness=3,
            ScrollBarImageColor3=_0xT.AC,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            Visible=false
        })

        local layout = _0xNew("UIListLayout",{
            Parent=page,
            Padding=UDim.new(0,7),
            SortOrder=Enum.SortOrder.LayoutOrder
        })

        _0xNew("UIPadding",{
            Parent=page,
            PaddingTop=UDim.new(0,10),
            PaddingBottom=UDim.new(0,10),
            PaddingLeft=UDim.new(0,12),
            PaddingRight=UDim.new(0,12)
        })

        local TabAPI = {}

        local function show()
            for _,v in ipairs(_0xTabs) do
                v.Page.Visible=false
                v.Button.BackgroundColor3=_0xT.TAB
                v.Button.TextColor3=_0xT.ST
            end

            page.Visible=true
            tabButton.BackgroundColor3=_0xT.EL
            tabButton.TextColor3=_0xT.TX
        end

        table.insert(_0xTabs,{
            Button=tabButton,
            Page=page
        })

        _0xCnn(tabButton.MouseButton1Click,show)

        if #_0xTabs == 1 then
            show()
        end

        function TabAPI:CreateSection(text)

            local section = _0xNew("TextLabel",{
                Parent=page,
                Size=UDim2.new(1,0,0,25),
                BackgroundTransparency=1,
                Font=Enum.Font.GothamSemibold,
                Text=text or "Section",
                TextSize=13,
                TextColor3=_0xT.TX,
                TextXAlignment=Enum.TextXAlignment.Left
            })

            return section
        end

        function TabAPI:CreateLabel(text)

            local label = _0xNew("TextLabel",{
                Parent=page,
                Size=UDim2.new(1,0,0,30),
                BackgroundTransparency=1,
                Font=Enum.Font.Gotham,
                Text=text or "",
                TextSize=12,
                TextColor3=_0xT.ST,
                TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Left
            })

            return label
        end

        function TabAPI:CreateButton(data)

            data=data or {}

            local button = _0xNew("TextButton",{
                Parent=page,
                Size=UDim2.new(1,0,0,38),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0,
                Font=Enum.Font.GothamMedium,
                Text=data.Name or "Button",
                TextSize=12,
                TextColor3=_0xT.TX,
                AutoButtonColor=false
            })

            _0xRound(button,6)
            _0xStroke(button,_0xT.BD)

            _0xButtonEffect(button,_0xT.EL,_0xT.EH)

            _0xCnn(button.MouseButton1Click,function()
                if typeof(data.Callback)=="function" then
                    task.spawn(data.Callback)
                end
            end)

            return button
        end

        function TabAPI:CreateToggle(data)

            data=data or {}

            local state = data.CurrentValue or false

            local button = _0xNew("TextButton",{
                Parent=page,
                Size=UDim2.new(1,0,0,38),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0,
                Font=Enum.Font.GothamMedium,
                Text=data.Name or "Toggle",
                TextSize=12,
                TextColor3=_0xT.TX,
                AutoButtonColor=false,
                TextXAlignment=Enum.TextXAlignment.Left
            })

            _0xRound(button,6)
            _0xStroke(button,_0xT.BD)

            local indicator = _0xNew("Frame",{
                Parent=button,
                Position=UDim2.new(1,-38,.5,-8),
                Size=UDim2.new(0,28,0,16),
                BackgroundColor3=_0xT.BD,
                BorderSizePixel=0
            })

            _0xRound(indicator,8)

            local dot = _0xNew("Frame",{
                Parent=indicator,
                Position=UDim2.new(0,2,.5,-6),
                Size=UDim2.new(0,12,0,12),
                BackgroundColor3=_0xT.ST,
                BorderSizePixel=0
            })

            _0xRound(dot,8)

            local function update()
                if state then
                    _0xTween(indicator,.15,{
                        BackgroundColor3=_0xT.AC
                    }):Play()

                    _0xTween(dot,.15,{
                        Position=UDim2.new(1,-14,.5,-6),
                        BackgroundColor3=_0xT.TX
                    }):Play()
                else
                    _0xTween(indicator,.15,{
                        BackgroundColor3=_0xT.BD
                    }):Play()

                    _0xTween(dot,.15,{
                        Position=UDim2.new(0,2,.5,-6),
                        BackgroundColor3=_0xT.ST
                    }):Play()
                end
            end

            update()

            _0xCnn(button.MouseButton1Click,function()
                state=not state
                update()

                if typeof(data.Callback)=="function" then
                    task.spawn(data.Callback,state)
                end
            end)

            return {
                Set=function(_,value)
                    state=value
                    update()

                    if typeof(data.Callback)=="function" then
                        task.spawn(data.Callback,state)
                    end
                end,

                Get=function()
                    return state
                end
            }
        end

        function TabAPI:CreateSlider(data)

            data=data or {}

            local min=data.Range and data.Range[1] or 0
            local max=data.Range and data.Range[2] or 100
            local value=data.CurrentValue or min
            local increment=data.Increment or 1

            local holder=_0xNew("Frame",{
                Parent=page,
                Size=UDim2.new(1,0,0,55),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0
            })

            _0xRound(holder,6)
            _0xStroke(holder,_0xT.BD)

            _0xNew("TextLabel",{
                Parent=holder,
                BackgroundTransparency=1,
                Position=UDim2.new(0,10,0,5),
                Size=UDim2.new(1,-80,0,20),
                Font=Enum.Font.GothamMedium,
                Text=data.Name or "Slider",
                TextSize=12,
                TextColor3=_0xT.TX,
                TextXAlignment=Enum.TextXAlignment.Left
            })

            local valueLabel=_0xNew("TextLabel",{
                Parent=holder,
                BackgroundTransparency=1,
                Position=UDim2.new(1,-65,0,5),
                Size=UDim2.new(0,55,0,20),
                Font=Enum.Font.Gotham,
                Text=tostring(value),
                TextSize=11,
                TextColor3=_0xT.ST,
                TextXAlignment=Enum.TextXAlignment.Right
            })

            local bar=_0xNew("Frame",{
                Parent=holder,
                Position=UDim2.new(0,10,0,35),
                Size=UDim2.new(1,-20,0,5),
                BackgroundColor3=_0xT.BD,
                BorderSizePixel=0
            })

            _0xRound(bar,5)

            local fill=_0xNew("Frame",{
                Parent=bar,
                Size=UDim2.new(0,0,1,0),
                BackgroundColor3=_0xT.AC,
                BorderSizePixel=0
            })

            _0xRound(fill,5)

            local function setValue(v)
                v=math.clamp(v,min,max)

                v=math.floor(
                    ((v-min)/increment)+.5
                )*increment+min

                value=v

                local percent=(value-min)/(max-min)

                fill.Size=UDim2.new(percent,0,1,0)
                valueLabel.Text=tostring(value)

                if typeof(data.Callback)=="function" then
                    task.spawn(data.Callback,value)
                end
            end

            setValue(value)

            local dragging=false

            _0xCnn(bar.InputBegan,function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1
                or input.UserInputType==Enum.UserInputType.Touch then

                    dragging=true

                    local percent=math.clamp(
                        (input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,
                        0,1
                    )

                    setValue(min+(max-min)*percent)
                end
            end)

            _0xCnn(_0xU.InputChanged,function(input)
                if not dragging then return end

                if input.UserInputType==Enum.UserInputType.MouseMovement
                or input.UserInputType==Enum.UserInputType.Touch then

                    local percent=math.clamp(
                        (input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,
                        0,1
                    )

                    setValue(min+(max-min)*percent)
                end
            end)

            _0xCnn(_0xU.InputEnded,function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1
                or input.UserInputType==Enum.UserInputType.Touch then
                    dragging=false
                end
            end)

            return {
                Set=function(_,v)
                    setValue(v)
                end,

                Get=function()
                    return value
                end
            }
        end

        function TabAPI:CreateDropdown(data)

            data=data or {}

            local options=data.Options or {}
            local selected=data.CurrentOption or options[1] or "Select"

            local holder=_0xNew("Frame",{
                Parent=page,
                Size=UDim2.new(1,0,0,38),
                BackgroundTransparency=1
            })

            local button=_0xNew("TextButton",{
                Parent=holder,
                Size=UDim2.new(1,0,1,0),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0,
                Font=Enum.Font.GothamMedium,
                Text=(data.Name or "Dropdown").." : "..tostring(selected),
                TextSize=12,
                TextColor3=_0xT.TX,
                AutoButtonColor=false,
                TextXAlignment=Enum.TextXAlignment.Left
            })

            _0xRound(button,6)
            _0xStroke(button,_0xT.BD)

            local pad=_0xNew("UIPadding",{
                Parent=button,
                PaddingLeft=UDim.new(0,10)
            })

            local list=_0xNew("ScrollingFrame",{
                Parent=holder,
                Position=UDim2.new(0,0,1,4),
                Size=UDim2.new(1,0,0,0),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0,
                ScrollBarThickness=3,
                ScrollBarImageColor3=_0xT.AC,
                CanvasSize=UDim2.new(0,0,0,0),
                AutomaticCanvasSize=Enum.AutomaticSize.Y,
                Visible=false,
                ZIndex=20
            })

            _0xRound(list,6)
            _0xStroke(list,_0xT.BD)

            local ll=_0xNew("UIListLayout",{
                Parent=list,
                Padding=UDim.new(0,2)
            })

            local lp=_0xNew("UIPadding",{
                Parent=list,
                PaddingTop=UDim.new(0,4),
                PaddingBottom=UDim.new(0,4),
                PaddingLeft=UDim.new(0,4),
                PaddingRight=UDim.new(0,4)
            })

            local opened=false

            for _,option in ipairs(options) do

                local opt=_0xNew("TextButton",{
                    Parent=list,
                    Size=UDim2.new(1,-8,0,30),
                    BackgroundColor3=_0xT.TAB,
                    BorderSizePixel=0,
                    Font=Enum.Font.Gotham,
                    Text=tostring(option),
                    TextSize=11,
                    TextColor3=_0xT.TX,
                    AutoButtonColor=false,
                    ZIndex=21
                })

                _0xRound(opt,5)

                _0xButtonEffect(
                    opt,
                    _0xT.TAB,
                    _0xT.EH
                )

                _0xCnn(opt.MouseButton1Click,function()
                    selected=option
                    button.Text=(data.Name or "Dropdown").." : "..tostring(option)

                    opened=false
                    list.Visible=false
                    list.Size=UDim2.new(1,0,0,0)

                    if typeof(data.Callback)=="function" then
                        task.spawn(data.Callback,option)
                    end
                end)
            end

            _0xCnn(button.MouseButton1Click,function()
                opened=not opened

                if opened then
                    list.Visible=true
                    list.Size=UDim2.new(1,0,0,math.min(150,35+(#options*32)))
                else
                    list.Visible=false
                    list.Size=UDim2.new(1,0,0,0)
                end
            end)

            return {
                Set=function(_,v)
                    selected=v
                    button.Text=(data.Name or "Dropdown").." : "..tostring(v)
                end,

                Get=function()
                    return selected
                end
            }
        end

        function TabAPI:CreateInput(data)

            data=data or {}

            local box=_0xNew("TextBox",{
                Parent=page,
                Size=UDim2.new(1,0,0,38),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0,
                Font=Enum.Font.Gotham,
                PlaceholderText=data.PlaceholderText or "Type here...",
                Text="",
                TextSize=12,
                TextColor3=_0xT.TX,
                PlaceholderColor3=_0xT.ST,
                ClearTextOnFocus=false
            })

            _0xRound(box,6)
            _0xStroke(box,_0xT.BD)

            _0xNew("UIPadding",{
                Parent=box,
                PaddingLeft=UDim.new(0,10),
                PaddingRight=UDim.new(0,10)
            })

            _0xCnn(box.FocusLost,function()
                if typeof(data.Callback)=="function" then
                    task.spawn(data.Callback,box.Text)
                end
            end)

            return box
        end

        function TabAPI:CreateKeybind(data)

            data=data or {}

            local current=data.CurrentKeybind or "RightShift"

            local button=_0xNew("TextButton",{
                Parent=page,
                Size=UDim2.new(1,0,0,38),
                BackgroundColor3=_0xT.EL,
                BorderSizePixel=0,
                Font=Enum.Font.GothamMedium,
                Text=(data.Name or "Keybind").." : "..tostring(current),
                TextSize=12,
                TextColor3=_0xT.TX,
                AutoButtonColor=false
            })

            _0xRound(button,6)
            _0xStroke(button,_0xT.BD)

            local listening=false

            _0xCnn(button.MouseButton1Click,function()
                listening=true
                button.Text=(data.Name or "Keybind").." : Press key..."
            end)

            _0xCnn(_0xU.InputBegan,function(input,gp)
                if gp then return end

                if listening and input.UserInputType==Enum.UserInputType.Keyboard then
                    current=input.KeyCode.Name
                    listening=false

                    button.Text=(data.Name or "Keybind").." : "..current

                    if typeof(data.Callback)=="function" then
                        task.spawn(data.Callback,input.KeyCode)
                    end
                end
            end)

            return button
        end

        return TabAPI
    end

    function WindowAPI:Destroy()
        _0xM:Destroy()
    end

    return WindowAPI
end

_0xM.Flags = {}
_0xM.Options = {}

return _0xM
