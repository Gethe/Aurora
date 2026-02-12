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
[12.0.1.9]: https://github.com/Haleth/Aurora/compare/12.0.0.2...12.0.1.0
[12.0.0.2]: https://github.com/Haleth/Aurora/compare/12.0.0.1...12.0.0.2
[12.0.0.1]: https://github.com/Haleth/Aurora/compare/12.0.0.0...12.0.0.1
[12.0.0.0]: https://github.com/Haleth/Aurora/compare/11.2.7.2...12.0.0.0
