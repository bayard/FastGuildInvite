--[[-----------------------------------------------------------------------------
FGI Filter Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "FilterButton", 1
local AceKGUI = LibStub and LibStub("AceKGUI-3.0", true)
if not AceKGUI or (AceKGUI:GetWidgetVersion(Type) or 0) >= Version then return end


local addon = FGI
local L = addon.L


-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(self, button,...)
	local frame = self.obj.frame
	local shift = IsShiftKeyDown()
	if button == "LeftButton" and not shift then
		--on/off
		self.obj:click()
		FGI.functions:FiltersUpdate()
	elseif button == "LeftButton" and shift then
		--delete
		local DB = FGI.DB
		DB.filtersList[frame.id] = nil
		FGI.functions:FiltersUpdate()
	elseif button == "RightButton" then
		--replace
		FGI.functions:FilterChange(frame.id)
	end
	AceKGUI:ClearFocus()
	--PlaySound("igMainMenuOption")
	self.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	if frame.obj.tooltip ~= nil and frame.obj.tooltip ~= '' then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:AddLine(format("%s\n\n%s", L.help["filter"], frame.obj.tooltip))
		GameTooltip:Show()
	end
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	GameTooltip:Hide()
	frame.obj:Fire("OnLeave")
end

local function setHighlight(frame, s)
	if s then
		frame:SetColorTexture(0,1,0,0.2);
	else
		frame:SetColorTexture(1,0,0,0.2);
	end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(25)
		self:SetWidth(80)
		self:SetDisabled(false)
		self:SetText()
	end,
	
	["click"] = function(self)
		local DB = FGI.DB
		if self.frame.id == '' and not DB.filtersList[self.frame.id] then return  end
		local on = not DB.filtersList[self.frame.id].filterOn
		if on then
			setHighlight(self.highlight, true)
			DB.filtersList[self.frame.id].filterOn = true
		else
			setHighlight(self.highlight, false)
			DB.filtersList[self.frame.id].filterOn = false
		end
	end,

	-- ["OnRelease"] = nil,

	["SetText"] = function(self, text)
		self.text:SetText(text)
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end,
	
	["SetTooltip"] = function(self, tooltip)
		self.tooltip = tooltip
	end,
	
	["SetID"] = function(self, id)
		local DB = FGI.DB
		self.frame.id = id
		if DB.filtersList[id] then self.frame:Show() end
		if DB.filtersList[id] and DB.filtersList[id].filterOn then
			setHighlight(self.highlight, true)
		else
			setHighlight(self.highlight, false)
		end
	end,
	
	["Show"] = function(self)
		self.frame:Show()
	end,
	
	["Hide"] = function(self)
		self.frame:Hide()
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceKGUI30Button" .. AceKGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, FGI.interface.filtersFrame.frame)
	frame:Hide()
	
	frame.tooltip = ''
	frame.id = ''

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	frame:RegisterForClicks("LeftButtonUp","RightButtonUp")
	
	

	--local text = frame:GetFontString()
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 5, -1)
	text:SetPoint("BOTTOMRIGHT", -5, 1)
	text:SetJustifyV("LEFT")
	
	local highlight = frame:CreateTexture()
	highlight:SetColorTexture(1,0,0,0.2)
	highlight:SetAllPoints()

	local widget = {
		text  = text,
		frame = frame,
		highlight = highlight,
		type  = Type,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceKGUI:RegisterAsWidget(widget)
end

AceKGUI:RegisterWidgetType(Type, Constructor, Version)
