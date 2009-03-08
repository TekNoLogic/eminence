
local GUIDtoMobID = LibStub("tekmobIDmemo")


local template = {}


function Eminence:new()
	local f = CreateFrame("frame")
	for i in pairs(template) do f[i] = template[i] end
	f:SetScript("OnEvent", template.OnEvent)
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	return f
end


function template:RegisterCombatLogEvent(event, ...)
	self.cleu_ids = self.cleu_ids or {}
	self.cleu_ids[event] = self.cleu_ids[event] or {}
	for i=1,select("#", ...) do self.cleu_ids[event][select(i, ...)] = true end
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end


function template:OnEvent(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, combatevent, _, _, _, _, _, spellID = ...
		local func = "CLEU_"..combatevent
		if self[func] and (self.cleu_ids[combatevent][spellID] or self.cleu_ids[combatevent][0]) then return self[func](self, ...) end

	elseif self[event] then return self[event](self, event, ...) end
end


function template:CLEU_UNIT_DIED(_, _, _, _, _, guid)
	if GUIDtoMobID[guid] ~= self.mobguid then return end

	-- TODO: Cleanup
	if self.MobDeath then self:MobDeath() end
	Stopwatch_Clear()
	StopwatchFrame:Hide()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
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


local raidtargets, partytargets = {}, {}
for i=1,4 do partytargets[i] = "party"..i.."target" end
for i=1,40 do raidtargets[i] = "raid"..i.."target" end


function template:TestUnit(unit)
	if UnitExists(unit) and UnitAffectingCombat(unit) and self.scanids[GUIDtoMobID[UnitGUID(unit)]] then return unit end
end


function template:Scan()
	if not self.scanids then
		self.scanids = {}
		if self.engagetrigger then
			if type(self.engagetrigger) == "table" then for _,id in pairs(self.engagetrigger) do self.scanids[id] = true end
			else self.scanids[self.engagetrigger] = true end
		end

		if type(self.mobguid) == "table" then for _,id in pairs(self.mobguid) do self.scanids[id] = true end
		else self.scanids[self.mobguid] = true end
	end

	if self:TestUnit("target") then return true end
	if self:TestUnit("focus") then return true end

	local numr = GetNumRaidMembers()
	if numr == 0 then for i=1,GetNumPartyMembers() do if self:TestUnit(partytargets[i]) then return true end end
	else for i=1,numr do if self:TestUnit(raidtargets[i]) then return true end end end
end


function template:PLAYER_REGEN_DISABLED()
	if self.checkengageat and self.checkengageat > GetTime() then return end

	if self:Scan() then
		self.engaged = true
		self.checkengageat = nil
		self:Hide()
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterCombatLogEvent("UNIT_DIED", 0)
		if self.Engage then self:Engage() end -- Engaged, go go go!

	elseif UnitAffectingCombat("player") then
		self.checkengageat = GetTime() + 0.5
		self:SetScript("OnUpdate", self.PLAYER_REGEN_DISABLED)
		self:Show()
	end
end


function template:PLAYER_REGEN_ENABLED()
	if self.checkwipeat and self.checkwipeat > GetTime() then return end

	if not UnitIsFeignDeath("player") and not self:Scan() then
		self.checkwipeat = nil
		self:Hide()
		self.engaged = nil
		self:UnregisterAllEvents()
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		Stopwatch_Clear()
		StopwatchFrame:Hide()
		if self.Wipe then self:Wipe() end -- We wiped, reset
		return
	end

	if not UnitAffectingCombat("player") then
		self.checkwipeat = GetTime() + 2
		self:SetScript("OnUpdate", self.PLAYER_REGEN_ENABLED)
		self:Show()
	end
end
