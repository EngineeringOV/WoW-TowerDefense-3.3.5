local PARCHMENT="Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal"
local PARCHMENT2="Interface\\AchievementFrame\\UI-GuildAchievement-Parchment-Horizontal"
local DIALOGBG="Interface\\DialogFrame\\UI-DialogBox-Background"
local GOLDBDR="Interface\\DialogFrame\\UI-DialogBox-Gold-Border"
local TOOLTIPBDR="Interface\\Tooltips\\UI-Tooltip-Border"
local HIGHLIGHT="Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
local C=TD.CELL; local COLS,ROWS=TD.COLS,TD.ROWS; local MW,MH=COLS*C,ROWS*C; local PW=TD.PANEL_W
local PT=TD.PAD_TOP; local PB=TD.PAD_BOT; local FW=MW+PW+8; local FH=MH+PT+PB+8
local function Stars(n) local s=""; for i=1,3 do s=s..(i<=n and "|cffffd700*|r" or "|cff555555*|r") end; return s end
local function HexC(c) return string.format("%02x%02x%02x",c[1]*255,c[2]*255,c[3]*255) end
local function CardFrame(p,w,h) local f=CreateFrame("Button",nil,p); f:SetSize(w,h)
    f:SetBackdrop({bgFile=PARCHMENT2,edgeFile=TOOLTIPBDR,edgeSize=16,tile=false,insets={left=3,right=3,top=3,bottom=3}})
    f:SetBackdropColor(0.7,0.65,0.55,0.95); f:SetBackdropBorderColor(0.5,0.45,0.35,1); return f end
local function InsetPanel(p,w,h) local f=CreateFrame("Frame",nil,p); f:SetSize(w,h)
    f:SetBackdrop({bgFile=DIALOGBG,edgeFile=TOOLTIPBDR,edgeSize=14,tile=true,tileSize=32,insets={left=3,right=3,top=3,bottom=3}})
    f:SetBackdropColor(0.1,0.1,0.1,0.85); f:SetBackdropBorderColor(0.4,0.4,0.4,0.8); return f end

function TD.CreateMain() if TD.frames.main then return end
    local f=CreateFrame("Frame","TowerDefenseFrame",UIParent); f:SetSize(FW,FH); f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving); f:SetScript("OnDragStop",f.StopMovingOrSizing)
    f:SetFrameStrata("HIGH"); f:SetClampedToScreen(true)
    f:SetBackdrop({bgFile=PARCHMENT,edgeFile=GOLDBDR,edgeSize=32,tile=false,insets={left=8,right=8,top=8,bottom=8}})
    f:SetBackdropColor(1,1,1,1); f:SetBackdropBorderColor(1,1,1,1); tinsert(UISpecialFrames,"TowerDefenseFrame")
    local cl=CreateFrame("Button",nil,f,"UIPanelCloseButton"); cl:SetPoint("TOPRIGHT",0,0); cl:SetScript("OnClick",function() f:Hide() end)
    TD.frames.main=f end

-- ============================================================
-- MENU (hover tooltip for details)
-- ============================================================
function TD.CreateMenu() if TD.frames.menuFrame then return end
    local m=CreateFrame("Frame",nil,TD.frames.main); m:SetPoint("TOPLEFT",14,-14); m:SetPoint("BOTTOMRIGHT",-14,14); m:Hide(); TD.frames.menuFrame=m
    local ti=TD.Lbl(m,28,0.85,0.7,0.35); ti:SetPoint("TOP",0,-10); ti:SetText("Tower Defense")
    local su=TD.Lbl(m,14,0.7,0.6,0.45); su:SetPoint("TOP",0,-42); su:SetText("Choose your battlefield")
    local cards={}; local pR=4; local mg=8; local gX=10; local gY=10; local iW=FW-32; local iH=FH-32
    local cw=math.floor((iW-mg*2-(pR-1)*gX)/pR); local ch=math.floor((iH-68-40-gY-mg)/2)
    for idx,md in ipairs(TD.MAPS) do local col=(idx-1)%pR; local row=math.floor((idx-1)/pR)
        local cd=CardFrame(m,cw,ch); cd:SetPoint("TOPLEFT",m,"TOPLEFT",mg+col*(cw+gX),-60-row*(ch+gY))
        local accent=TD.Tex(cd,"ARTWORK",md.theme.ground[1]*1.8,md.theme.ground[2]*1.8,md.theme.ground[3]*1.8,0.5); accent:SetHeight(4); accent:SetPoint("TOPLEFT",5,-5); accent:SetPoint("TOPRIGHT",-5,-5)
        local nl=TD.Lbl(cd,16,0.85,0.7,0.4); nl:SetPoint("TOP",0,-14); nl:SetWidth(cw-16); nl:SetText(md.name)
        local dl=TD.Lbl(cd,13,md.diffColor[1],md.diffColor[2],md.diffColor[3]); dl:SetPoint("TOP",0,-34); dl:SetText(md.difficulty.." - "..md.totalWaves.."w")
        local fl=TD.Lbl(cd,11,0.85,0.55,0.2); fl:SetPoint("TOP",0,-52); fl:SetWidth(cw-16); fl:SetText(md.flavor or "")
        if md.boss and TD.BOSS_DEFS[md.boss] then local bl=TD.Lbl(cd,11,0.8,0.4,0.8); bl:SetPoint("TOP",0,-68); bl:SetText("Boss: "..TD.BOSS_DEFS[md.boss].name) end
        cd.progL=TD.Lbl(cd,14,0.8,0.7,0.45); cd.progL:SetPoint("BOTTOM",0,32)
        cd.starsL=TD.Lbl(cd,20,1,1,1); cd.starsL:SetPoint("BOTTOM",0,10)
        cd:SetScript("OnEnter",function(self) self:SetBackdropBorderColor(1,0.85,0.4,1); GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
            GameTooltip:AddLine(md.name,0.9,0.8,0.5); GameTooltip:AddLine(md.difficulty.." - "..md.totalWaves.." waves",md.diffColor[1],md.diffColor[2],md.diffColor[3])
            GameTooltip:AddLine(" "); GameTooltip:AddLine(md.desc,0.9,0.85,0.75,true); GameTooltip:AddLine(md.flavor,0.9,0.6,0.2)
            if md.rewardItem and TD.ITEM_DEFS[md.rewardItem] then local d=TD.ITEM_DEFS[md.rewardItem]; GameTooltip:AddLine(" "); GameTooltip:AddLine("Reward: "..d.name,1,0.85,0.3); GameTooltip:AddLine(d.desc,0.8,0.7,0.5) end
            if md.boss and TD.BOSS_DEFS[md.boss] then local b=TD.BOSS_DEFS[md.boss]; GameTooltip:AddLine(" "); GameTooltip:AddLine("Boss: "..b.name,0.9,0.4,0.9); GameTooltip:AddLine(b.desc,0.8,0.6,0.8,true) end
            if md.challenges then GameTooltip:AddLine(" "); GameTooltip:AddLine("Challenges:",0.7,0.65,0.5)
                for _,ch in ipairs(md.challenges) do local cdf=TD.CHALLENGE_DEFS[ch.type]; local done=TD.IsChallengeComplete(ch.id)
                    if done then GameTooltip:AddDoubleLine(cdf.name,"|cff33cc33Done|r",0.5,0.8,0.5,0.2,0.8,0.2)
                    else GameTooltip:AddDoubleLine(cdf.name.." ("..cdf.desc..")",ch.rewardText,0.8,0.7,0.5,1,0.85,0.3) end end end; GameTooltip:Show() end)
        cd:SetScript("OnLeave",function(self) self:SetBackdropBorderColor(0.5,0.45,0.35,1); GameTooltip:Hide() end)
        cd:SetScript("OnClick",function() TD.game.pendingMapIndex=idx; TD.ShowEquip() end); cards[idx]=cd
    end; TD.ui.mapCards=cards
    local leg=TD.Lbl(m,12,0.7,0.6,0.45); leg:SetPoint("BOTTOMLEFT",m,"BOTTOMLEFT",8,8); leg:SetText("Hover cards for details")
    local eb=CreateFrame("Button",nil,m,"UIPanelButtonTemplate"); eb:SetSize(140,28); eb:SetPoint("BOTTOMRIGHT",m,"BOTTOMRIGHT",-8,8)
    eb:SetText("Equipment"); eb:SetScript("OnClick",function() TD.game.pendingMapIndex=nil; TD.ShowEquip() end) end

