## [11.2.7.2] ##
### Fixed ###
  * chg: moved from NUM_CHAT_WINDOWS to Constants.ChatFrameConstants.MaxChatWindows

## [11.2.7.1] ##
### Fixed ###
  * chg: MainMenuBar replaced by MainActionBar
  * fix: channel editbox info when chatType is CHANNEL
  * chg: ScrollBox.view.poolCollection replaced by ScrollUpdate hooks

## [11.2.7.0] ##
### Fixed ###
  * chg: renamed toc file to support _optional versions..
  * chore: toc bump

## [11.2.5.2] ##
### Fixed ###
  * chg: fix a missing _G in _G.AddFriendInfoFrame.ContinueButton
  * chg: fix skinning of checkboxes in Blizzard_Communities
  * chg: Blizzard_PlayerChoice skin close button
  * chore: cleanup
  * chg: fixup on DressUpFrame skin
  * chg: fix skin of questslog of questmap
  * chore: removed some FIXLATERs that have been fixed or just needed cleanup
  * del: removed noisy debug message
  * chg: fix skin on UnitPopUpVoiceLevels
  * chg: removed some FIXLATER tags
  * chg: fix for chatconfig checkboxes
  * chg: Aurora handling of private.FrameXML "FriendsFrame" restored
  * chg: more cleanup fixes for FriendsFrame
  * chg: make UIPanelButtonTemplate also work with never buttons
  * chg: IgnoreListFrame to IgnoreListWindow
  * fix: C_ItemSocketInfo fix for Sockets

## [11.2.5.1] ##
### Fixed ###
  * chg: fixed skinning of sockets which broke with 11.2.5
  * chg: removed debug messages from Blizzard_UIWidgets which broke skinning of some widgets

## [11.2.5.0] ##
### Fixed ###
  * minor fixes for 11.2.5
  * add: TabSystemTemplates skin
  * del: removed unused .xml's
  * add: Blizzard_WeeklyRewards skin part 1
  * add: api - StripTextures functionality
  * chg: TokenUI fixes
  * del: removed debug messages from Blizzard_UIWidgets


## [11.2.0.6] ##
### Fixed ###
  * add: Blizzard_PlayerSpellsFrame skin - part 1
  * chg: cleaned up broken Mixins - disabled some that are now private
  * chg: removed BlizzAddOns and replaced with AddOns
  * chg: cleaned up isPatch for older versions of wow
  * chg: fix skin on ClassTrainerTrainButton from Blizzard_TrainerUI
  * chg: lints
  * chg: dev/updatexmls.py minor update of addons.
  * chg: started skinning Blizzard_ProfessionsBook
  * chg: CommunitiesListEntryMixin creates an c stack overflow somehow
  * chg: removed static arrow-down-active from FilterButton, DropdownButton and WowStyle1ArrowDropdownTemplate
  * chg: removed Blizzard_ProfessionsBook related code from Blizzard_SpellBookFrame
  * chg: QuestMapFrame - EventsTab side tab skin
  * chg: Blizzard_TokenUI should not taint anymore
  * chg: fix Blizzard_AddOnList
  * chg: work on AuctionHouseUI - missing _auroraIconBG
  * chg: replace WowScrollBoxList with WowScrollBox
  * chg: skin fix for AddOnsList


## [11.2.0.5] ##
### Fixed ###
  * fix: found rc of JoinBattleGround taint - disabled ScrollBoxList skin that does not work
  * chg: Communities sidebuttons skin fix
  * chg: Blizzards_Channel skin fix
  * fx: StaticPopup fixes based on beta feedback


## [11.2.0.4] ##
### Fixed ###
  * Lint errors
  
  
