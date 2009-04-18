----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Heigan the Unclean"]
local mod = BigWigs:New(boss, tonumber(("$Revision: 4980 $"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15936
mod.toggleoptions = {"engage", "teleport", "bosskill"}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Heigan",

	starttrigger = "You are mine now.",
	starttrigger2 = "You... are next.",
	starttrigger3 = "I see you...",

	engage = "Engage",
	engage_desc = "Warn when Heigan is engaged.",
	engage_message = "Heigan the Unclean engaged! 90 sec to teleport!",

	teleport = "Teleport",
	teleport_desc = "Warn for Teleports.",
	teleport_trigger = "The end is upon you.",
	teleport_1min_message = "Teleport in 1 min",
	teleport_30sec_message = "Teleport in 30 sec",
	teleport_10sec_message = "Teleport in 10 sec!",
	on_platform_message = "Teleport! On platform for 45 sec!",

	to_floor_30sec_message = "Back in 30 sec",
	to_floor_10sec_message = "Back in 10 sec!",
	on_floor_message = "Back on the floor! 90 sec to next teleport!",

	teleport_bar = "Teleport!",
	back_bar = "Back on the floor!",
} end )

L:RegisterTranslations("ruRU", function() return {
	starttrigger = "Теперь вы принадлежите мне!",  
	starttrigger2 = "Пришло ваше время...",  
	starttrigger3 = "Я вижу вас...", 

	engage = "Исступление",
	engage_desc = "Предупреждать, когда Хейган впадает в Исступление.",
	engage_message = "Хейган в Исступлении! 90 секунд до телепорта!",

	teleport = "Телепорт",
	teleport_desc = "Предупреждать о телепорте.",
	teleport_trigger = "Вам конец.",  
	teleport_1min_message = "Телепорт через 1 минуту",
	teleport_30sec_message = "Телепорт через 30 секунд",
	teleport_10sec_message = "Телепорт через 10 секунд!",
	on_platform_message = "Телепорт! 45 секунд На платформе!",

	to_floor_30sec_message = "Возвращение через 30 секунд",
	to_floor_10sec_message = "Возвращение через 10 секунд!",
	on_floor_message = "Возвращается! 90 секунд до следующего телепорта!",

	teleport_bar = "Телепорт!",
	back_bar = "Возвращение!",
} end )

L:RegisterTranslations("koKR", function() return {
	starttrigger = "이제 넌 내 것이다.",
	starttrigger2 = "다음은... 너다.",
	starttrigger3 = "네가 보인다...",

	engage = "전투 시작",
	engage_desc = "헤이건 전투 시작을 알립니다.",
	engage_message = "부정의 헤이건, 90초 후 단상으로 순간 이동",

	teleport = "순간이동",
	teleport_desc = "순간이동을 알립니다.",
	teleport_trigger = "여기가 너희 무덤이 되리라.",
	teleport_1min_message = "60초 후 순간이동!",
	teleport_30sec_message = "30초 후 순간이동!",
	teleport_10sec_message = "10초 후 순간이동!",
	on_platform_message = "순간이동! 45초간 단상!",

	to_floor_30sec_message = "30초 후 단상 내려옴!",
	to_floor_10sec_message = "10초 후 단상 내려옴!",
	on_floor_message = "헤이건 내려옴! 90초 후 순간이동!",

	teleport_bar = "순간이동!",
	back_bar = "단상으로 이동!",
} end )

L:RegisterTranslations("deDE", function() return {
	starttrigger = "Ihr gehört mir...",
	starttrigger2 = "Ihr seid.... als nächstes dran.",
	starttrigger3 = "Ihr entgeht mir nicht...",
	
	engage = "Angriff",
	engage_desc = "Warnt, wenn Heigan angegriffen wird.",
	engage_message = "Heigan der Unreine angegriffen! Teleport in 90 sek!",
	
	teleport = "Teleport",
	teleport_desc = "Warnungen und Timer für Teleport.",
	teleport_trigger = "Euer Ende naht.",
	teleport_1min_message = "Teleport in 1 min",
	teleport_30sec_message = "Teleport in 30 sek",
	teleport_10sec_message = "Teleport in 10 sek!",
	on_platform_message = "Teleport! Auf Plattform für 45 sek!",

	to_floor_30sec_message = "Zurück in 30 sek",
	to_floor_10sec_message = "Zurück in 10 sek!",
	on_floor_message = "Zurück im Raum! Nächster Teleport in 90 sek!",

	teleport_bar = "Teleport",
	back_bar = "Zurück im Raum",
} end )

L:RegisterTranslations("zhCN", function() return {
	starttrigger = "你是我的了。",
	starttrigger2 = "你……就是下一个。",
	starttrigger3 = "我看到你了……",

	engage = "激活",
	engage_desc = "当激活时发出警报。",
	engage_message = "希尔盖已激活 - 90秒后，传送！",
	
	teleport = "传送",
	teleport_desc = "当传送时发出警报。",
	teleport_1min_message = "1分钟后传送",
	teleport_30sec_message = "30秒后传送",
	teleport_10sec_message = "10秒后传送！",
	teleport_trigger = "你的生命正走向终结。",
	on_platform_message = "传送！45秒后希尔盖出现！",

	to_floor_30sec_message = "30秒后返回",
	to_floor_10sec_message = "10秒后返回！",
	on_floor_message = "返回！90秒后，传送！",

	teleport_bar = "<传送>",
	back_bar = "<出现>",
} end )

L:RegisterTranslations("zhTW", function() return {
	starttrigger = "你是我的了。",
	starttrigger2 = "你……就是下一個。",
	starttrigger3 = "我看到你了……",

	engage = "進入戰鬥",
	engage_desc = "當海根進入戰鬥時發出警報。",
	engage_message = "海根已進入戰鬥 - 90秒後，傳送！",

	teleport = "傳送",
	teleport_desc = "當傳送時發出警報。",
	teleport_1min_message = "1分鐘後傳送",
	teleport_30sec_message = "30秒後傳送",
	teleport_10sec_message = "10秒後傳送！",
	teleport_trigger = "你的生命正走向終結。",
	on_platform_message = "傳送！ - 45秒後海根出現！",

	to_floor_30sec_message = "30 秒後返回",
	to_floor_10sec_message = "10 秒後返回！",
	on_floor_message = "返回！90秒後，傳送！",

	teleport_bar = "<傳送>",
	back_bar = "<出現>",
} end )

L:RegisterTranslations("frFR", function() return {
	starttrigger = "Vous êtes à moi, maintenant.",
	starttrigger2 = "Tu es… le suivant.",
	starttrigger3 = "Je vous vois…",

	engage = "Engagement",
	engage_desc = "Prévient quand Heigan est engagé.",
	engage_message = "Heigan l'Impur engagé ! 90 sec. avant téléportation !",

	teleport = "Téléportation",
	teleport_desc = "Prévient quand Heigan se téléporte.",
	teleport_trigger = "Votre fin est venue.",
	teleport_1min_message = "Téléportation dans 1 min.",
	teleport_30sec_message = "Téléportation dans 30 sec.",
	teleport_10sec_message = "Téléportation dans 10 sec. !",
	on_platform_message = "Téléportation ! Sur la plate-forme pendant 45 sec. !",

	to_floor_30sec_message = "De retour dans 30 sec.",
	to_floor_10sec_message = "De retour dans 10 sec. !",
	on_floor_message = "De retour sur le sol ! 90 sec. avant la prochaine téléportation !",

	teleport_bar = "Téléportation !",
	back_bar = "Retour sur le sol !",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["starttrigger"]) or msg:find(L["starttrigger2"]) or msg:find(L["starttrigger3"]) then
		if self.db.profile.engage then
			self:Message(L["engage_message"], "Important")
		end
		if self.db.profile.teleport then
			self:Bar(L["teleport_bar"], 90, "Spell_Arcane_Blink")
			self:DelayedMessage(30, L["teleport_1min_message"], "Attention")
			self:DelayedMessage(60, L["teleport_30sec_message"], "Urgent")
			self:DelayedMessage(80, L["teleport_10sec_message"], "Important")
		end
	elseif msg:find(L["teleport_trigger"]) then
		self:ScheduleEvent("BWBackToRoom", self.BackToRoom, 45, self)

		if self.db.profile.teleport then
			self:Message(L["on_platform_message"], "Attention")
			self:DelayedMessage(15, L["to_floor_30sec_message"], "Urgent")
			self:DelayedMessage(35, L["to_floor_10sec_message"], "Important")
			self:Bar(L["back_bar"], 45, "Spell_Magic_LesserInvisibilty")
		end
	end
end

function mod:BackToRoom()
	if self.db.profile.teleport then
		self:Message(L["on_floor_message"], "Attention")
		self:DelayedMessage(60, L["teleport_30sec_message"], "Urgent")
		self:DelayedMessage(80, L["teleport_10sec_message"], "Important")
		self:Bar(L["teleport_bar"], 90, "Spell_Arcane_Blink")
	end
end

