//Kyle 'Avoca' Abent

//Write this smart without getting messy with VoiceOver lua , just do the small area necessary hehe.


local function BuyMist(player)

    if player then
        player:HookWithShineToBuyMist(player)
    end  
    
    
end

local function BuyMed(player)

    if player then
        player:HookWithShineToBuyMed(player)
    end  
    
    
end

local function BuyAmmo(player)

    if player then
        player:HookWithShineToBuyAmmo(player)
    end  
    
    
end
local orig = CreateVoiceMessage

function CreateVoiceMessage(player, voiceId)
//print("Hook CreateVoiceMessage")

    //print("voiceId is ")
    local str = ( EnumToString(kVoiceId, voiceId) ) //oh it's kVoiceId. and not kTechId. how interesting
    if voiceId == kVoiceId.AlienRequestMist then
        //print("CreateVoiceMessage voiceId AlienAlertNeedMist")
        BuyMist(player)
    elseif string.find( str, "Medpack" )  then
        print("CreateVoiceMessage voiceId MarineRequestMedpack")
        BuyMed(player)
    elseif string.find( str, "Ammo" ) then
        print("CreateVoiceMessage voiceId MarineRequestAmmo")
        BuyAmmo(player)
    else
        orig(player,voiceId)
    end

end