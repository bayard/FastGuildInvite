local addon=FGI
local fn=addon.functions
local L = addon.L
local CLASS = L.SYSTEM.class
local interface = addon.interface
local settings = L.settings
-- local GUI = LibStub("AceKGUI-3.0")
local GUI = LibStub("AceGUI-3.0")
local color = addon.color
local FastGuildInvite = addon.lib
addon.search = {progress=1, inviteList={}, state='stop', timeShift=0, tempSendedInvites={}, whoQueryList = {}}
addon.removeMsgList = {}
addon.libWho = {}
local DB
--LibStub:GetLibrary("LibWho-2.0"):Embed(addon.libWho);
addon.searchInfo = {unique = {0}, sended = {0}, invited = {0}, filtered = {0}}
local mt = {
	__call = function(self,n)
		self[1] = self[1] + (n==0 and -self[1] or (n or 1))
		interface.mainFrame.searchInfo.update(addon.searchInfo())
		return self[1]
	end
}
setmetatable(addon.searchInfo.unique,mt);setmetatable(addon.searchInfo.sended,mt);setmetatable(addon.searchInfo.invited,mt);setmetatable(addon.searchInfo.filtered,mt);
setmetatable(addon.searchInfo,{__call = function(self)
	return {self.unique[1], self.sended[1], self.invited[1], self.filtered[1]}
end});

local time, next = time, next




local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(_,_,msg)
	local place = strfind(ERR_GUILD_JOIN_S,"%s",1,true)
	if (place) then
		local n = strsub(msg,place)
		local name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_JOIN_S,name) == msg then
			if DB.alredySended[name] then
				addon.searchInfo.invited()
			end
		end
	end
end)

--ERR_GUILD_INVITE_S,ERR_GUILD_DECLINE_S,ERR_ALREADY_IN_GUILD_S,ERR_ALREADY_INVITED_TO_GUILD_S,ERR_GUILD_DECLINE_AUTO_S,ERR_GUILD_JOIN_S,ERR_GUILD_PLAYER_NOT_FOUND_S,ERR_CHAT_PLAYER_NOT_FOUND_S
--	CanGuildInvite()
-- LOCALIZED_CLASS_NAMES_MALE

function fn:initDB()
	DB = addon.DB
end

local function IsInBlacklist(name)
	return DB.blackList[name] and true or false
end

local function guildKick(name)
	StaticPopupDialogs["FGI_BLACKLIST"].add(name)
end

function fn:blacklistKick()
	for i=1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i)
		if IsInBlacklist(name) then guildKick(name) end
	end
end

function fn:blackListAutoKick()
	if not IsInGuild() then return end
	-- autoKick on entering world
	fn:blacklistKick()
	
	--init autoKick on guild entering
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("CHAT_MSG_SYSTEM")
	frame:SetScript("OnEvent", function(_,_,msg)
		local place = strfind(ERR_GUILD_JOIN_S,"%s",1,true)
		if (place) then
			local n = strsub(msg,place)
			local name = strsub(n,1,(strfind(n,"%s") or 2)-1)
			if format(ERR_GUILD_JOIN_S,name) == msg then
				if IsInBlacklist(name) then guildKick(name) end
			end
		end
	end)
end

function fn:blackList(name)
	DB.blackList[name] = true
	print(format("%sPlayer %s has been blacklisted|r", color.red, name))
	fn:blacklistKick()
end

function fn:closeBtn(obj)
	obj.text:SetPoint("TOPLEFT", 2, -1)
	obj.text:SetPoint("BOTTOMRIGHT", -2, 1)
end

function fn.debug(...)
	local msg, colored = ...
	local text = interface.debugFrame.debugList:GetText() or ''
	if msg == nil or type(msg) == "table" then
		interface.debugFrame.debugList:SetText(format("%swrong debug input - msg = %s\n%s",color.red,type(msg),text))
		return
	end
	if colored then msg = format("%s%s|r", colored, msg) end
	if not addon.debug then return end
	-- interface.debugFrame.debugList.txt = interface.debugFrame.debugList.txt..msg.."\n"
	interface.debugFrame.debugList:SetText(format("%s\n%s",msg,text))
end
local debug = fn.debug

