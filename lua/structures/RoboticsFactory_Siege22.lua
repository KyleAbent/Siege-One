Script.Load("lua/Additions/LevelsMixin.lua")
Script.Load("lua/Additions/AvocaMixin.lua")

local networkVars = {}

AddMixinNetworkVars(LevelsMixin, networkVars)
AddMixinNetworkVars(AvocaMixin, networkVars)

local origInit = RoboticsFactory.OnInitialized
function RoboticsFactory:OnInitialized()
    origInit(self)
    InitMixin(self, LevelsMixin)
    InitMixin(self, AvocaMixin)
end


--override
function RoboticsFactory:OverrideCreateManufactureEntity(techId)

    if techId == kTechId.ARC or techId == kTechId.MAC then
    
        self.researchId = techId
        self.builtEntity = self:ManufactureEntity()
        self.builtEntity:Rollout(self, 3)

        return self.builtEntity
     
    end
    
end

/*
local origButton = RoboticsFactory.GetTechButtons
function RoboticsFactory:GetTechButtons(techId)

    local buttons = origButton(self, techId)
               
    if self:GetTechId() == kTechId.ARCRoboticsFactory then
        buttons[1] = kTechId.DropARC
    else
        return buttons    
    end           

    return buttons
end
*/

Shared.LinkClassToMap("RoboticsFactory", RoboticsFactory.kMapName, networkVars) 