function TD.RefreshMenu() if not TD.ui.mapCards then return end
    for idx,cd in ipairs(TD.ui.mapCards) do local md=TD.MAPS[idx]; local p=TD.GetMapProgress(md.id)
        if p.completed then cd.progL:SetText("|cff33cc33DONE|r") elseif p.bestWave>0 then cd.progL:SetText("W"..p.bestWave.."/"..md.totalWaves) else cd.progL:SetText("--") end
        cd.starsL:SetText(Stars(p.stars or 0)) end end

-- ============================================================
-- EQUIP (fixed widths, taller containers)
-- ============================================================
function TD.CreateEquip() if TD.frames.equipFrame then return end
    local ef=CreateFrame("Frame",nil,TD.frames.main); ef:SetPoint("TOPLEFT",14,-14); ef:SetPoint("BOTTOMRIGHT",-14,14); ef:Hide(); TD.frames.equipFrame=ef
    local iW=FW-220; local pad=math.floor((FW-28-iW)/2)
    local eqT=TD.Lbl(ef,22,0.85,0.7,0.35); eqT:SetPoint("TOP",0,-8); eqT:SetText("Loadout")
    local eqS=TD.Lbl(ef,12,0.7,0.6,0.45); eqS:SetPoint("TOP",0,-30); eqS:SetText("Equip 3 items and choose specializations")
    local slots={}; local slotGap=8; local slotW=math.floor((iW-slotGap*2)/3)
    for s=1,3 do local sf=CreateFrame("Button",nil,ef); sf:SetSize(slotW,56)
        sf:SetPoint("TOPLEFT",ef,"TOPLEFT",pad+(s-1)*(slotW+slotGap),-48)
        sf:SetBackdrop({bgFile=PARCHMENT2,edgeFile=TOOLTIPBDR,edgeSize=14,tile=false,insets={left=3,right=3,top=3,bottom=3}})
        sf:SetBackdropColor(0.6,0.55,0.45,0.95); sf:SetBackdropBorderColor(0.55,0.45,0.3,1)
        local slab=TD.Lbl(sf,10,0.75,0.65,0.5); slab:SetPoint("TOPLEFT",8,-4); slab:SetText("Slot "..s)
        sf.itemL=TD.Lbl(sf,13,0.8,0.65,0.35); sf.itemL:SetPoint("CENTER",0,0); sf.itemL:SetWidth(slotW-20); sf.itemL:SetJustifyH("CENTER")
        sf.descL=TD.Lbl(sf,10,0.75,0.65,0.5); sf.descL:SetPoint("BOTTOM",0,6); sf.descL:SetWidth(slotW-20); sf.descL:SetJustifyH("CENTER")
        sf:SetScript("OnClick",function() if TD.equipSelItem then TD.SetEquipped(s,TD.equipSelItem); TD.equipSelItem=nil; TD.RefreshEquip() end end); slots[s]=sf end; TD.ui.eqSlots=slots
    -- Set bonus display (between slots and scroll)
    TD.ui.setBonusL=TD.Lbl(ef,11,0.6,0.8,0.4); TD.ui.setBonusL:SetPoint("TOP",0,-108); TD.ui.setBonusL:SetWidth(iW)
    -- Scrollable area for items + specs
    local scrollTop=124; local scrollBot=42
    local scrollFrame=CreateFrame("ScrollFrame",nil,ef); scrollFrame:SetPoint("TOPLEFT",ef,"TOPLEFT",pad,-scrollTop); scrollFrame:SetPoint("BOTTOMRIGHT",ef,"BOTTOMRIGHT",-pad,scrollBot)
    local scrollChild=CreateFrame("Frame",nil,scrollFrame); scrollFrame:SetScrollChild(scrollChild)
    local scrollW=iW
    scrollChild:SetWidth(scrollW)
    -- Scroll bar
    local scrollBar=CreateFrame("Slider",nil,scrollFrame); scrollBar:SetWidth(14); scrollBar:SetPoint("TOPRIGHT",scrollFrame,"TOPRIGHT",16,0); scrollBar:SetPoint("BOTTOMRIGHT",scrollFrame,"BOTTOMRIGHT",16,0)
    scrollBar:SetBackdrop({bgFile=DIALOGBG,edgeFile=TOOLTIPBDR,edgeSize=10,tile=true,tileSize=16,insets={left=2,right=2,top=2,bottom=2}})
    scrollBar:SetBackdropColor(0.1,0.1,0.1,0.6); scrollBar:SetBackdropBorderColor(0.3,0.3,0.3,0.5)
    scrollBar:SetThumbTexture(HIGHLIGHT); scrollBar:SetOrientation("VERTICAL")
    scrollBar:SetMinMaxValues(0,1); scrollBar:SetValue(0)
    scrollBar:SetScript("OnValueChanged",function(self,val) scrollFrame:SetVerticalScroll(val) end)
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheelUp",function(self) local cur=scrollBar:GetValue(); scrollBar:SetValue(math.max(0,cur-40)) end)
    scrollFrame:SetScript("OnMouseWheelDown",function(self) local _,mx=scrollBar:GetMinMaxValues(); local cur=scrollBar:GetValue(); scrollBar:SetValue(math.min(mx,cur+40)) end)
    TD.ui.eqScrollBar=scrollBar; TD.ui.eqScrollFrame=scrollFrame; TD.ui.eqScrollChild=scrollChild
    -- Items header
    local invT=TD.Lbl(scrollChild,12,0.7,0.6,0.45); invT:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",4,0); invT:SetText("Items (click to select, then click a slot)")
    TD.ui.itemBtns={}; local icols=4; local bw=math.floor((scrollW-(icols-1)*6)/icols); local bh=48
    for i,itemId in ipairs(TD.ITEM_ORDER) do local ib=CreateFrame("Button",nil,scrollChild); local col=(i-1)%icols; local row=math.floor((i-1)/icols)
        ib:SetSize(bw,bh); ib:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",2+col*(bw+6),-18-row*(bh+4))
        ib:SetBackdrop({bgFile=DIALOGBG,edgeFile=TOOLTIPBDR,edgeSize=12,tile=true,tileSize=32,insets={left=2,right=2,top=2,bottom=2}})
        ib:SetBackdropColor(0.15,0.12,0.1,0.9); ib:SetBackdropBorderColor(0.4,0.35,0.25,0.8)
        local d=TD.ITEM_DEFS[itemId]; local ic=TD.Lbl(ib,16,d.color[1],d.color[2],d.color[3]); ic:SetPoint("TOPLEFT",5,-3); ic:SetText(d.icon)
        ib.nameL=TD.Lbl(ib,10,0.9,0.85,0.7); ib.nameL:SetPoint("TOPLEFT",22,-3); ib.nameL:SetWidth(bw-28); ib.nameL:SetJustifyH("LEFT"); ib.nameL:SetText(d.name)
        local dl=TD.Lbl(ib,9,0.8,0.7,0.55); dl:SetPoint("TOPLEFT",5,-18); dl:SetWidth(bw-10); dl:SetJustifyH("LEFT"); dl:SetText(d.desc)
        ib.statL=TD.Lbl(ib,9,0.75,0.65,0.5); ib.statL:SetPoint("BOTTOM",0,3); ib.itemId=itemId
        ib:SetScript("OnClick",function() if TD.HasItem(itemId) then TD.equipSelItem=itemId; TD.RefreshEquip() end end)
        -- Tooltip with set bonus info
        ib:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:AddLine(d.name,d.color[1],d.color[2],d.color[3]); GameTooltip:AddLine(d.desc,0.9,0.85,0.75)
            local setInfo=TD.GetItemSet(itemId)
            if setInfo then GameTooltip:AddLine(" "); GameTooltip:AddLine(setInfo.name.." (2 Set)",setInfo.color[1],setInfo.color[2],setInfo.color[3])
                for _,sid in ipairs(setInfo.items) do local sd=TD.ITEM_DEFS[sid]; local eq=TD.IsEquipped(sid)
                    if eq then GameTooltip:AddLine("  "..sd.name,0.3,1,0.3) else GameTooltip:AddLine("  "..sd.name,0.5,0.5,0.5) end end
                local bothEq=true; for _,sid in ipairs(setInfo.items) do if not TD.IsEquipped(sid) then bothEq=false end end
                if bothEq then GameTooltip:AddLine("(2) "..setInfo.desc,0.3,1,0.3) else GameTooltip:AddLine("(2) "..setInfo.desc,0.5,0.5,0.5) end
            end; GameTooltip:Show() end)
        ib:SetScript("OnLeave",function() GameTooltip:Hide() end)
        TD.ui.itemBtns[i]=ib end
    local itemRows=math.ceil(#TD.ITEM_ORDER/icols)
    local specY=-18-itemRows*(bh+4)-10
    -- Tower Specializations header
    local spT=TD.Lbl(scrollChild,12,0.7,0.6,0.45); spT:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",4,specY); spT:SetText("Tower Specializations")
    TD.ui.specBtns={}; local sBW=math.floor((scrollW-80)/2); local sBH=42; local sGap=4; local sSY=specY-20
    local iconSz=sBH-10
    for fi,fam in ipairs(TD.FAMILIES) do
        local famL=TD.Lbl(scrollChild,12,fam.color[1],fam.color[2],fam.color[3]); famL:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",4,sSY-(fi-1)*(sBH+sGap)); famL:SetText(fam.name..":")
        for si,specId in ipairs(fam.specs) do local spec=TD.SPECS[specId]; local sb=CreateFrame("Button",nil,scrollChild); sb:SetSize(sBW,sBH)
            sb:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",72+(si-1)*(sBW+8),sSY-(fi-1)*(sBH+sGap))
            sb:SetBackdrop({bgFile=DIALOGBG,edgeFile=TOOLTIPBDR,edgeSize=12,tile=true,tileSize=32,insets={left=2,right=2,top=2,bottom=2}})
            sb:SetBackdropColor(spec.color[1]*0.2,spec.color[2]*0.2,spec.color[3]*0.2,0.9); sb:SetBackdropBorderColor(spec.color[1]*0.6,spec.color[2]*0.6,spec.color[3]*0.6,0.8)
            -- Class icon
            local icon=sb:CreateTexture(nil,"ARTWORK"); icon:SetSize(iconSz,iconSz); icon:SetPoint("LEFT",4,0); icon:SetTexture(TD.CLASS_ICON)
            local coords=TD.CLASS_COORDS[spec.family] or TD.CLASS_COORDS.paladin; icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
            sb.nameL=TD.Lbl(sb,12,0.9,0.85,0.7); sb.nameL:SetPoint("TOPLEFT",iconSz+8,-4); sb.nameL:SetText(spec.letter.." "..spec.name)
            local sdl=TD.Lbl(sb,9,0.8,0.7,0.55); sdl:SetPoint("BOTTOMLEFT",iconSz+8,4); sdl:SetWidth(sBW-iconSz-16); sdl:SetJustifyH("LEFT"); sdl:SetText(spec.desc)
            sb.statL=TD.Lbl(sb,10,0.75,0.65,0.5); sb.statL:SetPoint("RIGHT",-8,5); sb.specId=specId; sb.famId=fam.id
            sb:SetScript("OnClick",function() if TD.IsSpecUnlocked(specId) then TowerDefenseSaved.specs[fam.id]=specId; TD.RefreshEquip() end end)
            sb:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:AddLine(spec.name,spec.color[1],spec.color[2],spec.color[3]); GameTooltip:AddLine(spec.desc,0.9,0.85,0.75)
                if spec.pulse then for ti=1,3 do GameTooltip:AddLine(string.format("T%d: %d dmg to ALL in %d / %.1fs (%dg)",ti,TD.TS(spec,"damage",ti),TD.TS(spec,"range",ti),TD.TS(spec,"cooldown",ti),spec.baseCost+(spec.upgradeCost[ti] or 0)),1,0.8,0.3) end
                elseif spec.aura then for ti=1,3 do GameTooltip:AddLine(string.format("T%d: Rng:%d +%d%% dmg +%d%% spd +%d%% rng (%dg)",ti,TD.TS(spec,"range",ti),TD.TS(spec,"auraDmg",ti)*100,TD.TS(spec,"auraSpd",ti)*100,(TD.TS(spec,"auraRng",ti) or 0)*100,spec.baseCost+(spec.upgradeCost[ti] or 0)),1,0.9,0.4) end
                    GameTooltip:AddLine("Buffed towers glow gold",0.7,0.7,0.4)
                else for ti=1,3 do GameTooltip:AddLine(string.format("T%d: %d dmg, %d rng, %.1fs spd (%dg)",ti,TD.TS(spec,"damage",ti),TD.TS(spec,"range",ti),TD.TS(spec,"cooldown",ti),spec.baseCost+(spec.upgradeCost[ti] or 0)),1,1,1) end end
                if TD.TS(spec,"splash",1)>0 then GameTooltip:AddLine(string.format("Splash: %d/%d/%d radius",TD.TS(spec,"splash",1),TD.TS(spec,"splash",2),TD.TS(spec,"splash",3)),1,0.5,0.2) end
                if TD.TS(spec,"slowPct",1)>0 then GameTooltip:AddLine(string.format("Slow: %d%%/%d%%/%d%% for %.1f/%.1f/%.1fs",TD.TS(spec,"slowPct",1)*100,TD.TS(spec,"slowPct",2)*100,TD.TS(spec,"slowPct",3)*100,TD.TS(spec,"slowDur",1),TD.TS(spec,"slowDur",2),TD.TS(spec,"slowDur",3)),0.4,0.7,1) end
                if TD.TS(spec,"dot",1)>0 then GameTooltip:AddLine(string.format("DoT: %d/%d/%d dps for 3s",TD.TS(spec,"dot",1),TD.TS(spec,"dot",2),TD.TS(spec,"dot",3)),0.7,0.3,0.5) end
                if not TD.IsSpecUnlocked(specId) then GameTooltip:AddLine("|cffff4444LOCKED - complete challenges|r") end; GameTooltip:Show() end)
            sb:SetScript("OnLeave",function() GameTooltip:Hide() end); TD.ui.specBtns[specId]=sb end end
    local palY=sSY-#TD.FAMILIES*(sBH+sGap); local ps=TD.SPECS.paladin
    -- Paladin support row with class icon
    local palRow=CreateFrame("Frame",nil,scrollChild); palRow:SetSize(scrollW,20); palRow:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",4,palY)
    local palIcon=palRow:CreateTexture(nil,"ARTWORK"); palIcon:SetSize(18,18); palIcon:SetPoint("LEFT",0,0); palIcon:SetTexture(TD.CLASS_ICON)
    local palCoords=TD.CLASS_COORDS.paladin; palIcon:SetTexCoord(palCoords[1],palCoords[2],palCoords[3],palCoords[4])
    local palL=TD.Lbl(palRow,12,0.9,0.8,0.3); palL:SetPoint("LEFT",22,0); palL:SetText("Support: "..ps.letter.." "..ps.name.." (hover specs for all tier stats)")
    -- Calculate total content height and set scroll child size
    local totalH=math.abs(palY)+24
    scrollChild:SetHeight(totalH)
    local visH=FH-28-scrollTop-scrollBot
    if totalH>visH then scrollBar:SetMinMaxValues(0,totalH-visH); scrollBar:Show() else scrollBar:SetMinMaxValues(0,0); scrollBar:Hide() end
    -- Bottom buttons (fixed, not scrolling)
    local back=CreateFrame("Button",nil,ef,"UIPanelButtonTemplate"); back:SetSize(130,28); back:SetPoint("BOTTOMLEFT",ef,"BOTTOMLEFT",pad,8)
    back:SetText("Back"); back:SetScript("OnClick",function() TD.equipSelItem=nil; TD.ShowMenu() end)
    TD.ui.eqPlayBtn=CreateFrame("Button",nil,ef,"UIPanelButtonTemplate"); TD.ui.eqPlayBtn:SetSize(160,32); TD.ui.eqPlayBtn:SetPoint("BOTTOMRIGHT",ef,"BOTTOMRIGHT",-pad,8)
    TD.ui.eqPlayBtn:SetText("Start Battle"); TD.ui.eqPlayBtn:SetScript("OnClick",function()
        if TD.game.pendingMapIndex then TD.equipSelItem=nil; TD.StartMap(TD.game.pendingMapIndex) end end) end

