
local function IsSpam(text)
	if type(text) ~= "string" then return end
	if string.find(text, "%*%*%*") then return true end
end


local function filter(self, event, msg)
	if select(4, GetBuildInfo()) < 30100 then msg = self end
	if IsSpam(msg) then return true end
end

for _,chan in pairs{"CHAT_MSG_WHISPER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_WARNING", "CHAT_MSG_RAID_LEADER"} do ChatFrame_AddMessageEventFilter(chan, filter) end


local o = RaidNotice_AddMessage
local RaidWarningFrame = RaidWarningFrame
function RaidNotice_AddMessage(self, message, ...)
	if self == RaidWarningFrame and IsSpam(message) then return end
	return o(self, message, ...)
end


-- Gotta hook this bitch or we'll get the noise but no message
local o2 = RaidWarningFrame_OnEvent
function RaidWarningFrame_OnEvent(self, event, message, ...)
	if IsSpam(message) then return end
	return o2(self, event, message, ...)
end
