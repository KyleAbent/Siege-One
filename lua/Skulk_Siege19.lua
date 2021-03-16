local origInit = Skulk.OnInitialized
function Skulk:OnInitialized()
    origInit(self)

/*
    local upgrades = self.lastUpgradeList or {}
    if upgrades and #upgrades > 0 then
            self:GiveUpgrade(upgrades[i])
            Print("Giving upgrade")
    end
    */
  local client = nil
  
  if Server then
  
  client = self:GetClient()
  if client then
  Print("Found Client")
  end
  
  end

   if client then 
    local player = Client:GetControllingPlayer()
    Print("AAAAAAA")
    if player and player:isa("Alien") and player:GetIsAlive() and not player:isa("Embryo") then
        Print("BBBBBB")
        local class = player:GetClassName()
        local upgrades = player.lastUpgradeList or {}
        upgrades = upgrades[class] or upgrades["Skulk"] or {}
        if upgrades and #upgrades > 0 then
           // if player.autopickedUpgrades then
            //    player:ClearUpgrades()
           // end

            //player:ProcessBuyAction(upgrades)
            player.upgrade1 = upgrades[1] or 1
            player.upgrade2 = upgrades[2] or 1
            player.upgrade3 = upgrades[3] or 1
            
        end
    
    end
    end
 
    
end