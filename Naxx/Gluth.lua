
-- The Arachnid Quarter
-- The Construct Quarter
-- The Military Quarter
-- The Plague Quarter


-- Decimate every 105 seconds, Frenzy (wipe) after 480 seconds (420 heroic)
local gluth = Eminence:new()
gluth.mobguid = 15932


local started = nil
local wipetime
function gluth:Engage()
	wipetime = GetTime() + (GetCurrentDungeonDifficulty() == 1 and 480 or 420)
	gluth:CLEU_SPELL_DAMAGE()
end


local last = 0
gluth:RegisterCombatLogEvent("SPELL_DAMAGE", 28375, 54426)
function gluth:CLEU_SPELL_DAMAGE() -- Decimate
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if (GetTime() + 105) < wipetime then
			self:RunStopwatch(0, 105, "Decimate:")
		else
			self:RunStopwatch(0, wipetime - GetTime(), "Wipe:")
		end
	end
end


gluth:RegisterCombatLogEvent("SPELL_MISSED", 28375, 54426)
gluth.CLEU_SPELL_MISSED = gluth.CLEU_SPELL_DAMAGE
