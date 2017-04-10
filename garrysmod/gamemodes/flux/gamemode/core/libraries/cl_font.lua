--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

library.New("font", _G)

-- We want the fonts to recreate on refresh.
local stored = {}

do
	local aspect = ScrW() / ScrH()

	local function ScreenIsRatio(w, h)
		return (aspect == w / h)
	end

	function font.Scale(size)
		if (ScreenIsRatio(16, 10)) then
			return math.floor(size * (ScrH() / 1200))
		elseif (ScreenIsRatio(4, 3)) then
			return math.floor(size * (ScrH() / 1024))
		end

		return math.floor(size * (ScrH() / 1080))
	end
end

function font.Create(name, fontData)
	if (name == nil or !istable(fontData)) then return end
	if (stored[name]) then return end

	-- Force UTF-8 range by default.
	fontData.extended = true

	surface.CreateFont(name, fontData)
	stored[name] = fontData
end

function font.GetSize(name, size)
	if (!size) then return name end

	local newName = name..":"..size

	if (!stored[newName]) then
		local fontData = table.Copy(stored[name])

		if (fontData) then
			fontData.size = size

			font.Create(newName, fontData)
		end
	end

	return newName
end

function font.ClearTable()
	stored = {}
end

function font.ClearSizes()
	for k, v in pairs(stored) do
		if (k:find("\\")) then
			stored[k] = nil
		end
	end
end

function font.GetTable(name)
	return stored[name]
end

function font.CreateFonts()
	font.ClearTable()

	font.Create("menu_thin", {
		font = "Roboto Lt",
		extended = true,
		weight = 400,
		size = font.Scale(34)
	})

	font.Create("menu_thin_large", {
		font = "Roboto Lt",
		extended = true,
		weight = 400,
		size = font.Scale(42)
	})

	font.Create("menu_thin_small", {
		font = "Roboto Lt",
		extended = true,
		weight = 300,
		size = font.Scale(28)
	})

	font.Create("menu_thin_smaller", {
		font = "Roboto Lt",
		extended = true,
		size = font.Scale(22),
		weight = 200
	})

	font.Create("menu_light", {
		font = "Roboto Lt",
		extended = true,
		size = font.Scale(34)
	})

	font.Create("menu_light_tiny", {
		font = "Roboto Lt",
		extended = true,
		size = font.Scale(16)
	})

	font.Create("menu_light_small", {
		font = "Roboto Lt",
		extended = true,
		size = font.Scale(20)
	})

	font.Create("hud_small", {
		font = "Roboto Condensed",
		extended = true,
		size = font.Scale(20),
		weight = 200
	})

	font.Create("bar_text", {
		font = "Roboto Condensed",
		extended = true,
		size = 14,
		weight = 600
	})

	font.Create("tooltip_large", {
		font = "Roboto Condensed",
		extended = true,
		size = 26,
		weight = 500
	})

	font.Create("tooltip_small", {
		font = "Roboto Condensed",
		extended = true,
		size = 16,
		weight = 500
	})

	font.Create("fl_frame_title", {
		font = "Roboto",
		size = 14,
		weight = 500
	})

	font.Create("fl_menuitem", {
		font = "Roboto Condensed",
		extended = true,
		size = 24,
		weight = 500
	})

	font.Create("fl_menuitem_large", {
		font = "Roboto Condensed",
		extended = true,
		size = 30,
		weight = 500
	})

	font.Create("flMainFont", {
		font = "Roboto Condensed",
		extended = true,
		size = 16,
		weight = 500
	})

	theme.Call("CreateFonts")
	hook.Run("CreateFonts")
end