function TD.RefreshEquip() TD.EnsureSaved()
    for s=1,3 do local sf=TD.ui.eqSlots[s]; local eqId=TowerDefenseSaved.equipped[s]
        if eqId and TD.ITEM_DEFS[eqId] then local d=TD.ITEM_DEFS[eqId]; sf.itemL:SetText(d.name); sf.itemL:SetTextColor(d.color[1],d.color[2],d.color[3]); sf.descL:SetText(d.desc)
        else sf.itemL:SetText("(empty)"); sf.itemL:SetTextColor(0.5,0.45,0.35); sf.descL:SetText("") end end
    for _,ib in ipairs(TD.ui.itemBtns) do local own=TD.HasItem(ib.itemId); local eq=TD.IsEquipped(ib.itemId); local sel=TD.equipSelItem==ib.itemId
        if not own then ib:SetBackdropColor(0.08,0.07,0.06,0.9); ib:SetBackdropBorderColor(0.2,0.18,0.12,0.5); ib.nameL:SetTextColor(0.45,0.4,0.3); ib.statL:SetText("|cff888866Locked|r")
        elseif sel then ib:SetBackdropBorderColor(1,0.85,0.2,1); ib:SetBackdropColor(0.25,0.2,0.1,0.9); ib.nameL:SetTextColor(1,0.95,0.8); ib.statL:SetText("|cffffff88Click slot|r")
        elseif eq then local d=TD.ITEM_DEFS[ib.itemId]; ib:SetBackdropBorderColor(d.color[1]*0.8,d.color[2]*0.8,d.color[3]*0.8,0.9); ib:SetBackdropColor(0.18,0.15,0.1,0.9); ib.nameL:SetTextColor(0.9,0.85,0.7); ib.statL:SetText("|cff44aa44Equipped|r")
        else ib:SetBackdropColor(0.15,0.12,0.1,0.9); ib:SetBackdropBorderColor(0.4,0.35,0.25,0.8); ib.nameL:SetTextColor(0.8,0.75,0.6); ib.statL:SetText("") end end
    for specId,sb in pairs(TD.ui.specBtns) do local spec=TD.SPECS[specId]; local u=TD.IsSpecUnlocked(specId); local sel=TowerDefenseSaved.specs[sb.famId]==specId
        if not u then sb:SetBackdropColor(0.06,0.05,0.04,0.9); sb:SetBackdropBorderColor(0.15,0.12,0.1,0.5); sb.nameL:SetTextColor(0.45,0.4,0.3); sb.statL:SetText("|cff888866Locked|r")
        elseif sel then sb:SetBackdropBorderColor(1,0.85,0.3,1); sb:SetBackdropColor(spec.color[1]*0.3,spec.color[2]*0.3,spec.color[3]*0.3,0.9); sb.nameL:SetTextColor(1,0.95,0.8); sb.statL:SetText("|cff44aa44Active|r")
        else sb:SetBackdropBorderColor(spec.color[1]*0.5,spec.color[2]*0.5,spec.color[3]*0.5,0.6); sb:SetBackdropColor(spec.color[1]*0.12,spec.color[2]*0.12,spec.color[3]*0.12,0.9); sb.nameL:SetTextColor(0.7,0.65,0.5); sb.statL:SetText("") end end
    if TD.game.pendingMapIndex then TD.ui.eqPlayBtn:SetText("Start Battle"); TD.ui.eqPlayBtn:Enable() else TD.ui.eqPlayBtn:SetText("(pick a map)"); TD.ui.eqPlayBtn:Disable() end
    -- Show active set bonuses
    local st=TD.GetEquippedStats(); local setTxt=""
    if st.activeSets and #st.activeSets>0 then for _,set in ipairs(st.activeSets) do
        if setTxt~="" then setTxt=setTxt.."  " end; setTxt=setTxt.."|cff"..HexC(set.color)..set.name.."|r: "..set.desc end end
    TD.ui.setBonusL:SetText(setTxt) end