function fn:SetKeybind(key, keyType)
	local DBkey = addon.DB.keyBind
	if key then
		if keyType == "invite" then
			DBkey.invite = key
			SetBindingClick(key, interface.scanFrame.invite.frame:GetName())
		elseif keyType == "nextSearch" then
			DBkey.nextSearch = key
			SetBindingClick(key, interface.scanFrame.pausePlay.frame:GetName())
		end
	else
		DBkey[keyType] = false
	end
	
	interface.keyBindings.buttonsGRP.keyBind.invite:SetLabel(format(L.interface["Назначить кнопку (%s)"], DBkey.invite or "none"))
	interface.keyBindings.buttonsGRP.keyBind.invite:SetKey(DBkey.invite)
	interface.keyBindings.buttonsGRP.keyBind.nextSearch:SetLabel(format(L.interface["Назначить кнопку (%s)"], DBkey.nextSearch or "none"))
	interface.keyBindings.buttonsGRP.keyBind.nextSearch:SetKey(DBkey.nextSearch)
end

function fn:FiltersInit()
	local parent = interface.filtersFrame
	local list = parent.filterList
	for i=1, FGI_FILTERSLIMIT do
		local frame = GUI:Create("FilterButton")
		interface.filtersFrame:AddChild(frame)
		
		table.insert(list, frame)
		
		interface.filtersFrame.filterList[i]:Hide()
	end
	--[[for i=1, FGI_FILTERSLIMIT do
		interface.filtersFrame.filterList[i]:Hide()
	end]]
end

function fn:FilterChange(id)
	local filtersFrame = interface.filtersFrame
	local addfilterFrame = interface.addfilterFrame
	local filter = FGI.DB.filtersList[id]
	local class = filter.classFilter
	local raceFilter = filter.raceFilter
	
	filtersFrame:Hide()
	addfilterFrame:Show()
	
	if not class then
		addfilterFrame.classesCheckBoxIgnore:SetValue(true)
	else
		addfilterFrame.classesCheckBoxIgnore:SetValue(false)
		addfilterFrame.classesCheckBoxDruid:SetValue(class[CLASS.Druid] or false)
		addfilterFrame.classesCheckBoxHunter:SetValue(class[CLASS.Hunter] or false)
		addfilterFrame.classesCheckBoxMage:SetValue(class[CLASS.Mage] or false)
		addfilterFrame.classesCheckBoxPaladin:SetValue(class[CLASS.Paladin] or false)
		addfilterFrame.classesCheckBoxPriest:SetValue(class[CLASS.Priest] or false)
		addfilterFrame.classesCheckBoxRogue:SetValue(class[CLASS.Rogue] or false)
		addfilterFrame.classesCheckBoxShaman:SetValue(class[CLASS.Shaman] or false)
		addfilterFrame.classesCheckBoxWarlock:SetValue(class[CLASS.Warlock] or false)
		addfilterFrame.classesCheckBoxWarrior:SetValue(class[CLASS.Warrior] or false)
	end
	
	if not raceFilter then 
		addfilterFrame.rasesCheckBoxIgnore:SetValue(true)
	else
		addfilterFrame.rasesCheckBoxIgnore:SetValue(false)
		for i=1, #addfilterFrame.rasesCheckBoxRace do
			local race = addfilterFrame.rasesCheckBoxRace[i]
			local name = race:GetLabel()
			race:SetValue(raceFilter[name] and true or false)
		end
	end
	
	addfilterFrame.filterNameEdit:SetText(id)
	addfilterFrame.filterNameEdit:SetDisabled(true)
	addfilterFrame.excludeNameEditBox:SetText(filter.filterByName or "")
	addfilterFrame.lvlRangeEditBox:SetText(filter.lvlRange or "")
	addfilterFrame.excludeRepeatEditBox:SetText(filter.letterFilter or "")
	
	fn:classIgnoredToggle()
	fn:racesIgnoredToggle()
	addfilterFrame.change = true
end

