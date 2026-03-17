TD = TD or {}
TowerDefenseSaved = TowerDefenseSaved or {}
TD.SOLID="Interface\\Buttons\\WHITE8X8"; TD.MINIMAP_CIRCLE="Interface\\Minimap\\UI-Minimap-Background"
TD.CELL=48; TD.COLS=20; TD.ROWS=13; TD.PANEL_W=300; TD.PAD_TOP=50; TD.PAD_BOT=28
TD.PROJ_SPEED=380; TD.SPAWN_CD=0.6; TD.BREAK_TIME=8
TD.S_MENU=-1; TD.S_EQUIP=-2; TD.S_IDLE=0; TD.S_PLAY=1; TD.S_BREAK=2; TD.S_OVER=3; TD.S_WIN=4

function TD.EnsureSaved() local s=TowerDefenseSaved
    if not s.maps then s.maps={} end; if not s.items then s.items={"spyglass","coinpurse","barricade"} end
    if not s.equipped then s.equipped={"spyglass","coinpurse","barricade"} end
    if not s.specs then s.specs={hunter="marksman",mage="frost",warlock="destruction",druid="starfall"} end
    if not s.unlocked then s.unlocked={marksman=true,frost=true,destruction=true,starfall=true} end
    if not s.challenges then s.challenges={} end end

function TD.Tex(p,l,r,g,b,a) local t=p:CreateTexture(nil,l or "BACKGROUND"); t:SetTexture(TD.SOLID); t:SetVertexColor(r,g,b,a or 1); return t end
function TD.CirTex(p,l,r,g,b,a) local t=p:CreateTexture(nil,l or "OVERLAY"); t:SetTexture(TD.MINIMAP_CIRCLE); t:SetVertexColor(r,g,b,a or 0.15); return t end
function TD.Lbl(p,sz,r,g,b) local f=p:CreateFontString(nil,"OVERLAY","GameFontNormal"); f:SetFont("Fonts\\FRIZQT__.TTF",sz or 11,"OUTLINE"); f:SetTextColor(r or 1,g or 1,b or 1,1); return f end
function TD.Dist(x1,y1,x2,y2) local dx,dy=x2-x1,y2-y1; return math.sqrt(dx*dx+dy*dy) end
function TD.CC(c,r) return (c-1)*TD.CELL+TD.CELL/2,(r-1)*TD.CELL+TD.CELL/2 end
function TD.TS(def,stat,tier) local v=def[stat]; if type(v)=="table" then return v[tier] or v[1] end; return v end

TD.CLASS_ICON="Interface\\GLUES\\CHARACTERCREATE\\UI-CharacterCreate-Classes"
TD.CLASS_COORDS={hunter={0,0.25,0.25,0.5},mage={0.25,0.5,0,0.25},warlock={0.75,1,0.25,0.5},druid={0.75,1,0,0.25},paladin={0,0.25,0.5,0.75}}

TD.FAMILIES={
    {id="hunter",name="Hunter",color={0.2,0.8,0.2},specs={"marksman","survival"}},
    {id="mage",name="Mage",color={0.3,0.6,1.0},specs={"frost","arcane"}},
    {id="warlock",name="Warlock",color={1.0,0.4,0.1},specs={"destruction","affliction"}},
    {id="druid",name="Druid",color={1.0,0.5,0.0},specs={"starfall","feral"}},
}

