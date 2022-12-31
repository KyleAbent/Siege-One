local origInit = ArmsLab.OnInitialized
function ArmsLab:OnInitialized()
    origInit(self)
    if Server then
        GetImaginator().activeArms = GetImaginator().activeArms + 1
    end    
end

if Server then

     function ArmsLab:PreOnKill(attacker, doer, point, direction)
          if self:GetIsPowered() then
            GetImaginator().activeArms  = GetImaginator().activeArms- 1;  
          end
    end

end