## [11.2.0.3] ##
### Fixed ###
  * chg: Aurora API Version to 11.2
  * chg: FriendsFrame adjustment
  * chg: disable Blizzard_StaticPopup\Blizzard_StaticPopup - enable Blizzard_StaticPopup_Game\GameDialog
  * chg: Blizzard_StaticPopup_Game\Mainline\StaticPopupSpecial
  * chg: removed most of the old StaticPopup code
  * chg: Enable StaticPopup2-4
  * chg: removed old StaticPopup with new Blizzard_StaticPopup_Game\GameDialog - now skinned.
  * chg: Skin EJ MonthlyActivitiesFrame
  * chg: Blizzard stopped using function(self) replaced function(dialog)


## [11.2.0.2] ##
### Fixed ###
  * add: skin for UIPanelSpellButtonFrameTemplate
  * chg: updated AlertFrameSystems
  * add: skeleton for Blizzard_Flyout
  * chg: renamed CRFManagerTooltipButtonTemplate to CRFManagerTooltipTemplate
  * chg: QuestMapFrame - skin SideTabs and MapLegendScrollFrame
  * add: Skin for Blizzard_WarbandSceneCollection in Blizzard_Collections
  * chg: add support for PVPQueueFrame.CategoryButton4
  * chg: fixed missing skins on Blizzard_Communities
  * chg: cleaned up older bugs
  * add: skin for WowStyle1ArrowDropdownTemplate
  * fix: QuestFrame skin
  * chg: Blizzard_CompactRaidFrames - code cleanup and skin fixes
  * chg: fix filter and dropdown buttons


## [11.2.0.1] ##
### Fixed ###
  * removed: F.ReskinDropDown from deprecated.lua
  * chg: Skin and code overhaul for Blizzard_Collections, Blizzard_ObjectiveTracker, Blizzard_PlayerChoice
  * chg: Skin and code overhaul for Blizzard_QueueStatusFrame, Blizzard_TimeManager, Blizzard_TokenUI
  * chg: Skin and code overhaul for Blizzard_TrainerUI, Blizzard_UIPanels_Game
  * chg:  Reagentbank is removed


## [11.2.0.0] ##
### Fixed ###
  * chg: Minor fixes for Blizzard_PVPUI skin
  * chg: Blizzard_GuildControlUI skin fixes
  * chg: Blizzard_GroupFinder skins fix
  * chg: removed some errors from Blizzard_FrameXML
  * chg: fix Blizzard_EventTrace
  * chg: cleaned up FrameXML\WardrobeOutfits.lua
  * fix: Blizzard_EncounterJournal skins
  * chg: updates to Blizzard_CompactRaidFrames skin
  * fix: Blizzard_Collections and Blizzard_Communities skins
  * chg: fix Blizzard_Calendar skins
  * fix: Skin.DropdownButton reports error only when Aurora is in dev mode. Fixed wrong dropdowns
  * fix: Blizzard_AddOnList skin
  * chg: Blizzard_ArchaeologyUI skin fix
  * chg: UIMenuTemplate was removed in 11.0.2
  * disable: SpellBookFrame skins - reimplementing as  Blizzard_SpellBookFrame
  * fix: Arrow directions are not UPPER case
  * fix: remove debug messages
  * update: changes to addon paths and updated luas missing from AddOns_Mainline.xml
  * chg: temp workaround for 11.2 errors
  * chg: fix for 11.2 BankFrame initial error...
  * removed: unused FrameXML_*.xml's
  * chg: removed some errors from Blizzard_EncounterJournal
  * chg: EJButtonTemplate now supports new texture locations.
  * chg: EncounterJournal.encounter.info.reset was removed in 11.0.2
  * chg: other changes related to C_SpecializationInfo implementation.
  * chg: GetSpecialization ->  C_SpecializationInfo.GetSpecialization
  * chg: Blizzard_VoidStorageUI removed in retail.


## [11.1.5.0] ##
### Fixed ###
  * chg: 11.1.5 toc update
  * debug: catching Arrows that were replaced in 11.1.5
  * fix: HelpPlate_GetButton was removed from 11.1.5
  * fix: removed parts of collections that was removed with 11.1.0
  * fix: workaround to catch empty textures.