TD.SPECS={
    marksman={id="marksman",family="hunter",name="Marksman",letter="M",baseCost=50,desc="Precise long-range shots.",color={0.2,0.8,0.2},damage={18,32,55},range={130,145,165},cooldown={1.2,1.0,0.8},splash=0,slowPct=0,slowDur=0,dot=0,upgradeCost={0,35,65}},
    survival={id="survival",family="hunter",name="Survival",letter="S",baseCost=45,desc="AoE traps, slows groups.",color={0.35,0.7,0.15},damage={10,16,26},range={100,110,120},cooldown={0.9,0.8,0.7},splash={35,45,55},slowPct={0.3,0.35,0.4},slowDur={1.5,2.0,2.5},dot=0,upgradeCost={0,30,55}},
    frost={id="frost",family="mage",name="Frost Mage",letter="F",baseCost=60,desc="Strong slow effect.",color={0.3,0.6,1.0},damage={6,10,16},range={110,120,135},cooldown={1.2,1.0,0.85},splash=0,slowPct={0.4,0.5,0.65},slowDur={1.8,2.2,3.0},dot=0,upgradeCost={0,40,70}},
    arcane={id="arcane",family="mage",name="Arcanist",letter="A",baseCost=75,desc="Devastating bursts.",color={0.5,0.3,1.0},damage={40,68,110},range={140,155,175},cooldown={2.6,2.3,2.0},splash=0,slowPct=0,slowDur=0,dot=0,upgradeCost={0,55,100}},
    destruction={id="destruction",family="warlock",name="Destruction",letter="D",baseCost=80,desc="Very slow fire AoE.",color={1.0,0.4,0.1},damage={16,26,42},range={85,95,105},cooldown={2.8,2.5,2.2},splash={45,55,70},slowPct=0,slowDur=0,dot=0,upgradeCost={0,50,90}},
    affliction={id="affliction",family="warlock",name="Affliction",letter="W",baseCost=65,desc="Damage over time.",color={0.7,0.3,0.5},damage={8,12,18},range={105,115,125},cooldown={1.0,0.9,0.8},splash=0,slowPct=0,slowDur=0,dot={6,10,16},upgradeCost={0,40,75}},
    starfall={id="starfall",family="druid",name="Starfall",letter="B",baseCost=75,desc="Pulses ALL in range.",color={1.0,0.6,0.0},damage={5,9,15},range={100,115,130},cooldown={1.8,1.5,1.2},splash=0,slowPct=0,slowDur=0,dot=0,upgradeCost={0,50,90},pulse=true},
    feral={id="feral",family="druid",name="Feral",letter="C",baseCost=55,desc="Fast melee swipes.",color={0.9,0.6,0.1},damage={10,17,28},range={65,72,80},cooldown={0.45,0.38,0.3},splash={25,30,40},slowPct=0,slowDur=0,dot=0,upgradeCost={0,35,65}},
    paladin={id="paladin",family="paladin",name="Paladin",letter="P",baseCost=100,desc="Aura buffs towers.",color={1.0,0.9,0.4},damage={0,0,0},range={100,115,130},cooldown={99,99,99},splash=0,slowPct=0,slowDur=0,dot=0,upgradeCost={0,60,110},aura=true,auraDmg={0.10,0.15,0.20},auraSpd={0.10,0.15,0.20},auraRng={0,0,0.10}},
}

function TD.GetActiveSpecs() TD.EnsureSaved(); local s=TowerDefenseSaved.specs
    return {TD.SPECS[s.hunter] or TD.SPECS.marksman,TD.SPECS[s.mage] or TD.SPECS.frost,TD.SPECS[s.warlock] or TD.SPECS.destruction,TD.SPECS[s.druid] or TD.SPECS.starfall,TD.SPECS.paladin} end
function TD.IsSpecUnlocked(id) TD.EnsureSaved(); if id=="paladin" then return true end; return TowerDefenseSaved.unlocked[id]==true end
function TD.UnlockSpec(id) TD.EnsureSaved(); TowerDefenseSaved.unlocked[id]=true end

