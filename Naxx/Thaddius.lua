
-- Phase 1: Stalagg and Feugen, Magnetic Pull (swap tanks) every 30sec
-- Phase 2: Polarity Shift every 30 seconds, wipe after 6 minutes
local thad = LibStub("Eminence-module").new()
thad.mobguid = 15928
thad.engagetrigger = {15929, 15930}


--~ local stage1warn, pullTime

--~ L:RegisterTranslations("enUS", function() return {
--~ 	trigger_phase1_1 = "Stalagg crush you!",
--~ 	trigger_phase1_2 = "Feed you to master!",
--~ 	trigger_phase2_1 = "Eat... your... bones...",
--~ 	trigger_phase2_2 = "Break... you!!",
--~ 	trigger_phase2_3 = "Kill...",
--~ } end)


local stalaggdead, feugendead, wipetime
function thad:Engage()
	stalaggdead, feugendead, wipetime = nil
--~ 	stage1warn, pullTime = nil

--~ 	self:AddCombatListener("SPELL_CAST_START", 28089)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end


thad:RegisterCombatLogEvent("SPELL_CAST_SUCCESS", 54517)
function thad:CLEU_SPELL_CAST_SUCCESS()
	self:RunStopwatch(0, 20, "Mag Pull:")
end


-- When Stalagg and Feugen are dead, switch to polarity timers
local orig = thad.CLEU_UNIT_DIED
function thad:CLEU_UNIT_DIED(...)
	local _, _, _, _, _, guid = ...
	local mobid = GUIDtoMobID[guid]

	if mobid == 15929 then stalaggdead = true end
	if mobid == 15930 then feugendead = true end

	if stalaggdead and feugendead and not wipetime then
		wipetime = GetTime() + 360 -- 6 Minutes
		self:RunStopwatch(0, 30, "Polarity:")
	end

	return orig(self, ...)
end


--~ function thad:CLEU_SPELL_CAST_START() -- Polarity (+3 sec cast)
thad:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
function thad:CHAT_MSG_RAID_BOSS_EMOTE(event, msg) -- Polarity
	if msg == "The polarity has shifted!" then
		if (GetTime() + 30) < wipetime then
			self:RunStopwatch(0, 30, "Polarity:")
		else
			self:RunStopwatch(0, wipetime - GetTime(), "Wipe:")
		end
	end
end




--~ function mod:Polarity()
--~ 	pullTime = GetTime()
--~ 	self:IfMessage("Polarity Shift incoming!", "Important", 28089)
--~ end


--~ local function magpull()
--~ 	if pullTime then return end
--~ 	mod:Bar("Magnetic Pull", 20, "Ability_Druid_Maul")
--~ 	mod:DelayedMessage(15, "Magnetic Pull in ~5 sec!", "Urgent")
--~ 	mod:ScheduleEvent(magpull, 21)
--~ end


--~ local polarity_trigger = "Now you feel pain..."
--~ function mod:CHAT_MSG_MONSTER_YELL(msg)
--~ 	if msg == polarity_trigger then
--~ 		self:DelayedMessage(25, "3 sec to Polarity Shift!", "Important")
--~ 		self:Bar("Polarity Shift", 28, "Spell_Nature_Lightning")
--~ 	elseif msg == L["trigger_phase1_1"] or msg == L["trigger_phase1_2"] then
--~ 		if not stage1warn then self:Message("Phase 1", "Important") end
--~ 		stage1warn = true
--~ 		magpull()
--~ 	elseif msg:find(L["trigger_phase2_1"]) or msg:find(L["trigger_phase2_2"]) or msg:find(L["trigger_phase2_3"]) then
--~ 		self:CancelAllScheduledEvents()
--~ 		self:TriggerEvent("BigWigs_StopBar", self, "Magnetic Pull")
--~ 		self:Message("Phase 2, Berserk in 6 minutes!", "Important")
--~ 		self:Enrage(360, true, true)
--~ 	end
--~ end