## This version may contain bugs and some debug code. Please report them to the issue tracker. ##

## [11.1.0.3] ##
### Fixed ###
  * chg: Blizzard_InspectUI.lua - InspectTalentFrame has been removed
  * chg: remove unused GetPlayerStyleString TaintFix
  * add: evoker classicon to classIcons list.
  * chg: temp workaround for 11.1.0.60189 break of InputMoneyFrame
  * chg: fix skins for collection tabs 5 and 6 if they exists

## [11.1.0.2] ##
### Fixed ###
  * fix: GetSearchResultInfo now returns ActivityIDs instead of ActivityID - fixes error on LFGListSearchEntryTooltip
  * chg: disabled broken menus and dropdowns in Blizzard_AuctionHouseUI for later fix


## [11.1.0.1] ##
### Fixed ###
  * fix: disabled debug messages in AchievementUI.lua - #133


## [11.1.0.0] ##
### Fixed ###
  * chg: AchivementUI updated for post 10.0.0 and 11.0.0 - stats, categories, filter and new mixins skinned
  * chore: removed fix it comment
  * chg: remove unused code from communities
  * fix: acchievemnts search box
  * fix: skinning of RecruitAFriendRewardsFrame
  * fix: dont update scale if parentscale is 11
  * fix: QuestMapFrame working for 11.1.0
  * tmp: disabled broken kode in 11.1.0
  * chg: make certain debug code only show if aurora\dev is running


## [11.0.5.2] ##
### Fixed ###
  * fix: ItemUpgradeUI
  * chg: move UIDropDownMenuTemplate to DropdownButton
  * add:  Skin.DropdownButton to replace UIDropDownMenuTemplate
  * cleanup: remove non mainline code from setup per now. Does not fit in current model.

## [11.0.5.1] ##
### Fixed ###
  * fix: comment out another dropdown menu
  * fix: skin gamemenu
  * fix: Communities update
  * chg: restored skins on ContainerFrameBackpackTemplate
  * chg: restored parts of communities.
  * fix: TalentMicroButton replaced by ProfessionMicroButton
  * fix: GetContainerItemInfo changes in 11.x

## [11.0.5.0] ##
### Fixed ###

  * chg: worldmap updates
  * fix: #130 - /aurora did not work after patch 11.
  * chg: disable FriendsFrame code - not used by RealUI.
  * add: new metatable for BlizzAddons
  * Add: Skin/Interface/AddOns/Blizzard_GroupFinder/Mainline/LFGFrame.lua - reminder of failsafe.
  * fix: IsDebugBuild is _G
  * fix WardrobeOutfitEditFrame as _G
  * fix: add PVEFrame.tab4 to skins
  * fix: C_SpellBook is now _G.C_SpellBook
  * chore: cleaned up depcreated and unused code
  * enable: skinning for active HelpTips
  * chore: enabled code disabled for debugging
  * chore: fix comments for disabled pools

## [11.0.0.0] ##
### Fixed ###

  * Updated for The War Within
  * Many features are currently disabled while the UI is being rebuilt
  * Some skins are not applied correctly


## [10.2.7.5] ##
### Fixed ###

  * [retail] fix: workaround for #117 if user does not have authenticator
  * [retail] fix: #119 make questContrast be dark


## [10.2.7.3] ##
### Fixed ###

  * [retail] fix: luacheck


## [10.2.7.2] ##
### Fixed ###

  * [retail] fix: MainMenuBar no longer have the frame Background - this is now a layer. #113
  * [retail] chg: as part of fix for #113 - tmp disabled skinning of backpack icon. It goes invisible
  * [retail] fix: a missing C_Container


## [10.2.7.1] ##
### Fixed ###

  * [retail] fix: Another LFGList layer change - missed previously - #116
  * [retail] fix: GetPlayerStyleString Taint
  * [retail] add: support for groupfinder-icon-role-micro