TD.BOSS_DEFS={
    hogger={name="Hogger",hp=900,speed=38,reward=35,size=34,color={0.6,0.4,0.15},desc="Enrages at 40%: +60% speed, -40% dmg taken.",abilities={{trigger="onHpPct",pct=0.4,action="enrage",spdMult=1.6,dmgReduce=0.4,done=false}}},
    redpath={name="Captain Redpath",hp=1100,speed=34,reward=40,size=34,color={0.8,0.2,0.2},desc="20% chance on hit to rally nearby enemies.",abilities={{trigger="onHit",chance=0.20,action="rally",radius=80,spdBuff=1.5,dur=3.0}}},
    tethyr={name="Tethyr",hp=1000,speed=36,reward=40,size=36,color={0.4,0.7,0.2},desc="Spawns 4 swarm adds at trigger tiles.",abilities={{trigger="onTile",action="spawnAdds",addType="swarm",addCount=4,addHpMult=1.0}}},
    flamelash={name="Ambassador Flamelash",hp=1400,speed=30,reward=45,size=36,color={1.0,0.3,0.0},desc="Fire Shield: blocks 3 hits, recharges every 6s.",abilities={{trigger="periodic",interval=6.0,action="shield",charges=3,timer=0,currentCharges=3}}},
    nightbane={name="Nightbane's Echo",hp=1200,speed=32,reward=45,size=36,color={0.3,0.15,0.35},desc="Vanishes for 2s every 5s.",abilities={{trigger="periodic",interval=5.0,action="vanish",dur=2.0,timer=0,vanished=false,vanishTimer=0}}},
    sartharion={name="Sartharion's Brood",hp=1500,speed=28,reward=50,size=38,color={0.5,0.1,0.1},desc="Spawns 3 brutes at trigger tiles. Slow immune.",abilities={{trigger="onTile",action="spawnAdds",addType="brute",addCount=3,addHpMult=0.5},{trigger="onSpawn",action="immunity",immType="noslow"}}},
    marrowgar={name="Lord Marrowgar",hp=1800,speed=26,reward=55,size=38,color={0.7,0.75,0.8},desc="Bone Storm every 8s: all enemies +80% speed 2s.",abilities={{trigger="onSpawn",action="immunity",immType="noslow"},{trigger="periodic",interval=8.0,action="bonestorm",spdBuff=1.8,dur=2.0,timer=0}}},
    illidan={name="Illidan's Shade",hp=2200,speed=24,reward=65,size=42,color={0.2,0.6,0.1},desc="Metamorphosis at 30%: regens, slow immune, faster.",abilities={{trigger="onHpPct",pct=0.3,action="metamorph",spdMult=1.4,regenPct=0.02,done=false}}},
}

TD.BOON_DEFS={
    power={name="Ley Line",char="P",color={0.6,0.2,0.2},desc="+20% tower damage",dmgMult=1.20},
    range={name="High Ground",char="R",color={0.2,0.3,0.6},desc="+15% tower range",rngMult=1.15},
    haste={name="Mana Well",char="H",color={0.5,0.5,0.15},desc="+15% attack speed",cdMult=0.85},
}

