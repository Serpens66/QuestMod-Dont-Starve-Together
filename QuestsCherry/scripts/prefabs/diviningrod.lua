

local assets =
{
    Asset( "ANIM", "anim/diviningrod.zip"),
    Asset( "IMAGE", "images/map_icons/rod.tex" ),
    Asset( "ATLAS", "images/map_icons/rod.xml" ),
}



local function ontalk(inst)
    inst.SoundEmitter:KillSound("diviningrod")

    local intensity = math.random()

    inst.SoundEmitter:PlaySound("dontstarve/common/diviningrod_ping", "ping")
    inst.SoundEmitter:SetParameter("ping", "intensity", intensity)
    inst:DoTaskInTime(3,function(inst) inst.SoundEmitter:KillSound("diviningrod") end)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    --inst.Transform:SetTwoFaced()
    --local shadow = inst.entity:AddDynamicShadow()
	--shadow:SetSize( 1.75, .75)
    inst.Transform:SetScale(1, 1, 1)
    
    --[[
    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    ]]
    MakeCharacterPhysics(inst, 300, .3)
    inst.Physics:SetFriction(1)
    inst.Physics:SetDamping(0)
    inst.Physics:SetRestitution(1)
    
    inst.AnimState:SetBank("diviningrod")
    inst.AnimState:SetBuild("diviningrod")
    inst.AnimState:PlayAnimation("idle_full")    
    

	--inst:AddTag("prototyper")
    --inst:AddTag("giftmachine")
    --inst:AddTag("shelter") -- give custom speech in modmain
    inst:AddTag("notarget")
    --inst:AddTag("shopkeeper")
    --inst:AddTag("skin_collector")

    inst:AddComponent("questgiver")
    inst:AddTag("questgiver")

    inst:AddTag("rod","diviningrod")
    
    inst:AddComponent("talker") -- talker always in pristine
    inst.components.talker.fontsize = 30
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -500, 0)
    inst.components.talker.colour = Vector3(0, 0, 0)
    inst.components.talker.ontalk = ontalk

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
	--inst:AddComponent("prototyper")
    --inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SHOPPING_ONE

    local minimap = inst.entity:AddMiniMapEntity()    
    minimap:SetIcon( "rod.tex" )
    
    return inst
end

return Prefab( "common/objects/diviningrod", fn, assets),
       MakePlacer( "common/diviningrod_placer", "diviningrod", "diviningrod", "idle_full")