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

interface.settingsFrame = GUI:Create("Frame")
local settingsFrame = interface.settingsFrame
settingsFrame:SetTitle("FGI Settings")
settingsFrame:clearFrame(true)
settingsFrame:SetWidth(size.settingsFrameW)
settingsFrame:SetHeight(size.settingsFrameH)

settingsFrame.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = settingsFrame.frame:GetPoint(1)
	DB.settingsFrame = {}
	DB.settingsFrame.point=point
	DB.settingsFrame.relativeTo=relativeTo
	DB.settingsFrame.relativePoint=relativePoint
	DB.settingsFrame.xOfs=xOfs
	DB.settingsFrame.yOfs=yOfs
end)

settingsFrame.closeButton = GUI:Create('Button')
local frame = settingsFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
frame:SetCallback('OnClick', function()
	interface.settingsFrame:Hide()
	interface.mainFrame:Show()
end)
settingsFrame:AddChild(frame)




settingsFrame.settingsCheckBoxGRP = GUI:Create("Frame")
local settingsCheckBoxGRP = settingsFrame.settingsCheckBoxGRP
--settingsCheckBoxGRP:SetLayout("List")
settingsCheckBoxGRP:isGroupFrame(true)
settingsCheckBoxGRP:SetHeight(100)
settingsCheckBoxGRP:SetWidth(size.settingsCheckBoxGRP)
settingsFrame:AddChild(settingsCheckBoxGRP)

settingsCheckBoxGRP.addonMSG = GUI:Create("CheckBox")
local frame = settingsCheckBoxGRP.addonMSG
frame:SetWidth(size.addonMSG)
frame:SetLabel(L.interface["Выключить сообщения аддона"])
frame:SetTooltip(L.interface.tooltip["Не отображать в чате сообщения аддона"])
frame:SetDisabled(true)
fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.addonMSG = settingsCheckBoxGRP.addonMSG:GetValue()
end)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.systemMSG = GUI:Create("CheckBox")
local frame = settingsCheckBoxGRP.systemMSG
frame:SetWidth(size.systemMSG)
frame:SetLabel(L.interface["Выключить системные сообщения"])
frame:SetTooltip(L.interface.tooltip["Не отображать в чате системные сообщения"])
frame:SetDisabled(true)
fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.systemMSG = settingsCheckBoxGRP.systemMSG:GetValue()
end)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.sendMSG = GUI:Create("CheckBox")
local frame = settingsCheckBoxGRP.sendMSG
frame:SetWidth(size.sendMSG)
frame:SetLabel(L.interface["Выключить отправляемые сообщения"])
frame:SetTooltip(L.interface.tooltip["Не отображать в чате отправляемые сообщения"])
fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.sendMSG = settingsCheckBoxGRP.sendMSG:GetValue()
end)
settingsCheckBoxGRP:AddChild(frame)

settingsCheckBoxGRP.minimapButton = GUI:Create("CheckBox")
local frame = settingsCheckBoxGRP.minimapButton
frame:SetWidth(size.minimapButton)
frame:SetLabel(L.interface["Не отображать значок у миникарты"])
frame:SetTooltip("")
fontSize(frame.text)
frame.frame:HookScript("OnClick", function()
	DB.minimap.hide = settingsCheckBoxGRP.minimapButton:GetValue()
	if DB.minimap.hide then
		addon.icon:Hide("FGI")
	else
		addon.icon:Show("FGI")
	end
end)
settingsCheckBoxGRP:AddChild(frame)




settingsFrame.settingsButtonsGRP = GUI:Create("Frame")
local settingsButtonsGRP = settingsFrame.settingsButtonsGRP
settingsButtonsGRP:isGroupFrame(true)
settingsButtonsGRP:SetHeight(45)
settingsButtonsGRP:SetWidth(size.settingsButtonsGRP)
settingsFrame:AddChild(settingsButtonsGRP)

settingsButtonsGRP.filters = GUI:Create("Button")
local frame = settingsButtonsGRP.filters
frame:SetText(L.interface["Фильтры"])
fontSize(frame.text)
frame:SetWidth(size.filters)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	interface.filtersFrame:Show()
	fn:FiltersUpdate()
	settingsFrame:Hide()
end)
settingsButtonsGRP:AddChild(frame)

settingsButtonsGRP.keyBind = GUI:Create("Keybinding")
local frame = settingsButtonsGRP.keyBind
-- frame:SetLabel(format(L.interface["Назначить кнопку (%s)"], "none"))
frame:SetTooltip(L.interface.tooltip["Назначить клавишу для приглашения"])
fontSize(frame.label)
frame:SetWidth(size.keyBind)
frame:SetHeight(40)
frame:SetCallback("OnKeyChanged", function(self) fn:SetKeybind(self:GetKey()) end)
settingsButtonsGRP:AddChild(frame)

settingsButtonsGRP.setMSG = GUI:Create("Button")
local frame = settingsButtonsGRP.setMSG
frame:SetText(L.interface["Настроить сообщения"])
fontSize(frame.text)
frame:SetWidth(size.setMSG)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	interface.messageFrame:Show()
	settingsFrame:Hide()
end)
settingsButtonsGRP:AddChild(frame)





-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	settingsCheckBoxGRP.addonMSG:SetValue(DB.addonMSG or false)
	settingsCheckBoxGRP.systemMSG:SetValue(DB.systemMSG or false)
	settingsCheckBoxGRP.sendMSG:SetValue(DB.sendMSG or false)
	settingsCheckBoxGRP.minimapButton:SetValue(DB.minimap.hide or false)
	
	settingsFrame.closeButton:ClearAllPoints()
	settingsFrame.closeButton:SetPoint("CENTER", settingsFrame.frame, "TOPRIGHT", -8, -8)
	
	settingsCheckBoxGRP:ClearAllPoints()
	settingsCheckBoxGRP:SetPoint("TOPLEFT", settingsFrame.frame, "TOPLEFT", 20, -25)
	
	settingsCheckBoxGRP.addonMSG:ClearAllPoints()
	settingsCheckBoxGRP.addonMSG:SetPoint("TOPLEFT", settingsCheckBoxGRP.frame, "TOPLEFT", 0, 0)
	
	settingsButtonsGRP:ClearAllPoints()
	settingsButtonsGRP:SetPoint("TOPLEFT", settingsCheckBoxGRP.frame, "BOTTOMLEFT", 0, -10)
	
	settingsButtonsGRP.filters:ClearAllPoints()
	settingsButtonsGRP.filters:SetPoint("TOPLEFT", settingsButtonsGRP.frame, "TOPLEFT", 0, 0)
	
	settingsButtonsGRP.keyBind:ClearAllPoints()
	settingsButtonsGRP.keyBind:SetPoint("LEFT", settingsButtonsGRP.filters.frame, "RIGHT", 2, 0)
	
	settingsButtonsGRP.setMSG:ClearAllPoints()
	settingsButtonsGRP.setMSG:SetPoint("LEFT", settingsButtonsGRP.keyBind.frame, "RIGHT", 2, 0)
	
	settingsFrame:Hide()
end)