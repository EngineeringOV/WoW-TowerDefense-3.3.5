TD.currentPathCells={}; TD.currentPathPoints={}

function TD.StartMap(mapIndex)
    local md=TD.MAPS[mapIndex]; if not md then return end; local g=TD.game
    g.currentMap=md; g.state=TD.S_IDLE; g.speed=1; g.equippedStats=TD.GetEquippedStats(); g.activeSpecs=TD.GetActiveSpecs()
    g.gold=md.startGold+(g.equippedStats.bonusGold or 0); g.lives=md.startLives+(g.equippedStats.bonusLives or 0)
    g.wave=0; g.totalWaves=md.totalWaves; g.selectedTower=nil; g.sellMode=false; g.spawnTimer=0; g.breakTimer=0
    g.tracking={livesLost=0,maxTowers=0,sellCount=0,skippedAll=true,neverPaused=true,goldSpent=0,latelivesLost=0}; g.waveImmunity=nil
    wipe(g.towers); for _,e in ipairs(g.enemies) do if e.frame then e.frame:Hide() end end; wipe(g.enemies)
    for _,p in ipairs(g.projectiles) do if p.frame then p.frame:Hide() end end; wipe(g.projectiles); wipe(g.spawnQueue)
    if TD.frames.towerFrames then for _,tf in ipairs(TD.frames.towerFrames) do tf:Hide() end; wipe(TD.frames.towerFrames) else TD.frames.towerFrames={} end
    g.waveList=TD.GenerateWaves(g.totalWaves,md)
    TD.currentPathCells,TD.currentPathPoints,TD.currentPathGrid=TD.BuildPath(md)
    TD.currentBlockedGrid=TD.BuildBlocked(md,TD.currentPathGrid)
    TD.currentBoonGrid=TD.BuildBoons(md,TD.currentPathGrid,TD.currentBlockedGrid)
    TD.currentTriggerGrid=TD.BuildTriggers(md,TD.currentPathGrid)
    TD.CreateGrid(); TD.HideUpgrade(); TD.BuildTowerBtns(); TD.ui.mapTitleL:SetText(md.name); TD.UpdateHUD(); TD.ShowGame()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r "..TD.MapLink(md.id).." ("..md.difficulty..") - "..g.totalWaves.." waves")
    if md.boss and TD.BOSS_DEFS[md.boss] then DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r Boss: "..TD.BossLink(md.boss).." - "..TD.BOSS_DEFS[md.boss].desc) end
end

