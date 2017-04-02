

local assets =
{
    Asset( "ANIM", "anim/skin_collector.zip"),
    Asset( "IMAGE", "images/map_icons/skin_collector.tex" ),
	Asset( "ATLAS", "images/map_icons/skin_collector.xml" ),
}


-- local function OnTurnOn(inst)
--     inst.components.talker:ShutUp()
--     local strings = {"These're my special deals.","Pleased ta meecha.","Take yer time. I can stand here yammerin' all day.","Once, when I was but a young shaver... ah, but ya don' wanna listen to an old trader's stories.","If ya find any coins while you're adventuring around out there, ya can bring the ones ya don't need ta me.","","","",}
--     inst.components.talker:Say(GetRandomItem(strings))
-- end

-- local function OnTurnOff(inst)
--     inst.components.talker:ShutUp()
--     local strings = {"C'mon back when ya got something ta trade!","Pleasure doin' business with ya.","See ya later.","","","",}
--     inst.components.talker:Say(GetRandomItem(strings))
-- end


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.Transform:SetTwoFaced() --- ######### ?
    local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75)
    inst.Transform:SetScale(.75, .75, .75)
    
    
    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)

    inst.AnimState:SetBank("skin_collector")
    inst.AnimState:SetBuild("skin_collector")
    inst.AnimState:PlayAnimation("idle", true)    
    
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("skin_collecter.tex")

    
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

    
    return inst
end



return Prefab( "common/objects/skin_collector", fn, assets),
       MakePlacer( "common/skin_collector_placer", "skin_collector", "skin_collector", "idle")