local addon = FGI
local fn = addon.functions
local L = addon.L
local interface = addon.interface
local settings = L.settings
local Console = LibStub("AceConsole-3.0")
local GUI = LibStub("AceKGUI-3.0")
local FastGuildInvite = addon.lib
local DB = addon.DB
addon.icon = LibStub("LibDBIcon-1.0")
local icon = addon.icon

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

function addon.dataBroker.OnTooltipShow(GameTooltip)
	local search = DB.SearchType == 3 and addon.smartSearch or addon.search
	GameTooltip:SetText(format(L.help.minimap,#search.inviteList, interface.scanFrame.progressBar:GetProgress()), 1, 1, 1)
end


function FastGuildInvite:OnEnable()
	fn:FiltersInit()
	fn:FiltersUpdate()
	if DB.keyBind then
		-- SetBindingClick(DB.keyBind, interface.scanFrame.invite.frame:GetName())
	end
	fn:SetKeybind(DB.keyBind)
	if DB.mainFrame then
		interface.mainFrame:ClearAllPoints()
		interface.mainFrame:SetPoint(DB.mainFrame.point, UIParent, DB.mainFrame.relativePoint, DB.mainFrame.xOfs, DB.mainFrame.yOfs)
	end
	if DB.scanFrame then
		interface.scanFrame:ClearAllPoints()
		interface.scanFrame:SetPoint(DB.scanFrame.point, UIParent, DB.scanFrame.relativePoint, DB.scanFrame.xOfs, DB.scanFrame.yOfs)
	end
	if DB.settingsFrame then
		interface.settingsFrame:ClearAllPoints()
		interface.settingsFrame:SetPoint(DB.settingsFrame.point, UIParent, DB.settingsFrame.relativePoint, DB.settingsFrame.xOfs, DB.settingsFrame.yOfs)
	end
	if DB.filtersFrame then
		interface.filtersFrame:ClearAllPoints()
		interface.filtersFrame:SetPoint(DB.filtersFrame.point, UIParent, DB.filtersFrame.relativePoint, DB.filtersFrame.xOfs, DB.filtersFrame.yOfs)
	end
	if DB.addfilterFrame then
		interface.addfilterFrame:ClearAllPoints()
		interface.addfilterFrame:SetPoint(DB.addfilterFrame.point, UIParent, DB.addfilterFrame.relativePoint, DB.addfilterFrame.xOfs, DB.addfilterFrame.yOfs)
	end
	if DB.messageFrame then
		interface.addfilterFrame:ClearAllPoints()
		interface.addfilterFrame:SetPoint(DB.messageFrame.point, UIParent, DB.messageFrame.relativePoint, DB.messageFrame.xOfs, DB.messageFrame.yOfs)
	end
	
	Console:RegisterChatCommand('fgi', 'FGIInput')
	Console:RegisterChatCommand('FastGuildInvite', 'FGIInput')
end

function FastGuildInvite:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FGI_DB")
	self.db.RegisterCallback(self, "OnDatabaseReset", function() UIReload() end)
	
	DB = self.db.global
	addon.DB = DB
	
	DB.inviteType = DB.inviteType or 1
	
	DB.lowLimit = DB.lowLimit or FGI_MINLVL
	DB.highLimit = DB.highLimit or FGI_MAXLVL
	DB.raceFilterVal = DB.raceFilterVal or FGI_DEFAULT_RACEFILTERSTART
	DB.classFilterVal = DB.classFilterVal or FGI_DEFAULT_CLASSFILTERSTART
	DB.searchInterval = DB.searchInterval or FGI_DEFAULT_SEARCHINTERVAL
	
	DB.SearchType = DB.SearchType or 1
	DB.backgroundRun = DB.backgroundRun or false
	DB.enableFilters = DB.enableFilters or false
	
	DB.addonMSG = DB.addonMSG or false
	DB.systemMSG = DB.systemMSG or false
	DB.sendMSG = DB.sendMSG or false
	DB.keyBind = DB.keyBind or false
	
	DB.messageList = type(DB.messageList) == "table" and DB.messageList or {}
	DB.curMessage = DB.curMessage or 0
	
	DB.alredySended = type(DB.alredySended)=="table" and DB.alredySended or {}
	DB.filtersList = type(DB.filtersList)=="table" and DB.filtersList or {}
	
	for k,v in pairs(DB.alredySended) do	-- delete player from sended DB after "FGI_RESETSENDDBTIME"
		if difftime(time({year = date("%Y"), month = date("%m"), day = date("%d")}), v) >= FGI_RESETSENDDBTIME then
			DB.alredySended[k] = nil
		end
	end
	

	DB.minimap = type(DB.minimap) == "table" and DB.minimap or {}
	DB.minimap.hide = DB.minimap.hide or false
	
	icon:Register("FGI", addon.dataBroker, DB.minimap)
end

function Console:FGIInput(str)
	if str == '' then return Console:FGIHelp()
	elseif str == 'show' then return interface.mainFrame:Show()
	elseif str == 'resetDB' then DB.alredySended = {}
	elseif str == 'resetWindowsPos' then
		
		interface.mainFrame:ClearAllPoints()
		interface.scanFrame:ClearAllPoints()
		interface.settingsFrame:ClearAllPoints()
		interface.filtersFrame:ClearAllPoints()
		interface.addfilterFrame:ClearAllPoints()
		
		interface.mainFrame:SetPoint("CENTER", UIParent)
		interface.scanFrame:SetPoint("CENTER", UIParent)
		interface.settingsFrame:SetPoint("CENTER", UIParent)
		interface.filtersFrame:SetPoint("CENTER", UIParent)
		interface.addfilterFrame:SetPoint("CENTER", UIParent)
		
		DB.mainFrame = nil
		DB.scanFrame = nil
		DB.settingsFrame = nil
		DB.filtersFrame = nil
		DB.addfilterFrame = nil
	elseif str == "factorySettings" then
		FastGuildInvite.db:ResetDB()
	end
end

function Console:FGIHelp()
	print(L.help.show)
	print(L.help.resetDB)
	print(L.help.factorySettings)
	print(L.help.resetWindowsPos)
end