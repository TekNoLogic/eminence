
local GUIDtoMobID = LibStub("tekmobIDmemo")


-- Phase 1: Stalagg and Feugen, Magnetic Pull (swap tanks) every 30sec
-- When Stalagg and Feugen are dead, switch to phase 2
-- Phase 2: Polarity Shift every 30 seconds, wipe after 6 minutes
local thad = Eminence:new(15929, 15930)
thad.mobguid = 15928


local stalaggdead, feugendead, wipetime
function thad:Engage()
	stalaggdead, feugendead, wipetime = nil

	self:RunStopwatch(0, 20, "Mag Pull:")

	self:RegisterCombatLogEvent("SPELL_CAST_SUCCESS", 54517)
	self:RegisterCombatLogEvent("UNIT_DIED", 0)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end


function thad:CLEU_SPELL_CAST_SUCCESS() -- Magnetic Pull
	self:RunStopwatch(0, 20, "Mag Pull:")
end


function thad:CLEU_UNIT_DIED(_, _, _, _, _, guid)
	local mobid = GUIDtoMobID[guid]

	if mobid == 15929 then stalaggdead = true end
	if mobid == 15930 then feugendead = true end

	if stalaggdead and feugendead and not wipetime then
		wipetime = GetTime() + 360 -- 6 Minutes
		self:RunStopwatch(0, 30, "Polarity:")
	end
end


function thad:CHAT_MSG_RAID_BOSS_EMOTE(event, msg) -- Polarity
	if msg == "The polarity has shifted!" then
		if (GetTime() + 30) < wipetime then
			self:RunStopwatch(0, 30, "Polarity:")
		else
			self:RunStopwatch(0, wipetime - GetTime(), "Wipe:")
		end
	end
end
