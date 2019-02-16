local addon = FGI
local fn = addon.functions
local L = addon.L
local settings = L.settings
local size = settings.size
local color = addon.color
local interface = addon.interface
local GUI = LibStub("AceKGUI-3.0")
local FastGuildInvite = addon.lib
local DB

local function fontSize(self, font, size)
	font = font or settings.Font
	size = size or settings.FontSize
	self:SetFont(font, size)
end

interface.mainFrame = GUI:Create("Frame")
local mainFrame = interface.mainFrame
mainFrame:Hide()
mainFrame:SetTitle("Fast Guild Invite")
mainFrame:clearFrame(true)
mainFrame:SetWidth(size.mainFrameW)
mainFrame:SetHeight(size.mainFrameH)

mainFrame.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = mainFrame.frame:GetPoint(1)
	DB.mainFrame = {}
	DB.mainFrame.point=point
	DB.mainFrame.relativeTo=relativeTo
	DB.mainFrame.relativePoint=relativePoint
	DB.mainFrame.xOfs=xOfs
	DB.mainFrame.yOfs=yOfs
end)

mainFrame.closeButton = GUI:Create('Button')
local frame = mainFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
frame:SetCallback('OnClick', function()
	interface.mainFrame:Hide()
end)
mainFrame:AddChild(frame)




mainFrame.inviteTypeGRP = GUI:Create("Frame")
local inviteTypeGRP = mainFrame.inviteTypeGRP
inviteTypeGRP:SetLayout("List")
inviteTypeGRP:isGroupFrame(true)
inviteTypeGRP:SetHeight(50)
inviteTypeGRP:SetWidth(size.inviteTypeGRP)
mainFrame:AddChild(inviteTypeGRP)

inviteTypeGRP.inviteType = GUI:Create("Label")
local frame = inviteTypeGRP.inviteType
frame:SetText(L["Режим приглашения"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(size.inviteTypeGRP)
inviteTypeGRP:AddChild(frame)

inviteTypeGRP.drop = GUI:Create("Dropdown")
local frame = inviteTypeGRP.drop
frame:SetWidth(size.inviteTypeGRP)
frame:SetList(L.invType)
frame:SetValue(1)
frame:SetCallback("OnValueChanged", function(key)
	DB.inviteType = inviteTypeGRP.drop:GetValue()
end)
inviteTypeGRP:AddChild(frame)




mainFrame.mainCheckBoxGRP = GUI:Create("Frame")
local mainCheckBoxGRP = mainFrame.mainCheckBoxGRP
mainCheckBoxGRP:SetLayout("List")
mainCheckBoxGRP:isGroupFrame(true)
mainCheckBoxGRP:SetHeight(120)
mainCheckBoxGRP:SetWidth(size.mainCheckBoxGRP)
mainFrame:AddChild(mainCheckBoxGRP)

local function radioToggle(type)
	if type == 1 then
		mainCheckBoxGRP.normalSearch:SetValue(true)
	elseif type == 2 then
		mainCheckBoxGRP.deepSearch:SetValue(true)
		mainFrame.searchRangeGRP.searchInterval.frame:Show()
		mainFrame.searchRangeGRP.raceFilterStart.frame:Show()
		mainFrame.searchRangeGRP.classFilterStart.frame:Show()
	elseif type == 3 then
		mainCheckBoxGRP.smartSearch:SetValue(true)
	end
	
	if type ~= 2 then
		mainFrame.searchRangeGRP.searchInterval.frame:Hide()
		mainFrame.searchRangeGRP.raceFilterStart.frame:Hide()
		mainFrame.searchRangeGRP.classFilterStart.frame:Hide()
	end
	
	if type == 1 or type == 2 then
		mainCheckBoxGRP.smartSearch:SetValue(false)
	end
	if  type == 1 or type == 3 then
		mainCheckBoxGRP.deepSearch:SetValue(false)
	end
	if  type == 2 or type == 3 then
		mainCheckBoxGRP.normalSearch:SetValue(false)
	end
	
	DB.SearchType = type
end

mainCheckBoxGRP.normalSearch = GUI:Create("CheckBox")
local frame = mainCheckBoxGRP.normalSearch
frame:SetWidth(size.normalSearch)
frame:SetLabel(L["Обычный поиск"])
frame:SetType("radio")
fontSize(frame.text)
frame.frame:SetScript("OnClick", function()
	radioToggle(1)
end)
mainCheckBoxGRP:AddChild(frame)

mainCheckBoxGRP.deepSearch = GUI:Create("CheckBox")
local frame = mainCheckBoxGRP.deepSearch
frame:SetWidth(size.deepSearch)
frame:SetLabel(L["Расширенное сканирование"])
frame:SetTooltip(L.tooltip["Дополнительные настройки сканирования"])
frame:SetType("radio")
fontSize(frame.text)
frame.frame:SetScript("OnClick", function()
	radioToggle(2)
end)
mainCheckBoxGRP:AddChild(frame)

mainCheckBoxGRP.smartSearch = GUI:Create("CheckBox")
local frame = mainCheckBoxGRP.smartSearch
frame:SetWidth(size.smartSearch)
frame:SetLabel(L["Умный поиск"])
frame:SetTooltip(L.tooltip["Автоматическое увеличение детализации поиска"])
frame:SetType("radio")
fontSize(frame.text)
frame.frame:SetScript("OnClick", function()
	radioToggle(3)
end)
mainCheckBoxGRP:AddChild(frame)

mainCheckBoxGRP.backgroundRun = GUI:Create("CheckBox")
local frame = mainCheckBoxGRP.backgroundRun
frame:SetWidth(size.backgroundRun)
frame:SetLabel(L["Запускать в фоновом режиме"])
frame:SetTooltip(L.tooltip["Запускать поиск в фоновом режиме"])
fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.backgroundRun = mainCheckBoxGRP.backgroundRun:GetValue()
end)
mainCheckBoxGRP:AddChild(frame)

mainCheckBoxGRP.enableFilters = GUI:Create("CheckBox")
local frame = mainCheckBoxGRP.enableFilters
frame:SetWidth(size.enableFilters)
frame:SetLabel(L["Включить фильтры"])
frame:SetTooltip("")
fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.enableFilters = mainCheckBoxGRP.enableFilters:GetValue()
end)
mainCheckBoxGRP:AddChild(frame)




