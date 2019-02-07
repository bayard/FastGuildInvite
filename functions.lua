local addon=FGI
local fn=addon.functions
local L = addon.L
local interface = addon.interface
local settings = L.settings
local color = addon.color
local FastGuildInvite = addon.lib
addon.search = {progress=1, inviteList={}, state='stop', timeShift=0, tempSendedInvites={}, whoQueryList = {}}
addon.smartSearch = {progress=1, intervalTime = 3, whoQueryList = {}, inviteList={}, tempSendedInvites={}}
addon.libWho = {}
local DB
local nextSearch
LibStub:GetLibrary("LibWho-2.0"):Embed(addon.libWho);

local time = time



--ERR_GUILD_INVITE_S,ERR_GUILD_DECLINE_S,ERR_ALREADY_IN_GUILD_S,ERR_ALREADY_INVITED_TO_GUILD_S,ERR_GUILD_DECLINE_AUTO_S,ERR_GUILD_JOIN_S,ERR_GUILD_PLAYER_NOT_FOUND_S,ERR_CHAT_PLAYER_NOT_FOUND_S
--	CanGuildInvite()





local RaceClassCombo = {
	Orc = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Shaman,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.DeathKnight},
	Undead = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.DeathKnight},
	Tauren = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Priest,L.class.Shaman,L.class.Monk,L.class.Druid,L.class.DeathKnight},
	Troll = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.Druid,L.class.DeathKnight},
	BloodElf = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.DemonHunter,L.class.DeathKnight},
	Goblin = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Warlock,L.class.DeathKnight},
	Nightborne = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Monk},
	HightmountainTauren = {L.class.Warrior,L.class.Hunter,L.class.Shaman,L.class.Monk,L.class.Druid},
	MagharOrc = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Monk},
	Pandaren = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Monk},
	Human = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.DeathKnight},
	Dwarf = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.DeathKnight},
	NightElf = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Monk,L.class.Druid,L.class.DemonHunter,L.class.DeathKnight},
	Gnome = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Monk,L.class.DeathKnight},
	Draenei = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Monk,L.class.DeathKnight},
	Worgen = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Druid,L.class.DeathKnight},
	VoidElf = {L.class.Warrior,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Mage,L.class.Warlock,L.class.Monk},
	LightforgedDraenei = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Priest,L.class.Mage},
	DarkIronDwarf = {L.class.Warrior,L.class.Paladin,L.class.Hunter,L.class.Rogue,L.class.Priest,L.class.Shaman,L.class.Mage,L.class.Warlock,L.class.Monk},
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
	dump(query)
	return query
end

