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
local fontSize = fn.fontSize

local synch, leftColumn, rightColumn


local function btnText(frame)
	local text = frame.text
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
end

interface.synch = GUI:Create("ClearFrame")
synch = interface.synch
synch:SetTitle("FGI Synchronization")
synch:SetWidth(size.synchFrameW)
synch:SetHeight(size.synchFrameH)
synch:SetLayout("Flow")

synch.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.DB
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = synch.frame:GetPoint(1)
	DB.synchPos = {}
	DB.synchPos.point=point
	DB.synchPos.relativeTo=relativeTo
	DB.synchPos.relativePoint=relativePoint
	DB.synchPos.xOfs=xOfs
	DB.synchPos.yOfs=yOfs
end)

synch.closeButton = GUI:Create('Button')
local frame = synch.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
	interface.synch:Hide()
end)
synch:AddChild(frame)

do		-- left col
synch.leftColumn = GUI:Create("SimpleGroup")
leftColumn = synch.leftColumn
leftColumn:SetWidth((size.synchFrameW-20)/2)
leftColumn:SetHeight(100)
leftColumn:SetLayout("List")
synch:AddChild(leftColumn)

leftColumn.synchTypeLabel = GUI:Create("TLabel")
local frame = leftColumn.synchTypeLabel
frame:SetText(L.interface["Данные для синхронизации"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(leftColumn.frame:GetWidth()-20)
leftColumn:AddChild(frame)

leftColumn.synchTypeDrop = GUI:Create("Dropdown")
local frame = leftColumn.synchTypeDrop
frame:SetWidth(leftColumn.frame:GetWidth()-20)
frame:SetList({L.interface.synchType[1], L.interface.synchType[2],})
frame:SetValue(1)
leftColumn:AddChild(frame)
end

do		--right col
synch.rightColumn = GUI:Create("SimpleGroup")
rightColumn = synch.rightColumn
rightColumn:SetWidth((size.synchFrameW-20)/2)
rightColumn:SetHeight(100)
rightColumn:SetLayout("List")
synch:AddChild(rightColumn)

rightColumn.synchPlayerReadyLabel = GUI:Create("TLabel")
local frame = rightColumn.synchPlayerReadyLabel
frame:SetText(L.interface["Игрок для синхронизации"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(rightColumn.frame:GetWidth()-20)
rightColumn:AddChild(frame)

rightColumn.synchPlayerReadyDrop = GUI:Create("Dropdown")
local frame = rightColumn.synchPlayerReadyDrop
frame:SetWidth(rightColumn.frame:GetWidth()-20)
frame:SetList({L.interface["Все"]})
frame:SetValue(1)
rightColumn:AddChild(frame)
end

synch.infoLabel = GUI:Create("TLabel")
local frame = synch.infoLabel
frame:SetText(L.interface["Отправить запрос"])
fontSize(frame.label)
frame.label:SetJustifyH("CENTER")
frame:SetWidth(synch.frame:GetWidth()-20)
synch:AddChild(frame)

function frame.Error(self, text)
	self:SetText(format("%s%s|r",color.red, text))
end
function frame.During(self, text)
	self:SetText(format("%s%s|r",color.yellow, text))
end
function frame.Success(self, text)
	self:SetText(format("%s%s|r",color.green, text))
end


synch.sendRequest = GUI:Create("Button")
local frame = synch.sendRequest
frame:SetText(L.interface["Отправить запрос"])
fontSize(frame.text)
btnText(frame)
frame:SetWidth(size.sendRequest)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	synch.infoLabel:SetText('')
	-- local type = leftColumn.synchTypeDrop.list[leftColumn.synchTypeDrop:GetValue()]
	local type = leftColumn.synchTypeDrop:GetValue()
	local player = rightColumn.synchPlayerReadyDrop--:GetValue()==1 and (not true) or rightColumn.synchPlayerReadyDrop.list[rightColumn.synchPlayerReadyDrop:GetValue()]
	local playerName = player.list[player:GetValue()]
	if type == nil or L.interface.synchType[type] == nil then
		synch.infoLabel:Error(L.interface.synchState["Данные для синхронизации не выбраны"])
		return
	end
	if player == nil then
		synch.infoLabel:Error(L.interface.synchState["Игрок для синхронизации не выбран"])
		return
	end
	synch.infoLabel:During(format(L.interface.synchState["Запрос синхронизации у: %s. %d"], playerName, FGI_MAXSYNCHWAIT))
	
	fn:sendSynchRequest(playerName, type)
end)
synch:AddChild(frame)



-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	DB = addon.DB
	if DB.synchPos then
		interface.synch:ClearAllPoints()
		interface.synch:SetPoint(DB.synchPos.point, UIParent, DB.synchPos.relativePoint, DB.synchPos.xOfs, DB.synchPos.yOfs)
	else
		interface.synch:SetPoint("CENTER", UIParent)
	end
	
	
	C_Timer.After(0.1, function()
	synch.closeButton:ClearAllPoints()
	synch.closeButton:SetPoint("CENTER", synch.frame, "TOPRIGHT", -8, -8)
	
	synch.leftColumn:ClearAllPoints()
	synch.leftColumn:SetPoint("TOPLEFT", synch.frame, "TOPLEFT", 10, -30)
	
	synch.rightColumn:ClearAllPoints()
	synch.rightColumn:SetPoint("TOPRIGHT", synch.frame, "TOPRIGHT", -10, -30)
	
	synch.sendRequest:ClearAllPoints()
	synch.sendRequest:SetPoint("BOTTOM", synch.frame, "BOTTOM", 0, 10)
	
	
	synch:Hide()
	end)
end)