## [10.2.7.0] ##
### Fixed ###

  * [classic] disabled non-mainline builds while rebuilding the structure
  * [retail] disable: hooksecurefunc FriendsFrame - this is no longer a function
  * [retail] fix: changes to LoadWith and toc - Blizzard fubard this one
  * [retail] fix: LFGList is changed - added another layer
  * [retail] disable petstable broken code - add a error on staticpopups.
  * [general] chore: resync all Addons and FramleXML xml files. Cata is added..
  * [retail] chore: resync Skin/Interface/FrameXML/FrameXML_WoWLabs.xml
  * [retail] fix: missing brackets
  * [retail] chore: sync with gethe/wow-ui-source


## [10.2.6.1] ##
### Fixed ###

  * [retail] Remove LFGListUtil_SetSearchEntryTooltip debug print spam
  * [retail] Fixed some missing _G references and cleared out luacheck warnings

## [10.2.6.0] ##
### Fixed ###

  * [retail] LFGListUtil_SetSearchEntryTooltip updates
  * [retail] Fix for 10.2.6 API changes C_Item


## [10.2.5.1] ##
### Fixed ###

  * [retail] AuctionHouseItemListMixin no longer has the functions OnScrollBoxRangeChanged or UpdateSelectionHighlights


## [10.2.5.0] ##
### Fixed ###

  * [retail] ColorPicker changes according to 10.2.5
  * [retail] LFG and PVP Groupfinder cleanups
  * [retail] license update for 2024


## [10.2.0.0] ##
### Fixed ###

  * [retail] Some new status bars in raids don't have a texture?
  * [retail] Addon management functions moved to the C_AddOns namespace.
  * [retail] Error on AddOn list in game. AddonList now uses ScrollBox.
  * [retail] Change of OrbitCamera to ModelScene.ControlFrame  

### Disabled ###
  * [retail] PlayerChoiceFrame while fixing this


## [10.1.7.0] ##
### Fixed ###

  * [retail] Fixed for Patch 10.1.7


## [10.1.5.1] ##
### Fixed ###

  * [retail] Error when opening the battlefield map
  * [retail] Action bar error on login


## [10.1.5.0] ##
### Fixed ###

  * [retail] Fixed for Patch 10.1.5

## [10.0.2.2] ##
### Fixed ###

  * [retail] Error when scenario stage has a progress bar
  * [retail] Covenant sanctum was missing background
  * [retail] Error when searching LFG
  * [wrath] Error when inspecting other players
  * [wrath] Error for scribes with Northrend Inscription


## [10.0.2.1] ##
### Fixed ###

  * Error with loot history
  * [retail] Various small fixes for Dragonflight


## [10.0.2.0] ##
### Fixed ###

  * More fixes for Dragonflight


## [10.0.0.0] ##
### Fixed ###

  * Updated for Dragonflight


## [9.2.7.0] ##
### Added ###

  * [retail] Basic support for Dragonflight (WIP)

### Fixed ###

  * Money test for trade targets was misplaced
  * [retail] Achievement borders wer not skinned
  * [wrath] Various fixes for Wrath Classic


## [9.2.5.0] ##
### Changed ###

  * [retail] Updated mail skin
  * [classic] Updated interface options

### Fixed ###

  * [retail] Various fixes for 9.2.5
  * [retail] Error when using the map before choosing a Covenant
  * [retail] Error when using Cypher gear


## [9.2.0.0] ##
### Changed ###

  * [retail] Updated guild bank skin

### Fixed ###

  * The "At War" check box in the reputations frame was out of place
  * The reputation detail frame had an out of place background
  * [retail] Various fixes for 9.2.0
  * [retail] Error when changing guild bank permissions
  * [retail] Error when opening BFA island queue frame
  * [classic] An extra texture was visible when at max level and not tracking any reputations
  * [classic] Error when mousing over the skill detail status bar
  * [classic] Spellbook tabs would not react to mouse input
  * [tbc] LFG skin was broken
  * [tbc] The character title dropdown had a misaligned backdrop


