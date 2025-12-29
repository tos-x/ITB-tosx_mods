
local path = GetParentPath(...)
local dialog = require(path.."dialog")

-- create personality
local personality = CreatePilotPersonality("Vertex", "Reyna Salazar")
personality:AddDialogTable(dialog)

-- create ceo
local ceo = easyEdit.ceo:add("Vertex")
ceo:setPersonality(personality)
ceo:setPortrait("img/ceo/portrait.png")
ceo:setOffice("img/ceo/office.png", "img/ceo/office_small.png")
--ceo:setFinalMission("Mission_Train")
