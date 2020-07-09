
local orig = GUIChat.AddMessage

function GUIChat:AddMessage(playerColor, playerName, messageColor, messageText, isCommander, isRookie)

    if string.find(playerName, "Avoca") then
        orig(self, 0xCC0000 , playerName, messageColor, messageText, isCommander, isRookie)
    else
        orig(self, playerColor, playerName, messageColor, messageText, isCommander, isRookie)
    end
    
end

/*


local origUpdate = GUIChat.Update
function GUIChat:Update(deltaTime)

    
    local addChatMessages = ChatUI_GetMessages()
    local numberElementsPerMessage = 8
    local numberMessages = table.icount(addChatMessages) / numberElementsPerMessage
    local currentIndex = 1

    while numberMessages > 0 do
    
        local playerColor = addChatMessages[currentIndex]
        local playerName = addChatMessages[currentIndex + 1]
        local messageColor = addChatMessages[currentIndex + 2]
        
        if string.find("Avoca",playerName) then
            addChatMessages[currentIndex + 2] = 00FF00
        end
    
    end
    
    
    origUpdate(self, deltaTime)
    
end

*/