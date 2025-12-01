It appears there is the same number of mythic dungeons as heroic, they share the similar layout, Blackrock Caverns is cata backport and is not in m+ list, yet?

- /script print(GetCurrentMapAreaID()) - 1
- /script WorldMapButtonFilters:Hide() smile

Font colors:
v1
- inner - 633e10
- glow - d9bc4c
v2
- inner - 5a4518
- glow - d6c273
v3 (full)
- inner - 633e10
- glow - d6bf69

Import maps:
- [x] /script SetMapByID(688) - Blackfathom Deeps
- [x] /script SetMapByID(753) - Blackrock Caverns
- [x] /script SetMapByID(704) - Blackrock Depths - Manufactory
- [x] /script SetMapByID(704) - Blackrock Depths - Prison
- [x] /script SetMapByID(704) - Blackrock Depths - Upper City
- [x] /script SetMapByID(756) - Deadmines
- [x] /script SetMapByID(699) - Dire Maul - East
- [x] /script SetMapByID(699) - Dire Maul - North
- [x] /script SetMapByID(699) - Dire Maul - West
- [x] /script SetMapByID(691) - Gnomeregan
- [x] /script SetMapByID(721) - Lower Blackrock Spire
- [ ] /script SetMapByID(763) - Lower Scholomance
- [x] /script SetMapByID(750) - Maraudon - Orange Crystals
- [x] /script SetMapByID(750) - Maraudon - Pristine Waters
- [x] /script SetMapByID(750) - Maraudon - Purple Crystals
- [x] /script SetMapByID(680) - Ragefire Chasm
- [x] /script SetMapByID(760) - Razorfen Downs
- [x] /script SetMapByID(761) - Razorfen Kraul
- [x] /script SetMapByID(2033) - Road to De Other Side
- [x] /script SetMapByID(762) - Scarlet Monastery - Armory
- [x] /script SetMapByID(762) - Scarlet Monastery - Cathedral
- [x] /script SetMapByID(762) - Scarlet Monastery - Graveyard
- [x] /script SetMapByID(762) - Scarlet Monastery - Library
- [x] /script SetMapByID(764) - Shadowfang Keep
- [x] /script SetMapByID(690) - Stormwind Stockade
- [x] /script SetMapByID(765) - Stratholme - Main Gate
- [x] /script SetMapByID(765) - Stratholme - Service Entrance
- [x] /script SetMapByID(2021) - Sunken Temple
- [x] /script SetMapByID(692) - Uldaman
- [x] /script SetMapByID(721) - Upper Blackrock Spire
- [ ] /script SetMapByID(763) - Upper Scholomance
- [x] /script SetMapByID(2032) - Vaults of Inquisition
- [x] /script SetMapByID(749) - Wailing Caverns
- [x] /script SetMapByID(686) - Zul'Farrak

Populate maps:
- [ ] Blackfathom Deeps
- [ ] Blackrock Caverns
- [ ] Blackrock Depths - Manufactory
- [ ] Blackrock Depths - Prison
- [ ] Blackrock Depths - Upper City
- [ ] Deadmines
- [ ] Dire Maul - East
- [ ] Dire Maul - North
- [ ] Dire Maul - West
- [ ] Gnomeregan
- [ ] Lower Blackrock Spire
- [ ] Lower Scholomance
- [ ] Maraudon - Orange Crystals
- [ ] Maraudon - Pristine Waters
- [ ] Maraudon - Purple Crystals
- [ ] Ragefire Chasm
- [ ] Razorfen Downs
- [ ] Razorfen Kraul
- [ ] Scarlet Monastery - Armory
- [ ] Scarlet Monastery - Cathedral
- [ ] Scarlet Monastery - Graveyard
- [ ] Scarlet Monastery - Library
- [ ] Shadowfang Keep
- [ ] Stormwind Stockade
- [x] Stratholme - Main Gate
- [x] Stratholme - Service Entrance
- [ ] Sunken Temple
- [ ] Uldaman
- [ ] Upper Scholomance
- [ ] Wailing Caverns
- [ ] Zul'Farrak

- C_MythicPlus.GetMapEncounters()
- C_MythicPlus.GetActiveKeystoneTrash()
- C_MythicPlus.GetActiveKeystoneChampions()
- C_MythicPlus.GetKeystoneInfo()
- C_MythicPlus.GetActiveKeystoneInfo()