mainFrame.mainButtonsGRP = GUI:Create("Frame")
local mainButtonsGRP = mainFrame.mainButtonsGRP
mainButtonsGRP:SetLayout("List")
mainButtonsGRP:isGroupFrame(true)
mainButtonsGRP:SetHeight(80)
mainButtonsGRP:SetWidth(size.mainButtonsGRP)
mainFrame:AddChild(mainButtonsGRP)

mainButtonsGRP.startScan = GUI:Create("Button")
local frame = mainButtonsGRP.startScan
frame:SetText(L["Начать сканирование"])
fontSize(frame.text)
frame:SetWidth(size.startScan)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	if not fn:inGuildCanInvite() then return print(L.error["Вы не состоите в гильдии или у вас нет прав для приглашения."]) end
	if not DB.backgroundRun or addon.search.state ~= "stop" then
		interface.scanFrame:Show()
	end
	if addon.search.state ~= "start" then
		interface.scanFrame.pausePlay.frame:Click()
	end
end)
mainButtonsGRP:AddChild(frame)

mainButtonsGRP.chooseInvites = GUI:Create("Button")
local frame = mainButtonsGRP.chooseInvites
frame:SetText(L["Выбрать приглашения"])
fontSize(frame.text)
frame:SetWidth(size.chooseInvites)
frame:SetHeight(mainButtonsGRP.startScan.frame:GetHeight())
frame:SetCallback("OnClick", function() interface.chooseInvites:Show() end)
mainButtonsGRP:AddChild(frame)

mainButtonsGRP.settingsBtn = GUI:Create("Button")
local frame = mainButtonsGRP.settingsBtn
frame:SetText(L["Настройки"])
fontSize(frame.text)
frame:SetWidth(size.settingsBtn)
frame:SetHeight(mainButtonsGRP.startScan.frame:GetHeight())
frame.frame:SetScript("OnClick", function()
	interface.settingsFrame:Show()
	interface.mainFrame:Hide()
end)
mainButtonsGRP:AddChild(frame)




mainFrame.searchRangeGRP = GUI:Create("Frame")
local searchRangeGRP = mainFrame.searchRangeGRP
searchRangeGRP:SetLayout("List")
searchRangeGRP:isGroupFrame(true)
searchRangeGRP:SetHeight(100)
searchRangeGRP:SetWidth(size.searchRangeGRP)
mainFrame:AddChild(searchRangeGRP)

