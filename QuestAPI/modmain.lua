
print("QUESTSMOD APIMod")


-- make all important blueprints buyable at shop right from the beginning instead of finding them?



PrefabFiles = { 
    "coin",
    "shopkeeper",
}
Assets = {
    Asset("ANIM", "anim/dubloon.zip"),
    Asset("ANIM", "anim/shop_basic.zip"),
    Asset( "IMAGE", "images/map_icons/shopkeepermap.tex" ),
	Asset( "ATLAS", "images/map_icons/shopkeepermap.xml" ),
    Asset( "IMAGE", "images/map_icons/shopicon.tex" ),
    Asset( "ATLAS", "images/map_icons/shopicon.xml" ),
}

local _G = GLOBAL
GLOBAL.TUNING.QUEST_DIFFICULTY = GetModConfigData("difficulty")
GLOBAL.TUNING.QUEST_BLUEPRINTMODE = GetModConfigData("blueprintonly")
GLOBAL.TUNING.QUEST_SHOPMODE = GetModConfigData("shopkeeperstuff")
GLOBAL.TUNING.QUEST_NEWONE = GetModConfigData("newquest") -- x * daytime has to pass, until getting a new quest
GLOBAL.TUNING.QUEST_LOOP = GetModConfigData("loopquests")


local questfunctions = GLOBAL.require("scenarios/questfunctions")

modimport "mymodstrings.lua" 
modimport "custom_tech_tree.lua"
AddNewTechTree("SHOPPING",1) -- add new techtree for the shop thing
local shoptab = AddRecipeTab("Shop", 979, "images/map_icons/shopicon.xml", "shopicon.tex")	--- don't change the name of the icons! it's cursed...








if GLOBAL.TUNING.QUESTSMOD==nil then
    GLOBAL.TUNING.QUESTSMOD = {}
end
if GLOBAL.TUNING.QUESTSMOD.QUESTS==nil then
    GLOBAL.TUNING.QUESTSMOD.QUESTS = {}
end
----------------------- ## Items as reward for quests (instead of coins or blueprints) , used if rewardfn is default
-- you can add things to these lsits with other mods, but I don't know a way to delete/change the stuff written here...

if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS==nil then
    GLOBAL.TUNING.QUESTSMOD.REWARDITEMS = {}
end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARE==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARE = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUM==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUM = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTEN==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTEN = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN = {} end
if GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.FOOD==nil then GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.FOOD = {} end

