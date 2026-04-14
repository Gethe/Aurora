local _, private = ...
if private.shouldSkip() then return end

local Aurora = private.Aurora
local Base, _, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

function private.AddOns.Blizzard_GuildRename()
    local frame = _G.GuildRenameFrame
    if not frame then return end

    ------------------------------------
    -- Main frame (ButtonFrameTemplate)
    ------------------------------------
    Skin.FrameTypeFrame(frame)

    ------------------------------------
    -- Strip ButtonFrameTemplate decorative textures (portrait, NineSlice, inset)
    ------------------------------------
    Base.StripBlizzardTextures(frame)

    -- Hide the background texture
    if frame.Background then
        frame.Background:SetAlpha(0)
    end

    ------------------------------------
    -- ContextButton (main action button)
    ------------------------------------
    if frame.ContextButton then
        Skin.FrameTypeButton(frame.ContextButton)
    end

    ------------------------------------
    -- TitleFlow option buttons (GossipTitleButtonTemplate)
    ------------------------------------
    if frame.TitleFlow then
        if frame.TitleFlow.RenameOption then
            Skin.GossipTitleButtonTemplate(frame.TitleFlow.RenameOption)
        end
        if frame.TitleFlow.RefundOption then
            Skin.GossipTitleButtonTemplate(frame.TitleFlow.RefundOption)
        end
    end

    ------------------------------------
    -- RenameFlow: NameBox EditBox (InputBoxTemplate)
    ------------------------------------
    if frame.RenameFlow and frame.RenameFlow.NameBox then
        Skin.InputBoxTemplate(frame.RenameFlow.NameBox)
    end

    ------------------------------------
    -- Close button
    ------------------------------------
    if frame.CloseButton then
        Skin.UIPanelCloseButton(frame.CloseButton)
    end
end
