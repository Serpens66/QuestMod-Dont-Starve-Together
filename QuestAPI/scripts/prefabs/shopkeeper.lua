

local assets =
{
    Asset( "ANIM", "anim/shop_basic.zip"),
    Asset( "IMAGE", "images/map_icons/shopkeepermap.tex" ),
	Asset( "ATLAS", "images/map_icons/shopkeepermap.xml" ),
}


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.Transform:SetTwoFaced() --- ######### ?
    local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    
    
    -- MakeObstaclePhysics(inst, .5)
    -- inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    -- inst.Physics:CollidesWith(COLLISION.WORLD)
    -- inst.Physics:CollidesWith(COLLISION.ITEMS)
    MakeCharacterPhysics(inst, 200, .3)
    inst.Physics:SetFriction(1)
    inst.Physics:SetDamping(0)
    inst.Physics:SetRestitution(1) -- ?

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
    
    inst:AddComponent("talker") -- talker always in pristine
    inst.components.talker.fontsize = 30
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -680, 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("prototyper")
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SHOPPING_ONE

    
    return inst
end



return Prefab( "common/objects/shopkeeper", fn, assets),
       MakePlacer( "common/shopkeeper_placer", "shop", "shop_basic", "idle")
