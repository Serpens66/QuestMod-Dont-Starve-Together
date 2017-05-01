

local assets =
{
    Asset( "ANIM", "anim/shop_basic.zip"),
    Asset( "ANIM", "anim/shopkeeper_carry.zip"),
    Asset( "IMAGE", "images/map_icons/shopkeepermap.tex" ),
	Asset( "ATLAS", "images/map_icons/shopkeepermap.xml" ),
    Asset( "INV_IMAGE", "images/map_icons/shopkeepermap.tex"),
}


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "shopkeeper_carry", "swap_body")
    
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.Transform:SetTwoFaced() --- ######### ?
    local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    
    
    -- MakeCharacterPhysics(inst, 200, .3)
    -- inst.Physics:SetFriction(1)
    -- inst.Physics:SetDamping(0)
    -- inst.Physics:SetRestitution(1) -- ?
    
    -- MakeHeavyObstaclePhysics(inst, 0.45)
    MakeSmallHeavyObstaclePhysics(inst, 0.45)
    
    inst.AnimState:SetBank("shop")
    inst.AnimState:SetBuild("shop_basic")
    inst.AnimState:PlayAnimation("idle", true)    
    
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("shopkeepermap.tex")
    
	inst:AddTag("prototyper")
    inst:AddTag("giftmachine")
    inst:AddTag("shelter") -- give custom speech in modmain
    inst:AddTag("notarget")
    inst:AddTag("shopkeeper")
    inst:AddTag("heavy")
    
    inst:AddComponent("talker") -- talker always in pristine
    inst.components.talker.fontsize = 30
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -680, 0)
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("heavyobstaclephysics")
    inst.components.heavyobstaclephysics:SetRadius(0.45)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
    
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("prototyper")
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SHOPPING_ONE

    
    return inst
end



return Prefab( "common/objects/shopkeeper", fn, assets),
       MakePlacer( "common/shopkeeper_placer", "shop", "shop_basic", "idle")
