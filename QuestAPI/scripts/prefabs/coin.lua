local assets=
{
	Asset("ANIM", "anim/dubloon.zip"),
	-- Asset("IMAGE", "images/inventoryimages/slotm_inventory.tex"),
	-- Asset("ATLAS", "images/inventoryimages/slotm_inventory.xml"),
    Asset("IMAGE", "images/slotm_inventory.tex"),
	Asset("ATLAS", "images/slotm_inventory.xml"),
}

local prefabs =
{

}

local function shine(inst)
	-- inst.AnimState:PushAnimation("idle")
	
    if not inst.AnimState:IsCurrentAnimation("sparkle") then
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:PushAnimation("idle", true)
    end
    
	if inst.entity:IsAwake() then
		inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
	end
end

local function onwake(inst)
	inst.task = inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
end

local function onsleep(inst)
end


local function fn(Sim)
	
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

	inst.OnEntityWake = onwake
	inst.OnEntitySleep = onsleep

	MakeInventoryPhysics(inst)
	--MakeInventoryFloatable(inst, "idle_water", "idle")
	--MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )	 
	
	inst.AnimState:SetBank("dubloon")
	inst.AnimState:SetBuild("dubloon")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("molebait")
    inst:AddTag("currency")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("waterproofer")
	inst.components.waterproofer.effectiveness = 0
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/slotm_inventory.xml"

	-- inst:AddComponent("tradable")
	-- inst.components.tradable.goldvalue = 2 -- instead buying gold at shopkeeper, 4 coins one gold
	
	inst:AddComponent("bait")
	
	return inst
end

return Prefab( "common/inventory/coin", fn, assets, prefabs)
