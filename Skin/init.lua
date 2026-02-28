local ADDON_NAME, private = ...

-- luacheck: globals select tostring tonumber math floor
-- luacheck: globals setmetatable rawset debugprofilestop type tinsert

private.API_MAJOR, private.API_MINOR = 12, 0

private.isRetail = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE
private.isVanilla = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC
private.isBCC = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC
private.isWrath = _G.WOW_PROJECT_ID == (_G.WOW_PROJECT_WRATH_CLASSIC or 11)
private.isCata = _G.WOW_PROJECT_ID == (_G.WOW_PROJECT_CATACLYSM_CLASSIC or 14)

private.isClassic = not private.isRetail
private.isMidnight = private.isRetail and select(4, _G.GetBuildInfo()) >= 120000
private.isBetaBuild = private.isRetail and select(4, _G.GetBuildInfo()) >= 130000


local debugProjectID = {
    [0] = private.isRetail,
    [10] = private.isVanilla,
    [20] = private.isBCC,
    [30] = private.isWrath,
    [40] = private.isCata,
    [50] = private.isMists,
}
function private.shouldSkip()
    return not debugProjectID[_G.AURORA_DEBUG_PROJECT]
end

private.uiScale = 1
private.disabled = {
    bags = false,
    banks = false,
    chat = false,
    fonts = false,
    tooltips = false,
    mainmenubar = false,
    pixelScale = true
}
private.textures = {
    plain = [[Interface\Buttons\WHITE8x8]],
}

local pixelScale, uiScaleChanging = false, false
function private.UpdateUIScale()
    if uiScaleChanging then return end
    local _, pysHeight = _G.GetPhysicalScreenSize()

    if not private.disabled.pixelScale then
        -- Calculate current UI scale
        pixelScale = 768 / pysHeight
        local cvarScale, parentScale = _G.tonumber(_G.GetCVar("uiscale")), floor(_G.UIParent:GetScale() * 100 + 0.5) / 100
        private.debug("scale", pixelScale, cvarScale, parentScale)
        if parentScale == 1 then -- bail if UIParent is scaled to 1... we don't want to mess with that
            return
        end
        uiScaleChanging = true
        --[[ UIParent:SetScale() from addon code taints C_ActionBar.GetActionBarPage() and related
            action bar page APIs, causing ADDON_ACTION_BLOCKED errors on MultiBar:ShowBase() during
            combat. Prefer SetCVar("uiScale") which lets the engine apply the scale securely.
            SetCVar has a minimum of 0.64, so UIParent:SetScale() is only used as a fallback for
            sub-0.64 scales. SetCVar may taint the ObjectiveTracker but that is far less disruptive
            than broken action bars in combat. ]]
        if parentScale ~= pixelScale then
            private.debug("Skipping engine UI scale change to avoid taint; desired pixelScale:", pixelScale)
            -- Store the desired engine UI scale instead of changing it here. Changing
            -- the `uiScale` CVar or calling `UIParent:SetScale` from addon code can
            -- taint protected Blizzard frame behavior (ObjectiveTracker / WorldMap)
            -- and lead to ADDON_ACTION_BLOCKED for protected functions like
            -- SetPassThroughButtons. Leave the global scale unchanged and only
            -- apply per-frame scaling via host addon integration.
            private.desiredUIScale = pixelScale
        end
        uiScaleChanging = false
    end
end


local classLocale, classToken, classID = _G.UnitClass("player")
private.charClass = {
    locale = classLocale,
    token = classToken,
    id = classID,
}

do -- private.font
    local fontPath = [[Interface\AddOns\Aurora\media\font.ttf]]
    if _G.LOCALE_koKR then
        fontPath = [[Fonts/2002.ttf]]
    elseif _G.LOCALE_zhCN then
        fontPath = [[Fonts/ARKai_T.ttf]]
    elseif _G.LOCALE_zhTW then
        fontPath = [[Fonts/blei00d.ttf]]
    end

    private.font = {
        normal = fontPath,
        chat = fontPath,
        crit = fontPath,
        header = fontPath,
    }
end