local function getWhoList(interval)
	local min = DB.lowLimit
	local max = DB.highLimit
	interval = DB.deepSearch and (interval or DB.searchInterval) or 1
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
					for k,v in pairs(L.race) do
						for _,j in pairs(RaceClassCombo[k]) do
							table.insert(query, cur.."-"..next..L[" r-"]..v..L[" c-"]..j)
						end
					end
				elseif raceFilter <= max and (raceFilter <= cur or raceFilter == next) then
					for _,v in pairs(L.race) do
						table.insert(query, cur.."-"..next..L[" r-"]..v)
					end
				elseif classFilter <= max and (classFilter <= cur or classFilter == next) then
					for _,j in pairs(L.class) do
						table.insert(query, cur.."-"..next..L[" c-"]..j)
					end
				else
					table.insert(query, cur.."-"..next)
				end
			end
		else
			table.insert(query, cur.."-"..next)
		end
		if next==max then break end
	end
	
	return (#query>FGI_MAXWHOQUERY and interval<=max-min) and getWhoList(interval+1) or query
end

function fn:invitePlayer()
	if DB.SearchType == 3 then
		local list = addon.smartSearch.inviteList
		if #list==0 then return end
		GuildInvite(list[1].name)
		DB.alredySended[list[1].name] = time({year = date("%Y"), month = date("%m"), day = date("%d")})
		table.remove(addon.smartSearch.inviteList, 1)
		interface.scanFrame.invite:SetText(format(L["Пригласить: %u"], #addon.smartSearch.inviteList))
	else
		local list = addon.search.inviteList
		if #list==0 then return end
		GuildInvite(list[1].name)
		DB.alredySended[list[1].name] = time({year = date("%Y"), month = date("%m"), day = date("%d")})
		table.remove(addon.search.inviteList, 1)
		interface.scanFrame.invite:SetText(format(L["Пригласить: %u"], #addon.search.inviteList))
	end
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
end)

local function getSearchDeepLvl(query)
	if query:find(("%%d+%%-%%d+%s%%\"%s+%%\"%s"):format(L[" r-"],addon.ruReg,L[" c-"]):gsub("-","%%-")) then
		return 3
	elseif query:find(("%%d+%%-%%d+%s%%\"%s+"):format(L[" r-"],addon.ruReg):gsub("-","%%-")) then
		return 2
	elseif query:find("%d+%-%d+") then
		return 1
	else
		return false
	end
end

local function smartSearchGetParams(query)
	local class = query:match(("%s%%\"(%s)+%%\""):format(L[" c-"],addon.ruReg):gsub("-","%%-"))
	local race = query:match(("%s%%\"(%s+)%%\""):format(L[" r-"],addon.ruReg):gsub("-","%%-"))
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
		for _,v in pairs(L.race) do
			table.insert(addon.smartSearch.whoQueryList, progress+new,format("%s%s\"%s\"",query,L[" r-"],v))
			new = new + 1
		end
		if new==0 then return table.insert(addon.smartSearch.whoQueryList, progress, query) end
		local min, max = interface.scanFrame.progressBar:GetMinMax()
		interface.scanFrame.progressBar:SetMinMax(min, max+(new)*FGI_SCANINTERVALTIME)
		addon.smartSearch.progress = addon.smartSearch.progress - 1
	end
	local function CLASSsplit(query, race)
		local new = 0
		table.remove(addon.smartSearch.whoQueryList, progress)
		for k,v in pairs(L.race) do
			if v==race then
				race = k
				break
			end
		end
		if not RaceClassCombo[race] then return print("Error race -",race) end
		for k,v in pairs(RaceClassCombo[race]) do
			table.insert(addon.smartSearch.whoQueryList, progress+k-1,format("%s%s\"%s\"",query,L[" c-"],v))
		end
		if #RaceClassCombo[race]==0 then return table.insert(addon.smartSearch.whoQueryList, progress, query) end
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
	--dump(addon.smartSearch.whoQueryList)
end

local function addNewPlayer(t, p)
	if p.Guild == "" and not t.tempSendedInvites[p.Name] and not DB.alredySended[p.Name] then
		table.insert(t.inviteList, {name = p.Name, lvl = p.Level, race = p.Race, class = p.Class})
		t.tempSendedInvites[p.Name] = true
	end
end

local function SmartSearchWhoResultCallback(query, results, complete)
	local searchLvl = getSearchDeepLvl(query)
	if searchLvl == 1 and #results>=FGI_MAXWHORETURN then
		smartSearchAddWhoList(query,1)
	elseif searchLvl == 2 and #results>=FGI_MAXWHORETURN then
		smartSearchAddWhoList(query,2)
	-- 3lvl can't modified
	end
	
	for i=1,#results do
		local player = results[i]
		addNewPlayer(addon.smartSearch, player)
	end
	
	interface.scanFrame.invite:SetText(format(L["Пригласить: %u"],#addon.smartSearch.inviteList))
end

local function WhoResultCallback(query, results, complete)
	if #results == FGI_MAXWHORETURN and DB.SearchType ~= 1 then print(format(L["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"],query)) end
	--print(query,#results,complete)
	for i=1,#results do
		local player = results[i]
		addNewPlayer(addon.search, player)
	end
	
	interface.scanFrame.invite:SetText(format(L["Пригласить: %u"],#addon.search.inviteList))
end

nextSearch = function()
	if (#addon.search.whoQueryList == 0 or addon.search.progress > #addon.search.whoQueryList) and DB.SearchType ~= 3 then
		addon.search.progress = 1
		if DB.SearchType == 1 and #addon.search.whoQueryList == 0 then
			addon.search.whoQueryList = getEasyWhoList()
		elseif DB.SearchType == 2 and #addon.search.whoQueryList == 0 then
			addon.search.whoQueryList = getWhoList()
		end
		interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.search.whoQueryList*FGI_SCANINTERVALTIME)
	elseif DB.SearchType == 3 then
		if #addon.smartSearch.whoQueryList == 0 then
			addon.smartSearch.whoQueryList = {DB.lowLimit.."-"..DB.highLimit}
		end
		if addon.smartSearch.progress <= 2 then
			interface.scanFrame.progressBar:SetMinMax(GetTime(), GetTime()+#addon.smartSearch.whoQueryList*FGI_SCANINTERVALTIME)
		end
	end
	
	local curQuery
	
	if DB.SearchType ~= 3 then
		addon.search.progress = (addon.search.progress <= (#addon.search.whoQueryList or 1)) and addon.search.progress or 1
		curQuery = addon.search.whoQueryList[addon.search.progress]
		addon.libWho:Who(tostring(curQuery),{queue = addon.libWho.WHOLIB_QUERY_QUIET, callback = WhoResultCallback})
		addon.search.progress = addon.search.progress + 1
	else
		addon.smartSearch.progress = (addon.smartSearch.progress <= (#addon.smartSearch.whoQueryList or 1)) and addon.smartSearch.progress or 1
		curQuery = addon.smartSearch.whoQueryList[addon.smartSearch.progress]
		addon.libWho:Who(tostring(curQuery),{queue = addon.libWho.WHOLIB_QUERY_QUIET, callback = SmartSearchWhoResultCallback})
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

function fn:StartSearch(timer)
	if addon.search.state == "pause" then
		local min,max = interface.scanFrame.progressBar:GetMinMax()
		local shift = addon.search.timeShift>0 and GetTime()-addon.search.timeShift or 0
		interface.scanFrame.progressBar:SetMinMax(min+shift, max+shift)
		addon.search.timeShift = 0
	end
	addon.search.state = "start"
	searchIntervalTimer(true, timer)
	nextSearch()
	Searchframe:SetScript("OnUpdate", SearchOnUpdate)
end

function fn:PauseSearch()
	if addon.search.state == 'start' then
		addon.search.timeShift = GetTime()
	end
	addon.search.state = "pause"
	searchIntervalTimer(false)
	Searchframe:SetScript("OnUpdate", nil)
	interface.scanFrame.pausePlay:SetDisabled(true)
	C_Timer.After(FGI_SCANINTERVALTIME, function() interface.scanFrame.pausePlay:SetDisabled(false) end)
end