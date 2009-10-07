
local anub = Eminence:new(15956)
anub.mobguid = 15956


local SWARM = GetSpellInfo(54021)
function gluth:Engage()
	local firsttime = GetRaidDifficulty() == 1 and 102 or 90
	self:RegisterCombatLogEvent("SPELL_AURA_APPLIED", 28785, 54021)
	self:RegisterCombatLogEvent("SPELL_AURA_REMOVED", 28785, 54021)
	self:RunStopwatch(0, firsttime, SWARM..":")
end


function gluth:CLEU_SPELL_AURA_APPLIED()
	self:RunStopwatch(0, 20, SWARM..":")
end


function gluth:CLEU_SPELL_AURA_REMOVED()
	self:RunStopwatch(0, 65, SWARM..":")
end
