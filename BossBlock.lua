
local function IsSpam(text) if type(text) == "string" and string.find(text, "%*%*%*") then return true end end
local function filter(self, event, msg) if IsSpam(msg) then return true end end
for _,chan in pairs{"CHAT_MSG_WHISPER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_WARNING", "CHAT_MSG_RAID_LEADER"} do ChatFrame_AddMessageEventFilter(chan, filter) end


-- Removing this for the moment, as the only places it is called are
-- RaidWarningFrame_OnEvent and RaidBossEmoteFrame_OnEvent.
-- We block RaidWarningFrame_OnEvent below, and we want to allow RaidBossEmoteFrame_OnEvent
--~ local o = RaidNotice_AddMessage
--~ local RaidWarningFrame = RaidWarningFrame
--~ function RaidNotice_AddMessage(self, message, ...)
--~ 	if self == RaidWarningFrame and IsSpam(message) then return end
--~ 	return o(self, message, ...)
--~ end


-- Gotta hook this bitch or we'll get the noise but no message
-- Also have to directly override the OnEvent of the frame because of the new crummy XML handler thingy
local o2 = RaidWarningFrame_OnEvent
RaidWarningFrame:SetScript("OnEvent", function (self, event, message, ...) if IsSpam(message) then return else	return o2(self, event, message, ...) end end)
