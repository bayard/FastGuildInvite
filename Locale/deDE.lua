-- if not(GetLocale() == "deDE") then
  -- return
-- end

local L = {
	["FAQ"] = {
		["help"] = {
			["factorySettings"] = "Werkseinstellungen",
		},
		["error"] = {
		}
	},
	["interface"] = {
		["Да"] = "Ja",
		["tooltip"] = {
		},
		["invType"] = {
		}
	},
	["SYSTEM"] = {
		["c-"] = "c-",
		["r-"] = "r-",
		["class"] = {
			["DeathKnight"] = "Todesritter",
			["DemonHunter"] = "Dämonenjäger",
			["Druid"] = "Druide",
		},
		["race"] = {
			["Horde"] = {
				["BloodElf"] = "Blutelf",
			},
			["Alliance"] = {
				["DarkIronDwarf"] = "Dunkeleisenzwerg",
				["Draenei"] = "Draenei",
				["Dwarf"] = "Zwerg",
				["Gnome"] = "Gnom",
			}
		}
	}
}



FGI.L["deDE"] = L