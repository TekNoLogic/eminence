
local GUIDtoMobID = LibStub("tekmobIDmemo")


local template = {}


function Eminence:new(...)
	local f = CreateFrame("frame")
	for i in pairs(template) do f[i] = template[i] end
	f:SetScript("OnEvent", template.OnEvent)
	for i=1,select("#", ...) do self.engagetriggers[select(i, ...)] = f end
	return f
end


-- Pass spellIDs to filter, or 0 to get every trigger of the event
function template:RegisterCombatLogEvent(event, ...)
	self.cleu_ids = self.cleu_ids or {}
	self.cleu_ids[event] = self.cleu_ids[event] or {}
	for i=1,select("#", ...) do self.cleu_ids[event][select(i, ...)] = true end
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end


function template:OnEvent(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, combatevent, _, _, _, _, _, _, spellID = ...
		local func = "CLEU_"..combatevent
		if self[func] and self.cleu_ids[combatevent] and (self.cleu_ids[combatevent][spellID] or self.cleu_ids[combatevent][0]) then return self[func](self, ...) end

	elseif self[event] then return self[event](self, event, ...) end
end


function template:RunStopwatch(m, s, label)
	Stopwatch_StartCountdown(0, m, s)
	Stopwatch_Play()
	if label then StopwatchTitle:SetText(label) end
end


function template:HideStopwatch()
	Stopwatch_Clear()
	StopwatchFrame:Hide()
end

