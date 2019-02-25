local addon = FGI

addon.lib = LibStub("AceAddon-3.0"):NewAddon("FastGuildInvite")
LibStub("AceEvent-3.0"):Embed(addon.lib)


addon.DB = {}
addon.debug = false
-- addon.debug = true
addon.ruReg = "[%aабвгдеёжзийклмнопрстуфхцчшщъьыэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯ%s]"
addon.functions = {}
addon.interface = {}
addon.version = tonumber(GetAddOnMetadata('FastGuildInvite', 'Version'))
addon.whoQueryList = {}
addon.color = {
	WARRIOR='|cffc79c6e',
	PALADIN='|cfff58cba',
	HUNTER='|cffabd473',
	ROGUE='|cfffff569',
	PRIEST='|cffffffff',
	DEATHKNIGHT='|cffc41f3b',
	SHAMAN='|cff0070de',
	MAGE='|cff3fc7eb',
	WARLOCK='|cff8788ee',
	MONK='|cff00ff96',
	DRUID='|cffff7d0a',
	DEMONHUNTER='|cffa330c9',
	green='|cff00ff00',
	red='|cffff0000',
	yellow='|cffffff00',
	orange='|cffFFA500',
	blue='|cff00BFFF',
}
