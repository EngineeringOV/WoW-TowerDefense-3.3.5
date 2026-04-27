local function GLink(tag)
    local clean=tag:gsub("|c%x%x%x%x%x%x%x%x",""):gsub("|r","")
    return "|HTDG:"..clean.."|h["..tag.."]|h"
end

local GIMMICKS={
    {tag=GLink("|cff00ff00Scout Rush|r"),min=3,build=function(w,n) local e={}; for i=1,n+8 do e[#e+1]="scout" end; return e end},
    {tag=GLink("|cffff4444Brute Wall|r"),min=6,build=function(w,n) local e={}; for i=1,math.floor(n*0.5)+3 do e[#e+1]="brute" end; return e end},
    {tag=GLink("|cff80ff80Swarm Tide|r"),min=4,build=function(w,n) local e={}; for i=1,n*3+5 do e[#e+1]="swarm" end; return e end},
    {tag=GLink("|cff00ffccHeal Train|r"),min=8,build=function(w,n) local e={}; for i=1,math.floor(n*0.4) do e[#e+1]="healer" end; for i=1,math.floor(n*0.4) do e[#e+1]="brute" end; return e end},
    {tag=GLink("|cffcc00ffBoss Blitz|r"),min=10,build=function(w,n) local e={}; for i=1,math.max(2,math.floor(w/4)) do e[#e+1]="boss" end; return e end},
    {tag=GLink("|cffffff00Full Assault|r"),min=7,build=function(w,n) local e={}; local q=math.floor(n/5)
        for i=1,q do e[#e+1]="runner" end; for i=1,q do e[#e+1]="scout" end; for i=1,q do e[#e+1]="brute" end; for i=1,q do e[#e+1]="swarm" end
        for i=1,math.max(1,math.floor(w/6)) do e[#e+1]="boss" end; for i=1,math.floor(q*0.5) do e[#e+1]="healer" end; return e end},
    {tag=GLink("|cff8888ffArcane Shielded|r"),min=6,immunity="nomagic",build=function(w,n) local e={}; for i=1,math.floor(n*0.6) do e[#e+1]="runner" end; for i=1,math.floor(n*0.3) do e[#e+1]="brute" end; return e end},
    {tag=GLink("|cffaaaa44Thick Skinned|r"),min=6,immunity="nophysic",build=function(w,n) local e={}; for i=1,math.floor(n*0.5) do e[#e+1]="runner" end; for i=1,math.floor(n*0.4) do e[#e+1]="brute" end; return e end},
    {tag=GLink("|cff44ddddFrost Ward|r"),min=5,immunity="noslow",build=function(w,n) local e={}; for i=1,math.floor(n*0.5) do e[#e+1]="scout" end; for i=1,math.floor(n*0.5) do e[#e+1]="runner" end; return e end},
    {tag=GLink("|cffdd88ddCurse Immune|r"),min=9,immunity="nodot",build=function(w,n) local e={}; for i=1,math.floor(n*0.4) do e[#e+1]="brute" end; for i=1,math.floor(n*0.3) do e[#e+1]="healer" end; for i=1,math.floor(n*0.3) do e[#e+1]="runner" end; return e end},
    {tag=GLink("|cffff8844Scatter Formation|r"),min=7,immunity="noaoe",build=function(w,n) local e={}; for i=1,math.floor(n*0.4) do e[#e+1]="swarm" end; for i=1,math.floor(n*0.3) do e[#e+1]="scout" end; for i=1,math.floor(n*0.3) do e[#e+1]="runner" end; return e end},
    {tag=GLink("|cffff4444Juggernaut|r"),min=12,immunity="noslow",build=function(w,n) local e={}; for i=1,math.max(2,math.floor(w/5)) do e[#e+1]="boss" end; for i=1,math.floor(n*0.2) do e[#e+1]="healer" end; return e end},
}

local function BuildStd(w,bias) local e={}; for i=1,5+w*2 do e[#e+1]="runner" end
    if w>=3 then for i=1,math.floor(w*0.9) do e[#e+1]="scout" end end; if w>=5 then for i=1,math.floor((w-3)*0.7) do e[#e+1]="brute" end end
    if w>=7 then for i=1,math.floor((w-5)*0.5) do e[#e+1]="healer" end end; if w>=4 then for i=1,math.floor(w*0.6) do e[#e+1]="swarm" end end
    if w>=10 then for i=1,math.floor((w-7)/3) do e[#e+1]="boss" end end
    if bias then for t,c in pairs(bias) do if TD.ENEMY_DEFS[t] then for i=1,c do e[#e+1]=t end end end end; return e end

function TD.GenerateWaves(totalWaves,mapDef)
    local waves={}; local seed=totalWaves*7+13; local hpM=mapDef and mapDef.hpMult or 1.0; local scalePow=mapDef and mapDef.scalePower or 1.8
    local bias=mapDef and mapDef.enemyBias or {}; local burstSet={}; if mapDef and mapDef.burstWaves then for _,bw in ipairs(mapDef.burstWaves) do burstSet[bw]=true end end
    local bossWaveSet={}; if mapDef and mapDef.bossWaves then for _,bw in ipairs(mapDef.bossWaves) do bossWaveSet[bw]=true end end
    for w=1,totalWaves do local pct=w/totalWaves
        local hpScale=(1+(w-1)*0.12+math.pow(pct,scalePow)*w*0.18)*hpM; local baseCount=5+w*2; local enemies; local gimmickTag; local isBurst=burstSet[w] or false; local immunity
        local spawnMapBoss=bossWaveSet[w] or false
        if w==totalWaves then enemies=GIMMICKS[5].build(w,baseCount); gimmickTag=GLink("|cffcc00ffFinal Boss Blitz|r"); hpScale=hpScale*2.2; isBurst=true; spawnMapBoss=true
        elseif w==math.floor(totalWaves*0.75) then enemies=GIMMICKS[6].build(w,baseCount); gimmickTag=GIMMICKS[6].tag; hpScale=hpScale*1.4
        elseif not spawnMapBoss and w>=3 and (w%4==0 or w%4==3) then
            local pick=((w+seed)%#GIMMICKS)+1; local gim=GIMMICKS[pick]; if w>=gim.min then enemies=gim.build(w,baseCount); gimmickTag=gim.tag; immunity=gim.immunity end end
        if not enemies then enemies=BuildStd(w,bias) end; if pct>0.75 then hpScale=hpScale*(1+(pct-0.75)*4.0) end
        waves[w]={enemies=enemies,hpScale=hpScale,gimmickTag=gimmickTag,isBurst=isBurst,immunity=immunity,spawnMapBoss=spawnMapBoss}
    end
    -- Boss gauntlet: assign different bosses per boss wave
    if mapDef and mapDef.bossSequence then local bi=1
        for w=1,totalWaves do if waves[w].spawnMapBoss then
            waves[w].bossId=mapDef.bossSequence[bi]; bi=math.min(bi+1,#mapDef.bossSequence) end end end
    return waves end

function TD.WaveSummary(info) local counts={}; for _,t in ipairs(info.enemies) do counts[t]=(counts[t] or 0)+1 end
    local parts={}; for _,t in ipairs({"swarm","scout","runner","healer","brute","boss"}) do if counts[t] then parts[#parts+1]=counts[t]..TD.ENEMY_DEFS[t].icon end end; return table.concat(parts," ") end

function TD.WavePreview(waveList,cur,n) n=n or 5; local lines={}
    for i=1,n do local w=cur+i; if w>#waveList then break end; local info=waveList[w]
        local s=TD.WaveSummary(info); local tag=info.gimmickTag or ""
        if tag~="" then tag=" "..tag:gsub("|H.-|h","") end
        local burst=info.isBurst and " |cffff8800[BURST]|r" or ""; local bossTag=info.spawnMapBoss and " |cffff00ff[BOSS]|r" or ""
        lines[#lines+1]=string.format("W%d: %s%s%s%s",w,s,tag,burst,bossTag) end; return lines end
