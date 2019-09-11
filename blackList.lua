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

interface.blackList = GUI:Create("ClearFrame")
local blackList = interface.blackList
blackList:Hide()
blackList:SetTitle("FGI Black List")
blackList:SetWidth(size.blackListW)
blackList:SetHeight(size.blackListH)
blackList:SetLayout("Flow")

blackList.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = blackList.frame:GetPoint(1)
	DB.blackListPos = {}
	DB.blackListPos.point=point
	DB.blackListPos.relativeTo=relativeTo
	DB.blackListPos.relativePoint=relativePoint
	DB.blackListPos.xOfs=xOfs
	DB.blackListPos.yOfs=yOfs
end)

blackList.closeButton = GUI:Create('Button')
local frame = blackList.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.blackList:Hide()
end)
blackList:AddChild(frame)

function blackList:updateList()
	local str = ''
	for k,v in pairs(DB.blackList) do
		str = format("%s%s\n", str, v)
	end
	blackList.list:SetText(str)
end

blackList.list = GUI:Create("MultiLineEditBox")
local frame = blackList.list
frame:SetLabel("")
frame:SetWidth(size.blackListW-40)
frame:DisableButton(true)
blackList:AddChild(frame)
frame:SetHeight(size.blackListH-60-40)



blackList.saveButton = GUI:Create("Button")
local frame = blackList.saveButton
frame:SetText(L.interface["Сохранить"])
fontSize(frame.text)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	DB.blackList = {}
	for k,v in pairs(table.pack(fn:split(blackList.list:GetText(),"\n"))) do
		if v~="" then
			table.insert(DB.blackList,v)
		end
	end
end)
blackList:AddChild(frame)


blackList.frame:HookScript("OnShow", function()
	blackList:updateList()
end)


-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	blackList:Show()
	
	blackList.closeButton:ClearAllPoints()
	blackList.closeButton:SetPoint("CENTER", blackList.frame, "TOPRIGHT", -8, -8)
	
	blackList.list:ClearAllPoints()
	blackList.list:SetPoint("TOP", blackList.frame, "TOP", 0, -30)
	
	blackList.saveButton:ClearAllPoints()
	blackList.saveButton:SetPoint("BOTTOM", blackList.frame, "BOTTOM", 0, 10)
	
	blackList:Hide()
	frame:UnregisterEvent('PLAYER_ENTERING_WORLD')
end)