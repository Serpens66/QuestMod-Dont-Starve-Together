
local questworldinfo = Class(function(self, inst)
	self.inst = inst
	self.stuff1 = {}
	self.stuff2 = {}
	self.stuff3 = {}
	self.stuff4 = {}
	self.stuff5 = {}
	self.stuff6 = {}
	self.stuff7 = {}
	self.stuff8 = {}
	self.stuff9 = {}
	self.stuff10 = {}
    
    -- set up blueprints in different category lists, which will be emptied when blueprints are found
    self.stuff3.veryimportantblueprints = {"heatrock","grass_umbrella","backpack","lightning_rod","spear","transistor","boomerang","treasurechest","rope","boards","cutstone",} -- without blueprint in name, it is added later
    self.stuff3.importantblueprints = {"fence_gate_item","fence_item","waxpaper","beeswax","mushroom_farm","slow_farmplot","fast_farmplot","firepit","hammer","shovel","pitchfork","razor","reviver","lifeinjector","bandage","tent","meatrack","cookpot","icebox",
    "gunpowder","footballhat","birdcage","blowdart_pipe","papyrus","nightmarefuel","purplegem","tophat","armorwood","featherpencil","cartographydesk",
    "trap_teeth","birdtrap","bugnet","fishingrod","healingsalve","pighouse",}
    local summerblueprints = {"coldfire","coldfirepit","siestahut","featherfan","firesuppressor","watermelonhat","icehat","reflectivevest",}
    local winterblueprints = {"winterhat","sweatervest",}
    local springblueprints = {"rainhat","raincoat","umbrealla",}
    local darknessblueprints = {"lantern","rabbithouse","minerhat",}
    self.stuff3.otherblueprints = {} -- if all other blueprints were already spawned, spawn these as reward. array is filled below
    self.stuff3.importantblueprints = ArrayUnion(self.stuff3.importantblueprints,winterblueprints,springblueprints,summerblueprints,darknessblueprints)-- no need to seperate these, so merge them
    
    for k,v in pairs(AllRecipes) do -- and all the other recipes...
        -- if v.level~=TECH.NONE and v.level~=TECH.LOST then
        if v.level==TECH.SCIENCE_ONE or v.level==TECH.SCIENCE_TWO or v.level==TECH.MAGIC_TWO or v.level==TECH.MAGIC_THREE then -- only make blueprints for these techs, cause only those researchlabs are forbidden. All other techtree buildings are allowed (events, other mods, cartographer ...)
            if not (table.contains(TUNING.PREFABSALWAYS,v.name) or table.contains(self.stuff3.veryimportantblueprints,v.name) or table.contains(self.stuff3.importantblueprints,v.name)) then -- if recipe is in none of this lists, then put it into others list
                if not (v.nounlock or v.builder_tag ~= nil or v.name=="researchlab" or v.name=="researchlab2" or v.name=="researchlab3" or v.name=="researchlab4") then
                    table.insert(self.stuff3.otherblueprints,v.name) -- all other recipes, also modrecipes.
                end
            end
        end
    end
end)

-- this component was previouly a neutral remember component to remember every kind of information. thats why the save and load stuff is that complicated
function questworldinfo:OnSave() -- thx DarkXero for help how to save/load entities properly!
	local data = {}
	local stuff_references = {}
    local data_stuff = nil
    local self_stuff = nil
	for i = 1, 10 do
		data_stuff = {}
		self_stuff = self["stuff"..i]

		for key, thing in pairs(self_stuff) do
			if type(thing) == "table" and thing.GUID then
				-- we need to pass the GUID references to the game
				table.insert(stuff_references, thing.GUID)
				-- save a table with flag and GUID where entity should be
                data_stuff[key] = { is_GUID = true, GUID = thing.GUID }
			else
                data_stuff[key] = thing
			end
		end

		data["stuff"..i] = data_stuff
	end

	if next(stuff_references) == nil then
		-- if stuff_references is empty, make it nil
		stuff_references = nil
	end
	return data, stuff_references
end

function questworldinfo:OnLoad(data)
	self.stuff1 = data and data.stuff1 or {}
	self.stuff2 = data and data.stuff2 or {}
	self.stuff3 = data and data.stuff3 or {}
	self.stuff4 = data and data.stuff4 or {}
	self.stuff5 = data and data.stuff5 or {}
	self.stuff6 = data and data.stuff6 or {}
	self.stuff7 = data and data.stuff7 or {}
	self.stuff8 = data and data.stuff8 or {}
	self.stuff9 = data and data.stuff9 or {}
	self.stuff10 = data and data.stuff10 or {}
end

function questworldinfo:LoadPostPass(newents, data)
	-- OnLoad runs before LoadPostPass
	-- we saved GUIDs in data
	-- therefore, stuff1 loaded the tables with { is_GUID, GUID } where there should be an entity instead
	-- therefore, we just need to swap
	for i = 1, 10 do
		local self_stuff = self["stuff"..i]

		for key, thing in pairs(self_stuff) do
			if type(thing) == "table" then
				if thing.is_GUID then
					local thingy = newents[thing.GUID]
					if thingy then
						-- swap temp table for entity
						self_stuff[key] = thingy.entity
					end
				end
			end
		end
	end
end

return questworldinfo


