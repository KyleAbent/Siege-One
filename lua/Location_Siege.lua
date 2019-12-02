if Server then
  local orig = Location.OnTriggerEntered
   function Location:OnTriggerEntered(entity, triggerEnt)
     orig(self, entity, triggerEnt)
         if GetGamerules():GetGameStarted() then
              if (  ( string.find(self.name, "siege") or string.find(self.name, "Siege") )  and not GetTimer():GetIsSiegeOpen() ) then
                  entity:Kill() 
               end
         end
    end
end