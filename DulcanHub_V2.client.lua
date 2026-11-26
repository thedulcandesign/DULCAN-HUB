-- DULCAN HUB V2 | LocalScript | standalone UI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("DulcanHub")
if old then old:Destroy() end

local C = {
    dark = Color3.fromRGB(12,12,17), purple = Color3.fromRGB(35,27,45),
    surface = Color3.fromRGB(44,42,52), border = Color3.fromRGB(100,94,110),
    accent = Color3.fromRGB(194,128,255), text = Color3.fromRGB(244,241,249),
    muted = Color3.fromRGB(154,148,169)
}
local function make(class, parent, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function frame(p, name, pos, size, color, transparency)
    return make("Frame", p, {Name=name, Position=pos, Size=size,
        BackgroundColor3=color or C.dark, BackgroundTransparency=transparency or 0,
        BorderSizePixel=0})
end
local function round(p,n)
    make("UICorner",p,{CornerRadius=UDim.new(0,n)})
end
local function stroke(p,t)
    make("UIStroke",p,{Color=C.border,Thickness=1,Transparency=t,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
end
local function label(p,txt,pos,size,px,color,font)
    return make("TextLabel",p,{BackgroundTransparency=1,Position=pos,Size=size,
        Text=txt,TextSize=px,TextColor3=color or C.text,Font=font or Enum.Font.GothamMedium,
        TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd})
end
local function tween(o,props,time)
    local t=TweenService:Create(o,TweenInfo.new(time or .18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props)
    t:Play(); return t
end
local connections={}
local function on(signal,fn)
    local c=signal:Connect(fn); table.insert(connections,c); return c
end
local gui=make("ScreenGui",pg,{Name="DulcanHub",ResetOnSpawn=false,IgnoreGuiInset=true,
    DisplayOrder=100,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local root=frame(gui,"Root",UDim2.fromOffset(0,0),UDim2.fromScale(1,1),C.dark,1)
local alive=true
on(gui.Destroying,function()
    alive=false
    for _,c in ipairs(connections) do c:Disconnect() end
end)

-- Original geometric D mark, built entirely from native UI.
local function logo(p,x,y,s)
    local f=frame(p,"Logo",UDim2.fromOffset(x,y),UDim2.fromOffset(s,s),C.dark,1)
    local d=label(f,"D",UDim2.fromScale(0,0),UDim2.fromScale(1,1),math.floor(s*.85),C.accent,Enum.Font.GothamBlack)
    d.TextXAlignment=Enum.TextXAlignment.Center
    make("UIGradient",d,{Color=ColorSequence.new(Color3.fromRGB(239,218,255),Color3.fromRGB(150,67,238)),Rotation=65})
    return f
end
local function button(p,name,txt,pos,size,hover)
    local b=make("TextButton",p,{Name=name,Position=pos,Size=size,Text=txt,
        Font=Enum.Font.GothamMedium,TextSize=18,TextColor3=C.muted,
        BackgroundColor3=hover or C.surface,BackgroundTransparency=1,
        AutoButtonColor=false,BorderSizePixel=0})
    round(b,5)
    b.MouseEnter:Connect(function() tween(b,{BackgroundTransparency=.25,TextColor3=C.text}) end)
    b.MouseLeave:Connect(function() tween(b,{BackgroundTransparency=1,TextColor3=C.muted}) end)
    return b
end

-- Main window: 720 x 470 logical pixels.
local w,h=720,470
local window=make("CanvasGroup",root,{Name="MainWindow",Size=UDim2.fromOffset(w,h),
    BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0,ClipsDescendants=true})
round(window,10)
local scale=make("UIScale",window,{Scale=1})
local bg=frame(window,"Glass",UDim2.fromOffset(0,0),UDim2.fromScale(1,1),Color3.new(1,1,1),.10)
round(bg,10); stroke(bg,.65)
make("UIGradient",bg,{Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.purple),ColorSequenceKeypoint.new(.5,Color3.fromRGB(24,22,30)),
    ColorSequenceKeypoint.new(1,C.dark)}),Rotation=90})
local header=frame(window,"Header",UDim2.fromOffset(0,0),UDim2.new(1,0,0,46),C.dark,1)
local drag=frame(header,"DragArea",UDim2.fromOffset(0,0),UDim2.new(1,-76,1,0),C.dark,1)
drag.Active=true
logo(drag,13,8,29)
local title=label(drag,'Dulcan <font color="#C280FF">Hub</font>',UDim2.fromOffset(51,6),UDim2.fromOffset(165,19),14,C.text,Enum.Font.GothamBold)
title.RichText=true
local subtitle=label(drag,"Universal Interface",UDim2.fromOffset(51,25),UDim2.fromOffset(165,13),10,C.muted)
local minimize=button(header,"Minimize","−",UDim2.new(1,-65,0,8),UDim2.fromOffset(28,28))
local close=button(header,"Close","×",UDim2.new(1,-34,0,8),UDim2.fromOffset(27,28),Color3.fromRGB(134,44,62))

local sidebar=frame(window,"Sidebar",UDim2.fromOffset(7,47),UDim2.new(0,176,1,-54),C.surface,.68)
round(sidebar,7); stroke(sidebar,.66)
local nav=frame(sidebar,"Navigation",UDim2.fromOffset(6,6),UDim2.new(1,-12,1,-59),C.dark,1)
make("UIListLayout",nav,{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder})
local content=frame(window,"Content",UDim2.fromOffset(190,47),UDim2.new(1,-197,1,-54),C.dark,1)
local profile=frame(sidebar,"Profile",UDim2.new(0,6,1,-47),UDim2.new(1,-12,0,41),C.dark,1)
local avatar=make("ImageLabel",profile,{Name="Avatar",Position=UDim2.fromOffset(3,4),Size=UDim2.fromOffset(31,31),
    BackgroundColor3=C.surface,BackgroundTransparency=.35,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop})
round(avatar,5); stroke(avatar,.65)
label(profile,player.DisplayName,UDim2.fromOffset(42,5),UDim2.new(1,-44,0,16),11,C.text,Enum.Font.GothamMedium)
label(profile,"@"..player.Name,UDim2.fromOffset(42,21),UDim2.new(1,-44,0,13),9,C.muted)

-- Compact independent status bar (actual measured values).
local bar=frame(root,"StatusBar",UDim2.new(1,-12,0,12),UDim2.fromOffset(470,35),C.purple,.10)
bar.AnchorPoint=Vector2.new(1,0); round(bar,7); stroke(bar,.55)
local barScale=make("UIScale",bar,{Scale=1})
make("UIGradient",bar,{Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(145,135,157)),Rotation=90})
logo(bar,8,5,23)
local fps=label(bar,"— FPS",UDim2.fromOffset(36,0),UDim2.fromOffset(59,35),11,C.text)
local ping=label(bar,"— ms",UDim2.fromOffset(102,0),UDim2.fromOffset(59,35),11,C.muted)
local function separator(x)
    frame(bar,"Separator",UDim2.fromOffset(x,8),UDim2.fromOffset(1,19),C.border,.65)
end
separator(95); separator(164); separator(282)
local smallAvatar=make("ImageLabel",bar,{Position=UDim2.fromOffset(172,9),Size=UDim2.fromOffset(17,17),
    BackgroundColor3=C.surface,BackgroundTransparency=.25,BorderSizePixel=0})
round(smallAvatar,4)
label(bar,"@"..player.Name,UDim2.fromOffset(195,0),UDim2.fromOffset(82,35),10,C.muted)
local experience=label(bar,game.Name,UDim2.fromOffset(291,0),UDim2.fromOffset(140,35),10,C.muted)
local eye=button(bar,"ToggleWindow","",UDim2.fromOffset(437,4),UDim2.fromOffset(27,27))
local eyeShape=frame(eye,"Eye",UDim2.fromOffset(5,8),UDim2.fromOffset(17,11),C.dark,1)
round(eyeShape,8); stroke(eyeShape,.05)
local pupil=frame(eyeShape,"Pupil",UDim2.fromOffset(6,3),UDim2.fromOffset(5,5),C.muted,0)
round(pupil,5)
local slash=frame(eye,"Hidden",UDim2.fromOffset(5,13),UDim2.fromOffset(17,1),C.accent,0)
slash.Rotation=-40; slash.Visible=false

task.spawn(function()
    local ok,url=pcall(function() return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    if alive and ok then avatar.Image=url; smallAvatar.Image=url end
end)
task.spawn(function()
    if game.PlaceId==0 then return end
    local ok,info=pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId,Enum.InfoType.Asset) end)
    if alive and ok and info.Name then experience.Text=info.Name end
end)

-- Layout, drag, resize and viewport bounds.
local positioned=false
local function layout()
    local v=root.AbsoluteSize
    if v.X<32 or v.Y<32 then return end
    scale.Scale=math.min(1,(v.X-24)/w,(v.Y-24)/h)
    barScale.Scale=math.min(1,(v.X-24)/470)
    window.Size=UDim2.fromOffset(w,h)
    local actual=Vector2.new(w,h)*scale.Scale
    local x,y=window.Position.X.Offset,window.Position.Y.Offset
    if not positioned then x=(v.X-actual.X)/2; y=(v.Y-actual.Y)/2; positioned=true end
    window.Position=UDim2.fromOffset(math.clamp(x,0,math.max(0,v.X-actual.X)),math.clamp(y,0,math.max(0,v.Y-actual.Y)))
end
on(root:GetPropertyChangedSignal("AbsoluteSize"),layout)
layout()
local grip=frame(window,"ResizeGrip",UDim2.new(1,-18,1,-18),UDim2.fromOffset(18,18),C.dark,1)
grip.Active=true
for i=1,3 do
    local line=frame(grip,"Line",UDim2.fromOffset(12-i*3,12),UDim2.fromOffset(i*4,1),C.muted,.25)
    line.Rotation=-45
end
local mode,startInput,startPoint,startPos,startSize,startScale
local function begin(input,kind)
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    if mode then return end
    mode=kind; startInput=input; startPoint=input.Position; startPos=window.Position
    startSize=Vector2.new(w,h); startScale=scale.Scale
end
on(drag.InputBegan,function(i) begin(i,"drag") end)
on(grip.InputBegan,function(i) begin(i,"resize") end)
on(UIS.InputChanged,function(i)
    if not mode then return end
    if startInput.UserInputType==Enum.UserInputType.Touch then
        if i~=startInput then return end
    elseif i.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local delta=i.Position-startPoint
    if mode=="drag" then
        window.Position=UDim2.fromOffset(startPos.X.Offset+delta.X,startPos.Y.Offset+delta.Y)
    else
        w=math.clamp(startSize.X+delta.X/startScale,480,1000)
        h=math.clamp(startSize.Y+delta.Y/startScale,300,700)
    end
    layout()
end)
on(UIS.InputEnded,function(i)
    if i==startInput then mode=nil; startInput=nil end
end)

-- Visibility and cleanup.
local open=true
local animation
local function setOpen(state)
    open=state; slash.Visible=not state
    if animation then animation:Cancel() end
    if state then window.Visible=true end
    animation=tween(window,{GroupTransparency=state and 0 or 1},.22)
    local current=animation
    current.Completed:Once(function(status)
        if alive and current==animation and status==Enum.PlaybackState.Completed and not open then window.Visible=false end
    end)
end
on(minimize.Activated,function() setOpen(false) end)
on(eye.Activated,function() setOpen(not open) end)
on(close.Activated,function() gui:Destroy() end)
on(UIS.InputBegan,function(i,processed)
    if not processed and not UIS:GetFocusedTextBox() and i.KeyCode==Enum.KeyCode.RightShift then setOpen(not open) end
end)
local frames,elapsed=0,0
on(RunService.RenderStepped,function(dt)
    frames+=1; elapsed+=dt
    if elapsed<.5 then return end
    fps.Text=string.format("%d FPS",math.floor(frames/elapsed+.5))
    frames,elapsed=0,0
    local ok,value=pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    ping.Text=ok and type(value)=="number" and string.format("%d ms",math.floor(value+.5)) or "— ms"
end)
setOpen(true)
