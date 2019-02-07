local addon = FGI
local fn = addon.functions
local L = addon.L
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
	local mf = addon.interface.mainFrame
	if mf.frame:IsShown() then
		mf:Hide()
	else
		mf:Show()
	end
end

function addon.dataBroker.OnClick(self, button)
	local shift = IsShiftKeyDown()
	if button == "LeftButton" and not shift then
		addon.interface.scanFrame.invite.frame:Click()
	elseif button == "LeftButton" and shift then
		addon.interface.scanFrame.pausePlay.frame:Click()
	elseif button == "RightButton" then
		mainFrameToggle()
	end
end

function addon.dataBroker.OnTooltipShow(GameTooltip)
	local search = DB.SearchType == 3 and addon.smartSearch or addon.search
	GameTooltip:SetText(format(L.minimapHelp,#search.inviteList,addon.interface.scanFrame.progressBar:GetProgress()), 1, 1, 1)
end


function FastGuildInvite:OnEnable()
	Console:RegisterChatCommand('fgi', 'FGIInput')
	Console:RegisterChatCommand('FastGuildInvite', 'FGIInput')
end

function FastGuildInvite:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("FGI_DB")
	
	DB = self.db.global
	addon.DB = DB
	
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
	
	DB.alredySended = type(DB.alredySended)=="table" and DB.alredySended or {}
	DB.filtersList = type(DB.filtersList)=="table" and DB.filtersList or {}
	
	for k,v in pairs(DB.alredySended) do	-- delete player from sended DB after "FGI_RESETDBTIME"
		if difftime(time({year = date("%Y"), month = date("%m"), day = date("%d")}), v) >= FGI_RESETDBTIME then
			DB.alredySended[k] = nil
		end
	end
	

	DB.minimap = type(DB.minimap) == "table" and DB.minimap or {}
	DB.minimap.hide = DB.minimap.hide or false
	
	icon:Register("FGI", addon.dataBroker, DB.minimap)
end

function Console:FGIInput(str)
	if str == '' then return Console:FGIHelp()
	elseif str == 'show' then return addon.interface.mainFrame:Show()
	elseif str == 'resetDB' then DB.alredySended = {}
	elseif str == 'resetWindowsPos' then
		local interface = addon.interface
		
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
	end
end

function Console:FGIHelp()
	print(L.help.show)
	print(L.help.resetDB)
	print(L.help.resetWindowsPos)
end