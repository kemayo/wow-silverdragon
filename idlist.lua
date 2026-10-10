local myname, ns = ...

-- An AceGUI multiselect for long lists of ids. AceConfigDialog draws every
-- value of a normal multiselect at once, which freezes the client once there
-- are thousands of them; this draws only the rows that are visible.

local AceGUI = LibStub("AceGUI-3.0", true)
if not AceGUI then return end

local ROWS = 9
local ROW_HEIGHT = 32
local HEADER_HEIGHT = 24
local SCROLLBAR_WIDTH = 24

local issecretvalue = _G.issecretvalue or function() return false end

local function compare(a, b)
	if type(a) == type(b) and type(a) ~= "table" then
		return a < b
	end
	return tostring(a) < tostring(b)
end

-- hooks.label(key) -> string, hooks.tooltip(tooltip, key) -> nothing,
-- hooks.detail(key) -> string for the smaller second line (defaults to "ID: key")
function ns.RegisterIDListWidget(widgetType, hooks)
	-- the panel is rebuilt after every change, which makes a fresh widget; this
	-- keeps your place in the list across that
	local memory = {}
	local count = 0

	local function labelFor(self, key)
		local label = self.labels[key]
		if label == nil then
			local value = self.values[key]
			label = type(value) == "string" and value or (hooks.label and hooks.label(key)) or tostring(key)
			if issecretvalue(label) then label = tostring(key) end
			self.labels[key] = label
		end
		return label
	end

	local methods = {
		OnAcquire = function(self)
			self:SetHeight(HEADER_HEIGHT + ROWS * ROW_HEIGHT)
			self:SetDisabled(false)
		end,
		OnRelease = function(self)
			self.frame:ClearAllPoints()
			self.frame:Hide()
			self:SetFilterText("")
			self.values, self.labels, self.checked = {}, {}, {}
			self.keys, self.shown = {}, {}
			self.scroll.offset = 0
		end,
		SetMultiselect = function() end,
		SetLabel = function(self, text)
			self.label:SetText(text or "")
		end,
		SetDisabled = function(self, disabled)
			self.disabled = disabled
			self:Update()
		end,
		SetList = function(self, values)
			self.values, self.labels = values or {}, {}
			local keys = {}
			for key in pairs(self.values) do
				keys[#keys + 1] = key
			end
			table.sort(keys, compare)
			self.keys = keys
			local saved = memory[widgetType]
			if saved then
				self:SetFilterText(saved.filter or "")
				self:Refilter(saved.offset)
			else
				self:Refilter(0)
			end
		end,
		SetItemValue = function(self, key, value)
			self.checked[key] = value and true or nil
		end,
		SetFilterText = function(self, text)
			self.settingFilter = true
			self.filter:SetText(text)
			self.settingFilter = nil
		end,
		Refilter = function(self, offset)
			local text = self.filter:GetText():lower()
			if text == "" then
				self.shown = self.keys
			else
				local shown = {}
				for _, key in ipairs(self.keys) do
					if tostring(key):find(text, 1, true) or labelFor(self, key):lower():find(text, 1, true) then
						shown[#shown + 1] = key
					end
				end
				self.shown = shown
			end
			FauxScrollFrame_SetOffset(self.scroll, 0)
			local bar = self.scroll.ScrollBar or _G[self.scroll:GetName() .. "ScrollBar"]
			bar:SetValue(0)
			self:Update()
			if offset and offset > 0 then
				local maxOffset = math.max(#self.shown - ROWS, 0)
				bar:SetValue(math.min(offset, maxOffset) * ROW_HEIGHT)
			end
		end,
		Update = function(self)
			local shown = self.shown
			FauxScrollFrame_Update(self.scroll, #shown, ROWS, ROW_HEIGHT)
			local offset = FauxScrollFrame_GetOffset(self.scroll)
			memory[widgetType] = {filter = self.filter:GetText(), offset = offset}
			for i, row in ipairs(self.rows) do
				local key = shown[offset + i]
				row.key = key
				if key == nil then
					row:Hide()
				else
					row.text:SetText(labelFor(self, key))
					row.check:SetShown(self.checked[key] and true or false)
					local shade = self.disabled and 0.5 or 1
					row.text:SetTextColor(shade, shade, shade)
					row.detail:SetText(hooks.detail and hooks.detail(key) or ("ID: " .. tostring(key)))
					row.detail:SetTextColor(shade, shade, shade)
					row:Show()
				end
			end
			self.empty:SetShown(#shown == 0)
		end,
	}

	local function Constructor()
		count = count + 1
		local name = ("%s%s%d"):format(myname, widgetType, count)
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()
		frame:SetHeight(HEADER_HEIGHT + ROWS * ROW_HEIGHT)
		frame:EnableMouseWheel(true)

		local widget = {
			frame = frame,
			type = widgetType,
			values = {}, labels = {}, checked = {}, keys = {}, shown = {},
			rows = {},
		}
		for methodName, method in pairs(methods) do
			widget[methodName] = method
		end

		local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		label:SetPoint("TOPLEFT", 0, -4)
		label:SetJustifyH("LEFT")
		widget.label = label

		local filter = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
		filter:SetSize(140, 20)
		filter:SetPoint("TOPRIGHT", -SCROLLBAR_WIDTH - 4, 0)
		filter.Instructions:SetText("search...")
		-- hooked, not replaced: the template uses this to drive its placeholder and clear button.
		-- The clear button empties the box without it counting as user input.
		filter:HookScript("OnTextChanged", function()
			if not widget.settingFilter then widget:Refilter(0) end
		end)
		widget.filter = filter
		label:SetPoint("RIGHT", filter, "LEFT", -8, 0)

		local scroll = CreateFrame("ScrollFrame", name, frame, "FauxScrollFrameTemplate")
		scroll:SetPoint("TOPLEFT", 0, -HEADER_HEIGHT)
		scroll:SetPoint("BOTTOMRIGHT", -SCROLLBAR_WIDTH, 0)
		widget.scroll = scroll

		-- Driven off the scrollbar value, not the scroll frame: that clamps to a
		-- range which is not worked out until the frame has been laid out.
		local bar = scroll.ScrollBar or _G[name .. "ScrollBar"]
		bar:HookScript("OnValueChanged", function(_, value)
			FauxScrollFrame_SetOffset(scroll, math.floor(value / ROW_HEIGHT + 0.5))
			widget:Update()
		end)
		local function onWheel(_, delta)
			local value = bar:GetValue()
			local min, max = bar:GetMinMaxValues()
			if (delta > 0 and value <= min) or (delta < 0 and value >= max) then
				-- the list is at its end, so let the panel around it scroll instead
				local parent = frame:GetParent()
				while parent do
					local handler = parent:GetScript("OnMouseWheel")
					if handler then
						return handler(parent, delta)
					end
					parent = parent:GetParent()
				end
				return
			end
			bar:SetValue(value - delta * ROW_HEIGHT * 3)
		end
		frame:SetScript("OnMouseWheel", onWheel)
		scroll:SetScript("OnMouseWheel", onWheel)

		local empty = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		empty:SetPoint("TOPLEFT", 4, -HEADER_HEIGHT - 4)
		empty:SetText("Nothing to show.")
		widget.empty = empty

		for i = 1, ROWS do
			local row = CreateFrame("Button", nil, frame)
			row:SetHeight(ROW_HEIGHT)
			row:EnableMouseWheel(true)
			row:SetScript("OnMouseWheel", onWheel)
			row:SetPoint("TOPLEFT", 0, -HEADER_HEIGHT - (i - 1) * ROW_HEIGHT)
			row:SetPoint("RIGHT", frame, "RIGHT", -SCROLLBAR_WIDTH, 0)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			row:GetHighlightTexture():SetAlpha(0.5)

			local box = row:CreateTexture(nil, "ARTWORK")
			box:SetSize(20, 20)
			box:SetPoint("LEFT")
			box:SetTexture("Interface\\Buttons\\UI-CheckBox-Up")
			local check = row:CreateTexture(nil, "OVERLAY")
			check:SetAllPoints(box)
			check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
			row.check = check

			local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			text:SetPoint("TOPLEFT", 24, -4)
			text:SetPoint("TOPRIGHT", 0, -4)
			text:SetJustifyH("LEFT")
			text:SetWordWrap(false)
			row.text = text

			local detail = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			detail:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 6, -1)
			detail:SetPoint("TOPRIGHT", text, "BOTTOMRIGHT", 0, -1)
			detail:SetJustifyH("LEFT")
			detail:SetWordWrap(false)
			row.detail = detail

			row:SetScript("OnClick", function(self)
				if widget.disabled or self.key == nil then return end
				local value = not widget.checked[self.key]
				widget.checked[self.key] = value or nil
				self.check:SetShown(value)
				widget:Fire("OnValueChanged", self.key, value)
			end)
			row:SetScript("OnEnter", function(self)
				if self.key == nil or not hooks.tooltip then return end
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				hooks.tooltip(GameTooltip, self.key)
				GameTooltip:Show()
			end)
			row:SetScript("OnLeave", GameTooltip_Hide)
			widget.rows[i] = row
		end

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(widgetType, Constructor, 1)
end
