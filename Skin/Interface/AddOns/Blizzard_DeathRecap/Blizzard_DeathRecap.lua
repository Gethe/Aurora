local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_DeathRecap.lua ]]
--end

do --[[ AddOns\Blizzard_DeathRecap.xml ]]
    function Skin.DeathRecapEntryTemplate(Frame)
        Base.CropIcon(Frame.SpellInfo.Icon, Frame)
        Frame.SpellInfo.IconBorder:Hide()
    end
end

function private.AddOns.Blizzard_DeathRecap()
    local DeathRecapFrame = _G.DeathRecapFrame

    Base.CreateBackdrop(DeathRecapFrame, private.backdrop, {
        tl = _G.DeathRecapFrameBorderTopLeft,
        tr = _G.DeathRecapFrameBorderTopRight,
        bl = _G.DeathRecapFrameBorderBottomLeft,
        br = _G.DeathRecapFrameBorderBottomRight,

        t = _G.DeathRecapFrameBorderTop,
        b = _G.DeathRecapFrameBorderBottom,
        l = _G.DeathRecapFrameBorderLeft,
        r = _G.DeathRecapFrameBorderRight,

        bg = _G.DeathRecapFrame.Background,

    })
    Skin.FrameTypeFrame(DeathRecapFrame)

    local titleText = DeathRecapFrame.Title
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT")
    titleText:SetPoint("BOTTOMRIGHT", DeathRecapFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    DeathRecapFrame.Divider:Hide()

    Skin.UIPanelCloseButton(DeathRecapFrame.CloseXButton)
    DeathRecapFrame.CloseXButton:SetPoint("TOPRIGHT", 5, 5)
    DeathRecapFrame.DragButton:SetAllPoints(titleText)

    -- Hook the ScrollBox element initializer to skin frames as they're created
    if DeathRecapFrame.ScrollBox then
        local function SkinDeathRecapEntry(frame, elementData)
            if not frame.auroraSkinned then
                Skin.DeathRecapEntryTemplate(frame)
                frame.auroraSkinned = true
            end
        end

        _G.hooksecurefunc(DeathRecapFrame.ScrollBox, "Update", function(self)
            self:ForEachFrame(SkinDeathRecapEntry)
        end)
    end

    Skin.UIPanelButtonTemplate(DeathRecapFrame.CloseButton)
end
