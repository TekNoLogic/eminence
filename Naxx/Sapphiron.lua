
-- Berserk (wipe) after 15 minutes
local saffy = Eminence:new(15989)
saffy.mobguid = 15989


local wipetime
function saffy:Engage()
	wipetime = GetTime() + 900
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RunStopwatch(0, 60, "Air Phase:") -- This may be 69sec, not sure
end


function saffy:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg == "Sapphiron lifts off into the air!" then
		self:RunStopwatch(0, 25, "Frost Breath:") -- 15sec until Frost Breath starts cast
	elseif msg == "%s takes a deep breath." then
		self:RunStopwatch(0, 10, "Frost Breath:") -- 10sec until Frost Breath goes off
	elseif msg == "Sapphiron resumes his attacks!" then
		self:RunStopwatch(0, 60, "Air Phase:") -- 60sec until next air phase
	end
end

