----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Kel'Thuzad"]
local mod = BigWigs:New(boss, tonumber(("$Revision: 4948 $"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15990
mod.toggleoptions = { "frostblast", "fissure", "mc", -1, "detonate", "icon", -1 ,"guardians", "phase", "proximity", "bosskill" }
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end

------------------------------
--      Are you local?      --
------------------------------

local FB = {}
local MCd = {}
local fmt = string.format
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Kelthuzad",

	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad's Chamber",

	start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!",
	start_warning = "Kel'Thuzad encounter started! ~3min 30sec till he is active!",
	start_bar = "Phase 2",

	phase = "Phase",
	phase_desc = "Warn for phases.",
	phase2_trigger1 = "Pray for mercy!",
	phase2_trigger2 = "Scream your dying breath!",
	phase2_trigger3 = "The end is upon you!",
	phase2_warning = "Phase 2, Kel'Thuzad incoming!",
	phase2_bar = "Kel'Thuzad Active!",
	phase3_soon_warning = "Phase 3 soon!",
	phase3_trigger = "Master, I require aid!",
	phase3_warning = "Phase 3, Guardians in ~15 sec!",

	mc = "Mind Control",
	mc_desc = "Tells you who has been Mind Control and when the next Mind Control is coming.",
	mc_message = "Mind Control: %s",
	mc_warning = "Mind controls soon!",
	mc_nextbar = "~Mind Controls",

	fissure = "Shadow Fissure",
	fissure_desc = "Alerts about incoming Shadow Fizzures.",
	fissure_warning = "Shadow Fissure!",

	frostblast = "Frost Blast",
	frostblast_desc = "Alerts when people get Frost Blasted.",
	frostblast_bar = "Possible Frost Blast",
	frostblast_message = "%s : Frost Blast",
	frostblast_soon_message = "Possible Frost Blast in ~5 sec!",

	detonate = "Detonate Mana",
	detonate_desc = "Warns about Detonate Mana soon.",
	detonate_you = "Detonate Mana on YOU!",
	detonate_other = "Detonate - %s",
	detonate_possible_bar = "Possible Detonate",
	detonate_warning = "Next Detonate in 5 sec!",

	guardians = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",
	guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!",
	guardians_warning = "Guardians incoming in ~10sec!",
	guardians_bar = "Guardians incoming!",

	icon = "Raid Icon",
	icon_desc = "Place a raid icon on people with Detonate Mana.",
} end )

L:RegisterTranslations("ruRU", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Зал Кел'Тузада",
					 
	start_trigger = "Соратники, слуги, солдаты холодной тьмы! Повинуйтесь зову Кел'Тузада!", 
	start_warning = "Бой с Кел'Тузадом начинается! ~3 мин 30 сек до выхода босса!", 
	start_bar = "Фаза 2",

	phase = "Фазы",
	phase_desc = "Предупреждать когда босс входит в новую фазу.",
	phase2_trigger1 = "Молите о пощаде!",  
	phase2_trigger2 = "Кричите! Кричите изо всех сил!", 
	phase2_trigger3 = 	"Вы уже мертвы!",  
	phase2_warning = "Фаза 2, Кел'Тузад просыпается!",
	phase2_bar = "Кел'Тузад активен!",
	phase3_soon_warning = "Скоро Фаза 3!",
	phase3_trigger = "Господин, мне нужна помощь!",
	phase3_warning = "Фаза 3, защитники через ~15 секунд!",

	mc = "Контроль Разума",
	mc_desc = "Предупреждать когда Кел'Тузад начинает контролировать чей то разум.",
	mc_message = "Контроль Разума: %s",
	mc_warning = "Скоро контроль разума!",
	mc_nextbar = "~Контроль Разума: Восстановление",

	fissure = "Расщелина тьмы",
	fissure_desc = "Сообщать, когда появляется расщелина тьмы.",
	fissure_warning = "Расщелина тьмы!",

	frostblast = "Опасность ледяного взрыва",
	frostblast_desc = "Сообщать, когда ледяной взрыв добирается до игроков.",
	frostblast_bar = "Возможен ледяной взрыв",
	frostblast_message = "%s : ледяной взрыв",
	frostblast_soon_message = "Возможный ледяной взрыв через 15 секунд!",

	detonate = "Опасность взрыва маны",
	detonate_desc = "Сообщать о взрыве маны.",
	detonate_you = "Взрыв маны на Вас!",
	detonate_other = "Взрыв маны - %s",
	detonate_possible_bar = "Возможен взрыв маны",
	detonate_warning = "Следующий взрыв маны через 5 секунд!",

	guardians = "Появление стражей",
	guardians_desc = "Сообщать о появлении стражей ледяной короны в третьей фазе.",
	guardians_trigger = "Хорошо. Воины ледяных пустошей, восстаньте! Повелеваю вам сражаться, убивать и умирать во имя своего повелителя! Не щадить никого!",
	guardians_warning = "Стражи появятся через 15 секунд!",
	guardians_bar = "Появляются стражи!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого наложен эффект взрыва маны (необходимо быть лидером группы или рейда).",
} end )

