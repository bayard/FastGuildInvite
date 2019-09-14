local addon = FGI
local fn = addon.functions
local L = addon.L
local interface = addon.interface
local settings = L.settings
local Console = LibStub("AceConsole-3.0")
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB = addon.DB
addon.icon = LibStub("LibDBIcon-1.0")
local icon = addon.icon
local color = addon.color
local debug = fn.debug

local function istable(t)
	return type(t) == "table"
end

addon.dataBroker = LibStub("LibDataBroker-1.1"):NewDataObject("FGI",
	{type = "launcher", label = "FGI", icon = "Interface\\AddOns\\FastGuildInvite\\img\\minimap\\MiniMapButton"}
)
local function mainFrameToggle()
	local mf = interface.mainFrame
	if mf.frame:IsShown() then
		mf:Hide()
	else
		mf:Show()
	end
end

function addon.dataBroker.OnClick(self, button)
	local shift = IsShiftKeyDown()
	if button == "LeftButton" and not shift then
		interface.scanFrame.invite.frame:Click()
	elseif button == "LeftButton" and shift then
		interface.scanFrame.pausePlay.frame:Click()
	elseif button == "RightButton" then
		mainFrameToggle()
	end
end

local function blackList(self)
	local button = self.value;
	if (button == "BLACKLIST") then
		local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
		local unit = dropdownFrame.unit;
		local name = dropdownFrame.name;
		local server = dropdownFrame.server;
		local fullname = name;
		
		if ( server and ((not unit and GetNormalizedRealmName() ~= server) or (unit and UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME)) ) then
			fullname = name.."-"..server;
		end
		
		fn:blackList(fullname)
		interface.blackList:updateList()
	end
end

local FGIBlackList = CreateFrame("Frame","FGIBlackListFrame")
FGIBlackList:SetScript("OnEvent", function() hooksecurefunc("UnitPopup_OnClick", blackList) end)
FGIBlackList:RegisterEvent("PLAYER_LOGIN")

local PopupUnits = {}

UnitPopupButtons["BLACKLIST"] = { text = "FGI - Black List",}

table.insert( UnitPopupMenus["SELF"] ,1 , "BLACKLIST")

for i,UPMenus in pairs(UnitPopupMenus) do
	for j=1, #UPMenus do
		if UPMenus[j] == "WHISPER" then
		  PopupUnits[#PopupUnits + 1] = i
		  pos = j + 1
		  table.insert( UnitPopupMenus[i] ,pos , "BLACKLIST" )
		  break
		end
	end
end
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(...)
	local _,_, msg = ...
	place = strfind(ERR_GUILD_LEAVE_S ,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_LEAVE_S ,name) == msg then
			DB.leave[name] = true
			debug(format("Player %s left the guild or was expelled.", name), color.yellow)
		end
	end
	--ERR_GUILD_REMOVE_SS
end)

