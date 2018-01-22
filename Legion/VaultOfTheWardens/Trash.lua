
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vault of the Wardens Trash", 1045)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	96587, -- Felsworn Infester
	98954, -- Felsworn Myrmidon
	99956, -- Fel-Infused Fury
	98533, -- Foul Mother
	96657, -- Blade Dancer Illianna
	99649, -- Dreadlord Mendacius
	102566 -- Grimhorn the Enslaver
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.infester = "Felsworn Infester"
	L.myrmidon = "Felsworn Myrmidon"
	L.fury = "Fel-Infused Fury"
	L.mother = "Foul Mother"
	L.illianna = "Blade Dancer Illianna"
	L.mendacius = "Dreadlord Mendacius"
	L.grimhorn = "Grimhorn the Enslaver"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Felsworn Infester ]]--
		{193069, "SAY"}, -- Nightmares

		--[[ Felsworn Myrmidon ]]--
		191735, -- Deafening Screech

		--[[ Fel-Infused Fury ]]--
		{196799, "FLASH"}, -- Unleash Fury

		--[[ Foul Mother ]]--
		210202, -- Foul Stench

		--[[ Blade Dancer Illianna ]]--
		191527, -- Deafening Shout

		--[[ Dreadlord Mendacius ]]--
		{196249, "FLASH"}, -- Meteor

		--[[ Grimhorn the Enslaver ]]--
		{202615, "SAY"}, -- Torment
	}, {
		[193069] = L.infester,
		[191735] = L.myrmidon,
		[196799] = L.fury,
		[210202] = L.mother,
		[191527] = L.illianna,
		[196249] = L.mendacius,
		[202615] = L.grimhorn,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Felsworn Infester ]]--
	self:Log("SPELL_CAST_START", "NightmaresCast", 193069)
	self:Log("SPELL_AURA_APPLIED", "NightmaresApplied", 193069)

	--[[ Felsworn Myrmidon ]]--
	self:Log("SPELL_CAST_START", "DeafeningScreech", 191735)

	--[[ Fel-Infused Fury ]]--
	self:Log("SPELL_CAST_START", "UnleashFury", 196799)

	--[[ Foul Mother ]]--
	self:Log("SPELL_AURA_APPLIED", "FoulStench", 210202) -- Foul Stench
 	self:Log("SPELL_PERIODIC_DAMAGE", "FoulStench", 210202)
 	self:Log("SPELL_PERIODIC_MISSED", "FoulStench", 210202)

	--[[ Blade Dancer Illianna ]]--
	self:Log("SPELL_CAST_START", "DeafeningShout", 191527)

	--[[ Dreadlord Mendacius ]]--
	self:Log("SPELL_CAST_START", "Meteor", 196249)

	--[[ Grimhorn the Enslaver ]]--
	self:Log("SPELL_AURA_APPLIED", "Torment", 202615)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Felsworn Infester ]]--
function mod:NightmaresCast(args)
	self:Message(args.spellId, "Attention", self:Interrupter() and "Info", CL.casting:format(args.spellName))
end

function mod:NightmaresApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", self:Healer() and "Alarm")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

--[[ Felsworn Myrmidon ]]--
function mod:DeafeningScreech(args)
	self:Message(args.spellId, "Important", self:Ranged() and "Alert", CL.casting:format(args.spellName))
end

--[[ Fel-Infused Fury ]]--
function mod:UnleashFury(args)
	self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(args.spellName))
	if self:Interrupter(args.sourceGUID) then
		self:Flash(args.spellId)
	end
end

--[[ Foul Mother ]]--
do
	local prev = 0
	function mod:FoulStench(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Blade Dancer Illianna ]]--
function mod:DeafeningShout(args)
	self:Message(args.spellId, "Important", self:Ranged() and "Alert", CL.casting:format(args.spellName))
end

--[[ Dreadlord Mendacius ]]--
function mod:Meteor(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.incoming:format(args.spellName))
end

--[[ Grimhorn the Enslaver ]]--
function mod:Torment(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end