function fn:FiltersUpdate()
	for i=1, FGI_FILTERSLIMIT do
		interface.filtersFrame.filterList[i]:Hide()
	end
	local parent = interface.filtersFrame
	local list = parent.filterList
	local i = 1
	for name,v in pairs(FGI.DB.filtersList) do
		local filter = FGI.DB.filtersList[name]
		local frame = list[i]
		frame:SetID(name)
		frame:SetText(name)
		local state = filter.filterOn and L.interface["Включен"]:upper() or L.interface["Выключен"]:upper()
		local lvlRange = filter.lvlRange or L.interface["Откл."]
		local filterByName = filter.filterByName or L.interface["Откл."]
		local letterFilterVowels, letterFilterConsonants = filter.letterFilter==false and 0,0 or fn:split(filter.letterFilter, ":")
		local class = ""
		if not filter.classFilter then
			class = L.interface["Откл."]
		else
			for k,v in pairs(filter.classFilter) do class = class..k.."," end
			class = class:sub(1, -2)
		end
		local race = ""
		if not filter.raceFilter then
			race = L.interface["Откл."]
		else
			for k,v in pairs(filter.raceFilter) do race = race..k.."," end
			race = race:sub(1, -2)
		end
		local count = filter.filteredCount
		
		frame:SetTooltip(format(L.FAQ.help["filterTooltip"], name, state, filterByName, lvlRange, letterFilterVowels, letterFilterConsonants, class, race, count))
		
		i = i + 1
		
	end
end


local RaceClassCombo 
RaceClassCombo = {
	Orc = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Undead = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Tauren = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Priest,CLASS.Shaman,CLASS.Monk,CLASS.Druid,CLASS.DeathKnight},
	Troll = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.Druid,CLASS.DeathKnight},
	Human = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	Dwarf = {CLASS.Warrior,CLASS.Paladin,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Shaman,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
	NightElf = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Monk,CLASS.Druid,CLASS.DemonHunter,CLASS.DeathKnight},
	Gnome = {CLASS.Warrior,CLASS.Hunter,CLASS.Rogue,CLASS.Priest,CLASS.Mage,CLASS.Warlock,CLASS.Monk,CLASS.DeathKnight},
}

local function getEasyWhoList()
	local min = DB.lowLimit
	local max = DB.highLimit
	interval = 1
	local query = {}
	
	for i=min,max,interval do
		local next = i+ interval-1
		next = next<=max and next or max
		table.insert(query, i.."-"..next)
	end
	return query
end

function fn:msgMod(msg)
	if not msg then return end
	if msg:find("NAME") then
		local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player")
		msg = msg:gsub("NAME", format("<%s>",guildName or 'GUILD_NAME'))
	end
	return msg
end

local function hideWhisper(...)
	local name = select(4,...):match("([^-]*)")
	if addon.removeMsgList[name] then
		--addon.removeMsgList[name] = nil
		return true
	else
		return false, select(3,...)
	end
end

function fn:sendWhisper(msg, name)
	if not msg or not name then return end
	msg = fn:msgMod(msg)
	if msg:len()>255 then
		return print(format(L.FAQ.error["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"], msg:len()-255))
	end
	
	if msg ~= nil then
		if DB.sendMSG then
			addon.removeMsgList[name:match("([^-]*)")] = true
		end
		SendChatMessage(msg, 'WHISPER', GetDefaultLanguage("player"), name)
	else
		print(L.FAQ.error["Выберите сообщение"])
	end
end

local function inviteBtnText(text)
	interface.scanFrame.invite:SetText(text)
end

local function rememberPlayer(name)
	DB.alredySended[name] = time({year = date("%Y"), month = date("%m"), day = date("%d")})
	addon.search.tempSendedInvites[name] = nil
	debug(format("Remember: %s",name))
end

