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

local blackList, scrollBar

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
blackList = interface.blackList
-- blackList:Hide()
blackList:SetTitle("FGI Blacklist")
blackList:SetWidth(size.blackListW)
blackList:SetHeight(size.blackListH)
blackList:SetLayout("Flow")

function blackList:updateList()
	local str = ''
	for k,v in pairs(DB.blackList) do
		str = format("%s%s\n", str, k)
	end
	blackList.list:SetText(str)
end

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

blackList.scrollBar = GUI:Create("ScrollFrame")
scrollBar = blackList.scrollBar
scrollBar:SetFullWidth(true)
scrollBar:SetFullWidth(true)
-- scrollBar:SetWidth(blackList.frame:GetWidth()-20)
-- scrollBar:SetHeight(blackList.frame:GetHeight()-40)
scrollBar:SetLayout("Flow")
blackList:AddChild(scrollBar)

blackList.closeButton = GUI:Create('Button')
local frame = blackList.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.blackList:Hide()
end)
blackList:AddChild(frame)

scrollBar.items = {}

StaticPopupDialogs["FGI_BLACKLIST_CHANGE"] = {
	text = 'Reason',
	button1 = "Ok",
	button2 = "Cancel",
	OnAccept = function(self, data)
		local text = self.editBox:GetText()
		DB.blackList[data.name] = text
		data.frame.r:SetText(text)
		data.frame.r:SetTooltip(text)
		StaticPopup_Hide("FGI_BLACKLIST_CHANGE")
		blackList:update()
		return true
	end,
	OnShow = function(self, data)
		self.text:SetText("Reason "..data.name)
		self.editBox:SetText(tostring(DB.blackList[data.name]))
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	hasEditBox = true
}


local function AddHookClick(frame, parent)
	local menu = {
		{text = "Select an Option", isTitle = true},
		{text = "Change", func = function()
			StaticPopup_Show("FGI_BLACKLIST_CHANGE", _,_,  {name = frame.label:GetText(), frame = parent})
		end},
		{text = "Delete", func = function()
			DB.blackList[frame.label:GetText()] = nil
			blackList:update()
		end},
		--[[{ text = "More Options", hasArrow = true,
			menuList = {
				{ text = "Option 3", func = function() print("You've chosen option 3"); end }
			} 
		}]]
	}
	local menuFrame = CreateFrame("Frame", "ExampleMenuFrame", UIParent, "UIDropDownMenuTemplate")
	frame.frame:HookScript("OnMouseDown",function(self, button,...)
		if button == "RightButton" then
			EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
		end
	end)
end
local help = "RBM - change\nRBM - change"
function blackList:add(data)
	scrollBar.items[#scrollBar.items+1] = GUI:Create("SimpleGroup")
	local frame = scrollBar.items[#scrollBar.items]
	frame:SetFullWidth(true)
	frame:SetLayout("Flow")
	frame.n = GUI:Create("TLabel")
		frame.n:SetText(data.name)
		frame.n:SetWidth(90)
		frame.n:SetHeight(20)
		frame.n:SetTooltip(help)
		AddHookClick(frame.n, frame)
	frame:AddChild(frame.n)
	frame.r = GUI:Create("TLabel")
		frame.r:SetText(data.reason)
		frame.r:SetHeight(20)
		frame.r:SetTooltip(data.reason)
	frame:AddChild(frame.r)
	frame:SetHeight(frame.n.frame:GetHeight())
	scrollBar:AddChild(frame)
end

function blackList:update()
	local i=1
	for k,v in pairs(DB.blackList) do
		local f = scrollBar.items[i]
		f.n:SetText(k)
		f.r:SetText(tostring(v))
		i = i+1
	end
	for i=i, #scrollBar.items do
		scrollBar.items[i].frame:Hide()
	end
end

--[[blackList.list = GUI:Create("MultiLineEditBox")
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

]]

local function showNext()
	local data = StaticPopupDialogs["FGI_BLACKLIST"].data
	if not data[1] then return end
	StaticPopupDialogs["FGI_BLACKLIST"].text = format(L.interface["Игрок %s найденный в черном списке, находится в вашей гильдии!"],data[1])
	StaticPopup_Show("FGI_BLACKLIST")
end
StaticPopupDialogs["FGI_BLACKLIST"] = {
	text = '',
	button1 = "Ok",
	data = {},
	data2 = {},
	OnAccept = function()
		local data = StaticPopupDialogs["FGI_BLACKLIST"].data
		StaticPopupDialogs["FGI_BLACKLIST"].data2[data[1] ] = true
		table.remove(data, 1)
		StaticPopup_Hide("FGI_BLACKLIST")
		showNext()
		return true
	end,
	add = function(name)
		local data = StaticPopupDialogs["FGI_BLACKLIST"].data
		if not StaticPopupDialogs["FGI_BLACKLIST"].data2[name] then table.insert(data, name) end
		showNext()
	end,
	OnShow = function()
		local data = StaticPopupDialogs["FGI_BLACKLIST"].data
		if not data[1] then return end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 3,
}

-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	
	blackList.closeButton:ClearAllPoints()
	blackList.closeButton:SetPoint("CENTER", blackList.frame, "TOPRIGHT", -8, -8)
	
	for k,v in pairs(DB.blackList) do
		blackList:add({name=tostring(k),reason=tostring(v)})
	end
	
	
	blackList:Hide()
end)
