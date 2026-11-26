-- DULCAN HUB V2.8.7 | LocalScript | standalone UI
local VERSION = "2.8.7"
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
-- Typography follows the public Fluent reference (not a verified Axon font).
local UI_FONT_FAMILY = "rbxasset://fonts/families/GothamSSm.json"
local UI_FONTS = {
    Regular = Font.new(UI_FONT_FAMILY, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
    Medium = Font.new(UI_FONT_FAMILY, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    SemiBold = Font.new(UI_FONT_FAMILY, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
}
local function make(class, parent, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    if o:IsA("GuiBase2d") then o.AutoLocalize = false end
    if (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")) and not (props and props.FontFace) then
        o.FontFace = UI_FONTS.Regular
    end
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
        Text=txt,TextSize=px,TextColor3=color or C.text,FontFace=font or UI_FONTS.Regular,
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
    "0000000000000000000000000000000000J",
    "000000000000000000000000000000000S1",
    "000000000000000000000000000000000VUP",
    "00000000000000000000000000000000CVUEJ",
    "0000000000000000000000000000000SVVEEN",
    "0000000000000000000000000000004V6NEK5Q",
    "00000000000000000000000000000JN6VIEINI1J",
    "0000000000000000J00000000000AKNVK7FI1EUUS00000000000000S",
    "000000000000000S1CJ000000000VN6G1555NV51Q00000000000JQL4",
    "0000000000000000KEGOC4J00000JDGG2II56VGD000000S44CCVKEQ",
    "00000000000000004E1GGG6600000J2GG6KVVG2400000466GGVKENJ",
    "0000000000000000055V6G6G4000JGG2661I62GGC0000CGG6VV6VQ",
    "00000000000000000A5G1L2GG00C66GG26U12GGG66CJDG22K626N",
    "0000000000000000005V5E222GL16GGGG2H2G66GGGVVG22RKGGNQ",
    "000000000000000000Q55E1L13EN6G2G6VVV6GGGGGG6N1UUN6VV00000AA",
    "000000000000000000055E557FE566N1KEUUKIN666GG6577N6NS00SSSLLVQS",
    "0000000000000000000QIEI5IEUUE7I7EFFFE7I1NV66VI7IVNN000Q6NLVVVVQ",
    "00000000000000000004IEE5EFFFE1V666V6GG6VVVV6GNU75540SQNKK11NVVVVQ",
    "000000000000000000001EN1K15NG22222222222222G66NEIVJS6NE1V66VVC4SQS",
    "00000000000000000000QIG2222222222222222GGGG22267E2GG6E1GGG44SS000SS",
    "000000000004QPBBPPPPTTGTTTTTTT99LLLL111KKEEKNG2V12661KGGC",
    "00000000000JV19HFFF338333FFFFFFFFFFFFFFFFFFFFUN22G6V1NGG4",
    "000000000000JV5G2GR33HHHHHHH8HHH88888833FFFFFFFE6266NV6G00000000A",
    "0000000000000JNIVG2GRF38H8HHHH8888888333FFFFF3FF3N2GV6GGC000000AB",
    "00000000000000DV7N662GHFFFFFFFFFFFFFFFFFFFFF33383FIGVVV62OJ000SABS",
    "000000000000000DV7N6VG2TRRRRRRRRRRRRRRRR3FF3333888FKG6N1K1VCJASQKSS000BBBBBBBBBBA00BBBB0000BBBBBBBB0000000ABBBBBBB0000ABBB0000BBBB000BBBBB00MMMB0000MMMMAMMMM000MMMMAMMMMMMMMM4",
    "0000000000000000OT755NG22222222222GGGG6G2TFF33888H8F12226KIKNCQVKQS00JHFFFFFFFFFFPO3FF800043FFRTFFF0000048FFFFFFF8J00J3FFFS00JFFF8J00PFFFP001777A000K77IG777Q0001777C7777777777A",
    "0000000000000000C2L7IV2GG22222222G2GGGGVN6GRF3888HH83V222TIIEN6LE6SS0D8F3FFFFF33F82FFFP000CFFFGRFFFJ0000HFF33333FRJ00PF33FP00P333FC0JRFF3C0J1771J00JII7VG7IIC00J177NG7IIIIIIII71",
    "0000000000000000G22KI6GG29F3FFFFF9222222GNVGT338HHHH3HG226EEUU6LUVCS4GFFFFFFFFF3F82FFFO000PFFF28FFRJ000SFFFFFFFFFTJ0C3388FPJ0PF38FRDDHFFHD04II7NJ00SII7GNII1D00SII76V7I777777I71",
    "000000000A11KMQ6G22712G223F3FFFFF2G2222222VN6683HHHHH362GKUUFUVNUVCSDTFFF222228FF9TFF8OA0JRFF32F3FTJ000PFFFG22222D0DHF838FRJJRF33FFG233F9J0CIIIG000QIII21IIVJ00QIII2177V22227I7L",
    "000000000QQMMN6GG2GEV222TF3FFFFFRGG22222222N1V638HHHH3L25UU3FI6NUN6CORFF8222223FFGRFFROASDHFFRGF33O400JRFF8222OOD4DTF38R83RDDH3333F92F3FT4JVIIIVMMM1II52I5I6J0JNIII27I7LLLTNI77D",
    "000000000A000MNVG2LE22G28FFFFFFF6G22GGGG22221VGH8HHHHF9NEEUFEN61UNV628FFR2GG2GFFF23FFTO44OFFFG933HOS40D8FFR2GOD444O83FGT38H2O8383838T388OSJNI55IIIII5IVGI5IO4SDNIING7II7777IIIGJ",
    "000000000000001VG21V2GGGFFFFFFFUVG2GGGGGG222VV6H38888K77KU3IIVVIF5V6G33FT2GG29F382F3FGOCOTF832H839O444O38FT2GODDCORF3H2G3832G388T3888H8HDAD155IIIII55IGVI512CCOI5I6VI5IIIII5I1O",
    "0000000000000MVGG6622VGHF3FFFFFKV22GGGGGGGG2NNV8333UEI1KUK6I16VKFIN6TF83G2GG2H339TF8822G293HH28H8G2OCOT3H32222OO2GF839T93832T8H82H8HHH89DSCI5I11111I5I255IV26G6I5I21IINVNVNI5IQ",
    "00000000000M1VGG6VG2GV6F333333FIV2GGG6GGGGG21553FF3E11HRG2NEG6VKFIN693HH2GG2G3H3T988H2222HH89G8RH2222298HH2222222838833388329HHR2T3RRR8TDJVI5I22226I552I5I62G2NI5I2I5I22222I5IQ",
    "000000000M11NGG6NNG2V61F838883UIG2GGGGGGG66V7IIFFUK1LLG22676G6VIF5VGR8HH833838R32HHHH8888HR8T9HRH8388GRHRH8H8H89T3H833338H8T9R89228RRRHG4DNII12GG21IINGI55I111I5INGI5I1111III7C",
    "0000000AK1NN666NINGGN63888HHHF7N2GGGGGG666V577UFUKLT6VG2656DSC61UNVGHRRH88HHRR3R28HRRRRRR9H82RRRH88HH2RH9RRRRRH2HR89GGGGHRHTTR8G229H9RRO0D1IIN2GG2I5I6G7555III5I72VI55IIIIII7LJ",
    "000000MK161N6NIEEN2VN1FHHHHR8UIG266GGG666V57UFFKNVVVLHGGVGJ04S6NUN6TF33F33333FH229F8888883822F33F3383TG3888883TH33H2OOO2833HT332O2238FRD0C777VGV6V777G2E77777777627777777777LD",
    "00000MK16N777EK1E12NNU8RHRRR37V2656GG666NIEF3KK11RRRH82G2J000SCNUVCT999999999T22O2988888RT22G99999999T2G9999992999GO444OT99TG9T2OOOT99TJ0CL11NN111K1LGGGLLLRRLL22G1LLLLLLLLGD",
    "0000MK1V177E7V6G55G55FRRRRRHU5G2G6GGG6NKEUEIIEF8HHHR3R2GD000004LEVSDOO",
    "000A1NNN1V66VGG2VNL5K3RRRRR8K622GGV5KEEKN655KFHHHHHHFGGG0000004QECSSSS",
    "000MNLNN6GGG66G26615URRRRRHFVG26V511N6G2G66KFHHHHHHFR2GC0000004QKCS00J",
    "000QVLN644CG6GGGGVIK39RRRHF922222222222226HFHHHHHHF3GG640000000QK4S04Q",
    "000Q6LVC000C6GGG21IUH9RR8822T9999999RRRR8F3HHHHHHF3GG6600000000AM4004C",
    "000SCVV4000J6GG2GII39R9HH29883FFFFFFFF338HRHHHH8FHGG6V400000000AM00000",
    "00000VV00000CGG2VIE899H92RH9RRH3FF38HRRRHHHHHH3F1GG6NQ0000000000A",
    "00000SV00000CCG2I73RRH9GRR9RRRHH8HHHHRHHH8888FFVG6NIN",
    "000000QS000040D67E3RH9TR99RRRRRRRRRRHHH8333FFUVG667KJ",
    "000000AQ000000J17FUKR9R9RRRRRRRRRRRHH83FFFFFK6G6G514",
    "0000000AS0000047UFUU3FFFFFFFFFFFFFFFFFFFFFUI66GGNNJ",
    "000000000S0000MEFFFUK1LTTTTTTTTTTTLLN11IE7IV6GGNVJ",
    "000000000000007UFF7IV6GG22222222222GGG6V575V66VC",
    "0000000000000Q7FEI5V666GGGG666666666VVVNIENGGCJ",
    "00000000000001UKV666CCCCCCCCCCCCCCCCCCCQCDDJ",
    "000000000000SEK66C4",
    "000000000000KKGC4",
    "00000000000SLOJ",
    "000000000004J",
    "0",
    "0"
}
local LOGO_PALETTE = {
    {0,0,0,0},
    {152,44,197,247},
    {3,3,5,249},
    {222,216,238,252},
    {38,26,48,62},
    {124,9,213,251},
    {46,11,80,248},
    {232,29,254,252},
    {192,189,209,252},
    {104,100,110,252},
    {117,65,139,46},
    {183,177,184,95},
    {39,16,56,148},
    {8,8,9,120},
    {242,95,254,253},
    {252,250,254,253},
    {26,14,41,248},
    {167,158,187,252},
    {171,11,249,252},
    {6,8,8,51},
    {194,74,240,247},
    {112,51,130,249},
    {174,58,199,96},
    {106,20,159,249},
    {8,8,9,199},
    {106,103,107,166},
    {92,30,125,147},
    {136,128,149,251},
    {75,42,95,60},
    {66,60,69,246},
    {246,160,252,252},
    {76,18,119,246}
}
local function rasterLogo(parent,name,pos,size,crop)
    local width = crop and 65 or 180
    local height = #LOGO_ROWS
    local layer = frame(parent,name,pos,size,C.dark,1)
    layer.Visible=false
    layer.ClipsDescendants=true
    local colors,alphas={},{}
    for i,p in ipairs(LOGO_PALETTE) do
        colors[i]=Color3.fromRGB(p[1],p[2],p[3])
        alphas[i]=1-p[4]/255
    end
    for y,row in ipairs(LOGO_ROWS) do
        for x=1,width,16 do
            local n=math.min(16,width-x+1)
            local indices={}
            local visible=false
            for k=1,n do
                local index=(tonumber(row:sub(x+k-1,x+k-1),32) or 0)+1
                indices[k]=index
                if alphas[index]<.92 then visible=true end
            end
            if visible then
                local strip=frame(layer,"Strip",UDim2.fromScale((x-1)/width,(y-1)/height),
                    UDim2.fromScale(n/width,1/height),Color3.new(1,1,1),0)
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
        FontFace=UI_FONTS.Medium,TextSize=18,TextColor3=C.muted,
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
local header=frame(window,"Header",UDim2.fromOffset(0,0),UDim2.new(1,0,0,66),C.dark,1)
local drag=frame(header,"DragArea",UDim2.fromOffset(0,0),UDim2.new(1,-76,1,0),C.dark,1)
drag.Active=true
local fallbackLogo=logo(drag,13,8,29)
local brandOK,brandImage=pcall(rasterLogo,drag,"OfficialBrand",UDim2.fromOffset(7,1),UDim2.fromOffset(192,64),false)
local title=label(drag,'Dulcan <font color="#C280FF">Hub</font>',UDim2.fromOffset(51,6),UDim2.fromOffset(165,19),15,C.text,UI_FONTS.SemiBold)
title.RichText=true
local subtitle=label(drag,"UNIVERSAL INTERFACE",UDim2.fromOffset(51,25),UDim2.fromOffset(200,14),11,C.text,UI_FONTS.Medium)
local brandSubtitle=label(drag,"UNIVERSAL INTERFACE",UDim2.fromOffset(83,44),UDim2.fromOffset(143,15),11,Color3.fromRGB(232,224,243),UI_FONTS.Medium)
brandSubtitle.Name="OfficialBrandSubtitle"
brandSubtitle.TextTruncate=Enum.TextTruncate.None
brandSubtitle.ZIndex=3
brandSubtitle.Visible=false
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

local sidebar=frame(window,"Sidebar",UDim2.fromOffset(7,66),UDim2.new(0,176,1,-73),C.surface,.77)
round(sidebar,7); stroke(sidebar,.72)
local nav=make("ScrollingFrame",sidebar,{Name="Navigation",Position=UDim2.fromOffset(6,6),
    Size=UDim2.new(1,-12,1,-59),BackgroundTransparency=1,BorderSizePixel=0,
    CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=2,
    ScrollBarImageColor3=C.muted,ClipsDescendants=true})
make("UIListLayout",nav,{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder})
local content=frame(window,"Content",UDim2.fromOffset(190,66),UDim2.new(1,-197,1,-73),C.dark,1)
local profile=frame(sidebar,"Profile",UDim2.new(0,6,1,-47),UDim2.new(1,-12,0,41),C.dark,1)
local avatar=make("ImageLabel",profile,{Name="Avatar",Position=UDim2.fromOffset(3,4),Size=UDim2.fromOffset(31,31),
    BackgroundColor3=C.surface,BackgroundTransparency=.35,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop})
round(avatar,5); stroke(avatar,.65)
label(profile,player.DisplayName,UDim2.fromOffset(42,5),UDim2.new(1,-44,0,16),12,C.text,UI_FONTS.Medium)
label(profile,"@"..player.Name,UDim2.fromOffset(42,21),UDim2.new(1,-44,0,13),10,C.muted)

-- Settings only: two compact panels, no game-specific functions.
local toggleKey=Enum.KeyCode.RightShift
local capturingKey=false
local blurEnabled=false
local blurEffect
local renderChanged=false
local oldQuality
local oldFPS
local fpsLimit=60
local capEnabled=false
local function restoreSettings()
    if blurEffect then blurEffect:Destroy(); blurEffect=nil end
    if renderChanged then pcall(function() RunService:Set3dRenderingEnabled(true) end) end
    if oldQuality~=nil then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel=oldQuality end) end
    if capEnabled and oldFPS~=nil and type(setfpscap)=="function" then pcall(setfpscap,oldFPS) end
end
on(gui.Destroying,restoreSettings)

local selected=make("TextButton",nav,{Name="Settings",Size=UDim2.new(1,-2,0,35),
    BackgroundColor3=C.surface,BackgroundTransparency=.38,Text="",AutoButtonColor=false,BorderSizePixel=0})
round(selected,6); stroke(selected,.72)
local gear=label(selected,"⚙",UDim2.fromOffset(11,0),UDim2.fromOffset(24,35),19,C.accent)
gear.Font=Enum.Font.BuilderSans
label(selected,"Settings",UDim2.fromOffset(40,0),UDim2.new(1,-45,1,0),12,C.text,UI_FONTS.Regular)
local heading=label(header,"Settings",UDim2.fromOffset(242,6),UDim2.new(1,-390,0,48),13,C.text,UI_FONTS.Medium)
heading.ZIndex=2
content.ClipsDescendants=true
local scroll=make("ScrollingFrame",content,{Name="SettingsPage",Size=UDim2.fromScale(1,1),
    CanvasSize=UDim2.fromOffset(0,0),BackgroundTransparency=1,BorderSizePixel=0,
    ScrollBarThickness=3,ScrollBarImageColor3=C.muted,ScrollingDirection=Enum.ScrollingDirection.Y})
local function panel(name,height)
    local p=frame(scroll,name,UDim2.fromOffset(0,0),UDim2.fromOffset(250,height),C.surface,.72)
    round(p,7); stroke(p,.65)
    label(p,name,UDim2.fromOffset(13,8),UDim2.new(1,-26,0,22),12,C.text,UI_FONTS.Medium)
    return p
end
local performance=panel("Performance",201)
local interface=panel("Interface",148)
local notice=label(scroll,"",UDim2.fromOffset(4,211),UDim2.new(1,-8,0,32),11,C.muted)
notice.TextWrapped=true; notice.TextTruncate=Enum.TextTruncate.None
local function feedback(message)
    notice.Text=message or ""
end
local function layoutPanels()
    local width=math.max(1,scroll.AbsoluteSize.X/math.max(scale.Scale,.001)-5)
    if width>=420 then
        local half=math.floor((width-6)/2)
        performance.Position=UDim2.fromOffset(0,1)
        performance.Size=UDim2.fromOffset(half,201)
        interface.Position=UDim2.fromOffset(half+6,1)
        interface.Size=UDim2.fromOffset(width-half-6,148)
        notice.Position=UDim2.fromOffset(4,209)
        scroll.CanvasSize=UDim2.fromOffset(0,244)
    else
        performance.Position=UDim2.fromOffset(0,1)
        performance.Size=UDim2.fromOffset(width,201)
        interface.Position=UDim2.fromOffset(0,208)
        interface.Size=UDim2.fromOffset(width,148)
        notice.Position=UDim2.fromOffset(4,363)
        scroll.CanvasSize=UDim2.fromOffset(0,400)
    end
end
on(scroll:GetPropertyChangedSignal("AbsoluteSize"),layoutPanels)
on(scale:GetPropertyChangedSignal("Scale"),layoutPanels)
layoutPanels()
local function row(p,name,y)
    local r=frame(p,name,UDim2.fromOffset(10,y),UDim2.new(1,-20,0,35),C.dark,1)
    label(r,name,UDim2.fromOffset(3,0),UDim2.new(1,-54,1,0),12,C.text,UI_FONTS.Regular)
    return r
end
local function toggle(p,name,y,callback)
    local r=row(p,name,y)
    local b=make("TextButton",r,{Name="Toggle",AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-3,.5,0),
        Size=UDim2.fromOffset(35,21),BackgroundColor3=C.surface,BackgroundTransparency=.15,Text="",BorderSizePixel=0,AutoButtonColor=false})
    round(b,11); stroke(b,.60)
    local knob=frame(b,"Knob",UDim2.fromOffset(3,3),UDim2.fromOffset(15,15),C.muted,0)
    round(knob,8)
    local state=false
    on(b.Activated,function()
        local nextState=not state
        local ok,result,message=pcall(callback,nextState)
        if not ok or result==false then
            feedback(message or (name.." is not available in this client."))
            return
        end
        state=nextState
        feedback("")
        tween(b,{BackgroundColor3=state and C.accent or C.surface},.15)
        tween(knob,{Position=UDim2.fromOffset(state and 17 or 3,3),BackgroundColor3=state and C.text or C.muted},.15)
    end)
end
toggle(performance,"Disable 3D Rendering",35,function(enabled)
    RunService:Set3dRenderingEnabled(not enabled)
    renderChanged=enabled
    return true
end)
toggle(performance,"Low Graphics",70,function(enabled)
    local settings=UserSettings():GetService("UserGameSettings")
    if enabled then
        local prior=settings.SavedQualityLevel
        settings.SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1
        oldQuality=prior
    elseif oldQuality~=nil then
        settings.SavedQualityLevel=oldQuality
        oldQuality=nil
    end
    return true
end)
toggle(performance,"FPS Cap",105,function(enabled)
    if type(setfpscap)~="function" or type(getfpscap)~="function" then
        return false,"FPS Cap is not available here. Use Roblox graphics settings."
    end
    if enabled then
        local prior=getfpscap()
        if type(prior)~="number" then return false,"Could not read the original FPS limit." end
        setfpscap(fpsLimit)
        oldFPS=prior; capEnabled=true
    else
        setfpscap(oldFPS)
        oldFPS=nil; capEnabled=false
    end
    return true
end)
local sliderLabel=label(performance,"FPS Limit",UDim2.fromOffset(13,144),UDim2.new(1,-72,0,21),12,C.text)
local value=label(performance,"60",UDim2.new(1,-66,0,144),UDim2.fromOffset(53,21),12,C.muted)
value.TextXAlignment=Enum.TextXAlignment.Right
local slider=frame(performance,"Slider",UDim2.fromOffset(13,174),UDim2.new(1,-26,0,6),C.surface,.05)
round(slider,4); stroke(slider,.7)
local fill=frame(slider,"Fill",UDim2.fromOffset(0,0),UDim2.fromScale(30/210,1),C.accent,0); round(fill,4)
local thumb=frame(slider,"Thumb",UDim2.fromScale(30/210,.5),UDim2.fromOffset(13,13),C.text,0)
thumb.AnchorPoint=Vector2.new(.5,.5); round(thumb,7)
local hit=make("TextButton",slider,{Name="Hit",Position=UDim2.fromOffset(0,-8),Size=UDim2.new(1,0,0,22),
    BackgroundTransparency=1,Text="",AutoButtonColor=false})
local sliding
local function sliderAt(x)
    local ratio=math.clamp((x-slider.AbsolutePosition.X)/math.max(1,slider.AbsoluteSize.X),0,1)
    local n=math.clamp(math.floor((30+ratio*210)/5+.5)*5,30,240)
    if capEnabled then
        local ok=pcall(setfpscap,n)
        if not ok then feedback("Unable to change the FPS limit."); return end
    end
    fpsLimit=n; value.Text=tostring(n)
    local t=(n-30)/210
    fill.Size=UDim2.fromScale(t,1); thumb.Position=UDim2.fromScale(t,.5)
end
on(hit.InputBegan,function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        sliding=i; sliderAt(i.Position.X)
    end
end)
on(UIS.InputChanged,function(i)
    if not sliding then return end
    if i==sliding or (sliding.UserInputType==Enum.UserInputType.MouseButton1 and i.UserInputType==Enum.UserInputType.MouseMovement) then sliderAt(i.Position.X) end
end)
on(UIS.InputEnded,function(i) if i==sliding then sliding=nil end end)
local function applyBlur(visible)
    if not blurEffect then return end
    blurEffect.Enabled=blurEnabled and visible
end
toggle(interface,"Background Blur",35,function(enabled)
    if enabled and not blurEffect then
        blurEffect=make("BlurEffect",game:GetService("Lighting"),{Name="DulcanHubBlur",Size=12,Enabled=true})
    end
    blurEnabled=enabled; applyBlur(window.Visible)
    return true
end)
local keyRow=row(interface,"Toggle Key",70)
local keyButton=make("TextButton",keyRow,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-3,.5,0),
    Size=UDim2.fromOffset(68,24),BackgroundColor3=C.surface,BackgroundTransparency=.18,Text="RShift",
    TextColor3=C.muted,FontFace=UI_FONTS.Medium,TextSize=11,BorderSizePixel=0,AutoButtonColor=false})