function addon.dataBroker.OnTooltipShow(GameTooltip)
	local search = DB.SearchType == 3 and addon.smartSearch or addon.search
	GameTooltip:SetText(format(L.FAQ.help.minimap,#search.inviteList, interface.scanFrame.progressBar:GetProgress()), 1, 1, 1)
end


function FastGuildInvite:OnEnable()
	addon.debug = DB.debug
	fn:FiltersInit()
	fn:FiltersUpdate()
		
	interface.debugFrame = GUI:Create("ClearFrame")
	local debugFrame = interface.debugFrame
	debugFrame:SetTitle("FGI Debug")
	debugFrame:SetWidth(400)
	debugFrame:SetHeight(720)
	debugFrame:SetLayout("Fill")
	
	debugFrame.title:SetScript('OnMouseUp', function(mover)
		local frame = mover:GetParent()
		frame:StopMovingOrSizing()
		local self = frame.obj
		local status = self.status or self.localstatus
		status.width = frame:GetWidth()
		status.height = frame:GetHeight()
		status.top = frame:GetTop()
		status.left = frame:GetLeft()
	end)
	
	debugFrame.debugList = GUI:Create("MultiLineEditBox")
	local frame = debugFrame.debugList
	-- frame:SetNumLines(50)
	frame:SetLabel("")
	frame:SetWidth(interface.debugFrame.frame:GetWidth()-40)
	frame.txt = ''
	frame:DisableButton(true)
	frame:SetHeight(interface.debugFrame.frame:GetHeight()-40)
	debugFrame:AddChild(frame)
	
	debugFrame.closeButton = GUI:Create('Button')
	local frame = debugFrame.closeButton
	frame:SetText('X')
	frame:SetWidth(frame.frame:GetHeight())
	fn:closeBtn(frame)
	frame:SetCallback('OnClick', function()
		interface.debugFrame:Hide()
	end)
	debugFrame:AddChild(frame)
	-- debugFrame.closeButton:ClearAllPoints()
	debugFrame.closeButton:SetPoint("CENTER", debugFrame.frame, "TOPRIGHT", -8, -8)
	
	if not addon.debug then debugFrame:Hide() else debugFrame:Show() end
	
	if DB.keyBind then
		-- SetBindingClick(DB.keyBind, interface.scanFrame.invite.frame:GetName())
	end
	fn:SetKeybind(DB.keyBind)
	
	
	if DB.mainFrame then
		interface.mainFrame:ClearAllPoints()
		interface.mainFrame:SetPoint(DB.mainFrame.point, UIParent, DB.mainFrame.relativePoint, DB.mainFrame.xOfs, DB.mainFrame.yOfs)
	else
		interface.mainFrame:SetPoint("CENTER", UIParent)
	end
	if DB.scanFrame then
		interface.scanFrame:ClearAllPoints()
		interface.scanFrame:SetPoint(DB.scanFrame.point, UIParent, DB.scanFrame.relativePoint, DB.scanFrame.xOfs, DB.scanFrame.yOfs)
	else
		interface.scanFrame:SetPoint("CENTER", UIParent)
	end
	if DB.settingsFrame then
		interface.settingsFrame:ClearAllPoints()
		interface.settingsFrame:SetPoint(DB.settingsFrame.point, UIParent, DB.settingsFrame.relativePoint, DB.settingsFrame.xOfs, DB.settingsFrame.yOfs)
	else
		interface.settingsFrame:SetPoint("CENTER", UIParent)
	end
	if DB.filtersFrame then
		interface.filtersFrame:ClearAllPoints()
		interface.filtersFrame:SetPoint(DB.filtersFrame.point, UIParent, DB.filtersFrame.relativePoint, DB.filtersFrame.xOfs, DB.filtersFrame.yOfs)
	else
		interface.filtersFrame:SetPoint("CENTER", UIParent)
	end
	if DB.addfilterFrame then
		interface.addfilterFrame:ClearAllPoints()
		interface.addfilterFrame:SetPoint(DB.addfilterFrame.point, UIParent, DB.addfilterFrame.relativePoint, DB.addfilterFrame.xOfs, DB.addfilterFrame.yOfs)
	else
		interface.addfilterFrame:SetPoint("CENTER", UIParent)
	end
	if DB.messageFrame then
		interface.messageFrame:ClearAllPoints()
		interface.messageFrame:SetPoint(DB.messageFrame.point, UIParent, DB.messageFrame.relativePoint, DB.messageFrame.xOfs, DB.messageFrame.yOfs)
	else
		interface.messageFrame:SetPoint("CENTER", UIParent)
	end
	if DB.chooseInvites then
		interface.chooseInvites:ClearAllPoints()
		interface.chooseInvites:SetPoint(DB.chooseInvites.point, UIParent, DB.chooseInvites.relativePoint, DB.chooseInvites.xOfs, DB.chooseInvites.yOfs)
	else
		interface.chooseInvites:SetPoint("CENTER", UIParent)
	end
	if DB.blackListPos then
		interface.blackList:ClearAllPoints()
		interface.blackList:SetPoint(DB.blackListPos.point, UIParent, DB.blackListPos.relativePoint, DB.blackListPos.xOfs, DB.blackListPos.yOfs)
	else
		interface.blackList:SetPoint("CENTER", UIParent)
	end
	interface.debugFrame:ClearAllPoints()
	interface.debugFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
	
	interface.gratitudeFrame:ClearAllPoints()
	interface.gratitudeFrame:SetPoint("CENTER", UIParent)
	
	Console:RegisterChatCommand('fgi', 'FGIInput')
	Console:RegisterChatCommand('FastGuildInvite', 'FGIInput')
end

function FastGuildInvite:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FGI_DB")
	self.db.RegisterCallback(self, "OnDatabaseReset", function() C_UI.Reload() end)
	
	DB = self.db.global
	addon.DB = DB
	
	DB.inviteType = DB.inviteType or 1
	
	DB.lowLimit = DB.lowLimit or FGI_MINLVL
	DB.highLimit = DB.highLimit or FGI_MAXLVL
	DB.raceFilterVal = DB.raceFilterVal or FGI_DEFAULT_RACEFILTERSTART
	DB.classFilterVal = DB.classFilterVal or FGI_DEFAULT_CLASSFILTERSTART
	DB.searchInterval = DB.searchInterval or FGI_DEFAULT_SEARCHINTERVAL
	
	DB.SearchType = DB.SearchType or 3
	DB.backgroundRun = DB.backgroundRun or false
	DB.enableFilters = DB.enableFilters or false
	
	DB.addonMSG = DB.addonMSG or false
	DB.systemMSG = DB.systemMSG or false
	DB.sendMSG = DB.sendMSG or false
	DB.keyBind = DB.keyBind or false
	DB.rememberAll = DB.rememberAll or false
	DB.clearDBtimes = DB.clearDBtimes or 3
	
	DB.messageList = istable(DB.messageList) and DB.messageList or {}
	DB.curMessage = DB.curMessage or 0
	
	DB.alredySended = istable(DB.alredySended) and DB.alredySended or {}
	DB.filtersList = istable(DB.filtersList) and DB.filtersList or {}
	DB.blackList = istable(DB.blackList) and DB.blackList or {}
	DB.leave = istable(DB.leave) and DB.leave or {}
	
	DB.debug = DB.debug or false
	
	if DB.clearDBtimes>1 then
		for k,v in pairs(DB.alredySended) do	-- delete player from sended DB after "FGI_RESETSENDDBTIME"
			if difftime(time({year = date("%Y"), month = date("%m"), day = date("%d")}), v) >= FGI_RESETSENDDBTIME[DB.clearDBtimes] then
				DB.alredySended[k] = nil
			end
		end
	end

	DB.minimap = istable(DB.minimap) and DB.minimap or {}
	DB.minimap.hide = DB.minimap.hide or false
	
	icon:Register("FGI", addon.dataBroker, DB.minimap)
end

local function toggleDebug()
	DB.debug = not DB.debug
	addon.debug = DB.debug
	if addon.debug then
		interface.debugFrame:Show()
	else
		interface.debugFrame:Hide()
	end
	print("FGI Debug "..(DB.debug and color.green.."on" or color.red.."off").."|r")
end
function Console:FGIInput(str)
	if str == '' then return Console:FGIHelp()
	elseif str == 'show' then return interface.mainFrame:Show()
	elseif str == 'debug' then 
		toggleDebug()
	elseif str == 'resetDB' then DB.alredySended = {}
	elseif str == 'resetWindowsPos' then
		
		interface.mainFrame:ClearAllPoints()
		interface.gratitudeFrame:ClearAllPoints()
		interface.scanFrame:ClearAllPoints()
		interface.settingsFrame:ClearAllPoints()
		interface.filtersFrame:ClearAllPoints()
		interface.addfilterFrame:ClearAllPoints()
		interface.messageFrame:ClearAllPoints()
		interface.chooseInvites:ClearAllPoints()
		interface.blackList:ClearAllPoints()
		
		interface.mainFrame:SetPoint("CENTER", UIParent)
		interface.gratitudeFrame:SetPoint("CENTER", UIParent)
		interface.scanFrame:SetPoint("CENTER", UIParent)
		interface.settingsFrame:SetPoint("CENTER", UIParent)
		interface.filtersFrame:SetPoint("CENTER", UIParent)
		interface.addfilterFrame:SetPoint("CENTER", UIParent)
		interface.messageFrame:SetPoint("CENTER", UIParent)
		interface.chooseInvites:SetPoint("CENTER", UIParent)
		interface.blackList:SetPoint("CENTER", UIParent)
		
		local point, relativeTo,relativePoint, xOfs, yOfs = interface.mainFrame.frame:GetPoint(1)
		DB.mainFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.scanFrame.frame:GetPoint(1)
		DB.scanFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.settingsFrame.frame:GetPoint(1)
		DB.settingsFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.filtersFrame.frame:GetPoint(1)
		DB.filtersFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.addfilterFrame.frame:GetPoint(1)
		DB.addfilterFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.messageFrame.frame:GetPoint(1)
		DB.messageFrame = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.chooseInvites.frame:GetPoint(1)
		DB.chooseInvites = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		point, relativeTo,relativePoint, xOfs, yOfs = interface.blackList.frame:GetPoint(1)
		DB.blackList = {point=point, relativeTo=relativeTo, relativePoint=relativePoint, xOfs=xOfs, yOfs=yOfs,}
		
		C_UI.Reload()
	elseif str == "factorySettings" then
		FastGuildInvite.db:ResetDB()
	end
end

function Console:FGIHelp()
	print(L.FAQ.help.show)
	print(L.FAQ.help.resetDB)
	print(L.FAQ.help.factorySettings)
	print(L.FAQ.help.resetWindowsPos)
end