I'm unable to verify if there are any trivial mobs or minus?

db.ascension classifications:
- Normal
- Elite
- Rare
- Rare Elite
- Boss

Maybe summoned creatures like "Tamed Parrot"?

    classification
        string - the unit's classification: "worldboss", "rareelite", "elite", "rare", "normal", "trivial", or "minus"

Note that "trivial" is for low-level targets that would not reward experience or honor (UnitIsTrivial() would return '1'), whereas "minus" is for mobs that show a miniature version of the v-key health plates.
Mists of Pandaria Patch 5.0.4 (2012-08-28): "minus" classification added; used for minion mobs that typically have less health than normal mobs of their level, but engage the player in larger numbers.

So we are not showing "minus", but what is its count? 0.5?

I should be able to just go into +2 key and run C_MythicPlus.GetActiveKeystoneTrash() to get trashRequired and reverse calculate the count the mobs give by looking at individual kill %

pretty sure this always returns 120? well it at least suggests that normal mobs are worth 1 and elite/champions/boss are 2 count

function MythicPlusObjectiveTrackerMixin:OnTooltipSetUnit(tooltip)
	if not C_MythicPlus.IsKeystoneActive() then return end
	if not self:IsShown() then return end
	
	local _, unit = tooltip:GetUnit()
	if not unit then return end

	if UnitReaction(unit, "player") > 4 then return end
	
	local classification = UnitClassification(unit)

	if classification == "trivial" or classification == "minus" then return end
	local unitCount = math.max(classification == "normal" and 1 or 2, (math.max(60, (UnitLevel(unit) % 10)) * 2))
	local trash = C_MythicPlus.GetActiveKeystoneTrash()
	local percent =  unitCount / trash.trashRequired
	tooltip:AddLine(format("Enemy Forces: %.2f%% (count: %d)", percent * 100, unitCount), 1, 0.82, 0)
end

local KeystoneDungeons = {
	[Enum.Expansion.Vanilla] = {
		2694, -- Ragefire Chasm
		2696, -- Deadmines
		2691, -- Wailing Caverns
		2008, -- Shadowfang Keep
		2700, -- Blackfathom Deeps
		2702, -- Stormwind Stockades
		2708, -- Scarlet Monastery: Graveyard
		2706, -- Razorfen Kraul
		2710, -- Razorfen Downs
		2855, -- Scarlet Monastery: Library
		2704, -- Gnomeregan
		2853, -- Sarelet Monastery: Armory
		2712, -- Uldaman
		2854, -- Scarlet Monastery: Cathedral
		2716, -- Maraudon Orange Cyrstal
		2962, -- Maraudon Purple Cyrstal
		2714, -- Zul'Farrak
		2963, -- Maraudon Pristine Waters
		2718, -- Sunken Temple
		53, -- Lower Scholomance
		56, -- Upper Scholomance
		2030, -- Blackrock Depths: Prison
		2032, -- Lower Blackrock Spire
		2040, -- Stratholme - Main Gate
		2034, -- Dire Maul - East
		2044, -- Upper Blackrock Spire
		2036, -- Dire Maul - West
		2276, -- Blackrock Depths - Upper City
		2274, -- Stratholme - Service Entrance
		2038, -- Dire Maul - North
	},
	[Enum.Expansion.TBC]     = {
		--263, -- The Black Morass
		270, -- The Shattered Halls
		262, -- Shadow Labrynth
		309, -- The Mechanar
		266, -- Steamvault
		269, -- Hellfire Ramparts
		259, -- Auchenai Crypts 
		267, -- The Underbog
		308, -- The Botanica
		261, -- Sethekk Halls
		268, -- Blood Furnace
		265, -- The Slave Pens
		271, -- The Arcatraz
		260, -- Mana Tombs
		--264, -- The Escape from Durnholde
	},
	[Enum.Expansion.WoTLK] = {
		3289, -- Utgarde Pinnacle
		3290, -- The Culling of Stratholme
		3291, -- The Oculus
		3292, -- Halls of Lightning
		3293, -- Halls of Stone
		3294, -- Drak'Tharon Keep
		3295, -- Gundrak
		3296, -- Ahn'kahet: The Old Kingdom
		3297, -- Violet Hold
		3298, -- The Nexus
		3299, -- Azjol-Nerub
		3300, -- Utgarde Keep
		3301, -- Pit of Saron
		3302, -- Halls of Reflection
	}
}