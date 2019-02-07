CHATINTERCEPT = {L={}}

local function defaultFunc(L,key)
	return key
end

local English = setmetatable({}, {__index=defaultFunc})
	English["%sChatIntercept [%sSystem Messages%s] is now %sACTIVE%s"] = nil
	English["%sChatIntercept [%sSystem Messages%s] is now %sINACTIVE%s"] = nil
	English["%sChatIntercept [%sWhispers%s] is now %sACTIVE%s"] = nil
	English["%sChatIntercept [%sWhispers%s] is now %sINACTIVE%s"] = nil


local Russian = setmetatable({}, {__index=defaultFunc})
	Russian["%sChatIntercept [%sSystem Messages%s] is now %sACTIVE%s"] = "%sChatIntercept [%sСистемные сообщения%s] is now %sВКЛЮЧЕНО%s"
	Russian["%sChatIntercept [%sSystem Messages%s] is now %sINACTIVE%s"] = "%sChatIntercept [%sСистемные сообщения%s] is now %sВЫКЛЮЧЕНО%s"
	Russian["%sChatIntercept [%sWhispers%s] is now %sACTIVE%s"] = "%sChatIntercept [%sЛичные сообщения%s] is now %sВКЛЮЧЕНО%s"
	Russian["%sChatIntercept [%sWhispers%s] is now %sINACTIVE%s"] = "%sChatIntercept [%sЛичные сообщения%s] is now %sВЫКЛЮЧЕНО%s"

	
	
local Locale = {}
Locale["enUS"] = English
Locale["ruRU"] = Russian
	
local l = GetLocale()
if Locale[l] then
	CHATINTERCEPT.L = Locale[l]
else
	CHATINTERCEPT.L = Locale["enUS"]
end