TD.MAPS={
    {id="elwynn",name="Elwynn Forest",img="EF small",difficulty="Easy",diffColor={0.2,1,0.3},totalWaves=20,startGold=90,startLives=25,
        desc="Gnolls near Goldshire.",rewardItem="arcanedust",hpMult=1.0,speedMult=1.0,spawnMult=1.0,scalePower=1.6,
        enemyBias={},burstWaves={},flavor="Standard combat",boss="hogger",bossWaves={10,20},
        challenges={{id="elwynn_1",type="flawless",reward={item="hoggersclaw",spec="survival"},rewardText="Hogger's Claw + Survival"},
                    {id="elwynn_2",type="minimalist",reward={item="goldshiremedal"},rewardText="Goldshire Medal"},
                    {id="elwynn_3",type="pauper",reward={item="rangersbow"},rewardText="Ranger's Longbow"}},
        waypoints={{1,2},{17,2},{17,5},{4,5},{4,8},{17,8},{17,11},{20,11}},
        theme={ground={0.12,0.28,0.08},path={0.38,0.28,0.14},blocked={0.06,0.20,0.04},bChar="T",bName="Tree"},
        blocked={{2,4},{3,4},{6,1},{7,1},{8,1},{10,4},{11,4},{12,3},{19,4},{20,4},{1,7},{2,7},{2,10},{2,11},{8,10},{9,10},{8,11},{9,11},{14,10},{15,10},{6,12},{6,13},{7,13},{18,6},{19,6},{20,7}},
        boons={{10,1,"power"},{15,4,"haste"},{10,10,"range"},{6,7,"power"}},triggerTiles={},
    },
    {id="hillsbrad",name="Hillsbrad Foothills",img="HF small",difficulty="Medium",diffColor={1,0.8,0.1},totalWaves=25,startGold=100,startLives=22,
        desc="Syndicate ambushes. Burst waves.",rewardItem="frostshard",hpMult=1.05,speedMult=1.0,spawnMult=1.0,scalePower=1.8,
        enemyBias={brute=1},burstWaves={4,8,12,16,20,24},flavor="Burst spawns",boss="redpath",bossWaves={12,25},
        challenges={{id="hills_1",type="flawless",reward={item="durnholdesignet",spec="arcane"},rewardText="Durnholde Signet + Arcanist"},
                    {id="hills_2",type="nosell",reward={item="hillsbradtrophy"},rewardText="Hillsbrad Trophy"},
                    {id="hills_3",type="speedrun",reward={item="merchantpurse"},rewardText="Merchant's Purse"}},
        waypoints={{1,1},{1,6},{8,6},{8,1},{8,6},{8,10},{15,10},{15,6},{20,6}},
        theme={ground={0.18,0.28,0.12},path={0.42,0.36,0.22},blocked={0.40,0.38,0.32},bChar="^",bName="Rock"},
        blocked={{3,3},{4,3},{3,4},{4,4},{5,8},{5,9},{6,8},{6,9},{10,3},{11,3},{10,4},{11,4},{12,8},{13,8},{17,3},{18,3},{17,4},{18,4},{17,8},{18,8},{3,11},{4,11},{3,12},{4,12},{14,12},{15,12}},
        boons={{6,3,"range"},{12,6,"power"},{16,9,"haste"},{2,9,"haste"}},triggerTiles={},
    },
    {id="ashenvale",name="Ashenvale",img="AV small",difficulty="Medium",diffColor={1,0.8,0.1},totalWaves=24,startGold=95,startLives=20,
        desc="Ancient forest. Fast scouts, demon summoner.",rewardItem="soulsiphon",hpMult=0.95,speedMult=1.15,spawnMult=0.8,scalePower=1.9,
        enemyBias={scout=2,swarm=3},burstWaves={5,10,15,20},flavor="Fast enemies, rapid spawns",boss="tethyr",bossWaves={12,24},
        challenges={{id="ash_1",type="speedrun",reward={item="moonwellwater"},rewardText="Moonwell Water"},
                    {id="ash_2",type="endurance",reward={item="satyrhorn",spec="affliction"},rewardText="Satyr's Horn + Affliction"},
                    {id="ash_3",type="nosell",reward={item="wintergrasp"},rewardText="Wintergrasp Ice"}},
        waypoints={{1,7},{5,7},{5,2},{12,2},{12,7},{8,7},{8,12},{16,12},{16,7},{20,7}},
        theme={ground={0.08,0.22,0.14},path={0.30,0.22,0.16},blocked={0.04,0.32,0.18},bChar="Y",bName="Ancient"},
        blocked={{2,2},{3,2},{2,3},{3,3},{9,4},{10,4},{9,5},{10,5},{14,4},{15,4},{14,5},{17,4},{18,4},{18,5},{2,10},{3,10},{2,11},{3,11},{11,10},{12,10},{11,9},{18,10},{19,10},{19,11}},
        boons={{6,5,"power"},{10,7,"range"},{14,10,"haste"},{3,7,"power"},{17,7,"range"}},triggerTiles={{8,7},{16,7}},
    },
    {id="searing",name="Searing Gorge",img="SG small",difficulty="Hard",diffColor={1,0.3,0.2},totalWaves=30,startGold=105,startLives=18,
        desc="Lava corridors. Fire-shielded ambassador.",rewardItem="moltenfrag",hpMult=1.25,speedMult=0.9,spawnMult=1.1,scalePower=2.0,
        enemyBias={brute=2,healer=1},burstWaves={},flavor="Tanky enemies, +25% HP",boss="flamelash",bossWaves={15,30},
        challenges={{id="sear_1",type="flawless",reward={item="darkironband"},rewardText="Dark Iron Band"},
                    {id="sear_2",type="pauper",reward={item="lavacoreshard",spec="feral"},rewardText="Lava Core Shard + Feral"},
                    {id="sear_3",type="endurance",reward={item="plaguevial"},rewardText="Plague Vial"}},
        waypoints={{1,1},{19,1},{19,12},{3,12},{3,4},{16,4},{16,9},{6,9},{6,6},{12,6},{12,8},{20,8}},
        theme={ground={0.22,0.10,0.06},path={0.35,0.18,0.10},blocked={0.55,0.18,0.02},bChar="~",bName="Lava"},
        blocked={{5,3},{6,3},{7,3},{10,2},{11,2},{10,3},{11,3},{14,2},{15,2},{1,6},{1,7},{2,6},{2,7},{8,7},{9,7},{8,8},{14,6},{15,6},{1,10},{2,10},{8,11},{9,11},{10,11},{18,10},{19,10},{20,10}},
        boons={{4,1,"power"},{12,4,"haste"},{10,9,"range"},{18,6,"power"},{5,12,"haste"}},triggerTiles={},
    },
    {id="deadwind",name="Deadwind Pass",img="DP small",difficulty="Hard",diffColor={1,0.3,0.2},totalWaves=28,startGold=110,startLives=16,
        desc="Road to Karazhan. Ghost surges through ruins.",rewardItem="lichecho",hpMult=1.1,speedMult=1.05,spawnMult=0.9,scalePower=2.1,
        enemyBias={healer=2,scout=1},burstWaves={3,7,11,15,19,23,27},flavor="Frequent bursts, phantom boss",boss="nightbane",bossWaves={14,28},
        challenges={{id="dead_1",type="minimalist",reward={item="karazhankey",spec="arcane"},rewardText="Karazhan Key + Arcanist"},
                    {id="dead_2",type="nosell",reward={item="ghostlantern"},rewardText="Ghost Lantern"},
                    {id="dead_3",type="speedrun",reward={item="lightbringer"},rewardText="Light of the Naaru"}},
        waypoints={{1,7},{6,7},{6,3},{10,3},{10,7},{14,7},{14,11},{18,11},{18,7},{20,7}},
        theme={ground={0.12,0.10,0.16},path={0.28,0.24,0.30},blocked={0.22,0.16,0.28},bChar="W",bName="Ruin"},
        blocked={{2,2},{3,2},{2,3},{3,3},{8,1},{9,1},{12,1},{13,1},{2,10},{3,10},{2,11},{3,11},{7,10},{8,10},{12,10},{13,10},{19,2},{20,2},{19,12},{20,12}},
        boons={{4,5,"range"},{8,3,"power"},{12,7,"haste"},{16,9,"power"},{4,9,"range"}},triggerTiles={},
    },
    {id="dragonblight",name="Dragonblight",img="DB small",difficulty="Hard",diffColor={1,0.3,0.2},totalWaves=30,startGold=100,startLives=16,
        desc="Frozen graveyard. Sartharion spawns whelps.",rewardItem="thunderfury",hpMult=1.15,speedMult=0.95,spawnMult=1.0,scalePower=2.2,
        enemyBias={boss=1,brute=1},burstWaves={10,20,25,30},flavor="Extra bosses, steep scaling",boss="sartharion",bossWaves={15,30},
        challenges={{id="drag_1",type="speedrun",reward={item="dragonscale",spec="survival"},rewardText="Dragon Scale + Survival"},
                    {id="drag_2",type="endurance",reward={item="wyrmtooth",spec="feral"},rewardText="Wyrm Tooth + Feral"},
                    {id="drag_3",type="minimalist",reward={item="stormhammer"},rewardText="Stormforged Hammer"}},
        waypoints={{1,1},{10,1},{10,6},{4,6},{4,10},{14,10},{14,4},{20,4}},
        theme={ground={0.16,0.18,0.24},path={0.32,0.34,0.40},blocked={0.28,0.35,0.48},bChar="D",bName="Dragon Bone"},
        blocked={{3,3},{4,3},{3,4},{7,3},{7,4},{12,2},{13,2},{12,3},{13,3},{16,6},{17,6},{16,7},{17,7},{6,8},{7,8},{6,9},{8,12},{9,12},{8,13},{16,10},{17,10},{18,10},{19,7},{20,7}},
        boons={{5,1,"power"},{8,6,"haste"},{10,10,"range"},{16,4,"power"},{2,8,"haste"},{12,8,"range"}},triggerTiles={{4,6},{14,10}},
    },
    {id="icecrown",name="Icecrown Glacier",img="IC small",difficulty="Very Hard",diffColor={0.8,0.1,0.1},totalWaves=35,startGold=120,startLives=14,
        desc="Frozen wastes. Marrowgar's Bone Storm.",rewardItem="ashbringer",hpMult=1.2,speedMult=1.1,spawnMult=0.65,scalePower=2.4,
        enemyBias={swarm=4,runner=2,healer=1},burstWaves={5,10,15,20,25,30,35},flavor="Rapid spawns, Bone Storm",boss="marrowgar",bossWaves={17,35},
        challenges={{id="ice_1",type="flawless",reward={item="frostmourneshard",spec="affliction"},rewardText="Frostmourne Shard + Affliction"},
                    {id="ice_2",type="pauper",reward={item="icecrowntabard"},rewardText="Icecrown Tabard"},
                    {id="ice_3",type="nosell",reward={item="trollbane"},rewardText="Trollbane's Edge"}},
        waypoints={{1,2},{5,2},{5,5},{2,5},{2,8},{7,8},{7,2},{11,2},{11,11},{14,11},{14,5},{10,5},{10,8},{17,8},{17,2},{20,2}},
        theme={ground={0.22,0.26,0.34},path={0.38,0.42,0.50},blocked={0.50,0.62,0.75},bChar="#",bName="Ice Wall"},
        blocked={{3,4},{4,4},{9,1},{9,3},{9,4},{12,3},{13,3},{12,4},{13,4},{16,4},{16,5},{16,6},{19,4},{20,4},{4,10},{5,10},{4,11},{5,11},{8,10},{12,8},{12,9},{13,9},{15,12},{16,12},{19,10},{20,10}},
        boons={{3,2,"power"},{6,5,"haste"},{11,8,"range"},{15,2,"power"},{8,11,"haste"},{17,5,"range"}},triggerTiles={},
    },
    {id="blacktemple",name="The Black Temple",img="BT small",difficulty="Brutal",diffColor={0.7,0,0},totalWaves=40,startGold=130,startLives=12,
        desc="Illidan's stronghold. You are not prepared.",rewardItem="phylactery",hpMult=1.35,speedMult=1.15,spawnMult=0.55,scalePower=2.6,
        enemyBias={brute=2,boss=1,healer=2,scout=2},burstWaves={5,10,15,20,25,28,30,33,35,38,40},flavor="All boosted, Illidan boss",boss="illidan",bossWaves={20,40},
        challenges={{id="bt_1",type="flawless",reward={item="warglaiveshard"},rewardText="Warglaive Shard"},
                    {id="bt_2",type="minimalist",reward={item="illidanseye"},rewardText="Illidan's Eye"},
                    {id="bt_3",type="endurance",reward={item="nethershard"},rewardText="Netherstorm Shard"}},
        waypoints={{1,1},{6,1},{6,5},{2,5},{2,9},{8,9},{8,3},{14,3},{14,11},{10,11},{10,7},{17,7},{17,12},{20,12}},
        theme={ground={0.10,0.06,0.12},path={0.24,0.14,0.22},blocked={0.18,0.08,0.22},bChar="X",bName="Fel Crystal"},
        blocked={{10,1},{11,1},{10,2},{11,2},{5,7},{6,7},{5,8},{12,5},{13,5},{12,6},{13,6},{16,4},{17,4},{16,5},{12,9},{12,10},{18,9},{19,9},{18,10},{19,10},{3,12},{4,12},{3,13},{4,13}},
        boons={{3,1,"power"},{7,5,"haste"},{9,9,"range"},{14,7,"power"},{16,12,"haste"},{11,3,"range"},{2,7,"power"}},triggerTiles={{8,9},{14,3}},
    },
    -- Secret boss gauntlet map - unlocked by completing all 8 maps
    {id="cavernstime",name="Caverns of Time",img="CT small",difficulty="Legendary",diffColor={1,0.85,0},totalWaves=50,startGold=200,startLives=10,
        desc="The Infinite Dragonflight corrupts the timeways. Face every boss.",rewardItem="chronoshard",hpMult=1.4,speedMult=1.15,spawnMult=0.6,scalePower=2.8,
        enemyBias={boss=1,brute=2,healer=2,scout=2,swarm=3},burstWaves={5,10,15,20,25,30,35,40,45,50},
        flavor="Boss Gauntlet - All bosses return",secret=true,
        boss="murozond",bossWaves={10,20,30,40,50},
        bossSequence={"hogger","flamelash","sartharion","marrowgar","murozond"},
        challenges={{id="cot_1",type="flawless",reward={item="infinityorb"},rewardText="Orb of the Infinite"},
                    {id="cot_2",type="speedrun",reward={item="timelordsigil"},rewardText="Timelord's Sigil"},
                    {id="cot_3",type="endurance",reward={item="epochstone"},rewardText="Epoch Stone"}},
        waypoints={{1,1},{10,1},{10,4},{3,4},{3,7},{12,7},{12,10},{1,10},{1,12},{16,12},{16,8},{20,8},{20,4},{14,4},{14,1},{20,1}},
        theme={ground={0.15,0.10,0.22},path={0.35,0.28,0.42},blocked={0.30,0.25,0.50},bChar="@",bName="Time Rift"},
        blocked={{5,2},{6,2},{5,3},{8,5},{8,6},{9,5},{14,2},{15,2},{15,3},{2,5},{2,6},{6,9},{7,9},{6,10},{14,11},{15,11},{17,10},{18,10},{18,5},{19,5},{19,6},{11,5},{11,6},{4,11},{5,11}},
        boons={{3,1,"power"},{8,4,"haste"},{6,7,"range"},{10,10,"power"},{15,12,"haste"},{18,8,"range"},{13,4,"power"},{17,1,"haste"},{1,7,"range"},{9,1,"power"}},
        triggerTiles={{3,7},{12,10},{14,1}},
    },
    -- Secret naga map - unlocked by completing Caverns of Time
    -- Open-field maze builder: enemies spawn left, grab beach babes on right, run back
    {id="azshara",name="Azshara Beach",img="AZ small",difficulty="Mythic",diffColor={0.4,0.2,0.9},totalWaves=60,startGold=175,startLives=8,
        desc="Naga raid the beach! Build mazes to stop them reaching the babes on the right - and escaping back left.",rewardItem="tidalscepter",hpMult=1.5,speedMult=1.2,spawnMult=0.55,scalePower=3.0,
        enemyBias={scout=3,healer=3,boss=2,swarm=4},burstWaves={6,12,18,24,30,36,42,48,54,60},
        flavor="Open Field - Build mazes to protect the beach!",secret=true,unlockReq="cavernstime",
        boss="azshara",bossWaves={12,24,36,48,60},
        bossSequence={"tethyr","nightbane","redpath","illidan","azshara"},
        openField=true,
        babeRows={2,5,8,11},
        spawnRows={1,3,5,7,9,11,13},
        challenges={{id="azs_1",type="flawless",reward={item="abyssalcore"},rewardText="Abyssal Core"},
                    {id="azs_2",type="speedrun",reward={item="depthcharger"},rewardText="Depth Charge"},
                    {id="azs_3",type="endurance",reward={item="azsharastiara"},rewardText="Azshara's Tiara"}},
        waypoints={{1,7},{20,7}},
        theme={ground={0.18,0.16,0.10},path={0.85,0.75,0.55},blocked={0.10,0.18,0.35},bChar="~",bName="Coral Reef"},
        blocked={{5,3},{6,3},{10,6},{10,7},{15,4},{15,5},{5,10},{6,10},{10,11},{15,9},{15,10}},
        boons={{3,1,"power"},{8,5,"haste"},{13,2,"range"},{3,12,"power"},{8,8,"haste"},{13,11,"range"},{18,4,"power"},{18,9,"haste"}},
        triggerTiles={},
    },
}