-- Items: 11 original + 16 challenge-unique
TD.ITEM_DEFS={
    -- Starter items
    spyglass={name="Scout's Spyglass",desc="+12% range",color={0.4,0.85,1},icon="O",apply=function(s) s.rangeMult=(s.rangeMult or 1)*1.12 end},
    coinpurse={name="Worn Coinpurse",desc="+20 starting gold",color={1,0.85,0.2},icon="$",apply=function(s) s.bonusGold=(s.bonusGold or 0)+20 end},
    barricade={name="Sturdy Barricade",desc="+5 lives",color={0.6,0.4,0.2},icon="#",apply=function(s) s.bonusLives=(s.bonusLives or 0)+5 end},
    -- Map completion rewards
    arcanedust={name="Arcane Dust",desc="+12% attack speed",color={0.6,0.3,1},icon="*",apply=function(s) s.cdMult=(s.cdMult or 1)*0.88 end},
    frostshard={name="Shard of Alterac",desc="Slows 35% longer",color={0.3,0.7,1},icon="<",apply=function(s) s.slowDurMult=(s.slowDurMult or 1)*1.35 end},
    moltenfrag={name="Molten Core Fragment",desc="+30% splash",color={1,0.4,0},icon="~",apply=function(s) s.splashMult=(s.splashMult or 1)*1.30 end},
    soulsiphon={name="Soul Siphon",desc="+15% gold drops",color={0.5,0.2,0.7},icon="?",apply=function(s) s.goldMult=(s.goldMult or 1)*1.15 end},
    lichecho={name="Echo of the Lich King",desc="+20% damage",color={0.4,0.85,1},icon="!",apply=function(s) s.dmgMult=(s.dmgMult or 1)*1.20 end},
    ashbringer={name="Corrupted Ashbringer",desc="Paladin aura +50%",color={0.8,0.1,0.1},icon="X",apply=function(s) s.auraMult=(s.auraMult or 1)*1.50 end},
    thunderfury={name="Thunderfury's Spark",desc="DoTs +40%",color={0.3,0.5,1},icon="Z",apply=function(s) s.dotMult=(s.dotMult or 1)*1.40 end},
    phylactery={name="Kel'Thuzad's Phylactery",desc="+8 lives -20g",color={0.4,1,0.7},icon="K",apply=function(s) s.bonusLives=(s.bonusLives or 0)+8; s.bonusGold=(s.bonusGold or 0)-20 end},
    -- Challenge-unique items
    hoggersclaw={name="Hogger's Claw",desc="+8% damage",color={0.7,0.5,0.2},icon="c",apply=function(s) s.dmgMult=(s.dmgMult or 1)*1.08 end},
    goldshiremedal={name="Goldshire Medal",desc="+25 starting gold",color={1,0.9,0.3},icon="m",apply=function(s) s.bonusGold=(s.bonusGold or 0)+25 end},
    durnholdesignet={name="Durnholde Signet",desc="+7% attack speed",color={0.6,0.5,0.3},icon="d",apply=function(s) s.cdMult=(s.cdMult or 1)*0.93 end},
    hillsbradtrophy={name="Hillsbrad Trophy",desc="+10% range",color={0.5,0.7,0.3},icon="h",apply=function(s) s.rangeMult=(s.rangeMult or 1)*1.10 end},
    moonwellwater={name="Moonwell Water",desc="Slows +30% stronger",color={0.3,0.5,1},icon="w",apply=function(s) s.slowDurMult=(s.slowDurMult or 1)*1.30 end},
    satyrhorn={name="Satyr's Horn",desc="DoTs +25%",color={0.6,0.2,0.4},icon="s",apply=function(s) s.dotMult=(s.dotMult or 1)*1.25 end},
    darkironband={name="Dark Iron Band",desc="+6 lives",color={0.4,0.3,0.3},icon="b",apply=function(s) s.bonusLives=(s.bonusLives or 0)+6 end},
    lavacoreshard={name="Lava Core Shard",desc="+20% splash",color={1,0.3,0.1},icon="l",apply=function(s) s.splashMult=(s.splashMult or 1)*1.20 end},
    karazhankey={name="Karazhan Key",desc="+9% range",color={0.5,0.3,0.6},icon="k",apply=function(s) s.rangeMult=(s.rangeMult or 1)*1.09 end},
    ghostlantern={name="Ghost Lantern",desc="+10% attack speed",color={0.4,0.6,0.8},icon="g",apply=function(s) s.cdMult=(s.cdMult or 1)*0.90 end},
    dragonscale={name="Dragon Scale",desc="+4 lives +15g",color={0.3,0.5,0.5},icon="D",apply=function(s) s.bonusLives=(s.bonusLives or 0)+4; s.bonusGold=(s.bonusGold or 0)+15 end},
    wyrmtooth={name="Wyrm Tooth",desc="+10% damage",color={0.5,0.6,0.7},icon="W",apply=function(s) s.dmgMult=(s.dmgMult or 1)*1.10 end},
    frostmourneshard={name="Frostmourne Shard",desc="+15% damage",color={0.5,0.7,1},icon="F",apply=function(s) s.dmgMult=(s.dmgMult or 1)*1.15 end},
    icecrowntabard={name="Icecrown Tabard",desc="+7 lives",color={0.6,0.7,0.9},icon="I",apply=function(s) s.bonusLives=(s.bonusLives or 0)+7 end},
    warglaiveshard={name="Warglaive Shard",desc="+14% attack speed",color={0.2,0.8,0.2},icon="G",apply=function(s) s.cdMult=(s.cdMult or 1)*0.86 end},
    illidanseye={name="Illidan's Eye",desc="Paladin aura +30%",color={0.3,0.7,0.1},icon="E",apply=function(s) s.auraMult=(s.auraMult or 1)*1.30 end},
}
TD.ITEM_ORDER={"spyglass","coinpurse","barricade","arcanedust","frostshard","moltenfrag","soulsiphon","lichecho","ashbringer","thunderfury","phylactery",
    "hoggersclaw","goldshiremedal","durnholdesignet","hillsbradtrophy","moonwellwater","satyrhorn","darkironband","lavacoreshard",
    "karazhankey","ghostlantern","dragonscale","wyrmtooth","frostmourneshard","icecrowntabard","warglaiveshard","illidanseye"}