function TD.ShowEquip() TD.frames.menuFrame:Hide(); if TD.frames.gameFrame then TD.frames.gameFrame:Hide() end; TD.CreateEquip(); TD.RefreshEquip(); TD.frames.equipFrame:Show(); TD.game.state=TD.S_EQUIP end

-- ============================================================
-- GAME SCREEN
-- ============================================================
function TD.CreateGameScreen() if TD.frames.gameFrame then return end
    local gf=CreateFrame("Frame",nil,TD.frames.main); gf:SetPoint("TOPLEFT",14,-14); gf:SetPoint("BOTTOMRIGHT",-14,14); gf:Hide(); TD.frames.gameFrame=gf
    local ga=CreateFrame("Frame",nil,gf); ga:SetSize(MW,MH); ga:SetPoint("TOPLEFT",gf,"TOPLEFT",2,-(PT-12)); TD.Tex(ga,"BORDER",0.08,0.06,0.04,1):SetAllPoints(); TD.frames.gameArea=ga
    local panel=CreateFrame("Frame",nil,gf); panel:SetSize(PW-18,MH+PT-12); panel:SetPoint("TOPLEFT",ga,"TOPRIGHT",4,PT-12); TD.ui.gamePanel=panel
    panel:SetBackdrop({bgFile=PARCHMENT2,edgeFile=TOOLTIPBDR,edgeSize=14,tile=false,insets={left=3,right=3,top=3,bottom=3}})
    panel:SetBackdropColor(0.75,0.7,0.6,0.95); panel:SetBackdropBorderColor(0.5,0.42,0.3,1)
    local pw=PW-26
    TD.ui.mapTitleL=TD.Lbl(panel,18,0.85,0.7,0.4); TD.ui.mapTitleL:SetPoint("TOP",0,-10)
    TD.ui.goldL=TD.Lbl(panel,16,0.9,0.75,0.15); TD.ui.goldL:SetPoint("TOP",0,-34)
    TD.ui.livesL=TD.Lbl(panel,16,0.3,0.8,0.3); TD.ui.livesL:SetPoint("TOP",0,-56)
    TD.ui.waveL=TD.Lbl(panel,14,0.8,0.7,0.5); TD.ui.waveL:SetPoint("TOP",0,-76)
    TD.ui.flavorL=TD.Lbl(panel,11,0.85,0.55,0.2); TD.ui.flavorL:SetPoint("TOP",0,-94); TD.ui.flavorL:SetWidth(pw)
    TD.ui.eqDisp={}; for s=1,3 do local l=TD.Lbl(panel,10,0.7,0.6,0.4); l:SetPoint("TOPLEFT",panel,"TOPLEFT",10,-108-(s-1)*14); l:SetWidth(pw); l:SetJustifyH("LEFT"); TD.ui.eqDisp[s]=l end
    TD.ui.towerBtns={}
    local sFrame=CreateFrame("Frame",nil,panel); sFrame:SetSize(pw,28); TD.ui.speedFrame=sFrame
    TD.ui.sendBtn=CreateFrame("Button",nil,sFrame,"UIPanelButtonTemplate"); TD.ui.sendBtn:SetSize(pw,26); TD.ui.sendBtn:SetPoint("LEFT",sFrame,"LEFT",0,0)
    TD.ui.sendBtn:SetScript("OnClick",function() local g=TD.game; if g.state==TD.S_IDLE or g.state==TD.S_BREAK then TD.StartWave() end end)
    TD.ui.pauseBtn=CreateFrame("Button",nil,sFrame,"UIPanelButtonTemplate"); TD.ui.pauseBtn:SetSize(50,26); TD.ui.pauseBtn:SetPoint("LEFT",sFrame,"LEFT",0,0); TD.ui.pauseBtn:SetText("||")
    TD.ui.pauseBtn:SetScript("OnClick",function() TD.game.speed=0; TD.game.tracking.neverPaused=false; TD.UpdateSpeedBtns() end)
    TD.ui.playBtn=CreateFrame("Button",nil,sFrame,"UIPanelButtonTemplate"); TD.ui.playBtn:SetSize(50,26); TD.ui.playBtn:SetPoint("LEFT",TD.ui.pauseBtn,"RIGHT",4,0); TD.ui.playBtn:SetText(">")
    TD.ui.playBtn:SetScript("OnClick",function() TD.game.speed=1; TD.UpdateSpeedBtns() end)
    TD.ui.ffBtn=CreateFrame("Button",nil,sFrame,"UIPanelButtonTemplate"); TD.ui.ffBtn:SetSize(60,26); TD.ui.ffBtn:SetPoint("LEFT",TD.ui.playBtn,"RIGHT",4,0); TD.ui.ffBtn:SetText(">>")
    TD.ui.ffBtn:SetScript("OnClick",function() TD.game.speed=2; TD.UpdateSpeedBtns() end)
    -- Auto-wave toggle
    TD.ui.autoBtn=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate"); TD.ui.autoBtn:SetSize(pw,24)
    TD.ui.autoBtn:SetScript("OnClick",function() TD.game.autoWave=not TD.game.autoWave; TD.UpdateHUD() end)
    TD.ui.sellBtn=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate"); TD.ui.sellBtn:SetSize(pw,24)
    TD.ui.sellBtn:SetScript("OnClick",function() local g=TD.game; if g.state==TD.S_OVER or g.state==TD.S_WIN then return end; g.selectedTower=nil; g.sellMode=not g.sellMode; TD.HideUpgrade(); TD.UpdateTowerBtns(); TD.UpdateHUD() end)
    TD.ui.menuBtn=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate"); TD.ui.menuBtn:SetSize(pw,24); TD.ui.menuBtn:SetText("Back to Menu"); TD.ui.menuBtn:SetScript("OnClick",function() TD.ShowMenu() end)
    -- Status label with tooltip on hover
    TD.ui.statusFrame=CreateFrame("Frame",nil,panel); TD.ui.statusFrame:SetSize(pw,20)
    TD.ui.statusL=TD.Lbl(TD.ui.statusFrame,13,0.9,0.3,0.2); TD.ui.statusL:SetWidth(pw); TD.ui.statusL:SetAllPoints()
    TD.ui.statusFrame:SetScript("OnEnter",function(self) local g=TD.game; if g.state~=TD.S_PLAY then return end; local info=g.waveList[g.wave]; if not info then return end
        GameTooltip:SetOwner(self,"ANCHOR_LEFT"); GameTooltip:AddLine("Wave "..g.wave.." Info",0.9,0.8,0.5)
        if info.gimmickTag then local clean=info.gimmickTag:gsub("|c%x%x%x%x%x%x%x%x",""):gsub("|r",""):gsub("|H.-|h",""):gsub("|h","")
            GameTooltip:AddLine(clean,1,0.8,0.3); local gi=TD.GIMMICK_INFO[clean]; if gi then GameTooltip:AddLine(gi,0.9,0.85,0.75,true) end end
        if g.waveImmunity then local immN={noslow="Slow Immune",nomagic="Magic Immune",nophysic="Physical Immune",nodot="DoT Immune",noaoe="AoE Immune"}
            GameTooltip:AddLine(immN[g.waveImmunity] or g.waveImmunity,1,0.4,0.4) end
        if info.isBurst then GameTooltip:AddLine("BURST: 2.5x faster spawn rate",1,0.6,0) end; GameTooltip:Show() end)
    TD.ui.statusFrame:SetScript("OnLeave",function() GameTooltip:Hide() end)
    -- Wave preview
    local pvf=InsetPanel(panel,pw,110); pvf:SetPoint("BOTTOMLEFT",panel,"BOTTOMLEFT",6,6)
    local pvTitle=TD.Lbl(pvf,13,0.6,0.75,0.8); pvTitle:SetPoint("TOP",0,-6); pvTitle:SetText("Upcoming Waves")
    TD.ui.pvLines={}; for i=1,5 do local ln=TD.Lbl(pvf,11,0.8,0.75,0.6); ln:SetPoint("TOPLEFT",pvf,"TOPLEFT",8,-24-(i-1)*16); ln:SetWidth(pw-20); ln:SetJustifyH("LEFT"); TD.ui.pvLines[i]=ln end
    -- Upgrade popup with parchment bg
    local uf=CreateFrame("Frame",nil,ga); uf:SetSize(220,135); uf:SetFrameStrata("DIALOG")
    uf:SetBackdrop({bgFile=PARCHMENT2,edgeFile=GOLDBDR,edgeSize=24,tile=false,insets={left=6,right=6,top=6,bottom=6}})
    uf:SetBackdropColor(1,1,1,1); uf:SetBackdropBorderColor(1,1,1,1); uf:Hide(); uf:EnableMouse(true)
    uf.titleL=TD.Lbl(uf,16,0.8,0.6,0.2); uf.titleL:SetPoint("TOP",0,-12)
    uf.infoL=TD.Lbl(uf,11,0.6,0.5,0.3); uf.infoL:SetPoint("TOP",0,-32); uf.infoL:SetWidth(200)
    uf.upBtn=CreateFrame("Button",nil,uf,"UIPanelButtonTemplate"); uf.upBtn:SetSize(150,24); uf.upBtn:SetPoint("BOTTOM",0,36)
    uf.slBtn=CreateFrame("Button",nil,uf,"UIPanelButtonTemplate"); uf.slBtn:SetSize(150,24); uf.slBtn:SetPoint("BOTTOM",0,8); uf.slBtn:SetText("Sell"); TD.frames.upgradeFrame=uf end

