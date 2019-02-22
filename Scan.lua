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

local function playerHaveInvite(msg)
	place = strfind(ERR_GUILD_PLAYER_NOT_FOUND_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-2)
		if format(ERR_GUILD_PLAYER_NOT_FOUND_S,name) == msg then
			return false, name
		end
	end
	
	place = strfind(ERR_CHAT_PLAYER_NOT_FOUND_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-2)
		if format(ERR_CHAT_PLAYER_NOT_FOUND_S,name) == msg then
			return false, name
		end
	end
	
	return true
end


interface.scanFrame = GUI:Create("Frame")
local scanFrame = interface.scanFrame
scanFrame:Hide()
scanFrame:SetTitle("FGI Scan")
scanFrame:clearFrame(true)
scanFrame:SetWidth(size.scanFrameW)
scanFrame:SetHeight(size.scanFrameH)
scanFrame.title:SetScript('OnMouseUp', function(mover)
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = scanFrame.frame:GetPoint(1)
	DB.scanFrame = {}
	DB.scanFrame.point=point
	DB.scanFrame.relativeTo=relativeTo
	DB.scanFrame.relativePoint=relativePoint
	DB.scanFrame.xOfs=xOfs
	DB.scanFrame.yOfs=yOfs
end)

scanFrame.closeButton = GUI:Create('Button')
local frame = scanFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
frame:SetCallback('OnClick', function()
	interface.scanFrame:Hide()
end)
scanFrame:AddChild(frame)


local function SetProgress(self, cur)
	local function modTime(time)
		--[[if time<60 then return time end
		local min, sec = math.floor(time/60), math.fmod(time, 60)
		sec = sec<10 and "0"..sec or sec
		return format("%u:%s", min, sec)]]
		return SecondsToTime(time)
	end
	cur = (cur or 70) - self.progressTexture.min
	local max = self.progressTexture.max - self.progressTexture.min
	local percent = math.round(math.progress(max, cur))/100
	self.progressTexture:SetWidth((self.frame:GetWidth()-10)*percent)
	
	local time = modTime(math.round(max - cur))
	self.statustext:SetText(self.statustext.placeholder:format(math.floor(percent*100), (max - cur)<=0 and "<1" or time))
end

scanFrame.progressBar = GUI:Create("ProgressBar")
local frame = scanFrame.progressBar
frame.SetProgress = SetProgress
frame:SetPlaceholder("%s%% %s")
fontSize(frame.statustext)
frame:SetWidth(scanFrame.frame:GetWidth()-20)
frame:SetHeight(30)
--frame:SetMinMax(GetTime(),GetTime()+200)
scanFrame:AddChild(frame)
--frame:SetProgress(GetTime()+180)




scanFrame.invite = GUI:Create("Button")
local frame = scanFrame.invite
frame:SetText(format(L["Пригласить: %u"],0))
frame:SetWidth(size.inviteBTN)
frame:SetHeight(40)
frame:SetCallback("OnClick", function(self)
	fn:invitePlayer()
end)
scanFrame:AddChild(frame)


scanFrame.pausePlayFilter = CreateFrame("Frame")
local frame = scanFrame.pausePlayFilter
frame:SetScript("OnEvent", function(_,_,msg)
	local inv, name = playerHaveInvite(msg)
	if not inv then
		DB.alredySended[name] = nil
	end
end)

scanFrame.pausePlay = GUI:Create("Button")
local frame = scanFrame.pausePlay
frame:SetWidth(38)
frame:SetHeight(40)
frame.frame.pause = true
frame.frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
frame:SetCallback("OnClick", function(self)
	if not fn:inGuildCanInvite() then return print(L.error["Вы не состоите в гильдии или у вас нет прав для приглашения."]) end
	self = self.frame
	if self.pause then
		self:SetNormalTexture("Interface\\TimeManager\\PauseButton")
		LibDBIcon10_FGI.icon:SetTexture("Interface\\AddOns\\FastGuildInvite\\img\\minimap\\MiniMapButton-Search")
		self.pause = false
		fn:StartSearch()
		scanFrame.pausePlayFilter:RegisterEvent("CHAT_MSG_SYSTEM")
	else
		self:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
		LibDBIcon10_FGI.icon:SetTexture("Interface\\AddOns\\FastGuildInvite\\img\\minimap\\MiniMapButton")
		self.pause = true
		fn:PauseSearch()
		scanFrame.pausePlayFilter:UnregisterEvent("CHAT_MSG_SYSTEM")
	end
end)
scanFrame:AddChild(frame)




scanFrame.clear = GUI:Create("Button")
local frame = scanFrame.clear
frame:SetText(L["Сбросить"])
frame:SetWidth(size.clearBTN)
frame:SetHeight(40)
frame:SetCallback("OnClick", function()
	scanFrame.invite:SetText(format(L["Пригласить: %u"],0))
	local resume = addon.search.state == "start"
	if resume then
		scanFrame.pausePlay.frame:Click()
	end
	addon.search.inviteList = {}
	addon.search.state = "stop"
	addon.search.progress = 1
	addon.search.timeShift = 0
	addon.search.tempSendedInvites = {}
	addon.search.whoQueryList = {}
	
	addon.smartSearch.progress = 1
	addon.smartSearch.whoQueryList = {}
	addon.smartSearch.inviteList = {}
	addon.smartSearch.tempSendedInvites = {}
	
	scanFrame.progressBar:SetMinMax(0, 1)
	scanFrame.progressBar:SetProgress(0)
	
	
	if resume then
		C_Timer.After(FGI_SCANINTERVALTIME, function() scanFrame.pausePlay.frame:Click() end)
	else
		addon.search.state = "stop"
	end
end)
scanFrame:AddChild(frame)



local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	scanFrame:Show()
	DB = addon.DB
	
	scanFrame.closeButton:ClearAllPoints()
	scanFrame.closeButton:SetPoint("CENTER", scanFrame.frame, "TOPRIGHT", -8, -8)
	
	scanFrame.progressBar:ClearAllPoints()
	scanFrame.progressBar:SetPoint("TOP", scanFrame.frame, "TOP", 0, -25)
	
	scanFrame.invite:ClearAllPoints()
	scanFrame.invite:SetPoint("TOPLEFT", scanFrame.progressBar.frame, "BOTTOMLEFT", 4, 0)
	
	scanFrame.pausePlay:ClearAllPoints()
	scanFrame.pausePlay:SetPoint("LEFT", scanFrame.invite.frame, "RIGHT", 2, 0)
	
	scanFrame.clear:ClearAllPoints()
	scanFrame.clear:SetPoint("LEFT", scanFrame.pausePlay.frame, "RIGHT", 2, 0)
	
	
	
	scanFrame:Hide()
end)