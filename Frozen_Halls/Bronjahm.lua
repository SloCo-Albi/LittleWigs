-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Bronjahm, the Godfather of Souls", "The Forge of Souls")
if not mod then return end
mod.partyContent = true
mod.otherMenu = "The Frozen Halls"
mod:RegisterEnableMob(36497)
mod.toggleOptions = {
	68872, -- Soulstorm
	68839, -- Corrupt Soul
	"bosskill",
}

-------------------------------------------------------------------------------
--  Locals

local stormannounced = nil

-------------------------------------------------------------------------------
--  Localization

local L = LibStub("AceLocale-3.0"):NewLocale("Little Wigs: Bronjahm, the Godfather of Souls", "enUS", true)
if L then
	--@do-not-package@
	L["storm_soon"] = "Soulstorm Soon!"
	--@end-do-not-package@
	--@localization(locale="enUS", namespace="Frozen_Halls/Bronjahm", format="lua_additive_table", handle-unlocalized="ignore")@
end
L = LibStub("AceLocale-3.0"):GetLocale("Little Wigs: Bronjahm, the Godfather of Souls")
mod.locale = L

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	if bit.band(self.db.profile[(GetSpellInfo(68872))], BigWigs.C.MESSAGE) == BigWigs.C.MESSAGE then
		self:RegisterEvent("UNIT_HEALTH")
	end
	self:Log("SPELL_AURA_APPLIED", "Corrupt", 68839)
	self:Log("SPELL_AURA_REMOVED", "CorruptRemoved", 68839)
	self:Death("Win", 36497)
end

function mod:OnEngage()
	stormannounced = nil
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:UNIT_HEALTH(event, msg)
	if UnitName(msg) ~= mod.displayName then return end
	local health = UnitHealth(msg)
	if health > 30 and health <= 35 and not stormannounced then
		self:Message(68872, L["storm_soon"], "Important")
		stormannounced = true
	elseif health > 40 and stormannounced then
		stormannounced = nil
	end
end

function mod:Corrupt(player, spellId, _, _, spellName)
	self:TargetMessage(68839, spellName, player, "Personal", spellId, "Alert")
	self:Bar(68839, player..": "..spellName, 4, spellId)
	self:PrimaryIcon(68839, player)
end

function mod:CorruptRemoved()
	self:PrimaryIcon(68839, false)
end
