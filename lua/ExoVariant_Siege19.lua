if Client then
    local origWeapon = ExoVariantMixin.GetWeaponLoadoutClass
    function ExoVariantMixin:GetWeaponLoadoutClass()
        if not 
                self:isa("Exosuit") 
        and not 
                self:isa("ReadyRoomExo")
        then
                local weapon = self:GetActiveWeapon():GetLeftSlotWeapon():GetClassName()
                if 
                    weapon == "ExoFlamer" 
                or 
                    weapon == "ExoWelder" 
                or 
                    weapon == "ExoGrenader" 
                then
                    return "Railgun"
                end//If weapon is Flamer/Welder/Grenader
        end//Not Exosuit or ReadyRoom
            return origWeapon(self)
    end//Function
 end//Client