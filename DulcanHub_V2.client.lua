-- DULCAN HUB V2.4 | LocalScript | standalone UI
local VERSION = "2.4.0"
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
    dark = Color3.fromRGB(10,11,16), purple = Color3.fromRGB(30,26,40),
    surface = Color3.fromRGB(44,42,52), border = Color3.fromRGB(100,94,110),
    accent = Color3.fromRGB(200,143,255), text = Color3.fromRGB(247,245,250),
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

-- Transparent raster derived from the approved cinematic artwork.
-- Native UI strips: no remote image, file API, or asset permissions required.
local LOGO_ROWS = {
    "0",
    "0000000000000000000000G",
    "000000000000000000000N5JM",
    "00000000000000000000N9GJ5",
    "0000000000000000000065EJ4K",
    "0000000000MO00000005654454G00000000VO",
    "00000000000467CC000C115091C0000P79G4M",
    "0000000000005911000C1164917000719655",
    "00000000000055617CO9115F1119P711519M",
    "000000000000S449FJ5119559911966J59O",
    "00000000000004E0JJ454EDDJ459194E5500NM56O",
    "00000000000004J4J2D45GFF5556694E0S0M5GG566O",
    "0000000000000045559111111111119E47754696600M",
    "00000000M000006119966666IIFFF516516461",
    "000000006II322BBD2222222222222D619559N",
    "0000000006596322BBBBBBB222222222K99617",
    "000000000054916322222222222222222K6666P",
    "0000000000C6459111111119966F2222B2B91544SNF000022222220020000220200000022223000220000200022000EE000EES4EV00EES44444E",
    "0000000000015491188888111196632BBBDF115EJ6GFN08222222283230002382200002222230032230022BC02200GE4000E46E4M0VE46EEEEEEEM",
    "000000000M71641112222291111166FDBBBB91KD25GGPC32B888228228003233230002238880002223002228822O044500045645000456EG995E4N",
    "000000VV0691G511322223111111156FBBBD65D2D5KF9132811122822107228328000221117C7B2323732223823CM44G0044654600545GE4G54E5",
    "000000000S915119222225111111166IDBDD4JDJ46JK6922811823823171228BB1C082B117C73281231323BB3B80O44444446046CP446444E4447",
    "000000000619119F2222D5111111165K22D4KK5456DJ662B111823I28118B38B317782I1111822332B13B1333380544665446441164464499644V",
    "0000000G5195196D22D2J6111111944D2DFI616596JJ68B3F3F3B833388338833I38I3388813BB22B383318333PC545116456445554G64566544M",
    "00000455954516F2BB3D411111995EJ2K566116CN6KK93BB22BB31333333313BD2B88333338B31113B83311333CM4E611GE56E4444E6G44EEEEG",
    "0000455444J495D3333J61611990JDDKFIFF11C00PFF98333II81193333I11333II818I8I98317C783888118380MG46554G61GGGGG61GGGGGG6C",
    "00045544G99554D333BG1199544K44DDBFBF170000F5CC777777CC7111111111111111111117C00C1111177117CC11111177C77777CCC7777C",
    "00S5561191165K3FF3B9195556995DD333D61000000S000MMMOO7C711111111111181111811C0071811818181181811118CCCMMMVVV",
    "00656C0191164DFI33911191119IDB3332I1P000000S00665FG56118118111818118188181810C818811181881618181187765GKK4G5",
    "00N660001115J3I381I3B2222DBD333D2I19N0000000000CCCCCC0C77777777777777777777C00CC77777777777777777700CCNNNNN",
    "000OO0001114DFF88333B2223333BB2D595O",
    "0000O0000C6JDF88III3333333D222D9944",
    "00000000004DDB33333333BD22222K9165",
    "0000000000J2DDKFFIIIFFFFKKDD4999O",
    "00000000002D459111111111990E599N",
    "000000000JK59P77777777PPPPSSPC",
    "000000000K97",
    "0000000057",
    "0",
    "0"
}
local LOGO_PALETTE = {
    {0,0,0,0},
    {24,16,33,245},
    {226,222,236,249},
    {153,149,166,250},
    {160,24,223,249},
    {106,25,152,249},
    {78,24,107,247},
    {20,16,25,154},
    {93,92,97,247},
    {48,13,81,249},
    {99,10,105,10},
    {181,173,203,252},
    {25,17,32,95},
    {216,164,233,252},
    {205,25,249,244},
    {138,97,161,249},
    {141,39,171,248},
    {32,7,89,17},
    {119,103,136,252},
    {220,94,245,252},
    {173,89,212,251},
    {255,255,255,1},
    {79,29,101,97},
    {51,17,76,96},
    {76,28,105,150},
    {51,17,78,158},
    {98,19,166,11},
    {156,35,167,17},
    {109,35,145,158},
    {103,99,105,15},
    {255,0,255,1},
    {113,35,140,100}
}
local function rasterLogo(parent,name,pos,size,crop)
    local width = crop and 42 or 120
    local layer = frame(parent,name,pos,size,C.dark,1)
    layer.Visible=false
    layer.ClipsDescendants=true
    local colors,alphas={},{}
    for i,p in ipairs(LOGO_PALETTE) do
        colors[i]=Color3.fromRGB(p[1],p[2],p[3])
        alphas[i]=1-p[4]/255
    end
    for y,row in ipairs(LOGO_ROWS) do
        for x=1,width,12 do
            local n=math.min(12,width-x+1)
            local indices={}
            local visible=false
            for k=1,n do
                local index=(tonumber(row:sub(x+k-1,x+k-1),32) or 0)+1
                indices[k]=index
                if alphas[index]<.92 then visible=true end
            end
            if visible then
                local strip=frame(layer,"Strip",UDim2.fromScale((x-1)/width,(y-1)/40),
                    UDim2.fromScale(n/width,1/40),Color3.new(1,1,1),0)
                local ck,ak={},{}
                local function point(t,i)
                    ck[#ck+1]=ColorSequenceKeypoint.new(t,colors[i])
                    ak[#ak+1]=NumberSequenceKeypoint.new(t,alphas[i])
                end
                point(0,indices[1])
                for k=1,n do point((k-.5)/n,indices[k]) end
                point(1,indices[n])
                make("UIGradient",strip,{Color=ColorSequence.new(ck),
                    Transparency=NumberSequence.new(ak),Rotation=0})
            end
        end
    end
    return layer
end
-- Native geometric fallback, for clients without local image support.
local function logo(p,x,y,s)
    local f=frame(p,"Logo",UDim2.fromOffset(x,y),UDim2.fromOffset(s,s),C.dark,1)
    local ring=frame(f,"Monogram",UDim2.fromScale(.20,.18),UDim2.fromScale(.63,.64),C.dark,1)
    round(ring,math.max(4,math.floor(s*.23)))
    local outline=make("UIStroke",ring,{Color=Color3.new(1,1,1),Thickness=math.max(1.5,s*.085),ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
    make("UIGradient",outline,{Color=ColorSequence.new(Color3.fromRGB(239,223,255),Color3.fromRGB(145,73,238)),Rotation=60})
    local spine=frame(f,"Spine",UDim2.fromScale(.20,.20),UDim2.fromScale(.09,.60),Color3.fromRGB(215,175,255),0)
    round(spine,1)
    local slash=frame(f,"Signature",UDim2.fromScale(.07,.53),UDim2.fromScale(.48,.085),C.accent,0)
    slash.Rotation=-48; round(slash,1)
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
local bg=frame(window,"Glass",UDim2.fromOffset(0,0),UDim2.fromScale(1,1),Color3.new(1,1,1),.07)
round(bg,10); stroke(bg,.68)
make("UIGradient",bg,{Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.purple),ColorSequenceKeypoint.new(.45,Color3.fromRGB(23,22,30)),
    ColorSequenceKeypoint.new(1,C.dark)}),Rotation=90})
local header=frame(window,"Header",UDim2.fromOffset(0,0),UDim2.new(1,0,0,60),C.dark,1)
local drag=frame(header,"DragArea",UDim2.fromOffset(0,0),UDim2.new(1,-76,1,0),C.dark,1)
drag.Active=true
local fallbackLogo=logo(drag,13,8,29)
local brandOK,brandImage=pcall(rasterLogo,drag,"OfficialBrand",UDim2.fromOffset(7,2),UDim2.fromOffset(168,56),false)
local title=label(drag,'Dulcan <font color="#C280FF">Hub</font>',UDim2.fromOffset(51,6),UDim2.fromOffset(165,19),15,C.text,Enum.Font.GothamBold)
title.RichText=true
local subtitle=label(drag,game.Name,UDim2.fromOffset(51,25),UDim2.fromOffset(200,13),10,C.muted)
local version=label(header,"v"..VERSION,UDim2.new(1,-132,0,11),UDim2.fromOffset(59,22),10,C.muted)
version.TextXAlignment=Enum.TextXAlignment.Center
local minimize=button(header,"Minimize","",UDim2.new(1,-65,0,8),UDim2.fromOffset(28,28))
local close=button(header,"Close","",UDim2.new(1,-34,0,8),UDim2.fromOffset(27,28),Color3.fromRGB(134,44,62))
local function iconLine(parent,rotation,length)
    local line=frame(parent,"IconLine",UDim2.fromScale(.5,.5),UDim2.fromOffset(length,1.5),C.muted,0)
    line.AnchorPoint=Vector2.new(.5,.5); line.Rotation=rotation; round(line,1)
    return line
end
iconLine(minimize,0,11)
iconLine(close,45,12); iconLine(close,-45,12)

local sidebar=frame(window,"Sidebar",UDim2.fromOffset(7,60),UDim2.new(0,176,1,-67),C.surface,.77)
round(sidebar,7); stroke(sidebar,.72)
local nav=frame(sidebar,"Navigation",UDim2.fromOffset(6,6),UDim2.new(1,-12,1,-59),C.dark,1)
make("UIListLayout",nav,{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder})
local content=frame(window,"Content",UDim2.fromOffset(190,60),UDim2.new(1,-197,1,-67),C.dark,1)
local profile=frame(sidebar,"Profile",UDim2.new(0,6,1,-47),UDim2.new(1,-12,0,41),C.dark,1)
local avatar=make("ImageLabel",profile,{Name="Avatar",Position=UDim2.fromOffset(3,4),Size=UDim2.fromOffset(31,31),
    BackgroundColor3=C.surface,BackgroundTransparency=.35,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop})
round(avatar,5); stroke(avatar,.65)
label(profile,player.DisplayName,UDim2.fromOffset(42,5),UDim2.new(1,-44,0,16),12,C.text,Enum.Font.GothamMedium)
label(profile,"@"..player.Name,UDim2.fromOffset(42,21),UDim2.new(1,-44,0,13),10,C.muted)

-- Compact independent status bar (actual measured values).
local bar=frame(root,"StatusBar",UDim2.new(1,-12,0,12),UDim2.fromOffset(470,35),C.purple,.10)
bar.AnchorPoint=Vector2.new(1,0); round(bar,7); stroke(bar,.55)
local barScale=make("UIScale",bar,{Scale=1})
make("UIGradient",bar,{Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(145,135,157)),Rotation=90})
local fallbackBarLogo=logo(bar,8,5,23)
local barOK,barLogo=pcall(rasterLogo,bar,"OfficialEmblem",UDim2.fromOffset(6,3),UDim2.fromOffset(28,28),true)
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
round(eyeShape,8); stroke(eyeShape,.22)
local pupil=frame(eyeShape,"Pupil",UDim2.fromOffset(6,3),UDim2.fromOffset(5,5),C.muted,0)
round(pupil,5)
local slash=frame(eye,"Hidden",UDim2.fromOffset(5,13),UDim2.fromOffset(17,1),C.accent,0)
slash.Rotation=-40; slash.Visible=false

-- The native raster is synchronous; retain the geometric fallback only on error.
if brandOK then
    brandImage.Visible=true
    fallbackLogo.Visible=false
    title.Visible=false
    subtitle.Visible=false
else
    warn("[Dulcan Hub] Header artwork: "..tostring(brandImage))
end
if barOK then
    barLogo.Visible=true
    fallbackBarLogo.Visible=false
else
    warn("[Dulcan Hub] Status artwork: "..tostring(barLogo))
end

task.spawn(function()
    local ok,url=pcall(function() return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
    if alive and ok then avatar.Image=url; smallAvatar.Image=url end
end)
task.spawn(function()
    if game.PlaceId==0 then return end
    local ok,info=pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId,Enum.InfoType.Asset) end)
    if alive and ok and info and info.Name then
        experience.Text=info.Name
        subtitle.Text=info.Name
    end
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
print("[Dulcan Hub] v"..VERSION.." | UI ready")
