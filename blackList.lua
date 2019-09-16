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

-- format("Player %s was found in blacklist. Do you want kick %s from guild?", name, name)
-- format("FGI autoKick: Player %s has been kicked.", name)

interface.blackList = GUI:Create("ClearFrame")
local blackList = interface.blackList
blackList:Hide()
blackList:SetTitle("FGI Blacklist")
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
		str = format("%s%s\n", str, k)
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
btnText(frame)
frame:SetWidth(size.saveButton)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	DB.blackList = {}
	for k,v in pairs(table.pack(fn:split(blackList.list:GetText(),"\n"))) do
		if v~="" then
			DB.blackList[v] = true
		end
	end
	interface.blackList:Hide()
end)
blackList:AddChild(frame)


blackList.frame:HookScript("OnShow", function()
	blackList:updateList()
end)









--[[interface.uninvite = GUI:Create("ClearFrame")
local uninvite = interface.uninvite
uninvite:Hide()
uninvite:SetTitle("FGI Blacklist UnInvite")
uninvite:SetWidth(size.uninviteW)
uninvite:SetHeight(size.uninviteH)
uninvite:SetLayout("Flow")
uninvite.list = {}

uninvite.kickLabel = GUI:Create("TLabel")
local frame = uninvite.kickLabel
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
uninvite:AddChild(frame)]]

--[[
local frame = CreateFrame("Button", "TestKick", UIParent, "SecureActionButtonTemplate")
frame:SetHeight(40)
frame:SetWidth(100)
frame:SetPoint("TOP")
frame:SetAttribute("type", "macro")
frame:SetAttribute("macrotext", "/guildremove Knoot")
frame.text = frame:CreateFontString(nil, "OVERLAY")
frame.text:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
frame.text:SetPoint("CENTER")
frame.text:SetText("Yes!")]]



--[[local SecureKick = CreateFrame("Button", "FGISecureKick", UIParent, "SecureActionButtonTemplate")
local frame = SecureKick
frame:SetHeight(40)
frame:SetWidth(100)
frame:SetPoint("CENTER")
frame:SetAttribute("type", "macro")
frame:SetAttribute("macrotext", "/guildremove Knoot")
frame.text = frame:CreateFontString(nil, "OVERLAY")
frame.text:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
frame.text:SetPoint("CENTER")
frame.text:SetText("Yes")

function uninvite:listChange()
	if #uninvite.list == 0 then return interface.uninvite:Hide() else interface.uninvite:Show() end
	local name = uninvite.list[1]
	uninvite.kickLabel:SetText(format(L.interface["Игрок %s был найден в черном списке. Исключить игрока %s из гильдии?"], name, name))
	-- uninvite.SecureKick:SetAttribute("macrotext", format("/guildremove %s\n/run FGI.interface.uninvite:remove()", name))
end

function uninvite:add(name)
	if not name then return end
	table.insert(uninvite.list, name)
	uninvite:listChange()
end

function uninvite:remove()
	table.remove(uninvite.list, 1)
	uninvite:listChange()
end


uninvite.cancel = GUI:Create("Button")
local frame = uninvite.cancel
frame:SetText(L.interface["Нет"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.no)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	uninvite:remove()
end)
uninvite:AddChild(frame)]]


StaticPopupDialogs["FGI_BLACKLIST"] = {
	text = '',
	button1 = "Ok",
	list = {},
	OnAccept = function()
		local list = StaticPopupDialogs["FGI_BLACKLIST"].list
		table.remove(list, 1)
		StaticPopup_Hide("FGI_BLACKLIST")
	end,
	add = function(name)
		print(name)
		local list = StaticPopupDialogs["FGI_BLACKLIST"].list
		table.insert(list, name)
		StaticPopup_Show("FGI_BLACKLIST")
	end,
	OnShow = function()
		local list = StaticPopupDialogs["FGI_BLACKLIST"].list
		if not list[1] then return end
		StaticPopupDialogs["FGI_BLACKLIST"].text = (format(L.interface["Игрок %s найденный в черном списке, находится в вашей гильдии!"],list[1]))
	end,
	OnHide = function()
		local list = StaticPopupDialogs["FGI_BLACKLIST"].list
		if not list[1] then return end
		StaticPopup_Show("FGI_BLACKLIST")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 3,
}

-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	blackList:Show()
C_Timer.NewTicker(0.1,function()
	
	blackList.closeButton:ClearAllPoints()
	blackList.closeButton:SetPoint("CENTER", blackList.frame, "TOPRIGHT", -8, -8)
	
	blackList.list:ClearAllPoints()
	blackList.list:SetPoint("TOP", blackList.frame, "TOP", 0, -30)
	
	blackList.saveButton:ClearAllPoints()
	blackList.saveButton:SetPoint("BOTTOM", blackList.frame, "BOTTOM", 0, 10)
	
	
	blackList:Hide()
end,2)
	frame:UnregisterEvent('PLAYER_ENTERING_WORLD')
end)