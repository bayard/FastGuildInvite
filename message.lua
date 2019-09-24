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

local function defaultValues()
	local messageFrame = interface.messageFrame
	messageFrame.drop:SetList(DB.messageList)
	messageFrame.drop:SetValue(DB.curMessage)
	messageFrame.message:SetText(DB.messageList[DB.curMessage] or "")
	local msg = DB.messageList[DB.curMessage]
	if msg then msg = fn:msgMod(msg) end
	messageFrame.curMessage:SetText(format(L.interface["Текущее сообщение: %s"], msg or L.interface["Нет"]))
end

local function overLen(msg)
	local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player")
	msg = msg:gsub("NAME", format("<%s>",guildName or 'GUILD_NAME'))
	if msg:len()>255 then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		message(format(L.FAQ.error["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"], msg:len()-255))
		return true
	end
	return false
end

local function EditBoxChange(frame)
	frame.editbox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		self.lasttext = self:GetText()
	end)
	frame.editbox:SetScript("OnEnter", function(self)
		self.lasttext = self:GetText()
	end)
	frame.editbox:SetScript("OnEscapePressed", function(self)
		self:SetText(self.lasttext or "")
		self:ClearFocus()
	end)
end

interface.messageFrame = GUI:Create("ClearFrame")
local messageFrame = interface.messageFrame
messageFrame:SetTitle("FGI Message")
messageFrame:SetWidth(size.messageFrameW)
messageFrame:SetHeight(size.messageFrameH)

messageFrame.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = messageFrame.frame:GetPoint(1)
	DB.messageFrame = {}
	DB.messageFrame.point=point
	DB.messageFrame.relativeTo=relativeTo
	DB.messageFrame.relativePoint=relativePoint
	DB.messageFrame.xOfs=xOfs
	DB.messageFrame.yOfs=yOfs
end)

messageFrame.closeButton = GUI:Create('Button')
local frame = messageFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.messageFrame:Hide()
	interface.settingsFrame:Show()
end)
messageFrame:AddChild(frame)





messageFrame.intro = GUI:Create("TLabel")
local frame = messageFrame.intro
frame:SetText(L.interface["Слово NAME заглавными буквами будет заменено на название вашей гильдии."])
fontSize(frame.label)
frame:SetWidth(messageFrame.frame:GetWidth()-30)
frame.label:SetJustifyH("CENTER")
messageFrame:AddChild(frame)

messageFrame.drop = GUI:Create("Dropdown")
local frame = messageFrame.drop
frame:SetWidth(messageFrame.frame:GetWidth()-30)
frame:SetCallback("OnValueChanged", function(key)
	messageFrame.message:SetText(DB.messageList[messageFrame.drop:GetValue()] or "")
end)
messageFrame:AddChild(frame)

messageFrame.message = GUI:Create("EditBox")
local frame = messageFrame.message
frame:SetWidth(messageFrame.frame:GetWidth()-30)
frame:SetMaxLetters(255)
EditBoxChange(frame)
messageFrame:AddChild(frame)

messageFrame.save = GUI:Create("Button")
local frame = messageFrame.save
frame:SetText(L.interface["Сохранить"])
fontSize(frame.text)
frame:SetWidth(size.save)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = messageFrame.message:GetText()
	if msg == "" then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L.FAQ.error["Нельзя сохранить пустое сообщение"])
	else
		if overLen(msg) then return end
		
		DB.messageList[messageFrame.drop:GetValue()] = msg
		DB.curMessage = messageFrame.drop:GetValue()
		defaultValues()
	end
end)
messageFrame:AddChild(frame)

messageFrame.add = GUI:Create("Button")
local frame = messageFrame.add
frame:SetText(L.interface["Добавить"])
fontSize(frame.text)
frame:SetWidth(size.add)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = messageFrame.message:GetText()
	if msg == "" then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L.FAQ.error["Нельзя добавить пустое сообщение"])
	else
		table.insert(DB.messageList, msg)
		DB.curMessage = #DB.messageList
		defaultValues()
	end
end)
messageFrame:AddChild(frame)

messageFrame.delete = GUI:Create("Button")
local frame = messageFrame.delete
frame:SetText(L.interface["Удалить"])
fontSize(frame.text)
frame:SetWidth(size.delete)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	local msg = messageFrame.drop:GetValue()
	if DB.messageList[msg] == nil then
		BasicMessageDialog:SetFrameStrata("TOOLTIP")
		return message(L.FAQ.error["Выберите сообщение"])
	else
		if DB.curMessage == msg then
			DB.curMessage = 0
		elseif DB.curMessage > msg then
			DB.curMessage = DB.curMessage - 1
		end
		table.remove(DB.messageList, msg)
		defaultValues()
	end
end)
messageFrame:AddChild(frame)

messageFrame.curMessage = GUI:Create("TLabel")
local frame = messageFrame.curMessage
--frame:SetText(format(L.interface["Текущее сообщение: %s"], L.interface["Нет"]))
fontSize(frame.label)
frame:SetWidth(messageFrame.frame:GetWidth()-30)
frame.label:SetJustifyH("CENTER")
messageFrame:AddChild(frame)




messageFrame.frame:HookScript("OnShow", defaultValues)




-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	if DB.messageFrame then
		interface.messageFrame:ClearAllPoints()
		interface.messageFrame:SetPoint(DB.messageFrame.point, UIParent, DB.messageFrame.relativePoint, DB.messageFrame.xOfs, DB.messageFrame.yOfs)
	else
		interface.messageFrame:SetPoint("CENTER", UIParent)
	end
	
	defaultValues()
	C_Timer.After(0.1, function()
	messageFrame.closeButton:ClearAllPoints()
	messageFrame.closeButton:SetPoint("CENTER", messageFrame.frame, "TOPRIGHT", -8, -8)
	
	messageFrame.intro:ClearAllPoints()
	messageFrame.intro:SetPoint("TOP", messageFrame.frame, "TOP", 0, -20)
	
	messageFrame.add:ClearAllPoints()
	messageFrame.add:SetPoint("TOP", messageFrame.message.frame, "BOTTOM", 0, -5)
	
	messageFrame.save:ClearAllPoints()
	messageFrame.save:SetPoint("RIGHT", messageFrame.add.frame, "LEFT", -5, 0)
	
	messageFrame.delete:ClearAllPoints()
	messageFrame.delete:SetPoint("LEFT", messageFrame.add.frame, "RIGHT", 5, 0)
	
	messageFrame.curMessage:ClearAllPoints()
	messageFrame.curMessage:SetPoint("BOTTOM", messageFrame.frame, "BOTTOM", 0, 20)
	
	messageFrame:Hide()
	end)
end)