searchRangeGRP.lvlRange = GUI:Create("Label")
local frame = searchRangeGRP.lvlRange
frame:SetText(L["Диапазон уровней"])
fontSize(frame.label)
frame:SetWidth(size.lvlRange)
frame.label:SetJustifyH("CENTER")
searchRangeGRP:AddChild(frame)

searchRangeGRP.lvlRangeMin = GUI:Create("Label")
local frame = searchRangeGRP.lvlRangeMin
frame:SetText(FGI_MINLVL)
fontSize(frame.label)
frame.label:SetJustifyH("RIGHT")
frame:SetWidth(30)
frame.frame:SetScript("OnMouseWheel",function(self,mod)
	if mod == 1 and DB.lowLimit+1 <= DB.highLimit then
		DB.lowLimit = DB.lowLimit + 1
	elseif mod == -1 and DB.lowLimit-1 >= FGI_MINLVL then
		DB.lowLimit = DB.lowLimit - 1
	end
	searchRangeGRP.lvlRangeMin:SetText(DB.lowLimit)
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.lvlRangeLine = GUI:Create("Label")
local frame = searchRangeGRP.lvlRangeLine
frame:SetText('-')
frame.label:SetJustifyH("CENTER")
fontSize(frame.label)
frame:SetWidth(15)
searchRangeGRP:AddChild(frame)

searchRangeGRP.lvlRangeMax = GUI:Create("Label")
local frame = searchRangeGRP.lvlRangeMax
frame:SetText(FGI_MAXLVL)
frame.label:SetJustifyH("LEFT")
frame:SetWidth(searchRangeGRP.lvlRangeMin.frame:GetWidth())
fontSize(frame.label)
frame.frame:SetScript("OnMouseWheel",function(self,mod)
	if mod == 1 and DB.highLimit+1 <= FGI_MAXLVL then
		DB.highLimit = DB.highLimit + 1
	elseif mod == -1 and DB.highLimit-1 >= DB.lowLimit then
		DB.highLimit = DB.highLimit - 1
	end
	searchRangeGRP.lvlRangeMax:SetText(DB.highLimit)
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.searchInterval = GUI:Create("Label")
local frame = searchRangeGRP.searchInterval
frame:SetText(L["Интервал"])
frame:SetTooltip(L.tooltip["Количество уровней сканируемых за один раз"])
fontSize(frame.label)
frame:SetWidth(size.searchInterval)
frame.label:SetJustifyH("CENTER")
frame.frame:HookScript("OnHide", function()
	searchRangeGRP.searchIntervalVal.frame:Hide()
end)
frame.frame:HookScript("OnShow", function()
	searchRangeGRP.searchIntervalVal.frame:Show()
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.searchIntervalVal = GUI:Create("Label")
local frame = searchRangeGRP.searchIntervalVal
frame:SetText(FGI_DEFAULT_SEARCHINTERVAL)
fontSize(frame.label)
frame:SetWidth(40)
frame.label:SetJustifyH("CENTER")
frame.frame:SetScript("OnMouseWheel",function(self,mod)
	if mod == 1 and DB.searchInterval+1 <= 30 then
		DB.searchInterval = DB.searchInterval + 1
	elseif mod == -1 and DB.searchInterval-1 >= 1 then
		DB.searchInterval = DB.searchInterval - 1
	end
	searchRangeGRP.searchIntervalVal:SetText(DB.searchInterval)
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.raceFilterStart = GUI:Create("Label")
local frame = searchRangeGRP.raceFilterStart
frame:SetText(L["Фильтр рас начало:"])
frame:SetTooltip(L.tooltip["Уровень, с которого начинается фильтр по расам"])
fontSize(frame.label)
frame:SetWidth(size.raceFilterStart)
frame.label:SetJustifyH("CENTER")
frame.frame:HookScript("OnHide", function()
	searchRangeGRP.raceFilterStartVal.frame:Hide()
end)
frame.frame:HookScript("OnShow", function()
	searchRangeGRP.raceFilterStartVal.frame:Show()
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.raceFilterStartVal = GUI:Create("Label")
local frame = searchRangeGRP.raceFilterStartVal
frame:SetText(FGI_DEFAULT_RACEFILTERSTART == FGI_MAXLVL+1 and L["Откл."] or FGI_DEFAULT_RACEFILTERSTART)
fontSize(frame.label)
frame:SetWidth(40)
frame.label:SetJustifyH("CENTER")
frame.frame:SetScript("OnMouseWheel",function(self,mod)
	if mod == 1 then
		if DB.raceFilterVal+1 <= FGI_MAXLVL then
			DB.raceFilterVal = DB.raceFilterVal + 1
		else
			DB.raceFilterVal = FGI_MAXLVL+1
		end
	elseif mod == -1 and DB.raceFilterVal-1 >= DB.lowLimit then
		DB.raceFilterVal = DB.raceFilterVal - 1
	end
	searchRangeGRP.raceFilterStartVal:SetText(DB.raceFilterVal == FGI_MAXLVL+1 and L["Откл."] or DB.raceFilterVal)
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.classFilterStart = GUI:Create("Label")
local frame = searchRangeGRP.classFilterStart
frame:SetText(L["Фильтр классов начало:"])
frame:SetTooltip(L.tooltip["Уровень, с которого начинается фильтр по классам"])
fontSize(frame.label)
frame:SetWidth(size.classFilterStart)
frame.label:SetJustifyH("CENTER")
frame.frame:HookScript("OnHide", function()
	searchRangeGRP.classFilterStartVal.frame:Hide()
end)
frame.frame:HookScript("OnShow", function()
	searchRangeGRP.classFilterStartVal.frame:Show()
end)
searchRangeGRP:AddChild(frame)

searchRangeGRP.classFilterStartVal = GUI:Create("Label")
local frame = searchRangeGRP.classFilterStartVal
frame:SetText(FGI_DEFAULT_CLASSFILTERSTART == FGI_MAXLVL+1 and L["Откл."] or FGI_DEFAULT_CLASSFILTERSTART)
fontSize(frame.label)
frame:SetWidth(40)
frame.label:SetJustifyH("CENTER")
frame.frame:SetScript("OnMouseWheel",function(self,mod)
	if mod == 1 then
		if DB.classFilterVal+1 <= FGI_MAXLVL then
			DB.classFilterVal = DB.classFilterVal + 1
		else
			DB.classFilterVal = FGI_MAXLVL+1
		end
	elseif mod == -1 and DB.classFilterVal-1 >= DB.lowLimit then
		DB.classFilterVal = DB.classFilterVal - 1
	end
	searchRangeGRP.classFilterStartVal:SetText(DB.classFilterVal == FGI_MAXLVL+1 and L["Откл."] or DB.classFilterVal)
end)
searchRangeGRP:AddChild(frame)





-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	mainFrame:Show()
	DB = addon.DB
	
	inviteTypeGRP.drop:SetValue(DB.inviteType)
	
	mainCheckBoxGRP.normalSearch:SetValue(DB.SearchType==1)
	mainCheckBoxGRP.deepSearch:SetValue(DB.SearchType==2)
	mainCheckBoxGRP.smartSearch:SetValue(DB.SearchType==3)
	mainCheckBoxGRP.backgroundRun:SetValue(DB.backgroundRun or false)
	mainCheckBoxGRP.enableFilters:SetValue(DB.enableFilters or false)
	
	searchRangeGRP.lvlRangeMin:SetText(DB.lowLimit)
	searchRangeGRP.lvlRangeMax:SetText(DB.highLimit)
	searchRangeGRP.searchIntervalVal:SetText(DB.searchInterval)
	searchRangeGRP.raceFilterStartVal:SetText(DB.raceFilterVal == FGI_MAXLVL+1 and L["Откл."] or DB.raceFilterVal)
	searchRangeGRP.classFilterStartVal:SetText(DB.classFilterVal == FGI_MAXLVL+1 and L["Откл."] or DB.classFilterVal)
	if not(mainCheckBoxGRP.deepSearch:GetValue()) then
		searchRangeGRP.searchInterval.frame:Hide()
		searchRangeGRP.raceFilterStart.frame:Hide()
		searchRangeGRP.classFilterStart.frame:Hide()
	end
	
	
	mainFrame.closeButton:ClearAllPoints()
	mainFrame.closeButton:SetPoint("CENTER", mainFrame.frame, "TOPRIGHT", -8, -8)
	
	inviteTypeGRP:ClearAllPoints()
	inviteTypeGRP:SetPoint("TOPLEFT", mainFrame.frame, "TOPLEFT", 20, -40)
	
	inviteTypeGRP.inviteType:ClearAllPoints()
	inviteTypeGRP.inviteType:SetPoint("TOPLEFT", inviteTypeGRP.frame, "TOPLEFT", 0, 0)
	
	mainCheckBoxGRP:ClearAllPoints()
	mainCheckBoxGRP:SetPoint("TOPLEFT", inviteTypeGRP.frame, "BOTTOMLEFT", 0, -20)
	
	mainCheckBoxGRP.normalSearch:ClearAllPoints()
	mainCheckBoxGRP.normalSearch:SetPoint("TOPLEFT", mainCheckBoxGRP.frame, "TOPLEFT", 0, 0)
	
	searchRangeGRP:ClearAllPoints()
	searchRangeGRP:SetPoint("TOPLEFT", inviteTypeGRP.frame, "TOPRIGHT", 15, 0)
	
	searchRangeGRP.lvlRange:ClearAllPoints()
	searchRangeGRP.lvlRange:SetPoint("TOPLEFT", searchRangeGRP.frame, "TOPLEFT", 0, 0)
	
	searchRangeGRP.lvlRangeLine:ClearAllPoints()
	searchRangeGRP.lvlRangeLine:SetPoint("TOP", searchRangeGRP.lvlRange.frame, "BOTTOM", 0, -10)
	
	searchRangeGRP.lvlRangeMin:ClearAllPoints()
	searchRangeGRP.lvlRangeMin:SetPoint("RIGHT", searchRangeGRP.lvlRangeLine.frame, "LEFT", 0, 0)
	
	searchRangeGRP.lvlRangeMax:ClearAllPoints()
	searchRangeGRP.lvlRangeMax:SetPoint("LEFT", searchRangeGRP.lvlRangeLine.frame, "RIGHT", 0, 0)
	
	searchRangeGRP.searchInterval:ClearAllPoints()
	searchRangeGRP.searchInterval:SetPoint("TOP", searchRangeGRP.lvlRange.frame, "BOTTOM", 0, -40)
	
	searchRangeGRP.searchIntervalVal:ClearAllPoints()
	searchRangeGRP.searchIntervalVal:SetPoint("TOP", searchRangeGRP.searchInterval.frame, "BOTTOM", 0, -10)
	
	searchRangeGRP.raceFilterStart:ClearAllPoints()
	searchRangeGRP.raceFilterStart:SetPoint("LEFT", searchRangeGRP.lvlRange.frame, "RIGHT", 30, 0)
	
	searchRangeGRP.raceFilterStartVal:ClearAllPoints()
	searchRangeGRP.raceFilterStartVal:SetPoint("TOP", searchRangeGRP.raceFilterStart.frame, "BOTTOM", 0, -10)
	
	searchRangeGRP.classFilterStart:ClearAllPoints()
	searchRangeGRP.classFilterStart:SetPoint("TOP", searchRangeGRP.raceFilterStart.frame, "BOTTOM", 0, -40)
	
	searchRangeGRP.classFilterStartVal:ClearAllPoints()
	searchRangeGRP.classFilterStartVal:SetPoint("TOP", searchRangeGRP.classFilterStart.frame, "BOTTOM", 0, -10)
	
	mainButtonsGRP:ClearAllPoints()
	mainButtonsGRP:SetPoint("TOPLEFT", mainCheckBoxGRP.frame, "BOTTOMLEFT", 0, -10)
	
	mainButtonsGRP.startScan:ClearAllPoints()
	mainButtonsGRP.startScan:SetPoint("TOPLEFT", mainButtonsGRP.frame, "TOPLEFT", 0, 0)
	
	mainButtonsGRP.chooseInvites:ClearAllPoints()
	mainButtonsGRP.chooseInvites:SetPoint("LEFT", mainButtonsGRP.startScan.frame, "RIGHT", 2, 0)
	
	mainButtonsGRP.settingsBtn:ClearAllPoints()
	mainButtonsGRP.settingsBtn:SetPoint("LEFT", mainButtonsGRP.chooseInvites.frame, "RIGHT", 2, 0)
	
	mainFrame:Hide()
end)