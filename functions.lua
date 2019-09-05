local addon=FGI
local fn=addon.functions
local L = addon.L
local interface = addon.interface
local settings = L.settings
-- local GUI = LibStub("AceKGUI-3.0")
local GUI = LibStub("AceGUI-3.0")
local color = addon.color
local FastGuildInvite = addon.lib
addon.search = {progress=1, inviteList={}, state='stop', timeShift=0, tempSendedInvites={}, whoQueryList = {}}
addon.smartSearch = {progress=1, intervalTime = 3, whoQueryList = {}, inviteList={}, tempSendedInvites={}}
addon.removeMsgList = {}
addon.libWho = {}
local DB
local nextSearch
LibStub:GetLibrary("LibWho-2.0"):Embed(addon.libWho);
local classicWoW = addon.isClassic

local time, next = time, next



--ERR_GUILD_INVITE_S,ERR_GUILD_DECLINE_S,ERR_ALREADY_IN_GUILD_S,ERR_ALREADY_INVITED_TO_GUILD_S,ERR_GUILD_DECLINE_AUTO_S,ERR_GUILD_JOIN_S,ERR_GUILD_PLAYER_NOT_FOUND_S,ERR_CHAT_PLAYER_NOT_FOUND_S
--	CanGuildInvite()
-- LOCALIZED_CLASS_NAMES_MALE

function fn:closeBtn(obj)
	obj:SetPoint("TOPLEFT", 2, -1)
	obj:SetPoint("BOTTOMRIGHT", -2, 1)
end

function fn:blackList(name)
	DB.blackList[name] = true
	print(format("%sPlayer %s has been blacklisted|r", color.red, name))
end

local function debug(msg, colored)
	if colored then msg = format("%s%s|r", colored, msg) end
	if not addon.debug then return end
	if msg == nil or type(msg) == "table" then
		interface.debugFrame.debugList:SetText(interface.debugFrame.debugList:GetText()..color.red.."wrong debug input - msg = nil or table".."|r\n")
		return
	end
	-- interface.debugFrame.debugList.txt = interface.debugFrame.debugList.txt..msg.."\n"
	interface.debugFrame.debugList:SetText(interface.debugFrame.debugList:GetText()..msg.."\n")
end

function fn:SetKeybind(key)
	if key then
		if GetBindingAction(key) == "" or addon.DB.keyBind == key then
			addon.DB.keyBind = key
			SetBindingClick(key, interface.scanFrame.invite.frame:GetName())
		else
			BasicMessageDialog:SetFrameStrata("TOOLTIP")
			message(L.FAQ.error["Сочетание клавиш уже занято"])
		end
	else
		addon.DB.keyBind = false
	end
	interface.settingsFrame.settingsButtonsGRP.keyBind:SetLabel(format(L.interface["Назначить кнопку (%s)"], addon.DB.keyBind or "none"))
	interface.settingsFrame.settingsButtonsGRP.keyBind:SetKey(addon.DB.keyBind)
end