## [9.1.5.0] ##
### Added ###

  * [tbc] LFG frame skin

### Changed ###

  * Updates for recent patch compatibility
  * Tweak class and spec backdrops
  * [retail] Update item upgrade frame
  * [retail] Tweak create channel popup
  * [retail] Update dress up frame
  * [classic] Tweak chat frame skin
  * [tbc] Update inspect frame

### Fixed ###

  * Various tooltip issues
  * [retail] Browse groups button was not skinned in LFG list
  * [retail] Channel headers in the chat channels frame were not skinned
  * [retail] PvP ready popup background was not aligned
  * [classic] Bag frame background would not update after opening the keyring
  * [classic] Errors when opening the talent frame


## [9.0.5.0] ##
### Added ###

  * [tbc] Support for BC Classic
  * [classic] Items in the loot frame now have quality colored borders
  * Skin for upgraded event trace frame

### Fixed ###

  * Loot frame misplaced when set under mouse
  * [classic] Error when opening Beast Training
  * [retail] Call to Arms reward role icons were misaligned



## [9.0.2.1] ##
### Added ###

  * [retail] Campaign Recap
  * [retail] Torghast Level Picker
  * [retail] Anima Diversion

### Changed ###

  * [retail] Tweak campaign headers

### Fixed ###

  * [retail] Error when clicking optional reagents
  * [retail] Achievement search preview backdrop was broken
  * [retail] Adventure rewards weren't skinned



## [9.0.2.0] ##
### Fixed ###

  * [retail] SSAO graphics option was not skinned
  * [retail] The dungeon ready popup had two backdrops
  * [retail] The world map's close button was out of place when maximized
  * [retail] Intermittent errors when opening the talent frame



## [9.0.1.7] - 2020-12-07 ##
### Added ###

  * [retail] Skinned Maw Buffs

### Changed ###

  * [retail] Updated Warlords garrison skin
  * Tweaked mail inbox items to not be so close to the page buttons
  * Updated /etrace dev tool skin

### Fixed ###

  * [classic] Error while exploring the plaguelands
  * [retail] Error when completing an LFG dungeon
  * [retail] Campaign quest progress bars were not skinned
  * [retail] Error when opening PvP frame
  * [retail] Scouting maps were unusable with high frame opacity
  * [retail] Dressup frame borders were not skinned
  * [retail] Barber shop buttons would sometimes be unskinned
  * [retail] Spell quest rewards had a dark colored header



## [9.0.1.6] - 2020-11-16 ##
### Added ###

  * [retail] Skinned Covenant Renown
  * Skinned RatingMenuFrame

### Changed ###

  * [retail] Updated gossip frame friendship status bar

### Fixed ###

  * Various bugs with backdrops
  * [retail] Quest tracker progress bars weren't skinned
  * [retail] Empty mission spots had the highlight out of place
  * [retail] Help tip arrows would sometimes be placed wrong
  * [retail] Various bugs from 9.0.2



## [9.0.1.5] - 2020-10-25 ##
### Changed ###

  * Tweaked font for chat bubble names

### Fixed ###

  * Error when loot skin is disabled
  * Chat bubble didn't work
  * [retail] Out of place borders on LFG list refresh buttons
  * [retail] Queue status frame wasn't skinned properly
  * [retail] Void Storage item background didn't display properly
  * [retail] Optional reagents icons would get stretched when adding an item
  * [retail] Out of place borders on the PvP category buttons
  * [retail] Sell item icon had the wrong texture
  * [retail] Volume sliders were white
  * [retail] Missed some textures on the spec frame
  * [retail] Display bug with quest detail
  * [retail] World quest header wasn't skinned
  * [retail] Display bug with the calendar
  * [retail] Error when entering a pet battle



## [9.0.1.4] - 2020-10-14 ##
### Added ###

  * [retail] New player guide sign-up skin

