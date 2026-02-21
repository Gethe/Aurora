## [12.0.1.3] ##
### Fixed ###
  * fix: use SetAlpha(0) instead of Hide() on LFG InfoBackground
  * fix: Lua error ui widget [#146]
  * fix: Error on certain mouseovers that impacts mouseover tooltips afterwards [#147]
  * fix: quit catch-up button doesn't show up [#148]
  * fix: fixed error "calling 'SetAlpha' on bad self" when nameplate widget containers are registered with pooled/recycled frames (Blizzard_UIWidgets) [#139]
  * fix: isMidnight starts with 12.0.0

### Changed ###
  * chg: remove isPatch as it is no longer used


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

[Unreleased]: https://github.com/Gethe/Aurora/compare/main...develop
[12.0.1.3]: https://github.com/Haleth/Aurora/compare/12.0.1.2...12.0.1.3
[12.0.1.2]: https://github.com/Haleth/Aurora/compare/12.0.1.1...12.0.1.2
[12.0.1.1]: https://github.com/Haleth/Aurora/compare/12.0.1.0...12.0.1.1
[12.0.1.0]: https://github.com/Haleth/Aurora/compare/12.0.0.2...12.0.1.0
[12.0.0.2]: https://github.com/Haleth/Aurora/compare/12.0.0.1...12.0.0.2
[12.0.0.1]: https://github.com/Haleth/Aurora/compare/12.0.0.0...12.0.0.1
[12.0.0.0]: https://github.com/Haleth/Aurora/compare/11.2.7.2...12.0.0.0