round(keyButton,5); stroke(keyButton,.65)
on(keyButton.Activated,function()
    capturingKey=not capturingKey
    keyButton.Text=capturingKey and "Press key" or (toggleKey==Enum.KeyCode.RightShift and "RShift" or toggleKey.Name)
end)
local unload=make("TextButton",interface,{Name="UnloadHub",Position=UDim2.fromOffset(9,109),Size=UDim2.new(1,-18,0,30),
    Text="",BackgroundColor3=C.surface,BackgroundTransparency=.73,BorderSizePixel=0,AutoButtonColor=false})
round(unload,5); stroke(unload,.76)
label(unload,"Unload Hub",UDim2.fromOffset(5,0),UDim2.new(1,-35,1,0),12,C.text)
local arrow=label(unload,"›",UDim2.new(1,-22,0,0),UDim2.fromOffset(16,30),18,C.muted)
on(unload.Activated,function() gui:Destroy() end)

-- Compact status bar inspired by the visual reference.
-- Every group has its own space; the logo cannot overlap the FPS label.
local BAR_WIDTH=480
local BAR_HEIGHT=36
local bar=frame(root,"StatusBar",UDim2.new(1,-12-BAR_WIDTH,0,12),UDim2.fromOffset(BAR_WIDTH,BAR_HEIGHT),Color3.fromRGB(22,23,29),.13)
bar.AnchorPoint=Vector2.new(0,0); round(bar,7); stroke(bar,.67)
local barScale=make("UIScale",bar,{Scale=1})
make("UIGradient",bar,{Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(190,185,200)),Rotation=90})
local barRegular=Font.new(UI_FONT_FAMILY,Enum.FontWeight.Regular,Enum.FontStyle.Normal)
local barMedium=Font.new(UI_FONT_FAMILY,Enum.FontWeight.Medium,Enum.FontStyle.Normal)
local fallbackBarLogo=logo(bar,9,8,20)
local barOK,barLogo=pcall(rasterLogo,bar,"OfficialEmblem",UDim2.fromOffset(8,8),UDim2.fromOffset(22,20),true)
local function barLabel(name,txt,x,width,color)
    local l=label(bar,txt,UDim2.fromOffset(x,0),UDim2.fromOffset(width,BAR_HEIGHT),11,color,barRegular)
    l.Name=name
    l.TextXAlignment=Enum.TextXAlignment.Center
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.TextScaled=false
    return l