function private.nop() end
local debug do
    if not private.debug then
        local LTD = _G.LibStub("LibTextDump-1.0", true)
        if LTD then
            local debugger
            function debug(...)
                if not debugger then
                    if LTD then
                        debugger = LTD:New(ADDON_NAME .." Debug Output", 640, 480)
                        private.debugger = debugger
                    else
                        return
                    end
                end
                local time = _G.date("%H:%M:%S")
                local text = ("[%s]"):format(time)
                for i = 1, select("#", ...) do
                    local arg = select(i, ...)
                    text = text .. "     " .. tostring(arg)
                end
                -- Use pcall to safely handle tainted/secret strings
                local success, err = pcall(debugger.AddLine, debugger, text)
                if not success and not err:match("secret string") then
                    -- Only report non-taint related errors
                    _G.print("Aurora debug error:", err)
                end
            end
        else
            debug = private.nop
        end
        private.debug = debug
    end
end

local Aurora = {
    Base = {},
    Scale = {},
    Hook = {},
    Skin = {},
    Color = {},
    Util = {},
}
private.Aurora = Aurora
_G.Aurora = Aurora

do -- set up file order
    private.fileOrder = {}
    local mt = {
        __newindex = function(t, k, v)
            tinsert(private.fileOrder, {list = t, name = k})
            rawset(t, k, v)
        end
    }

    private.AddOns = {} --  setmetatable({}, mt) --
    private.FrameXML = setmetatable({}, mt)
    private.SharedXML = setmetatable({}, mt)
end


local eventFrame = _G.CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("UI_SCALE_CHANGED")
eventFrame:SetScript("OnEvent", function(dialog, event, addonName)
    if event == "UI_SCALE_CHANGED" then
        -- Defer to a new execution context so that SetCVar("uiScale") taint
        -- does not propagate through Blizzard event handlers, which would cause
        -- ADDON_ACTION_BLOCKED for protected functions like SetPassThroughButtons
        -- when opening the WorldMap.
        _G.C_Timer.After(0, function()
            private.UpdateUIScale()
        end)
    else
        if addonName == ADDON_NAME then
            local phyScreenWidth, phyScreenHeight = _G.GetPhysicalScreenSize()
            _G.print(("%s v%s loaded."):format(ADDON_NAME, private.API_MAJOR + private.API_MINOR / 100))
            _G.print(("Blizzard World of Warcraft - %s (%s)"):format(select(1, _G.GetBuildInfo()),select(2, _G.GetBuildInfo())))
            _G.print(("Running on %sx%s - UI Scale: %.2f"):format(phyScreenWidth, phyScreenHeight, _G.UIParent:GetScale()))
            -- Setup function for the host addon
            private.OnLoad()
            -- Defer scale update to a new execution context so that
            -- SetCVar("uiScale") / UIParent:SetScale() taint does not
            -- contaminate the ADDON_LOADED processing chain and propagate
            -- to UIParentPanelManager, which causes ADDON_ACTION_BLOCKED
            -- errors for protected functions (e.g. SetPassThroughButtons)
            -- when frames like WorldMapFrame are opened via ShowUIPanel.
            _G.C_Timer.After(0, function()
                private.UpdateUIScale()
            end)
            if (tonumber(_G.GetCVar("questTextContrast")) ~= 4) then
                _G.SetCVar("questTextContrast", 4);
            end

            if _G.AuroraConfig then
                Aurora[2].buttonsHaveGradient = _G.AuroraConfig.buttonsHaveGradient
            end

            for i = 1, #private.fileOrder do
                local file = private.fileOrder[i]
                file.list[file.name]()
            end

            -- Skin prior loaded AddOns
            for addon, func in _G.next, private.AddOns do
                local isLoaded, isFinished = _G.C_AddOns.IsAddOnLoaded(addon)
                if isLoaded and isFinished then
                    func()
                end
            end

            private.isLoaded = true
        else
            local addonModule = private.AddOns[addonName]
            if addonModule then
                addonModule()
            end
        end

        -- Load deprected themes
        local addonModule = Aurora[2].themes[addonName]
        if addonModule then
            if _G.type(addonModule) == "function" then
                addonModule()
            else
                for _, moduleFunc in _G.next, addonModule do
                    moduleFunc()
                end
            end
        end
    end
end)