L:RegisterTranslations("koKR", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "켈투자드의 방",

	start_trigger = "어둠의 문지기와 하수인, 그리고 병사들이여! 나 켈투자드가 부르니 명을 받들라!",
	start_warning = "켈투자드 전투 시작! 약 3분 30초 후 활동!",
	start_bar = "2 단계",

	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	phase2_trigger1 = "자비를 구하라!", -- CHECK
	phase2_trigger2 = "마지막 숨이나 쉬어라!",
	phase2_trigger3 = "최후를 맞이하라!",
	phase2_warning = "2 단계, 켈투자드!",
	phase2_bar = "켈투자드 활동!",
	phase3_soon_warning = "잠시 후 3 단계!",
	phase3_trigger = "주인님, 도와주소서!",
	phase3_warning = "3 단계, 약 15초 이내 수호자 등장!",

	mc = "정신 지배",
	mc_desc = "정신 지배에 걸린 플레이어와 다음 정신 지배에 대해 알립니다.",
	mc_message = "정신 지배: %s",
	mc_warning = "정신 지배 대기시간 종료 - 곧 사용!",
	mc_nextbar = "~정배 대기 시간",

	fissure = "어둠의 균열",
	fissure_desc = "어둠의 균열 시전을 알립니다.",
	fissure_warning = "어둠의 균열!",

	frostblast = "냉기 작렬",
	frostblast_desc = "냉기 작렬을 알립니다.",
	frostblast_bar = "냉기 작렬 가능",
	frostblast_message = "냉기 작렬: %s",
	frostblast_soon_message = "약 5초 이내 냉기 작렬 가능!",

	detonate = "마나 폭발",
	detonate_desc = "마나 폭발을 알립니다.",
	detonate_you = "당신은 마나 폭발!",
	detonate_other = "마나 폭발 - %s",
	detonate_possible_bar = "폭발 가능",
	detonate_warning = "약 5초 이내 마나 폭발 가능!",

	guardians = "수호자 생성",
	guardians_desc = "3 단계의 수호자 소환을 알립니다.",
	guardians_trigger = "좋다. 얼어붙은 땅의 전사들이여, 일어나라! 너희에게 싸울 것을 명하노라. 날 위해 죽고, 날 위해 죽여라! 한 놈도 살려두지 마라!",
	guardians_warning = "10초 이내 수호자 등장!",
	guardians_bar = "수호자 등장!",

	icon = "전술 표시",
	icon_desc = "마나 폭발 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("deDE", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzads Gemach",

	start_trigger = "Lakaien, Diener, Soldaten der eisigen Finsternis! Folgt dem Ruf von Kel'Thuzad!",
	start_warning = "Kel'Thuzad gestartet! ~3:30 min, bis er aktiv wird!",
	start_bar = "Phase 2",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase2_trigger1 = "Betet um Gnade!",
	phase2_trigger2 = "Schreiend werdet ihr diese Welt verlassen!",
	phase2_trigger3 = "Euer Ende ist gekommen!",
	phase2_warning = "Phase 2, Kel'Thuzad kommt!",
	phase2_bar = "Kel'Thuzad aktiv",
	phase3_soon_warning = "Phase 3 bald!",
	phase3_trigger = "Meister, ich benötige Beistand.",
	phase3_warning = "Phase 3, Wächter in ~15 sek!",

	mc = "Gedankenkontrolle",
	mc_desc = "Warnungen und Timer für Gedankenkontrolle.",
	mc_message = "Gedankenkontrolle: %s",
	mc_warning = "Gedankenkontrolle bald!",
	mc_nextbar = "~Gedankenkontrolle",

	fissure = "Schattenspalt",
	fissure_desc = "Warnt, wenn Schattenspalt gewirkt wird.",
	fissure_warning = "Schattenspalt!",

	frostblast = "Frostschlag",
	frostblast_desc = "Warnungen und Timer für Frostschlag.",
	frostblast_bar = "~Frostschlag",
	frostblast_message = "Frostschlag: %s",
	frostblast_soon_message = "Frostschlag in ~5 sek!",

	detonate = "Detonierendes Mana",
	detonate_desc = "Warnungen und Timer für Detonierendes Mana.",
	detonate_you = "Detonierendes Mana auf DIR!",
	detonate_other = "Detonierendes Mana: %s",
	detonate_possible_bar = "~Detonierendes Mana",
	detonate_warning = "Detonierendes Mana in 5 sek!",

	guardians = "Wächter",
	guardians_desc = "Warnt vor den Wächtern von Eiskrone in Phase 3.",
	guardians_trigger = "Wohlan, Krieger der Eisigen Weiten, erhebt euch! Ich befehle euch für euren Meister zu kämpfen, zu töten und zu sterben! Keiner darf überleben!",
	guardians_warning = "Wächter in ~10 sek!",
	guardians_bar = "Wächter kommen",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Detonierendes Mana gewirkt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "克尔苏加德的大厅",

	start_trigger = "仆从们，侍卫们，隶属于黑暗与寒冷的战士们！听从克尔苏加德的召唤！",
	start_warning = "战斗开始，约3分30秒后，克尔苏加德激活！",
	start_bar = "<第二阶段>",

	phase = "阶段",
	phase_desc = "当进入不同阶段时发出警报。",
	phase2_trigger1 = "祈祷我的慈悲吧！",
	phase2_trigger2 = "呼出你的最后一口气！",
	phase2_trigger3 = "你的末日临近了！",
	phase2_warning = "第二阶段 - 克尔苏加德！",
	phase2_bar = "<激活克尔苏加德>",
	phase3_soon_warning = "即将 第三阶段！",
	phase3_trigger = "主人，我需要帮助！",
	phase3_warning = "第三阶段 - 约15秒后，寒冰皇冠卫士出现！",

	mc = "克尔苏加德锁链",
	mc_desc = "当玩家中了克尔苏加德锁链时发出警报。",
	mc_message = "克尔苏加德锁链：>%s<！",
	mc_warning = "即将 克尔苏加德锁链！",
	mc_nextbar = "<下一克尔苏加德锁链>",

	fissure = "暗影裂隙",
	fissure_desc = "当施放暗影裂隙时发出警报。",
	fissure_warning = "暗影裂隙！",

	frostblast = "冰霜冲击",
	frostblast_desc = "当玩家中了冰霜冲击时发出警报。",
	frostblast_bar = "<可能 冰霜冲击>",
	frostblast_message = "冰霜冲击：>%s<！",
	frostblast_soon_message = "约5秒后，可能冰霜冲击！",

	detonate = "自爆法力",
	detonate_desc = "当玩家中了自爆法力时发出警报。",
	detonate_you = ">你< 自爆法力！",
	detonate_other = "自爆法力：>%s<！",
	detonate_possible_bar = "<可能 自爆法力>",
	detonate_warning = "约5秒后，自爆法力！",

	guardians = "寒冰皇冠卫士",
	guardians_desc = "当第三阶段召唤寒冰皇冠卫士时发出警报。",
	guardians_trigger = "很好，冰荒废土的战士们，起来吧！我命令你们为主人而战斗，杀戮，直到死亡！一个活口都不要留！",
	guardians_warning = "约10秒后，寒冰皇冠卫士出现！",
	guardians_bar = "<寒冰皇冠卫士出现>",

	icon = "团队标记",
	icon_desc = "为中了自爆法力的玩家打上团队标记。（需要权限）",
} end )