function TD.GetEquippedStats() TD.EnsureSaved(); local st={}; for _,id in ipairs(TowerDefenseSaved.equipped) do local d=TD.ITEM_DEFS[id]; if d then d.apply(st) end end; return st end
function TD.HasItem(id) TD.EnsureSaved(); for _,v in ipairs(TowerDefenseSaved.items) do if v==id then return true end end; return false end
function TD.GiveItem(id) if TD.HasItem(id) then return end; table.insert(TowerDefenseSaved.items,id) end
function TD.IsEquipped(id) TD.EnsureSaved(); for _,v in ipairs(TowerDefenseSaved.equipped) do if v==id then return true end end; return false end
function TD.SetEquipped(slot,id) TD.EnsureSaved(); if slot<1 or slot>3 then return end; for i=1,3 do if i~=slot and TowerDefenseSaved.equipped[i]==id then TowerDefenseSaved.equipped[i]=TowerDefenseSaved.equipped[slot] end end; TowerDefenseSaved.equipped[slot]=id end

TD.ENEMY_DEFS={
    runner={name="Runner",hp=60,speed=72,reward=3,size=16,color={0.2,0.9,0.2},icon="R"},
    scout={name="Scout",hp=30,speed=135,reward=3,size=14,color={1,1,0.2},icon="S"},
    brute={name="Brute",hp=220,speed=45,reward=8,size=22,color={0.9,0.2,0.2},icon="B"},
    healer={name="Healer",hp=75,speed=58,reward=6,size=16,color={0.2,1,0.7},icon="H"},
    boss={name="Boss",hp=800,speed=30,reward=30,size=28,color={0.7,0.1,0.9},icon="!"},
    swarm={name="Swarm",hp=18,speed=100,reward=1,size=10,color={0.8,0.5,0.2},icon="s"},
}

TD.CHALLENGE_DEFS={
    flawless={name="Flawless",desc="Lose no lives",check=function(t) return t.livesLost==0 end},
    minimalist={name="Minimalist",desc="6 or fewer towers",check=function(t) return t.maxTowers<=6 end},
    nosell={name="No Sell",desc="Never sell a tower",check=function(t) return t.sellCount==0 end},
    speedrun={name="Speed Run",desc="Never pause",check=function(t) return t.neverPaused end},
    pauper={name="Pauper",desc="Spend 300g or less",check=function(t) return t.goldSpent<=300 end},
    endurance={name="Endurance",desc="No lives lost past W15",check=function(t) return t.latelivesLost==0 end},
}

-- Gimmick explanations for chat/tooltip
TD.GIMMICK_INFO={
    ["Scout Rush"]="Only fast scouts. High speed, low HP.",
    ["Brute Wall"]="Tanky brutes. Slow but massive HP.",
    ["Swarm Tide"]="Massive swarm wave. Overwhelm with numbers.",
    ["Heal Train"]="Healers mixed with brutes. Kill healers first!",
    ["Boss Blitz"]="Multiple bosses at once. Bring burst damage.",
    ["Full Assault"]="All enemy types. A true test.",
    ["Arcane Shielded"]="Magic immune! Mage towers deal zero damage.",
    ["Thick Skinned"]="Physical immune! Hunter towers deal zero damage.",
    ["Frost Ward"]="Slow immune! Cannot be slowed.",
    ["Curse Immune"]="DoT immune! Affliction effects blocked.",
    ["Scatter Formation"]="AoE immune! Splash damage blocked.",
    ["Juggernaut"]="Slow immune bosses with healer support.",
    ["Final Boss Blitz"]="The final wave. Everything at once.",
    ["BURST"]="2.5x faster spawn rate this wave.",
}

TD.game={state=TD.S_MENU,currentMap=nil,gold=0,lives=0,wave=0,totalWaves=0,
    towers={},enemies={},projectiles={},selectedTower=nil,sellMode=false,
    waveList={},spawnQueue={},spawnTimer=0,breakTimer=0,
    equippedStats={},activeSpecs={},pendingMapIndex=nil,
    tracking={livesLost=0,maxTowers=0,sellCount=0,skippedAll=true,neverPaused=true,goldSpent=0,latelivesLost=0},
    waveImmunity=nil,speed=1,autoWave=false,
}
TD.frames={main=nil,menuFrame=nil,equipFrame=nil,gameFrame=nil,gameArea=nil,cells={},towerFrames={},enemyPool={},projPool={},rangeCircle=nil}
TD.ui={}; TD.equipSelItem=nil; TD.activeTowerPanel=nil
TD.currentPathGrid={}; TD.currentPathPoints={}; TD.currentBlockedGrid={}; TD.currentBoonGrid={}; TD.currentTriggerGrid={}