end
local fps=barLabel("FPS","— FPS",34,59,C.muted)
fps.RichText=true
fps.FontFace=barMedium
fps.TextTruncate=Enum.TextTruncate.None
local ping=barLabel("Ping","— ms",100,51,C.muted)
ping.RichText=true
ping.FontFace=barMedium
ping.TextTruncate=Enum.TextTruncate.None
local function separator(x)
    local line=frame(bar,"Separator",UDim2.fromOffset(x,BAR_HEIGHT/2),UDim2.fromOffset(1,15),C.border,.75)
    line.AnchorPoint=Vector2.new(.5,.5)
end
separator(96); separator(155); separator(263)
local smallAvatar=make("ImageLabel",bar,{Position=UDim2.fromOffset(164,18),AnchorPoint=Vector2.new(0,.5),Size=UDim2.fromOffset(18,18),
    BackgroundColor3=C.surface,BackgroundTransparency=.38,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop})
round(smallAvatar,4); stroke(smallAvatar,.78)
local barUser=barLabel("Username","@"..player.Name,188,70,C.muted)
barUser.TextSize=10
barUser.TextXAlignment=Enum.TextXAlignment.Left
local experience=barLabel("Experience",game.Name,273,165,C.muted)
experience.TextXAlignment=Enum.TextXAlignment.Left
local eye=make("TextButton",bar,{Name="ToggleWindow",Position=UDim2.fromOffset(446,4),Size=UDim2.fromOffset(29,28),
    BackgroundColor3=C.surface,BackgroundTransparency=.57,Text="",BorderSizePixel=0,AutoButtonColor=false})