-- using ArrayUnion(...) here, to make sure every prefab is only used once and to not need a table.insert line for every single prefab
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE , {"deerclops_eyeball","minotaurhorn","eyeturret_item",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARE = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARE , {"yellowgem", "orangegem", "greengem", "purplegem",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK , {"multitool_axe_pickaxe","batbat","armorslurper","greenamulet","nightsword","greenstaff","orangeamulet","yellowamulet","armor_sanity","yellowstaff",
    "ruinshat","armorruins","eyebrellahat","purpleamulet","trunkvest_winter","slurtlehat","walrushat","telestaff","orangestaff","molehat","armordragonfly","staff_tornado",
    "raincoat","beargervest",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUM = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUM , {"bluegem","redgem","manrabbit_tail","gears","livinglog","nightmarefuel","pigskin","slurper_pelt","slurtleslime","tentaclespots","transistor","blowdart_sleep",
    "blowdart_fire","blowdart_pipe","marble","healingsalve",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK , {"beemine","beefalohat","beehat","blueprint","trunkvest_summer","bugnet","blueamulet","sweatervest","featherhat","firestaff",
    "bedroll_furry","icestaff","lantern","amulet","onemanband","panflute","sewing_kit","spiderhat","tentaclespike","trap_teeth","umbrella","cane",
    "winterhat","featherfan","nightstick","catcoonhat","rainhat","reflectivevest","tallbirdegg","fertilizer","minerhat",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTEN = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTEN , {"boards","cutstone","guano","gunpowder","houndstooth","poop","rope","charcoal"})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK , {"torch","boomerang","fishingrod","footballhat","bedroll_straw","armorgrass","heatrock","armorwood","goldenaxe","goldenpickaxe","earmuffshat","goldenshovel",
    "strawhat","tophat",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN , {"log","cutgrass","flint","rocks","twigs",})
GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.FOOD = _G.ArrayUnion(GLOBAL.TUNING.QUESTSMOD.REWARDITEMS.FOOD , {"butter","dragonfruit","goatmilk","trunk_summer","trunk_winter","mandrake","meat_dried","smallmeat_dried","dragonpie","fishsticks","jammypreserves","flowersalad",
    "frogglebunwich","fruitmedley","guacamole","honeyham","honeynuggets","kabobs","mandrakesoup","meatballs","bonestew","watermelonicle","monsterlasagna","perogies","powcake",
    "pumpkincookie","ratatouille","hotchili","stuffedeggplant","taffy","turkeydinner","unagi","waffles",})


-------------------- ## SHOP, things that should be buyable at shop for coins
-- you can add things to these lsits with other mods, but I don't know a way to delete/change the stuff written here...
if GLOBAL.TUNING.QUESTSMOD.SHOPITEMS==nil then
    GLOBAL.TUNING.QUESTSMOD.SHOPITEMS = {}
end
-- prefab -> the prefab from the item you want
-- costs  -> the amount of coins to buy it
-- image -> the name of the .tex (leave out the ".tex") file of the image of the item. Usually it the same like prefab, in this case you can leave it nil.
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "cutgrass", costs = 2, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "twigs", costs = 2, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "rocks", costs = 2, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "flint", costs = 2, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "nitre", costs = 3, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "log", costs = 3, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "charcoal", costs = 4, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "cutreeds", costs = 4, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "ice", costs = 4, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "goldnugget", costs = 4, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "berries", costs = 4, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "butterflywings", costs = 5, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "smallmeat", costs = 5, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "silk", costs = 7, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "lightbulb", costs = 12, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "moonrocknugget", costs = 20, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "marble", costs = 20, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "manrabbit_tail", costs = 20, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "pigskin", costs = 20, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "redgem", costs = 25, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "bluegem", costs = 25, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "wormlight", costs = 30, image = nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "gears", costs = 30, image = nil})

-- strings for the item in the shop (you can outsource it in a modstrings.lua and import it in modmain.
-- GLOBAL.STRINGS.RECIPE_DESC.LOG_SHOP_STUFF = "Wood."
-- GLOBAL.STRINGS.NAMES.LOG_SHOP_STUFF = "Logs"


GLOBAL.TUNING.QUESTSMOD.GIVERS = {}








-- sort the items in various tables, depending how important the tech is 
GLOBAL.TUNING.PREFABSALWAYS = {"torch", "campfire", "axe", "compass", "bedroll_straw", "minifan", "pickaxe", "armorgrass", "homesign", "arrowsign", "wall_hay_item", "wardrobe", "flowerhat", "strawhat",
"moonrockcrater","trap","earmuffshat"} -- only these things should be always craftable without learning it

local function pairsOrdered(t, order) -- iterates in an ordered way
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


-- local function ChangeSomeTechLevels()
    -- muss wohl so direkt ohne fkt gemacht werden, denn sonst gibts trotz science_one änderung keine firepit/hammer blueprint (welche vorher none waren)
    if TUNING.QUEST_BLUEPRINTMODE then -- change tech_level of some things
        for k,v in pairs(GLOBAL.AllRecipes) do
            if v.level==GLOBAL.TECH.NONE and v.builder_tag == nil then -- character specific items should stay NONE tech, if they are before 
                if not table.contains(GLOBAL.TUNING.PREFABSALWAYS,v.name) then
                    v.level = GLOBAL.TECH.SCIENCE_ONE -- make require researchlab1
                end
            elseif table.contains(GLOBAL.TUNING.PREFABSALWAYS,v.name) or v.builder_tag ~= nil then -- make also all character specifc items tech none, otherwise they won't be buildable, cause no blueprints for them exist
                v.level = GLOBAL.TECH.NONE -- make these things requre no learning
            end
        end
    end
    
    -- shop
    if TUNING.QUEST_SHOPMODE and GLOBAL.TUNING.QUESTSMOD and type(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS)=="table" then
        local recipe = nil
        local contain = {}
        for k , rec in pairs(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS) do
            if not GLOBAL.table.contains(contain,rec.prefab) then -- dont add a recipe twice (if added twice it will overwrite the previous recipe with that name, resulting in unchangeable api shop)
                if rec.image==nil then
                    rec.image = rec.prefab
                end
                recipe = AddRecipe(rec.prefab.."_shop_stuff", {Ingredient("coin", rec.costs, "images/slotm_inventory.xml")}, shoptab, GLOBAL.TECH.SHOPPING_ONE, nil, nil, true, nil, nil, nil, rec.image..".tex");recipe.product = rec.prefab;
                table.insert(contain,rec.prefab)
            end
        end
    end

    if TUNING.QUEST_BLUEPRINTMODE then --blueprint recipes to buy
        local names = {}
        local recipes = GLOBAL.AllRecipes 
        for k,v in pairsOrdered(recipes, function(t,a,b) return tostring(GLOBAL.STRINGS.NAMES[string.upper(t[b].name)]) > tostring(GLOBAL.STRINGS.NAMES[string.upper(t[a].name)]) end) do -- add the blueprint recipes alphabetically sorted
            -- if v.level~=GLOBAL.TECH.NONE and v.level~=GLOBAL.TECH.LOST then -- for these things no blueprint exists ... but I could change TECH for things that have NONE at the moment, like firepit, pickaxe and so on.
            if v.level==GLOBAL.TECH.SCIENCE_ONE or v.level==GLOBAL.TECH.SCIENCE_TWO or v.level==GLOBAL.TECH.MAGIC_TWO or v.level==GLOBAL.TECH.MAGIC_THREE then -- only make blueprints for these techs, cause only those researchlabs are forbidden. All other techtree buildings are allowed (events, other mods, cartographer ...)
                table.insert(names,v.name) -- make it that way, cause you cant add recipes while iterating over recipes. and we also cant use a deepcopy of recipes, cause then v.level would never mathc any tech, since they are tables and therefore only match, if they are the same object, not when they have sma content...
            end            
        end
        for i,name in pairs(names) do
            recipe = AddRecipe(tostring(name).."_blueprint_shop",  {Ingredient("coin", 1, "images/slotm_inventory.xml")}, shoptab, GLOBAL.TECH.SHOPPING_ONE, nil, nil, true, nil, nil, nil, "blueprint.tex");recipe.product = tostring(name).."_blueprint";
            GLOBAL.STRINGS.RECIPE_DESC[string.upper(tostring(name).."_blueprint_shop")] = tostring(GLOBAL.STRINGS.RECIPE_DESC[string.upper(name)])
            GLOBAL.STRINGS.NAMES[string.upper(tostring(name).."_blueprint_shop")] = tostring(GLOBAL.STRINGS.NAMES[string.upper(name)]).." Blueprint"
        end
    end
-- end
    




-- a new testfunction if something can be build
local function recipetestfn(recname,recipe,builder)
    if recipe.level==GLOBAL.TECH.SHOPPING_ONE then
        if GLOBAL.TUNING.QUEST_SHOPMODE then
            if string.match(recname,"_shop_stuff") and not string.match(recname,"_blueprint_shop") then
                return true
            end
        end
        if string.match(recname,"_blueprint_shop") then
            local isreleased = GLOBAL.TheWorld.components and GLOBAL.TheWorld.components.questworldinfo and GLOBAL.TheWorld.components.questworldinfo.stuff1 and GLOBAL.TheWorld.components.questworldinfo.stuff1[recname] or false
            if not GLOBAL.TheNet:GetIsServer() and not GLOBAL.POPULATING and builder["mynetvar"..tostring(recname)] then
                isreleased = builder["mynetvar"..tostring(recname)]:value()
                -- isreleased = GLOBAL.TheWorld["mynetvar"..tostring(recname)] and GLOBAL.TheWorld["mynetvar"..tostring(recname)]:value() or false -- store in world does not work
            end
            if GLOBAL.TUNING.QUEST_BLUEPRINTMODE and isreleased then
                return true
            else
                return false
            end
        end
    elseif GLOBAL.TUNING.QUEST_BLUEPRINTMODE then -- remove researchlabs
        if recname=="researchlab" or recname=="researchlab2" or recname=="researchlab3" or recname=="researchlab4" then
            return false
        end
        return true
    else
        return true
    end
    return true
end

-- builder mod for client
AddClassPostConstruct("components/builder_replica",  function(self)
	local _CanLearn = self.CanLearn
	self.CanLearn = function(self, recname)
        local recipe = GLOBAL.GetValidRecipe(recname)
        if recipe~=nil and not recipetestfn(recname,recipe,self.inst) then 
            return false
        else
            return _CanLearn(self, recname) 
        end
	end
end)

local function AddScenario(inst,scen)
    if inst and inst.components and not inst.components.scenariorunner then
        inst:AddComponent("scenariorunner")
        inst.components.scenariorunner:SetScript(scen)
        inst.components.scenariorunner:Run()
    end
end


local function OnEmote(player,data) -- "emoteXL_annoyed", to skip a quest
    if data then
        local x, y, z = player.Transform:GetWorldPosition() 
        local questgivers = TheSim:FindEntities(x, y, z, 8, nil, nil, {"questgiver"})
        for i,giver in ipairs(questgivers) do
            if giver.components and giver.components.questgiver and giver.components.questgiver.questname~=nil then
                if ((giver.prefab=="pigking" and giver.components.trader:GetDebugString()=="true") or giver.prefab~="pigking") then -- say nothing, if pigking is sleeping
                    if type(data.anim)=="string" and "emoteXL_annoyed" == data.anim then 
                        giver:DoTaskInTime(0.5,function(giver) giver.components.questgiver:WantSkipQuest() end)
                    end
                end
            end
        end
    end
end


local function OnPlayerSpawn(inst)
    
    if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then
        for k,v in pairs(GLOBAL.AllRecipes) do -- set netvars up for client and server and give them default value
            if string.match(v.name,"_blueprint_shop") then -- we need a boolean netvar for every blueprintshop recipe, cause client builder can't check the components...
                inst["mynetvar"..tostring(v.name)] = GLOBAL.net_bool(inst.GUID, tostring(v.name).."NetStuff", "DirtyEvent"..tostring(v.name)) -- false or true
                inst["mynetvar"..tostring(v.name)]:set(false) -- store in world does not work
            end
        end
    end
    
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    inst:ListenForEvent("emote", OnEmote) -- skipping quests
    inst:ListenForEvent("invalidrpc", function(inst,data) print("Questmod Debug: InvalidRPC player "..tostring(data.player).." RPCName: "..tostring(data.rpcname)) end)
    
    if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then
        inst:DoTaskInTime(1,function(inst)
            for k,v in pairs(GLOBAL.AllRecipes) do -- now as server, give them the correct actual value
                if string.match(v.name,"_blueprint_shop") then -- we need a boolean netvar for every blueprintshop recipe, cause client builder can't check the components...
                    if inst["mynetvar"..tostring(v.name)] then
                        inst["mynetvar"..tostring(v.name)]:set(GLOBAL.TheWorld.components.questworldinfo and GLOBAL.TheWorld.components.questworldinfo.stuff1 and GLOBAL.TheWorld.components.questworldinfo.stuff1[v.name] or false)
                    end
                end
            end
        end)
    end
    
end
AddPlayerPostInit(OnPlayerSpawn)


local function Doinitquests(world)
    local x,y,z = world.components.playerspawner.GetAnySpawnPoint()
    local spawnpointpos = GLOBAL.Vector3(x ,y ,z )
    local keepers = TheSim:FindEntities(x, y, z, 20, nil, nil, {"shopkeeper"})
    if not _G.next(keepers) and (GLOBAL.TUNING.QUEST_BLUEPRINTMODE or GLOBAL.TUNING.QUEST_SHOPMODE) then -- if there is no keeper, but there should be one, create one.
        questfunctions.SpawnPrefabAtLandPlotNearInst("shopkeeper",spawnpointpos,15,0,15,1,3,3)
    elseif _G.next(keepers) and not (GLOBAL.TUNING.QUEST_BLUEPRINTMODE or GLOBAL.TUNING.QUEST_SHOPMODE) then -- remove them if they are not needed
        for i,keeper in pairs(keepers) do
            keeper.Remove()
        end
    end
    -- world.components.questworldinfo.stuff2.shopkeeper = keepers -- save the keeper in a component ... think this is not needed
end



local function ShopTalkOn(inst) -- only talk this way, if no quest was assigned to this shopkeeper
    if inst.components.questgiver==nil or inst.components.questgiver.questname==nil then
        inst.components.talker:ShutUp()
        local str = GLOBAL.GetRandomItem(GLOBAL.STRINGS.QUESTSMOD.SHOP.ON)
        local form = ""
        if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then
            form = GLOBAL.STRINGS.QUESTSMOD.SHOP.BLUEPRINT -- if blueprintmode, replace the "%s" in the strings with a blueprint sentence
        end
        str = string.format(str,form)
        inst.components.talker:Say(str)
    end
end

local function ShopTalkOff(inst) -- only talk this way, if no quest was assigned to this shopkeeper
    if inst.components.questgiver==nil or inst.components.questgiver.questname==nil then -- the starting shopkeeper
        inst.components.talker:ShutUp()
        local str = GLOBAL.GetRandomItem(GLOBAL.STRINGS.QUESTSMOD.SHOP.OFF)
        local form = ""
        if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then
            form = GLOBAL.STRINGS.QUESTSMOD.SHOP.BLUEPRINT -- if blueprintmode, replace the "%s" in the strings with a blueprint sentence
        end
        str = string.format(str,form)
        inst.components.talker:Say(str)
    end
end

AddPrefabPostInit("shopkeeper", function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if inst.components.prototyper then
        inst.components.prototyper.onturnon = ShopTalkOn
        inst.components.prototyper.onturnoff = ShopTalkOff
    end
end)


AddPrefabPostInit("world", function(world)

    if world.ismastershard then -- recipe changes need to be done for server and client
        -- world:DoTaskInTime(0.25,ChangeSomeTechLevels)
        
        
        -- world:DoTaskInTime(1,function(world) -- store in world does not work... maybe because of ismastershard check?
            -- for k,v in pairs(GLOBAL.AllRecipes) do 
                -- if string.match(v.name,"_blueprint_shop") then -- we need a boolean netvar for every blueprintshop recipe, cause client builder can't check the components...
                    -- world["mynetvar"..tostring(v.name)] = GLOBAL.net_bool(world.GUID, tostring(v.name).."NetStuff", "DirtyEvent"..tostring(v.name)) -- false or true
                    -- world["mynetvar"..tostring(v.name)]:set(false)
                -- end
            -- end
            -- if not GLOBAL.TheNet:GetIsServer() then 
                -- return
            -- end
            -- world:DoTaskInTime(1,function(world)
                -- for k,v in pairs(GLOBAL.AllRecipes) do
                    -- if string.match(v.name,"_blueprint_shop") then -- we need a boolean netvar for every blueprintshop recipe, cause client builder can't check the components...
                        -- if world["mynetvar"..tostring(v.name)] then
                            -- world["mynetvar"..tostring(v.name)]:set(GLOBAL.TheWorld.components.questworldinfo and GLOBAL.TheWorld.components.questworldinfo.stuff1 and GLOBAL.TheWorld.components.questworldinfo.stuff1[v.name] or false)
                        -- end
                    -- end
                -- end
            -- end)
        -- end)
        
    end
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if world.ismastersim and world.ismastershard then
        world:AddComponent("questworldinfo") -- a component just to save and load information, like possible recipes for shop. Also add it if no blueprint mode is active, to save data when blueprint mode is disabled and enabeld again
        world:DoTaskInTime(0,function(world) Doinitquests(world) end) -- spawn a shopkeeper if needed
    end
end)



-- mod the builder component to change recipes availibilty
AddComponentPostInit("builder", function(self)
	local _CanLearn = self.CanLearn
	self.CanLearn = function(self, recname)
        local recipe = GLOBAL.GetValidRecipe(recname)
        if recipe~=nil and not recipetestfn(recname,recipe,self.inst) then 
            return false
        else
            return _CanLearn(self, recname) 
        end
	end
end)


local function GetCustomShelterString(character, shelter)
	if shelter.prefab == "shopkeeper" then
		return GLOBAL.GetRandomItem(GLOBAL.STRINGS.QUESTSMOD.SHOP.SHELTER)
	end
end
AddComponentPostInit("sheltered", function(self)
	if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    local _SetSheltered = self.SetSheltered
	self.SetSheltered = function(self, issheltered)
		local cooldown_before = self.announcecooldown
		_SetSheltered(self, issheltered)
		local cooldown_after = self.announcecooldown
		if cooldown_before ~= cooldown_after then
			local shelter = GLOBAL.GetClosestInstWithTag("shelter", self.inst, 2)
			local custom_string = shelter and GetCustomShelterString(self.inst, shelter)
			if custom_string then
				self.inst.components.talker:ShutUp()
				self.inst.components.talker:Say(custom_string)
			end
		end
	end
end)


-- chance to find blueprints when slow picking/working something e.g grass
local function OnPicked(inst)
    if math.random() < GetModConfigData("findcoins") then
        questfunctions.SpawnPuff(inst)
        questfunctions.SpawnDrop(inst,"coin") -- since there is no lootdropper when slow picking something, we also add it here
    end
    if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then -- we have to define what blueprint, which is not easy possible with lootdropper, so we assign them only to slow pickable things
        local blueprint = nil
        local dospawn = false
        if math.random() < GetModConfigData("findblueprints") then -- 0.2 for high chance and 0.005 for low chance. default 0.02
            dospawn = true
        end
        if dospawn then
            questfunctions.SpawnPuff(inst)
            blueprint = questfunctions.GetNewBlueprints(questname,"",1)[1] -- a list with one entry, calling this function will remove blueprints from list, so only call this, if all of them will be spawned!
            if blueprint then
                questfunctions.SpawnDrop(inst,blueprint)
            else
                questfunctions.SpawnDrop(inst,"coin")
            end
        end
    end
end

local function OnWorked(inst,worker,workleft) -- is called for every hit... so it has to be very small chance... we cant use the finish event, cause it is rarely called, cause inst is removed before -.-
    if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then -- we have to define what blueprint, which is not easy possible with lootdropper, so we assign them only to slow pickable things
        local blueprint = nil
        local dospawn = false
        if math.random() < GetModConfigData("findblueprints")/5 then
            dospawn = true
        end
        if dospawn and inst and inst:IsValid() then
            questfunctions.SpawnPuff(inst)
            blueprint = questfunctions.GetNewBlueprints(questname,"",1)[1] -- a list with one entry, calling this function will remove blueprints from list, so only call this, if all of them will be spawned!
            if blueprint then
                questfunctions.SpawnDrop(inst,blueprint)
            end
        end
    end -- coins are found in loot of the worked object
end

AddComponentPostInit("lootdropper", function(self)
	local _SetLoot = self.SetLoot
	self.SetLoot = function(self, loots) -- when this fct is called, everything that was there before is overwritten, so we have to add the chance for coins again...
        _SetLoot(self, loots)
        self.inst.components.lootdropper:AddChanceLoot("coin", GetModConfigData("findcoins")) -- in case loot contains more then 1-2 coins, we chould first check chanceloot if there is already coin in it...
	end
end)

AddPrefabPostInitAny(function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if GetModConfigData("findcoins")>0 and (GLOBAL.TUNING.QUEST_BLUEPRINTMODE or GLOBAL.TUNING.QUEST_SHOPMODE) then -- chance is removed if modsetting is chanced, so everything is fine
        if inst and inst.components and inst.components.lootdropper then
            inst.components.lootdropper:AddChanceLoot("coin", GetModConfigData("findcoins"))  -- chance to find coins in everything that uses lootdropper
        end  
    end
    
    if not GLOBAL.TheWorld.ismastershard then return end -- only add blueprint stuff for forest world
    
    if inst and inst.components and inst.components.pickable and inst.components.pickable.quickpick==false then -- only things that take longer to pick up. this also means no coins for guys who use any quickpick mod for grass and such stuff
        inst:ListenForEvent("picked",OnPicked)
    end
    if inst and inst.components and inst.components.workable then -- only things that take longer to pick up. this also means no coins for guys who use any quickpick mod for grass and such stuff
        inst:ListenForEvent("worked",OnWorked)
    end
    
end)

AddPrefabPostInit("blueprint",function(inst)
    if not GLOBAL.TheNet:GetIsServer() then -- ?
        return
    end
    if GLOBAL.TUNING.QUEST_BLUEPRINTMODE then
        inst:DoTaskInTime(0,function(inst)
            GLOBAL.AddHauntableCustomReaction(inst, function(inst,haunter) end, true, false, true) -- remove the "change blueprint" haunt effect for this mode
        end)
    end
end)

local function GetDifferenceofTables(a,b) 
    local diff = {}
    -- local a = quests
    -- local b = questlistsave
    if (type(a)=="table" and type(b)=="table") then -- of course only works, if both are tables
        local counta = {}
        local countb = {}
        for ka,va in pairs(a) do
            counta[va.questname] = 0
            countb[va.questname] = 0
            for ka2,va2 in pairs(a) do -- iterate over a again, to count how often a quest with that name is in a
                if va.questname == va2.questname then
                    counta[va.questname] = counta[va.questname] + 1
                end
            end
            
            for kb,vb in pairs(b) do -- now count how often this questname is in b
                if va.questname == vb.questname then
                    countb[va.questname] = countb[va.questname] + 1
                end
            end
        end -- now we know how often the quests appearing in a, are in a and in b
        
        for kb,vb in pairs(b) do -- at last find out about quests that are not in a but in b
            countb[vb.questname] = 0
            counta[vb.questname] = 0
            for kb2,vb2 in pairs(b) do -- iterate over a again, to count how often a quest with that name is in a
                if vb.questname == vb2.questname then
                    countb[vb.questname] = countb[vb.questname] + 1
                end
            end
            
            for ka,va in pairs(a) do 
                if vb.questname == va.questname then
                    counta[vb.questname] = counta[vb.questname] + 1
                end
            end
        end
        
        for namea,ia in pairs(counta) do
            print("QUESTS contains: "..GLOBAL.tostring(namea).." : "..GLOBAL.tostring(ia))
            for nameb,ib in pairs(countb) do
                if namea==nameb then
                    print("questlistsave contains: "..GLOBAL.tostring(nameb).." : "..GLOBAL.tostring(ib))
                    diff[namea] = ia - ib
                end
            end
        end
    else
        print("FEHLER a oder b ist keine table?!")
    end
    print("--")
    for k,v in pairs(diff) do
        print("DIFF name "..GLOBAL.tostring(k).." : "..GLOBAL.tostring(v))
    end
    print("--")
    
    return diff
end


-- das was diff returned muss dann auf die questlistsave angewandt werden
local function CheckNewQuests(inst) -- inst is the questgiver
    local diff = GetDifferenceofTables(GLOBAL.TUNING.QUESTSMOD.QUESTS,inst.components.questgiver.questlistSave) -- find out which quests we have to add/remove to/from questlist
    local diffcopy = GLOBAL.deepcopy(diff) -- this copy is used to also adjust questlist accordingly
    for k,v in pairs(inst.components.questgiver.questlistSave) do
        if diff[v.questname] ~= nil and diff[v.questname]~=0 then
            if diff[v.questname]<0 then
                while diff[v.questname]~=0 do
                    if inst.prefab==v.questgiver then -- ignore quests from other questgivers. For every questgiver, this function has to be called
                        table.remove(inst.components.questgiver.questlistSave,k)
                    end
                    diff[v.questname] = diff[v.questname]+1
                end
            end
        end
    end
    local quest = nil    
    for i,q in pairs(GLOBAL.TUNING.QUESTSMOD.QUESTS) do -- what quests in QUESTS we have to add to list
        if diff[q.questname] ~= nil and diff[q.questname]>0 then
            quest = GLOBAL.deepcopy(q)
            while diff[q.questname]~=0 do
                if inst.prefab==q.questgiver then
                    table.insert(inst.components.questgiver.questlistSave,quest) -- hinzufügen, nun muss ich aber den kompletten eintrag zufügen
                end
                diff[q.questname] = diff[q.questname]-1
            end
        end
    end
    -- dieselben Änderungen müssen nun auch bei questlist gemacht werden... wobei es hier sein kann, dass es den zu entfernenden eintrag garnicht mehr gibt, sonst sollte es dasselbe sein
    for k,v in pairs(inst.components.questgiver.questlist) do
        if diffcopy[v.questname] ~= nil and diffcopy[v.questname]~=0 then
            if diffcopy[v.questname]<0 then
                while diffcopy[v.questname]~=0 do
                    if inst.prefab==v.questgiver then
                        table.remove(inst.components.questgiver.questlist,k)
                    end
                    diffcopy[v.questname] = diffcopy[v.questname]+1
                end
            end
        end
    end
    local quest = nil    
    for i,q in pairs(GLOBAL.TUNING.QUESTSMOD.QUESTS) do -- what quests in QUESTS we have to add to list
        if diffcopy[q.questname] ~= nil and diffcopy[q.questname]>0 then
            quest = GLOBAL.deepcopy(q)
            while diffcopy[q.questname]~=0 do
                if inst.prefab==q.questgiver then
                    table.insert(inst.components.questgiver.questlist,quest) -- hinzufügen, nun muss ich aber den kompletten eintrag zufügen
                end
                diffcopy[q.questname] = diffcopy[q.questname]-1
            end
        end
    end
end

local function OnDirtyEventQuestRGB(inst) -- function called for client, when rgb value is changed for a questgiver
    -- print("client colour changed to "..GLOBAL.tostring(inst["mynetvarQuestsR"]:value()).."/"..GLOBAL.tostring(inst["mynetvarQuestsG"]:value()).."/"..GLOBAL.tostring(inst["mynetvarQuestsB"]:value()))
    inst.components.talker.colour = GLOBAL.Vector3(inst["mynetvarQuestsR"]:value()/255, inst["mynetvarQuestsG"]:value()/255, inst["mynetvarQuestsB"]:value()/255)
end

AddPrefabPostInit("pigking",function(inst)
    if inst.components.talker==nil then
        inst:AddComponent("talker")
    end
    inst.components.talker.offset = GLOBAL.Vector3(0, -500, 0) -- default is Vector3(0, -400, 0)
    inst.components.talker.fontsize = 40 -- 35 ist default
    inst.components.talker.colour = GLOBAL.Vector3(1, 1, 1) -- talking colour when no quest -- here it must be a vector ={x=0.25,y=.5,z=0.4}, but in the Say() function is must look like this {0.25,0.5,0.4,1}
    
    -- to be able to change colour also for clients we have to use netvars I fear... also with the talker:Say() function, the colour is only valid for host, at least if we only call it for host
    inst["mynetvarQuestsR"] = GLOBAL.net_byte(inst.GUID, "QuestsRNetStuff", "DirtyEventQuestsR") 
    inst["mynetvarQuestsR"]:set(255)
    inst["mynetvarQuestsG"] = GLOBAL.net_byte(inst.GUID, "QuestsGNetStuff", "DirtyEventQuestsG") 
    inst["mynetvarQuestsG"]:set(255)
    inst["mynetvarQuestsB"] = GLOBAL.net_byte(inst.GUID, "QuestsBNetStuff", "DirtyEventQuestsB") 
    inst["mynetvarQuestsB"]:set(255)
    inst:ListenForEvent("DirtyEventQuestsR", OnDirtyEventQuestRGB)
    inst:ListenForEvent("DirtyEventQuestsG", OnDirtyEventQuestRGB)
    inst:ListenForEvent("DirtyEventQuestsB", OnDirtyEventQuestRGB)
    
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if inst.components.questgiver==nil then -- only add it if it was not added by another questmod before
        inst:AddComponent("questgiver")
        inst:AddTag("questgiver")
        table.insert(GLOBAL.TUNING.QUESTSMOD.GIVERS,inst)
    end
    if GLOBAL.TUNING.QUESTSMOD and type(GLOBAL.TUNING.QUESTSMOD.QUESTS)=="table" then
        inst:DoTaskInTime(3,function(inst) 
            
            CheckNewQuests(inst) -- find out if quests were added or removed and adjust questlist of questgiver accordingly, if the quest have pigking as questgiver 
            
            -- after init and onload of component, start next quest if necessary. Also call it if questname~=nil, cause maybe we have to remove this quest or fill the empty questlist (if someone enabled loop now)
            if inst.components.questgiver.nextquesttasktimeleft then -- when saved, the task is transformed into the remaining time
                inst.components.questgiver.nextquesttask = inst:DoTaskInTime(inst.components.questgiver.nextquesttasktimeleft+3,function(inst) inst.components.questgiver:StartNextQuest() end) -- start the task again
            elseif not inst.components.questgiver.nextquesttasktimeleft then 
                inst:DoTaskInTime(4,function(inst) inst.components.questgiver:StartNextQuest() end) -- start next quest AFTER we filled the questlist
            end
            print("Questanzahl in questlist: "..GLOBAL.tostring(#inst.components.questgiver.questlist))
       end)
    end
end)


AddMinimapAtlas("images/map_icons/shopkeepermap.xml")




