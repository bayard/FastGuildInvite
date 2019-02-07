-- Format: ["SYSTEM"] = { pattern1, pattern2, pattern3, ...}
local L = CHATINTERCEPT.L

local messagesToHide = {
	ERR_GUILD_INVITE_S,
	ERR_GUILD_DECLINE_S,
	ERR_ALREADY_IN_GUILD_S,
	ERR_ALREADY_INVITED_TO_GUILD_S,
	ERR_GUILD_DECLINE_AUTO_S,
	ERR_GUILD_PLAYER_NOT_FOUND_S,
	ERR_CHAT_PLAYER_NOT_FOUND_S,
}

local RealmCleanup = {
	ERR_CHAT_PLAYER_NOT_FOUND_S,
}

local chatFilters = {}
local OnInt = {}
local WhisperFilterActive = false;

local function check(msg)
	local place
	local n
	local name
	for k,_ in pairs(messagesToHide) do
		place = strfind(messagesToHide[k],"%s",1,true)
		if place then
			name = strfind(msg," ",place,true)
			if name then
				n = strsub(msg,place,name-1)
				if format(messagesToHide[k],n) == msg then
					return true
				else
					n = strsub(msg,place,name-2)
					if format(messagesToHide[k],n) == msg then
						return true
					end
				end
			end
		end
	end
end

local function check2(msg)
	local place
	local n
	local name
	for k,_ in pairs(RealmCleanup) do
		place = strfind(RealmCleanup[k],"%s",1,true)
		if place then
			name = strfind(msg," ",place,true)
			if name then
				n = strsub(msg,place,name-1)
				if format(RealmCleanup[k],n) == msg then
					return true
				else
					n = strsub(msg,place,name-2)
					if format(RealmCleanup[k],n) == msg then
						return true
					end
				end
			end
		end
	end
end

local function HideOutWhispers(self, event, msg, sender)
	if (sender == UnitName("player")) then
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
		return true;
	end
end

local function HideSystemMessage(self, event, msg)
	if (check(msg)) then
		return true;
	end
end

local function HideRealmConflictMessage(self, event, msg)
	if (check2(msg)) then
		return true;
	end
end

ChatIntercept = {}
function ChatIntercept:StateSystem(on)
	if (on) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", HideSystemMessage);
		print(format(L["%sChatIntercept [%sSystem Messages%s] is now %sACTIVE%s"], "|cffffff00", "|r|cff16ABB5", "|r|cffffff00", "|r|cff00ff00", "|r"))
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", HideSystemMessage);
		print(format(L["%sChatIntercept [%sSystem Messages%s] is now %sINACTIVE%s"], "|cffffff00", "|r|cff16ABB5", "|r|cffffff00", "|r|cff00ff00", "|r"))
	end
end

function ChatIntercept:StateRealm(state)
	if (state) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", HideRealmConflictMessage);
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM",HideRealmConflictMessage);
	end
end

function ChatIntercept:StateWhisper(on)
	WhisperFilterActive = on;
	if (on) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
		print(format(L["%sChatIntercept [%sWhispers%s] is now %sACTIVE%s"], "|cffffff00", "|r|cff16ABB5", "|r|cffffff00", "|r|cff00ff00", "|r"))
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
		print(format(L["%sChatIntercept [%sWhispers%s] is now %sINACTIVE%s"], "|cffffff00", "|r|cff16ABB5", "|r|cffffff00", "|r|cff00ff00", "|r"))
	end
end

function ChatIntercept:InterceptNextWhisper()
	if (WhisperFilterActive) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
	end
end