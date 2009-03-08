
local GUIDtoMobID = LibStub("tekmobIDmemo")


local debugf = tekDebug and tekDebug:GetFrame("Eminence")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end end


Eminence = CreateFrame("Frame")
Eminence.engagetriggers = {}


local o = Stopwatch_Clear
function Stopwatch_Clear(...)
  StopwatchTitle:SetText("Stopwatch:")
  return o(...)
end


local function TestUnit(unit)
	return UnitExists(unit) and UnitAffectingCombat(unit) and Eminence.engagetriggers[GUIDtoMobID[UnitGUID(unit)]]
end


local raidtargets, partytargets = {}, {}
for i=1,4 do partytargets[i] = "party"..i.."target" end
for i=1,40 do raidtargets[i] = "raid"..i.."target" end
local function Scan()
	local f = TestUnit("target"); if f then return f end
	local f = TestUnit("focus"); if f then return f end

	local numr = GetNumRaidMembers()
	if numr == 0 then for i=1,GetNumPartyMembers() do local f = TestUnit(partytargets[i]); if f then return f end end
	else for i=1,numr do local f = TestUnit(raidtargets[i]); if f then return f end end end
end


local CheckForEngage, CheckForWipe
local checkengageat, checkwipeat, engaged
function CheckForEngage(self, event, ...)
	if checkengageat and checkengageat > GetTime() then return end

	local f = Scan()
	if f then
		Debug("Detected engage", f.mobguid)
		engaged = f
		checkengageat = nil
		self:Hide()
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", CheckForWipe)
		if f.Engage then f:Engage() end

	elseif UnitAffectingCombat("player") then
		checkengageat = GetTime() + 0.5
		self:SetScript("OnUpdate", CheckForEngage)
		self:Show()

	else
		checkengageat = nil
		self:Hide()
	end
end


local function Cleanup(self)
	checkwipeat = nil
	self:Hide()
	local f = engaged
	engaged = nil
	f:UnregisterAllEvents()
	self:UnregisterAllEvents()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:SetScript("OnEvent", CheckForEngage)
	Stopwatch_Clear()
	StopwatchFrame:Hide()
	return f
end


function CheckForWipe(self, event, ...)
	if event and event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, combatevent, _, _, _, guid, _, spellID = ...
		if combatevent ~= "UNIT_DIED" or GUIDtoMobID[guid] ~= engaged.mobguid then return end

		Debug("Detected boss death")
		local f = Cleanup(self)
		if f.BossDeath then f:BossDeath() end
		return
	end

	if checkwipeat and checkwipeat > GetTime() then return end

	if not UnitIsFeignDeath("player") and not Scan() then
		Debug("Detected wipe")
		local f = Cleanup(self)
		if f.Wipe then f:Wipe() end
		return
	end

	if not UnitAffectingCombat("player") then
		checkwipeat = GetTime() + 2
		self:SetScript("OnUpdate", CheckForWipe)
		self:Show()
	else
		checkwipeat = nil
		self:Hide()
	end
end


Eminence:SetScript("OnEvent", CheckForEngage)
Eminence:RegisterEvent("PLAYER_REGEN_DISABLED")
