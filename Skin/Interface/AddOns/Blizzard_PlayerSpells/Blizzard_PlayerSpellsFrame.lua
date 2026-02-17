local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook = Aurora.Hook
local Skin = Aurora.Skin
local Color = Aurora.Color
local Util = Aurora.Util

do  -- PlayerSpellsFrame.SpecFrame
    local RoleIcons = {
        TANK = "groupfinder-icon-role-micro-tank",
        HEALER = "groupfinder-icon-role-micro-heal",
        DAMAGER = "groupfinder-icon-role-micro-dps",
        DPS = "groupfinder-icon-role-micro-dps",
    }

    function Hook.SkinSpellBookItem(frame)
        if not frame.Button then return end

        local button = frame.Button

        -- Mark as skinned first to prevent re-entry
        if button._auroraSkinned then return end
        button._auroraSkinned = true

        -- Hide the Backplate that creates the dark bar behind text
        if frame.Backplate then
            frame.Backplate:Hide()
        end

        -- Hide text container background if it exists
        if frame.TextContainer then
            for _, region in pairs({frame.TextContainer:GetRegions()}) do
                if region:IsObjectType("Texture") then
                    region:Hide()
                end
            end
        end

        -- Hide the FxModelScene that creates animated effects
        if button.FxModelScene then
            button.FxModelScene:Hide()
            button.FxModelScene:SetAlpha(0)
        end

        -- Aggressively hide the border - it keeps getting reset
        if button.Border then
            button.Border:SetTexture(nil)
            button.Border:SetAlpha(0)
            button.Border:Hide()
            -- Hook SetTexture to prevent it from being set
            _G.hooksecurefunc(button.Border, "SetTexture", function(self)
                if self:GetTexture() then
                    self:SetTexture(nil)
                    self:SetAlpha(0)
                end
            end)
            _G.hooksecurefunc(button.Border, "SetAtlas", function(self)
                self:SetTexture(nil)
                self:SetAlpha(0)
            end)
        end

        if button.TrainableShadow then
            button.TrainableShadow:Hide()
        end
        if button.TrainableBackplate then
            button.TrainableBackplate:SetAlpha(0)
        end
        if button.BorderSheen then
            button.BorderSheen:Hide()
        end
        if button.BorderSheenMask then
            button.BorderSheenMask:Hide()
        end

        -- Crop and position the icon - make it sharper
        Base.CropIcon(button.Icon, button)
        button.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Create Aurora backdrop on the button
        Base.CreateBackdrop(button, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        button:SetBackdropColor(1, 1, 1, 0.75)
        button:SetBackdropBorderColor(Color.frame, 1)
        Base.CropIcon(button:GetBackdropTexture("bg"))

        -- Handle various overlay textures
        if button.IconHighlight then
            button.IconHighlight:ClearAllPoints()
            button.IconHighlight:SetPoint("TOPLEFT", button.Icon)
            button.IconHighlight:SetPoint("BOTTOMRIGHT", button.Icon)
        end

        -- Handle AutoCast overlay
        if button.AutoCastOverlay then
            local overlay = button.AutoCastOverlay
            if overlay.Corners then
                overlay.Corners:SetAlpha(0)
            end
        end

        -- Hook the button's UpdateVisuals to maintain skinning and update text colors
        if button.UpdateVisuals then
            _G.hooksecurefunc(button, "UpdateVisuals", function(self)
                if self.Border then
                    self.Border:SetTexture(nil)
                    self.Border:SetAlpha(0)
                end
                if self.TrainableBackplate then
                    self.TrainableBackplate:SetAlpha(0)
                end
                if self.FxModelScene then
                    self.FxModelScene:Hide()
                    self.FxModelScene:SetAlpha(0)
                end
            end)
        end

        -- Hook text alpha setting to override Blizzard's values
        if frame.Name and not frame.Name._auroraAlphaHooked then
            _G.hooksecurefunc(frame.Name, "SetAlpha", function(self, alpha)
                -- Always force full alpha for better visibility
                if alpha < 1 then
                    self:SetAlpha(1)
                end
            end)
            frame.Name._auroraAlphaHooked = true
        end

        if frame.SubName and not frame.SubName._auroraAlphaHooked then
            _G.hooksecurefunc(frame.SubName, "SetAlpha", function(self, alpha)
                -- Always force full alpha for better visibility
                if alpha < 1 then
                    self:SetAlpha(1)
                end
            end)
            frame.SubName._auroraAlphaHooked = true
        end

        -- Hook UpdateVisuals on the parent frame to handle text coloring
        if not frame._auroraTextColorHooked then
            -- Hook into the frame's property changes to update text colors
            _G.hooksecurefunc(frame, "UpdateSpellData", function(self)
                if not self.TextContainer then return end

                -- Apply colors immediately after Blizzard's update
                if self.isTrainable then
                    -- Trainable spells get bright yellow text
                    if self.TextContainer.Name then
                        self.TextContainer.Name:SetTextColor(Color.yellow:GetRGB())
                        self.TextContainer.Name:SetAlpha(1)
                    end
                    if self.TextContainer.SubName then
                        self.TextContainer.SubName:SetTextColor(Color.yellow:GetRGB())
                        self.TextContainer.SubName:SetAlpha(1)
                    end
                elseif self.isUnlearned then
                    -- Unlearned/off-spec spells stay gray
                    if self.TextContainer.Name then
                        self.TextContainer.Name:SetTextColor(0.6, 0.6, 0.6)
                        self.TextContainer.Name:SetAlpha(1)
                    end
                    if self.TextContainer.SubName then
                        self.TextContainer.SubName:SetTextColor(0.5, 0.5, 0.5)
                        self.TextContainer.SubName:SetAlpha(1)
                    end
                else
                    -- Normal learned spells get BRIGHT white text - use full RGB values
                    if self.TextContainer.Name then
                        self.TextContainer.Name:SetTextColor(1, 1, 1)
                        self.TextContainer.Name:SetAlpha(1)
                    end
                    if self.TextContainer.SubName then
                        self.TextContainer.SubName:SetTextColor(0.9, 0.9, 0.9)
                        self.TextContainer.SubName:SetAlpha(1)
                    end
                end
            end)
            frame._auroraTextColorHooked = true
        end

        frame._auroraSkinned = true
    end

    -- Create a mixin to hook into SpellBookFrame's methods
    Hook.SpellBookFrameMixin = {}

    function Hook.SpellBookFrameMixin:OnLoad()
        -- Called when the frame is first loaded
        -- This may have already been called before we mixin, so we also manually trigger skinning
        _G.C_Timer.After(0.5, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button then
                    frame._auroraSkinned = nil
                    frame.Button._auroraSkinned = nil
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
    end

    function Hook.SpellBookFrameMixin:OnShow()
        -- Called when the frame is shown
        -- Skin all spell items with multiple attempts to catch them when ready
        _G.C_Timer.After(0.1, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button then
                    frame._auroraSkinned = nil
                    frame.Button._auroraSkinned = nil
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
        _G.C_Timer.After(0.5, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button and not frame._auroraSkinned then
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
        _G.C_Timer.After(1.0, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button and not frame._auroraSkinned then
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
    end

    function Hook.SpellBookFrameMixin:UpdateDisplayedSpells()
        -- Skin all spell items after Blizzard updates them
        _G.C_Timer.After(0.1, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button and not frame._auroraSkinned then
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
    end

    function Hook.SpellBookFrameMixin:OnPagedSpellsUpdate()
        -- Skin all spell items when page updates
        _G.C_Timer.After(0.1, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button and not frame._auroraSkinned then
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
    end

    function Hook.SpellBookFrameMixin:UpdateAllSpellData()
        -- Skin all spell items when all data is updated (initial load)
        _G.C_Timer.After(0.2, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button then
                    -- Force re-skin on initial load
                    frame._auroraSkinned = nil
                    frame.Button._auroraSkinned = nil
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
        _G.C_Timer.After(0.5, function()
            for _, frame in self.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button and not frame._auroraSkinned then
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
    end

    function Hook.UpdatePlayeerSpecFrame(self)
        for SpecContentFrame in self.SpecContentFramePool:EnumerateActive() do
            if not SpecContentFrame._auroraSkinned then
                Skin.UIPanelButtonTemplate(SpecContentFrame.ActivateButton)
                local role = _G.GetSpecializationRole(SpecContentFrame.specIndex)
                if role then
                    local RoleIcon = SpecContentFrame.RoleIcon
                    RoleIcon:SetTexCoord(0, 1, 0, 1)
                    RoleIcon:SetAtlas(RoleIcons[role])
                end
                if SpecContentFrame.SpellButtonPool then
                    for Button in SpecContentFrame.SpellButtonPool:EnumerateActive() do
                        Button.Ring:Hide()
                        Base.CropIcon(Button.Icon, Button)
                        local texture = Button.spellID and _G.C_Spell.GetSpellTexture(Button.spellID)
                        if texture then
                            Button.Icon:SetTexture(texture)
                        end
                    end
                end
                SpecContentFrame._auroraSkinned = true
            end
        end
    end
    function Skin.PlayerSpellsFrameTabTemplate(Button)
        Skin.PanelTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.PlayerSpellsButtonTemplate(Button)
        Base.CropIcon(Button.Icon, Button)
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
end

function private.AddOns.Blizzard_PlayerSpells()
    local PlayerSpellsFrame = _G.PlayerSpellsFrame

    -- Skin the main frame - this provides the Aurora background
    Skin.NineSlicePanelTemplate(PlayerSpellsFrame.NineSlice)
    PlayerSpellsFrame.NineSlice:SetFrameLevel(1)

    -- Make the background solid black like Collections frame
    if PlayerSpellsFrame.NineSlice.Bg then
        PlayerSpellsFrame.NineSlice.Bg:SetColorTexture(0, 0, 0, 1)
        PlayerSpellsFrame.NineSlice.Bg:SetAllPoints(PlayerSpellsFrame.NineSlice)
        PlayerSpellsFrame.NineSlice.Bg:Show()
    end

    -- Hide portrait but keep the frame background
    if PlayerSpellsFrame.PortraitContainer then
        PlayerSpellsFrame.PortraitContainer:Hide()
    end

    -- Skin tabs
    for i = 1, 3 do
        local tab = select(i, PlayerSpellsFrame.TabSystem:GetChildren())
        Skin.PlayerSpellsFrameTabTemplate(tab)
    end

    Skin.UIPanelCloseButton(_G.PlayerSpellsFrameCloseButton)
    Skin.MaximizeMinimizeButtonFrameTemplate(PlayerSpellsFrame.MaxMinButtonFrame)

    -- SpecFrame
    local SpecFrame = PlayerSpellsFrame.SpecFrame
    _G.hooksecurefunc(SpecFrame, "UpdateSpecFrame", Hook.UpdatePlayeerSpecFrame)

    -- TalentsFrame
    local TalentsFrame = PlayerSpellsFrame.TalentsFrame
    Skin.UIPanelButtonTemplate(TalentsFrame.ApplyButton)
    Skin.UIPanelButtonTemplate(TalentsFrame.InspectCopyButton)
    Skin.SearchBoxTemplate(TalentsFrame.SearchBox)
    Skin.DropdownButton(TalentsFrame.LoadSystem.Dropdown)

    -- SpellBookFrame
    local SpellBookFrame = PlayerSpellsFrame.SpellBookFrame

    -- Mix in our hooks to the SpellBookFrame
    Util.Mixin(SpellBookFrame, Hook.SpellBookFrameMixin)

    -- Immediately try to skin if the frame is already shown
    if SpellBookFrame:IsShown() then
        _G.C_Timer.After(0.5, function()
            for _, frame in SpellBookFrame.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button then
                    frame._auroraSkinned = nil
                    frame.Button._auroraSkinned = nil
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
        _G.C_Timer.After(1.0, function()
            for _, frame in SpellBookFrame.PagedSpellsFrame:EnumerateFrames() do
                if frame.Button and not frame._auroraSkinned then
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end)
    end

    -- Create a solid black background for the SpellBookFrame to cover any Blizzard textures
    if not SpellBookFrame._auroraBackground then
        local bg = SpellBookFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
        bg:SetColorTexture(0, 0, 0, 1)
        bg:SetAllPoints(SpellBookFrame)
        SpellBookFrame._auroraBackground = bg
    end

    -- Function to hide all book backgrounds
    local function HideSpellBookBackgrounds()
        -- Hide all the book texture layers
        if SpellBookFrame.TopBar then SpellBookFrame.TopBar:SetAlpha(0) end
        if SpellBookFrame.BookBGHalved then SpellBookFrame.BookBGHalved:SetAlpha(0) end
        if SpellBookFrame.BookBGLeft then SpellBookFrame.BookBGLeft:SetAlpha(0) end
        if SpellBookFrame.BookBGRight then SpellBookFrame.BookBGRight:SetAlpha(0) end
        if SpellBookFrame.BookCornerFlipbook then SpellBookFrame.BookCornerFlipbook:SetAlpha(0) end
        if SpellBookFrame.Bookmark then SpellBookFrame.Bookmark:SetAlpha(0) end

        -- Also try to hide any regions that might be the stripes
        for _, region in pairs({SpellBookFrame:GetRegions()}) do
            if region:IsObjectType("Texture") and region:GetDrawLayer() == "BACKGROUND" then
                local texture = region:GetTexture()
                if texture and type(texture) == "number" then
                    -- Hide any background textures
                    region:SetAlpha(0)
                end
            end
        end
    end

    -- Get references to paging controls
    local PagedSpellsFrame = SpellBookFrame.PagedSpellsFrame
    local PagingControls = PagedSpellsFrame.PagingControls

    -- Function to hide all background effects
    local function HidePagedSpellsBackgrounds()
        -- Hide any background effects on the PagedSpellsFrame and its views
        if PagedSpellsFrame.ViewFrames then
            for _, view in ipairs(PagedSpellsFrame.ViewFrames) do
                -- Hide all textures on the view frames
                for _, region in pairs({view:GetRegions()}) do
                    if region:IsObjectType("Texture") then
                        region:SetAlpha(0)
                    end
                end
                -- Hide any ModelScenes on the views
                for _, child in pairs({view:GetChildren()}) do
                    if child:IsObjectType("ModelScene") then
                        child:Hide()
                        child:SetAlpha(0)
                    end
                end
            end
        end

        -- Also hide textures on the PagedSpellsFrame itself
        for _, region in pairs({PagedSpellsFrame:GetRegions()}) do
            if region:IsObjectType("Texture") and region:GetDrawLayer() == "BACKGROUND" then
                region:SetAlpha(0)
            end
        end
    end

    -- Function to skin all visible spell book items
    local function SkinAllSpellBookItems()
        if not PagedSpellsFrame then return end

        local frameCount = 0
        for _, frame in PagedSpellsFrame:EnumerateFrames() do
            frameCount = frameCount + 1
            if frame.Button then
                -- Always check and re-skin if needed, as buttons can be recycled from pools
                local button = frame.Button
                if not button._auroraSkinned or not button:GetBackdrop() then
                    -- Clear the flag to force re-skinning
                    button._auroraSkinned = nil
                    frame._auroraSkinned = nil
                    Hook.SkinSpellBookItem(frame)
                end
            end
        end

        -- Debug: if no frames found, try again later
        if frameCount == 0 then
            _G.C_Timer.After(0.2, SkinAllSpellBookItems)
        end
    end

    -- Hide backgrounds initially
    HideSpellBookBackgrounds()

    -- Hook SetMinimized to re-hide backgrounds when frame is resized
    _G.hooksecurefunc(SpellBookFrame, "SetMinimized", function(self)
        HideSpellBookBackgrounds()
        -- Re-skin all items after layout change
        _G.C_Timer.After(0.1, function() SkinAllSpellBookItems() end)
    end)

    -- Hook the parent frame's SetMinimized as well
    _G.hooksecurefunc(PlayerSpellsFrame, "SetMinimized", function(self)
        HideSpellBookBackgrounds()
        HidePagedSpellsBackgrounds()
        -- Re-skin all items after layout change
        _G.C_Timer.After(0.1, function() SkinAllSpellBookItems() end)
    end)

    -- Hide help button
    if SpellBookFrame.HelpPlateButton then SpellBookFrame.HelpPlateButton:Hide() end

    Skin.SearchBoxTemplate(SpellBookFrame.SearchBox)
    Skin.DropdownButton(SpellBookFrame.SettingsDropdown)

    for i = 1, 3 do
        local tab = select(i, SpellBookFrame.CategoryTabSystem:GetChildren())
        Skin.PlayerSpellsFrameTabTemplate(tab)
    end

    Skin.PlayerSpellsButtonTemplate(SpellBookFrame.AssistedCombatRotationSpellFrame.Button)

    -- Skin SpellBookItem frames as they're created/updated
    _G.hooksecurefunc(SpellBookFrame.PagedSpellsFrame, "SetDataProvider", function()
        _G.C_Timer.After(0.05, function() SkinAllSpellBookItems() end)
    end)
    _G.hooksecurefunc(SpellBookFrame, "UpdateDisplayedSpells", function()
        _G.C_Timer.After(0.05, function() SkinAllSpellBookItems() end)
    end)
    _G.hooksecurefunc(SpellBookFrame, "OnPagedSpellsUpdate", function()
        _G.C_Timer.After(0.05, function() SkinAllSpellBookItems() end)
    end)
    _G.hooksecurefunc(SpellBookFrame, "UpdateAllSpellData", function()
        _G.C_Timer.After(0.1, function() SkinAllSpellBookItems() end)
    end)

    -- Hide backgrounds initially
    HidePagedSpellsBackgrounds()

    -- Hook the paging controls to re-skin when pages change
    _G.hooksecurefunc(PagingControls, "SetCurrentPage", function()
        _G.C_Timer.After(0.1, function()
            SkinAllSpellBookItems()
            HidePagedSpellsBackgrounds()
        end)
    end)

    -- Hook the frame show to ensure skinning persists
    SpellBookFrame:HookScript("OnShow", function()
        HideSpellBookBackgrounds()
        HidePagedSpellsBackgrounds()
        -- Multiple delayed attempts to ensure frames are created and skinned
        _G.C_Timer.After(0.1, function() SkinAllSpellBookItems() end)
        _G.C_Timer.After(0.3, function() SkinAllSpellBookItems() end)
        _G.C_Timer.After(0.5, function() SkinAllSpellBookItems() end)
    end)

    -- Skin immediately on load if the frame is already visible
    if SpellBookFrame:IsVisible() then
        HideSpellBookBackgrounds()
        HidePagedSpellsBackgrounds()
        _G.C_Timer.After(0.2, function() SkinAllSpellBookItems() end)
        _G.C_Timer.After(0.4, function() SkinAllSpellBookItems() end)
    end

    -- Create a continuous monitor to keep hiding the stripes and ensure skinning
    SpellBookFrame:HookScript("OnUpdate", function(self, elapsed)
        if not self._auroraUpdateTimer then
            self._auroraUpdateTimer = 0
        end
        self._auroraUpdateTimer = self._auroraUpdateTimer + elapsed

        -- Check every 0.5 seconds
        if self._auroraUpdateTimer >= 0.5 then
            self._auroraUpdateTimer = 0
            HidePagedSpellsBackgrounds()

            -- Also check if any frames need skinning
            for _, frame in PagedSpellsFrame:EnumerateFrames() do
                if frame.Button then
                    local button = frame.Button
                    -- Re-skin if the backdrop is missing
                    if not button:GetBackdrop() then
                        button._auroraSkinned = nil
                        frame._auroraSkinned = nil
                        Hook.SkinSpellBookItem(frame)
                    end

                    -- Always re-hide these elements
                    if button.BorderSheen then
                        button.BorderSheen:Hide()
                        button.BorderSheen:SetAlpha(0)
                    end
                    if button.BorderSheenMask then
                        button.BorderSheenMask:Hide()
                    end
                    if button.FxModelScene then
                        button.FxModelScene:Hide()
                        button.FxModelScene:SetAlpha(0)
                    end
                end
            end
        end
    end)

    Skin.NavButtonPrevious(PagingControls.PrevPageButton)
    Skin.NavButtonNext(PagingControls.NextPageButton)
end
