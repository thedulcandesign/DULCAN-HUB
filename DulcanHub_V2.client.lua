-- DULCAN HUB V2.3 | LocalScript | standalone UI
local VERSION = "2.3.0"
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

-- Official transparent logo, embedded at UI resolution (240 x 80 PNG).
-- Only this static image is written, when a local image API is available.
local LOGO_PNG = "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"
local ROBLOX_LOGO_ASSET = "" -- Optional approved Roblox image asset ID for Studio.
local function decodeBase64(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #alphabet do lookup[alphabet:sub(i,i)] = i-1 end
    local out, value, bits = {}, 0, 0
    for i = 1, #data do
        local n = lookup[data:sub(i,i)]
        if n then
            value = value * 64 + n
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                out[#out+1] = string.char(math.floor(value / 2^bits))
                value = value % 2^bits
            end
        end
    end
    return table.concat(out)
end
local function resolveLogo()
    if ROBLOX_LOGO_ASSET ~= "" then return "rbxassetid://" .. ROBLOX_LOGO_ASSET end
    if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then return nil end
    local ok, result = pcall(function()
        local file = "DulcanHub_logo_v230.png"
        writefile(file, decodeBase64(LOGO_PNG))
        return getcustomasset(file)
    end)
    if ok and type(result) == "string" and result ~= "" then return result end
    return nil
end
local logoAsset = resolveLogo()
local function officialImage(parent, name, pos, size, crop)
    local img = make("ImageLabel", parent, {Name=name, Position=pos, Size=size,
        BackgroundTransparency=1, BorderSizePixel=0, Image=logoAsset or "",
        ScaleType=Enum.ScaleType.Fit, Visible=false})
    if crop then
        img.ImageRectOffset=Vector2.new(0,0)
        img.ImageRectSize=Vector2.new(83,80)
    end
    return img
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
local header=frame(window,"Header",UDim2.fromOffset(0,0),UDim2.new(1,0,0,46),C.dark,1)
local drag=frame(header,"DragArea",UDim2.fromOffset(0,0),UDim2.new(1,-76,1,0),C.dark,1)
drag.Active=true
local fallbackLogo=logo(drag,13,8,29)
local brandImage=officialImage(drag,"OfficialBrand",UDim2.fromOffset(9,3),UDim2.fromOffset(144,40),false)
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

local sidebar=frame(window,"Sidebar",UDim2.fromOffset(7,47),UDim2.new(0,176,1,-54),C.surface,.77)
round(sidebar,7); stroke(sidebar,.72)
local nav=frame(sidebar,"Navigation",UDim2.fromOffset(6,6),UDim2.new(1,-12,1,-59),C.dark,1)
make("UIListLayout",nav,{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder})
local content=frame(window,"Content",UDim2.fromOffset(190,47),UDim2.new(1,-197,1,-54),C.dark,1)
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
local barLogo=officialImage(bar,"OfficialEmblem",UDim2.fromOffset(7,4),UDim2.fromOffset(25,27),true)
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

-- Keep the native fallback until the actual image is loaded.
if logoAsset then
    task.spawn(function()
        local contentProvider=game:GetService("ContentProvider")
        pcall(function() contentProvider:PreloadAsync({brandImage,barLogo}) end)
        if not alive then return end
        if brandImage.IsLoaded then
            brandImage.Visible=true
            fallbackLogo.Visible=false
            title.Visible=false
            subtitle.Visible=false
        end
        if barLogo.IsLoaded then
            barLogo.Visible=true
            fallbackBarLogo.Visible=false
        end
    end)
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
