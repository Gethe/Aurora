local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Color = private.Aurora.Color

private.NORMAL_QUEST_DISPLAY = _G.NORMAL_QUEST_DISPLAY:gsub("ff000000", Color.white.colorStr)
private.TRIVIAL_QUEST_DISPLAY = _G.TRIVIAL_QUEST_DISPLAY:gsub("ff000000", Color.grayLight.colorStr)
private.IGNORED_QUEST_DISPLAY = _G.IGNORED_QUEST_DISPLAY:gsub("ff000000", Color.grayLight.colorStr)

private.FRAME_TITLE_HEIGHT = 27

local Enum = {}
Enum.LFGListFilter = {
	Recommended = _G.LE_LFG_LIST_FILTER_RECOMMENDED or _G.Enum.LFGListFilter.Recommended,
	NotRecommended = _G.LE_LFG_LIST_FILTER_NOT_RECOMMENDED or _G.Enum.LFGListFilter.NotRecommended,
	PvE = _G.LE_LFG_LIST_FILTER_PVE or _G.Enum.LFGListFilter.PvE,
	PvP = _G.LE_LFG_LIST_FILTER_PVP or _G.Enum.LFGListFilter.PvP,
}
private.Enum = Enum

private.assetColors = {
    ["_honorsystem-bar-fill"] = Color.Create(1.0, 0.24, 0),
    ["_islands-queue-progressbar-fill"] = private.AZERITE_COLORS[2],
    ["_islands-queue-progressbar-fill_2"] = private.AZERITE_COLORS[1],
    ["_pvpqueue-conquestbar-fill-yellow"] = Color.Create(.9529, 0.7569, 0.1804),
    ["ChallengeMode-TimerFill"] = Color.Create(0.1490, 0.6196, 1.0),
    ["objectivewidget-bar-fill-left"] = Color.Create(0.1176, 0.2823, 0.7176),
    ["objectivewidget-bar-fill-neutral"] = Color.Create(0.3608, 0.2980, 0.0),
    ["objectivewidget-bar-fill-right"] = Color.Create(0.5765, 0.0, 0.0),
    ["UI-Frame-Bar-Fill-Green"] = Color.Create(0.0941, 0.7647, 0.0157),
    ["UI-Frame-Bar-Fill-Red"] = Color.Create(0.7725, 0.0, 0.0),
    ["UI-Frame-Bar-Fill-Yellow"] = Color.Create(0.9608, 0.6314, 0.0),
    ["UI-Frame-Bar-Fill-Blue"] = Color.Create(0.0667, 0.4470, 0.8745),
    ["UI-HUD-ExperienceBar-Fill-Honor"] = Color.Create("ffff3d00"),
    ["UI-HUD-ExperienceBar-Fill-Rested"] = Color.Create("ff0063e0"),
    ["UI-HUD-ExperienceBar-Fill-Experience"] = Color.Create("ff940080"),
    ["UI-HUD-ExperienceBar-Fill-Reputation-Faction-Red"] = _G.FACTION_RED_COLOR,
    ["UI-HUD-ExperienceBar-Fill-Reputation-Faction-Orange"] = _G.FACTION_ORANGE_COLOR,
    ["UI-HUD-ExperienceBar-Fill-Reputation-Faction-Yellow"] = _G.FACTION_YELLOW_COLOR,
    ["UI-HUD-ExperienceBar-Fill-Reputation-Faction-Green"] = _G.FACTION_GREEN_COLOR,
}

private.CLASS_BACKGROUND_SETTINGS = {
	["DEFAULT"] = { desaturation = 0.5, alpha = 0.25 },
	["DEATHKNIGHT"] = { desaturation = 0.5, alpha = 0.30 },
	["DEMONHUNTER"] = { desaturation = 0.5, alpha = 0.30 },
	["HUNTER"] = { desaturation = 0.5, alpha = 0.45 },
	["MAGE"] = { desaturation = 0.5, alpha = 0.45 },
	["PALADIN"] = { desaturation = 0.5, alpha = 0.21 },
	["ROGUE"] = { desaturation = 0.5, alpha = 0.65 },
	["SHAMAN"] = { desaturation = 0.5, alpha = 0.40 },
	["WARLOCK"] = { desaturation = 0.5, alpha = 0.40 },
}

--function private.FrameXML.Constants()
--end
