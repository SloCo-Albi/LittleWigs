
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wise Mari", 867, 672)
mod:RegisterEnableMob(56448)

local deaths = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_say = "You dare to disturb these waters? You will drown!"

	L.water_killed = "Water killed! (%d/4)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {"ej:6327", "stages", "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CallWater", 106526)
	self:Log("SPELL_CAST_START", "BubbleBurst", 106612)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 56448, 56511)
end

function mod:OnEngage()
	self:Message("stages", CL["phase"]:format(1), "Positive", nil, "Info")
	self:Bar("ej:6327", 106526, 9.2, 106526) -- Call Water
	deaths = 0
end
--[[9.3
33.7
37.4
42.2]]
--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CallWater(_, spellId, _, _, spellName)
	self:Message("ej:6327", spellName, "Important", spellId, "Alert")
	self:Bar("ej:6327", spellName, 2, spellId)
end

function mod:BubbleBurst()
	self:Message("stages", CL["phase"]:format(2), "Positive", nil, "Info")
end

function mod:Deaths(mobId)
	if mobId == 56448 then
		self:Win()
	else
		deaths = deaths + 1
		self:Message("ej:6327", L["water_killed"]:format(deaths), "Attention", 106526)
	end
end