L:RegisterTranslations("zhTW", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "科爾蘇加德的大廳",

	start_trigger = "僕從們，侍衛們，隸屬於黑暗與寒冷的戰士！聽從科爾蘇加德的召換！",
	start_warning = "戰斗開始，約3分30秒後，科爾蘇加德進入戰鬥！",
	start_bar = "<第二階段>",

	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",
	phase2_trigger1 = "祈禱我的慈悲吧",
	phase2_trigger2 = "呼出你的最後一口氣",
	phase2_trigger3 = "The end is upon you!", -- yell required
	phase2_warning = "第二階段 - 科爾蘇加德！",
	phase2_bar = "<科爾蘇加德進入戰鬥>",
	phase3_soon_warning = "即將 第三階段！",
	phase3_trigger = "主人，我需要幫助",
	phase3_warning = "第三階段開始， 約15秒後，寒冰皇冠守衛者出現！",

	mc = "科爾蘇加德之鍊",
	mc_desc = "當玩家中了科爾蘇加德之鍊時發出警報。",
	mc_message = "科爾蘇加德之鍊：>%s<！",
	mc_warning = "即將 科爾蘇加德之鍊！",
	mc_nextbar = "<下一科爾蘇加德之鍊>",

	fissure = "暗影裂縫",
	fissure_desc = "當施放暗影裂縫時發出警報。",
	fissure_warning = "暗影裂縫！",

	frostblast = "冰霜衝擊",
	frostblast_desc = "當玩家中了冰霜衝擊時發出警報。",
	frostblast_bar = "<可能 冰霜衝擊>",
	frostblast_message = "冰霜衝擊：>%s<！",
	frostblast_soon_message = "約5秒後，可能冰霜衝擊！",

	detonate = "爆裂法力",
	detonate_desc = "當玩家中了爆裂法力時發出警報。",
	detonate_you = ">你< 爆裂法力！",
	detonate_other = "爆裂法力：>%s<！",
	detonate_possible_bar = "<可能 爆裂法力>",
	detonate_warning = "約5秒后，爆裂法力！",

	guardians = "寒冰皇冠守衛者",
	guardians_desc = "當第三階段召喚寒冰皇冠守衛者時發出警報。",
	guardians_trigger = "非常好，凍原的戰士們，起來吧!我命令你們作戰，為你們的主人殺戮或獻身吧!不要留下活口",
	guardians_warning = "約10秒後，寒冰皇冠守衛者出現！",
	guardians_bar = "<寒冰皇冠守衛者出現>",

	icon = "團隊標記",
	icon_desc = "為中了爆裂法力的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("frFR", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Appartements de Kel'Thuzad",

	start_trigger = "Serviteurs, valets et soldats des ténèbres glaciales ! Répondez à l'appel de Kel'Thuzad !",
	start_warning = "Kel'Thuzad engagé ! ~3 min. 30 sec. avant qu'il ne soit actif !",
	start_bar = "Phase 2",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase2_trigger1 = "Faites vos prières !",
	phase2_trigger2 = "Hurlez et expirez !",
	phase2_trigger3 = "Votre fin est proche !",
	phase2_warning = "Phase 2, arrivée de Kel'Thuzad !",
	phase2_bar = "Kel'Thuzad actif !",
	phase3_soon_warning = "Phase 3 imminente !",
	phase3_trigger = "Maître, j'ai besoin d'aide !",
	phase3_warning = "Phase 3, gardiens dans ~15 sec. !",

	mc = "Contrôle mental",
	mc_desc = "Prévient qui subit les effets du Contrôle mentale et quand aura lieu le prochain.",
	mc_message = "Contrôle mental : %s",
	mc_warning = "Contrôles mentaux imminents !",
	mc_nextbar = "~Contrôles mentaux",

	fissure = "Fissure d'ombre",
	fissure_desc = "Prévient de l'arrivée des Fissures d'ombre.",
	fissure_warning = "Fissure d'ombre !",

	frostblast = "Trait de givre",
	frostblast_desc = "Prévient quand des joueurs subissent les effets du Trait de givre.",
	frostblast_bar = "Trait de givre probable",
	frostblast_message = "%s : Trait de givre",
	frostblast_soon_message = "Trait de givre probable dans ~5 sec. !",

	detonate = "Faire détoner mana",
	detonate_desc = "Prévient quand un joueur subit les effets de Faire détoner mana.",
	detonate_you = "Faire détoner mana sur VOUS !",
	detonate_other = "Détoner mana - %s",
	detonate_possible_bar = "~Prochain Détoner",
	detonate_warning = "Prochain Faire détoner mana dans 5 sec. !",

	guardians = "Apparition des gardiens",
	guardians_desc = "Prévient de l'arrivée des gardiens en phase 3.",
	guardians_trigger = "Très bien. Guerriers des terres gelées, relevez-vous ! Je vous ordonne de combattre, de tuer et de mourir pour votre maître ! N'épargnez personne !",
	guardians_warning = "Arrivée des gardiens dans ~10 sec. !",
	guardians_bar = "Arrivée des gardiens !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par Faire détoner mana (nécessite d'être promu ou mieux).",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnRegister()
	-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function mod:OnDisable()
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Fizzure", 27810)
	self:AddCombatListener("SPELL_AURA_APPLIED", "FrostBlast", 27808)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Detonate", 27819)
	self:AddCombatListener("SPELL_AURA_APPLIED", "MC", 28410)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self.warnedAboutPhase3Soon = nil
	
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ZONE_CHANGED_INDOORS(msg)
	if GetMinimapZoneText() ~= L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] or BigWigs:IsModuleActive(boss) then return end
	-- Activate the Kel'Thuzad mod!
	BigWigs:EnableModule(boss)
