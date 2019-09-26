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
	-- self:SetFont(font, size)
end

local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

local chooseInvites

do		--	chooseInvites
interface.chooseInvites = GUI:Create("ClearFrame")
chooseInvites = interface.chooseInvites
-- chooseInvites:Hide()
chooseInvites:SetTitle("FGI Choose Invites")
chooseInvites:SetWidth(size.chooseInvitesW)
chooseInvites:SetHeight(size.chooseInvitesH)

chooseInvites.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = chooseInvites.frame:GetPoint(1)
	DB.chooseInvites = {}
	DB.chooseInvites.point=point
	DB.chooseInvites.relativeTo=relativeTo
	DB.chooseInvites.relativePoint=relativePoint
	DB.chooseInvites.xOfs=xOfs
	DB.chooseInvites.yOfs=yOfs
end)

chooseInvites.closeButton = GUI:Create('Button')
local frame = chooseInvites.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.chooseInvites:Hide()
end)
chooseInvites:AddChild(frame)





chooseInvites.player = GUI:Create("Label")
local frame = chooseInvites.player
fontSize(frame.label)
frame:SetWidth(chooseInvites.frame:GetWidth()-30)
frame.label:SetJustifyH("CENTER")
chooseInvites:AddChild(frame)

chooseInvites.invite = GUI:Create("Button")
local frame = chooseInvites.invite
frame:SetText(L.interface["Пригласить"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.invite)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	fn:invitePlayer()
end)
chooseInvites:AddChild(frame)

chooseInvites.reject = GUI:Create("Button")
local frame = chooseInvites.reject
frame:SetText(L.interface["Отклонить"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.reject)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	fn:invitePlayer(true)
end)
chooseInvites:AddChild(frame)
end




-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	C_Timer.After(0.1, function()
	chooseInvites.closeButton:ClearAllPoints()
	chooseInvites.closeButton:SetPoint("CENTER", chooseInvites.frame, "TOPRIGHT", -8, -8)
	
	chooseInvites.player:ClearAllPoints()
	chooseInvites.player:SetPoint("TOP", chooseInvites.frame, "TOP", 0, -25)
	
	chooseInvites.invite:ClearAllPoints()
	chooseInvites.invite:SetPoint("TOP", chooseInvites.player.frame, "BOTTOM", -(size.invite/2), -5)
	
	chooseInvites.reject:ClearAllPoints()
	chooseInvites.reject:SetPoint("LEFT", chooseInvites.invite.frame, "RIGHT", 5, 0)
	
	chooseInvites:Hide()
	end)
end)