function TD.UpdateSpeedBtns() local s=TD.game.speed
    TD.ui.pauseBtn:SetText(s==0 and "|cffffffff|||r|cffffffff|||r" or "||"); TD.ui.playBtn:SetText(s==1 and "|cff00ff00>|r" or ">"); TD.ui.ffBtn:SetText(s==2 and "|cff00ff00>>|r" or ">>") end

-- Tower buttons (2-col with class icons + tier tooltip)
function TD.BuildTowerBtns() for _,b in ipairs(TD.ui.towerBtns) do b:Hide() end; wipe(TD.ui.towerBtns)
    local specs=TD.game.activeSpecs; local panel=TD.ui.gamePanel; local pw=PW-26
    local cols=2; local btnW=math.floor((pw-6)/cols); local btnH=48; local gapX=6; local gapY=4; local startY=-152
    for i,spec in ipairs(specs) do local col=(i-1)%cols; local row=math.floor((i-1)/cols)
        local btn=CreateFrame("Button",nil,panel); btn:SetSize(btnW,btnH); btn:SetPoint("TOPLEFT",panel,"TOPLEFT",8+col*(btnW+gapX),startY-row*(btnH+gapY))
        btn:SetBackdrop({bgFile=DIALOGBG,edgeFile=TOOLTIPBDR,edgeSize=12,tile=true,tileSize=32,insets={left=2,right=2,top=2,bottom=2}})
        btn:SetBackdropColor(spec.color[1]*0.25,spec.color[2]*0.25,spec.color[3]*0.25,0.9); btn:SetBackdropBorderColor(spec.color[1]*0.6,spec.color[2]*0.6,spec.color[3]*0.6,0.8)
        local hl=btn:CreateTexture(nil,"HIGHLIGHT"); hl:SetTexture(HIGHLIGHT); hl:SetBlendMode("ADD"); hl:SetAllPoints(); hl:SetAlpha(0.15)
        local icon=btn:CreateTexture(nil,"ARTWORK"); icon:SetSize(btnH-8,btnH-8); icon:SetPoint("LEFT",4,0); icon:SetTexture(TD.CLASS_ICON)
        local coords=TD.CLASS_COORDS[spec.family] or TD.CLASS_COORDS.paladin; icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
        local nl=TD.Lbl(btn,12,1,0.95,0.8); nl:SetPoint("TOPLEFT",btnH-2,-6); nl:SetWidth(btnW-btnH-6); nl:SetJustifyH("LEFT"); nl:SetText(spec.name)
        local cl=TD.Lbl(btn,11,0.9,0.75,0.2); cl:SetPoint("BOTTOMLEFT",btnH-2,6); cl:SetText(spec.baseCost.."g")
        btn.spec=spec; btn.specIdx=i
        btn:SetScript("OnClick",function() local g=TD.game; if g.state==TD.S_OVER or g.state==TD.S_WIN then return end; g.sellMode=false; TD.HideUpgrade()
            if g.selectedTower==i then g.selectedTower=nil else g.selectedTower=i end; TD.UpdateTowerBtns() end)
        btn:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_LEFT"); GameTooltip:AddLine(spec.name,spec.color[1],spec.color[2],spec.color[3]); GameTooltip:AddLine(spec.desc,0.9,0.85,0.75)
            if spec.pulse then for ti=1,3 do GameTooltip:AddLine(string.format("T%d: %d dmg ALL in %d / %.1fs",ti,TD.TS(spec,"damage",ti),TD.TS(spec,"range",ti),TD.TS(spec,"cooldown",ti)),1,0.8,0.3) end
            elseif spec.aura then for ti=1,3 do GameTooltip:AddLine(string.format("T%d: Rng:%d +%d%% dmg +%d%% spd",ti,TD.TS(spec,"range",ti),TD.TS(spec,"auraDmg",ti)*100,TD.TS(spec,"auraSpd",ti)*100),1,0.9,0.4) end; GameTooltip:AddLine("Buffed towers glow gold",0.7,0.7,0.4)
            else for ti=1,3 do GameTooltip:AddLine(string.format("T%d: %d dmg %d rng %.1fs",ti,TD.TS(spec,"damage",ti),TD.TS(spec,"range",ti),TD.TS(spec,"cooldown",ti)),1,1,1) end end
            if TD.TS(spec,"splash",1)>0 then GameTooltip:AddLine("Splash AoE",1,0.5,0.2) end; if TD.TS(spec,"slowPct",1)>0 then GameTooltip:AddLine("Slows enemies",0.4,0.7,1) end
            if TD.TS(spec,"dot",1)>0 then GameTooltip:AddLine("DoT effect",0.7,0.3,0.5) end; GameTooltip:Show() end)
        btn:SetScript("OnLeave",function() GameTooltip:Hide() end); TD.ui.towerBtns[i]=btn end
    local nRows=math.ceil(#specs/cols); local yBase=startY-nRows*(btnH+gapY)-8
    TD.ui.speedFrame:ClearAllPoints(); TD.ui.speedFrame:SetPoint("TOP",panel,"TOP",0,yBase)
    TD.ui.autoBtn:ClearAllPoints(); TD.ui.autoBtn:SetPoint("TOP",panel,"TOP",0,yBase-30)
    TD.ui.sellBtn:ClearAllPoints(); TD.ui.sellBtn:SetPoint("TOP",panel,"TOP",0,yBase-56)
    TD.ui.menuBtn:ClearAllPoints(); TD.ui.menuBtn:SetPoint("TOP",panel,"TOP",0,yBase-82)
    TD.ui.statusFrame:ClearAllPoints(); TD.ui.statusFrame:SetPoint("TOP",panel,"TOP",0,yBase-110) end

function TD.UpdateTowerBtns() for i,btn in ipairs(TD.ui.towerBtns) do local spec=btn.spec
    if TD.game.selectedTower==i then btn:SetBackdropBorderColor(1,0.85,0.2,1) else btn:SetBackdropBorderColor(spec.color[1]*0.6,spec.color[2]*0.6,spec.color[3]*0.6,0.8) end end end

-- Upgrade popup shows paladin buff
function TD.ShowUpgrade(tower)
    local uf=TD.frames.upgradeFrame; local spec=TD.game.activeSpecs[tower.specIdx]; local t=tower.tier; local st=TD.game.equippedStats
    local dmg,rng,cd=TD.TowerEffective(tower)
    uf.titleL:SetText(spec.name.." T"..t); local info
    if spec.pulse then info=string.format("Pulse %d ALL | Rng:%d | %.2fs",dmg,rng,cd)
    elseif spec.aura then info=string.format("Aura Rng:%d\n+%d%% dmg +%d%% spd",rng,TD.TS(spec,"auraDmg",t)*100,TD.TS(spec,"auraSpd",t)*100)
    else info=string.format("Dmg:%d  Rng:%d  Spd:%.2fs",dmg,rng,cd) end
    local boon=TD.currentBoonGrid[tower.col..","..tower.row]; if boon then info=info.."\n|cffffd700"..TD.BOON_DEFS[boon].name.."|r" end
    -- Show paladin buff if any
    local pD,pS,pR=TD.GetPaladinBuff(tower); if pD>0 or pS>0 then info=info.."\n|cffffff88Paladin: +"..(math.floor(pD*100)).."%dmg +"..(math.floor(pS*100)).."%spd|r" end
    uf.infoL:SetText(info)
    if t<3 then local cost=spec.upgradeCost[t+1]; if st.upgradeCostMult then cost=math.floor(cost*st.upgradeCostMult) end
        uf.upBtn:SetText("T"..(t+1).." ("..cost.."g)"); uf.upBtn:Show()
        uf.upBtn:SetScript("OnClick",function() if TD.game.gold>=cost then TD.game.gold=TD.game.gold-cost; TD.game.tracking.goldSpent=TD.game.tracking.goldSpent+cost
            tower.tier=t+1; tower.cooldownTimer=0; tower.frame.tierL:SetText("T"..tower.tier); TD.ShowUpgrade(tower); TD.UpdateHUD() end end)
        uf:SetHeight(135) else uf.upBtn:Hide(); uf:SetHeight(110) end
    uf.slBtn:SetText("Sell ("..TD.SellValue(tower).."g)"); uf.slBtn:SetScript("OnClick",function() TD.SellTower(tower); uf:Hide() end)
    uf:ClearAllPoints(); uf:SetPoint("BOTTOM",tower.frame,"TOP",0,8); uf:Show(); TD.activeTowerPanel=tower end

function TD.HideUpgrade() if TD.frames.upgradeFrame then TD.frames.upgradeFrame:Hide() end; TD.activeTowerPanel=nil end
function TD.SellValue(tower) local spec=TD.game.activeSpecs[tower.specIdx]; local total=spec.baseCost; for t=2,tower.tier do total=total+(spec.upgradeCost[t] or 0) end
    local pct=0.5; local st=TD.game.equippedStats; if st and st.sellMult then pct=st.sellMult end; return math.floor(total*pct) end
function TD.SellTower(tower) TD.game.gold=TD.game.gold+TD.SellValue(tower); TD.game.tracking.sellCount=TD.game.tracking.sellCount+1; tower.frame:Hide()
    for i,t in ipairs(TD.game.towers) do if t==tower then table.remove(TD.game.towers,i); break end end; TD.UpdateHUD() end

-- Grid (no flanking)
function TD.CreateGrid() local ga=TD.frames.gameArea; wipe(TD.frames.cells); for _,ch in ipairs({ga:GetChildren()}) do ch:Hide() end
    local th=TD.game.currentMap.theme
    for r=1,ROWS do for c=1,COLS do local cell=CreateFrame("Button",nil,ga); cell:SetSize(C-1,C-1); cell:SetPoint("TOPLEFT",ga,"TOPLEFT",(c-1)*C,-((r-1)*C))
        cell.col=c; cell.row=r; cell.bg=TD.Tex(cell,"BACKGROUND",0,0,0,1); cell.bg:SetAllPoints()
        local k=c..","..r; local isTrigger=TD.currentTriggerGrid[k]
        if TD.currentPathGrid[k] then cell.bg:SetVertexColor(th.path[1],th.path[2],th.path[3],1)
            if isTrigger then local tm=TD.Lbl(cell,16,1,0.2,0.8); tm:SetPoint("CENTER"); tm:SetText("X"); tm:SetAlpha(0.6) end
        elseif TD.currentBlockedGrid[k] then cell.bg:SetVertexColor(th.blocked[1],th.blocked[2],th.blocked[3],1)
            local bc=TD.Lbl(cell,14,th.blocked[1]*0.6,th.blocked[2]*0.6,th.blocked[3]*0.6); bc:SetPoint("CENTER"); bc:SetText(th.bChar); bc:SetAlpha(0.5)
        elseif TD.currentBoonGrid[k] then local bd=TD.BOON_DEFS[TD.currentBoonGrid[k]]
            cell.bg:SetVertexColor(bd.color[1]*0.5+th.ground[1]*0.5,bd.color[2]*0.5+th.ground[2]*0.5,bd.color[3]*0.5+th.ground[3]*0.5,1)
            local bl=TD.Lbl(cell,14,bd.color[1],bd.color[2],bd.color[3]); bl:SetPoint("CENTER"); bl:SetText(bd.char); bl:SetAlpha(0.7)
        else cell.bg:SetVertexColor(th.ground[1],th.ground[2],th.ground[3],1) end
        cell:SetScript("OnClick",function(self) local g=TD.game; if g.state==TD.S_OVER or g.state==TD.S_WIN then return end
            local ck=self.col..","..self.row; TD.HideUpgrade()
            if TD.currentPathGrid[ck] or TD.currentBlockedGrid[ck] then return end
            if g.sellMode then for _,t in ipairs(g.towers) do if t.col==self.col and t.row==self.row then TD.SellTower(t); return end end; return end
            if g.selectedTower then for _,t in ipairs(g.towers) do if t.col==self.col and t.row==self.row then return end end
                local spec=g.activeSpecs[g.selectedTower]
                if g.gold>=spec.baseCost then g.gold=g.gold-spec.baseCost; g.tracking.goldSpent=g.tracking.goldSpent+spec.baseCost; TD.PlaceTower(g.selectedTower,self.col,self.row)
                    local tc=0; for _ in ipairs(g.towers) do tc=tc+1 end; if tc>g.tracking.maxTowers then g.tracking.maxTowers=tc end; TD.UpdateHUD() end end end)
        cell:SetScript("OnEnter",function(self) local ck=self.col..","..self.row
            if TD.currentBoonGrid[ck] then local bd=TD.BOON_DEFS[TD.currentBoonGrid[ck]]; GameTooltip:SetOwner(self,"ANCHOR_CURSOR"); GameTooltip:AddLine(bd.name,bd.color[1],bd.color[2],bd.color[3]); GameTooltip:AddLine(bd.desc,0.8,0.8,0.8); GameTooltip:Show()
            elseif TD.currentBlockedGrid[ck] then GameTooltip:SetOwner(self,"ANCHOR_CURSOR"); GameTooltip:AddLine(th.bName,th.blocked[1],th.blocked[2],th.blocked[3]); GameTooltip:AddLine("Cannot build",0.6,0.6,0.6); GameTooltip:Show()
            elseif TD.currentTriggerGrid[ck] then GameTooltip:SetOwner(self,"ANCHOR_CURSOR"); GameTooltip:AddLine("Boss Trigger",1,0.2,0.8)
                local bId=TD.game.currentMap and TD.game.currentMap.boss; if bId and TD.BOSS_DEFS[bId] then GameTooltip:AddLine(TD.BOSS_DEFS[bId].name.." activates here",0.8,0.6,0.9) end; GameTooltip:Show() end
            if TD.game.selectedTower and not TD.currentPathGrid[ck] and not TD.currentBlockedGrid[ck] then
                local spec=TD.game.activeSpecs[TD.game.selectedTower]; local rng=TD.TS(spec,"range",1); local st=TD.game.equippedStats
                if st.rangeMult then rng=rng*st.rangeMult end; local boon=TD.currentBoonGrid[ck]; if boon and TD.BOON_DEFS[boon].rngMult then rng=rng*TD.BOON_DEFS[boon].rngMult end
                TD.ShowRange(self.col,self.row,rng) end end)
        cell:SetScript("OnLeave",function() GameTooltip:Hide(); if TD.frames.rangeCircle and not TD.activeTowerPanel then TD.frames.rangeCircle:Hide() end end)
        TD.frames.cells[k]=cell end end end

function TD.ShowRange(col,row,rng) if not TD.frames.rangeCircle then local rc=CreateFrame("Frame",nil,TD.frames.gameArea); rc:SetFrameLevel(TD.frames.gameArea:GetFrameLevel()+10); TD.CirTex(rc,"OVERLAY",1,1,1,0.14):SetAllPoints(); TD.frames.rangeCircle=rc end
    local cx,cy=TD.CC(col,row); TD.frames.rangeCircle:SetSize(rng*2,rng*2); TD.frames.rangeCircle:ClearAllPoints(); TD.frames.rangeCircle:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",cx,-cy); TD.frames.rangeCircle:Show() end

function TD.UpdateHUD() local g=TD.game
    TD.ui.goldL:SetText("Gold: "..g.gold); TD.ui.livesL:SetText("Lives: "..g.lives)
    TD.ui.waveL:SetText("Wave: "..g.wave.." / "..g.totalWaves); TD.ui.flavorL:SetText(g.currentMap and g.currentMap.flavor or "")
    for s=1,3 do local eqId=TowerDefenseSaved.equipped[s]; local d=TD.ITEM_DEFS[eqId or ""]; TD.ui.eqDisp[s]:SetText(d and ("|cff"..HexC(d.color)..d.icon.."|r "..d.name) or "") end
    local showSend=(g.state==TD.S_IDLE or g.state==TD.S_BREAK); local showSpeed=(g.state==TD.S_PLAY)
    if showSend then TD.ui.sendBtn:Show() else TD.ui.sendBtn:Hide() end
    if showSpeed then TD.ui.pauseBtn:Show(); TD.ui.playBtn:Show(); TD.ui.ffBtn:Show() else TD.ui.pauseBtn:Hide(); TD.ui.playBtn:Hide(); TD.ui.ffBtn:Hide() end
    TD.ui.autoBtn:SetText(g.autoWave and "|cff33cc33Auto Wave ON|r" or "Auto Wave OFF")
    if g.state==TD.S_IDLE then TD.ui.sendBtn:SetText("Send Wave 1"); TD.ui.statusL:SetText("")
    elseif g.state==TD.S_BREAK then TD.ui.sendBtn:SetText("Send Wave "..(g.wave+1)); TD.ui.statusL:SetText("")
    elseif g.state==TD.S_PLAY then TD.UpdateSpeedBtns(); local info=g.waveList[g.wave]; local status=(info and info.gimmickTag) or ""
        if g.waveImmunity then local immN={noslow="Slow Immune",nomagic="Magic Immune",nophysic="Phys Immune",nodot="DoT Immune",noaoe="AoE Immune"}
            if status~="" then status=status.." " end; status=status.."|cffee4444"..(immN[g.waveImmunity] or g.waveImmunity).."|r" end; TD.ui.statusL:SetText(status)
    elseif g.state==TD.S_OVER then TD.ui.statusL:SetText("|cffee4444Defeated W"..g.wave.."|r")
    elseif g.state==TD.S_WIN then TD.ui.statusL:SetText("|cff33cc33Map Complete!|r") end
    TD.ui.sellBtn:SetText(g.sellMode and "|cffcc3333Sell ON|r" or "Sell Mode")
    local lines=TD.WavePreview(g.waveList,g.wave,5); for i=1,5 do TD.ui.pvLines[i]:SetText(lines[i] or "") end end

function TD.ShowMenu() TD.HideUpgrade(); TD.game.state=TD.S_MENU
    if TD.frames.gameFrame then TD.frames.gameFrame:Hide() end; if TD.frames.equipFrame then TD.frames.equipFrame:Hide() end
    for _,e in ipairs(TD.game.enemies) do if e.frame then e.frame:Hide() end end; for _,p in ipairs(TD.game.projectiles) do if p.frame then p.frame:Hide() end end
    for _,tf in ipairs(TD.frames.towerFrames or {}) do tf:Hide() end; wipe(TD.game.enemies); wipe(TD.game.projectiles); wipe(TD.frames.towerFrames or {})
    if TD.frames.rangeCircle then TD.frames.rangeCircle:Hide() end; TD.RefreshMenu(); TD.frames.menuFrame:Show(); TD.frames.main:Show() end
function TD.ShowGame() TD.frames.menuFrame:Hide(); if TD.frames.equipFrame then TD.frames.equipFrame:Hide() end; TD.frames.gameFrame:Show(); TD.frames.main:Show() end

function TD.PlaceTower(specIdx,col,row)
    local spec=TD.game.activeSpecs[specIdx]; local cx,cy=TD.CC(col,row)
    local tf=CreateFrame("Button",nil,TD.frames.gameArea); tf:SetSize(C-6,C-6); tf:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",cx,-cy); tf:SetFrameLevel(TD.frames.gameArea:GetFrameLevel()+5)
    TD.Tex(tf,"BACKGROUND",spec.color[1],spec.color[2],spec.color[3],0.75):SetAllPoints()
    local tl=TD.Lbl(tf,18,1,1,1); tl:SetPoint("CENTER",0,4); tl:SetText(spec.letter)
    tf.tierL=TD.Lbl(tf,11,0.9,0.85,0.5); tf.tierL:SetPoint("BOTTOM",0,2); tf.tierL:SetText("T1")
    local boon=TD.currentBoonGrid[col..","..row]
    if boon then local bd=TD.BOON_DEFS[boon]; local bc=TD.Lbl(tf,10,bd.color[1],bd.color[2],bd.color[3]); bc:SetPoint("TOPRIGHT",-2,-2); bc:SetText(bd.char) end
    local tower={specIdx=specIdx,col=col,row=row,cx=cx,cy=cy,tier=1,cooldownTimer=0,frame=tf}
    tf:SetScript("OnClick",function() local g=TD.game; if g.state==TD.S_OVER or g.state==TD.S_WIN then return end
        if g.sellMode then TD.SellTower(tower) else g.selectedTower=nil; TD.UpdateTowerBtns(); TD.ShowUpgrade(tower)
            local rng=TD.TS(spec,"range",tower.tier); local st=g.equippedStats; if st.rangeMult then rng=rng*st.rangeMult end
            if boon and TD.BOON_DEFS[boon].rngMult then rng=rng*TD.BOON_DEFS[boon].rngMult end; TD.ShowRange(col,row,rng) end end)
    tf:SetScript("OnEnter",function() local rng=TD.TS(spec,"range",tower.tier); local st=TD.game.equippedStats
        if st.rangeMult then rng=rng*st.rangeMult end; if boon and TD.BOON_DEFS[boon].rngMult then rng=rng*TD.BOON_DEFS[boon].rngMult end; TD.ShowRange(col,row,rng) end)
    tf:SetScript("OnLeave",function() if TD.frames.rangeCircle and not TD.activeTowerPanel then TD.frames.rangeCircle:Hide() end end)
    table.insert(TD.game.towers,tower); if not TD.frames.towerFrames then TD.frames.towerFrames={} end; table.insert(TD.frames.towerFrames,tf) end