function TD.StartWave()
    local g=TD.game; g.wave=g.wave+1; g.speed=1
    if g.wave>g.totalWaves then g.state=TD.S_WIN; TD.SaveMapProgress(g.currentMap.id,g.wave-1,g.totalWaves,g.lives,g.currentMap.startLives)
        TD.CheckChallenges(g.currentMap,g.tracking); TD.UpdateHUD(); return end
    local wi=g.waveList[g.wave]; wipe(g.spawnQueue); g.waveImmunity=wi.immunity
    for _,tn in ipairs(wi.enemies) do g.spawnQueue[#g.spawnQueue+1]={typeName=tn,hpScale=wi.hpScale,immunity=wi.immunity} end
    if wi.spawnMapBoss then local bId=wi.bossId or g.currentMap.boss; if bId then g.spawnQueue[#g.spawnQueue+1]={typeName="_mapboss",hpScale=wi.hpScale,immunity=nil,bossId=bId} end end
    -- Ambush: half the non-boss enemies spawn mid-path
    local md=g.currentMap; local ambushTag=""
    if md.ambushWaypointIdx and md.ambushWaves then local isAmb=false
        for _,aw in ipairs(md.ambushWaves) do if aw==g.wave then isAmb=true; break end end
        if isAmb then for i,entry in ipairs(g.spawnQueue) do
            if not entry.bossId and i%2==0 then entry.ambushIdx=md.ambushWaypointIdx end end
            ambushTag=" |cff00ccff[AMBUSH]|r" end end
    g.spawnTimer=0; g.state=TD.S_PLAY; g.sellMode=false; TD.UpdateHUD()
    local tag=wi.gimmickTag and (" - "..wi.gimmickTag) or ""; local burst=wi.isBurst and " |cffff8800[BURST]|r" or ""
    local bossTag=""; if wi.spawnMapBoss then local bId=wi.bossId or g.currentMap.boss; if bId and TD.BOSS_DEFS[bId] then bossTag=" "..TD.BossLink(bId) end end
    DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff00ccff[TD]|r W%d/%d (%d)%s%s%s%s",g.wave,g.totalWaves,#g.spawnQueue,tag,burst,bossTag,ambushTag))
end

function TD.GetSpawnInterval() local g=TD.game; local base=TD.SPAWN_CD; local md=g.currentMap
    if md and md.spawnMult then base=base*md.spawnMult end
    local wi=g.waveList[g.wave]; if wi and wi.isBurst then base=base*0.4 end; if base<0.15 then base=0.15 end; return base end

-- Enemy spawn
local function GetEF()
    for _,ef in ipairs(TD.frames.enemyPool) do if not ef:IsShown() then return ef end end
    local ga=TD.frames.gameArea; local ef=CreateFrame("Frame",nil,ga); ef:SetFrameLevel(ga:GetFrameLevel()+8)
    ef.body=TD.Tex(ef,"ARTWORK",1,1,1,1); ef.body:SetAllPoints()
    ef.hpBg=TD.Tex(ef,"OVERLAY",0.2,0.2,0.2,0.8); ef.hpBg:SetHeight(5); ef.hpBg:SetPoint("BOTTOMLEFT",ef,"TOPLEFT",0,3); ef.hpBg:SetPoint("BOTTOMRIGHT",ef,"TOPRIGHT",0,3)
    ef.hpBar=TD.Tex(ef,"OVERLAY",0,1,0,1); ef.hpBar:SetHeight(5); ef.hpBar:SetPoint("LEFT",ef.hpBg,"LEFT")
    ef.immBar=TD.Tex(ef,"OVERLAY",0.8,0.2,0.2,0); ef.immBar:SetHeight(3); ef.immBar:SetPoint("TOPLEFT",ef,"BOTTOMLEFT",0,-1); ef.immBar:SetPoint("TOPRIGHT",ef,"BOTTOMRIGHT",0,-1)
    -- Flash overlay for pulse/splash hit
    ef.flash=TD.Tex(ef,"OVERLAY",1,1,1,0); ef.flash:SetAllPoints()
    -- HP number text (for "numbers" health display mode)
    ef.hpText=TD.Lbl(ef,8,1,1,1); ef.hpText:SetPoint("TOP",ef,"BOTTOM",0,-1); ef.hpText:Hide()
    TD.frames.enemyPool[#TD.frames.enemyPool+1]=ef; return ef end

local function DeepCopyAbilities(abilities) local out={}; for _,a in ipairs(abilities) do local copy={}; for k,v in pairs(a) do copy[k]=v end; out[#out+1]=copy end; return out end

function TD.SpawnEnemy(tn,hpScale,immunity,startIdx)
    local d=TD.ENEMY_DEFS[tn]; if not d then return end
    local ef=GetEF(); ef:SetSize(d.size,d.size); ef.body:SetVertexColor(d.color[1],d.color[2],d.color[3],1)
    local si=startIdx or 1; local sp=TD.currentPathPoints[si]; if not sp then sp=TD.currentPathPoints[1]; si=1 end
    ef:ClearAllPoints(); ef:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",sp.x,-sp.y); ef:Show()
    local mhp=math.floor(d.hp*hpScale); local spd=d.speed; if TD.game.currentMap and TD.game.currentMap.speedMult then spd=spd*TD.game.currentMap.speedMult end
    if immunity then ef.immBar:SetAlpha(0.8)
        if immunity=="nomagic" then ef.immBar:SetVertexColor(0.4,0.4,1,0.8) elseif immunity=="nophysic" then ef.immBar:SetVertexColor(0.8,0.6,0.2,0.8)
        elseif immunity=="noslow" then ef.immBar:SetVertexColor(0.3,0.8,1,0.8) elseif immunity=="nodot" then ef.immBar:SetVertexColor(0.7,0.3,0.7,0.8)
        elseif immunity=="noaoe" then ef.immBar:SetVertexColor(1,0.5,0.2,0.8) else ef.immBar:SetVertexColor(0.8,0.2,0.2,0.8) end
    else ef.immBar:SetAlpha(0) end
    ef.flash:SetAlpha(0); if ef.nameLabel then ef.nameLabel:SetText(""); ef.nameLabel:Hide() end
    local en={typeName=tn,hp=mhp,maxHP=mhp,speed=spd,baseSpeed=spd,reward=d.reward,
        pathIndex=si+1,x=sp.x,y=sp.y,frame=ef,slowTimer=0,alive=true,dots={},immunity=immunity,isBoss=false,abilities=nil,lastTileKey=nil,flashTimer=0}
    local bw=ef.hpBg:GetWidth(); if bw<1 then bw=d.size end; ef.hpBar:SetWidth(bw)
    TD.game.enemies[#TD.game.enemies+1]=en end

function TD.SpawnMapBoss(bossId,hpScale)
    local bd=TD.BOSS_DEFS[bossId]; if not bd then return end
    local ef=GetEF(); ef:SetSize(bd.size,bd.size); ef.body:SetVertexColor(bd.color[1],bd.color[2],bd.color[3],1)
    local sp=TD.currentPathPoints[1]; ef:ClearAllPoints(); ef:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",sp.x,-sp.y); ef:Show()
    local mhp=math.floor(bd.hp*hpScale); local spd=bd.speed; if TD.game.currentMap and TD.game.currentMap.speedMult then spd=spd*TD.game.currentMap.speedMult end
    if not ef.nameLabel then ef.nameLabel=TD.Lbl(ef,10,1,0.8,1); ef.nameLabel:SetPoint("TOP",ef,"BOTTOM",0,-5) end; ef.nameLabel:SetText(bd.name); ef.nameLabel:Show()
    ef.immBar:SetAlpha(0); ef.flash:SetAlpha(0)
    local en={typeName="_mapboss",hp=mhp,maxHP=mhp,speed=spd,baseSpeed=spd,reward=bd.reward,
        pathIndex=2,x=sp.x,y=sp.y,frame=ef,slowTimer=0,alive=true,dots={},immunity=nil,
        isBoss=true,bossId=bossId,bossName=bd.name,abilities=DeepCopyAbilities(bd.abilities),lastTileKey=nil,
        enraged=false,metamorphed=false,vanished=false,flashTimer=0}
    for _,ab in ipairs(en.abilities) do if ab.trigger=="onSpawn" and ab.action=="immunity" then en.immunity=ab.immType end end
    local bw=ef.hpBg:GetWidth(); if bw<1 then bw=bd.size end; ef.hpBar:SetWidth(bw)
    TD.game.enemies[#TD.game.enemies+1]=en; DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(bossId).." has arrived!") end

-- Flash an enemy briefly (pulse/splash hit indicator)
function TD.FlashEnemy(en,r,g,b)
    if not en.frame or not en.frame.flash then return end
    en.frame.flash:SetVertexColor(r or 1,g or 1,b or 1,0.7); en.flashTimer=0.15 end

-- Combat text (floating damage numbers)
TD.frames.combatTextPool={}; TD.combatTexts={}
function TD.SpawnCombatText(x,y,text,r,g,b)
    if not TD.GetSetting("combatText") then return end
    local fs; for _,ct in ipairs(TD.frames.combatTextPool) do if not ct:IsShown() then fs=ct; break end end
    if not fs then fs=TD.Lbl(TD.frames.gameArea,11,1,1,1); fs:SetDrawLayer("OVERLAY",7); TD.frames.combatTextPool[#TD.frames.combatTextPool+1]=fs end
    fs:SetTextColor(r or 1,g or 1,b or 1,1); fs:SetAlpha(1); fs:SetText(text)
    fs:ClearAllPoints(); fs:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",x,-y); fs:Show()
    TD.combatTexts[#TD.combatTexts+1]={fs=fs,x=x,y=y,age=0,maxAge=0.7} end
function TD.UpdateCombatText(elapsed) local rem={}
    for i,ct in ipairs(TD.combatTexts) do ct.age=ct.age+elapsed
        if ct.age>=ct.maxAge then ct.fs:Hide(); rem[#rem+1]=i
        else ct.y=ct.y-35*elapsed; ct.fs:ClearAllPoints(); ct.fs:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",ct.x,-ct.y); ct.fs:SetAlpha(1-(ct.age/ct.maxAge)) end
    end; for i=#rem,1,-1 do table.remove(TD.combatTexts,rem[i]) end end

-- Boss abilities (unchanged logic)
function TD.UpdateBossAbilities(en,elapsed)
    if not en.abilities then return end; local pct=en.hp/en.maxHP; local g=TD.game
    for _,ab in ipairs(en.abilities) do
        if ab.trigger=="onHpPct" and not ab.done and pct<=ab.pct then ab.done=true
            if ab.action=="enrage" then en.baseSpeed=en.baseSpeed*ab.spdMult; en.speed=en.baseSpeed; en.enraged=true; en.dmgReduce=ab.dmgReduce or 0; en.frame.body:SetVertexColor(1,0.3,0.1,1)
                DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(en.bossId).." |cffff4444ENRAGED!|r")
            elseif ab.action=="metamorph" then en.baseSpeed=en.baseSpeed*ab.spdMult; en.speed=en.baseSpeed; en.metamorphed=true; en.regenPct=ab.regenPct; en.immunity="noslow"; en.frame.body:SetVertexColor(0.1,0.9,0.1,1)
                DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(en.bossId).." |cff00ff00METAMORPHOSIS!|r")
            elseif ab.action=="rewind" then en.hp=math.floor(en.maxHP*(ab.healPct or 0.5)); en.frame.body:SetVertexColor(0.9,0.8,0.2,1)
                DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(en.bossId).." |cffffd700REWINDS TIME!|r HP restored to "..math.floor((ab.healPct or 0.5)*100).."%!") end end
        if ab.trigger=="periodic" then ab.timer=(ab.timer or 0)+elapsed
            if ab.action=="shield" and ab.timer>=ab.interval then ab.timer=0; ab.currentCharges=ab.charges; en.shieldCharges=ab.charges end
            if ab.action=="vanish" then if en.vanished then ab.vanishTimer=(ab.vanishTimer or 0)+elapsed
                    if ab.vanishTimer>=ab.dur then en.vanished=false; ab.vanishTimer=0; en.frame:SetAlpha(1) end
                elseif ab.timer>=ab.interval then ab.timer=0; en.vanished=true; ab.vanishTimer=0; en.frame:SetAlpha(0.15) end end
            if ab.action=="bonestorm" and ab.timer>=ab.interval then ab.timer=0
                for _,e in ipairs(g.enemies) do if e.alive then e.speed=e.baseSpeed*ab.spdBuff; e.slowTimer=ab.dur end end
                DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(en.bossId)..": |cffff8800BONE STORM!|r") end end
        if en.metamorphed and en.regenPct then en.hp=math.min(en.maxHP,en.hp+en.maxHP*en.regenPct*elapsed) end end
    local col=math.floor(en.x/TD.CELL)+1; local row=math.floor(en.y/TD.CELL)+1; local tileKey=col..","..row
    if tileKey~=en.lastTileKey then en.lastTileKey=tileKey
        if TD.currentTriggerGrid[tileKey] then for _,ab in ipairs(en.abilities) do
            if ab.trigger=="onTile" and ab.action=="spawnAdds" then local wi=g.waveList[g.wave]
                for i=1,ab.addCount do TD.SpawnEnemy(ab.addType,(wi and wi.hpScale or 1)*(ab.addHpMult or 1),nil) end
                DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(en.bossId).." summons "..ab.addCount.." "..ab.addType.."s!") end end end end end

function TD.BossOnHit(en) if not en.abilities then return end
    for _,ab in ipairs(en.abilities) do if ab.trigger=="onHit" and ab.action=="rally" and math.random()<ab.chance then
        for _,e in ipairs(TD.game.enemies) do if e.alive and e~=en and TD.Dist(en.x,en.y,e.x,e.y)<=ab.radius then e.speed=e.baseSpeed*ab.spdBuff; e.slowTimer=ab.dur end end end end end

-- ============================================================
-- FIXED: Paladin buff now includes boon on paladin's own tile
-- ============================================================
function TD.GetPaladinBuff(tower)
    local db,sb,rb=0,0,0; local st=TD.game.equippedStats
    for _,t in ipairs(TD.game.towers) do local spec=TD.game.activeSpecs[t.specIdx]
        if spec.aura and t~=tower then
            local ar=TD.TS(spec,"range",t.tier)
            if st.rangeMult then ar=ar*st.rangeMult end
            if st.auraRangeMult then ar=ar*st.auraRangeMult end
            -- Apply boon on the PALADIN's tile to its aura range
            local palBoon=TD.currentBoonGrid[t.col..","..t.row]
            if palBoon then local bd=TD.BOON_DEFS[palBoon]; if bd.rngMult then ar=ar*bd.rngMult end end
            if TD.Dist(t.cx,t.cy,tower.cx,tower.cy)<=ar then
                local mult=st.auraMult or 1
                db=db+TD.TS(spec,"auraDmg",t.tier)*mult
                sb=sb+TD.TS(spec,"auraSpd",t.tier)*mult
                rb=rb+(TD.TS(spec,"auraRng",t.tier) or 0)*mult
            end
        end
    end; return db,sb,rb
end

local auraTimer=0
function TD.UpdateAuraVisuals(elapsed) auraTimer=auraTimer+elapsed; if auraTimer<0.5 then return end; auraTimer=auraTimer-0.5
    for _,tower in ipairs(TD.game.towers) do local spec=TD.game.activeSpecs[tower.specIdx]
        if spec.aura then if not tower.frame.auraGlow then tower.frame.auraGlow=TD.Tex(tower.frame,"OVERLAY",1,0.85,0.2,0.4); tower.frame.auraGlow:SetPoint("TOPLEFT",-3,3); tower.frame.auraGlow:SetPoint("BOTTOMRIGHT",3,-3) end; tower.frame.auraGlow:Show()
        else local pD=TD.GetPaladinBuff(tower); if pD>0 then if not tower.frame.auraGlow then tower.frame.auraGlow=TD.Tex(tower.frame,"OVERLAY",1,0.85,0.2,0.3); tower.frame.auraGlow:SetPoint("TOPLEFT",-2,2); tower.frame.auraGlow:SetPoint("BOTTOMRIGHT",2,-2) end; tower.frame.auraGlow:Show()
            else if tower.frame.auraGlow then tower.frame.auraGlow:Hide() end end end end end

-- FIXED: TowerEffective properly stacks paladin + boons
function TD.TowerEffective(tower)
    local spec=TD.game.activeSpecs[tower.specIdx]; local st=TD.game.equippedStats; local t=tower.tier
    local dmg=TD.TS(spec,"damage",t); local rng=TD.TS(spec,"range",t); local cd=TD.TS(spec,"cooldown",t)
    -- Item stats
    if st.dmgMult then dmg=dmg*st.dmgMult end; if st.rangeMult then rng=rng*st.rangeMult end; if st.cdMult then cd=cd*st.cdMult end
    -- Boon on tower's tile
    local boon=TD.currentBoonGrid[tower.col..","..tower.row]
    if boon then local bd=TD.BOON_DEFS[boon]; if bd.dmgMult then dmg=dmg*bd.dmgMult end; if bd.rngMult then rng=rng*bd.rngMult end; if bd.cdMult then cd=cd*bd.cdMult end end
    -- Paladin aura (multiplicative on top of everything)
    local pD,pS,pR=TD.GetPaladinBuff(tower); dmg=dmg*(1+pD); cd=cd/(1+pS); rng=rng*(1+pR)
    if cd<0.1 then cd=0.1 end; return math.floor(dmg+0.5),rng,cd
end

function TD.DamageEnemy(en,damage,tower,isSplash)
    local st=TD.game.equippedStats; local spec=TD.game.activeSpecs[tower.specIdx]; local imm=en.immunity
    if imm=="nomagic" and spec.family=="mage" then return end; if imm=="nophysic" and spec.family=="hunter" then return end
    if en.shieldCharges and en.shieldCharges>0 then
        if not (st.shieldPiercePct and math.random()<st.shieldPiercePct) then en.shieldCharges=en.shieldCharges-1; return end end
    if en.dmgReduce then damage=math.floor(damage*(1-en.dmgReduce)) end
    -- Item damage modifiers
    if st.firstStrikeMult and en.hp>=en.maxHP then damage=math.floor(damage*st.firstStrikeMult) end
    if st.bossDmgMult and en.isBoss then damage=math.floor(damage*st.bossDmgMult) end
    if st.slowedDmgMult and en.slowTimer and en.slowTimer>0 then damage=math.floor(damage*st.slowedDmgMult) end
    if st.executeMult and st.executePct and (en.hp/en.maxHP)<=st.executePct then damage=math.floor(damage*st.executeMult) end
    if st.speedDmgMult and st.speedThreshold and en.baseSpeed>=st.speedThreshold then damage=math.floor(damage*st.speedDmgMult) end
    if st.dmgPerLifeLost and TD.game.tracking.livesLost>0 then damage=math.floor(damage*(1+st.dmgPerLifeLost*TD.game.tracking.livesLost)) end
    if st.critChance and math.random()<st.critChance then damage=math.floor(damage*(st.critMult or 1.5)); TD.FlashEnemy(en,1,1,0.3) end
    if st.doubleHitChance and math.random()<st.doubleHitChance then damage=damage*2; TD.FlashEnemy(en,0.4,0.8,1) end
    en.hp=en.hp-damage; if en.isBoss then TD.BossOnHit(en) end
    TD.SpawnCombatText(en.x+math.random(-8,8),en.y-6,tostring(damage),1,0.9,0.2)
    if en.hp<=0 then en.alive=false; en.frame:Hide()
        local rw=en.reward; if st.goldMult then rw=math.floor(rw*st.goldMult) end
        if st.flatBounty then rw=rw+st.flatBounty end
        if st.splashBounty and isSplash then rw=rw+st.splashBounty end
        if st.bossGoldMult and en.isBoss then rw=math.floor(rw*st.bossGoldMult) end
        TD.game.gold=TD.game.gold+rw
        -- Death splash AoE
        if st.deathSplash and st.deathSplash>0 then local rad=st.deathSplashRadius or 60
            for _,e in ipairs(TD.game.enemies) do if e.alive and e~=en and TD.Dist(en.x,en.y,e.x,e.y)<=rad then
                e.hp=e.hp-st.deathSplash; TD.FlashEnemy(e,1,0.6,0.2) end end end
        if en.isBoss then
            if st.lifeOnBossKill and st.lifeOnBossKill>0 then local maxLives=TD.game.currentMap.startLives+(st.bonusLives or 0)
                TD.game.lives=math.min(TD.game.lives+st.lifeOnBossKill,maxLives)
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[TD]|r Boss killed! +"..st.lifeOnBossKill.." life restored!") end
            DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[BOSS]|r "..TD.BossLink(en.bossId).." defeated! +"..rw..TD.GOLD_ICON) end
    else
        if imm~="noslow" then local ti=tower.tier; local sp=TD.TS(spec,"slowPct",ti); local sd=TD.TS(spec,"slowDur",ti)
            if st.slowDurMult and sd>0 then sd=sd*st.slowDurMult end; if sp>0 then en.speed=en.baseSpeed*(1-sp); en.slowTimer=sd end
            -- Proc slow from item (only if tower doesn't already slow)
            if st.procSlowChance and sp==0 and math.random()<st.procSlowChance then
                en.speed=en.baseSpeed*(1-(st.procSlowPct or 0.20)); en.slowTimer=(st.procSlowDur or 2.0) end end
        if imm~="nodot" then local dot=TD.TS(spec,"dot",tower.tier); if dot>0 then en.dots[#en.dots+1]={dps=dot*(st.dotMult or 1),remaining=3.0} end end
    end end

function TD.UpdateEnemies(elapsed) local g=TD.game; local rem={}
    for i,e in ipairs(g.enemies) do
        if not e.alive then rem[#rem+1]=i else
            if e.slowTimer>0 then e.slowTimer=e.slowTimer-elapsed; if e.slowTimer<=0 then e.speed=e.baseSpeed end end
            local dr={}; for di,dot in ipairs(e.dots) do e.hp=e.hp-dot.dps*elapsed; dot.remaining=dot.remaining-elapsed; if dot.remaining<=0 then dr[#dr+1]=di end end
            for di=#dr,1,-1 do table.remove(e.dots,dr[di]) end
            if e.isBoss then TD.UpdateBossAbilities(e,elapsed) end
            -- Flash timer
            if e.flashTimer and e.flashTimer>0 then e.flashTimer=e.flashTimer-elapsed; if e.flashTimer<=0 then e.frame.flash:SetAlpha(0) end end
            if e.hp<=0 then e.alive=false; e.frame:Hide(); rem[#rem+1]=i
                local rw=e.reward; local est=g.equippedStats
                if est.goldMult then rw=math.floor(rw*est.goldMult) end
                if est.flatBounty then rw=rw+est.flatBounty end
                if est.bossGoldMult and e.isBoss then rw=math.floor(rw*est.bossGoldMult) end
                g.gold=g.gold+rw
                if est.deathSplash and est.deathSplash>0 then local rad=est.deathSplashRadius or 60
                    for _,o in ipairs(g.enemies) do if o.alive and o~=e and TD.Dist(e.x,e.y,o.x,o.y)<=rad then
                        o.hp=o.hp-est.deathSplash; TD.FlashEnemy(o,1,0.6,0.2) end end end
            else local tgt=TD.currentPathPoints[e.pathIndex]
                if not tgt then g.lives=g.lives-1; g.tracking.livesLost=g.tracking.livesLost+1; if g.wave>15 then g.tracking.latelivesLost=g.tracking.latelivesLost+1 end
                    e.alive=false; e.frame:Hide(); rem[#rem+1]=i; if g.lives<=0 then g.state=TD.S_OVER; TD.SaveMapProgress(g.currentMap.id,g.wave,g.totalWaves,0,g.currentMap.startLives) end
                else local dx=tgt.x-e.x; local dy=tgt.y-e.y; local dist=TD.Dist(e.x,e.y,tgt.x,tgt.y); local mv=e.speed*elapsed
                    if mv>=dist then e.x=tgt.x; e.y=tgt.y; e.pathIndex=e.pathIndex+1 else e.x=e.x+(dx/dist)*mv; e.y=e.y+(dy/dist)*mv end
                    e.frame:ClearAllPoints(); e.frame:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",e.x,-e.y)
                    local pct=e.hp/e.maxHP; local hm=TD.GetSetting("healthDisplay")
                    if hm=="bars" then e.frame.hpBg:Show(); e.frame.hpBar:Show(); if e.frame.hpText then e.frame.hpText:Hide() end
                        local bw=e.frame.hpBg:GetWidth()*pct; if bw<1 then bw=1 end; e.frame.hpBar:SetWidth(bw)
                        if pct>0.5 then e.frame.hpBar:SetVertexColor(0,1,0,1) elseif pct>0.25 then e.frame.hpBar:SetVertexColor(1,1,0,1) else e.frame.hpBar:SetVertexColor(1,0,0,1) end
                    elseif hm=="numbers" then e.frame.hpBg:Hide(); e.frame.hpBar:Hide()
                        if e.frame.hpText then e.frame.hpText:SetText(math.floor(e.hp)); e.frame.hpText:Show()
                            if pct>0.5 then e.frame.hpText:SetTextColor(0,1,0) elseif pct>0.25 then e.frame.hpText:SetTextColor(1,1,0) else e.frame.hpText:SetTextColor(1,0,0) end end
                    else e.frame.hpBg:Hide(); e.frame.hpBar:Hide(); if e.frame.hpText then e.frame.hpText:Hide() end end
                end end end
    end; for i=#rem,1,-1 do table.remove(g.enemies,rem[i]) end end

local healTick=0
function TD.UpdateHealers(elapsed) healTick=healTick+elapsed; if healTick<1.5 then return end; healTick=healTick-1.5
    for _,e in ipairs(TD.game.enemies) do if e.alive and e.typeName=="healer" then for _,o in ipairs(TD.game.enemies) do if o.alive and o~=e and TD.Dist(e.x,e.y,o.x,o.y)<=70 then o.hp=math.min(o.maxHP,o.hp+math.floor(o.maxHP*0.03)) end end end end end

-- Projectiles
local function GetPF() for _,pf in ipairs(TD.frames.projPool) do if not pf:IsShown() then return pf end end
    local ga=TD.frames.gameArea; local pf=CreateFrame("Frame",nil,ga); pf:SetSize(8,8); pf:SetFrameLevel(ga:GetFrameLevel()+12)
    pf.tex=TD.Tex(pf,"ARTWORK",1,1,1,1); pf.tex:SetAllPoints(); TD.frames.projPool[#TD.frames.projPool+1]=pf; return pf end

function TD.Fire(tower,target)
    local spec=TD.game.activeSpecs[tower.specIdx]; local pf=GetPF(); pf:ClearAllPoints()
    pf:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",tower.cx,-tower.cy); pf.tex:SetVertexColor(spec.color[1],spec.color[2],spec.color[3],1); pf:Show()
    local dmg,rng,cd=TD.TowerEffective(tower); local splash=TD.TS(spec,"splash",tower.tier); local st=TD.game.equippedStats
    if st.splashMult and splash>0 then splash=splash*st.splashMult end
    TD.game.projectiles[#TD.game.projectiles+1]={frame=pf,x=tower.cx,y=tower.cy,target=target,tower=tower,damage=dmg,splash=splash,active=true} end

function TD.UpdateProjectiles(elapsed) local rem={}; local spd=TD.PROJ_SPEED
    for i,p in ipairs(TD.game.projectiles) do
        if not p.active then rem[#rem+1]=i elseif not p.target.alive then p.frame:Hide(); p.active=false; rem[#rem+1]=i
        elseif p.target.vanished then p.frame:Hide(); p.active=false; rem[#rem+1]=i
        else local tx,ty=p.target.x,p.target.y; local dx=tx-p.x; local dy=ty-p.y; local dist=TD.Dist(p.x,p.y,tx,ty); local mv=spd*elapsed
            if mv>=dist then TD.DamageEnemy(p.target,p.damage,p.tower)
                -- Splash visual: flash hit enemies orange
                if p.splash>0 and p.target.immunity~="noaoe" then
                    for _,e in ipairs(TD.game.enemies) do if e~=p.target and e.alive and e.immunity~="noaoe" and not e.vanished and TD.Dist(tx,ty,e.x,e.y)<=p.splash then
                        TD.DamageEnemy(e,math.floor(p.damage*0.5),p.tower,true); TD.FlashEnemy(e,1,0.5,0) end end
                end
                p.frame:Hide(); p.active=false; rem[#rem+1]=i
            else p.x=p.x+(dx/dist)*mv; p.y=p.y+(dy/dist)*mv; p.frame:ClearAllPoints(); p.frame:SetPoint("CENTER",TD.frames.gameArea,"TOPLEFT",p.x,-p.y) end
        end
    end; for i=#rem,1,-1 do table.remove(TD.game.projectiles,rem[i]) end end

-- Towers (pulse flashes enemies purple)
function TD.UpdateTowers(elapsed)
    for _,tower in ipairs(TD.game.towers) do local spec=TD.game.activeSpecs[tower.specIdx]
        if spec.aura then -- no attack
        elseif spec.pulse then tower.cooldownTimer=tower.cooldownTimer-elapsed
            if tower.cooldownTimer<=0 then local dmg,rng,cd=TD.TowerEffective(tower); local hit=false
                for _,e in ipairs(TD.game.enemies) do if e.alive and not e.vanished then
                    local imm=false; if e.immunity=="nomagic" and spec.family=="mage" then imm=true end; if e.immunity=="nophysic" and spec.family=="hunter" then imm=true end
                    if not imm and TD.Dist(tower.cx,tower.cy,e.x,e.y)<=rng then
                        TD.DamageEnemy(e,dmg,tower); TD.FlashEnemy(e,0.8,0.5,1); hit=true end end end
                if hit then tower.cooldownTimer=cd end end
        else tower.cooldownTimer=tower.cooldownTimer-elapsed
            if tower.cooldownTimer<=0 then local dmg,rng,cd=TD.TowerEffective(tower); local best,bestProg=nil,-1
                for _,e in ipairs(TD.game.enemies) do if e.alive and not e.vanished then
                    local dom=false; if e.immunity=="nomagic" and spec.family=="mage" then dom=true end; if e.immunity=="nophysic" and spec.family=="hunter" then dom=true end
                    if not dom then local d=TD.Dist(tower.cx,tower.cy,e.x,e.y); if d<=rng then local prog=e.pathIndex*10000-d; if prog>bestProg then best=e; bestProg=prog end end end end end
                if best then TD.Fire(tower,best); tower.cooldownTimer=cd end end end end end

function TD.UpdateSpawning(elapsed) local g=TD.game; if #g.spawnQueue==0 then return end; g.spawnTimer=g.spawnTimer+elapsed
    if g.spawnTimer>=TD.GetSpawnInterval() then g.spawnTimer=g.spawnTimer-TD.GetSpawnInterval()
        local entry=table.remove(g.spawnQueue,1); if entry.bossId then TD.SpawnMapBoss(entry.bossId,entry.hpScale) else TD.SpawnEnemy(entry.typeName,entry.hpScale,entry.immunity,entry.ambushIdx) end end end

function TD.CheckWaveComplete() local g=TD.game; if g.state~=TD.S_PLAY then return end
    if #g.spawnQueue==0 and #g.enemies==0 then
        if g.wave>=g.totalWaves then g.state=TD.S_WIN; TD.SaveMapProgress(g.currentMap.id,g.wave,g.totalWaves,g.lives,g.currentMap.startLives)
            TD.CheckChallenges(g.currentMap,g.tracking); TD.UpdateHUD(); return end
        g.state=TD.S_BREAK; g.waveImmunity=nil; local bonus=3+g.wave; local st=g.equippedStats
        if st.waveGoldBonus then bonus=bonus+st.waveGoldBonus end; g.gold=g.gold+bonus
        if st.waveLifeRegen then local maxLives=g.currentMap.startLives+(st.bonusLives or 0); g.lives=math.min(g.lives+st.waveLifeRegen,maxLives) end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r W"..g.wave.." cleared! +"..bonus..TD.GOLD_ICON); TD.UpdateHUD()
        -- Auto-wave: immediately start next wave
        if g.autoWave then TD.StartWave() end
    end end

-- Main loop
local uiAcc=0
local function OnUpdate(self,elapsed)
    if not TD.frames.main:IsShown() then return end; local g=TD.game
    if g.state==TD.S_MENU or g.state==TD.S_IDLE or g.state==TD.S_EQUIP then return end
    if g.state==TD.S_OVER or g.state==TD.S_WIN then return end
    if g.state==TD.S_BREAK then uiAcc=uiAcc+elapsed; if uiAcc>=0.3 then uiAcc=0; TD.UpdateHUD() end; return end
    local dt=elapsed*(g.speed or 1); if dt<=0 then uiAcc=uiAcc+elapsed; if uiAcc>=0.15 then uiAcc=0; TD.UpdateHUD() end; return end
    TD.UpdateSpawning(dt); TD.UpdateEnemies(dt); TD.UpdateHealers(dt); TD.UpdateTowers(dt); TD.UpdateProjectiles(dt)
    TD.UpdateCombatText(dt); TD.UpdateAuraVisuals(elapsed); TD.CheckWaveComplete()
    uiAcc=uiAcc+elapsed; if uiAcc>=0.15 then uiAcc=0; TD.UpdateHUD() end end

local function Init() TD.EnsureSaved(); TD.CreateMain(); TD.CreateMenu(); TD.CreateGameScreen()
    TD.frames.main:SetScript("OnUpdate",OnUpdate); TD.frames.main:Hide(); TD.RefreshMenu(); TD.game.state=TD.S_MENU
    -- Hook chat links for clickable tooltips
    local origRef=SetItemRef; SetItemRef=function(link,text,button,chatFrame)
        if link and link:find("^TDG:") then local tag=link:sub(5)
            GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR"); GameTooltip:AddLine(tag,1,0.8,0.3)
            local info=TD.GIMMICK_INFO[tag]; if info then GameTooltip:AddLine(info,0.9,0.85,0.75,true) end; GameTooltip:Show(); return end
        if link and link:find("^TD:boss:") then local bId=link:sub(9); local bd=TD.BOSS_DEFS[bId]
            if bd then GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR"); GameTooltip:AddLine(bd.name,1,0,1)
                GameTooltip:AddLine(string.format("HP: %d  Speed: %d  Reward: %d",bd.hp,bd.speed,bd.reward),0.8,0.8,0.8)
                GameTooltip:AddLine(bd.desc,0.9,0.85,0.75,true); GameTooltip:Show() end; return end
        if link and link:find("^TD:enemy:") then local eId=link:sub(10); local ed=TD.ENEMY_DEFS[eId]
            if ed then GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR"); GameTooltip:AddLine(ed.name,ed.color[1],ed.color[2],ed.color[3])
                GameTooltip:AddLine(string.format("HP: %d  Speed: %d  Reward: %d",ed.hp,ed.speed,ed.reward),0.8,0.8,0.8); GameTooltip:Show() end; return end
        if link and link:find("^TD:item:") then local iId=link:sub(9); local d=TD.ITEM_DEFS[iId]
            if d then GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR"); GameTooltip:AddLine(d.name,d.color[1],d.color[2],d.color[3])
                GameTooltip:AddLine(d.desc,0.9,0.85,0.75); GameTooltip:Show() end; return end
        if link and link:find("^TD:map:") then local mId=link:sub(8)
            for _,md in ipairs(TD.MAPS) do if md.id==mId then GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR")
                GameTooltip:AddLine(md.name,0.9,0.8,0.5); GameTooltip:AddLine(md.difficulty.." - "..md.totalWaves.." waves",md.diffColor[1],md.diffColor[2],md.diffColor[3])
                GameTooltip:AddLine(md.desc,0.9,0.85,0.75,true); GameTooltip:Show(); break end end; return end
        if link and link:find("^TD:spec:") then local sId=link:sub(9); local sp=TD.SPECS[sId]
            if sp then GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR"); GameTooltip:AddLine(sp.name,sp.color[1],sp.color[2],sp.color[3])
                GameTooltip:AddLine(sp.desc,0.9,0.85,0.75,true); GameTooltip:Show() end; return end
        return origRef(link,text,button,chatFrame) end
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Tower Defense]|r v5.1. |cff00ff00/td|r to play. Click gimmick names in chat for info.") end
SLASH_TOWERDEFENSE1="/td"; SLASH_TOWERDEFENSE2="/towerdefense"
SlashCmdList["TOWERDEFENSE"]=function(msg) if msg=="reset" then TowerDefenseSaved={}; TD.EnsureSaved(); if TD.frames.menuFrame then TD.RefreshMenu() end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r All progress, items, and specs have been reset."); return end
    if msg=="itsasecret" then TD.EnsureSaved()
        for _,m in ipairs(TD.MAPS) do if not m.secret then TowerDefenseSaved.maps[m.id]={bestWave=m.totalWaves,completed=true,stars=1} end end
        if TD.frames.menuFrame then TD.RefreshMenu() end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r |cffff00ffSecret levels unlocked!|r The timeways are open..."); return end
    if not TD.frames.main then return end; if TD.frames.main:IsShown() then TD.frames.main:Hide() else TD.ShowMenu() end end
local loader=CreateFrame("Frame"); loader:RegisterEvent("PLAYER_LOGIN"); loader:SetScript("OnEvent",function(self) Init(); self:UnregisterAllEvents() end)