round(eye,5); stroke(eye,.71)
on(eye.MouseEnter,function() tween(eye,{BackgroundTransparency=.24},.12) end)
on(eye.MouseLeave,function() tween(eye,{BackgroundTransparency=.57},.12) end)
local eyeShape=frame(eye,"Eye",UDim2.fromScale(.5,.5),UDim2.fromOffset(14,8),C.dark,1)
eyeShape.AnchorPoint=Vector2.new(.5,.5)
round(eyeShape,8); stroke(eyeShape,.16)
local pupil=frame(eyeShape,"Pupil",UDim2.fromScale(.5,.5),UDim2.fromOffset(4,4),C.muted,0)
pupil.AnchorPoint=Vector2.new(.5,.5); round(pupil,5)
local slash=frame(eye,"Hidden",UDim2.fromScale(.5,.5),UDim2.fromOffset(16,1),C.accent,0)
slash.AnchorPoint=Vector2.new(.5,.5); slash.Rotation=-40; slash.Visible=false

-- The native raster is synchronous; retain the geometric fallback only on error.
if brandOK then
    brandImage.Visible=true
    fallbackLogo.Visible=false
    title.Visible=false
    subtitle.Visible=false
    brandSubtitle.Visible=true
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
    end
end)

-- Layout, drag, resize and viewport bounds.
local positioned=false
local function layout()
    local v=root.AbsoluteSize
    if v.X<32 or v.Y<32 then return end
    scale.Scale=math.min(1,(v.X-24)/w,(v.Y-24)/h)
    local statusScale=math.min(1,(v.X-24)/BAR_WIDTH)
    barScale.Scale=statusScale
    bar.Position=UDim2.fromOffset(math.max(0,math.floor(v.X-12-BAR_WIDTH*statusScale)),12)
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
    applyBlur(state)
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
    if capturingKey and i.UserInputType==Enum.UserInputType.Keyboard then
        capturingKey=false
        if i.KeyCode~=Enum.KeyCode.Escape and i.KeyCode~=Enum.KeyCode.Unknown then toggleKey=i.KeyCode end
        keyButton.Text=toggleKey==Enum.KeyCode.RightShift and "RShift" or toggleKey.Name
        return
    end
    if not processed and not UIS:GetFocusedTextBox() and i.KeyCode==toggleKey then setOpen(not open) end
end)
local frames,elapsed=0,0
on(RunService.RenderStepped,function(dt)
    frames+=1; elapsed+=dt
    if elapsed<.5 then return end
    fps.Text=string.format('<font color="#F3F0FA">%d</font> FPS',math.floor(frames/elapsed+.5))
    frames,elapsed=0,0
    local ok,value=pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    ping.Text=ok and type(value)=="number" and string.format('<font color="#F3F0FA">%d</font> ms',math.floor(value+.5)) or "— ms"
end)
setOpen(true)
print("[Dulcan Hub] v"..VERSION.." | UI ready")