function TD.BuildPath(md) local pC,pP,pG={},{},{}
    -- Open-field maps have no fixed path; enemies use BFS
    if md.openField then
        -- Provide a dummy path point so the system doesn't break for non-open-field code
        local cx,cy=TD.CC(1,7); pP[1]={x=cx,y=cy}; pP[2]={x=-TD.CELL,y=cy}; return pC,pP,pG end
    local wp=md.waypoints
    for i=1,#wp-1 do local c1,r1=wp[i][1],wp[i][2]; local c2,r2=wp[i+1][1],wp[i+1][2]
        local dc=c2>c1 and 1 or(c2<c1 and -1 or 0); local dr=r2>r1 and 1 or(r2<r1 and -1 or 0); local c,r=c1,r1
        while true do if c>=1 and c<=TD.COLS and r>=1 and r<=TD.ROWS then local k=c..","..r; if not pG[k] then pG[k]=true; pC[#pC+1]={c,r}; local px,py=TD.CC(c,r); pP[#pP+1]={x=px,y=py} end end
            if c==c2 and r==r2 then break end; c=c+dc; r=r+dr end
    end; local lw=wp[#wp]; pP[#pP+1]={x=lw[1]*TD.CELL+TD.CELL,y=select(2,TD.CC(lw[1],lw[2]))}; return pC,pP,pG end
function TD.BuildBlocked(md,pG) local bg={}; if not md.blocked then return bg end; for _,c in ipairs(md.blocked) do local k=c[1]..","..c[2]; if not pG[k] then bg[k]=true end end; return bg end
function TD.BuildBoons(md,pG,bG) local bg={}; if not md.boons then return bg end; for _,b in ipairs(md.boons) do local k=b[1]..","..b[2]; if not pG[k] and not bG[k] then bg[k]=b[3] end end; return bg end
function TD.BuildTriggers(md,pG) local tG={}; if not md.triggerTiles then return tG end; for _,t in ipairs(md.triggerTiles) do local k=t[1]..","..t[2]; if pG[k] then tG[k]=true end end; return tG end

-- ============================================================
-- BFS pathfinding for open-field maps (Azshara Beach)
-- ============================================================
function TD.BFS(startCol,startRow,goalCol,goalRow,blocked)
    -- blocked is a table of "c,r" -> true for impassable cells (towers + map blocked)
    if startCol==goalCol and startRow==goalRow then return {{startCol,startRow}} end
    local key=function(c,r) return c..","..r end
    if blocked[key(startCol,startRow)] or blocked[key(goalCol,goalRow)] then return nil end
    local queue={{startCol,startRow}}; local head=1; local came={}; came[key(startCol,startRow)]=true
    local dirs={{0,-1},{0,1},{-1,0},{1,0}}
    while head<=#queue do
        local cur=queue[head]; head=head+1; local cc,cr=cur[1],cur[2]
        for _,d in ipairs(dirs) do local nc,nr=cc+d[1],cr+d[2]
            if nc>=1 and nc<=TD.COLS and nr>=1 and nr<=TD.ROWS then local nk=key(nc,nr)
                if not came[nk] and not blocked[nk] then came[nk]=key(cc,cr)
                    if nc==goalCol and nr==goalRow then -- reconstruct
                        local path={{nc,nr}}; local ck=nk
                        while ck~=true do local pk=came[ck]; if pk==true then break end
                            local dc,dr=pk:match("^(%d+),(%d+)$"); path[#path+1]={tonumber(dc),tonumber(dr)}; ck=pk end
                        -- reverse
                        local rev={}; for i=#path,1,-1 do rev[#rev+1]=path[i] end; return rev end
                    queue[#queue+1]={nc,nr} end end end
    end; return nil end

-- BFS to any cell in a goal column (e.g. col 20 for babes, col 1 for exit)
function TD.BFSToColumn(startCol,startRow,goalCol,blocked)
    local key=function(c,r) return c..","..r end
    if blocked[key(startCol,startRow)] then return nil end
    if startCol==goalCol then return {{startCol,startRow}} end
    local queue={{startCol,startRow}}; local head=1; local came={}; came[key(startCol,startRow)]=true
    local dirs={{0,-1},{0,1},{-1,0},{1,0}}
    while head<=#queue do
        local cur=queue[head]; head=head+1; local cc,cr=cur[1],cur[2]
        for _,d in ipairs(dirs) do local nc,nr=cc+d[1],cr+d[2]
            if nc>=1 and nc<=TD.COLS and nr>=1 and nr<=TD.ROWS then local nk=key(nc,nr)
                if not came[nk] and not blocked[nk] then came[nk]=key(cc,cr)
                    if nc==goalCol then -- reconstruct
                        local path={{nc,nr}}; local ck=nk
                        while ck~=true do local pk=came[ck]; if pk==true then break end
                            local dc,dr=pk:match("^(%d+),(%d+)$"); path[#path+1]={tonumber(dc),tonumber(dr)}; ck=pk end
                        local rev={}; for i=#path,1,-1 do rev[#rev+1]=path[i] end; return rev end
                    queue[#queue+1]={nc,nr} end end end
    end; return nil end

-- Build a blocked grid combining tower positions + map blocked tiles
function TD.BuildOpenFieldBlocked(extraCol,extraRow)
    local bg={}
    -- Map blocked tiles
    if TD.currentBlockedGrid then for k in pairs(TD.currentBlockedGrid) do bg[k]=true end end
    -- All tower positions
    for _,t in ipairs(TD.game.towers) do bg[t.col..","..t.row]=true end
    -- Hypothetical extra tower being placed
    if extraCol then bg[extraCol..","..extraRow]=true end
    return bg end

-- Check that all spawn rows can reach column 20 and all column-20 reachable rows can reach column 1
function TD.ValidateOpenFieldPath(extraCol,extraRow)
    local md=TD.game.currentMap; if not md or not md.openField then return true end
    local bg=TD.BuildOpenFieldBlocked(extraCol,extraRow)
    -- Check: at least one spawn row can reach right side, and from there reach left side
    for _,sr in ipairs(md.spawnRows) do
        local pathToRight=TD.BFSToColumn(1,sr,TD.COLS,bg)
        if pathToRight then
            -- The endpoint on the right side must be able to reach column 1
            local endCell=pathToRight[#pathToRight]
            local pathToLeft=TD.BFSToColumn(endCell[1],endCell[2],1,bg)
            if pathToLeft then return true end end end
    return false end

-- Compute BFS path points for an enemy (spawn->right->left)
function TD.ComputeOpenFieldPath(spawnRow)
    local bg=TD.BuildOpenFieldBlocked()
    local toRight=TD.BFSToColumn(1,spawnRow,TD.COLS,bg)
    if not toRight then return nil end
    local endCell=toRight[#toRight]
    local toLeft=TD.BFSToColumn(endCell[1],endCell[2],1,bg)
    if not toLeft then return nil end
    -- Combine: toRight + toLeft (skip duplicate junction cell)
    local full={}
    for _,c in ipairs(toRight) do full[#full+1]=c end
    for i=2,#toLeft do full[#full+1]=toLeft[i] end
    -- Convert to path points
    local pts={}; for _,c in ipairs(full) do local x,y=TD.CC(c[1],c[2]); pts[#pts+1]={x=x,y=y} end
    -- Add exit point past left edge
    pts[#pts+1]={x=-TD.CELL,y=pts[#pts].y}
    return pts end

function TD.GetMapProgress(id) TD.EnsureSaved(); return TowerDefenseSaved.maps[id] or {bestWave=0,completed=false,stars=0} end
function TD.IsChallengeComplete(id) TD.EnsureSaved(); return TowerDefenseSaved.challenges[id]==true end
function TD.SaveMapProgress(id,wave,total,livesLeft,startLives) TD.EnsureSaved(); local p=TD.GetMapProgress(id); if wave>p.bestWave then p.bestWave=wave end
    if wave>=total and livesLeft>0 then local stars=1; if livesLeft>=math.floor(startLives*0.5) then stars=2 end; if livesLeft>=startLives then stars=3 end
        if not p.completed then p.completed=true; local md; for _,m in ipairs(TD.MAPS) do if m.id==id then md=m; break end end
            if md and md.rewardItem then TD.GiveItem(md.rewardItem); DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r Item: "..TD.ItemLink(md.rewardItem)) end end
        if stars>(p.stars or 0) then p.stars=stars end end; TowerDefenseSaved.maps[id]=p end
function TD.CheckChallenges(md,tr) if not md.challenges then return end; for _,ch in ipairs(md.challenges) do if not TD.IsChallengeComplete(ch.id) then
    local cd=TD.CHALLENGE_DEFS[ch.type]; if cd and cd.check(tr) then TowerDefenseSaved.challenges[ch.id]=true
        if ch.reward.spec then TD.UnlockSpec(ch.reward.spec) end; if ch.reward.item then TD.GiveItem(ch.reward.item) end
        local parts={}; if ch.reward.item then parts[#parts+1]=TD.ItemLink(ch.reward.item) end
        if ch.reward.spec then parts[#parts+1]=TD.SpecLink(ch.reward.spec) end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[TD]|r |cffffd700["..cd.name.."]|r complete! Reward: "..table.concat(parts," + ")) end end end end