function fn:invitePlayer(noInv)
	local list = addon.search.inviteList
	if #list==0 then return end
	if DB.inviteType == 2 and not noInv then
		addon.msgQueue[list[1].name] = true
	elseif DB.inviteType == 3 and not noInv then
		local msg = DB.messageList[DB.curMessage]
		debug(format("Send whisper: %s %s",list[1].name, msg))
		fn:sendWhisper(msg, list[1].name)
	end
	if (DB.inviteType == 1 or DB.inviteType == 2) and not noInv then
		debug(format("Invite: %s",list[1].name))
		GuildInvite(list[1].name)
	end
	if not noInv or DB.rememberAll then
		rememberPlayer(list[1].name)
	end
	if not noInv then
		addon.searchInfo.sended()
	end
	table.remove(list, 1)
	inviteBtnText(format(L.interface["Пригласить: %d"], #list))
	
	interface.chooseInvites.player:SetText(#list > 0 and format("%s%s %d %s %s|r", color[list[1].NoLocaleClass:upper()], list[1].name, list[1].lvl, list[1].class, list[1].race) or "")
end

local function SearchOnUpdate()
	interface.scanFrame.progressBar:SetProgress(GetTime())
end

local Searchframe = CreateFrame('Frame')

local function searchIntervalTimer(onOff, timer)
	if onOff then
		 addon.search.intervalTimer = C_Timer.NewTicker(timer or FGI_SCANINTERVALTIME, function()fn:nextSearch()end)
	else
		if addon.search.intervalTimer then
			addon.search.intervalTimer:Cancel()
		end
	end
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	-- DB = addon.DB
C_Timer.NewTicker(0.1,function()
	local parent = interface.filtersFrame
	local list = parent.filterList
	for i=1, #list do
		local frame = list[i]
		frame:ClearAllPoints()
		if i == 1 then
			frame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", 15, -50)
		else
			if mod(i-1,7) == 0 then
				frame:SetPoint("TOP", list[7*math.floor(i/7)+1-7].frame, "BOTTOM", 0, -10)
			else
				frame:SetPoint("LEFT", list[i-1].frame, "RIGHT", 5, 0)
			end
		end
	end
end,2)
	frame:UnregisterEvent('PLAYER_ENTERING_WORLD')
end)

local function getSearchDeepLvl(query)
	local l2 = (("%%d+-%%d+ %s\"%s+"):format(L.SYSTEM["r-"],addon.ruReg)):gsub("-","%%-")
	local l3 = (("%%d+-%%d+ %s\"%s+%%\" %s"):format(L.SYSTEM["r-"],addon.ruReg,L.SYSTEM["c-"])):gsub("-","%%-")
	if query:find(l3) then
		return 3
	elseif query:find(l2) then
		return 2
	elseif query:find("%d+%-%d+") then
		return 1
	else
		return false
	end
end

local function searchGetParams(query)
	local class = query:match(("%s%%\"(%s+)%%\""):format(L.SYSTEM["c-"],addon.ruReg):gsub("-","%%-"))
	local race = query:match(("%s%%\"(%s+)%%\""):format(L.SYSTEM["r-"],addon.ruReg):gsub("-","%%-"))
	local lvl = {}
	for s in query:gmatch("%d+") do
		table.insert(lvl, s)
	end
	
	return {class = class,race = race, min = lvl[1], max = lvl[2]}
end

local function isQueryFiltered(query)
	if DB.filtersList == {} or not DB.enableFilters then return false end
	local filter = {}
	local q = searchGetParams(query)
	q.min = tonumber(q.min)
	q.max = tonumber(q.max)
	for fName,v in pairs(DB.filtersList) do
		local lvl = {}
		if v.filterOn then
			filter[fName] = {min = false, max = false, --[[race = false,class = false,]]}
			if v.lvlRange then
				for s in v.lvlRange:gmatch("%d+") do
					table.insert(lvl, tonumber(s))
				end
				filter[fName].min, filter[fName].max = lvl[1], lvl[2] or lvl[1]
			end
			if v.raceFilter then filter[fName].race = v.raceFilter[q.race] and q.race or false end
			if v.classFilter then filter[fName].class = v.classFilter[q.class] and q.class or false end
		end
	end
	for fName,f in pairs(filter) do
		local sLevel = getSearchDeepLvl(query)
		local lvlFiltered, raceFiltered, classFiltered = (f.min and (f.min <= q.min and f.max >= q.max)), (f.race and (f.race==q.race)), (f.class and (f.class==q.class))
		local queryFiltered = false
		if sLevel == 1 then
			queryFiltered = lvlFiltered and f.race==nil and f.class==nil
		elseif sLevel == 2 then
			queryFiltered = f.class==nil and ((lvlFiltered and raceFiltered) or (not f.min and raceFiltered)) or (lvlFiltered and f.race==nil and f.class==nil)
		elseif sLevel == 3 then
			queryFiltered = (lvlFiltered and (f.race==nil and f.class==nil) or (raceFiltered and f.class==nil) or (f.race==nil and classFiltered) or (raceFiltered and classFiltered)) or (not f.min and (raceFiltered and f.class==nil) or (f.race==nil and classFiltered))
		else
			debug('wrong search Level', color.red)
		end
		if queryFiltered then debug(string.format('query (%s) filtered by filter (%s)', query, fName), color.blue);return true end
	end
	return false
end

local function searchAddWhoList(query, lvl)
	local progress = addon.search.progress-1
	local tAddN =0
	local function LVLsplit(query)
		local v1 = query:gsub("(%d+)%-(%d+)", function(a,b)
			local dif = b-a
			b = b - math.floor(dif/2)-1
			tAddN = tAddN+1
			return a.."-"..b
		end)
		local v2 = query:gsub("(%d+)%-(%d+)", function(a,b)
			local dif = b-a
			a = a + math.ceil(dif/2)
			tAddN = tAddN+1
			return a.."-"..b
		end)
		table.remove(addon.search.whoQueryList, progress)
		
		
		if isQueryFiltered(v1) then
			tAddN = tAddN-1
		else
			debug(format("Add new lvl query: (%s); Query: %s", v1, query))
			table.insert(addon.search.whoQueryList, progress, v1)
		end
		if isQueryFiltered(v2) then
			tAddN = tAddN-1
		else
			debug(format("Add new lvl query: (%s); Query: %s", v2, query))
			table.insert(addon.search.whoQueryList, progress+1-(2-tAddN), v2)
		end
		
		
		
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		-- interface.scanFrame.progressBar:SetMinMax(min, max+tAddN*FGI_SCANINTERVALTIME)
		addon.search.progress = addon.search.progress - 1
	end
	local function RACEsplit(query)
		local new = 0
		table.remove(addon.search.whoQueryList, progress)
		for _,v in pairs(L.SYSTEM.race) do
			local newQuery = format("%s %s\"%s\"",query,L.SYSTEM["r-"],v)
			if not isQueryFiltered(newQuery) then
				table.insert(addon.search.whoQueryList, progress+new, newQuery)
				new = new + 1
			end
		end
		if new==0 then return table.insert(addon.search.whoQueryList, progress, query) end
		debug(format("Add new race queries: %d; Query: %s", new, query))
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		-- interface.scanFrame.progressBar:SetMinMax(min, max+(new)*FGI_SCANINTERVALTIME)
		addon.search.progress = addon.search.progress - 1
	end
	local function CLASSsplit(query, race)
		local new = 0
		table.remove(addon.search.whoQueryList, progress)
		if race then
			for k,v in pairs(L.SYSTEM.race) do
				if v==race then
					race = k
					break
				end
			end
			
			if not RaceClassCombo[race] then return print("FGI Error race -",race) end
		else
			return table.insert(addon.search.whoQueryList, progress, query)
		end
		for k,v in pairs(RaceClassCombo[race]) do
			local newQuery = format("%s %s\"%s\"",query,L.SYSTEM["c-"],v)
			if not isQueryFiltered(newQuery) then
				table.insert(addon.search.whoQueryList, progress+new, newQuery)
				new = new + 1
			end
		end
		if #RaceClassCombo[race]==0 then return table.insert(addon.search.whoQueryList, progress, query) end
		debug(format("Add new class queries: %d; Query: %s", #RaceClassCombo[race], query))
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		-- interface.scanFrame.progressBar:SetMinMax(min, max+(new)*FGI_SCANINTERVALTIME)
		addon.search.progress = addon.search.progress - 1
	end
	local queryParams = searchGetParams(query, lvl)
	local difference = (queryParams.max - queryParams.min) > 0
	if difference then
		LVLsplit(query)
	elseif lvl == 1 then
		RACEsplit(query)
	elseif lvl == 2 then
		CLASSsplit(query, queryParams.race)
	end
end

local function findClass(className)
	for k,v in pairs(L.SYSTEM.femaleClass) do
		if v==className then return L.SYSTEM.class[k]  end
	end
	return false
end

local function findRace(raceName)
	for k,v in pairs(L.SYSTEM.femaleRace) do
		if v==raceName then return L.SYSTEM.race[k] end
	end
	return false
end

local function filtered(player)
	for k,v in pairs(DB.filtersList) do
		if v.filterOn then
			if v.lvlRange then
				local min, max = fn:split(v.lvlRange, ":", -1)
				if player.Level >= min and player.Level <= max then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"lvl"
				end
			end
			if v.filterByName then
				for k in v.filterByName:gmatch("([^;]+)") do
					if player.Name:find(k) then
						v.filteredCount = v.filteredCount + 1
						fn:FiltersUpdate()
						return true--,"name"
					end
				end
			end
			--[[if v.letterFilter then
				
			end]]
			if v.classFilter then
				if v.classFilter[player.Class] or v.classFilter[findClass(player.Class)] then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"class"
				end
			end
			if v.raceFilter then
				if v.raceFilter[player.Race] or v.raceFilter[findRace(player.Race)] then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"race"
				end
			end
			
		end
	end
	return false
end
local function addNewPlayer(t, p)
	local blackList = false
	for i=1,#DB.blackList do
		if DB.blackList[i] == p.Name then blackList = true;break; end
	end
	local playerInfoStr = format("%s - lvl:%d; race:%s; class:%s; Guild: \"%s\"", p.Name, p.Level, p.Race, p.Class, p.Guild)
	if p.Guild == "" then
		if not blackList then
			if not DB.leave[p.Name] then
				if not t.tempSendedInvites[p.Name] then
					if not DB.alredySended[p.Name] then
						if ((DB.enableFilters and not filtered(p)) or not DB.enableFilters) then
							table.insert(t.inviteList, {name = p.Name, lvl = p.Level, race = p.Race, class = p.Class,  NoLocaleClass = p.NoLocaleClass})
							t.tempSendedInvites[p.Name] = true
							debug(format("Add player %s", playerInfoStr), color.green)
						else
							addon.searchInfo.filtered()
							debug(format("Player (%s) has been fitlered", playerInfoStr), color.yellow)
						end
						addon.searchInfo.unique()
					else
						debug(format("Invitation has already been sent to the player %s", playerInfoStr), color.yellow)
					end
				else
					debug(format("Player (%s) alrady added", playerInfoStr), color.yellow)
				end
			else
				debug(format("Player (%s) previously exited (or was expelled) from the guild.", playerInfoStr), color.red)
			end
		else
			debug(format("Player (%s) was found in the blacklist.", playerInfoStr), color.red)
		end
	else
		debug(format("Player (%s) already have guild.", playerInfoStr), color.yellow)
	end
	local list = t.inviteList
	interface.chooseInvites.player:SetText(#list > 0 and format("%s%s %d %s %s|r", color[list[1].NoLocaleClass:upper()], list[1].name, list[1].lvl, list[1].class, list[1].race) or "")
end

local libWho = {whoQuery='', doHide=false, isFGI=false}
local function GetWho(query)
	libWho.isFGI = true
	libWho.doHide = (not WhoFrame:IsShown()) and (not FriendsFrame:IsShown())
	C_FriendList.SendWho(query)
end

local function searchWhoResultCallback(query, results, complete)
	addon.search.progress = addon.search.progress + 1
	-- print(query, #results)
	debug(format("Query %s", query))
	local searchLvl = getSearchDeepLvl(query)
	if searchLvl == 1 and #results>=FGI_MAXWHORETURN then
		searchAddWhoList(query,1)
		debug(format("Query (%s) return 50 or more results; SearchLevel-%d", query, searchLvl))
	elseif searchLvl == 2 and #results>=FGI_MAXWHORETURN then
		searchAddWhoList(query,2)
		debug(format("Query (%s) return 50 or more results; SearchLevel-%d", query, searchLvl))
	-- 3lvl can't modified
	end
	
	for i=1,#results do
		local player = results[i]
		addNewPlayer(addon.search, player)
	end
	interface.scanFrame.progressBar:SetMinMax(0, #addon.search.whoQueryList)
	interface.scanFrame.progressBar:SetProgress(addon.search.progress-1)
	inviteBtnText(format(L.interface["Пригласить: %d"], #addon.search.inviteList))
end

function fn:nextSearch()
	C_Timer.After(FGI_SCANINTERVALTIME, function() interface.scanFrame.pausePlay:SetDisabled(false) end)
	if #addon.search.whoQueryList == 0 then
		addon.search.whoQueryList = {DB.lowLimit.."-"..DB.highLimit}
		-- interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.search.whoQueryList*FGI_SCANINTERVALTIME)
	end
	if addon.search.progress <= 1 or addon.search.progress > #addon.search.whoQueryList then
		-- interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.search.whoQueryList*FGI_SCANINTERVALTIME)
	end
	
	
	
	
	addon.search.progress = (addon.search.progress <= (#addon.search.whoQueryList or 1)) and addon.search.progress or 1
	local curQuery = addon.search.whoQueryList[addon.search.progress]
	GetWho(curQuery)
end

local function returnWho(result)
	searchWhoResultCallback(whoQuery, result)
end

local whoFrame = CreateFrame('Frame')
whoFrame:RegisterEvent("WHO_LIST_UPDATE")
whoFrame:SetScript("OnEvent", function()
	if not libWho.isFGI then return end
	if libWho.doHide then
		-- FriendsFrame:Hide()
		FriendsFrameCloseButton:Click()
	end
	libWho.isFGI = false
	local result = {}

	local total, num = C_FriendList.GetNumWhoResults()
	for i=1, num do
	--	self.Result[i] = C_FriendList.GetWhoInfo(i)
		local info = C_FriendList.GetWhoInfo(i)
		--backwards compatibility START
		info.Name=info.fullName
		info.Guild=info.fullGuildName
		info.Level=info.level
		info.Race=info.raceStr
		info.Class=info.classStr
		info.Zone=info.area
		info.NoLocaleClass=info.filename
		info.Sex=info.gender
		--backwards compatibility END
		result[i] = info
	end
	
	returnWho(result)
end)
local function test(query)
	whoQuery = query
end
hooksecurefunc(C_FriendList, "SendWho", test);

function dump(t,l)
  local str = '{'
  l = l or 1
  if l>100 then return 'overstack' end
  for k,v in pairs(t) do
    str = str.."\n"..string.rep('   ', l)..'['..(type(k)=='string' and "'"..k.."'" or k).."] = "
    if type(v) == 'table' then
        str = str..dump(v,l+1)
    elseif type(v) == 'function' then
        str = str..'function'
    elseif type(v) == 'string' then
        str = str.."'"..v.."'"
    else
        str = str..tostring(v)
    end
  end
  str = str..'\n'..string.rep('   ', l-1)..'},'
  if l==1 then
    print(str)
  else
    return str
  end
end

math.progress = function(End, cur)
  local percentageDone = cur*100/End
  return percentageDone>100 and 100 or percentageDone
end

math.round = function (val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

table.pack = function(...)
    return { ... }
end

function fn:split(inputstr, sep, isNumber)
	isNumber = isNumber or false
	if sep == nil then sep = "%s" end
	if not inputstr:find(sep) then return inputstr end
	local t={}
	for str in inputstr:gmatch("([^"..sep.."]+)") do
		table.insert(t, (tonumber(str)==nil and not isNumber) and str or (tonumber(str) or isNumber))
	end
	return unpack(t)
end

function fn:inGuildCanInvite()
	if not addon.debug then
		if not IsInGuild() then return false end
		if not CanGuildInvite() then return false end
	end
	
	return true	
end

local function hideSysMsg()
	return true
end

function fn:StartSearch(timer)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", hideWhisper)
	if DB.systemMSG then ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", hideSysMsg) end
	if addon.search.state == "pause" then
		local min,max = interface.scanFrame.progressBar:GetMinMax()
		local shift = addon.search.timeShift>0 and GetTime()-addon.search.timeShift or 0
		interface.scanFrame.progressBar:SetMinMax(min+shift, max+shift)
		addon.search.timeShift = 0
	end
	addon.search.state = "start"
	searchIntervalTimer(true, timer)
	fn:nextSearch()
	Searchframe:SetScript("OnUpdate", SearchOnUpdate)
end

function fn:PauseSearch()
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", hideWhisper)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", hideSysMsg)
	if addon.search.state == 'start' then
		addon.search.timeShift = GetTime()
	end
	addon.search.state = "pause"
	searchIntervalTimer(false)
	Searchframe:SetScript("OnUpdate", nil)
	interface.scanFrame.pausePlay:SetDisabled(true)
	C_Timer.After(FGI_SCANINTERVALTIME, function() interface.scanFrame.pausePlay:SetDisabled(false) end)
end