function fn:FiltersInit()
	local parent = interface.filtersFrame
	local list = parent.filterList
	for i=1, FGI_FILTERSLIMIT do
		local frame = GUI:Create("FilterButton")
		interface.filtersFrame:AddChild(frame)
		
		table.insert(list, frame)
	end
	for i=1, FGI_FILTERSLIMIT do
		interface.filtersFrame.filterList[i]:Hide()
	end
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
		addfilterFrame.classesCheckBoxDruid:SetValue(class[L.SYSTEM.class.Druid] or false)
		addfilterFrame.classesCheckBoxHunter:SetValue(class[L.SYSTEM.class.Hunter] or false)
		addfilterFrame.classesCheckBoxMage:SetValue(class[L.SYSTEM.class.Mage] or false)
		addfilterFrame.classesCheckBoxPaladin:SetValue(class[L.SYSTEM.class.Paladin] or false)
		addfilterFrame.classesCheckBoxPriest:SetValue(class[L.SYSTEM.class.Priest] or false)
		addfilterFrame.classesCheckBoxRogue:SetValue(class[L.SYSTEM.class.Rogue] or false)
		addfilterFrame.classesCheckBoxShaman:SetValue(class[L.SYSTEM.class.Shaman] or false)
		addfilterFrame.classesCheckBoxWarlock:SetValue(class[L.SYSTEM.class.Warlock] or false)
		addfilterFrame.classesCheckBoxWarrior:SetValue(class[L.SYSTEM.class.Warrior] or false)
		if not classicWoW then
		addfilterFrame.classesCheckBoxDeathKnight:SetValue(class[L.SYSTEM.class.DeathKnight] or false)
		addfilterFrame.classesCheckBoxDemonHunter:SetValue(class[L.SYSTEM.class.DemonHunter] or false)
		addfilterFrame.classesCheckBoxMonk:SetValue(class[L.SYSTEM.class.Monk] or false)
		end
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
if not classicWoW then
RaceClassCombo = {
	Orc = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Undead = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Tauren = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,L.SYSTEM.class.DeathKnight},
	Troll = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,L.SYSTEM.class.DeathKnight},
	Human = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Dwarf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	NightElf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,L.SYSTEM.class.DemonHunter,L.SYSTEM.class.DeathKnight},
	Gnome = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	
	
	BloodElf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DemonHunter,L.SYSTEM.class.DeathKnight},
	Goblin = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.DeathKnight},
	Nightborne = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk},
	HightmountainTauren = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Shaman,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid},
	MagharOrc = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk},
	Pandaren = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk},
	Draenei = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Worgen = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Druid,L.SYSTEM.class.DeathKnight},
	VoidElf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk},
	LightforgedDraenei = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage},
	DarkIronDwarf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk},
	KulTiran = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,},
	ZandalariTroll = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,},
	
}
else
RaceClassCombo = {
	Orc = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Undead = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Tauren = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,L.SYSTEM.class.DeathKnight},
	Troll = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,L.SYSTEM.class.DeathKnight},
	Human = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	Dwarf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Paladin,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Shaman,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
	NightElf = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Monk,L.SYSTEM.class.Druid,L.SYSTEM.class.DemonHunter,L.SYSTEM.class.DeathKnight},
	Gnome = {L.SYSTEM.class.Warrior,L.SYSTEM.class.Hunter,L.SYSTEM.class.Rogue,L.SYSTEM.class.Priest,L.SYSTEM.class.Mage,L.SYSTEM.class.Warlock,L.SYSTEM.class.Monk,L.SYSTEM.class.DeathKnight},
}
end

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

