## [12.0.1.23] ##
### Fixed ###
  * fix: call GameTooltip_AddWidgetSet via securecallfunction to prevent secret layoutIndex taint on delve tooltip hide
  * fix: removed taint from titleFramePool
  * fix: AdventureMapFrame nil error by hooking AdventureMapMixin:OnLoad for pool wrap


## [12.0.1.22] ##
### Fixed ###
  * fix: race condition in VisitHouse
  * fix: protect against AuroraConfig being nil on embedded Aurora


## [12.0.1.21] ##
### Added ###
  * add: skins for Blizzard_CovenantCallings, Blizzard_DelvesDifficultyPicker, Blizzard_HousingControls, Blizzard_HousingTemplates, and PVP match results

### Changed ###
  * chg: expand pooled-frame skinning across housing dashboard rewards, weekly rewards extra items, adventure map widgets, quest map frames, queue status entries, chat config tabs, campaign headers, and transmog collection/set buttons
  * chg: consolidate pooled frame acquisition helpers into Util.WrapPoolAcquire and remove the obsolete WardrobeOutfits shim
  * chg: stop touching CommunitiesListEntryTemplate buttons at runtime to keep Communities skinning combat-safe

### Fixed ###
  * fix: taint-safe tooltip status/progress bar skinning and securecallfunction wrapping for DefaultWidgetLayout to avoid UIWidget secret-number layout errors (WoWUIBugs[#811])
  * fix: replace SetTooltipMoney with GetCoinTextureString to avoid MoneyFrame secret-number taint in tooltips (WoWUIBugs[#801])
  * fix: remove taint-unsafe ChannelRoster skinning that could break voice activity notifications
  * fix: make VehicleLeaveButton and TaintSafeUIPanelButtonTemplate skinning safe, and align auxiliary/zone ability cooldown overlays
  * fix: follow wardrobe custom set renames and guard campaign header/map canvas edge cases


## [12.0.1.20] ##
### Added ###
  * add: GUI toggles for character sheet, objective tracker, and talent background skins ([#151], [#158], [#160])
  * add: Color.panelBg constant and unified panel background colors ([#155])
  * add: SetSize clamping hook to crafting order tabs ([#167])
  * add: config and compatibility foundations ([#151], [#158], [#160], [#167])

### Changed ###
  * chg: gate character sheet skin on config toggle ([#151])
  * chg: gate objective tracker skin on config toggle ([#158])
  * chg: gate talent background hiding on config toggle ([#160])
  * chg: clamp PlayerChoice frame to screen bounds ([#164])
  * chg: reduce border width on Achievement and Loot frames ([#157])
  * chg: talentArtBackground defaults to true


## [12.0.1.19] ##
### Changed ###
  * chg: Add taint-safe frame skinning for high-risk protected-function frames (ItemUpgrade, ItemInteraction, Scrapping, AzeriteEssence, AzeriteUI)
  * chg: call Base.CropIcon(texture) without the parent argument to avoid tainting button geometry

### Fixed ###
  * fix: nil texture name crash in ClubFinder role icons and SetTexture assertion
  * fix: move CUSTOM_CLASS_COLORS early-return guard below private definitions so they're always available to host addons
  * fix: duplicate scale message on login in dev mode
  * fix: remove GetUnscaledFrameRect override that tainted GameMenu secure callback path [#166]
  * fix: taint-safe replacement for GameTooltip_AddWidgetSet in SharedTooltipTemplates.lua
  * fix: taint-safe status bar skinning to prevent OverlayPlayerCastingBarFrame taint propagating into action bar secure execution path


## [12.0.1.18] ##
### Changed ###
  * chg: stop aroura from doing any scaling when a host addon is handling scaling..


## [12.0.1.17] ##
### Fixed ###
  * fix: UIWidgetContainerMixin is tainting again
  * fix: replace GameTooltip_InsertFrame to avoid taint
  * fix: replaced $$$$%%%%$$$$$ to just #'s


## [12.0.1.16] ##
### Added ###
  * add: configurable GC tuning modes (smooth / default / combat-pause) to reduce microstutter — selectable in Aurora settings UI
  * add: object pooling for Color objects and backdrop tables, plus a reusable NineSlice layout, to eliminate per-frame table allocations feeding GC pressure
  * add: GC settings UI available in both Aurora standalone config and when used with other addons


## [12.0.1.15] ##
### Fixed ###
  * fix: attempt to fix potentional stutter issues when using large amount of memory.. GC is an issue
  * fix: taint safe skinning of  LFGPVP Join Battle button..
  * fix: taint-safe Blizzard_Communities skin — remove FrameTypeButton/CreateTexture/SetBackdrop from list entries and ScrollBox, guard UpdatePresence with InCombatLockdown()
  * fix: more attempts of fixing taints in tables for widgets


## [12.0.1.14] ##
### Fixed ###
  * fix: attempt to fix [#149]
  * fix: another attempt on uiwidgets fixes


## [12.0.1.13] ##
### Added ###
  * add: skinning of VehicleLeaveButton [#125]

### Fixed ###
  * fix: PlayerChoice frames being too high (Worldsoul Memories) [#156]
  * fix: Tradeskills screen with addon TradeSkillFluxCapacitor buttons out of bonds [#154]
  * fix: skin of custom tabs in QuestMapFrame.... and removed border from Tabs
  * fix: VehicleLeaveButton skinning [#125]


## [12.0.1.12] ##
### Fixed ###
  * fix: Widget containers parented to a GameTooltip must NOT be skinned.
  * chg: somewhat taint safe Blizzard_WorldMap -- until we allow it to be moved...
  * fix: QuestMapFrame Tabs to be skinned and not repositioned..
  * fix: more taint fixes for tooltips
  * fix: trying to make GameTooltip taint safe


## [12.0.1.11] ##
### Fixed ###
  * fix: Revert GetUnscaledFrameRect global replacement — overwriting this global taints every LayoutFrame call, causing massive CooldownViewer combat taint.

## [12.0.1.10] ##
### Fixed ###
  * fix: Protect GetUnscaledFrameRect against secret (tainted) values from GetScaledRect.
  * fix: ADDON_LOADED contaminates the execution context that feeds into the action bar initialization chain.

## [12.0.1.9] ##
### Added ###
  * add: skin for Blizzard_Transmog
  * add: three new reusable Skin.* functions to SharedUIPanelTemplates.lua: Skin.InputBoxNineSliceTemplate, Skin.InputBoxInstructionsNineSliceTemplate and Skin.SearchBoxNineSliceTemplate

### Changed ###
  * chg: cleaned up Blizzard_Communities
  * chg: Replaced deprecated calls with current API in AdventureMap skin.

### Fixed ###
  * fix: another taint in communitiesListScrollBox
  * fix: only hide ScrollBar borders when they exist
  * fix: safeguarding possible taints from in-combat issues
  * fix: replacing more out of date calls
  * fix: deprecated ui calls


## [12.0.1.8] ##
### Fixed ###
  * fix: possible "Texture:SetTextCoord(): Cannot set tex coords when texture has mask" error
  * fix: Aurora.test loot windows and roll behavior
  * fix: additional Aurora Test Loot fixes
  * fix: update "Running on" UI information
  * fix: Blizzard_BlackMarketUI and gfx crash


## [12.0.1.7] ##
### Added ###
  * add: Blizzard_HousingDashboard skin
  * add: skin for EventToastManager

### Fixed ###
  * fix: another tain in UIWidgets
  * fix: hooking of alerts
  * fix: for uiscale
  * fix: random taints
  * fix: uiScale taints
  * fix: error in Blizzard_CompactRaidFrames
  * fix: updates to Blizzard_HousingDashboard


## [12.0.1.6] ##
### Fixed ###
  * fix: skinning of BankFrame
  * fix: skins for PVEFrame tabs
  * fix: Blizzard_AddOnList - skinning AddonList entries
  * fix: skin - replace removed convertToGroup/convertToRaid with new settings button in CompactRaidFrameManager
  * fix: removed dead code from GossipFrame
  * fix: AlertFrameSystem - updated to cover all 31 alert systems (up from 8)
  * fix: safeguard Util.Mixin
  * fix: RecruitAFriendRewardsFrame.rewardPool can no longer use ObjectPoolMixin
  * fix: ZoneAbilityFrameTemplate
  * fix: replacement of dead Hook.ObjectPoolMixin with proper acquires
  * fix: removed deprecated Wardrobe code from Collections
  * fix: ArchaeologyUI fixes
  * fix: skinning of AchievementUI was incomplete
  * fix: cleaned up deprecated code in Blizzard_ArchaeologyUI
  * fix: Blizzard_TimeManager to no longer use deprecated APIs
  * fix: skin StopwatchResetButton/StopwatchPlayPauseButton from Blizzard_TimeManager
  * fix: SpecificScrollBox taint
  * fix: LFD/LFG/LFR fixes for Frames/RaidFinder
  * fix: partly fixed taint bug in the Blizzard_Communities - Guild Finder
  * fix: instanceButton gets garbled by DropIcon
  * fix: updated ObjectiveTracker for WOW11+
  * fix: Blizzard_StaticPopup_Game_GameDialog updated for WOW12
  * fix: Blizzard_ActionBarController updated for wow12
  * fix: updated OrderHallUI for wow12
  * fix: Blizzard_AuctionHouseUI for wow12
  * fix: updated Blizzard_Collections for wow12
  * fix: updated Blizzard_Collections ToggleDynamicFlightFlyoutButton
  * fix: LFGList menus
  * fix: added fixes to FriendsFrame

### Changed ###
  * chg: update for wow12 compatibility
  * chg: cleanup deprecated compatibility API from deprecated.lua
  * chg: cleaned up Blizzard_UIPanels_Game QuestMapFrame

### Removed ###
  * removed: Hook.ObjectPoolMixin removed in 11.0.0 (private API), no replacement
  * removed: Blizzard_SharedXMLBase\Pools.lua - dead code
  * removed: unused and outdated code from Blizzard_Calendar

## [12.0.1.5] ##
### Added ###
  * add: skinning Blizzard_Professions
  * add: skinning of all Blizzard_PlayerSpells panels
  * add: skinning of PlayerChoice

### Fixed ###
  * fix: arrow down on dropdown buttons
  * fix: skinned Blizzard_ProffesionsBook
  * fix: don't skin CommunitiesList ScrollBox to prevent SetAvatarTexture taint
  * fix: backdrops and playchoice fixes
  * fix: skinning of all Blizzard_PlayerSpells panels
  * fix: SpellBookFrame skinned properly
  * fix: skinning of PlayerChoice

### Removed ###
  * removed: Blizzard_PlayerSpellsFrame.lua duplicates Blizzard_PlayerSpells.lua

## [12.0.1.4] ##
### Fixed ###
  * fix: use SetAlpha(0) instead of Hide() on LFG InfoBackground
  * fix: Lua error ui widget [#146]
  * fix: Error on certain mouseovers that impacts mouseover tooltips afterwards [#147]
  * fix: quit catch-up button doesn't show up [#148]
  * fix: fixed error "calling 'SetAlpha' on bad self" when nameplate widget containers are registered with pooled/recycled frames (Blizzard_UIWidgets) [#139]
  * fix: isMidnight starts with 12.0.0

### Changed ###
  * chg: remove isPatch as it is no longer used


## [12.0.1.3] ##

** wrongly tagged **

## [12.0.1.2] ##
### Fixed ###
  * fix: Protect from calling GetStatusBarTexture on invalid objects
  * fix(aurora): guard backdrop setup on forbidden/invalid frames to prevent NineSlice CreateTexture crashes in UIWidgets/nameplates
  * fix: Updated DeathRecap skin for WoW 12 API changes
  * fix: Wrapped debug name handling to safely process tainted/secret strings from WoW API values


### Changed ###
  * chg: Added Blizzard_PlayerSpells skinning and follow-up cleanup
  * chg: Updated Aurora options menu
  * chg: Updated updatexmls.py for WoW 12 XML changes
  * chg: Added configuration management system, color/highlight management, theme/frame processing, and configuration UI
  * chg: Integrated analytics/external systems and finalized integration polish
  * chore: linting updates


## [12.0.1.1] ##
### Fixed ###
  * fix: Added a nil check to the CropIcon function in api.lua. Gethe/Aurora#145
  * chg: prevents Aurora from interfering with Chonky Character Sheet's modifications to the character frame Gethe/Aurora#142
  * fix(aurora): apply proper Aurora styling to game menu buttons Gethe/Aurora#143
  * chg: Cleaned up ChatFrame
  * fix(aurora): sanitize chat sender names to avoid secret-string taint
  * fix(aurora): guard UIWidget debug name calls against tainted frames
  * fix: crash path in the chat bubble skin.
  * fix: prevents secret-value violations in chatbubbles


## [12.0.1.0] ##
### Fixed ###
  * chg: Hook_SetStatusBarTexture now uses pcall when indexing private.assetColors (prevents protected/secret-index error)
  * chg: fix 12.0.1 tables now being secret
  * chg: combat-safeMultiActionBar skinning so the action bar buttons are only skinned out of combat


## [12.0.0.2] ##
### Fixed ###
  * chg: fix hooking of SetPortraitToTexture and BuildIconArray if they exist
  * chg: avoid passing secret widgetSizeSetting into SetWidth.
  * fix: chatframe errors in raid


## [12.0.0.1] ##
### Fixed ###
  * chg: intial EventsFrame list setup (intial idea found from Wetxius/ShestakUI)
  * chg: fixes to GameMenu to not taint shop
  * chg; updates to PVEFrame and Blizzard_PVPUI
  * chg: updated Blizzard_EncounterJournal
  * chg: only skin FrameTypeButton SetNormalTexture when SetNormalTexture exists
  * chg: skin EncounterJournalJourneysTab
  * fix: DressUpFrame fixes for wow12
  * chg: skin TutorialsFrame.Contents.StartButton


## [12.0.0.0] ##
### Fixed ###
  * fix: added back removed Skin.FrameTypeScrollBarButton ...
  * chg: updated AddOns_Mainline.xml file
  * fix: removed some references to F.Reskin* (deprecated code) with newer Skin.. for BlackMarketFrame
  * chg: SetsTransmogFrame, WardrobeFrame and WardrobeTransmogFrame removed - disabled code for now
  * fix: LFGRoleButtonTemplate missing Button - catch error
  * chg: remove old debug messages left in the codebase
  * fix: Aurora AddOn Config window fix and /slashcmd fix
  * chg: ChatEdit_UpdateHeader is now ChatFrameEditBoxMixinUpdateHeader so renaming functions
  * beta: wrappers to make things run in beta
  * chore: toc update for beta


## Detailed Changes ##
[Unreleased]: https://github.com/Gethe/Aurora/compare/main...develop
[12.0.1.23]: https://github.com/Gethe/Aurora/compare/12.0.1.22...12.0.1.23
[12.0.1.22]: https://github.com/Gethe/Aurora/compare/12.0.1.21...12.0.1.22
[12.0.1.21]: https://github.com/Gethe/Aurora/compare/12.0.1.20...12.0.1.21
[12.0.1.20]: https://github.com/Gethe/Aurora/compare/12.0.1.19...12.0.1.20
[12.0.1.19]: https://github.com/Gethe/Aurora/compare/12.0.1.18...12.0.1.19
[12.0.1.18]: https://github.com/Gethe/Aurora/compare/12.0.1.17...12.0.1.18
[12.0.1.17]: https://github.com/Gethe/Aurora/compare/12.0.1.16...12.0.1.17
[12.0.1.16]: https://github.com/Gethe/Aurora/compare/12.0.1.15...12.0.1.16
[12.0.1.15]: https://github.com/Gethe/Aurora/compare/12.0.1.14...12.0.1.15
[12.0.1.14]: https://github.com/Gethe/Aurora/compare/12.0.1.13...12.0.1.14
[12.0.1.13]: https://github.com/Gethe/Aurora/compare/12.0.1.12...12.0.1.13
[12.0.1.12]: https://github.com/Gethe/Aurora/compare/12.0.1.11...12.0.1.12
[12.0.1.11]: https://github.com/Gethe/Aurora/compare/12.0.1.10...12.0.1.11
[12.0.1.10]: https://github.com/Gethe/Aurora/compare/12.0.1.9...12.0.1.10
[12.0.1.9]: https://github.com/Gethe/Aurora/compare/12.0.1.8...12.0.1.9
[12.0.1.8]: https://github.com/Gethe/Aurora/compare/12.0.1.7...12.0.1.8
[12.0.1.7]: https://github.com/Gethe/Aurora/compare/12.0.1.6...12.0.1.7
[12.0.1.6]: https://github.com/Gethe/Aurora/compare/12.0.1.5...12.0.1.6
[12.0.1.5]: https://github.com/Gethe/Aurora/compare/12.0.1.4...12.0.1.5
[12.0.1.4]: https://github.com/Gethe/Aurora/compare/12.0.1.3...12.0.1.4
[12.0.1.3]: https://github.com/Gethe/Aurora/compare/12.0.1.2...12.0.1.3
[12.0.1.2]: https://github.com/Gethe/Aurora/compare/12.0.1.1...12.0.1.2
[12.0.1.1]: https://github.com/Gethe/Aurora/compare/12.0.1.0...12.0.1.1
[12.0.1.0]: https://github.com/Gethe/Aurora/compare/12.0.0.2...12.0.1.0
[12.0.0.2]: https://github.com/Gethe/Aurora/compare/12.0.0.1...12.0.0.2
[12.0.0.1]: https://github.com/Gethe/Aurora/compare/12.0.0.0...12.0.0.1
[12.0.0.0]: https://github.com/Gethe/Aurora/compare/11.2.7.2...12.0.0.0
