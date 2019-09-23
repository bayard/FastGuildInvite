local addon = FGI
local fn = addon.functions
local L = addon.L
local settings = L.settings
local size = settings.size
local color = addon.color
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local FastGuildInvite = addon.lib
local DB

local function fontSize(self, font, size)
	font = font or settings.Font
	size = size or settings.FontSize
	self:SetFont(font, size)
end

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

interface.customList = GUI:Create("ClearFrame")
local customList = interface.customList
-- customList:Hide()
customList:SetTitle("FGI Custom Who List")
customList:SetWidth(size.customListW)
customList:SetHeight(size.customListH)
customList:SetLayout("Flow")

customList.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = customList.frame:GetPoint(1)
	DB.customListPos = {}
	DB.customListPos.point=point
	DB.customListPos.relativeTo=relativeTo
	DB.customListPos.relativePoint=relativePoint
	DB.customListPos.xOfs=xOfs
	DB.customListPos.yOfs=yOfs
end)

customList.closeButton = GUI:Create('Button')
local frame = customList.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.customList:Hide()
end)
customList:AddChild(frame)

customList.list = GUI:Create("MultiLineEditBox")
local frame = customList.list
frame:SetLabel("")
frame:SetWidth(size.customListW-40)
frame:DisableButton(true)
customList:AddChild(frame)
frame:SetHeight(size.customListH-60-40)



customList.saveButton = GUI:Create("Button")
local frame = customList.saveButton
frame:SetText(L.interface["Сохранить"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	DB.customWhoList = {}
	for k,v in pairs(table.pack(fn:split(customList.list:GetText(),"\n"))) do
		if v~="" then
			table.insert(DB.customWhoList, v)
		end
	end
	interface.customList:Hide()
end)
customList:AddChild(frame)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	local str = ''
	for i=1,#DB.customWhoList do
		str = format("%s%s\n", str, DB.customWhoList[i])
		customList.list:SetText(str)
	end
	
	customList.closeButton:ClearAllPoints()
	customList.closeButton:SetPoint("CENTER", customList.frame, "TOPRIGHT", -8, -8)
	
	customList.list:ClearAllPoints()
	customList.list:SetPoint("TOP", customList.frame, "TOP", 0, -30)
	
	customList.saveButton:ClearAllPoints()
	customList.saveButton:SetPoint("BOTTOM", customList.frame, "BOTTOM", 0, 10)
	
	
	customList:Hide()
end)