### Changed ###

  * [retail] Updated barber shop skin

### Fixed ###

  * [retail] Chat frame had an extra backdrop
  * [retail] Gossip options were black



## [9.0.1.3] - 2020-10-12 ##
### Fixed ###

  * [retail] Some dropdown menus did not use the configured frame alpha
  * [retail] Error when bounty tutorial is shown



## [9.0.1.2] - 2020-10-10 ##
### Fixed ###

  * [retail] Error when entering a pet battle



## [9.0.1.1] - 2020-10-10 ##
### Fixed ###

  * Core files missing in the package



## [9.0.1.0] - 2020-10-09 ##
### Added ###

  * [classic] CraftUI skin
  * [classic] Honor frame skin
  * [retail] Auto-quest objective popups skin

### Changed ###

  * [retail] Updated inspect frame
  * [retail] Tweaked hunter pet stable

### Fixed ###

  * [classic] Display bugs in dropdown menu
  * [retail] Display bugs with the AH favorite button
  * [retail] Error with rep frame
  * [retail] Gossip text overlapping friendship bar
  * [retail] Display bugs with achievement alert



## [8.3.0.8] - 2020-07-18 ##
### Added ###

  * Basic compatibility for Shadowlands

### Changed ###

  * Who list search box is now more visible
  * The archeology progress bar now has dynamic ticks

### Fixed ###

  * [classic] Fixed errors when the loot frame shows
  * [classic] Gossip frame options had the wrong colors
  * [classic] Missed some textures in the friends frame
  * [classic] SetTextColor error when in a raid
  * Error with some dropdown frames
  * Scroll list error in AH
  * Tooltip skin toggle didn't work
  * Font size was still set even when the font skin is disabled
  * Backpack money frame border was positioned wrong



## [8.3.0.7] - 2020-06-10 ##
### Fixed ###

  * Macro icon picker would obscure icons if too opaque
  * Addon list check boxes were not shaded properly
  * A few frames for the club finder were not skinned



## [8.3.0.6] - 2020-04-30 ##
### Changed ###

  * The default highlight color is now blue
  * Darkened the cast bar and main menu tracking bars
  * Minor tweak to item button borders

### Fixed ###

  * PvP results frame sill had a border around the "X" button
  * Queue status role icons were not spaced out well
  * Highlight textures for some expand buttons would still show
  * Tracking bars were still skinned if the main menu skin is disabled
  * `classic` Errors when opening the friends frame



## [8.3.0.5] - 2020-03-26 ##
### Added ###

  * Community invite skin
  * Additional action bars

### Fixed ###

  * Error when opening communities UI
  * Display bug with the send mail money border
  * Button highlights when disabled
  * Friends tooltip is now skinned again



## [8.3.0.4] - 2020-03-06 ##
### Changed ###

  * `classic` Improved keyring skin

### Fixed ###

  * Error in raid UI
  * Error when using nameplates in a raid
  * AH sell item did not have a border



## [8.3.0.3] - 2020-02-17 ##
### Changed ###

  * Improved auto complete skin

### Fixed ###

  * Chat minimize button had wrong offsets
  * Error with some older skins



## [8.3.0.2] - 2020-02-12 ##
### Added ###

  * Classic support

### Changed ###

  * More custom class color overrides across the UI
  * Various minor tweaks

### Fixed ###

  * Guild news filter options weren't skinned
  * Auction House buy dialog wasn't skinned
  * World Quest tracker heading wasn't skinned
  * CUSTOM_CLASS_COLORS callbacks were not always called when changed



## [8.3.0.1] - 2020-01-18 ##
### Fixed ###

  * Boss buttons in the Encounter Journal would not un-highlight
  * Encounter Journal loot buttons had an out of bounds overlay
  * The wardrobe outfits dropdown menu was too short



## [8.3.0.0] - 2020-01-14 ##
### Added ###

  * Flight Map
  * Item Interaction (used to cleanse Corrupted Items)
  * LFG invite popup