end

function mod:Fizzure()
	if self.db.profile.fissure then
		self:Message(L["fissure_warning"], "Important", 27810)
	end
end

function mod:FrostBlast(player)
	if self.db.profile.frostblast then
		FB[player] = true
		self:ScheduleEvent("BWFrostBlastWarn", self.FBWarn, 0.4, self)
	end
end

function mod:FBWarn()
	local msg = nil
	for k in pairs(FB) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["frostblast_message"]:format(msg), "Important", 27808, "Alert")
	self:DelayedMessage(32, L["frostblast_soon_message"], "Attention")
	self:Bar(L["frostblast_bar"], 37, 27808)
	for k in pairs(FB) do FB[k] = nil end
end

function mod:Detonate(player, spellID)
	if self.db.profile.detonate then
		local other = L["detonate_other"]:format(player)
		if player == pName then
			self:Message(L["detonate_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["detonate_you"])
		end
		self:Icon(player, "icon")
		self:Bar(other, 5, spellID)
		self:Bar(L["detonate_possible_bar"], 20, spellID)
		self:DelayedMessage(15, L["detonate_warning"], "Attention")
	end
end

function mod:MC(player)
	if self.db.profile.mc then
		MCd[player] = true
		self:ScheduleEvent("BWMCWarn", self.MCWarn, 0.5, self)
	end
end

function mod:MCWarn()
	if self.db.profile.mc then
		local msg = nil
		for k in pairs(MCd) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:IfMessage(fmt(L["mc_message"], msg), "Important", 28410, "Alert")
		self:Bar(L["mc"], 21, 28410)
		self:DelayedMessage(68, L["mc_warning"], "Urgent")
		self:Bar(L["mc_nextbar"], 68, 28410)
	end
	for k in pairs(MCd) do MCd[k] = nil end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 and not self.warnedAboutPhase3Soon then
			self:Message(L["phase3_soon_warning"], "Attention")
			self.warnedAboutPhase3Soon = true
		elseif health > 60 and self.warnedAboutPhase3Soon then
			self.warnedAboutPhase3Soon = nil
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.phase and msg == L["start_trigger"] then
		self:Message(L["start_warning"], "Attention")
		self:Bar(L["start_bar"], 215, "Spell_Fire_FelImmolation")
		for k in pairs(MCd) do MCd[k] = nil end
		for k in pairs(FB) do FB[k] = nil end
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg == L["phase2_trigger1"] or msg == L["phase2_trigger2"] or msg == L["phase2_trigger3"] then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_StopBar", self, L["start_bar"])
			self:Message(L["phase2_warning"], "Important")
			self:Bar(L["phase2_bar"], 15, "Spell_Shadow_Charm")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_warning"], "Attention")
	elseif self.db.profile.guardians and msg == L["guardians_trigger"] then
		self:Message(L["guardians_warning"], "Important")
		self:Bar(L["guardians_bar"], 10, 28866)
	end
end

