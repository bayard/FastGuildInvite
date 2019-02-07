GUILDSHIELD = {L={}}

local function defaultFunc(L,key)
	return key
end

local English = setmetatable({}, {__index=defaultFunc})
	English["%sGuild%sShield%s has been initiated%s"] = nil
	English["%sGuild%sShield%s protected you from an invite (%s%s%s)%s"] = nil
	English["%sGuild%sShield%s protected you from %s%s%s invites last game session, for a total of %s%s%s blocked invites.%s"] = nil
	English["%sGuild%sShield%s is active and protecting you%s"] = nil


local Russian = setmetatable({}, {__index=defaultFunc})
	Russian["%sGuild%sShield%s has been initiated%s"] = "%sGuild%sShield%s был инициирован%s"
	Russian["%sGuild%sShield%s protected you from an invite (%s%s%s)%s"] = "%sGuild%sShield%s защитил вас от приглашения (%s%s%s)%s"
	Russian["%sGuild%sShield%s protected you from %s%s%s invites last game session, for a total of %s%s%s blocked invites.%s"] = "%sGuild%sShield%s защитил вас от %s%s%s приглашений в последней игровой сессии, всего %s%s%s заблокированных приглашений.%s"
	Russian["%sGuild%sShield%s is active and protecting you%s"] = "%sGuild%sShield%s активен и защищает вас%s"


local Locale = {}
Locale["enUS"] = English
Locale["ruRU"] = Russian
	
local l = GetLocale()
if Locale[l] then
	GUILDSHIELD.L = Locale[l]
else
	GUILDSHIELD.L = Locale["enUS"]
end