### Changed ###

  * Updates for 8.3.0
  * Updated group finder skin
  * Updated tradeskill skin
  * Buttons with white textures now highlight from the background instead of the white texture (close, scroll bar)
  * Tweak item scrapping UI

### Fixed ###

  * Error when opening Communities
  * BNet broadcast would not send
  * Error when viewing sets in adventure journal
  * The conquest progress bar was not colored
  * Error when opening azerite respec UI

[Unreleased]: https://github.com/Gethe/Aurora/compare/master...develop
[10.1.5.1]: https://github.com/Haleth/Aurora/compare/10.1.5.0...10.1.5.1
[10.1.5.0]: https://github.com/Haleth/Aurora/compare/10.0.2.2...10.1.5.0
[10.0.2.2]: https://github.com/Haleth/Aurora/compare/10.0.2.1...10.0.2.2
[10.0.2.1]: https://github.com/Gethe/Aurora/compare/10.0.2.0...10.0.2.1
[10.0.2.0]: https://github.com/Gethe/Aurora/compare/10.0.0.0...10.0.2.0
[10.0.0.0]: https://github.com/Gethe/Aurora/compare/9.2.7.0...10.0.0.0
[9.2.7.0]: https://github.com/Gethe/Aurora/compare/9.2.5.0...9.2.7.0
[9.2.5.0]: https://github.com/Gethe/Aurora/compare/9.2.0.0...9.2.5.0
[9.2.0.0]: https://github.com/Gethe/Aurora/compare/9.1.5.0...9.2.0.0
[9.1.5.0]: https://github.com/Gethe/Aurora/compare/9.0.5.0...9.1.5.0
[9.0.5.0]: https://github.com/Gethe/Aurora/compare/9.0.2.1...9.0.5.0
[9.0.2.1]: https://github.com/Gethe/Aurora/compare/9.0.2.0...9.0.2.1
[9.0.2.0]: https://github.com/Gethe/Aurora/compare/9.0.1.7...9.0.2.0
[9.0.1.7]: https://github.com/Gethe/Aurora/compare/9.0.1.6...9.0.1.7
[9.0.1.6]: https://github.com/Gethe/Aurora/compare/9.0.1.5...9.0.1.6
[9.0.1.5]: https://github.com/Gethe/Aurora/compare/9.0.1.4...9.0.1.5
[9.0.1.4]: https://github.com/Gethe/Aurora/compare/9.0.1.3...9.0.1.4
[9.0.1.3]: https://github.com/Gethe/Aurora/compare/9.0.1.2...9.0.1.3
[9.0.1.2]: https://github.com/Gethe/Aurora/compare/9.0.1.1...9.0.1.2
[9.0.1.1]: https://github.com/Gethe/Aurora/compare/9.0.1.0...9.0.1.1
[9.0.1.0]: https://github.com/Gethe/Aurora/compare/8.3.0.8...9.0.1.0
[8.3.0.8]: https://github.com/Gethe/Aurora/compare/8.3.0.7...8.3.0.8
[8.3.0.7]: https://github.com/Gethe/Aurora/compare/8.3.0.6...8.3.0.7
[8.3.0.6]: https://github.com/Gethe/Aurora/compare/8.3.0.5...8.3.0.6
[8.3.0.5]: https://github.com/Gethe/Aurora/compare/8.3.0.4...8.3.0.5
[8.3.0.4]: https://github.com/Gethe/Aurora/compare/8.3.0.3...8.3.0.4
[8.3.0.3]: https://github.com/Gethe/Aurora/compare/8.3.0.2...8.3.0.3
[8.3.0.2]: https://github.com/Gethe/Aurora/compare/8.3.0.1...8.3.0.2
[8.3.0.1]: https://github.com/Gethe/Aurora/compare/8.3.0.0...8.3.0.1
[8.3.0.0]: https://github.com/Gethe/Aurora/compare/8.2.5.3...8.3.0.0
