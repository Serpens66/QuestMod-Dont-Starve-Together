

local assets =
{
    Asset( "ANIM", "anim/skin_collector.zip"),
    Asset( "IMAGE", "images/map_icons/skin_collector.tex" ),
	Asset( "ATLAS", "images/map_icons/skin_collector.xml" ),
    Asset("SOUNDPACKAGE", "sound/skin_collector.fev"),    
    Asset("SOUND", "sound/skin_collector.fsb"),
}



local function ontalk(inst)
    inst.SoundEmitter:KillSound("skincollector")
    inst.AnimState:PlayAnimation("dialog_pre")
    inst.AnimState:PushAnimation("dial_loop")
    inst.AnimState:PushAnimation("dialog_pst", false)
    inst.AnimState:PushAnimation("idle", true)

    inst.SoundEmitter:PlaySound("dontstarve/characters/skincollector/talk_LP", "skincollector")
    inst:DoTaskInTime(3,function(inst) inst.SoundEmitter:KillSound("skincollector") end)

end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.Transform:SetTwoFaced()
    local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75)
    inst.Transform:SetScale(.85, .85, .85)
    
    --[[
    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    ]]
    MakeCharacterPhysics(inst, 200, .3)
    inst.Physics:SetFriction(1)
    inst.Physics:SetDamping(0)
    inst.Physics:SetRestitution(1)

    inst.AnimState:SetBank("skin_collector")
    inst.AnimState:SetBuild("skin_collector")
    inst.AnimState:PlayAnimation("idle", true)    
    

	--inst:AddTag("prototyper")
    --inst:AddTag("giftmachine")
    inst:AddTag("shelter") -- give custom speech in modmain
    inst:AddTag("notarget")
    --inst:AddTag("shopkeeper")
    inst:AddTag("skin_collector")

    inst:AddComponent("questgiver")
    inst:AddTag("questgiver")

    
    inst:AddComponent("talker") -- talker always in pristine
    inst.components.talker.fontsize = 30
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -700, 0)
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
	--inst.components.prototyper.onturnon = OnTurnOn -- overwritten in modmain now, to give hints about quests
	--inst.components.prototyper.onturnoff = OnTurnOff

    local minimap = inst.entity:AddMiniMapEntity()    
    minimap:SetIcon( "skin_collector.tex" )
    
    return inst
end



return Prefab( "common/objects/skin_collector", fn, assets),
       MakePlacer( "common/skin_collector_placer", "skin_collector", "skin_collector", "idle")