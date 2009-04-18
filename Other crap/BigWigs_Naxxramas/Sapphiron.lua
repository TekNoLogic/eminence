
local breath = 1

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Drain", 28542, 55665)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Breath", 28524, 29318)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	breath = 1
end


function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == "Sapphiron lifts off into the air!" then
		self:CancelScheduledEvent("Lifedrain")
		self:TriggerEvent("BigWigs_StopBar", self, "~Possible Life Drain")
		--43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
		self:IfMessage("Ice Bomb casting in ~14sec!", "Attention")
		self:Bar("Ice Bomb Cast", 14, 43810)
		self:DelayedMessage(9, "Ice Bomb casting in ~5sec!", "Attention")
	elseif msg == "%s takes a deep breath." then
		self:IfMessage("Ice Bomb Incoming!", "Attention")
		self:Bar("Ice Bomb Lands!", 10, 29318)
	end
end


function mod:Breath(_, spellId)
	breath = breath + 1
	if breath == 2 then
		self:IfMessage("Ice Bomb", "Important", spellId)
	end
end


function mod:Drain(_, spellID)
	self:IfMessage("Life Drain! Next in ~24sec!", "Urgent", spellID)
	self:Bar("~Possible Life Drain", 23, spellID)
	self:ScheduleEvent("Lifedrain", "BigWigs_Message", 18, "Life Drain in ~5sec!", "Important")
end
