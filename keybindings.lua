local addon = FGI
local fn = addon.functions
local L = addon.L
local settings = L.settings
local size = settings.size
local color = addon.color
local interface = addon.interface
-- local GUI = LibStub("AceKGUI-3.0")
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB

local function fontSize(self, font, size)
	font = font or settings.Font
	size = size or settings.FontSize
	self:SetFont(font, size)
end

interface.keyBindings = GUI:Create("ClearFrame")
local keyBindings = interface.keyBindings
-- keyBindings:Hide()
keyBindings:SetTitle("FGI key bindings")
keyBindings:SetWidth(size.keyBindingsW)
keyBindings:SetHeight(size.keyBindingsH)
keyBindings:SetLayout("List")

keyBindings.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = keyBindings.frame:GetPoint(1)
	DB.keyBindings = {}
	DB.keyBindings.point=point
	DB.keyBindings.relativeTo=relativeTo
	DB.keyBindings.relativePoint=relativePoint
	DB.keyBindings.xOfs=xOfs
	DB.keyBindings.yOfs=yOfs
end)

keyBindings.closeButton = GUI:Create('Button')
local frame = keyBindings.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.keyBindings:Hide()
end)
keyBindings:AddChild(frame)





keyBindings.buttonsGRP = GUI:Create("GroupFrame")
local buttonsGRP = keyBindings.buttonsGRP
buttonsGRP:SetHeight(45)
buttonsGRP:SetWidth(keyBindings.frame:GetWidth()-20)
keyBindings:AddChild(buttonsGRP)

buttonsGRP.keyBind = {}
buttonsGRP.keyBind.invite = GUI:Create("TKeybinding")
local frame = buttonsGRP.keyBind.invite
-- frame:SetTooltip(L.interface.tooltip["Назначить клавишу для приглашения"])
fontSize(frame.label)
frame:SetWidth(size.keyBind)
frame:SetHeight(40)
frame:SetCallback("OnKeyChanged", function(self) fn:SetKeybind(self:GetKey(), "invite") end)
buttonsGRP:AddChild(frame)

buttonsGRP.inviteLabel = GUI:Create("TLabel")
local frame = buttonsGRP.inviteLabel
frame:SetText(L.interface.tooltip["Назначить клавишу для приглашения"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(size.keyBind)
buttonsGRP:AddChild(frame)

buttonsGRP.keyBind.nextSearch = GUI:Create("TKeybinding")
local frame = buttonsGRP.keyBind.nextSearch
-- frame:SetTooltip(L.interface.tooltip["Назначить клавишу следующего поиска"])
fontSize(frame.label)
frame:SetWidth(size.keyBind-10)
frame:SetHeight(40)
frame:SetCallback("OnKeyChanged", function(self) fn:SetKeybind(self:GetKey(), "nextSearch") end)
buttonsGRP:AddChild(frame)

buttonsGRP.nextSearchLabel = GUI:Create("TLabel")
local frame = buttonsGRP.nextSearchLabel
frame:SetText(L.interface.tooltip["Назначить клавишу следующего поиска"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(size.keyBind)
buttonsGRP:AddChild(frame)





-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	keyBindings.closeButton:ClearAllPoints()
	keyBindings.closeButton:SetPoint("CENTER", keyBindings.frame, "TOPRIGHT", -8, -8)
	
	buttonsGRP:ClearAllPoints()
	buttonsGRP:SetPoint("BOTTOM", keyBindings.frame, "BOTTOM", 0, 12)
	
	buttonsGRP.keyBind.invite:ClearAllPoints()
	buttonsGRP.keyBind.invite:SetPoint("BOTTOMLEFT", buttonsGRP.frame, "BOTTOMLEFT", 2, 0)
	
	buttonsGRP.inviteLabel:ClearAllPoints()
	buttonsGRP.inviteLabel:SetPoint("BOTTOM", buttonsGRP.keyBind.invite.frame, "TOP", 0, 20)
	
	buttonsGRP.keyBind.nextSearch:ClearAllPoints()
	buttonsGRP.keyBind.nextSearch:SetPoint("LEFT", buttonsGRP.keyBind.invite.frame, "RIGHT", 2, 0)
	
	buttonsGRP.nextSearchLabel:ClearAllPoints()
	buttonsGRP.nextSearchLabel:SetPoint("BOTTOM", buttonsGRP.keyBind.nextSearch.frame, "TOP", 0, 20)
	
	keyBindings:Hide()
end)