local function getWhoList(interval)
	local min = DB.lowLimit
	local max = DB.highLimit
	interval = DB.deepSearch and (interval or DB.searchInterval) or (interval or 1)
	local raceFilter = DB.raceFilterVal
	local classFilter = DB.classFilterVal
	local query = {}
	
	for i=min,max,interval do
		local cur = i
		local next = i+ interval-1
		next = next<=max and next or max
		if DB.deepSearch then
			if next<=max then
				if raceFilter <= max and (raceFilter <= cur or raceFilter == next) and classFilter <= max and (classFilter <= cur or classFilter == next) then
					for k,v in pairs(L.SYSTEM.race) do
						for _,j in pairs(RaceClassCombo[k]) do
							-- table.insert(query, cur.."-"..next..L.interface["r-"]..v..L.interface["c-"]..j)
							table.insert(query, format("%d-%d %s%s %s%s", cur, next, L.SYSTEM["r-"], v, L.SYSTEM["c-"], j))
						end
					end
				elseif raceFilter <= max and (raceFilter <= cur or raceFilter == next) then
					for _,v in pairs(L.SYSTEM.race) do
						-- table.insert(query, cur.."-"..next..L.interface["r-"]..v)
						table.insert(query, format("%d-%d %s%s", cur, next, L.SYSTEM["r-"], v))
					end
				elseif classFilter <= max and (classFilter <= cur or classFilter == next) then
					for _,j in pairs(L.SYSTEM.class) do
						-- table.insert(query, cur.."-"..next..L.interface["c-"]..j)
						table.insert(query, format("%d-%d %s%s", cur, next, L.SYSTEM["c-"], j))
					end
				else
					-- table.insert(query, cur.."-"..next)
					table.insert(query, format("%d-%d", cur, next))
				end
			end
		else
			-- table.insert(query, cur.."-"..next)
			table.insert(query, format("%d-%d", cur, next))
		end
		if next==max then break end
	end
	
	return (#query>FGI_MAXWHOQUERY and interval<=max-min) and getWhoList(interval+1) or query
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
		addon.removeMsgList[name] = nil
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
	debug(format("Remember: %s",name))
end

function fn:invitePlayer(noInv)
	local list = DB.SearchType == 3 and addon.smartSearch.inviteList or addon.search.inviteList
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
		 addon.search.intervalTimer = C_Timer.NewTicker(timer or FGI_SCANINTERVALTIME, function()nextSearch()end)
	else
		if addon.search.intervalTimer then
			addon.search.intervalTimer:Cancel()
		end
	end
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	DB = addon.DB
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

local function smartSearchGetParams(query)
	local class = query:match(("%s%%\"(%s)+%%\""):format(L.SYSTEM["c-"],addon.ruReg):gsub("-","%%-"))
	local race = query:match(("%s%%\"(%s+)%%\""):format(L.SYSTEM["r-"],addon.ruReg):gsub("-","%%-"))
	local lvl = {}
	for s in query:gmatch("%d+") do
		table.insert(lvl, s)
	end
	
	return {class = class,race = race, min = lvl[1], max = lvl[2]}
end

local function smartSearchAddWhoList(query, lvl)
	local progress = addon.smartSearch.progress-1
	local function LVLsplit(query)
		local v1 = query:gsub("(%d+)%-(%d+)", function(a,b)
			local dif = b-a
			b = b - math.floor(dif/2)-1
			return a.."-"..b
		end)
		local v2 = query:gsub("(%d+)%-(%d+)", function(a,b)
			local dif = b-a
			a = a + math.ceil(dif/2)
			return a.."-"..b
		end)
		debug(format("Add new lvl queries: (%s) and (%s); Query: %s", v1, v2, query))
		table.remove(addon.smartSearch.whoQueryList, progress)
		table.insert(addon.smartSearch.whoQueryList, progress, v1)
		table.insert(addon.smartSearch.whoQueryList, progress+1, v2)
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		interface.scanFrame.progressBar:SetMinMax(min, max+2*FGI_SCANINTERVALTIME)
		addon.smartSearch.progress = addon.smartSearch.progress - 1
	end
	local function RACEsplit(query)
		local new = 0
		table.remove(addon.smartSearch.whoQueryList, progress)
		for _,v in pairs(L.SYSTEM.race) do
			table.insert(addon.smartSearch.whoQueryList, progress+new,format("%s %s\"%s\"",query,L.SYSTEM["r-"],v))
			new = new + 1
		end
		if new==0 then return table.insert(addon.smartSearch.whoQueryList, progress, query) end
		debug(format("Add new race queries: %d; Query: %s", new, query))
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		interface.scanFrame.progressBar:SetMinMax(min, max+(new)*FGI_SCANINTERVALTIME)
		addon.smartSearch.progress = addon.smartSearch.progress - 1
	end
	local function CLASSsplit(query, race)
		local new = 0
		table.remove(addon.smartSearch.whoQueryList, progress)
		if race then
			for k,v in pairs(L.SYSTEM.race) do
				if v==race then
					race = k
					break
				end
			end
			
			if not RaceClassCombo[race] then return print("FGI Error race -",race) end
		else
			return table.insert(addon.smartSearch.whoQueryList, progress, query)
		end
		for k,v in pairs(RaceClassCombo[race]) do
			table.insert(addon.smartSearch.whoQueryList, progress+k-1,format("%s %s\"%s\"",query,L.SYSTEM["c-"],v))
		end
		if #RaceClassCombo[race]==0 then return table.insert(addon.smartSearch.whoQueryList, progress, query) end
		debug(format("Add new class queries: %d; Query: %s", #RaceClassCombo[race], query))
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		interface.scanFrame.progressBar:SetMinMax(min, max+(#RaceClassCombo[race])*FGI_SCANINTERVALTIME)
		addon.smartSearch.progress = addon.smartSearch.progress - 1
	end
	local queryParams = smartSearchGetParams(query, lvl)
	local difference = (queryParams.max - queryParams.min) > 0
	if difference then
		LVLsplit(query)
	elseif lvl == 1 then
		RACEsplit(query)
	elseif lvl == 2 then
		CLASSsplit(query, queryParams.race)
	end
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
				if v.classFilter[player.Class] then
					v.filteredCount = v.filteredCount + 1
					fn:FiltersUpdate()
					return true--,"class"
				end
			end
			if v.raceFilter then
				if v.raceFilter[player.Race] then
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
	if not DB.blackList[p.Name] then
		if p.Guild == "" then
			if not t.tempSendedInvites[p.Name] then
				if not DB.alredySended[p.Name] then
					if ((DB.enableFilters and not filtered(p)) or not DB.enableFilters) then
						table.insert(t.inviteList, {name = p.Name, lvl = p.Level, race = p.Race, class = p.Class,  NoLocaleClass = p.NoLocaleClass})
						t.tempSendedInvites[p.Name] = true
						debug(format("Add player %s",p.Name), color.green)
					else
						debug(format("Player %s has been fitlered",p.Name), color.blue)
					end
				else
					debug(format("Invitation has already been sent to the player %s",p.Name), color.blue)
				end
			else
				debug(format("Player %s alrady added",p.Name), color.yellow)
			end
		else
			debug(format("Player %s already have guild.",p.Name), color.blue)
		end
	else
		debug(format("Player %s find in black list.",p.Name), color.red)
	end
	local list = t.inviteList
	interface.chooseInvites.player:SetText(#list > 0 and format("%s%s %d %s %s|r", color[list[1].NoLocaleClass:upper()], list[1].name, list[1].lvl, list[1].class, list[1].race) or "")
end



local function SmartSearchWhoResultCallback(query, results, complete)
	local searchLvl = getSearchDeepLvl(query)
	if searchLvl == 1 and #results>=FGI_MAXWHORETURN then
		smartSearchAddWhoList(query,1)
		debug(format("Query (%s) return 50 or more results; SearchLevel-%d", query, searchLvl))
	elseif searchLvl == 2 and #results>=FGI_MAXWHORETURN then
		smartSearchAddWhoList(query,2)
		debug(format("Query (%s) return 50 or more results; SearchLevel-%d", query, searchLvl))
	-- 3lvl can't modified
	end
	
	for i=1,#results do
		local player = results[i]
		addNewPlayer(addon.smartSearch, player)
	end
	
	inviteBtnText(format(L.interface["Пригласить: %d"], #addon.smartSearch.inviteList))
end

local function WhoResultCallback(query, results, complete)
	if #results == FGI_MAXWHORETURN and DB.SearchType ~= 1 then
		print(format(L.FAQ.error["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"], query))
	end
	for i=1,#results do
		local player = results[i]
		addNewPlayer(addon.search, player)
	end
	
	inviteBtnText(format(L.interface["Пригласить: %d"], #addon.search.inviteList))
end

nextSearch = function()
	if (#addon.search.whoQueryList == 0 or addon.search.progress > #addon.search.whoQueryList) and DB.SearchType ~= 3 then
		addon.search.progress = 1
		if DB.SearchType == 1 and #addon.search.whoQueryList == 0 then
			addon.search.whoQueryList = getEasyWhoList()
		elseif DB.SearchType == 2 and #addon.search.whoQueryList == 0 then
			addon.search.whoQueryList = getWhoList(DB.searchInterval)
		end
		interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.search.whoQueryList*FGI_SCANINTERVALTIME)
	elseif DB.SearchType == 3 then
		if #addon.smartSearch.whoQueryList == 0 then
			addon.smartSearch.whoQueryList = {DB.lowLimit.."-"..DB.highLimit}
			interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.smartSearch.whoQueryList*FGI_SCANINTERVALTIME)
		end
		if addon.smartSearch.progress <= 1 or addon.smartSearch.progress > #addon.smartSearch.whoQueryList then
			interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.smartSearch.whoQueryList*FGI_SCANINTERVALTIME)
		end
	end
	
	local curQuery
	
	if DB.SearchType ~= 3 then
		addon.search.progress = (addon.search.progress <= (#addon.search.whoQueryList or 1)) and addon.search.progress or 1
		curQuery = addon.search.whoQueryList[addon.search.progress]
		addon.libWho:Who(tostring(curQuery),{queue = addon.libWho.WHOLIB_QUEUE_QUIET, callback = WhoResultCallback})
		addon.search.progress = addon.search.progress + 1
	else
		addon.smartSearch.progress = (addon.smartSearch.progress <= (#addon.smartSearch.whoQueryList or 1)) and addon.smartSearch.progress or 1
		curQuery = addon.smartSearch.whoQueryList[addon.smartSearch.progress]
		addon.libWho:Who(tostring(curQuery),{queue = addon.libWho.WHOLIB_QUEUE_QUIET, callback = SmartSearchWhoResultCallback})
		addon.smartSearch.progress = addon.smartSearch.progress + 1
	end
end

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
	nextSearch()
	interface.mainFrame.mainCheckBoxGRP.normalSearch:SetDisabled(true)
	interface.mainFrame.mainCheckBoxGRP.deepSearch:SetDisabled(true)
	interface.mainFrame.mainCheckBoxGRP.smartSearch:SetDisabled(true)
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